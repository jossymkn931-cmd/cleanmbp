*** Settings ***
Documentation    Financial assertions for the dashboard account balance.
...
...              These confirm that money actually moved, rather than that the app
...              displayed a receipt. The dashboard balance is the app's own view of
...              the ledger, so it is a weaker oracle than the core banking API, but
...              it still catches wrong amounts, missing fees and absent postings.
Library          AppiumLibrary
Library          ../libraries/money.py
Resource         ../locators/login_locators.robot


*** Variables ***
# Transfers are acknowledged as "In Processing" and settle out of band, so the
# balance is polled rather than read once.
${BALANCE_SETTLEMENT_TIMEOUT}     120s
${BALANCE_SETTLEMENT_INTERVAL}    5s


*** Keywords ***
Dashboard Balance Should Not Be Masked
    [Documentation]    Fail while the balance still shows masking asterisks.

    ${raw}=    Get Text    ${MOBILE_BALANCE_AMOUNT}
    Should Not Contain    ${raw}    *    msg=Balance is still masked: ${raw}


Reveal Dashboard Balance
    [Documentation]    Ensure the balance is unmasked. Safe to call when already
    ...                revealed, unlike tapping the eye toggle unconditionally.

    Wait Until Element Is Visible    ${MOBILE_BALANCE_AMOUNT}    timeout=30s

    ${raw}=      Get Text    ${MOBILE_BALANCE_AMOUNT}
    ${masked}=   Run Keyword And Return Status    Should Contain    ${raw}    *

    IF    ${masked}
        Click Element    ${MOBILE_BALANCE_TOGGLE}
        Wait Until Keyword Succeeds    15s    1s    Dashboard Balance Should Not Be Masked
    END


Get Dashboard Balance
    [Documentation]    Return the dashboard balance in minor units for exact comparison.

    Reveal Dashboard Balance
    ${raw}=    Get Text    ${MOBILE_BALANCE_AMOUNT}
    ${balance}=    Parse Money    ${raw}
    Log    Dashboard balance is ${raw} (${balance} minor units)
    RETURN    ${balance}


Refresh Dashboard Balance
    [Documentation]    Pull to refresh so the balance is re-fetched rather than
    ...                read from the cached value rendered before the transfer.

    Wait Until Element Is Visible    ${MOBILE_BALANCE_AMOUNT}    timeout=30s
    Swipe    start_x=540    start_y=700    end_x=540    end_y=1600    duration=400ms
    Wait Until Element Is Visible    ${MOBILE_BALANCE_AMOUNT}    timeout=30s


Dashboard Balance Delta Should Be
    [Arguments]    ${before}    ${expected_delta}
    [Documentation]    Single-shot delta check. Use the settlement keywords below
    ...                unless the posting is known to be synchronous.

    Refresh Dashboard Balance
    ${after}=    Get Dashboard Balance
    ${delta}=    Money Delta    ${before}    ${after}

    ${before_text}=    Format Money    ${before}
    ${after_text}=     Format Money    ${after}

    Money Should Be Equal    ${delta}    ${expected_delta}
    ...    Balance moved from ${before_text} to ${after_text}.


Dashboard Balance Should Settle To Debit Of
    [Arguments]    ${before}    ${expected_debit}
    [Documentation]    Confirm the account was debited by exactly the expected amount,
    ...                allowing for asynchronous settlement.

    ${expected_delta}=    Subtract Money    ${0}    ${expected_debit}
    Wait Until Keyword Succeeds
    ...    ${BALANCE_SETTLEMENT_TIMEOUT}
    ...    ${BALANCE_SETTLEMENT_INTERVAL}
    ...    Dashboard Balance Delta Should Be    ${before}    ${expected_delta}


Dashboard Balance Should Settle To Credit Of
    [Arguments]    ${before}    ${expected_credit}
    [Documentation]    Confirm the account was credited by exactly the expected amount,
    ...                allowing for asynchronous settlement.

    Wait Until Keyword Succeeds
    ...    ${BALANCE_SETTLEMENT_TIMEOUT}
    ...    ${BALANCE_SETTLEMENT_INTERVAL}
    ...    Dashboard Balance Delta Should Be    ${before}    ${expected_credit}


Dashboard Balance Should Be Unchanged
    [Arguments]    ${before}
    [Documentation]    Confirm no money moved. Used by negative tests, where a failed
    ...                or rejected transaction must leave the account untouched.

    Refresh Dashboard Balance
    ${after}=    Get Dashboard Balance
    ${delta}=    Money Delta    ${before}    ${after}

    ${before_text}=    Format Money    ${before}
    ${after_text}=     Format Money    ${after}

    Money Should Be Equal    ${delta}    ${0}
    ...    Balance should not have moved but went from ${before_text} to ${after_text}.

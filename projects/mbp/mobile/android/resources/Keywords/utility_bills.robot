*** Settings ***
Documentation    Utility bills and services payment keywords
Library          AppiumLibrary
Library          String
Resource         ../locators/pay_locators.robot
Resource         ../locators/utility_bills_locators.robot
Resource         ../locators/send_money_locators.robot


*** Keywords ***
Open Utility Bills And Services
    [Documentation]    From the dashboard, open Pay and pick Utility Bills & Services.

    Wait Until Element Is Visible    ${PAY_TILE}    timeout=60s
    Click Element    ${PAY_TILE}
    Wait Until Element Is Visible    ${PAY_UTILITY_BILLS_OPTION}    timeout=30s
    Click Element    ${PAY_UTILITY_BILLS_OPTION}
    Wait Until Element Is Visible    ${BILLER_SEARCH_PLACEHOLDER}    timeout=30s


Search And Select Biller
    [Arguments]    ${biller_name}
    [Documentation]    Search the biller directory and open the biller's form.
    ...                The search box is a label until tapped, so it is focused first.

    Wait Until Element Is Visible    ${BILLER_SEARCH_PLACEHOLDER}    timeout=30s
    Click Element    ${BILLER_SEARCH_PLACEHOLDER}
    Wait Until Element Is Visible    ${BILLER_SEARCH_INPUT}    timeout=15s
    Input Text    ${BILLER_SEARCH_INPUT}    ${biller_name}

    ${result}=    Format String    ${BILLER_RESULT}    ${biller_name}
    Wait Until Element Is Visible    ${result}    timeout=30s
    Click Element    ${result}
    Wait Until Element Is Visible    ${BILLER_ACCOUNT_NUMBER_INPUT}    timeout=30s


Selected Biller Should Be
    [Arguments]    ${biller_name}
    [Documentation]    Verify the form opened for the biller that was searched for.

    ${biller}=    Format String    ${BILLER_RESULT}    ${biller_name}
    Wait Until Element Is Visible    ${biller}    timeout=30s


Enter Biller Account Number
    [Arguments]    ${account_number}
    [Documentation]    Enter the bill account number.

    Wait Until Element Is Visible    ${BILLER_ACCOUNT_NUMBER_INPUT}    timeout=30s
    Input Text    ${BILLER_ACCOUNT_NUMBER_INPUT}    ${account_number}
    ${actual}=    Get Text    ${BILLER_ACCOUNT_NUMBER_INPUT}
    Should Be Equal    ${actual}    ${account_number}
    ...    msg=Expected the Account Number field to contain '${account_number}' but it contains '${actual}'


Select Vooma Wallet
    [Documentation]    Pay the bill from the Vooma wallet rather than a bank account.
    ...                Source of Funds opens Select Account. Switch to the Wallet tab,
    ...                pick the Vooma wallet row, then Continue.
    ...
    ...                The wallet must have enough balance. If the row shows Insufficient
    ...                Balance the radio stays unselectable and this keyword fails clearly.

    Open Source Of Funds Picker
    Click Element    ${BILLER_WALLET_TAB}
    ${wallet}=    Format String    ${BILLER_VOOMA_WALLET_OPTION}    ${VOOMA_WALLET_MASKED}
    ${wallet_row}=    Format String    ${BILLER_VOOMA_WALLET_ROW}    ${VOOMA_WALLET_MASKED}
    Wait Until Element Is Visible    ${wallet}    timeout=30s

    ${insufficient}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${BILLER_WALLET_INSUFFICIENT}
    IF    ${insufficient}
        Fail    Vooma wallet ${VOOMA_WALLET_MASKED} shows Insufficient Balance and cannot be selected. Fund the wallet then re-run.
    END

    Click Element    ${wallet_row}
    ${selected}=    Run Keyword And Return Status
    ...    Wait Until Keyword Succeeds    5s    1s    Element Attribute Should Match    ${wallet_row}    selected    true
    IF    not ${selected}
        Click Element    ${wallet}
    END

    Wait Until Element Is Visible    ${BILLER_SELECT_ACCOUNT_CONTINUE}    timeout=15s
    Click Element    ${BILLER_SELECT_ACCOUNT_CONTINUE}
    Wait Until Page Does Not Contain Element    ${BILLER_WALLET_TAB}    timeout=15s


Open Source Of Funds Picker
    [Documentation]    Open the Select Account sheet from Source of Funds.

    Wait Until Element Is Visible    ${BILLER_SOURCE_OF_FUNDS_LABEL}    timeout=30s
    Click Element    ${BILLER_SOURCE_OF_FUNDS_LABEL}
    ${sheet_open}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${BILLER_WALLET_TAB}    timeout=8s
    IF    not ${sheet_open}
        Click Element    ${BILLER_SOURCE_OF_FUNDS_VALUE}
        Wait Until Element Is Visible    ${BILLER_WALLET_TAB}    timeout=15s
    END


Verify Biller Account Name Is Resolved
    [Arguments]    ${account_name}
    [Documentation]    Verify the biller looked the account up and named the holder.
    ...                The lookup shows a loading placeholder first.

    ${name}=    Format String    ${BILLER_ACCOUNT_NAME}    ${account_name}
    Wait Until Element Is Visible    ${name}    timeout=60s


Get Prefilled Amount Due
    [Documentation]    Return the outstanding balance the biller prefilled.
    ...
    ...                The balance is whatever the biller currently reports, so it is
    ...                read at runtime rather than asserted against a fixed figure.

    Wait Until Element Is Visible    ${BILLER_AMOUNT_DUE_LABEL}    timeout=60s
    ${amount}=    Get Text    ${BILLER_AMOUNT_DUE_VALUE}
    Should Match Regexp    ${amount}    ^[0-9,]+\\.[0-9]{2}$
    ...    msg=Amount Due was not prefilled with a balance, got '${amount}'
    RETURN    ${amount}


Verify Utility Payment Was Submitted
    [Arguments]    ${expected_amount}    ${paybill_number}    ${biller_name}    ${transaction_type}
    [Documentation]    Verify the receipt confirms the bill payment was accepted.
    ...                Returns the MBP reference number.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=120s

    ${status}=    Get Text    ${SEND_RESULT_STATUS}
    Should Be Equal    ${status}    In Processing    msg=Unexpected transaction status

    ${type}=    Get Text    ${UTILITY_RESULT_TYPE}
    Should Be Equal    ${type}    ${transaction_type}    msg=Unexpected transaction type

    ${reference}=    Get Text    ${SEND_RESULT_REFERENCE}
    Should Not Be Empty    ${reference}    msg=No MBP reference number was issued

    ${paybill}=    Get Text    ${UTILITY_RESULT_PAYBILL_NUMBER}
    Should Be Equal    ${paybill}    ${paybill_number}    msg=Receipt paybill number does not match

    ${biller}=    Get Text    ${UTILITY_RESULT_PAYBILL_NAME}
    Should Be Equal    ${biller}    ${biller_name}    msg=Receipt biller name does not match

    ${amount}=    Get Text    ${UTILITY_RESULT_AMOUNT}
    Should Be Equal    ${amount}    ${expected_amount}    msg=Receipt amount does not match

    Expect Element    ${SEND_DONE_BUTTON}    visible
    RETURN    ${reference}
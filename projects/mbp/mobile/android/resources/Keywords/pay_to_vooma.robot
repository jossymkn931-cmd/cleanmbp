*** Settings ***
Documentation    Pay to Vooma keywords, covering Buy Goods and Pay Bill
Library          AppiumLibrary
Library          String
Resource         common.robot
Resource         ../locators/pay_locators.robot
Resource         ../locators/vooma_pay_locators.robot
Resource         ../locators/send_money_locators.robot


*** Keywords ***
Open Pay To Vooma
    [Documentation]    From the dashboard, open Pay and pick Pay to Vooma.

    Wait Until Element Is Visible    ${PAY_TILE}    timeout=60s
    Click Element    ${PAY_TILE}
    Wait Until Element Is Visible    ${PAY_VOOMA_OPTION}    timeout=30s
    Click Element    ${PAY_VOOMA_OPTION}
    Wait Until Element Is Visible    ${VOOMA_PAY_FORM_TITLE}    timeout=30s


Verify Vooma Pay Options Are Listed
    [Documentation]    Verify the form offers both Vooma payment modes.

    Wait Until Element Is Visible    ${VOOMA_BUY_GOODS_TAB}    timeout=30s
    Expect Element    ${VOOMA_PAY_BILL_TAB}    visible


Select Vooma Buy Goods
    [Documentation]    Switch the Vooma form to the Buy Goods tab.
    ...                Waits for the Till Number label, because until the tab has
    ...                rendered the amount label still belongs to the other tab.

    Wait Until Element Is Visible    ${VOOMA_BUY_GOODS_TAB}    timeout=30s
    Click Element    ${VOOMA_BUY_GOODS_TAB}
    Wait Until Element Is Visible    ${VOOMA_TILL_NUMBER_LABEL}    timeout=30s
    Wait Until Element Is Visible    ${VOOMA_TILL_NUMBER_INPUT}    timeout=30s


Select Vooma Pay Bill
    [Documentation]    Switch the Vooma form to the Pay Bill tab.

    Wait Until Element Is Visible    ${VOOMA_PAY_BILL_TAB}    timeout=30s
    Click Element    ${VOOMA_PAY_BILL_TAB}
    Wait Until Element Is Visible    ${VOOMA_PAYBILL_NUMBER_LABEL}    timeout=30s
    Wait Until Element Is Visible    ${VOOMA_PAYBILL_NUMBER_INPUT}    timeout=30s


Enter Vooma Till Number
    [Arguments]    ${till_number}
    [Documentation]    Enter the merchant till number on the Buy Goods tab.

    Wait Until Element Is Visible    ${VOOMA_TILL_NUMBER_INPUT}    timeout=30s
    Input Text    ${VOOMA_TILL_NUMBER_INPUT}    ${till_number}
    Field Should Contain Value    ${VOOMA_TILL_NUMBER_INPUT}    ${till_number}    Till Number


Enter Vooma Paybill Number
    [Arguments]    ${paybill_number}
    [Documentation]    Enter the biller paybill number on the Pay Bill tab.

    Wait Until Element Is Visible    ${VOOMA_PAYBILL_NUMBER_INPUT}    timeout=30s
    Input Text    ${VOOMA_PAYBILL_NUMBER_INPUT}    ${paybill_number}
    Field Should Contain Value    ${VOOMA_PAYBILL_NUMBER_INPUT}    ${paybill_number}    Paybill Number


Enter Vooma Account Number
    [Arguments]    ${account_number}
    [Documentation]    Enter the biller account number on the Pay Bill tab.

    Wait Until Element Is Visible    ${VOOMA_ACCOUNT_NUMBER_INPUT}    timeout=30s
    Input Text    ${VOOMA_ACCOUNT_NUMBER_INPUT}    ${account_number}
    Field Should Contain Value    ${VOOMA_ACCOUNT_NUMBER_INPUT}    ${account_number}    Account Number


Verify Vooma Merchant Is Resolved
    [Arguments]    ${merchant_name}
    [Documentation]    Verify the app looked the number up and named the merchant.

    ${merchant}=    Format String    ${VOOMA_MERCHANT_NAME}    ${merchant_name}
    Wait Until Element Is Visible    ${merchant}    timeout=60s


Enter Vooma Buy Goods Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Enter the amount on the Buy Goods tab.

    Enter Vooma Amount    ${VOOMA_BUY_GOODS_AMOUNT_INPUT}    ${amount}    ${formatted_amount}


Enter Vooma Pay Bill Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Enter the amount on the Pay Bill tab, which labels it Amount Due.

    Enter Vooma Amount    ${VOOMA_PAY_BILL_AMOUNT_INPUT}    ${amount}    ${formatted_amount}


Enter Vooma Amount
    [Arguments]    ${input_locator}    ${amount}    ${formatted_amount}
    [Documentation]    Focus the amount field, then type the amount.
    ...                The field only becomes an EditText once it has focus, and it
    ...                reverts to a formatted label afterwards, so the entry is
    ...                confirmed against that label rather than the input.

    Wait Until Element Is Visible    ${VOOMA_PAY_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${VOOMA_PAY_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${input_locator}    timeout=15s
    Input Text    ${input_locator}    ${amount}
    ${value}=    Format String    ${VOOMA_PAY_AMOUNT_VALUE}    ${formatted_amount}
    Wait Until Element Is Visible    ${value}    timeout=15s


Verify Vooma Payment Was Submitted
    [Arguments]    ${transaction_type}    ${expected_amount}    ${recipient}    ${merchant_name}=${EMPTY}
    [Documentation]    Verify the receipt confirms the Vooma request was accepted.
    ...
    ...                Vooma returns one narrative message rather than the labelled
    ...                rows the other receipts use, so the details are asserted
    ...                against that message. Returns the MBP reference number.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=120s

    ${message}=    Get Text    ${VOOMA_PAY_RESULT_MESSAGE}
    Should Contain    ${message}    ${transaction_type}    msg=Unexpected transaction type
    Should Contain    ${message}    ${expected_amount}    msg=Receipt amount does not match
    Should Contain    ${message}    ${recipient}    msg=Receipt does not name the recipient
    IF    $merchant_name
        Should Contain    ${message}    ${merchant_name}    msg=Receipt does not name the merchant
    END

    ${references}=    Get Regexp Matches    ${message}    ^([A-Z0-9]{10,})    1
    Should Not Be Empty    ${references}    msg=No MBP reference number was issued
    RETURN    ${references}[0]
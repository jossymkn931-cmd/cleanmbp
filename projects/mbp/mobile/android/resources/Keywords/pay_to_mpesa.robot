*** Settings ***
Documentation    M-Pesa payment keywords, covering Buy Goods and Pay Bill
Library          AppiumLibrary
Library          String
Resource         ../locators/pay_locators.robot
Resource         ../locators/mpesa_pay_locators.robot
Resource         ../locators/send_money_locators.robot


*** Keywords ***
Open Pay To Mpesa
    [Documentation]    From the dashboard, open Pay and pick M-Pesa.
    ...                The sheet option and the form title share the same text, so
    ...                the form is confirmed by its Buy Goods tab.

    Wait Until Element Is Visible    ${PAY_TILE}    timeout=60s
    Click Element    ${PAY_TILE}
    Wait Until Element Is Visible    ${PAY_MPESA_OPTION}    timeout=30s
    Click Element    ${PAY_MPESA_OPTION}
    Wait Until Element Is Visible    ${MPESA_BUY_GOODS_TAB}    timeout=30s


Verify Mpesa Pay Options Are Listed
    [Documentation]    Verify the form offers both M-Pesa payment modes.

    Wait Until Element Is Visible    ${MPESA_BUY_GOODS_TAB}    timeout=30s
    Expect Element    ${MPESA_PAY_BILL_TAB}    visible


Select Mpesa Buy Goods
    [Documentation]    Switch the M-Pesa form to the Buy Goods tab.

    Wait Until Element Is Visible    ${MPESA_BUY_GOODS_TAB}    timeout=30s
    Click Element    ${MPESA_BUY_GOODS_TAB}
    Wait Until Element Is Visible    ${MPESA_TILL_NUMBER_LABEL}    timeout=30s
    Wait Until Element Is Visible    ${MPESA_TILL_NUMBER_INPUT}    timeout=30s


Select Mpesa Pay Bill
    [Documentation]    Switch the M-Pesa form to the Pay Bill tab.

    Wait Until Element Is Visible    ${MPESA_PAY_BILL_TAB}    timeout=30s
    Click Element    ${MPESA_PAY_BILL_TAB}
    Wait Until Element Is Visible    ${MPESA_PAYBILL_NUMBER_LABEL}    timeout=30s
    Wait Until Element Is Visible    ${MPESA_PAYBILL_NUMBER_INPUT}    timeout=30s


Enter Mpesa Till Number
    [Arguments]    ${till_number}
    [Documentation]    Enter the merchant till number on the Buy Goods tab.

    Wait Until Element Is Visible    ${MPESA_TILL_NUMBER_INPUT}    timeout=30s
    Input Text    ${MPESA_TILL_NUMBER_INPUT}    ${till_number}
    Mpesa Field Should Contain Value    ${MPESA_TILL_NUMBER_INPUT}    ${till_number}    M-Pesa Till Number


Enter Mpesa Paybill Number
    [Arguments]    ${paybill_number}
    [Documentation]    Enter the biller paybill number on the Pay Bill tab.

    Wait Until Element Is Visible    ${MPESA_PAYBILL_NUMBER_INPUT}    timeout=30s
    Input Text    ${MPESA_PAYBILL_NUMBER_INPUT}    ${paybill_number}
    Mpesa Field Should Contain Value    ${MPESA_PAYBILL_NUMBER_INPUT}    ${paybill_number}    M-Pesa Paybill Number


Enter Mpesa Account Number
    [Arguments]    ${account_number}
    [Documentation]    Enter the biller account number on the Pay Bill tab.

    Wait Until Element Is Visible    ${MPESA_ACCOUNT_NUMBER_INPUT}    timeout=30s
    Input Text    ${MPESA_ACCOUNT_NUMBER_INPUT}    ${account_number}
    Mpesa Field Should Contain Value    ${MPESA_ACCOUNT_NUMBER_INPUT}    ${account_number}    Account Number


Verify Mpesa Merchant Is Resolved
    [Arguments]    ${merchant_name}
    [Documentation]    Verify the app looked the number up and named the merchant.

    ${merchant}=    Format String    ${MPESA_MERCHANT_NAME}    ${merchant_name}
    Wait Until Element Is Visible    ${merchant}    timeout=60s


Enter Mpesa Buy Goods Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Enter the amount on the Buy Goods tab.

    Enter Mpesa Amount    ${MPESA_BUY_GOODS_AMOUNT_INPUT}    ${amount}    ${formatted_amount}


Enter Mpesa Pay Bill Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Enter the amount on the Pay Bill tab, which labels it Amount Due.

    Enter Mpesa Amount    ${MPESA_PAY_BILL_AMOUNT_INPUT}    ${amount}    ${formatted_amount}


Enter Mpesa Amount
    [Arguments]    ${input_locator}    ${amount}    ${formatted_amount}
    [Documentation]    Focus the amount field, then type the amount.
    ...                The field only becomes an EditText once it has focus, and it
    ...                reverts to a formatted label afterwards, so the entry is
    ...                confirmed against that label rather than the input.

    Wait Until Element Is Visible    ${MPESA_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${MPESA_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${input_locator}    timeout=15s
    Input Text    ${input_locator}    ${amount}
    ${value}=    Format String    ${MPESA_AMOUNT_VALUE}    ${formatted_amount}
    Wait Until Element Is Visible    ${value}    timeout=15s


Enter Mpesa Payment Reason
    [Arguments]    ${reason}
    [Documentation]    Fill the optional reason for payment.

    Wait Until Element Is Visible    ${MPESA_REASON_INPUT}    timeout=30s
    Input Text    ${MPESA_REASON_INPUT}    ${reason}
    Mpesa Field Should Contain Value    ${MPESA_REASON_INPUT}    ${reason}    Reason for Payment


Mpesa Field Should Contain Value
    [Arguments]    ${locator}    ${expected}    ${field_name}
    [Documentation]    Guard against a value landing in a neighbouring field, which
    ...                label relative locators allow when a tab has not fully rendered.

    ${actual}=    Get Text    ${locator}
    Should Be Equal    ${actual}    ${expected}
    ...    msg=Expected the ${field_name} field to contain '${expected}' but it contains '${actual}'


Verify Mpesa Payment Was Submitted
    [Arguments]    ${expected_amount}    ${recipient}
    [Documentation]    Verify the receipt confirms the M-Pesa request was accepted.
    ...
    ...                The receipt layout has not been observed yet, because no valid
    ...                M-Pesa till was available, so this asserts on page text rather
    ...                than on specific rows. Tighten it once a real receipt is seen.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=120s
    Page Should Contain Text    ${expected_amount}
    Page Should Contain Text    ${recipient}
    Expect Element    ${SEND_DONE_BUTTON}    visible
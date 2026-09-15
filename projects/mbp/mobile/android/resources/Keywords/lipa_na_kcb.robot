*** Settings ***
Documentation    Lipa na KCB payment keywords
Library          AppiumLibrary
Library          String
Resource         ../locators/pay_locators.robot
Resource         ../locators/lipa_na_kcb_locators.robot
Resource         ../locators/send_money_locators.robot


*** Keywords ***
Open Lipa Na KCB
    [Documentation]    From the dashboard, open Pay and pick Lipa na KCB.
    ...                The option and the form title share the same text, so the
    ...                form is confirmed by its Till Number field.

    Wait Until Element Is Visible    ${PAY_TILE}    timeout=60s
    Click Element    ${PAY_TILE}
    Wait Until Element Is Visible    ${PAY_LIPA_NA_KCB_OPTION}    timeout=30s
    Click Element    ${PAY_LIPA_NA_KCB_OPTION}
    Wait Until Element Is Visible    ${LIPA_TILL_NUMBER_LABEL}    timeout=30s
    Wait Until Element Is Visible    ${LIPA_TILL_NUMBER_INPUT}    timeout=30s


Enter Lipa Till Number
    [Arguments]    ${till_number}
    [Documentation]    Enter the Lipa na KCB till number.

    Wait Until Element Is Visible    ${LIPA_TILL_NUMBER_INPUT}    timeout=30s
    Input Text    ${LIPA_TILL_NUMBER_INPUT}    ${till_number}
    ${actual}=    Get Text    ${LIPA_TILL_NUMBER_INPUT}
    Should Be Equal    ${actual}    ${till_number}
    ...    msg=Expected the Till Number field to contain '${till_number}' but it contains '${actual}'


Verify Lipa Merchant Is Resolved
    [Arguments]    ${merchant_name}
    [Documentation]    Verify the app looked the till up and named the merchant.

    ${merchant}=    Format String    ${LIPA_MERCHANT_NAME}    ${merchant_name}
    Wait Until Element Is Visible    ${merchant}    timeout=60s


Enter Lipa Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Focus the amount field, then type the amount.
    ...                The field only becomes an EditText once it has focus, and it
    ...                reverts to a formatted label afterwards, so the entry is
    ...                confirmed against that label rather than the input.

    Wait Until Element Is Visible    ${LIPA_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${LIPA_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${LIPA_AMOUNT_INPUT}    timeout=15s
    Input Text    ${LIPA_AMOUNT_INPUT}    ${amount}
    ${value}=    Format String    ${LIPA_AMOUNT_VALUE}    ${formatted_amount}
    Wait Until Element Is Visible    ${value}    timeout=15s


Verify Lipa Payment Was Submitted
    [Arguments]    ${expected_amount}    ${till_number}    ${service_type}
    [Documentation]    Verify the receipt confirms the Lipa na KCB request was accepted.
    ...                Returns the transaction id.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=120s

    ${status}=    Get Text    ${LIPA_RESULT_STATUS}
    Should Be Equal    ${status}    In Processing    msg=Unexpected transaction status

    ${type}=    Get Text    ${LIPA_RESULT_SERVICE_TYPE}
    Should Be Equal    ${type}    ${service_type}    msg=Unexpected service type

    ${transaction_id}=    Get Text    ${LIPA_RESULT_TRANSACTION_ID}
    Should Not Be Empty    ${transaction_id}    msg=No transaction id was issued

    ${till}=    Get Text    ${LIPA_RESULT_TILL_NUMBER}
    Should Be Equal    ${till}    ${till_number}    msg=Receipt till number does not match

    ${amount}=    Get Text    ${LIPA_RESULT_AMOUNT}
    Should Be Equal    ${amount}    ${expected_amount}    msg=Receipt amount does not match

    Expect Element    ${SEND_DONE_BUTTON}    visible
    RETURN    ${transaction_id}
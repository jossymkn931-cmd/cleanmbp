*** Settings ***
Documentation    Deposit & Withdraw keywords
Library          AppiumLibrary
Library          String
Resource         ../locators/deposit_withdraw_locators.robot
Resource         ../locators/send_money_locators.robot


*** Keywords ***
Open Deposit And Withdraw
    [Documentation]    Open Deposit & Withdraw from the dashboard.
    ...                The tile and the screen title share their text, so arrival is
    ...                confirmed by the tabs instead.

    Wait Until Element Is Visible    ${DEPOSIT_WITHDRAW_TILE}    timeout=60s
    Click Element    ${DEPOSIT_WITHDRAW_TILE}
    Wait Until Element Is Visible    ${DEPOSIT_TAB}    timeout=30s
    Wait Until Element Is Visible    ${WITHDRAW_TAB}    timeout=30s


Select Deposit Tab
    [Documentation]    Switch to the Deposit tab and wait for its own field to render.

    Wait Until Element Is Visible    ${DEPOSIT_TAB}    timeout=30s
    Click Element    ${DEPOSIT_TAB}
    Wait Until Element Is Visible    ${DEPOSIT_FUNDS_TO_LABEL}    timeout=30s


Select Withdraw Tab
    [Documentation]    Switch to the Withdraw tab and wait for its own field to render.

    Wait Until Element Is Visible    ${WITHDRAW_TAB}    timeout=30s
    Click Element    ${WITHDRAW_TAB}
    Wait Until Element Is Visible    ${WITHDRAW_OPTION_LABEL}    timeout=30s


Verify Deposit Source Of Funds Is
    [Arguments]    ${mobile_number}
    [Documentation]    Verify the deposit is drawn from the linked mobile money number.

    Wait Until Element Is Visible    ${DEPOSIT_SOURCE_MOBILE_NUMBER}    timeout=30s
    ${actual}=    Get Text    ${DEPOSIT_SOURCE_MOBILE_NUMBER}
    Should Be Equal    ${actual}    ${mobile_number}
    ...    msg=Expected the source of funds to be '${mobile_number}' but it is '${actual}'


Verify Deposit Target Account Is
    [Arguments]    ${account}
    [Documentation]    Verify the deposit is credited to the expected account.

    Wait Until Element Is Visible    ${DEPOSIT_TARGET_ACCOUNT}    timeout=30s
    ${actual}=    Get Text    ${DEPOSIT_TARGET_ACCOUNT}
    Should Be Equal    ${actual}    ${account}
    ...    msg=Expected the deposit to credit '${account}' but it credits '${actual}'


Verify Withdraw Source Account Is
    [Arguments]    ${account}
    [Documentation]    Verify the withdrawal is debited from the expected account.

    Wait Until Element Is Visible    ${WITHDRAW_SOURCE_ACCOUNT}    timeout=30s
    ${actual}=    Get Text    ${WITHDRAW_SOURCE_ACCOUNT}
    Should Be Equal    ${actual}    ${account}
    ...    msg=Expected the withdrawal to debit '${account}' but it debits '${actual}'


Verify Withdraw Option Is
    [Arguments]    ${option}
    [Documentation]    Verify the withdrawal option the form preselects.

    Wait Until Element Is Visible    ${WITHDRAW_SELECTED_OPTION}    timeout=30s
    ${actual}=    Get Text    ${WITHDRAW_SELECTED_OPTION}
    Should Be Equal    ${actual}    ${option}
    ...    msg=Expected '${option}' to be preselected but '${actual}' is


Enter Agent Number
    [Arguments]    ${agent_number}
    [Documentation]    Enter the KCB agent's number.

    Wait Until Element Is Visible    ${WITHDRAW_AGENT_NUMBER_INPUT}    timeout=30s
    Input Text    ${WITHDRAW_AGENT_NUMBER_INPUT}    ${agent_number}
    ${actual}=    Get Text    ${WITHDRAW_AGENT_NUMBER_INPUT}
    Should Be Equal    ${actual}    ${agent_number}
    ...    msg=Expected the agent number field to contain '${agent_number}' but it contains '${actual}'


Enter Deposit Or Withdraw Amount
    [Arguments]    ${amount}    ${expected_on_form}
    [Documentation]    Enter the amount and verify how the form formats it.
    ...                The field is a label until tapped, so it is focused first, and
    ...                the keyboard is dismissed because it hides the submit button.

    Wait Until Element Is Visible    ${AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${AMOUNT_INPUT}    timeout=15s
    Input Text    ${AMOUNT_INPUT}    ${amount}
    Hide Keyboard
    ${value}=    Format String    ${AMOUNT_VALUE}    ${expected_on_form}
    Wait Until Element Is Visible    ${value}    timeout=15s


Tap Deposit Or Withdraw Submit
    [Documentation]    Submit the form and open the confirm summary.

    Wait Until Element Is Visible    ${DEPOSIT_WITHDRAW_SUBMIT_BUTTON}    timeout=30s
    Expect Element    ${DEPOSIT_WITHDRAW_SUBMIT_BUTTON}    enabled
    Click Element    ${DEPOSIT_WITHDRAW_SUBMIT_BUTTON}
    Wait Until Element Is Visible    ${DEPOSIT_CONFIRM_TITLE}    timeout=60s


Confirm Row Should Be
    [Arguments]    ${locator}    ${expected}    ${row}
    [Documentation]    Compare a confirm summary value, which the sheet renders with a
    ...                leading space.

    ${actual}=    Get Text    ${locator}
    ${actual}=    Strip String    ${actual}
    Should Be Equal    ${actual}    ${expected}
    ...    msg=Confirm summary ${row} is '${actual}', expected '${expected}'


Verify Deposit Confirm Summary
    [Arguments]    ${source}    ${mobile_number}    ${recipient}    ${account_number}    ${expected_amount}
    [Documentation]    Verify every row of the deposit confirm summary before the PIN
    ...                is entered and money moves.

    Wait Until Element Is Visible    ${DEPOSIT_CONFIRM_TITLE}    timeout=60s
    Confirm Row Should Be    ${DEPOSIT_CONFIRM_SOURCE}    ${source}    source of funds
    Confirm Row Should Be    ${DEPOSIT_CONFIRM_MOBILE_NUMBER}    ${mobile_number}    mobile number
    Confirm Row Should Be    ${DEPOSIT_CONFIRM_RECIPIENT}    ${recipient}    recipient
    Confirm Row Should Be    ${DEPOSIT_CONFIRM_ACCOUNT_NUMBER}    ${account_number}    recipient account no
    Confirm Row Should Be    ${DEPOSIT_CONFIRM_AMOUNT}    ${expected_amount}    amount


Verify Deposit Or Withdrawal Was Submitted
    [Arguments]    ${service_type}    ${account_number}    ${expected_amount}
    [Documentation]    Verify the receipt confirms the request was accepted.
    ...                Returns the MBP reference number.
    ...
    ...                A deposit only settles once the customer approves the M-Pesa
    ...                prompt on their handset, so the bank acknowledges receipt here
    ...                rather than confirming the funds have landed.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=120s

    ${status}=    Get Text    ${SEND_RESULT_STATUS}
    Should Be Equal    ${status}    In Processing    msg=Unexpected transaction status

    ${type}=    Get Text    ${DW_RESULT_SERVICE_TYPE}
    Should Be Equal    ${type}    ${service_type}    msg=Unexpected service type

    ${reference}=    Get Text    ${SEND_RESULT_REFERENCE}
    Should Not Be Empty    ${reference}    msg=No MBP reference number was issued

    ${account}=    Get Text    ${DW_RESULT_ACCOUNT_NUMBER}
    Should Be Equal    ${account}    ${account_number}    msg=Receipt account number does not match

    ${amount}=    Get Text    ${DW_RESULT_AMOUNT}
    Should Be Equal    ${amount}    ${expected_amount}    msg=Receipt amount does not match

    Expect Element    ${SEND_DONE_BUTTON}    visible
    RETURN    ${reference}
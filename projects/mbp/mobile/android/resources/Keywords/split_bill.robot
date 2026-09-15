*** Settings ***
Documentation    Split Bill keywords
Library          AppiumLibrary
Library          String
Resource         ../locators/split_bill_locators.robot


*** Keywords ***
Open Split Bill
    [Documentation]    Open Split Bill from the Transact tab.
    ...                The tile and the screen title share their text, so arrival is
    ...                confirmed by the request list instead.

    Wait Until Element Is Visible    ${TRANSACT_NAV_TAB}    timeout=60s
    Click Element    ${TRANSACT_NAV_TAB}
    Wait Until Element Is Visible    ${SPLIT_BILL_TILE}    timeout=30s
    Click Element    ${SPLIT_BILL_TILE}
    Wait Until Element Is Visible    ${SPLIT_BILL_MY_REQUEST_TAB}    timeout=30s
    Wait Until Element Is Visible    ${SPLIT_BILL_MY_PAYMENTS_TAB}    timeout=30s


Start A Split Bill Request
    [Documentation]    Open the form used to raise a new split bill.

    Wait Until Element Is Visible    ${SPLIT_BILL_REQUEST_SPLIT_BUTTON}    timeout=30s
    Click Element    ${SPLIT_BILL_REQUEST_SPLIT_BUTTON}
    Wait Until Element Is Visible    ${SPLIT_BILL_NAME_LABEL}    timeout=30s


Enter Split Bill Name
    [Arguments]    ${name}
    [Documentation]    Name the split bill.

    Wait Until Element Is Visible    ${SPLIT_BILL_NAME_INPUT}    timeout=30s
    Input Text    ${SPLIT_BILL_NAME_INPUT}    ${name}
    Hide Keyboard
    ${actual}=    Get Text    ${SPLIT_BILL_NAME_INPUT}
    Should Be Equal    ${actual}    ${name}
    ...    msg=Expected the split bill name field to contain '${name}' but it contains '${actual}'


Verify Split Bill Destination Account Is
    [Arguments]    ${account}
    [Documentation]    Verify the collected funds are credited to the expected account.

    Wait Until Element Is Visible    ${SPLIT_BILL_DESTINATION_ACCOUNT}    timeout=30s
    ${actual}=    Get Text    ${SPLIT_BILL_DESTINATION_ACCOUNT}
    Should Be Equal    ${actual}    ${account}
    ...    msg=Expected the split bill to credit '${account}' but it credits '${actual}'


Enter Split Bill Total Amount
    [Arguments]    ${amount}    ${expected_on_form}
    [Documentation]    Enter the total amount and verify how the form formats it.
    ...                The field is a label until tapped, so it is focused first, and
    ...                the keyboard is dismissed because it hides the submit button.

    Wait Until Element Is Visible    ${SPLIT_BILL_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${SPLIT_BILL_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${SPLIT_BILL_AMOUNT_INPUT}    timeout=15s
    Input Text    ${SPLIT_BILL_AMOUNT_INPUT}    ${amount}
    Hide Keyboard
    ${value}=    Format String    ${SPLIT_BILL_AMOUNT_VALUE}    ${expected_on_form}
    Wait Until Element Is Visible    ${value}    timeout=15s


Add Split Bill Participant
    [Arguments]    ${mobile_number}
    [Documentation]    Add a participant by mobile number and return to the form.

    Wait Until Element Is Visible    ${SPLIT_BILL_ADD_PARTICIPANT}    timeout=30s
    Click Element    ${SPLIT_BILL_ADD_PARTICIPANT}
    Wait Until Element Is Visible    ${ADD_PARTICIPANTS_TITLE}    timeout=30s
    Input Text    ${PARTICIPANT_MOBILE_INPUT}    ${mobile_number}
    Hide Keyboard
    Wait Until Element Is Visible    ${PARTICIPANT_ADD_BUTTON}    timeout=15s
    Expect Element    ${PARTICIPANT_ADD_BUTTON}    enabled
    Click Element    ${PARTICIPANT_ADD_BUTTON}
    Wait Until Element Is Visible    ${PARTICIPANT_DONE_BUTTON}    timeout=15s
    Expect Element    ${PARTICIPANT_DONE_BUTTON}    enabled
    Click Element    ${PARTICIPANT_DONE_BUTTON}
    Wait Until Element Is Visible    ${SPLIT_BILL_NAME_LABEL}    timeout=30s


Verify Split Bill Participants Are
    [Arguments]    ${summary}
    [Documentation]    Verify how many people the bill is split between.
    ...                The account holder is counted as a participant.

    Wait Until Element Is Visible    ${SPLIT_BILL_PARTICIPANT_SUMMARY}    timeout=30s
    ${actual}=    Get Text    ${SPLIT_BILL_PARTICIPANT_SUMMARY}
    Should Be Equal    ${actual}    ${summary}
    ...    msg=Expected '${summary}' but the form shows '${actual}'


Accept Default Expiration Date
    [Documentation]    Open the due date picker and accept the date it preselects.
    ...                Tapping a day in the wheel dismisses the picker without
    ...                selecting, so the picker's confirm control is used instead.

    Wait Until Element Is Visible    ${SPLIT_BILL_DUE_DATE}    timeout=30s
    Click Element    ${SPLIT_BILL_DUE_DATE}
    Wait Until Element Is Visible    ${DATE_PICKER_TITLE}    timeout=30s
    Click Element    ${DATE_PICKER_DONE_BUTTON}
    Wait Until Element Is Visible    ${SPLIT_BILL_EXPIRATION_DATE}    timeout=30s
    ${date}=    Get Text    ${SPLIT_BILL_EXPIRATION_DATE}
    Should Not Be Equal    ${date}    Due Date    msg=No expiration date was selected
    RETURN    ${date}


Verify Split Bill Cannot Be Completed
    [Documentation]    Verify an incomplete form cannot be submitted.

    Wait Until Element Is Visible    ${SPLIT_BILL_COMPLETE_BUTTON}    timeout=30s
    Expect Element    ${SPLIT_BILL_COMPLETE_BUTTON}    disabled


Tap Complete
    [Documentation]    Submit the form and open the confirm summary.

    Wait Until Element Is Visible    ${SPLIT_BILL_COMPLETE_BUTTON}    timeout=30s
    Expect Element    ${SPLIT_BILL_COMPLETE_BUTTON}    enabled
    Click Element    ${SPLIT_BILL_COMPLETE_BUTTON}
    Wait Until Element Is Visible    ${SPLIT_BILL_CONFIRM_TITLE}    timeout=60s


Split Bill Confirm Row Should Be
    [Arguments]    ${locator}    ${expected}    ${row}
    [Documentation]    Compare a confirm summary value, which the sheet renders with a
    ...                leading space.

    ${actual}=    Get Text    ${locator}
    ${actual}=    Strip String    ${actual}
    Should Be Equal    ${actual}    ${expected}
    ...    msg=Confirm summary ${row} is '${actual}', expected '${expected}'


Verify Split Bill Confirm Summary
    [Arguments]    ${name}    ${account}    ${expected_amount}
    [Documentation]    Verify every row of the confirm summary before the PIN is
    ...                entered and the request goes out.

    Wait Until Element Is Visible    ${SPLIT_BILL_CONFIRM_TITLE}    timeout=60s
    Split Bill Confirm Row Should Be    ${SPLIT_BILL_CONFIRM_NAME}    ${name}    split bill name
    Split Bill Confirm Row Should Be    ${SPLIT_BILL_CONFIRM_ACCOUNT}    ${account}    destination account
    Split Bill Confirm Row Should Be    ${SPLIT_BILL_CONFIRM_AMOUNT}    ${expected_amount}    total amount to receive

    ${date}=    Get Text    ${SPLIT_BILL_CONFIRM_DATE}
    ${date}=    Strip String    ${date}
    Should Not Be Empty    ${date}    msg=Confirm summary shows no date


Verify Split Bill Was Created
    [Documentation]    Verify the split bill request was raised.
    ...
    ...                Split Bill issues no receipt or reference number: the app shows
    ...                a success overlay and returns to the Transact tab on its own.

    Wait Until Element Is Visible    ${SPLIT_BILL_SUCCESS_MESSAGE}    timeout=120s
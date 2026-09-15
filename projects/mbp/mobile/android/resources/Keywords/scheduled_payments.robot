*** Settings ***
Documentation    Keywords for scheduling a future payment from the More menu
Library          AppiumLibrary
Library          String
Resource         send_money.robot
Resource         ../locators/scheduled_payment_locators.robot
Resource         ../variables/test_data.robot


*** Keywords ***
Open Scheduled Payments
    [Documentation]    Reach the Scheduled Payments hub from the dashboard More sheet.
    ...                The tap is swallowed while the dashboard is still settling, and
    ...                nothing on the dashboard reports that it has, so it is repeated.

    Wait Until Element Is Visible    ${MORE_TILE}    timeout=60s
    Wait Until Keyword Succeeds    3x    2s    Open The More Sheet
    Click Element    ${SCHEDULED_PAYMENTS_OPTION}
    Wait Until Element Is Visible    ${NEW_SCHEDULED_PAYMENT_BUTTON}    timeout=30s


Open The More Sheet
    [Documentation]    Open the dashboard More sheet.

    Click Element    ${MORE_TILE}
    Wait Until Element Is Visible    ${SCHEDULED_PAYMENTS_OPTION}    timeout=10s


Start A New Scheduled Payment
    [Documentation]    Open the payment type picker from the Scheduled Payments hub.

    Click Element    ${NEW_SCHEDULED_PAYMENT_BUTTON}
    Wait Until Element Is Visible    ${PAYMENT_TYPE_TITLE}    timeout=30s


Select Scheduled Payment Type
    [Arguments]    ${tab}    ${payment_type}
    [Documentation]    Pick a payment type from one of the type tabs and continue to
    ...                the ordinary form for that payment.

    Select Schedule Tab    ${tab}
    ${option}=    Format String    ${PAYMENT_TYPE_OPTION}    ${payment_type}
    Wait Until Element Is Visible    ${option}    timeout=30s
    Click Element    ${option}
    Click Element    ${PAYMENT_TYPE_CONTINUE}
    Wait Until Page Does Not Contain Element    ${PAYMENT_TYPE_TITLE}    timeout=30s


Select Schedule Tab
    [Arguments]    ${tab}
    [Documentation]    Switch tabs, on the payment type screen or on a payment form.

    ${locator}=    Format String    ${SCHEDULE_TAB}    ${tab}
    Wait Until Element Is Visible    ${locator}    timeout=30s
    Click Element    ${locator}


Select Schedule Send To Self
    [Documentation]    Schedule the payment to the number the account is registered on.

    Select Schedule Tab    Send to Self
    Wait Until Element Is Visible    ${SCHEDULE_AMOUNT_PLACEHOLDER}    timeout=30s


Select Schedule Send To Other
    [Documentation]    Schedule the payment to a number that is typed in.
    ...                Waits on Favourites, which only the Send to Other tab has: the
    ...                Send to Self tab already holds an input the recipient field would
    ...                otherwise resolve to while the tab is still rendering.

    Select Schedule Tab    Send to Other
    Wait Until Element Is Visible    ${SCHEDULE_ADD_FAVOURITE}    timeout=30s


Enter Schedule Recipient Number
    [Arguments]    ${mobile_number}
    [Documentation]    Enter the recipient after the fixed +254 prefix.

    Wait Until Element Is Visible    ${SCHEDULE_MOBILE_NUMBER_INPUT}    timeout=30s
    Input Text    ${SCHEDULE_MOBILE_NUMBER_INPUT}    ${mobile_number}


Schedule Recipient Should Be
    [Arguments]    ${expected_name}
    [Documentation]    Verify the app resolved the number, which is what enables
    ...                Make Payment.

    ${name}=    Format String    ${SCHEDULE_RECIPIENT_NAME}    ${expected_name}
    Wait Until Element Is Visible    ${name}    timeout=30s


Enter Schedule Amount
    [Arguments]    ${amount}
    [Documentation]    Focus the amount field, then type the amount.
    ...                The field only becomes an EditText once it has focus.

    Wait Until Element Is Visible    ${SCHEDULE_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${SCHEDULE_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${SCHEDULE_AMOUNT_INPUT}    timeout=15s
    Input Text    ${SCHEDULE_AMOUNT_INPUT}    ${amount}


Name The Scheduled Payment
    [Arguments]    ${schedule_name}
    [Documentation]    Name the schedule on the Schedule Payment screen.

    Wait Until Element Is Visible    ${SCHEDULE_DETAILS_TITLE}    timeout=30s
    Input Text    ${SCHEDULE_NAME_INPUT}    ${schedule_name}


Schedule It For The Earliest Date
    [Arguments]    ${schedule_name}
    [Documentation]    Fill in the schedule itself, which is the same for every payment
    ...                type once its own form has been submitted.

    Name The Scheduled Payment    ${schedule_name}
    Select Schedule Frequency     ${SCHEDULE_FREQUENCY}
    Accept The Default Start Date
    Enter Schedule Narration      ${SCHEDULE_NARRATION}
    Submit The Schedule


Select Schedule Frequency
    [Arguments]    ${frequency}
    [Documentation]    Set how often the payment repeats. Never schedules it once.

    Click Element    ${SCHEDULE_REPEAT_VALUE}
    Wait Until Element Is Visible    ${SCHEDULE_FREQUENCY_SHEET}    timeout=30s
    ${option}=    Format String    ${SCHEDULE_FREQUENCY_OPTION}    ${frequency}
    Click Element    ${option}
    Wait Until Page Does Not Contain Element    ${SCHEDULE_FREQUENCY_SHEET}    timeout=15s


Accept The Default Start Date
    [Documentation]    Take the date the picker opens on, which is the earliest the app
    ...                allows. Choosing another date would only exercise the wheels.

    Click Element    ${SCHEDULE_START_DATE_VALUE}
    Wait Until Element Is Visible    ${SCHEDULE_DATE_PICKER_TITLE}    timeout=30s
    Click Element    ${SCHEDULE_DATE_DONE_BUTTON}
    Wait Until Page Does Not Contain Element    ${SCHEDULE_START_DATE_VALUE}    timeout=15s


Enter Schedule Narration
    [Arguments]    ${narration}
    [Documentation]    Describe the payment for the recipient's statement.
    ...                The page is briefly empty behind the closing date picker, so the
    ...                field is waited for rather than typed into straight away.

    Wait Until Element Is Visible    ${SCHEDULE_NARRATION_INPUT}    timeout=30s
    Input Text    ${SCHEDULE_NARRATION_INPUT}    ${narration}


Submit The Schedule
    [Documentation]    Submit the schedule details and raise the confirmation sheet.

    Click Element    ${SCHEDULE_SUBMIT_BUTTON}
    Wait Until Element Is Visible    ${SEND_CONFIRM_TITLE}    timeout=30s


Verify Schedule Summary Is Displayed
    [Arguments]    ${schedule_name}    ${expected_amount}
    [Documentation]    Verify the confirmation sheet repeats back what was scheduled.

    Schedule Summary Row Should Be    Scheduled Payment Name    ${schedule_name}
    Schedule Summary Row Should Be    Amount                    ${expected_amount}


Schedule Summary Row Should Be
    [Arguments]    ${label}    ${expected}
    [Documentation]    Compare a summary row, which the app renders with a leading space.

    ${locator}=    Format String    ${SCHEDULE_CONFIRM_ROW}    ${label}
    ${actual}=     Get Text    ${locator}
    ${actual}=     Strip String    ${actual}
    Should Be Equal    ${actual}    ${expected}    msg=${label} was summarised as '${actual}'


Verify Schedule Was Sent For Authorization
    [Documentation]    Verify the PIN was accepted and the schedule reached the OTP step.
    ...
    ...                The app autofills the OTP from SMS and then shows the receipt, but
    ...                SMS delivery is currently unavailable on this environment, so the
    ...                receipt is out of reach and authorization is the last checkable step.

    Wait Until Element Is Visible    ${SCHEDULE_AUTHORIZE_TITLE}    timeout=120s
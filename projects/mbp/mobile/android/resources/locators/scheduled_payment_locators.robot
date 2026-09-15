*** Variables ***
${MORE_TILE}                       xpath=//android.widget.TextView[@text='More']
${SCHEDULED_PAYMENTS_OPTION}       xpath=//android.widget.TextView[@text='Scheduled Payments']
${NEW_SCHEDULED_PAYMENT_BUTTON}    accessibility_id=scheduledPayment

${SCHEDULE_TAB}                    xpath=//android.view.View[@text='{}']

${PAYMENT_TYPE_TITLE}              xpath=//android.widget.TextView[@text='Select Payment Type']
${PAYMENT_TYPE_OPTION}             accessibility_id=radio_{}
${PAYMENT_TYPE_CONTINUE}           accessibility_id=continue

${SCHEDULE_ADD_FAVOURITE}          xpath=//android.widget.TextView[@text='Add Favourite']
${SCHEDULE_MOBILE_NUMBER_INPUT}    xpath=//android.widget.TextView[contains(@text,'Mobile Number')]/following::android.widget.EditText[1]
${SCHEDULE_RECIPIENT_NAME}         xpath=//android.widget.TextView[@text='{}']
${SCHEDULE_AMOUNT_PLACEHOLDER}     xpath=//android.widget.TextView[@text='Enter Amount']
${SCHEDULE_AMOUNT_INPUT}           xpath=//android.widget.TextView[@text='Amount']/following::android.widget.EditText[1]

${SCHEDULE_DETAILS_TITLE}          xpath=//android.widget.TextView[@text='Schedule Payment']
${SCHEDULE_NAME_INPUT}             xpath=//android.widget.TextView[starts-with(@text,'What Will You Call')]/following::android.widget.EditText[1]
${SCHEDULE_REPEAT_VALUE}           xpath=//android.widget.TextView[@text='Select Repeat']
${SCHEDULE_FREQUENCY_SHEET}        xpath=//android.widget.TextView[@text='Select Frequency']
${SCHEDULE_FREQUENCY_OPTION}       xpath=//android.widget.TextView[@text='Select Frequency']/following::android.widget.TextView[@text='{}'][1]
${SCHEDULE_START_DATE_VALUE}       xpath=//android.widget.TextView[@text='Select Start Date']
${SCHEDULE_DATE_PICKER_TITLE}      xpath=//android.widget.TextView[@text='Select Date']
${SCHEDULE_DATE_DONE_BUTTON}       accessibility_id=done
${SCHEDULE_NARRATION_INPUT}        xpath=//android.widget.TextView[@text='Narration']/following::android.widget.EditText[1]
${SCHEDULE_SUBMIT_BUTTON}          accessibility_id=setSchedulePayment

${SCHEDULE_CONFIRM_ROW}            xpath=//android.widget.TextView[@text='{}']/following::android.widget.TextView[1]

${SCHEDULE_AUTHORIZE_TITLE}        xpath=//android.widget.TextView[@text='Authorize Transaction']
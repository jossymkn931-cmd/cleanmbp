*** Settings ***
Documentation    Split Bill locators


*** Variables ***
${TRANSACT_NAV_TAB}                xpath=(//android.widget.TextView[@text='Transact'])[last()]
${SPLIT_BILL_TILE}                 xpath=//android.widget.TextView[@text='Split Bill']

${SPLIT_BILL_MY_REQUEST_TAB}       xpath=//android.view.View[@text='My Request']
${SPLIT_BILL_MY_PAYMENTS_TAB}      xpath=//android.view.View[@text='My Payments']
${SPLIT_BILL_REQUEST_SPLIT_BUTTON}    xpath=//android.widget.Button[contains(@text, 'Request Split')]

${SPLIT_BILL_NAME_LABEL}           xpath=//android.widget.TextView[@text='Split Bill Name']
${SPLIT_BILL_NAME_INPUT}           xpath=//android.widget.TextView[@text='Split Bill Name']/following::android.widget.EditText[1]
${SPLIT_BILL_DESTINATION_ACCOUNT}    xpath=//android.widget.TextView[@text='Destination Account']/following::android.widget.TextView[1]
${SPLIT_BILL_AMOUNT_PLACEHOLDER}    xpath=//android.widget.TextView[@text='Enter Amount']
${SPLIT_BILL_AMOUNT_INPUT}         xpath=//android.widget.TextView[@text='KES']/following::android.widget.EditText[1]
${SPLIT_BILL_AMOUNT_VALUE}         xpath=//android.widget.TextView[@text='KES']/following::android.widget.TextView[@text='{}'][1]
${SPLIT_BILL_PARTICIPANT_SUMMARY}    xpath=//android.widget.TextView[starts-with(@text, 'Splitting with')]

${SPLIT_BILL_ADD_PARTICIPANT}      xpath=//android.widget.TextView[@text='Add participant']
${ADD_PARTICIPANTS_TITLE}          xpath=//android.widget.TextView[@text='Add Participants']
${PARTICIPANT_MOBILE_INPUT}        xpath=//android.widget.TextView[@text='+254']/following::android.widget.EditText[1]
${PARTICIPANT_ADD_BUTTON}          xpath=//android.widget.Button[@text='Add']
${PARTICIPANT_DONE_BUTTON}         xpath=//android.widget.Button[@text='Done']

${SPLIT_BILL_DUE_DATE}             xpath=//android.widget.TextView[@text='Due Date']
${DATE_PICKER_TITLE}               xpath=//android.widget.TextView[@text='Select Date']
${DATE_PICKER_DONE_BUTTON}         xpath=//android.widget.Button[@content-desc='done']
${SPLIT_BILL_EXPIRATION_DATE}      xpath=//android.widget.TextView[@text='Expiration Date']/following::android.widget.TextView[1]

${SPLIT_BILL_COMPLETE_BUTTON}      xpath=//android.widget.Button[contains(@text, 'Complete')]

${SPLIT_BILL_CONFIRM_TITLE}        xpath=//android.widget.TextView[@text='Confirm Summary']
${SPLIT_BILL_CONFIRM_NAME}         xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Split Bill Name'][1]/following::android.widget.TextView[1]
${SPLIT_BILL_CONFIRM_ACCOUNT}      xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Destination Account'][1]/following::android.widget.TextView[1]
${SPLIT_BILL_CONFIRM_AMOUNT}       xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Total Amount To Receive'][1]/following::android.widget.TextView[1]
${SPLIT_BILL_CONFIRM_DATE}         xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Date'][1]/following::android.widget.TextView[1]

${SPLIT_BILL_SUCCESS_MESSAGE}      xpath=//android.widget.TextView[@text='Success']
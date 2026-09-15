*** Settings ***
Documentation    Send to Mobile transfer locators.
...              These screens are rendered in a Vue WebView, so elements expose HTML
...              ids/aria-labels rather than Android resource-ids.


*** Variables ***
${SEND_TO_MOBILE_TILE}         xpath=//android.widget.TextView[@text='Send to Mobile']

${SEND_TO_MOBILE_OPTION}       xpath=(//android.widget.TextView[@text='Send to Mobile'])[2]
${VOOMA_OPTION}                xpath=//*[contains(@text, 'Vooma')]

${VOOMA_FORM_TITLE}            xpath=//android.widget.TextView[@text='Send to Vooma']
${VOOMA_INVALID_NUMBER_ERROR}  xpath=//android.widget.TextView[@text='Invalid Mobile Number']
${VOOMA_MOBILE_NUMBER_INPUT}   xpath=//android.widget.EditText[@resource-id='ion-input-1']

${SEND_TO_SELF_TAB}            xpath=//android.view.View[@text='Send to Self']
${SEND_TO_OTHER_TAB}           xpath=//android.view.View[@text='Send to Other']
${SEND_MOBILE_NUMBER_INPUT}    xpath=//android.widget.EditText[@resource-id='ion-input-2']
${SEND_CONTACT_PICKER_BUTTON}  xpath=//android.widget.TextView[@text='+254']/following-sibling::android.view.View[2]
${SEND_CONTACT_SEARCH_INPUT}   xpath=//android.widget.TextView[@text='Search Contacts']/following::android.widget.EditText[1]
${SEND_CONTACT_RESULT}         xpath=//android.widget.TextView[@text='{}']
${SEND_AMOUNT_PLACEHOLDER}     xpath=//android.widget.TextView[@text='Enter Amount']
${SEND_AMOUNT_INPUT}           xpath=//android.widget.EditText[@resource-id='ion-input-0']

${SEND_MAKE_PAYMENT_BUTTON}    accessibility_id=makePayment

${SEND_CONFIRM_TITLE}          xpath=//android.widget.TextView[@text='Confirm Summary']
${SEND_CONTINUE_BUTTON}        accessibility_id=continue

${SEND_RESULT_TITLE}           xpath=//android.widget.TextView[@text='Request Sent']
${SEND_RESULT_STATUS}          xpath=//android.widget.TextView[@text='Transaction Status']/following-sibling::android.widget.TextView[1]
${SEND_RESULT_REFERENCE}       xpath=//android.widget.TextView[@text='MBP Reference No.']/following-sibling::android.widget.TextView[1]
${SEND_RESULT_PRINCIPAL}       xpath=//android.widget.TextView[@text='Principal']/following-sibling::android.widget.TextView[1]
${SEND_DONE_BUTTON}            accessibility_id=done
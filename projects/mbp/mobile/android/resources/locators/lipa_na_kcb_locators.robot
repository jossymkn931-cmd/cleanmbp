*** Settings ***
Documentation    Lipa na KCB locators


*** Variables ***
${LIPA_TILL_NUMBER_LABEL}         xpath=//android.widget.TextView[@text='Till Number']
${LIPA_TILL_NUMBER_INPUT}         xpath=//android.widget.TextView[@text='Till Number']/following::android.widget.EditText[1]
${LIPA_MERCHANT_NAME}             xpath=//android.widget.TextView[@text='{}']

${LIPA_AMOUNT_PLACEHOLDER}        xpath=//android.widget.TextView[@text='Enter Amount']
${LIPA_AMOUNT_INPUT}              xpath=//android.widget.TextView[@text='Amount']/following::android.widget.EditText[1]
${LIPA_AMOUNT_VALUE}              xpath=//android.widget.TextView[@text='{}']

${LIPA_RESULT_STATUS}             xpath=//android.widget.TextView[@text='Transaction Status']/following-sibling::android.widget.TextView[1]
${LIPA_RESULT_SERVICE_TYPE}       xpath=//android.widget.TextView[@text='Service Type']/following-sibling::android.widget.TextView[1]
${LIPA_RESULT_TRANSACTION_ID}     xpath=//android.widget.TextView[@text='Transaction ID']/following-sibling::android.widget.TextView[1]
${LIPA_RESULT_TILL_NUMBER}        xpath=//android.widget.TextView[@text='Till Number']/following-sibling::android.widget.TextView[1]
${LIPA_RESULT_AMOUNT}             xpath=//android.widget.TextView[@text='Amount']/following-sibling::android.widget.TextView[1]
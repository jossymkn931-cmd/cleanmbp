*** Settings ***
Documentation    Pay to Vooma locators.
...              Buy Goods and Pay Bill share one form, so every field is located
...              relative to its label rather than by resource-id: the WebView
...              renumbers the ion-input ids each time the tab changes.


*** Variables ***
${VOOMA_PAY_FORM_TITLE}            xpath=//android.widget.TextView[@text='Vooma']
${VOOMA_BUY_GOODS_TAB}             xpath=//android.view.View[@text='Buy Goods']
${VOOMA_PAY_BILL_TAB}              xpath=//android.view.View[@text='Pay Bill']

${VOOMA_TILL_NUMBER_LABEL}         xpath=//android.widget.TextView[@text='Till Number']
${VOOMA_TILL_NUMBER_INPUT}         xpath=//android.widget.TextView[@text='Till Number']/following::android.widget.EditText[1]
${VOOMA_MERCHANT_NAME}             xpath=//android.widget.TextView[@text='{}']

${VOOMA_PAYBILL_NUMBER_LABEL}      xpath=//android.widget.TextView[@text='Paybill Number']
${VOOMA_PAYBILL_NUMBER_INPUT}      xpath=//android.widget.TextView[@text='Paybill Number']/following::android.widget.EditText[1]
${VOOMA_ACCOUNT_NUMBER_INPUT}      xpath=//android.widget.TextView[@text='Account Number']/following::android.widget.EditText[1]
${VOOMA_INVALID_PAYBILL_ERROR}     xpath=//android.widget.TextView[@text='Invalid Paybill Number']

${VOOMA_PAY_AMOUNT_PLACEHOLDER}    xpath=//android.widget.TextView[@text='Enter Amount']
${VOOMA_BUY_GOODS_AMOUNT_INPUT}    xpath=//android.widget.TextView[@text='Amount']/following::android.widget.EditText[1]
${VOOMA_PAY_BILL_AMOUNT_INPUT}     xpath=//android.widget.TextView[@text='Amount Due']/following::android.widget.EditText[1]
${VOOMA_PAY_AMOUNT_VALUE}          xpath=//android.widget.TextView[@text='{}']

${VOOMA_PAY_RESULT_MESSAGE}        xpath=//android.widget.TextView[@text='Request Sent']/following::android.widget.TextView[1]
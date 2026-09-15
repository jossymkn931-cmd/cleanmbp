*** Settings ***
Documentation    M-Pesa payment locators, covering Buy Goods and Pay Bill


*** Variables ***
${MPESA_FORM_TITLE}                xpath=//android.widget.TextView[@text='M-Pesa']
${MPESA_BUY_GOODS_TAB}             xpath=//android.view.View[@text='Buy Goods']
${MPESA_PAY_BILL_TAB}              xpath=//android.view.View[@text='Pay Bill']

${MPESA_TILL_NUMBER_LABEL}         xpath=//android.widget.TextView[@text='M-Pesa Till Number']
${MPESA_TILL_NUMBER_INPUT}         xpath=//android.widget.TextView[@text='M-Pesa Till Number']/following::android.widget.EditText[1]
${MPESA_INVALID_MERCHANT_ERROR}    xpath=//android.widget.TextView[@text='Invalid Merchant Code']

${MPESA_PAYBILL_NUMBER_LABEL}      xpath=//android.widget.TextView[@text='M-Pesa Paybill Number']
${MPESA_PAYBILL_NUMBER_INPUT}      xpath=//android.widget.TextView[@text='M-Pesa Paybill Number']/following::android.widget.EditText[1]
${MPESA_ACCOUNT_NUMBER_INPUT}      xpath=//android.widget.TextView[@text='Account Number']/following::android.widget.EditText[1]

${MPESA_MERCHANT_NAME}             xpath=//android.widget.TextView[@text='{}']

${MPESA_AMOUNT_PLACEHOLDER}        xpath=//android.widget.TextView[@text='Enter Amount']
${MPESA_BUY_GOODS_AMOUNT_INPUT}    xpath=//android.widget.TextView[@text='Amount']/following::android.widget.EditText[1]
${MPESA_PAY_BILL_AMOUNT_INPUT}     xpath=//android.widget.TextView[@text='Amount Due']/following::android.widget.EditText[1]
${MPESA_AMOUNT_VALUE}              xpath=//android.widget.TextView[@text='{}']
${MPESA_REASON_INPUT}              xpath=//android.widget.TextView[@text='Reason for Payment (optional)']/following::android.widget.EditText[1]
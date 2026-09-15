*** Settings ***
Documentation    Utility bills and services locators


*** Variables ***
${BILLER_SEARCH_PLACEHOLDER}       xpath=//android.widget.TextView[@text='Search Biller']
${BILLER_SEARCH_INPUT}             xpath=//android.widget.EditText
${BILLER_RESULT}                   xpath=//android.widget.TextView[@text='{}']

${BILLER_LABEL}                    xpath=//android.widget.TextView[@text='Biller']
${BILLER_ACCOUNT_NUMBER_INPUT}     xpath=//android.widget.TextView[@text='Account Number']/following::android.widget.EditText[1]
${BILLER_ACCOUNT_NAME}             xpath=//android.widget.TextView[@text='{}']

${BILLER_AMOUNT_DUE_LABEL}         xpath=//android.widget.TextView[@text='Amount Due']
${BILLER_AMOUNT_DUE_VALUE}         xpath=//android.widget.TextView[@text='Amount Due']/following::android.widget.TextView[2]

${BILLER_SOURCE_OF_FUNDS_LABEL}    xpath=//android.widget.TextView[@text='Source of Funds']
${BILLER_SOURCE_OF_FUNDS_VALUE}    xpath=//android.widget.TextView[@text='Source of Funds']/following::android.widget.TextView[1]
${BILLER_SELECT_ACCOUNT_TITLE}     xpath=//android.widget.TextView[@text='Select Account']
${BILLER_ACCOUNTS_TAB}             xpath=//android.view.View[@text='Accounts']
${BILLER_WALLET_TAB}               xpath=//android.view.View[@text='Wallet']
${BILLER_VOOMA_WALLET_OPTION}      xpath=//android.widget.TextView[@text='{}']
${BILLER_VOOMA_WALLET_ROW}         xpath=//android.widget.TextView[@text='{}']/parent::*
${BILLER_WALLET_INSUFFICIENT}      xpath=//android.widget.TextView[@text='Insufficient Balance']
${BILLER_SELECT_ACCOUNT_CONTINUE}  accessibility_id=continue

${UTILITY_RESULT_TYPE}             xpath=//android.widget.TextView[@text='Transaction Type']/following-sibling::android.widget.TextView[1]
${UTILITY_RESULT_PAYBILL_NUMBER}   xpath=//android.widget.TextView[@text='Paybill Number']/following-sibling::android.widget.TextView[1]
${UTILITY_RESULT_PAYBILL_NAME}     xpath=//android.widget.TextView[@text='Paybill Name']/following-sibling::android.widget.TextView[1]
${UTILITY_RESULT_AMOUNT}           xpath=(//android.widget.TextView[@text='Amount'])[1]/following-sibling::android.widget.TextView[1]
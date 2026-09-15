*** Settings ***
Documentation    Send to Bank transfer locators


*** Variables ***
${BANK_TILE}                      xpath=//android.widget.TextView[@text='Send to Bank']

${BANK_KCB_OPTION}                xpath=//android.widget.TextView[@text='KCB Bank']
${BANK_RTGS_OPTION}               xpath=//android.widget.TextView[@text='RTGS']
${BANK_PESALINK_OPTION}           xpath=//android.widget.TextView[@text='PesaLink']
${BANK_GLOBAL_TRANSFER_OPTION}    xpath=//android.widget.TextView[@text='Global Transfer']

${GLOBAL_PAYPAL_OPTION}           xpath=//android.widget.TextView[@text='PayPal']
${GLOBAL_SWIFT_OPTION}            xpath=//android.widget.TextView[@text='SWIFT']
${GLOBAL_WESTERN_UNION_OPTION}    xpath=//android.widget.TextView[@text='Western Union']
${GLOBAL_PAPSS_OPTION}            xpath=//android.widget.TextView[@text='PAPSS']

${KCB_FORM_TITLE}                 xpath=//android.widget.TextView[@text='Send to KCB Bank']
${PESALINK_FORM_TITLE}            xpath=//android.widget.TextView[@text='Send to Pesalink']
${BANK_SEND_TO_SELF_TAB}          xpath=//android.view.View[@text='Send to Self']
${BANK_SEND_TO_OTHER_TAB}         xpath=//android.view.View[@text='Send to Other']
${PESALINK_SEND_TO_BANK_TAB}      xpath=//android.view.View[@text='Send to Bank']
${PESALINK_SEND_TO_MOBILE_TAB}    xpath=//android.view.View[@text='Send to Mobile']

${BANK_ACCOUNT_NUMBER_INPUT}      xpath=//android.widget.TextView[@text='Account Number']/following::android.widget.EditText[1]
${BANK_MOBILE_NUMBER_INPUT}       xpath=//android.widget.TextView[@text='Mobile Number']/following::android.widget.EditText[1]
${PESALINK_MOBILE_PREFIX}         xpath=//android.widget.TextView[@text='+254']
${BANK_REASON_INPUT}              xpath=//android.widget.TextView[@text='Reason for Payment']/following::android.widget.EditText[1]
${BANK_AMOUNT_PLACEHOLDER}        xpath=//android.widget.TextView[@text='Enter Amount']
${BANK_AMOUNT_INPUT}              xpath=//android.widget.TextView[@text='Amount']/following::android.widget.EditText[1]
${BANK_AMOUNT_VALUE}              xpath=//android.widget.TextView[@text='{}']
${BANK_RESOLVED_RECIPIENT}        xpath=//android.widget.TextView[@text='{}']
${BANK_SELECT_ACCOUNT}            xpath=//android.widget.TextView[@text='Select Account']
${BANK_SOURCE_OF_FUNDS_LABEL}     xpath=//android.widget.TextView[@text='Source of Funds']
${BANK_SOURCE_OF_FUNDS_VALUE}     xpath=//android.widget.TextView[@text='Source of Funds']/following::android.widget.TextView[1]
${BANK_SELECT_ACCOUNT_TITLE}      xpath=//android.widget.TextView[@text='Select Account']
${BANK_ACCOUNTS_TAB}              xpath=//android.view.View[@text='Accounts']
${BANK_SOURCE_ACCOUNT_OPTION}     xpath=//android.widget.TextView[contains(@text,'{}')]
${BANK_SELECT_ACCOUNT_CONTINUE}   accessibility_id=continue

${PESALINK_SELECT_BANK}           xpath=//android.widget.TextView[@text='Select Bank']
${BANK_SEARCH_INPUT}              xpath=//android.widget.TextView[@text='Search Bank']/following::android.widget.EditText[1]
${BANK_SEARCH_RESULT}             xpath=//android.widget.TextView[@text='{}']

${BANK_MAKE_PAYMENT_BUTTON}       accessibility_id=makePayment
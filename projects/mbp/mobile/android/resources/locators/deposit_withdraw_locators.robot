*** Settings ***
Documentation    Deposit & Withdraw locators.
...              This screen is a Vue WebView, so fields are located relative to their
...              labels rather than by id, which renumbers as tabs switch.


*** Variables ***
${DEPOSIT_WITHDRAW_TILE}           xpath=//android.widget.TextView[@text='Deposit & Withdraw']

${DEPOSIT_TAB}                     xpath=//android.view.View[@text='Deposit']
${WITHDRAW_TAB}                    xpath=//android.view.View[@text='Withdraw']

${DEPOSIT_SOURCE_LABEL}            xpath=//android.widget.TextView[@text='Source of Funds']
${DEPOSIT_SOURCE_MOBILE_NUMBER}    xpath=//android.widget.TextView[@text='Source of Funds']/following::android.widget.TextView[1]
${DEPOSIT_FUNDS_TO_LABEL}          xpath=//android.widget.TextView[@text='Deposit Funds To']
${DEPOSIT_TARGET_ACCOUNT}          xpath=//android.widget.TextView[@text='Deposit Funds To']/following::android.widget.TextView[1]

${WITHDRAW_SOURCE_ACCOUNT}         xpath=//android.widget.TextView[@text='Source of Funds']/following::android.widget.TextView[1]
${WITHDRAW_OPTION_LABEL}           xpath=//android.widget.TextView[@text='Withdraw Option']
${WITHDRAW_SELECTED_OPTION}        xpath=//android.widget.TextView[@text='Withdraw Option']/following::android.widget.TextView[1]
${WITHDRAW_AGENT_NUMBER_INPUT}     xpath=//android.widget.TextView[@text='Enter Agent Number']/following::android.widget.EditText[1]

${AMOUNT_PLACEHOLDER}              xpath=//android.widget.TextView[@text='Enter Amount']
${AMOUNT_INPUT}                    xpath=//android.widget.TextView[@text='KES']/following::android.widget.EditText[1]
${AMOUNT_VALUE}                    xpath=//android.widget.TextView[@text='KES']/following::android.widget.TextView[@text='{}'][1]

${DEPOSIT_WITHDRAW_SUBMIT_BUTTON}    accessibility_id=depositWithdraw

${DEPOSIT_CONFIRM_TITLE}           xpath=//android.widget.TextView[@text='Confirm Summary']
${DEPOSIT_CONFIRM_SOURCE}          xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Source of Funds'][1]/following::android.widget.TextView[1]
${DEPOSIT_CONFIRM_MOBILE_NUMBER}    xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Mobile Number'][1]/following::android.widget.TextView[1]
${DEPOSIT_CONFIRM_RECIPIENT}       xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Recipient'][1]/following::android.widget.TextView[1]
${DEPOSIT_CONFIRM_ACCOUNT_NUMBER}    xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Recipient Account No'][1]/following::android.widget.TextView[1]
${DEPOSIT_CONFIRM_AMOUNT}          xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Amount'][1]/following::android.widget.TextView[1]

${DW_RESULT_SERVICE_TYPE}          xpath=//android.widget.TextView[@text='Service Type']/following::android.widget.TextView[1]
${DW_RESULT_ACCOUNT_NUMBER}        xpath=//android.widget.TextView[@text='Account No']/following::android.widget.TextView[1]
${DW_RESULT_AMOUNT}                xpath=//android.widget.TextView[@text='Amount']/following::android.widget.TextView[1]
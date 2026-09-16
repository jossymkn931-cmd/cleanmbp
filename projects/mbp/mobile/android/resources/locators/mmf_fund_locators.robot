*** Variables ***
${INVEST_HOME_TILE}                 xpath=//android.widget.TextView[@text='Invest']
${INVESTMENT_TITLE}                 xpath=//android.widget.TextView[@text='Investment']
${INVESTMENT_PORTFOLIO_TAB}         xpath=//android.view.View[@text='My Portfolio']
${INVESTMENT_PRODUCTS_TAB}          xpath=//android.view.View[@text='Investments']
${INVESTMENT_FACT_SHEET}            accessibility_id=investmentFactSheet

${PORTFOLIO_FUND_ENTRY}             xpath=//android.widget.TextView[@text='{}']
${PORTFOLIO_EMPTY_MESSAGE}          xpath=//android.widget.TextView[contains(@text,'no investment')]

${MMF_PRODUCT_TITLE}                xpath=//android.widget.TextView[@text='{} Money Market Fund']
${MMF_GET_STARTED_BUTTON}           accessibility_id=getStarted_{} Money Market Fund

# The label carries a private use glyph prefix, so it can only be matched partially.
${MMF_TERMS_CHECKBOX}               xpath=//android.widget.CheckBox[contains(@text,'Accept Terms')]
${MMF_ACCEPT_CONTINUE_BUTTON}       accessibility_id=acceptContinue
${MMF_TERMS_AGREE_BUTTON}           accessibility_id=agree

${MMF_DETAILS_TITLE}                xpath=//android.widget.TextView[@text='MMF Details']
${MMF_NAME_PROMPT}                  xpath=//android.widget.TextView[@text='Give Your Money Market Fund A Name']
${MMF_NAME_INPUT}                   xpath=//android.widget.EditText
${MMF_DESTINATION_ACCOUNT_LABEL}    xpath=//android.widget.TextView[@text='Destination Account']
# The dropdown reads 'Select Account' until an account is chosen and the account number
# afterwards, so it is located by where it sits rather than by what it says.
${MMF_DESTINATION_ACCOUNT_DROPDOWN}    xpath=//android.widget.TextView[@text='Destination Account']/following::android.widget.TextView[2]
${MMF_DETAILS_CONTINUE_BUTTON}      accessibility_id=continue

# 'Select Account' is also what the closed dropdown reads, so the sheet is recognised
# by its account rows rather than by its title.
${ACCOUNT_PICKER_BALANCE_ROW}       xpath=//android.widget.TextView[starts-with(@text,'Available Balance: {}')]
# Rows are only distinguishable by the currency on their balance line. The radio ids
# are positional, so they move with the account order and cannot be used directly.
${ACCOUNT_PICKER_ROW_RADIO}         xpath=//android.widget.TextView[starts-with(@text,'Available Balance: {}')]/following::android.widget.RadioButton[1]
${ACCOUNT_PICKER_CONTINUE_BUTTON}   accessibility_id=continue

${MMF_SUMMARY_TITLE}                xpath=//android.widget.TextView[@text='Confirm Summary']
${MMF_SUMMARY_NAME}                 xpath=//android.widget.TextView[@text='MMF Name']/following::android.widget.TextView[1]
${MMF_SUMMARY_CURRENCY}             xpath=//android.widget.TextView[@text='MMF Currency']/following::android.widget.TextView[1]
${MMF_SUMMARY_PAYEE}                xpath=//android.widget.TextView[@text='Payee']/following::android.widget.TextView[1]
# Destination Account also labels the details page beneath the sheet, so the summary
# copy is the later of the two.
${MMF_SUMMARY_ACCOUNT}              xpath=(//android.widget.TextView[@text='Destination Account'])[last()]/following::android.widget.TextView[1]
# The summary opens as a sheet over the details page, so both carry a continue button.
${MMF_SUMMARY_CONTINUE_BUTTON}      xpath=(//android.widget.Button[@content-desc='continue'])[last()]
${MMF_SUMMARY_CANCEL_BUTTON}        accessibility_id=cancel

${MMF_RESULT_TITLE}                 xpath=//android.widget.TextView[@text='Request Submitted']
${MMF_RESULT_STATUS}                xpath=//android.widget.TextView[@text='Transaction Status']/following::android.widget.TextView[1]
${MMF_RESULT_SERVICE_TYPE}          xpath=//android.widget.TextView[@text='Service Type']/following::android.widget.TextView[1]
${MMF_RESULT_DATE}                  xpath=//android.widget.TextView[@text='Transaction Date']/following::android.widget.TextView[1]
${MMF_RESULT_REFERENCE}             xpath=//android.widget.TextView[@text='Transaction ID']/following::android.widget.TextView[1]
${MMF_RESULT_ACCOUNT}               xpath=(//android.widget.TextView[@text='Destination Account'])[last()]/following::android.widget.TextView[1]
${MMF_RESULT_FEE}                   xpath=//android.widget.TextView[@text='Transaction Fee']/following::android.widget.TextView[1]

${MMF_SUCCESS_TITLE}                xpath=//android.widget.TextView[@text='Success']
# Okay on the success dialog and Done on the receipt beneath it share the same id.
${MMF_SUCCESS_OKAY_BUTTON}          xpath=(//android.widget.Button[@content-desc='done'])[last()]
${MMF_RESULT_DONE_BUTTON}           accessibility_id=done

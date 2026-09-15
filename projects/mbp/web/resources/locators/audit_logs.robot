*** Variables ***
# Navigation menu
${AUDIT_LOGS_MENU}                 xpath=//span[normalize-space()='Audit Logs']
${APP_JOURNAL_MENU}                xpath=//span[normalize-space()='APP Journal']
${USSD_JOURNAL_MENU}               xpath=//span[normalize-space()='USSD Journal']
${OPERATOR_JOURNAL_MENU}           xpath=//span[normalize-space()='Operator Journal']

# Common page elements
${AUDIT_LOGS_SEARCH_BUTTON}        xpath=//span[normalize-space()='Search']
${AUDIT_LOGS_FIRST_TABLE_ROW}      xpath=(//tr[contains(@class,'el-table__row')])[1]
${AUDIT_LOGS_FIRST_ROW_RADIO}      xpath=//label[@data-test-id='table-radio-0']//span[contains(@class,'el-radio__inner')]
# APP/USSD use "Details"; Operator Journal uses "Detail"
${AUDIT_LOGS_DETAILS_BUTTON}       xpath=//span[normalize-space()='Details' or normalize-space()='Detail']

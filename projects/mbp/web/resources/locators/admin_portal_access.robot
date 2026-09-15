*** Variables ***
# Navigation menu - Report
${REPORT_MENU}                    xpath=//span[normalize-space()='Report']
${ONLINE_REPORT_SUBMENU}          xpath=//span[normalize-space()='Online Report']
${TRANSACTION_REPORTS_MENU}       xpath=//span[normalize-space()='Transaction Reports']

# Transaction Reports page elements
${SEARCH_BUTTON}                  xpath=//span[normalize-space()='Search']
${TABLE_HEADER}                   xpath=//*[@id='transactionReportsTable']//th//div[normalize-space()='MBP Reference No.']
${FIRST_TABLE_ROW}                xpath=//*[@id='transactionReportsTable']//tbody//tr[1]
${FIRST_ROW_RADIO_BUTTON}         xpath=//*[@id='transactionReportsTable']//tbody//tr[1]//span[@class='el-radio__inner']
${GENERATE_BUTTON}                xpath=//span[normalize-space()='Generate']

# Transaction Reports - type dropdown, date range and detail/generate flow
# NOTE: use the stable placeholder, not the dynamic Element UI id (el-id-xxxx changes each session)
# Scope to the main search form (exclude the Generate dialog which has its own Transaction type input)
${TRANSACTION_TYPE_INPUT}         xpath=//input[@placeholder='Transaction type'][not(ancestor::div[contains(@class,'el-dialog')])]
${REPORT_DATE_START_INPUT}        xpath=(//input[contains(@class,'el-range-input')])[1]
${REPORT_DATE_END_INPUT}          xpath=(//input[contains(@class,'el-range-input')])[2]
${DETAIL_BUTTON}                  xpath=//span[normalize-space()='Detail']
${DETAILS_CANCEL_BUTTON}          xpath=//button[@data-test-id='cancel-btn']
${GENERATE_SAVE_BUTTON}           xpath=//button[@data-test-id='save-btn']
# Date picker calendar cells
${REPORT_DATE_PICKER_TABLE}       xpath=(//table[@class='el-date-table'])[1]
${REPORT_DATE_FIRST_DAY_CELL}     xpath=(//table[@class='el-date-table'])[1]//td[contains(@class,'available') and not(contains(@class,'prev-month'))][.//span[normalize-space()='1']]
${REPORT_DATE_TODAY_CELL}         xpath=//td[contains(@class,'today') and not(contains(@class,'disabled'))]

# Service Request Reports navigation and elements
# Match the menu entry by its visible text; allow surrounding tooltip/span wrappers
${SERVICE_REQUESTS_MENU}          xpath=//span[contains(normalize-space(),'Service Request Reports')]
${SR_TABLE_HEADER}                xpath=//*[@id='serviceRequestReportsTable']//th//div[contains(translate(normalize-space(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'request')]
${SR_FIRST_TABLE_ROW}             xpath=//*[@id='serviceRequestReportsTable']//tbody//tr[1]
${SR_FIRST_ROW_RADIO_BUTTON}      xpath=//*[@id='serviceRequestReportsTable']//tbody//tr[1]//span[@class='el-radio__inner']
${SR_SERVICE_TYPE_INPUT}          xpath=//input[@placeholder='Service type'][not(ancestor::div[contains(@class,'el-dialog')])]
${SR_SERVICE_TYPE_LABEL}          xpath=//span[normalize-space()='Service type:']
${SR_SERVICE_TYPE_SELECT}         xpath=//span[normalize-space()='Service type:']/following::div[contains(@class,'el-select')][1]
${SR_REGION_INPUT}                xpath=//input[@placeholder='Region'][not(ancestor::div[contains(@class,'el-dialog')])]
${SR_BRANCH_DAO_INPUT}            xpath=//input[@placeholder='Branch DAO'][not(ancestor::div[contains(@class,'el-dialog')])]

# Navigation menu - User Guide
${SYSTEM_ADMIN_MENU}              xpath=//span[normalize-space()='System administration']
${USER_GUIDE_MENU}                xpath=//span[normalize-space()='User Guide']

# User guide page elements
${USER_GUIDE_TABLE_HEADER}        xpath=//th//div[normalize-space()='Guide No.']
${UPLOAD_BUTTON}                  xpath=//span[normalize-space()='Upload']
${DOWNLOAD_BUTTON}                xpath=//span[normalize-space()='Download']
${PREVIEW_BUTTON}                 xpath=//span[normalize-space()='Preview']
${UPLOAD_DIALOG_TITLE}            xpath=//div[contains(@class,'el-dialog__header')]//span[normalize-space()='Upload']
${UPLOAD_FILE_INPUT}              xpath=//div[contains(@class,'el-dialog__body')]//input[@type='file']
${UPLOAD_INPUT_BOX}              xpath=//div[contains(@class,'el-dialog__body')]//div[contains(@class,'el-input')]//input[not(@type='file')]
${FILE_VERSION_INPUT}             xpath=//input[@placeholder='File version']
${TITLE_INPUT}                    xpath=(//input[@placeholder='Title'])[last()]
${NARRATION_INPUT}                xpath=//textarea[@placeholder='Narration']
${SUBMIT_BUTTON}                  xpath=//span[normalize-space()='Submit']
${CANCEL_BUTTON}                  xpath=//span[normalize-space()='Cancel']
${CLEAR_BUTTON}                   xpath=//i[@class='el-icon el-input__icon el-range__close-icon']
${USER_GUIDE_DATE_INPUT}          xpath=//div[contains(@class,'el-date-editor')]
${USER_GUIDE_SEARCH_BUTTON}       xpath=//span[normalize-space()='Search']
${USER_GUIDE_FIRST_ROW_RADIO}     xpath=//tbody//tr[1]//span[@class='el-radio__inner']

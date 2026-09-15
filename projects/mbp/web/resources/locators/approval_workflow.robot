*** Variables ***
# Customer Profile - Search locators
${CUSTOMER_PROFILE_MOBILE_NO_INPUT}   xpath=//input[@placeholder='Mobile No.']
${CUSTOMER_PROFILE_SEARCH_BUTTON}     xpath=//span[normalize-space()='Search']
${CUSTOMER_PROFILE_FIRST_ROW}         xpath=//table//tbody//tr[1]
${SUCCESS_MESSAGE}                    xpath=//div[contains(@class,'el-message')]

# Customer Profile Update locators
${UPDATE_PROFILE_BUTTON}              xpath=//button[@data-test-id='updateCus-btn']
${NARRATION_LABEL}                    xpath=//span[normalize-space()='Narration:']
${NARRATION_TEXTAREA}                 xpath=//textarea[@placeholder='Narration']
${UPDATE_PROFILE_SUBMIT_BUTTON}       xpath=//span[normalize-space()='Submit']

# Workflow locators
${WORKFLOW_MENU}                      xpath=//span[normalize-space()='Workflow']
${SUBMITTED_LIST_MENU}               xpath=//span[normalize-space()='Submitted list']
${WORKFLOW_DETAILS_BUTTON}            xpath=//span[normalize-space()='Details']
${SUBMITTED_LIST_SUBMIT_BUTTON}       xpath=//span[normalize-space()='Submit']
${PENDING_AUTHORIZE_TASK}             xpath=//span[contains(text(),'Pending authorize-task to do')]
${WORKFLOW_SEARCH_BUTTON}             xpath=//span[normalize-space()='Search']
${WORKFLOW_CHECK_BUTTON}              xpath=//span[normalize-space()='Check']
${WORKFLOW_APPROVE_BUTTON}            xpath=//span[normalize-space()='Approve']
${APPROVER_COMMENT_TEXTAREA}          xpath=(//textarea[contains(@class,'el-textarea__inner')])[last()]
${WORKFLOW_FIRST_ITEM_RADIO}          xpath=//label[@data-test-id='table-radio-0']//span[contains(@class,'el-radio__inner')]
${PENDING_APPROVAL_ITEM_RADIO}       xpath=//tr[contains(.,'PENDING_APPROVED')]//label//span[contains(@class,'el-radio__inner')]
${WORKFLOW_FIRST_ROW}                 xpath=(//tr[contains(@class,'el-table__row')])[1]

# Logout/Login locators
${PROFILE_NAME}                       xpath=//p[normalize-space()='KCB.Bank']
${LOGOUT_MENU_ITEM}                   xpath=//li[normalize-space()='Logout']
${LOGOUT_CONFIRM_BUTTON}              xpath=//span[normalize-space()='Confirm']
${SIGN_IN_BUTTON}                     xpath=//span[normalize-space()='Sign in with Password']

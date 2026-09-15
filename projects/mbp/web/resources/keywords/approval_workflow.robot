*** Settings ***
Documentation     Approval Workflow - Maker and Checker operations
Library           Browser
Resource          ../locators/customer_profile.robot
Resource          ../locators/approval_workflow.robot
Resource          ../locators/login.robot
Resource          customer_profile.robot

*** Keywords ***
Search And Update Customer Profile
    [Documentation]    Search for a customer by mobile number and click Update Profile
    [Arguments]    ${mobile_no}
    Fill Text    ${CUSTOMER_PROFILE_MOBILE_NO_INPUT}    ${mobile_no}
    Click    ${CUSTOMER_PROFILE_SEARCH_BUTTON}
    Wait For Elements State    ${UPDATE_PROFILE_BUTTON}    visible    timeout=30s
    Click    ${UPDATE_PROFILE_BUTTON}
    Wait For Elements State    ${NARRATION_TEXTAREA}    visible    timeout=15s

Add Narration
    [Documentation]    Add narration text to the customer profile update
    [Arguments]    ${narration_text}
    Click    ${NARRATION_TEXTAREA}
    Fill Text    ${NARRATION_TEXTAREA}    ${narration_text}

Submit Customer Profile Update
    [Documentation]    Click Submit to save the profile update
    Click    ${UPDATE_PROFILE_SUBMIT_BUTTON}
    Wait For Elements State    ${SUCCESS_MESSAGE}    visible    timeout=10s

Logout
    [Documentation]    Click logout button via profile menu and confirm
    Click    ${PROFILE_NAME}
    Click    ${LOGOUT_MENU_ITEM}
    Click    ${LOGOUT_CONFIRM_BUTTON}
    TRY
        Wait For Elements State    ${LOGIN_STAFF_NO_FIELD}    visible    timeout=15s
    EXCEPT
        Wait For Elements State    ${SIGN_IN_BUTTON}    visible    timeout=15s
    END

Navigate To Workflow
    [Documentation]    Navigate to Workflow menu
    Wait For Elements State    ${WORKFLOW_MENU}    visible    timeout=15s
    Click    ${WORKFLOW_MENU}
    Wait For Elements State    ${PENDING_AUTHORIZE_TASK}    visible    timeout=20s

Navigate To Submitted List
    [Documentation]    Open Workflow menu and go to the Submitted list
    Wait For Elements State    ${WORKFLOW_MENU}    visible    timeout=15s
    Click    ${WORKFLOW_MENU}
    Wait For Elements State    ${SUBMITTED_LIST_MENU}    visible    timeout=20s
    Click    ${SUBMITTED_LIST_MENU}
    Click   ${WORKFLOW_SEARCH_BUTTON}
   # Wait For Elements State    ${WORKFLOW_SEARCH_BUTTON}    visible    timeout=15s

Submit From Submitted List
    [Documentation]    Search, select the pending approval item, open Details and Submit it
    Click    ${WORKFLOW_SEARCH_BUTTON}
    Wait For Elements State    ${PENDING_APPROVAL_ITEM_RADIO}    visible    timeout=30s
    Click    ${PENDING_APPROVAL_ITEM_RADIO}
    Click    ${WORKFLOW_DETAILS_BUTTON}
    Wait For Elements State    ${SUBMITTED_LIST_SUBMIT_BUTTON}    visible    timeout=15s
    Click    ${SUBMITTED_LIST_SUBMIT_BUTTON}
    Wait For Elements State    ${SUCCESS_MESSAGE}    visible    timeout=15s

Click Pending Authorize Task
    [Documentation]    Click on the Pending authorize-task to do item
    Click    ${PENDING_AUTHORIZE_TASK}
    Wait For Elements State    ${WORKFLOW_SEARCH_BUTTON}    visible    timeout=15s

Search Workflow Tasks
    [Documentation]    Click Search in the workflow page
    Click    ${WORKFLOW_SEARCH_BUTTON}
    Wait For Elements State    ${WORKFLOW_FIRST_ROW}    visible    timeout=30s

Select First Workflow Item
    [Documentation]    Select the first item in the workflow task list
    Click    ${WORKFLOW_FIRST_ITEM_RADIO}

Check Workflow Item
    [Documentation]    Click Check to verify the workflow item
    Click    ${WORKFLOW_CHECK_BUTTON}
    Wait For Elements State    ${WORKFLOW_APPROVE_BUTTON}    visible    timeout=15s

Add Approver Comment
    [Documentation]    Add the approver's comment on the workflow approval page
    [Arguments]    ${comment_text}
    Wait For Elements State    ${APPROVER_COMMENT_TEXTAREA}    visible    timeout=15s
    Click    ${APPROVER_COMMENT_TEXTAREA}
    Fill Text    ${APPROVER_COMMENT_TEXTAREA}    ${comment_text}

Approve Workflow Item
    [Documentation]    Click Approve to approve the workflow item
    Click    ${WORKFLOW_APPROVE_BUTTON}
    Wait For Elements State    xpath=//div[contains(@class,'el-message')]    visible    timeout=10s

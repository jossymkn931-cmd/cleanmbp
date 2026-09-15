*** Settings ***
Documentation     Approval Workflow - Maker and Checker tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/approval_workflow.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Maker Checker Approval Workflow
    [Documentation]    End-to-end test: Maker submits profile update, Checker approves it
    [Tags]    smoke    approval_workflow    e2e    AdoTestCaseId=256563
 
    Ensure Admin Logged In

    Navigate To Customer Profile
    Search And Update Customer Profile    ${CUSTOMER_PROFILE_SEARCH_NO}
    Add Narration    E2E test: maker submission for checker approval
    Submit Customer Profile Update
    Navigate To Submitted List
    Submit From Submitted List
    Logout
    Ensure Checker Logged In
    Navigate To Workflow
    Click Pending Authorize Task
    Search Workflow Tasks
    Select First Workflow Item
    Check Workflow Item
    Add Approver Comment    E2E test approval - reviewed and approved
    Approve Workflow Item

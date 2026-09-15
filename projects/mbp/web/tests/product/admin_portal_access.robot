*** Settings ***
Documentation     Admin Portal - Access Management tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/admin_portal_access.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Admin Can Upload And Manage User Guide
    [Documentation]    Verify admin can view, upload and manage the user guide/manual
    [Tags]    smoke    admin_portal    user_guide    AdoTestCaseId=255866
    Ensure Admin Logged In
    Navigate To User Guide
    User Guide Page Should Be Displayed
    Verify Upload Dialog Opens

Admin Can Download User Guide
    [Documentation]    Verify admin can clear dates, search, select a guide and download it
    [Tags]    smoke    admin_portal    user_guide    AdoTestCaseId=275506
    Ensure Admin Logged In
    Navigate To User Guide
    Clear Dates And Search User Guide
    Select First User Guide And Download

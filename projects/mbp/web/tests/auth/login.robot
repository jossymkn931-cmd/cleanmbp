*** Settings ***
Documentation     Smoke tests for admin login scenarios
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Admin Can Login Successfully
    [Documentation]    Verify that admin can successfully login to the admin portal
    [Tags]    smoke  ui   auth  positive    AdoTestCaseId=256547
    
    Ensure Admin Logged In
    
    Dashboard Should Be Displayed

Admin Cannot Login With Invalid Credentials
    [Documentation]    Verify that invalid credentials display error message
    [Tags]    smoke    auth    negative    AdoTestCaseId=257411 
    
    Attempt Login    invalid_user    wrong_password
    
    Verify Login Error Message    Staff information does not exist

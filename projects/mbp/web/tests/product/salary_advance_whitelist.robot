*** Settings ***
Documentation     Salary Advance Whitelist management tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/salary_advance_whitelist.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Admin Can Whitelist Customers For Salary Advance Service
    [Documentation]    Verify admin can navigate to salary advance whitelist, view records, and change customer status
    [Tags]    smoke    product    whitelist    AdoTestCaseId=257284

    Ensure Admin Logged In
    
    Navigate To Salary Advance Whitelist
    Click View Button
    Search And Wait For Results
    Click First Customer Record
    Click Change Status Button
    Select First Status Option
    Submit Status Change
    

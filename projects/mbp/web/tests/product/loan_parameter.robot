*** Settings ***
Documentation     Loan Parameter management tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/loan_parameter.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Admin Can Access Loan Parameter Page
    [Documentation]    Verify admin can navigate to Loan Parameter page and view the list
    [Tags]    smoke    product    loan_parameter    AdoTestCaseId=257283
    Ensure Admin Logged In
    Navigate To Loan Parameter Page
    Search And Wait For Results
    Loan Parameter Page Should Be Displayed

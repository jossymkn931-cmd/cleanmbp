*** Settings ***
Documentation     Admin Portal Branch Operations - Transaction History tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/transaction_history.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Admin Can View Loan Disbursement Transaction Records
    [Documentation]    Verify admin can navigate to Loan Disbursement history and view records
    [Tags]    smoke    branch_operations    transaction_history    AdoTestCaseId=255859
    Ensure Admin Logged In
    Navigate To Loan Disbursement History
    Search And Verify Transaction Records

Admin Can View Savings Transaction Records
    [Documentation]    Verify admin can navigate to Savings transaction history and view records
    [Tags]    smoke    branch_operations    transaction_history    AdoTestCaseId=255863
    Ensure Admin Logged In
    Navigate To Savings Transaction History
    Search And Verify Transaction Records

Admin Can View Payment Transaction Records
    [Documentation]    Verify admin can navigate to Payment transaction history and view records
    [Tags]    smoke    branch_operations    transaction_history    AdoTestCaseId=255860
    Ensure Admin Logged In
    Navigate To Payment Transaction History
    Search And Verify Transaction Records

Admin Can View Transfer Transaction Records
    [Documentation]    Verify admin can navigate to Transfer transaction history and view records
    [Tags]    smoke    branch_operations    transaction_history    AdoTestCaseId=255861
    Ensure Admin Logged In
    Navigate To Transfer Transaction History
    Search And Verify Transaction Records

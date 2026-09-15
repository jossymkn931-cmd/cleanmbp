*** Settings ***
Documentation     Audit Logs - APP, USSD and Operator Journal tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/audit_logs.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Admin Can View App Journal Logs
    [Documentation]    Access APP Journal, search, and wait for log details to appear
    [Tags]    smoke    workflow    audit_logs  e2e    app_journal   AdoTestCaseId=256567
    Ensure Admin Logged In
    Navigate To App Journal
    Search And Wait For Journal Logs

Admin Can View Ussd Journal Logs
    [Documentation]    Access USSD Journal, search, and wait for log details to appear
    [Tags]    smoke    workflow    audit_logs  e2e    ussd_journal   AdoTestCaseId=256568
    Ensure Admin Logged In
    Navigate To Ussd Journal
    Search And Wait For Journal Logs

Admin Can View Operator Journal Logs
    [Documentation]    Access Operator Journal, search, and wait for log details to appear
    [Tags]    smoke    workflow    audit_logs  e2e    operator_journal   AdoTestCaseId=256569
    Ensure Admin Logged In
    Navigate To Operator Journal
    Search And Wait For Journal Logs

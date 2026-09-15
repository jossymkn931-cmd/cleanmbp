*** Settings ***
Documentation     Service Request Reports tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/admin_portal_access.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Service Request Reports End-To-End
    [Documentation]    Full end-to-end validation: filters, search, columns, generate, detail view and print
    [Tags]    smoke    reports    service_request    AdoTestCaseId=255862
    Ensure Admin Logged In
    Navigate To Service Request Reports
    Service Request Search Criteria Should Be Available
    Set Report Date Range One Month To Date
    Search And Select First Service Request Record
    Verify Service Request Report Columns
    Scroll To Element    ${SR_TABLE_HEADER}
    Wait For Elements State    ${DETAIL_BUTTON}    visible    timeout=10s
    Click    ${DETAIL_BUTTON}
    Print Service Request Details
    Click    ${GENERATE_BUTTON}
    Wait For Elements State    ${GENERATE_SAVE_BUTTON}    visible    timeout=15s
    Click    ${GENERATE_SAVE_BUTTON}

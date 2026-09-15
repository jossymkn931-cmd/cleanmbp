*** Settings ***
Documentation     Transaction Reports tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/admin_portal_access.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers

*** Test Cases ***
Admin Can Generate Report On Demand
    [Documentation]    Verify admin can navigate to Transaction Reports and generate report if records exist
    [Tags]    smoke    reports    transaction    AdoTestCaseId=255865

   
    Ensure Admin Logged In
    Navigate To Transaction Reports
    Set Report Date Range One Month To Date
    Search And Select First Report Record
    Generate Report

Admin Can Generate Reports For Different Transaction Types
    [Documentation]    For each transaction type, set a one-month-to-date range and search. When a
    ...    record is listed, open its Detail, close it, then Generate and submit the report.
    [Tags]    reports    transaction    transaction_type    AdoTestCaseId=255865
    [Setup]    Run Keywords    Ensure Admin Logged In    AND    Navigate To Transaction Reports
    [Template]    Generate Report For Transaction Type
    3A01-Buy Goods
    3201-Send to Mobile(Self)
    3202-Intra bank transfer to self
    3203-Inter bank transfer
    3205-Top-up bank account by card
    3206-Top-up bank account by mobile wallet
    3801-Request transfer funds
    5001-Deposit
    5200-Create account and deposit

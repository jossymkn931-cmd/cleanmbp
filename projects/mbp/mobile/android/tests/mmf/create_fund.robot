*** Settings ***
Documentation    Creating Money Market Fund investment accounts
Resource         ../../resources/Keywords/common.robot
Resource         ../../resources/Keywords/login.robot
Resource         ../../resources/Keywords/mmf_fund.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Open A Fresh Investments Catalogue
Test Teardown     Take Screenshot On Failure

Force Tags        investments    mmf


*** Test Cases ***
Create A KES Money Market Fund
    [Documentation]    An account holder can apply for a shilling money market fund,
    ...                paying withdrawals into a shilling account.
    [Tags]    kes    AdoTestCaseId=

    Apply For A Money Market Fund    KES


Create A USD Money Market Fund
    [Documentation]    An account holder can apply for a dollar money market fund,
    ...                paying withdrawals into a dollar account rather than the
    ...                shilling account the form defaults to.
    [Tags]    usd    AdoTestCaseId=

    Apply For A Money Market Fund    USD


*** Keywords ***
Apply For A Money Market Fund
    [Arguments]    ${currency}

    ${fund_name}=    Generate Fund Name    ${currency} MMF
    Start Money Market Fund Application    ${currency}
    Accept Money Market Fund Terms
    Name The Money Market Fund    ${fund_name}
    ${account}=    Select Destination Account    ${currency}
    Continue To Summary
    Verify Money Market Fund Summary    ${fund_name}    ${currency}    ${account}
    Confirm Money Market Fund Application
    ${reference}=    Verify Money Market Fund Was Submitted    ${account}
    Log    Applied for ${fund_name} into ${account} under reference ${reference}
    Dismiss Money Market Fund Receipt
    Portfolio Should Contain Fund    ${fund_name}

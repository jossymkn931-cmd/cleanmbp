*** Settings ***
Documentation     Recent mobile transactions and transfer receipt view tests on Home
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/transactions.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can View Recent Succeeded Transactions And Receipt
    [Documentation]    Verify recent succeeded mobile transactions can be opened from Home
    ...                via Recent Mobile Transactions View all, details viewed, and the
    ...                transfer receipt opened for viewing.
    [Tags]    smoke    home    transactions    receipt    positive    journey    AdoTestCaseId=256666

    Login With Saved Number    ${MOBILE_PIN}
    Open Recent Mobile Transactions
    Open First Successful Recent Transaction
    Verify Successful Transaction Details Are Shown
    View Transfer Receipt
    Verify Transfer Receipt Is Visible

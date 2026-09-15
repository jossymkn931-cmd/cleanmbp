*** Settings ***
Documentation     MMF Calculator end to end tests, one per investment type
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/mmf.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Template     Project An MMF Investment
Test Setup        Ensure MMF Calculator Is Open
Test Teardown     Take Screenshot On Failure


*** Test Cases ***                        INVESTMENT TYPE    CURRENCY
User Can Project An MMF KES Investment    MMF KES            KES
    [Documentation]    Walk the calculator from an empty form through to a projected
    ...                balance, an interest figure and the rate it was earned at.
    [Tags]    smoke    calculator    mmf    positive    AdoTestCaseId=257607

User Can Project An MMF USD Investment    MMF USD            $
    [Tags]    calculator    mmf    positive    AdoTestCaseId=257607
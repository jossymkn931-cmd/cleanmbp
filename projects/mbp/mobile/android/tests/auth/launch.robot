*** Settings ***
Documentation     Android APK launch smoke test
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
Android App Can Launch
    [Documentation]    Verify that the Android application launches and shows the login screen.
    ...                The launch is the Test Setup, so this test is assertion only.
    [Tags]    smoke    mobile    postitive    AdoTestCaseId=293252

    Verify Saved Number Login Screen Is Visible
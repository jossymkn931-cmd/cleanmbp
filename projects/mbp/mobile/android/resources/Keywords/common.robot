*** Settings ***
Documentation    Common Android mobile keywords for Appium sessions
Library          AppiumLibrary


*** Keywords ***
Open Mobile Application
    [Arguments]    ${package}    ${activity}    ${device}    ${platform}    ${version}
    [Documentation]    Open the installed Android application using Appium

    Open Application
    ...    ${APPIUM_SERVER_URL}
    ...    platformName=${platform}
    ...    platformVersion=${version}
    ...    deviceName=${device}
    ...    udid=${UDID}
    ...    appPackage=${package}
    ...    appActivity=${activity}
    ...    appWaitPackage=${package}
    ...    appWaitActivity=${APP_WAIT_ACTIVITY}
    ...    appWaitDuration=40000
    ...    automationName=${AUTOMATION_NAME}
    ...    noReset=${TRUE}
    ...    forceAppLaunch=${TRUE}
    ...    autoGrantPermissions=${TRUE}
    ...    ignoreHiddenApiPolicyError=${TRUE}
    ...    skipUnlock=${TRUE}
    ...    autoLaunch=${TRUE}
    ...    newCommandTimeout=120


Take Mobile Screenshot
    [Arguments]    ${file_name}=mobile_screenshot.png
    [Documentation]    Capture mobile screenshot safely
    Run Keyword And Ignore Error    AppiumLibrary.Capture Page Screenshot    ${file_name}


Take Screenshot On Failure
    [Documentation]    Capture screenshot only when test fails
    Run Keyword If Test Failed    Take Mobile Screenshot


Restart Application
    [Documentation]    Return the app to the login screen without recreating the session.
    ...
    ...                The suite opens a single Appium session, so without this each test
    ...                would resume wherever the previous one stopped.

    Terminate Application    ${APP_PACKAGE}
    Activate Application     ${APP_PACKAGE}


Close Mobile Application
    [Documentation]    Close mobile application safely
    Run Keyword And Ignore Error    Close Application


Field Should Contain Value
    [Arguments]    ${locator}    ${expected}    ${field_name}
    [Documentation]    Verify a typed value landed in the intended field.
    ...                Inputs are located from their labels, so a value can land in a
    ...                neighbouring field while the form is still rendering.

    ${actual}=    Get Text    ${locator}
    Should Be Equal    ${actual}    ${expected}
    ...    msg=Expected the ${field_name} field to contain '${expected}' but it contains '${actual}'
    ...    values=${FALSE}
*** Settings ***
Documentation     Mobile Android UI tests for saved number and PIN login scenarios
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Launch Login Screen
    [Documentation]    Verify that the saved number login screen is displayed.
    ...                The app start is the Test Setup, so this test is assertion only.
    [Tags]    smoke    auth    mobile    AdoTestCaseId=257901

    Verify Saved Number Login Screen Is Visible


User Can Navigate To Pin Screen
    [Documentation]    Verify that tapping Log in as saved number opens the PIN screen
    [Tags]    smoke    auth    mobile    AdoTestCaseId=256346

    # Arrange
    Verify Saved Number Login Screen Is Visible

    # Act
    Tap Login As Saved Number

    # Assert
    Verify Pin Screen Is Visible


User Can Return From Pin Screen
    [Documentation]    Verify that Android back returns to saved-number login.
    [Tags]    smoke    auth    navigation    mobile    AdoTestCaseId=255943

    # Arrange
    Open Pin Screen

    # Act and assert
    Return To Saved Number Login


User Can Login Successfully
    [Documentation]    Verify that user can login using saved number and PIN
    [Tags]    smoke    auth    positive    mobile    AdoTestCaseId=258034

    # Arrange
    Open Pin Screen

    # Act
    Enter Mobile Pin    ${MOBILE_PIN}

    # Assert
    Verify Dashboard Is Displayed


User Can Reveal Account Balance
    [Documentation]    Verify that tapping the eye icon reveals the masked account balance
    [Tags]    smoke    dashboard    positive    mobile   AdoTestCaseId=257531

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}

    # Act
    Show Account Balance

    # Assert
    Verify Account Balance Is Displayed


User Cannot Login With Invalid Pin
    [Documentation]    Verify that invalid PIN displays error message.
    ...
    ...                WARNING: every run consumes one of the account's PIN attempts and
    ...                will eventually lock it out. Excluded from the smoke tag on purpose.
    [Tags]    auth    negative    mobile    lockout    AdoTestCaseId=257504

    # Arrange
    Open Pin Screen

    # Act
    Enter Mobile Pin    0000

    # Assert
    Verify Login Error Message
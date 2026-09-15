*** Settings ***
Documentation     QR Code tests
...
...               Receiving a payment by QR needs a second handset to scan the code,
...               so these cover the requester's side end to end.
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/qr_code.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Qr Code
    [Documentation]    Verify the QR screen opens from the Home header against the
    ...                customer's account.
    [Tags]    smoke    qr-code    navigation    ADoTestCaseId=256347

    Login With Saved Number    ${MOBILE_PIN}
    Open Qr Code
    Verify My Qr Is Displayed
    Verify Qr Source Account Is    ${ACCOUNT_MASKED}


User Can Generate A Qr Code For An Amount
    [Documentation]    Verify a QR code is generated end to end for a set amount.
    [Tags]    qr-code    positive    AdoTestCaseId=256354

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Qr Code
    Verify Qr Source Account Is    ${ACCOUNT_MASKED}

    # Act
    Open Set Amount
    Enter Qr Amount    ${QR_AMOUNT}    ${QR_AMOUNT_ON_FORM}
    Tap Generate Qr

    # Assert
    Verify Qr Was Generated For    ${ACCOUNT_MASKED}    ${QR_EXPECTED_AMOUNT}


User Can Open The Qr Scanner
    [Documentation]    Verify the scanner opens with the camera ready to detect a code.
    ...
    ...                Completing a scan needs a second handset displaying a code, so
    ...                this covers the payer's side up to the live camera.
    [Tags]    qr-code    scan    navigation    AdoTestCaseId=256352

    Login With Saved Number    ${MOBILE_PIN}
    Open Qr Code
    Select Scan Qr Tab
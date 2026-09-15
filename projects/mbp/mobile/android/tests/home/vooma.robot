*** Settings ***
Documentation     Vooma mobile transfer tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Vooma Transfer Form
    [Documentation]    Verify the Vooma transfer form opens from the type sheet.
    [Tags]    payments    vooma    mobile    AdoTestCaseId=257685

    Login With Saved Number    ${MOBILE_PIN}
    Open Mobile Transfer Type Sheet
    Select Vooma Transfer Type


User Can Send Money Using Vooma
    [Documentation]    Verify a Vooma transfer can be completed using the registered number.
    ...                Known bug: the app currently marks valid 0116503161 as invalid,
    ...                which keeps Make Payment disabled. Remove known-bug after the fix.
    [Tags]    payments    vooma    positive    mobile    known-bug    AdoTestCaseId=257684

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Mobile Transfer Type Sheet
    Select Vooma Transfer Type
    Enter Transfer Amount    ${VOOMA_TRANSFER_AMOUNT}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${VOOMA_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}
    Wait For Vooma Otp Authorization

    # Assert
    Verify Transfer Was Submitted    ${VOOMA_EXPECTED_AMOUNT}


User Can Send Money To Vooma Contact
    [Documentation]    Verify Vooma Send to Other completes for a selected contact.
    [Tags]    payments    vooma    contacts    positive    mobile    send-to-other    AdoTestCaseId=256594

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Mobile Transfer Type Sheet
    Select Vooma Transfer Type
    Select Vooma Send To Other
    Open Contact List
    Search And Select Vooma Contact    ${VOOMA_CONTACT_NAME}
    Selected Vooma Recipient Should Be    ${VOOMA_CONTACT_NUMBER}
    Enter Transfer Amount    ${VOOMA_TRANSFER_AMOUNT}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${VOOMA_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}
    Wait For Vooma Otp Authorization

    # Assert
    Verify Transfer Was Submitted    ${VOOMA_EXPECTED_AMOUNT}
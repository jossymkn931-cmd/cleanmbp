*** Settings ***
Documentation     Send to Mobile transfer tests
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
Dashboard Shows Send To Mobile Action
    [Documentation]    Verify Send to Mobile is available after login.
    [Tags]    smoke    payments    dashboard    mobile    AdoTestCaseId=

    Login With Saved Number    ${MOBILE_PIN}
    Verify Send To Mobile Is Available


User Can Open Send To Mobile Form
    [Documentation]    Verify the transfer form opens without initiating a payment.
    [Tags]    smoke    payments    navigation    mobile    AdoTestCaseId=256605

    Login With Saved Number    ${MOBILE_PIN}
    Open Send To Mobile
    Select Send To Self
    Verify Empty Transfer Form Cannot Be Submitted


User Can Send Money To Selected Contact
    [Documentation]    Verify a Send to Other transfer can be completed from contact search.
    [Tags]    payments    contacts    positive    mobile    AdoTestCaseId=256591

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Send To Mobile
    Select Send To Other
    Open Contact List
    Search And Select Contact    ${CONTACT_NAME}
    Selected Recipient Mobile Number Should Be    ${CONTACT_LOCAL_NUMBER}
    Enter Transfer Amount    ${TRANSFER_AMOUNT}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${EXPECTED_AMOUNT_TEXT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Transfer Was Submitted    ${EXPECTED_AMOUNT_TEXT}


User Can Send Money To Other Mobile
    [Documentation]    Verify a Send to Other mobile transfer can be completed end to end.
    [Tags]    payments    positive    mobile    send-to-other    AdoTestCaseId=256695

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Send To Mobile
    Select Send To Other
    Enter Recipient Mobile Number    ${OTHER_MOBILE_NUMBER}
    Enter Transfer Amount    ${TRANSFER_AMOUNT}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${EXPECTED_AMOUNT_TEXT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Transfer Was Submitted    ${EXPECTED_AMOUNT_TEXT}


User Can Send Money To Self Via Mobile
    [Documentation]    Verify a Send to Self mobile transfer can be completed end to end
    [Tags]    smoke    payments    positive    mobile    AdoTestCaseId=256696

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Send To Mobile
    Select Send To Self
    Enter Transfer Amount    ${TRANSFER_AMOUNT}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${EXPECTED_AMOUNT_TEXT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Transfer Was Submitted    ${EXPECTED_AMOUNT_TEXT}
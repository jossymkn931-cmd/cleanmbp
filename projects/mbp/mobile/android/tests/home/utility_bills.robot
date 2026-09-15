*** Settings ***
Documentation     Utility bills and services payment tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/utility_bills.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Search For A Biller
    [Documentation]    Verify a biller can be found in the directory and opened.
    [Tags]    smoke    utility-bills    navigation     AdoTestCaseId=257480

    Login With Saved Number    ${MOBILE_PIN}
    Open Utility Bills And Services
    Search And Select Biller    ${UTILITY_BILLER_NAME}
    Selected Biller Should Be    ${UTILITY_BILLER_NAME}


User Can Pay A Utility Bill
    [Documentation]    Verify a utility bill payment completes end to end, paying the
    ...                outstanding balance the biller prefills.
    [Tags]    utility-bills    positive     AdoTestCaseId=257480

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Utility Bills And Services
    Search And Select Biller    ${UTILITY_BILLER_NAME}
    Enter Biller Account Number    ${UTILITY_ACCOUNT_NUMBER}
    Verify Biller Account Name Is Resolved    ${UTILITY_ACCOUNT_NAME}
    ${amount_due}=    Get Prefilled Amount Due
    ${expected_amount}=    Set Variable    KES ${amount_due}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${expected_amount}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Utility Payment Was Submitted
    ...    ${expected_amount}
    ...    ${UTILITY_PAYBILL_NUMBER}
    ...    ${UTILITY_BILLER_NAME}
    ...    ${UTILITY_TRANSACTION_TYPE}
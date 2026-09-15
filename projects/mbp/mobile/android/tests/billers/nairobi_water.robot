*** Settings ***
Documentation     Nairobi Water and Sewerage Company full payment journey
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
User Can Pay Nairobi Water
    [Documentation]    Verify a Nairobi Water and Sewerage Company bill payment completes
    ...                end to end from the default account: open biller (40029), enter
    ...                account number, confirm amount due, enter PIN and submit.
    [Tags]    smoke    billers    nairobi-water    positive    journey

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Utility Bills And Services
    Search And Select Biller    ${NAIROBI_WATER_BILLER_NAME}
    Enter Biller Account Number    ${NAIROBI_WATER_ACCOUNT_NUMBER}
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
    ...    ${NAIROBI_WATER_PAYBILL_NUMBER}
    ...    ${NAIROBI_WATER_BILLER_NAME}
    ...    ${NAIROBI_WATER_TRANSACTION_TYPE}

*** Settings ***
Documentation     KPLC Prepaid full payment journey via Vooma wallet
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
User Can Pay KPLC Prepaid Via Vooma
    [Documentation]    Verify a KPLC Prepaid payment completes end to end from the Vooma
    ...                wallet: open biller, enter meter number, select Vooma wallet,
    ...                confirm amount, enter PIN and submit.
    [Tags]    smoke    billers    kplc    prepaid    vooma    positive    journey    AdoTestCaseId=256961

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Utility Bills And Services
    Search And Select Biller    ${KPLC_PREPAID_BILLER_NAME}
    Enter Biller Account Number    ${KPLC_PREPAID_ACCOUNT_NUMBER}
    Select Vooma Wallet
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
    ...    ${KPLC_PREPAID_PAYBILL_NUMBER}
    ...    ${KPLC_PREPAID_BILLER_NAME}
    ...    ${KPLC_TRANSACTION_TYPE}

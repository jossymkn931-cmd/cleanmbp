*** Settings ***
Documentation     M-Pesa payment tests, covering Buy Goods and Pay Bill
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/pay_to_mpesa.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Pay To Mpesa Form
    [Documentation]    Verify the M-Pesa pay form opens with both payment modes.
    [Tags]    smoke    mpesa    navigation    AdoTestCaseId=257346


    Login With Saved Number    ${MOBILE_PIN}
    Open Pay To Mpesa
    Verify Mpesa Pay Options Are Listed


User Can Pay To Mpesa Buy Goods
    [Documentation]    Verify an M-Pesa Buy Goods payment to a till completes end to end.
    ...
    ...                Expected to fail until a valid M-Pesa till number replaces the
    ...                placeholder, which the app rejects with 'Invalid Merchant Code'.
    [Tags]    mpesa    positive    buy-goods   AdoTestCaseId=257345

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Pay To Mpesa
    Select Mpesa Buy Goods
    Enter Mpesa Till Number    ${MPESA_TILL_NUMBER}
    Enter Mpesa Buy Goods Amount    ${MPESA_AMOUNT}    ${MPESA_AMOUNT_ON_FORM}
    Enter Mpesa Payment Reason    ${MPESA_PAYMENT_REASON}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${MPESA_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Mpesa Payment Was Submitted    ${MPESA_EXPECTED_AMOUNT}    ${MPESA_TILL_NUMBER}


User Can Pay To Mpesa Paybill
    [Documentation]    Verify an M-Pesa Pay Bill payment to a biller completes end to end.
    [Tags]    mpesa    positive    pay-bill    AdoTestCaseId=257346

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Pay To Mpesa
    Select Mpesa Pay Bill
    Enter Mpesa Paybill Number    ${MPESA_PAYBILL_NUMBER}
    Verify Mpesa Merchant Is Resolved    ${MPESA_BILLER_NAME_TEXT}
    Enter Mpesa Account Number    ${MPESA_PAYBILL_ACCOUNT}
    Enter Mpesa Pay Bill Amount    ${MPESA_AMOUNT}    ${MPESA_AMOUNT_ON_FORM}
    Enter Mpesa Payment Reason    ${MPESA_PAYMENT_REASON}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${MPESA_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Mpesa Payment Was Submitted    ${MPESA_EXPECTED_AMOUNT}    ${MPESA_PAYBILL_NUMBER}
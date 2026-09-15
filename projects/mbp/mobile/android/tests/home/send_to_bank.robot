*** Settings ***
Documentation     Send to Bank transfer tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/send_to_bank.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
Dashboard Offers Every Bank Transfer Type
    [Documentation]    Verify the bank transfer sheet lists all transfer types.
    [Tags]    smoke    payments    bank    navigation    AdoTestCaseId=256605

    Login With Saved Number    ${MOBILE_PIN}
    Open Bank Transfer Type Sheet
    Verify Bank Transfer Types Are Listed


User Cannot Transfer Between The Same Account
    [Documentation]    Verify transfers between the same account are prevented on KCB
    ...                Send to Self: after selecting the source of funds account, the
    ...                destination cannot be the same account and payment stays disabled.
    [Tags]    smoke    payments    bank    kcb    negative    journey    AdoTestCaseId=256661

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Bank Transfer Type Sheet
    Select KCB Bank Transfer
    Select Bank Send To Self
    Select Bank Source Account    ${ACCOUNT_MASKED}

    # Assert
    Verify Payer Cannot Be The Recipient


User Can Send Money To Another KCB Account
    [Documentation]    Verify a KCB Send to Other bank transfer completes end to end.
    [Tags]    payments    bank    kcb    positive    AdoTestCaseId=256592

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Bank Transfer Type Sheet
    Select KCB Bank Transfer
    Select Bank Send To Other
    Enter Bank Account Number    ${KCB_ACCOUNT_NUMBER}
    Recipient Name Should Be Resolved    ${KCB_ACCOUNT_NAME}
    Enter Payment Reason    ${BANK_PAYMENT_REASON}
    Enter Bank Transfer Amount    ${BANK_TRANSFER_AMOUNT}    ${BANK_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${BANK_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Transfer Was Submitted    ${BANK_EXPECTED_AMOUNT}


User Can Send Money To Another Bank Via Pesalink
    [Documentation]    Verify a Pesalink bank transfer completes end to end.
    [Tags]    payments    bank    pesalink    positive    AdoTestCaseId=256054

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Bank Transfer Type Sheet
    Select Pesalink Transfer
    Select Pesalink Send To Bank
    Select Recipient Bank    ${PESALINK_BANK_NAME}
    Enter Bank Account Number    ${PESALINK_ACCOUNT_NUMBER}
    Enter Payment Reason    ${PESALINK_PAYMENT_REASON}
    Enter Bank Transfer Amount    ${BANK_TRANSFER_AMOUNT}    ${BANK_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${BANK_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Transfer Was Submitted    ${BANK_EXPECTED_AMOUNT}


User Can Send Money To A Mobile Number Via Pesalink
    [Documentation]    Verify a Pesalink mobile transfer completes end to end.
    [Tags]    payments    bank    pesalink    positive    send-to-mobile    AdoTestCaseId=256064

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Bank Transfer Type Sheet
    Select Pesalink Transfer
    Select Pesalink Send To Mobile
    Enter Bank Recipient Mobile Number    ${PESALINK_MOBILE_NUMBER}
    Recipient Name Should Be Resolved    ${PESALINK_MOBILE_NAME}
    Enter Payment Reason    ${PESALINK_PAYMENT_REASON}
    Enter Bank Transfer Amount    ${BANK_TRANSFER_AMOUNT}    ${BANK_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${BANK_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Transfer Was Submitted    ${BANK_EXPECTED_AMOUNT}


User Can Open Swift Global Transfer
    [Documentation]    Verify SWIFT is offered and opens from Global Transfer.
    [Tags]    payments    bank    global-transfer    swift    navigation    AdoTestCaseId=

    Login With Saved Number    ${MOBILE_PIN}
    Open Bank Transfer Type Sheet
    Open Global Transfer Options
    Verify Global Transfer Options Are Listed
    Open Swift Transfer
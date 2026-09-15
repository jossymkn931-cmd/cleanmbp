*** Settings ***
Documentation     Scheduled Payments tests, one per payment type that can be scheduled.
...               Each type opens its own ordinary payment form, so the form is driven
...               with the keywords that already cover that payment.
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/scheduled_payments.robot
Resource          ../../resources/Keywords/send_to_bank.robot
Resource          ../../resources/Keywords/pay_to_vooma.robot
Resource          ../../resources/Keywords/utility_bills.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Schedule A Vooma Payment To Self
    [Documentation]    Verify a Vooma payment to the registered number can be scheduled.
    ...                Known bug: the app prefills the registered number and then marks it
    ...                invalid, which keeps Make Payment disabled.
    [Tags]    payments    scheduled-payments    vooma    positive    mobile    AdoTestCaseId=257342

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Transfers    VOOMA
    Select Schedule Send To Self
    Enter Schedule Amount    ${SCHEDULE_AMOUNT}

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_VOOMA_SELF_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_VOOMA_SELF_NAME}    ${SCHEDULE_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization


User Can Schedule A Vooma Payment To Another Number
    [Documentation]    Verify a Vooma payment to another number can be scheduled to run
    ...                once on the earliest date the app allows.
    [Tags]    payments    scheduled-payments    vooma    positive    mobile    send-to-other    AdoTestCaseId=257350

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Transfers    VOOMA
    Select Schedule Send To Other
    Enter Schedule Recipient Number    ${VOOMA_CONTACT_NUMBER}
    Schedule Recipient Should Be    ${SCHEDULE_RECIPIENT_NAME_TEXT}
    Enter Schedule Amount    ${SCHEDULE_AMOUNT}

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_VOOMA_OTHER_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_VOOMA_OTHER_NAME}    ${SCHEDULE_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization


User Can Schedule An M-Pesa Payment To Self
    [Documentation]    Verify an M-Pesa transfer to the registered number can be scheduled.
    [Tags]    payments    scheduled-payments    mpesa    positive    mobile    AdoTestCaseId=257344

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Transfers    M-Pesa
    Select Schedule Send To Self
    Enter Schedule Amount    ${SCHEDULE_AMOUNT}

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_MPESA_SELF_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_MPESA_SELF_NAME}    ${SCHEDULE_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization


User Can Schedule An M-Pesa Payment To Another Number
    [Documentation]    Verify an M-Pesa transfer to another number can be scheduled.
    ...                M-Pesa does not name the recipient before payment, so there is
    ...                nothing to verify the number against here.
    [Tags]    payments    scheduled-payments    mpesa    positive    mobile    send-to-other    AdoTestCaseId=257347

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Transfers    M-Pesa
    Select Schedule Send To Other
    Enter Schedule Recipient Number    ${AIRTIME_OTHER_NUMBER}
    Enter Schedule Amount    ${SCHEDULE_AMOUNT}

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_MPESA_OTHER_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_MPESA_OTHER_NAME}    ${SCHEDULE_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization


User Can Schedule An Internal Bank Transfer
    [Documentation]    Verify a transfer to another KCB account can be scheduled.
    [Tags]    payments    scheduled-payments    bank    positive    mobile    AdoTestCaseId=257349

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Transfers    Internal Bank Transfer
    Select Schedule Tab    Send to Other
    Enter Bank Account Number    ${KCB_ACCOUNT_NUMBER}
    Recipient Name Should Be Resolved    ${KCB_ACCOUNT_NAME}
    Enter Payment Reason    ${BANK_PAYMENT_REASON}
    Enter Bank Transfer Amount    ${SCHEDULE_AMOUNT}    ${SCHEDULE_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_BANK_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_BANK_NAME}    ${SCHEDULE_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization


User Can Schedule A Pesalink Transfer
    [Documentation]    Verify a Pesalink transfer to another bank can be scheduled.
    [Tags]    payments    scheduled-payments    pesalink    positive    mobile    AdoTestCaseId=257348

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Transfers    Pesalink
    Select Schedule Tab    Send to Bank
    Select Recipient Bank    ${PESALINK_BANK_NAME}
    Enter Bank Account Number    ${PESALINK_ACCOUNT_NUMBER}
    Enter Payment Reason    ${PESALINK_PAYMENT_REASON}
    Enter Bank Transfer Amount    ${SCHEDULE_AMOUNT}    ${SCHEDULE_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_PESALINK_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_PESALINK_NAME}    ${SCHEDULE_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization


User Can Schedule A Vooma Merchant Payment
    [Documentation]    Verify a Vooma Buy Goods payment to a till can be scheduled.
    [Tags]    payments    scheduled-payments    vooma    buy-goods    positive    mobile    AdoTestCaseId=257345

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Payments    Vooma Payments
    Select Vooma Buy Goods
    Enter Vooma Till Number    ${VOOMA_TILL_NUMBER}
    Verify Vooma Merchant Is Resolved    ${VOOMA_MERCHANT_NAME_TEXT}
    Enter Vooma Buy Goods Amount    ${SCHEDULE_AMOUNT}    ${SCHEDULE_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_VOOMA_MERCHANT_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_VOOMA_MERCHANT_NAME}    ${SCHEDULE_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization


User Can Schedule A Utility Bill Payment
    [Documentation]    Verify a utility bill can be scheduled for the balance the biller
    ...                prefills, which is whatever it currently reports.
    ...                Known bug: the scheduled form answers Validation error occurred for
    ...                the bill account the ordinary utility payment accepts, so neither
    ...                the account name nor the balance is ever returned.
    [Tags]    payments    scheduled-payments    utility-bills    positive    mobile    AdoTestCaseId=257346

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Scheduled Payments
    Start A New Scheduled Payment
    Select Scheduled Payment Type    Payments    Utility
    Search And Select Biller    ${UTILITY_BILLER_NAME}
    Enter Biller Account Number    ${UTILITY_ACCOUNT_NUMBER}
    Verify Biller Account Name Is Resolved    ${UTILITY_ACCOUNT_NAME}
    ${amount_due}=    Get Prefilled Amount Due

    # Act
    Tap Make Payment
    Schedule It For The Earliest Date    ${SCHEDULE_UTILITY_NAME}
    Verify Schedule Summary Is Displayed    ${SCHEDULE_UTILITY_NAME}    KES ${amount_due}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Schedule Was Sent For Authorization
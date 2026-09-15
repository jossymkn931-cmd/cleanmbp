*** Settings ***
Documentation     Pay to Vooma tests, covering Buy Goods and Pay Bill
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/pay_to_vooma.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Pay To Vooma Form
    [Documentation]    Verify the Vooma pay form opens with both payment modes.
    [Tags]    smoke    vooma    navigation    AdoTestCaseId=257678

    Login With Saved Number    ${MOBILE_PIN}
    Open Pay To Vooma
    Verify Vooma Pay Options Are Listed


User Can Pay To Vooma Buy Goods
    [Documentation]    Verify a Vooma Buy Goods payment to a till completes end to end.
    [Tags]    vooma    positive    buy-goods    AdoTestCaseId=257675

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Pay To Vooma
    Select Vooma Buy Goods
    Enter Vooma Till Number    ${VOOMA_TILL_NUMBER}
    Verify Vooma Merchant Is Resolved    ${VOOMA_MERCHANT_NAME_TEXT}
    Enter Vooma Buy Goods Amount    ${VOOMA_PAY_AMOUNT}    ${VOOMA_PAY_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${VOOMA_PAY_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Vooma Payment Was Submitted
    ...    ${VOOMA_BUY_GOODS_TYPE}
    ...    ${VOOMA_PAY_EXPECTED_AMOUNT}
    ...    ${VOOMA_TILL_NUMBER}
    ...    ${VOOMA_MERCHANT_NAME_TEXT}


User Can Pay To Vooma Paybill
    [Documentation]    Verify a Vooma Pay Bill payment to a biller completes end to end.
    [Tags]    vooma    positive    pay-bill    AdoTestCaseId=257677

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Pay To Vooma
    Select Vooma Pay Bill
    Enter Vooma Paybill Number    ${VOOMA_PAYBILL_NUMBER}
    Verify Vooma Merchant Is Resolved    ${VOOMA_BILLER_NAME_TEXT}
    Enter Vooma Account Number    ${VOOMA_PAYBILL_ACCOUNT}
    Enter Vooma Pay Bill Amount    ${VOOMA_PAY_AMOUNT}    ${VOOMA_PAY_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${VOOMA_PAY_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Vooma Payment Was Submitted
    ...    ${VOOMA_PAY_BILL_TYPE}
    ...    ${VOOMA_PAY_EXPECTED_AMOUNT}
    ...    ${VOOMA_PAYBILL_NUMBER}
    ...    ${VOOMA_BILLER_NAME_TEXT}
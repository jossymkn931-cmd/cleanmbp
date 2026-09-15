*** Settings ***
Documentation     Lipa na KCB payment tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/lipa_na_kcb.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Lipa Na KCB Form
    [Documentation]    Verify the Lipa na KCB form opens from the Pay sheet.
    [Tags]    smoke    lipa-na-kcb    navigation    AdoTestCaseId=257547

    Login With Saved Number    ${MOBILE_PIN}
    Open Lipa Na KCB


User Can Pay To A Lipa Na KCB Till
    [Documentation]    Verify a Lipa na KCB payment to a till completes end to end.
    [Tags]    lipa-na-kcb    positive     AdoTestCaseId=257480

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Lipa Na KCB
    Enter Lipa Till Number    ${LIPA_TILL_NUMBER}
    Verify Lipa Merchant Is Resolved    ${LIPA_MERCHANT_NAME_TEXT}
    Enter Lipa Amount    ${LIPA_AMOUNT}    ${LIPA_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${LIPA_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Lipa Payment Was Submitted
    ...    ${LIPA_EXPECTED_AMOUNT}
    ...    ${LIPA_TILL_NUMBER}
    ...    ${LIPA_SERVICE_TYPE}
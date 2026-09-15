*** Settings ***
Documentation     PayPal module tests from the Transact menu
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/paypal.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open PayPal Module From Transact Menu
    [Documentation]    Verify user can open the PayPal module from the Transact menu.
    ...                After PIN, the Agree/Disagree consent screen means success.
    [Tags]    smoke    transact    paypal    navigation    positive    mobile    AdoTestCaseId=257979

    Login With Saved Number    ${MOBILE_PIN}
    Open PayPal From Transact    ${MOBILE_PIN}
    Verify PayPal Module Opened


System Requests Verification Code When Linking PayPal
    [Documentation]    Open PayPal → PIN → Agree → Access PayPal → Link Account →
    ...                Accept terms → enter Gmail → Continue → verify-email popup.
    [Tags]    transact    paypal    link-account    verification    positive    mobile    AdoTestCaseId=257982

    Login With Saved Number    ${MOBILE_PIN}
    Open PayPal From Transact    ${MOBILE_PIN}
    Tap PayPal Agree
    Tap Access PayPal
    Tap Link Account
    Accept PayPal Terms And Conditions
    Enter PayPal Email And Continue    ${PAYPAL_EMAIL}
    Verify PayPal Email Verification Popup

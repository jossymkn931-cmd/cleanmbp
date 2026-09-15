*** Settings ***
Documentation     Lipa Karo journey tests from the Transact menu
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/lipa_karo.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Complete Lipa Karo Payment
    [Documentation]    Pay school fees via Lipa Karo for Alliance Girls High School.
    [Tags]    smoke    transact    lipa-karo    positive    journey    AdoTestCaseId=257360

    Login With Saved Number    ${MOBILE_PIN}
    Open Lipa Karo From Transact
    Search And Select Lipa Karo School    ${LIPA_KARO_SCHOOL_NAME}
    Select Lipa Karo School Account    ${LIPA_KARO_SCHOOL_ACCOUNT}
    ${admission}=    Generate Random Admission Number
    Enter Lipa Karo Admission Number    ${admission}
    Enter Lipa Karo Student Name    ${LIPA_KARO_STUDENT_NAME}
    Enter Lipa Karo Amount    ${LIPA_KARO_AMOUNT}    ${LIPA_KARO_AMOUNT_ON_FORM}
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${LIPA_KARO_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}
    Verify Lipa Karo Payment Was Submitted    ${LIPA_KARO_EXPECTED_AMOUNT}

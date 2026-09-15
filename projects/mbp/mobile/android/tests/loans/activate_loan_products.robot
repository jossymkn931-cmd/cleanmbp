*** Settings ***
Documentation    Ability to activate a loan product (ADO 256503)
Library          AppiumLibrary
Resource         ../../resources/Keywords/common.robot
Resource         ../../resources/Keywords/login.robot
Resource         ../../resources/Keywords/loans.robot
Resource         ../../resources/variables/test_data.robot

Suite Setup      Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown   Close Mobile Application
Test Setup       Restart Application
Test Teardown    Take Screenshot On Failure


*** Test Cases ***
User Can Activate Loan Products
    [Tags]    Loans    Smoke    AdoTestCaseId:256503

    Login With Saved Number    ${MOBILE_PIN}
    User Navigates To Loans Section
    Loan Products Should Be Activated And Visible

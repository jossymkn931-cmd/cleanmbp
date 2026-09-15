*** Settings ***
Documentation     Manage Statements / Get Statements tests from the Transact menu
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/statements.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can View Statements List For Account
    [Documentation]    Ability to view the statements list for an account (ADO 257902).
    ...                Transact → Manage Statements opens My Statements; opening
    ...                Get Statements shows the account available for the list/request.
    [Tags]    smoke    transact    statements    navigation    mobile    AdoTestCaseId=257902

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}

    # Act
    Open Manage Statements From Transact

    # Assert — hub / list for the account
    Verify Statements Hub Is Displayed
    Open Get Statements Form
    Verify Statement Account Is Shown    ${ACCOUNT_MASKED}


User Can Request Account Statements Via Email
    [Documentation]    Transact → Manage Statements → Get Statements.
    ...                Fill period, PDF format, Via Email delivery and email, then
    ...                confirm the request reaches the email verification step.
    [Tags]    smoke    transact    statements    positive    mobile    AdoTestCaseId=257906

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Manage Statements From Transact
    Open Get Statements Form
    Select Statement Period One Month
    Select Statement Format PDF
    Select Statement Delivery Via Email
    Enter Statement Email    ${STATEMENT_EMAIL}

    # Act
    Submit Get Statements Form
    Verify Statements Confirm Summary    ${STATEMENT_EMAIL}    ${STATEMENT_FORMAT}
    Confirm Get Statements Request

    # Assert
    Verify Statement Email Verification Screen

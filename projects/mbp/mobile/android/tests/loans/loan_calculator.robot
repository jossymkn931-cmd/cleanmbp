*** Settings ***
Documentation     Loans and Loan Calculator tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/loans.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Calculate A Mobile Loan
    [Documentation]    Verify the calculator costs a KCB Mobile Loan over a
    ...                day based tenure.
    [Tags]    smoke    loans    calculator    mobile-loans    positive    AdoTestCaseId=257597

    Login With Saved Number    ${MOBILE_PIN}
    Open Loans
    Open Loan Calculator
    Select Loan Type       ${MOBILE_LOAN_TYPE}
    Enter Loan Amount      ${MOBILE_LOAN_AMOUNT}    ${MOBILE_LOAN_AMOUNT_ON_FORM}
    Select Loan Duration   ${MOBILE_LOAN_DURATION}    ${MOBILE_LOAN_DURATION_ON_FORM}
    Tap Calculate Now
    Verify Loan Was Costed    ${MOBILE_LOAN_AMOUNT}


User Can Calculate A Personal Loan
    [Documentation]    Verify the calculator costs a Salary Advance over a
    ...                month based tenure.
    [Tags]    loans    calculator    personal-loans    positive    AdoTestCaseId=257603
    Login With Saved Number    ${MOBILE_PIN}
    Open Loans
    Select Personal Loans
    Open Loan Calculator
    Select Loan Type       ${PERSONAL_LOAN_TYPE}
    Enter Loan Amount      ${PERSONAL_LOAN_AMOUNT}    ${PERSONAL_LOAN_AMOUNT_ON_FORM}
    Select Loan Duration   ${PERSONAL_LOAN_DURATION}    ${PERSONAL_LOAN_DURATION_ON_FORM}
    Tap Calculate Now
    Verify Loan Was Costed    ${PERSONAL_LOAN_AMOUNT}


User Can Calculate A Check Off Loan
    [Documentation]    Verify the calculator costs a Check Off Loan over a tenure
    ...                set on the duration slider.
    [Tags]    loans    calculator    check-off    positive    AdoTestCaseId=257602
    Login With Saved Number    ${MOBILE_PIN}
    Open Loans
    Open Loan Calculator
    Select Loan Type         ${CHECKOFF_LOAN_TYPE}
    Enter Loan Amount        ${CHECKOFF_LOAN_AMOUNT}    ${CHECKOFF_LOAN_AMOUNT_ON_FORM}
    Drag Loan Duration To    ${CHECKOFF_LOAN_MONTHS}    ${CHECKOFF_LOAN_DURATION_ON_FORM}
    Tap Calculate Now
    Verify Loan Was Costed    ${CHECKOFF_LOAN_AMOUNT}


Loan Calculator Quotes Nothing Without A Loan Type
    [Tags]    loans    calculator    negative    AdoTestCaseId=257593
    Login With Saved Number    ${MOBILE_PIN}
    Open Loans
    Open Loan Calculator
    Tap Calculate Now
    Verify Loan Was Not Costed
*** Settings ***
Documentation     Deposit & Withdraw tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/deposit_withdraw.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Deposit And Withdraw
    [Documentation]    Verify both tabs open against the linked mobile money number
    ...                and the customer's account.
    [Tags]    smoke    deposit-withdraw    navigation    AdoTestCaseId=257994

    Login With Saved Number    ${MOBILE_PIN}
    Open Deposit And Withdraw
    Verify Deposit Source Of Funds Is    ${DEPOSIT_SOURCE_MOBILE}
    Verify Deposit Target Account Is    ${ACCOUNT_MASKED}
    Select Withdraw Tab
    Verify Withdraw Source Account Is    ${ACCOUNT_MASKED}
    Verify Withdraw Option Is    ${WITHDRAW_AGENT_OPTION}


User Can Deposit Funds From Mobile Money
    [Documentation]    Verify a mobile money deposit completes end to end.
    [Tags]    deposit-withdraw    deposit    positive    AdoTestCaseId=257081

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Deposit And Withdraw
    Enter Deposit Or Withdraw Amount    ${DEPOSIT_AMOUNT}    ${DEPOSIT_AMOUNT_ON_FORM}

    # Act
    Tap Deposit Or Withdraw Submit
    Verify Deposit Confirm Summary
    ...    ${DEPOSIT_SOURCE_TYPE}
    ...    ${DEPOSIT_SOURCE_MOBILE}
    ...    ${ACCOUNT_MASKED}
    ...    ${ACCOUNT_NUMBER}
    ...    ${DEPOSIT_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Deposit Or Withdrawal Was Submitted
    ...    ${DEPOSIT_SERVICE_TYPE}
    ...    ${ACCOUNT_NUMBER}
    ...    ${DEPOSIT_EXPECTED_AMOUNT}


User Can Withdraw Cash At An Agent
    [Documentation]    Verify an agent withdrawal completes end to end.
    [Tags]    deposit-withdraw    withdraw    positive    AdoTestCaseId=257082

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Deposit And Withdraw
    Select Withdraw Tab
    Enter Agent Number    ${WITHDRAW_AGENT_NUMBER}
    Enter Deposit Or Withdraw Amount    ${WITHDRAW_AMOUNT}    ${WITHDRAW_AMOUNT_ON_FORM}

    # Act
    Tap Deposit Or Withdraw Submit
    Verify Confirm Summary Is Displayed    ${WITHDRAW_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Deposit Or Withdrawal Was Submitted
    ...    ${WITHDRAW_SERVICE_TYPE}
    ...    ${ACCOUNT_NUMBER}
    ...    ${WITHDRAW_EXPECTED_AMOUNT}
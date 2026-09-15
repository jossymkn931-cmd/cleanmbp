*** Settings ***
Documentation     Split Bill tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/split_bill.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Split Bill
    [Documentation]    Verify Split Bill opens from the Transact tab against the
    ...                customer's account.
    [Tags]    smoke    split-bill    navigation    AdoTestCaseId=257619

    Login With Saved Number    ${MOBILE_PIN}
    Open Split Bill
    Start A Split Bill Request
    Verify Split Bill Destination Account Is    ${ACCOUNT_MASKED}


User Cannot Complete A Split Bill Without Participants
    [Documentation]    Verify the bill cannot be raised until it has someone to split
    ...                with and a date to expire on.
    [Tags]    split-bill    negative    AdoTestCaseId=257628

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Split Bill
    Start A Split Bill Request

    # Act
    Enter Split Bill Name    ${SPLIT_BILL_NAME}
    Enter Split Bill Total Amount    ${SPLIT_BILL_AMOUNT}    ${SPLIT_BILL_AMOUNT_ON_FORM}

    # Assert
    Verify Split Bill Cannot Be Completed


User Can Create A Split Bill
    [Documentation]    Verify a split bill request is raised end to end.
    [Tags]    split-bill    positive    AdoTestCaseId=257642

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Split Bill
    Start A Split Bill Request
    Enter Split Bill Name    ${SPLIT_BILL_NAME}
    Enter Split Bill Total Amount    ${SPLIT_BILL_AMOUNT}    ${SPLIT_BILL_AMOUNT_ON_FORM}
    Add Split Bill Participant    ${SPLIT_BILL_PARTICIPANT_NUMBER}
    Verify Split Bill Participants Are    ${SPLIT_BILL_PARTICIPANT_SUMMARY_TEXT}
    Accept Default Expiration Date

    # Act
    Tap Complete
    Verify Split Bill Confirm Summary
    ...    ${SPLIT_BILL_NAME}
    ...    ${ACCOUNT_MASKED}
    ...    ${SPLIT_BILL_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Split Bill Was Created
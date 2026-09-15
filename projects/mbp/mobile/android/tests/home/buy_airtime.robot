*** Settings ***
Documentation     Buy Airtime tests
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/send_money.robot
Resource          ../../resources/Keywords/buy_airtime.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Open Buy Airtime Form
    [Documentation]    Verify the airtime form opens with both purchase modes.
    [Tags]    smoke    airtime    navigation    AdoTestCaseId=256718

    Login With Saved Number    ${MOBILE_PIN}
    Open Buy Airtime
    Verify Buy Airtime Options Are Listed


User Can Buy Airtime For Self
    [Documentation]    Verify an airtime purchase for the registered number
    ...                completes end to end.
    [Tags]    airtime    positive    buy-for-self    AdoTestCaseId=256719

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Buy Airtime
    Select Buy For Self
    Own Mobile Number Should Be Prefilled
    Verify Airtime Provider Is Detected    ${AIRTIME_PROVIDER}
    Enter Airtime Amount    ${AIRTIME_AMOUNT}    ${AIRTIME_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${AIRTIME_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Airtime Purchase Was Submitted    ${AIRTIME_EXPECTED_AMOUNT}    ${AIRTIME_PROVIDER}


User Can Buy Airtime For Other
    [Documentation]    Verify an airtime purchase for another number completes
    ...                end to end.
    [Tags]    airtime    positive    buy-for-other    AdoTestCaseId=256720

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Buy Airtime
    Select Buy For Other
    Enter Airtime Recipient Mobile Number    ${AIRTIME_OTHER_NUMBER}
    Verify Airtime Provider Is Detected    ${AIRTIME_PROVIDER}
    Enter Airtime Amount    ${AIRTIME_AMOUNT}    ${AIRTIME_AMOUNT_ON_FORM}

    # Act
    Tap Make Payment
    Verify Confirm Summary Is Displayed    ${AIRTIME_EXPECTED_AMOUNT}
    Tap Continue
    Enter Transaction Pin    ${MOBILE_PIN}

    # Assert
    Verify Airtime Purchase Was Submitted    ${AIRTIME_EXPECTED_AMOUNT}    ${AIRTIME_PROVIDER}
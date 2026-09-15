*** Settings ***
Documentation     Insurance journeys, one end to end run per cover that can be quoted.
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/insurance.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Restart Application
Test Teardown     Take Screenshot On Failure


*** Test Cases ***
User Can Save A Comprehensive Motor Private Quote
    [Documentation]    Verify a comprehensive quote for a private vehicle can be taken
    ...                through the whole wizard and kept for later.
    [Tags]    insurance    motor    comprehensive    positive    mobile    AdoTestCaseId=256382

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Insurance Hub
    Open Cover Catalogue
    Start A Quote For    ${MOTOR_PRIVATE_INDEX}

    # Act
    Select Insurance Option    Type of Motor Insurance    0
    Select Insurance Option    Type of Cover    0
    Enter Vehicle Details    ${MOTOR_REGISTRATION}    ${MOTOR_ESTIMATED_VALUE}
    Select Insurance Option    Confirmation of vehicle usage    0
    Enter Additional Covers    ${MOTOR_WINDSCREEN_COVER}    ${MOTOR_ENTERTAINMENT_UNIT}
    Continue Past The Quote List
    Save The Quote

    # Assert
    Verify Quote Is Saved    ${MOTOR_PRIVATE_PRODUCT_NAME}    ${MOTOR_REGISTRATION}


User Can Save A Third Party Motor Private Quote
    [Documentation]    Verify a third party quote for a private vehicle can be taken
    ...                through the whole wizard and kept for later. Third party prices off
    ...                the vehicle alone, so it skips the usage and additional cover steps.
    [Tags]    insurance    motor    third-party    positive    mobile    AdoTestCaseId=256390

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Insurance Hub
    Open Cover Catalogue
    Start A Quote For    ${MOTOR_PRIVATE_INDEX}

    # Act
    Select Insurance Option    Type of Motor Insurance    0
    Select Insurance Option    Type of Cover    1
    Enter Vehicle Registration    ${MOTOR_REGISTRATION}
    Continue Past The Quote List
    Save The Quote

    # Assert
    Verify Quote Is Saved    ${MOTOR_PRIVATE_PRODUCT_NAME}    ${MOTOR_REGISTRATION}
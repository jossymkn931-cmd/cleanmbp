*** Settings ***
Documentation     Personal accident journeys. The cover is quoted per person rather than
...               per asset, so its quote list offers a button on each quote instead of a
...               radio and a shared Continue.
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
User Can Save An Individual Personal Accident Quote
    [Documentation]    Verify an individual personal accident quote can be taken through
    ...                the whole wizard and kept for later.
    [Tags]    insurance    personal-accident    individual    positive    mobile    AdoTestCaseId=256408

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Insurance Hub
    Open Cover Catalogue
    Start A Quote For    ${PERSONAL_ACCIDENT_INDEX}

    # Act
    Select Insurance Option    Type of Cover    ${INDIVIDUAL_ACCIDENT_INDEX}
    Pick The First Quote
    Save The Quote

    # Assert
    Verify Quote Is Listed    ${PERSONAL_ACCIDENT_PRODUCT_NAME}


User Can Save A Six Month Student Personal Accident Quote
    [Documentation]    Verify a six month student personal accident quote can be taken
    ...                through the whole wizard and kept for later.
    [Tags]    insurance    personal-accident    student    positive    mobile    AdoTestCaseId=256396

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Insurance Hub
    Open Cover Catalogue
    Start A Quote For    ${PERSONAL_ACCIDENT_INDEX}

    # Act
    Select Insurance Option    Type of Cover    ${STUDENT_ACCIDENT_6M_INDEX}
    Pick The First Quote
    Save The Quote

    # Assert
    Verify Quote Is Listed    ${PERSONAL_ACCIDENT_PRODUCT_NAME}


User Can Save A Twelve Month Student Personal Accident Quote
    [Documentation]    Verify a twelve month student personal accident quote can be taken
    ...                through the whole wizard and kept for later.
    [Tags]    insurance    personal-accident    student    positive    mobile    AdoTestCaseId=256402

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Insurance Hub
    Open Cover Catalogue
    Start A Quote For    ${PERSONAL_ACCIDENT_INDEX}

    # Act
    Select Insurance Option    Type of Cover    ${STUDENT_ACCIDENT_12M_INDEX}
    Pick The First Quote
    Save The Quote

    # Assert
    Verify Quote Is Listed    ${PERSONAL_ACCIDENT_PRODUCT_NAME}
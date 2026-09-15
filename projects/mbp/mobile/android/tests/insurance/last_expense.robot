*** Settings ***
Documentation     Last expense journeys. The cover is priced off the family size alone, so
...               the wizard is a single step before the quotes appear.
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
User Can Save A Nuclear Last Expense Quote
    [Documentation]    Verify a nuclear family last expense quote can be taken through the
    ...                whole wizard and kept for later.
    [Tags]    insurance    last-expense    nuclear    positive    mobile    AdoTestCaseId=256413

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Insurance Hub
    Open Cover Catalogue
    Start A Quote For    ${LAST_EXPENSE_INDEX}

    # Act
    Select Insurance Option    Type of Cover    ${NUCLEAR_LAST_EXPENSE_INDEX}
    Pick The First Quote
    Save The Quote

    # Assert
    Verify Quote Is Listed    ${LAST_EXPENSE_PRODUCT_NAME}


User Can Save An Extended Family Last Expense Quote
    [Documentation]    Verify a nuclear and extended family last expense quote can be taken
    ...                through the whole wizard and kept for later.
    [Tags]    insurance    last-expense    extended    positive    mobile    AdoTestCaseId=256414

    # Arrange
    Login With Saved Number    ${MOBILE_PIN}
    Open Insurance Hub
    Open Cover Catalogue
    Start A Quote For    ${LAST_EXPENSE_INDEX}

    # Act
    Select Insurance Option    Type of Cover    ${EXTENDED_LAST_EXPENSE_INDEX}
    Pick The First Quote
    Save The Quote

    # Assert
    Verify Quote Is Listed    ${LAST_EXPENSE_PRODUCT_NAME}
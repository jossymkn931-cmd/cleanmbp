*** Settings ***
Documentation     Customer - Create Customer Profile tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/create_customer_profile.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Staff Can Input Account Number And Retrieve T24 Customer Information
    [Documentation]    Confirmations 2 & 3 - bank staff can input the account number provided by the
    ...    customer, MBP calls the T24 API to validate it, and the returned information is displayed:
    ...    mobile number, customer's names, gender, date of birth, legal document type and number.
    [Tags]    smoke    customer    create_customer_profile    AdoTestCaseId=255963
    Ensure Admin Logged In
    Navigate To Create Customer Profile
    Search Customer By Account Number    ${CUSTOMER_ACCOUNT_NO}
    Customer Information Should Be Displayed
    T24 Should Return Customer Details

MBP Supports The Required Legal Document Types
    [Documentation]    Confirmation 4 - the admin portal supports the legal document types:
    ...    national ID, alien ID, passport, maisha card, refugee manifest.
    [Tags]    customer    create_customer_profile    AdoTestCaseId= 255905 
    Ensure Admin Logged In
    Navigate To Create Customer Profile
    Search Customer By Account Number    ${CUSTOMER_ACCOUNT_NO}
    Customer Information Should Be Displayed
    Legal Document Types Should Be Supported

Registration Is Blocked When Customer Does Not Exist In Core Banking
    [Documentation]    Confirmation 7 - if the customer does not exist in the core banking system (or
    ...    has no bank accounts), no T24 data is returned and registration cannot proceed.
    [Tags]    negative    customer    create_customer_profile    AdoTestCaseId=256548
    Ensure Admin Logged In
    Navigate To Create Customer Profile
    Search Customer By Account Number    ${CUSTOMER_INVALID_ACCOUNT_NO}
    Registration Should Be Blocked For Unknown Customer

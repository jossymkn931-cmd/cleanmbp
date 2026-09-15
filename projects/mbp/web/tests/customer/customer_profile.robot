*** Settings ***
Documentation     Customer - Customer Profile search tests
Library           Browser
Variables         ../../resources/variables/uat.py
Resource          ../../resources/keywords/common.robot
Resource          ../../resources/keywords/login.robot
Resource          ../../resources/keywords/customer_profile.robot

Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page

*** Test Cases ***
Operator Can Search For An Existing Customer Profile
    [Documentation]    Verify an operator can navigate to Customer Profile, search by mobile/customer
    ...    number, and view the returned customer record.
    [Tags]    smoke    customer    customer_profile    AdoTestCaseId=256559
    Ensure Admin Logged In
    Navigate To Customer Profile
    Search Customer Profile By Number    ${CUSTOMER_PROFILE_SEARCH_NO}
    Customer Profile Results Should Be Displayed

Searching A Non-Existent Number Returns No Customer Profile
    [Documentation]    Verify that searching a random/non-existent number does not return a customer
    ...    profile detail view (negative scenario).
    [Tags]    negative    customer    customer_profile   AdoTestCaseId=258035
    Ensure Admin Logged In
    Navigate To Customer Profile
    Search Customer Profile By Number    ${CUSTOMER_PROFILE_INVALID_NO}
    Customer Profile Should Not Be Found

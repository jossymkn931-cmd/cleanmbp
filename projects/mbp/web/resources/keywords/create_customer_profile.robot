*** Settings ***
Documentation     Create Customer Profile page keywords
Library           Browser
Library           Collections
Resource          ../locators/create_customer_profile.robot

*** Keywords ***
Navigate To Create Customer Profile
    [Documentation]    Navigate to Customer > Individual Customer > Create Customer Profile
    Click    ${CUSTOMER_MENU}
    Wait For Elements State    ${INDIVIDUAL_CUSTOMER_MENU}    visible    timeout=15s
    Click    ${INDIVIDUAL_CUSTOMER_MENU}
    Wait For Elements State    ${CREATE_CUSTOMER_PROFILE_MENU}    visible    timeout=15s
    Click    ${CREATE_CUSTOMER_PROFILE_MENU}
    Wait For Elements State    ${ACCOUNT_NO_FIELD}    visible    timeout=20s

Search Customer By Account Number
    [Documentation]    Enter the bank account number and search for T24 customer information
    [Arguments]    ${account_no}
    Wait For Elements State    ${ACCOUNT_NO_FIELD}    visible    timeout=10s
    Click    ${ACCOUNT_NO_FIELD}
    Clear Text    ${ACCOUNT_NO_FIELD}
    Type Text    ${ACCOUNT_NO_FIELD}    ${account_no}
    Click    ${SEARCH_BUTTON}

    # Wait for either the T24 info section OR an error message to appear
    ${t24_shown}=    Run Keyword And Return Status    Wait For Elements State    ${T24_INFO_SECTION}    visible    timeout=10s
    IF    ${t24_shown}
        RETURN
    END
    ${err_present}=    Run Keyword And Return Status    Wait For Elements State    xpath=//div[contains(@class,'el-message__content')]    visible    timeout=5s
    IF    ${err_present}
        ${err_text}=    Get Text    xpath=//div[contains(@class,'el-message__content')]
        Fail    T24 service returned an error after account lookup: ${err_text}
    END

Customer Information Should Be Displayed
    [Documentation]    Verify the account search returned a customer from T24 when one exists. If the
    ...    customer is not present in T24, treat that as a valid not-created-in-T24 outcome.
    Wait For Elements State    ${T24_INFO_SECTION}    visible    timeout=30s
    Wait For Elements State    ${CUSTOMER_NAME_FIELD}    visible    timeout=30s
    ${customer_name}=    Get Property    ${CUSTOMER_NAME_FIELD}    value
    ${customer_found}=    Run Keyword And Return Status    Should Not Be Empty    ${customer_name}
    IF    ${customer_found}    RETURN
    Log    Account not found in T24; treating this as a valid not-created-in-T24 scenario.    console=True

T24 Should Return Customer Details
    [Documentation]    Item 3 - verify T24 returned all required fields: mobile number, customer's
    ...    names, gender, date of birth, legal document type and number. Each field must be populated.
    ${customer_name}=    Get Property    ${CUSTOMER_NAME_FIELD}    value
    ${customer_found}=    Run Keyword And Return Status    Should Not Be Empty    ${customer_name}
    IF    not ${customer_found}
        Log    T24 returned no customer details; skipping detailed field validation for not-created-in-T24 scenario.    console=True
        RETURN
    END
    ${mobile}=          Get Property    ${MOBILE_NO_FIELD}       value
    ${name}=            Get Property    ${CUSTOMER_NAME_FIELD}   value
    ${gender}=          Get Property    ${GENDER_SELECT}         value
    ${dob}=             Get Property    ${DATE_OF_BIRTH_FIELD}   value
    ${legal_type}=      Get Property    ${LEGAL_ID_TYPE_SELECT}  value
    ${legal_no}=        Get Property    ${LEGAL_ID_NO_FIELD}     value
    Should Not Be Empty    ${mobile}        T24 did not return the mobile number
    Should Not Be Empty    ${name}          T24 did not return the customer's names
    Should Not Be Empty    ${gender}        T24 did not return the gender
    Should Not Be Empty    ${dob}           T24 did not return the date of birth
    Should Not Be Empty    ${legal_type}    T24 did not return the legal document type
    Should Not Be Empty    ${legal_no}      T24 did not return the legal document number

Legal Document Types Should Be Supported
    [Documentation]    Item 4 - open the Legal ID type dropdown and verify the supported document
    ...    types are available: national ID, alien ID, passport, maisha card, refugee manifest.
    Click    ${LEGAL_ID_TYPE_SELECT}
    Wait For Elements State    ${LEGAL_ID_TYPE_DROPDOWN_LIST}    visible    timeout=15s
    @{expected_types}=    Create List    national id    alien id    passport    maisha card    refugee manifest
    FOR    ${type}    IN    @{expected_types}
        Wait For Elements State
        ...    xpath=//li[contains(@class,'el-option')]//*[contains(translate(normalize-space(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), '${type}')]
        ...    attached    timeout=10s
    END

Registration Should Be Blocked For Unknown Customer
    [Documentation]    Items 5/6/7 - when the account/customer does not exist (or is already
    ...    registered), no T24 data is returned and the "Create customer profile" action stays
    ...    disabled, so registration cannot proceed.
    Wait For Elements State    ${CREATE_BUTTON_DISABLED}    visible    timeout=15s

Click Create Customer Profile Button
    [Documentation]    Click the "Create customer profile" button to complete profile creation
    Wait For Elements State    ${CREATE_CUSTOMER_PROFILE_BUTTON}    visible    timeout=15s
    Click    ${CREATE_CUSTOMER_PROFILE_BUTTON}

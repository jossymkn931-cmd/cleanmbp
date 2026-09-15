*** Settings ***
Documentation     Customer Profile (search) page keywords
Library           Browser
Resource          ../locators/customer_profile.robot

*** Keywords ***
Navigate To Customer Profile
    [Documentation]    Navigate to Customer > Individual Customer > Customer Profile
    Click    ${CUSTOMER_MENU}
    Wait For Elements State    ${INDIVIDUAL_CUSTOMER_MENU}    visible    timeout=15s
    Click    ${INDIVIDUAL_CUSTOMER_MENU}
    Wait For Elements State    ${CUSTOMER_PROFILE_MENU}    visible    timeout=15s
    Click    ${CUSTOMER_PROFILE_MENU}
    Wait For Elements State    ${SEARCH_INPUT}    visible    timeout=20s

Search Customer Profile By Number
    [Documentation]    Enter the mobile/customer number and click search
    [Arguments]    ${number}
    Wait For Elements State    ${SEARCH_INPUT}    visible    timeout=20s
    Click    ${SEARCH_INPUT}
    Clear Text    ${SEARCH_INPUT}
    Type Text    ${SEARCH_INPUT}    ${number}
    Click    ${SEARCH_BUTTON}

Customer Profile Results Should Be Displayed
    [Documentation]    Verify a populated customer profile loads: the detail panel is shown and
    ...    the action buttons are enabled.
    Wait For Elements State    ${PROFILE_INFO_TAB}    visible    timeout=30s
    Wait For Elements State    ${CUSTOMER_PROFILE_DETAILS}    visible    timeout=30s
    Wait For Elements State    ${UPDATE_PROFILE_BUTTON_ENABLED}    visible    timeout=30s

Customer Profile Should Not Be Found
    [Documentation]    Verify that searching a random/non-existent number returns an empty profile:
    ...    the layout is still present but the action buttons stay disabled (no customer loaded).
    Wait For Elements State    ${UPDATE_PROFILE_BUTTON_DISABLED}    visible    timeout=15s

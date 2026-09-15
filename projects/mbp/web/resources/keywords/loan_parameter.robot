*** Settings ***
Documentation     Loan Parameter page keywords
Library           Browser
Resource          ../locators/loan_parameter.robot

*** Keywords ***
Navigate To Loan Parameter Page
    [Documentation]    Navigate through menu: Service Parameter > Loan > Loan Parameter
    Click    ${SERVICE_PARAMETER_MENU}
    Wait For Elements State    ${LOAN_SUBMENU}    visible    timeout=15s
    Click    ${LOAN_SUBMENU}
    Wait For Elements State    ${LOAN_PARAMETER_MENU}    visible    timeout=15s
    Click    ${LOAN_PARAMETER_MENU}
    Wait For Elements State    ${SEARCH_BUTTON}    visible    timeout=15s

Click Search Button
    [Documentation]    Click the search button to load loan parameters
    Click    ${SEARCH_BUTTON}
    
Wait For Loan Parameter List To Load
    [Documentation]    Wait for loan parameter list to fully load by checking table headers and rows
    # Wait for table header to appear
    Wait For Elements State    ${TABLE_HEADER_PRODUCT_CODE}    visible    timeout=60s
    # Wait for at least one data row
    Wait For Elements State    ${TABLE_FIRST_ROW}    visible    timeout=30s

Wait For Load Indicator To Disappear
    [Documentation]    Wait for loading mask to disappear
    # Use Run Keyword And Ignore Error to handle cases where loading mask doesn't exist
    Run Keyword And Ignore Error    Wait For Elements State    ${LOAN_PARAMETER_LOADING}    hidden    timeout=10s

Search And Wait For Results
    [Documentation]    Perform search and wait for results to load
    Click Search Button
    Wait For Loan Parameter List To Load

Loan Parameter Page Should Be Displayed
    [Documentation]    Verify loan parameter table is displayed with expected columns
    # Verify table header is visible
    Wait For Elements State    ${TABLE_HEADER_PRODUCT_CODE}    visible    timeout=10s
    # Verify at least one data row exists
    Wait For Elements State    ${TABLE_FIRST_ROW}    visible    timeout=10s

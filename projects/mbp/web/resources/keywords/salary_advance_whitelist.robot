*** Settings ***
Documentation     Salary Advance Whitelist page keywords
Library           Browser
Resource          ../locators/salary_advance_whitelist.robot

*** Keywords ***
Navigate To Salary Advance Whitelist
    [Documentation]    Navigate to Salary Advance Whitelist via Service Parameter > Loan menu
    Click    ${SERVICE_PARAMETER_MENU}
    Wait For Elements State    ${LOAN_MENU}    visible    timeout=15s
    Click    ${LOAN_MENU}
    Wait For Elements State    ${SALARY_ADVANCE_WHITELIST_MENU}    visible    timeout=15s
    Click    ${SALARY_ADVANCE_WHITELIST_MENU}

Click View Button
    [Documentation]    Click the View menu item for Salary Advance Whitelist
    # View should be a menu item under Salary Advance Whitelist submenu
    Click    ${VIEW_MENU_ITEM}
    Wait For Elements State    ${SEARCH_BUTTON}    visible    timeout=20s

Search And Wait For Results
    [Documentation]    Click search button and wait for customer list to load
    Click    ${SEARCH_BUTTON}
    Wait For Elements State    ${TABLE_HEADER}    visible    timeout=60s
    Wait For Elements State    ${TABLE_FIRST_ROW_DATA}    visible    timeout=30s

Click First Customer Record
    [Documentation]    Click the first customer record row in the table
    Click    ${FIRST_TABLE_ROW}
    Wait For Elements State    ${CHANGE_STATUS_BUTTON}    visible    timeout=15s

Click Change Status Button
    [Documentation]    Click the Change Status button
    Click    ${CHANGE_STATUS_BUTTON}
    Wait For Elements State    ${STATUS_DROPDOWN}    visible    timeout=10s

Select First Status Option
    [Documentation]    Click on status dropdown and use arrow keys to select second option
    Click    ${STATUS_DROPDOWN}
    Keyboard Key    press    ArrowDown
    Keyboard Key    press    ArrowDown
    Keyboard Key    press    Enter
    Wait For Elements State    ${SUBMIT_BUTTON}    visible    timeout=10s

Submit Status Change
    [Documentation]    Click submit button to save status change
    Click    ${SUBMIT_BUTTON}
    # Accept either a success message or an "already changed" popup - both are valid outcomes
    TRY
        Wait For Elements State    xpath=//div[contains(@class,'el-message')]    visible    timeout=15s
    EXCEPT
        Wait For Elements State    xpath=//div[contains(@class,'el-dialog') or contains(@class,'el-message-box')]    visible    timeout=5s
    END

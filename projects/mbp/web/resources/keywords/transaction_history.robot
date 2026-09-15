*** Settings ***
Documentation     Transaction History page keywords
Library           Browser
Resource          ../locators/transaction_history.robot

*** Keywords ***
Expand Transaction History Menu
    [Documentation]    Click Transaction > Transaction History to expand submenu
    Click    ${TRANSACTION_MENU}
    Wait For Elements State    ${TRANSACTION_HISTORY_MENU}    visible    timeout=15s
    Click    ${TRANSACTION_HISTORY_MENU}
    Wait For Elements State    ${LOAN_TH_MENU}    visible    timeout=15s

Navigate To Loan Disbursement History
    [Documentation]    Navigate to Transaction > Loan > Disbursement
    Click    ${TRANSACTION_MENU}
    Wait For Elements State    ${LOAN_DIRECT_MENU}    visible    timeout=15s
    Click    ${LOAN_DIRECT_MENU}
    Wait For Elements State    ${DISBURSEMENT_MENU}    visible    timeout=15s
    Click    ${DISBURSEMENT_MENU}
    Wait For Elements State    ${SEARCH_BUTTON}    visible    timeout=20s
    Click    ${DATE_EDITOR_RANGE}
    Wait For Elements State    ${DATE_PICKER_TABLE}    visible    timeout=5s
    Click    ${DATE_PICKER_FIRST_DAY_CELL}
    ${TODAY_DAY}=    Evaluate    int(__import__('datetime').datetime.now().strftime('%d'))
    Wait For Elements State
    ...    xpath=//div[contains(@class,'is-left')]//td[not(contains(@class,'prev-month')) and not(contains(@class,'disabled'))][.//span[normalize-space()='${TODAY_DAY}']]    stable    timeout=5s
    Click    xpath=//div[contains(@class,'is-left')]//td[not(contains(@class,'prev-month')) and not(contains(@class,'disabled'))][.//span[normalize-space()='${TODAY_DAY}']]

Navigate To Savings Transaction History
    [Documentation]    Navigate to Transaction > Transaction History > Savings
    Expand Transaction History Menu
    Click    ${SAVINGS_TH_MENU}
    Wait For Elements State    ${SEARCH_BUTTON}    visible    timeout=20s

Navigate To Payment Transaction History
    [Documentation]    Navigate to Transaction > Transaction History > Payment
    Expand Transaction History Menu
    Click    ${PAYMENT_TH_MENU}
    Wait For Elements State    ${TRANSACTION_TYPE_DROPDOWN}    visible    timeout=20s
    Click    ${TRANSACTION_TYPE_DROPDOWN}
    Keyboard Key    press    ArrowDown
    Keyboard Key    press    Enter

Navigate To Transfer Transaction History
    [Documentation]    Navigate to Transaction > Transaction History > Transfer
    Expand Transaction History Menu
    Click    ${TRANSFER_TH_MENU}
    Wait For Elements State    ${SEARCH_BUTTON}    visible    timeout=20s

Search And Verify Transaction Records
    [Documentation]    Click search, open first record and verify detail view
    Click    ${SEARCH_BUTTON}
    Wait For Elements State    ${FIRST_TABLE_ROW}    visible    timeout=60s
    Click    ${FIRST_TABLE_ROW}
    Wait For Elements State    ${DETAIL_BUTTON}    visible    timeout=15s
    Click    ${DETAIL_BUTTON}

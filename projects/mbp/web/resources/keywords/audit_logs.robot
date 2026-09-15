*** Settings ***
Documentation     Audit Logs journal page keywords
Library           Browser
Resource          ../locators/audit_logs.robot

*** Keywords ***
Expand Audit Logs Menu
    [Documentation]    Open the Audit Logs side menu
    Wait For Elements State    ${AUDIT_LOGS_MENU}    visible    timeout=15s
    Click    ${AUDIT_LOGS_MENU}
    Wait For Elements State    ${APP_JOURNAL_MENU}    visible    timeout=15s

Navigate To App Journal
    [Documentation]    Navigate to Audit Logs > APP Journal
    Expand Audit Logs Menu
    Click    ${APP_JOURNAL_MENU}
    Wait For Elements State    ${AUDIT_LOGS_SEARCH_BUTTON}    visible    timeout=20s

Navigate To Ussd Journal
    [Documentation]    Navigate to Audit Logs > USSD Journal
    Expand Audit Logs Menu
    Click    ${USSD_JOURNAL_MENU}
    Wait For Elements State    ${AUDIT_LOGS_SEARCH_BUTTON}    visible    timeout=20s

Navigate To Operator Journal
    [Documentation]    Navigate to Audit Logs > Operator Journal
    Expand Audit Logs Menu
    Click    ${OPERATOR_JOURNAL_MENU}
    Wait For Elements State    ${AUDIT_LOGS_SEARCH_BUTTON}    visible    timeout=20s

Search And Wait For Journal Logs
    [Documentation]    Click Search, wait for log rows, select first row radio, confirm Details
    Click    ${AUDIT_LOGS_SEARCH_BUTTON}
    Wait For Elements State    ${AUDIT_LOGS_FIRST_TABLE_ROW}    visible    timeout=60s
    Wait For Elements State    ${AUDIT_LOGS_FIRST_ROW_RADIO}    visible    timeout=30s
    Click    ${AUDIT_LOGS_FIRST_ROW_RADIO}
    Wait For Elements State    ${AUDIT_LOGS_DETAILS_BUTTON}    visible    timeout=15s

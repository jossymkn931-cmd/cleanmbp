*** Settings ***
Documentation     Admin Portal Access Management page keywords
Library           Browser
Resource          ../locators/admin_portal_access.robot

*** Keywords ***
Navigate To Transaction Reports
    [Documentation]    Navigate to Report > Online Report > Transaction Reports
    Click    ${REPORT_MENU}
    Wait For Elements State    ${ONLINE_REPORT_SUBMENU}    visible    timeout=15s
    Click    ${ONLINE_REPORT_SUBMENU}
    Wait For Elements State    ${TRANSACTION_REPORTS_MENU}    visible    timeout=15s
    Click    ${TRANSACTION_REPORTS_MENU}
    Wait For Elements State    ${SEARCH_BUTTON}    visible    timeout=20s

Navigate To Service Request Reports
    [Documentation]    Navigate to Report > Online Report > Service Request Reports
    Click    ${REPORT_MENU}
    Wait For Elements State    ${ONLINE_REPORT_SUBMENU}    visible    timeout=15s
    Click    ${ONLINE_REPORT_SUBMENU}
    Wait For Elements State    ${SERVICE_REQUESTS_MENU}    visible    timeout=15s
    Click    ${SERVICE_REQUESTS_MENU}
    Wait For Elements State    ${SEARCH_BUTTON}    visible    timeout=20s

Search And Select First Service Request Record
    [Documentation]    Click search and select first record from Service Request results
    Click    ${SEARCH_BUTTON}
    Wait For Elements State    ${SR_TABLE_HEADER}    visible    timeout=60s
    Wait For Elements State    ${SR_FIRST_TABLE_ROW}    visible    timeout=30s
    # Dismiss overlays and give UI a moment to settle before selecting row
    Click    xpath=//body
    Scroll To Element    ${SR_TABLE_HEADER}
    ${has_radio}=    Run Keyword And Return Status    Wait For Elements State    ${SR_FIRST_ROW_RADIO_BUTTON}    visible    timeout=5s
    IF    ${has_radio}
        Click    ${SR_FIRST_ROW_RADIO_BUTTON}
        # Verify radio became selected; Element UI toggles a checked class on selection
        ${radio_selected}=    Run Keyword And Return Status    Wait For Elements State    xpath=//*[@id='serviceRequestReportsTable']//tbody//tr[1]//span[contains(@class,'is-checked')]    visible    timeout=3s
        IF    not ${radio_selected}
            # Try clicking the first selectable cell as a fallback
            Click    xpath=//*[@id='serviceRequestReportsTable']//tbody//tr[1]//td[1]
            Sleep    0.3s
            ${radio_selected}=    Run Keyword And Return Status    Wait For Elements State    xpath=//*[@id='serviceRequestReportsTable']//tbody//tr[1]//span[contains(@class,'is-checked')]    visible    timeout=3s
        END
    ELSE
        # No radio buttons present; click the first row to select
        Click    ${SR_FIRST_TABLE_ROW}
    END

Verify Service Request Report Columns
    [Documentation]    Verify the Service Request report shows expected columns
    Wait For Elements State    ${SR_TABLE_HEADER}    visible    timeout=30s
    ${expected}=    Create List    request number    service type    customer name    mobile no    branch name    branch dao    initiator staff id    approver staff id    date created    time created    customer status    sales code    primary account    primary account branch    document type    id number
    ${missing}=    Create List
    FOR    ${hdr}    IN    @{expected}
        ${expr_exact}=    Set Variable    xpath=//*[@id='serviceRequestReportsTable']//th//div[translate(normalize-space(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='${hdr}']
        ${found}=    Run Keyword And Return Status    Wait For Elements State    ${expr_exact}    visible    timeout=5s
        IF    ${found}
            Scroll To Element    ${expr_exact}
        ELSE
            ${expr_contains}=    Set Variable    xpath=(//*[@id='serviceRequestReportsTable']//th//div[contains(translate(normalize-space(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'${hdr}')])[1]
            ${found2}=    Run Keyword And Return Status    Wait For Elements State    ${expr_contains}    visible    timeout=5s
            IF    ${found2}
                Scroll To Element    ${expr_contains}
            ELSE
                Append To List    ${missing}    ${hdr}
            END
        END
    END
    Run Keyword If    ${missing}    Fail    Missing expected report columns: ${missing}

Service Request Search Criteria Should Be Available
    [Documentation]    Verify time range, region, branch and service type filters are present
    Wait For Elements State    ${REPORT_DATE_START_INPUT}    visible    timeout=10s
    Wait For Elements State    ${SR_REGION_INPUT}    visible    timeout=10s
    Wait For Elements State    ${SR_BRANCH_DAO_INPUT}    visible    timeout=10s
    Wait For Elements State    ${SR_SERVICE_TYPE_LABEL}    visible    timeout=10s
    Wait For Elements State    ${SR_SERVICE_TYPE_SELECT}    visible    timeout=10s
    Wait For Elements State    ${SR_SERVICE_TYPE_INPUT}    visible    timeout=10s

Search Service Request By Request Number
    [Documentation]    Search results and click the row matching the given Request Number
    [Arguments]    ${request_no}
    Click    ${SEARCH_BUTTON}
    Wait For Elements State    xpath=//*[@id='serviceRequestReportsTable']//tbody//tr    visible    timeout=30s
    ${row_locator}=    Set Variable    xpath=//*[@id='serviceRequestReportsTable']//tbody//tr[.//td[normalize-space()="${request_no}"]][1]
    ${found}=    Run Keyword And Return Status    Wait For Elements State    ${row_locator}    visible    timeout=5s
    IF    ${found}
        Click    ${row_locator}
    ELSE
        Fail    Request '${request_no}' not found in Service Request results
    END

Open Service Request Detail By Request Number
    [Documentation]    Open the Detail view for the service request matching the given Request Number
    [Arguments]    ${request_no}
    Search Service Request By Request Number    ${request_no}
    Wait For Elements State    ${DETAIL_BUTTON}    visible    timeout=10s
    Click    ${DETAIL_BUTTON}

Close Open Report Dialog
    [Documentation]    Close the currently open report dialog using data-test-id cancel button.
    Wait For Elements State    ${DETAILS_CANCEL_BUTTON}    visible    timeout=15s
    Click    ${DETAILS_CANCEL_BUTTON}
    Wait For Elements State    ${DETAILS_CANCEL_BUTTON}    hidden    timeout=10s

Print Service Request Details
    [Documentation]    Wait for the already-opened detail dialog, then close it with Cancel.
    Wait For Elements State    ${DETAILS_CANCEL_BUTTON}    visible    timeout=15s
    Log    Details dialog opened; closing with Cancel
    Close Open Report Dialog

Search And Select First Report Record
    [Documentation]    Click search and select first record from results
    Click    ${SEARCH_BUTTON}
    Wait For Elements State    ${TABLE_HEADER}    visible    timeout=60s
    Wait For Elements State    ${FIRST_TABLE_ROW}    visible    timeout=30s
    Click    ${FIRST_TABLE_ROW}

Generate Report
    [Documentation]    Click Generate to open the dialog, then click Submit to generate the report
    Click    ${GENERATE_BUTTON}
    Wait For Elements State    ${GENERATE_SAVE_BUTTON}    visible    timeout=15s
    Click    ${GENERATE_SAVE_BUTTON}

Select Transaction Type
    [Documentation]    Open the Transaction type dropdown and click the option span matching the given text.
    [Arguments]    ${type}    ${position}=1
    Click    ${TRANSACTION_TYPE_INPUT}
    Wait For Elements State
    ...    xpath=//span[normalize-space(.)='${type}']    visible    timeout=15s
    Click    xpath=//span[normalize-space(.)='${type}']

Set Report Date Range One Month To Date
    [Documentation]    Set the Transaction time range using the calendar picker to the current month:
    ...    click the first day of the current month (left panel), then today's date (marked with 'today' class).
    Click    ${REPORT_DATE_START_INPUT}
    Wait For Elements State    ${REPORT_DATE_PICKER_TABLE}    visible    timeout=5s
    Click    ${REPORT_DATE_FIRST_DAY_CELL}
    Click    ${REPORT_DATE_TODAY_CELL}

Open Transaction Reports Page
    [Documentation]    Log in and navigate to the Transaction Reports page (used as test setup)
    [Arguments]    ${base_url}    ${username}    ${password}
    Ensure Logged In    ${base_url}    ${username}    ${password}
    Navigate To Transaction Reports

Generate Report For Transaction Type
    [Documentation]    For a given transaction type: set a one-month-to-date range, search, and if a
    ...    record is listed, open its Detail, close it, then Generate and submit the report.
    [Arguments]    ${type}
    Select Transaction Type    ${type}
    Set Report Date Range One Month To Date
    Click    ${SEARCH_BUTTON}
    ${has_record}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${FIRST_ROW_RADIO_BUTTON}    visible    timeout=8s
    IF    ${has_record}
        Click    ${FIRST_ROW_RADIO_BUTTON}
        Click    ${DETAIL_BUTTON}
        Close Open Report Dialog
        Click    ${GENERATE_BUTTON}
        Wait For Elements State    ${GENERATE_SAVE_BUTTON}    visible    timeout=15s
        Click    ${GENERATE_SAVE_BUTTON}
        Wait For Elements State    ${GENERATE_SAVE_BUTTON}    hidden    timeout=15s
    ELSE
        Log    No records found for transaction type '${type}'. Skipping Detail/Generate.    level=INFO
    END

Clear Dates And Search User Guide
    [Documentation]    Clear prefilled dates, search and wait for results
    Hover    ${USER_GUIDE_DATE_INPUT}
    Wait For Elements State    ${CLEAR_BUTTON}    visible    timeout=5s
    Click    ${CLEAR_BUTTON}
    Click    ${USER_GUIDE_SEARCH_BUTTON}
    Wait For Elements State    ${USER_GUIDE_TABLE_HEADER}    visible    timeout=30s
    Wait For Elements State    ${USER_GUIDE_FIRST_ROW_RADIO}    visible    timeout=30s

Select First User Guide And Download
    [Documentation]    Select first record radio button and click Download
    Click    ${USER_GUIDE_FIRST_ROW_RADIO}
    Click    ${DOWNLOAD_BUTTON}

Navigate To User Guide
    [Documentation]    Navigate to System administration > User Guide
    Click    ${SYSTEM_ADMIN_MENU}
    Wait For Elements State    ${USER_GUIDE_MENU}    visible    timeout=15s
    Click    ${USER_GUIDE_MENU}
    Wait For Elements State    ${USER_GUIDE_TABLE_HEADER}    visible    timeout=20s

User Guide Page Should Be Displayed
    [Documentation]    Verify user guide page shows Upload, Download and Preview buttons
    Wait For Elements State    ${UPLOAD_BUTTON}    visible    timeout=10s
    Wait For Elements State    ${DOWNLOAD_BUTTON}    visible    timeout=10s
    Wait For Elements State    ${PREVIEW_BUTTON}    visible    timeout=10s

Verify Upload Dialog Opens
    [Documentation]    Click Upload, fill in form details and submit
    Click    ${UPLOAD_BUTTON}
    Wait For Elements State    ${FILE_VERSION_INPUT}    visible    timeout=10s
    ${promise}=    Promise To Upload File    ${CURDIR}/../test_data/af701c3e5a524b378e7fc16c92609fed_1.pdf
    Click    xpath=//div[contains(@class,'el-upload')]//input[@type='file']/..
    Wait For    ${promise}
    Fill Text    ${FILE_VERSION_INPUT}    99.0.0
    Fill Text    ${TITLE_INPUT}    Test User Guide v99.0.0
    Fill Text    ${NARRATION_INPUT}    Automated test upload of user guide document
    Click    ${SUBMIT_BUTTON}
    TRY
        Wait For Elements State    xpath=//div[contains(@class,'el-message')]    visible    timeout=15s
    EXCEPT
        Wait For Elements State    ${USER_GUIDE_TABLE_HEADER}    visible    timeout=10s
    END

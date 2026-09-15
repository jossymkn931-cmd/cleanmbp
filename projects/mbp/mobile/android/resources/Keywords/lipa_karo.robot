*** Settings ***
Documentation    Lipa Karo payment keywords from Transact
Library          AppiumLibrary
Library          String
Library          DateTime
Resource         ../locators/lipa_karo_locators.robot
Resource         ../locators/send_money_locators.robot
Resource         send_money.robot


*** Keywords ***
Open Lipa Karo From Transact
    [Documentation]    Navigate Transact and open Lipa Karo.

    Wait Until Element Is Visible    ${LIPA_KARO_TRANSACT_TAB}    timeout=30s
    Click Element    ${LIPA_KARO_TRANSACT_TAB}
    Scroll Transact Menu To Lipa Karo
    Wait Until Element Is Visible    ${LIPA_KARO_TILE}    timeout=15s
    ${parent_ok}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${LIPA_KARO_TILE_CLICKABLE}
    IF    ${parent_ok}
        Click Element    ${LIPA_KARO_TILE_CLICKABLE}
    ELSE
        Click Element    ${LIPA_KARO_TILE}
    END
    Wait Until Element Is Visible    ${LIPA_KARO_SCHOOL_PLACEHOLDER}    timeout=30s


Scroll Transact Menu To Lipa Karo
    [Documentation]    Swipe Transact menu until Lipa Karo tile is visible.

    FOR    ${i}    IN RANGE    8
        ${found}=    Run Keyword And Return Status
        ...    Page Should Contain Element    ${LIPA_KARO_TILE}
        IF    ${found}    RETURN
        Swipe    start_x=540    start_y=1800    end_x=540    end_y=700    duration=200ms
    END
    Wait Until Element Is Visible    ${LIPA_KARO_TILE}    timeout=10s


Tap Element Center
    [Arguments]    ${locator}
    [Documentation]    Tap the painted center of a non-clickable Ionic control.

    ${loc}=     Get Element Location    ${locator}
    ${size}=    Get Element Size        ${locator}
    ${x}=    Evaluate    int(${loc}[x] + ${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y] + ${size}[height] / 2)
    Tap With Positions    200ms    ${{(int($x), int($y))}}


Search And Select Lipa Karo School
    [Arguments]    ${school_name}
    [Documentation]    Open school picker via the search icon, search, and select school.

    Wait Until Element Is Visible    ${LIPA_KARO_SCHOOL_PLACEHOLDER}    timeout=20s
    Wait Until Element Is Visible    ${LIPA_KARO_SCHOOL_SEARCH_ICON}    timeout=10s
    Tap Element Center    ${LIPA_KARO_SCHOOL_SEARCH_ICON}
    Wait Until Element Is Visible    ${LIPA_KARO_SEARCH_SHEET_TITLE}    timeout=15s

    ${search_ready}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${LIPA_KARO_SCHOOL_SEARCH}    timeout=10s
    IF    not ${search_ready}
        Wait Until Element Is Visible    ${LIPA_KARO_SCHOOL_SEARCH_ANY}    timeout=15s
        Input Text    ${LIPA_KARO_SCHOOL_SEARCH_ANY}    ${school_name}
    ELSE
        Input Text    ${LIPA_KARO_SCHOOL_SEARCH}    ${school_name}
    END

    ${result}=    Format String    ${LIPA_KARO_SCHOOL_RESULT}    ${school_name}
    Wait Until Element Is Visible    ${result}    timeout=30s
    Click Element    ${result}
    Wait Until Element Is Visible    ${LIPA_KARO_ACCOUNT_PLACEHOLDER}    timeout=20s


Select Lipa Karo School Account
    [Arguments]    ${account_number}=${LIPA_KARO_SCHOOL_ACCOUNT}
    [Documentation]    Open school bank account sheet, pick account, Continue.

    Wait Until Element Is Visible    ${LIPA_KARO_ACCOUNT_FIELD}    timeout=20s
    Tap Element Center    ${LIPA_KARO_ACCOUNT_FIELD}
    Wait Until Element Is Visible    ${LIPA_KARO_ACCOUNT_SHEET_TITLE}    timeout=15s
    ${account}=    Format String    ${LIPA_KARO_ACCOUNT_NUMBER}    ${account_number}
    Wait Until Element Is Visible    ${account}    timeout=15s
    Click Element    ${account}

    ${cont}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${LIPA_KARO_ACCOUNT_CONTINUE}    timeout=8s
    IF    ${cont}
        Click Element    ${LIPA_KARO_ACCOUNT_CONTINUE}
    ELSE
        Wait Until Element Is Visible    ${LIPA_KARO_ACCOUNT_CONTINUE_ALT}    timeout=8s
        Click Element    ${LIPA_KARO_ACCOUNT_CONTINUE_ALT}
    END
    Wait Until Element Is Visible    ${LIPA_KARO_ADMISSION_LABEL}    timeout=20s


Enter Lipa Karo Admission Number
    [Arguments]    ${admission_number}
    [Documentation]    Enter the student admission number.

    ${ready}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${LIPA_KARO_ADMISSION_INPUT}    timeout=8s
    IF    not ${ready}
        ${please}=    Run Keyword And Return Status
        ...    Page Should Contain Element    ${LIPA_KARO_ADMISSION_PLEASE_ENTER}
        IF    ${please}
            Tap Element Center    ${LIPA_KARO_ADMISSION_PLEASE_ENTER}
        END
        ${ready}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${LIPA_KARO_ADMISSION_INPUT}    timeout=8s
        IF    not ${ready}
            Wait Until Element Is Visible    ${LIPA_KARO_ADMISSION_INPUT_ALT}    timeout=15s
            Input Text    ${LIPA_KARO_ADMISSION_INPUT_ALT}    ${admission_number}
            RETURN
        END
    END
    Click Element    ${LIPA_KARO_ADMISSION_INPUT}
    Clear Text    ${LIPA_KARO_ADMISSION_INPUT}
    Input Text    ${LIPA_KARO_ADMISSION_INPUT}    ${admission_number}


Generate Random Admission Number
    [Documentation]    Build a simple random admission number for the journey.
    ${stamp}=    Get Current Date    result_format=%H%M%S
    ${admission}=    Set Variable    AG${stamp}
    RETURN    ${admission}


Enter Lipa Karo Student Name
    [Arguments]    ${student_name}
    [Documentation]    Enter the student's name required for Lipa Karo.

    Wait Until Element Is Visible    ${LIPA_KARO_STUDENT_NAME_LABEL}    timeout=15s
    ${placeholder}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${LIPA_KARO_STUDENT_NAME_PLACEHOLDER}
    IF    ${placeholder}
        Tap Element Center    ${LIPA_KARO_STUDENT_NAME_PLACEHOLDER}
    ELSE
        Tap Element Center    ${LIPA_KARO_STUDENT_NAME_LABEL}
    END
    Wait Until Element Is Visible    ${LIPA_KARO_STUDENT_NAME_INPUT}    timeout=15s
    Input Text    ${LIPA_KARO_STUDENT_NAME_INPUT}    ${student_name}


Enter Lipa Karo Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Focus amount, type value, confirm formatted label.

    Wait Until Element Is Visible    ${LIPA_KARO_AMOUNT_PLACEHOLDER}    timeout=20s
    Tap Element Center    ${LIPA_KARO_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${LIPA_KARO_AMOUNT_INPUT}    timeout=15s
    Input Text    ${LIPA_KARO_AMOUNT_INPUT}    ${amount}
    ${value}=    Format String    ${LIPA_KARO_AMOUNT_VALUE}    ${formatted_amount}
    Wait Until Element Is Visible    ${value}    timeout=15s


Verify Lipa Karo Payment Was Submitted
    [Arguments]    ${expected_amount}    ${school_name}=${LIPA_KARO_SCHOOL_NAME}
    [Documentation]    Confirm Request Sent receipt for Lipa Karo.

    Wait Until Element Is Visible    ${LIPA_KARO_RESULT_TITLE}    timeout=120s
    Wait Until Element Is Visible    ${LIPA_KARO_RESULT_STATUS}    timeout=15s
    Page Should Contain Text    ${expected_amount}
    Page Should Contain Text    ${school_name}
    Page Should Contain Text    Lipa Karo
    Page Should Contain Text    Transaction ID
    Expect Element    ${SEND_DONE_BUTTON}    visible

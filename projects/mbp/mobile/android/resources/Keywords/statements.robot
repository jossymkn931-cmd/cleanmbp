*** Settings ***
Documentation    Manage Statements / Get Statements keywords
Library          AppiumLibrary
Library          String
Resource         ../locators/statements_locators.robot
Resource         ../variables/test_data.robot


*** Keywords ***
Open Manage Statements From Transact
    [Documentation]    Transact → Manage Statements hub (My Statements).

    Wait Until Element Is Visible    ${STATEMENTS_TRANSACT_TAB}    timeout=30s
    Click Element    ${STATEMENTS_TRANSACT_TAB}
    Scroll Until Statements Tile Visible
    Wait Until Keyword Succeeds    15s    1s    Tap Manage Statements Tile
    Wait Until Element Is Visible    ${STATEMENTS_HUB_TITLE}    timeout=30s
    Wait Until Element Is Visible    ${STATEMENTS_GET_BUTTON}    timeout=15s


Tap Manage Statements Tile
    [Documentation]    Tap the Manage Statements tile by painted center.
    ...                Label TextViews are often non-clickable on this menu.

    Wait Until Page Contains Element    ${STATEMENTS_TILE}    timeout=5s
    ${parent_ok}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${STATEMENTS_TILE_CLICKABLE}
    ${target}=    Set Variable If    ${parent_ok}    ${STATEMENTS_TILE_CLICKABLE}    ${STATEMENTS_TILE}
    Tap Statements Control    ${target}


Scroll Until Statements Tile Visible
    [Documentation]    Fling the Transact menu until Manage Statements is on screen.

    FOR    ${i}    IN RANGE    12
        ${visible}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${STATEMENTS_TILE}    timeout=0.8s
        IF    ${visible}
            ${loc}=    Get Element Location    ${STATEMENTS_TILE}
            ${y}=    Set Variable    ${loc}[y]
            IF    ${y} >= 350 and ${y} <= 2100    RETURN
        END
        Swipe    start_x=540    start_y=1900    end_x=540    end_y=700    duration=200ms
    END
    Wait Until Element Is Visible    ${STATEMENTS_TILE}    timeout=5s


Verify Statements Hub Is Displayed
    [Documentation]    My Statements hub is open after Manage Statements.
    ...                Empty accounts still show the hub chrome and Get Statements CTA;
    ...                scheduled lists share the same title.

    Wait Until Element Is Visible    ${STATEMENTS_HUB_TITLE}    timeout=30s
    Wait Until Element Is Visible    ${STATEMENTS_GET_BUTTON}    timeout=15s
    ${has_subtitle}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${STATEMENTS_HUB_SUBTITLE}
    ${has_empty}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${STATEMENTS_HUB_EMPTY}
    IF    not ${has_subtitle} and not ${has_empty}
        Log    Hub has neither empty-state copy nor subtitle — assuming a non-empty list.
    END


Verify Statement Account Is Shown
    [Arguments]    ${account}=${ACCOUNT_MASKED}
    [Documentation]    Get Statements form shows the customer's masked account under Select Account.

    Wait Until Element Is Visible    ${STATEMENTS_SELECT_ACCOUNT_LABEL}    timeout=15s
    Wait Until Element Is Visible    ${STATEMENTS_ACCOUNT_VALUE}    timeout=15s
    ${actual}=    Get Text    ${STATEMENTS_ACCOUNT_VALUE}
    Should Be Equal    ${actual}    ${account}
    ...    msg=Expected statement account '${account}' but form shows '${actual}'
    ...    values=${FALSE}


Open Get Statements Form
    [Documentation]    From My Statements hub, open the Get Statements request form.

    Wait Until Element Is Visible    ${STATEMENTS_GET_BUTTON}    timeout=30s
    Click Element    ${STATEMENTS_GET_BUTTON}
    Wait Until Element Is Visible    ${STATEMENTS_FORM_TITLE}    timeout=30s
    Wait Until Element Is Visible    ${STATEMENTS_PERIOD_LABEL}    timeout=15s


Tap Statements Control
    [Arguments]    ${locator}
    [Documentation]    Tap painted center. Dropdown rows and sheet options are
    ...                non-clickable TextViews — Click Element does nothing on them.

    ${loc}=     Get Element Location    ${locator}
    ${size}=    Get Element Size        ${locator}
    ${x}=    Evaluate    int(${loc}[x] + ${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y] + ${size}[height] / 2)
    Tap With Positions    200ms    ${{(int($x), int($y))}}


Select Statement Period One Month
    [Documentation]    Choose the 1 Month period radio (content-desc=period_1M).

    Wait Until Element Is Visible    ${STATEMENTS_PERIOD_1M}    timeout=15s
    Click Element    ${STATEMENTS_PERIOD_1M}


Select Statement Format PDF
    [Documentation]    Open Statement Format sheet and pick PDF.
    ...                Sheet options are non-clickable TextViews — tap by center.
    ...                Prefer the bottom-sheet row (last PDF) over any form value.

    Wait Until Element Is Visible    ${STATEMENTS_FORMAT_DROPDOWN}    timeout=15s
    Tap Statements Control    ${STATEMENTS_FORMAT_DROPDOWN}
    Wait Until Element Is Visible    ${STATEMENTS_FORMAT_OPTION_PDF}    timeout=15s
    Tap Statements Control    xpath=(//android.widget.TextView[@text='PDF'])[last()]
    Wait Until Element Is Visible    ${STATEMENTS_FORMAT_VALUE_PDF}    timeout=15s


Select Statement Delivery Via Email
    [Documentation]    Open Delivery Method sheet and pick Via Email.

    Wait Until Element Is Visible    ${STATEMENTS_DELIVERY_DROPDOWN}    timeout=15s
    Tap Statements Control    ${STATEMENTS_DELIVERY_DROPDOWN}
    Wait Until Element Is Visible    ${STATEMENTS_DELIVERY_VIA_EMAIL}    timeout=15s
    Tap Statements Control    ${STATEMENTS_DELIVERY_VIA_EMAIL}
    Wait Until Element Is Visible    ${STATEMENTS_DELIVERY_VALUE_EMAIL}    timeout=15s


Enter Statement Email
    [Arguments]    ${email}=${STATEMENT_EMAIL}
    [Documentation]    Type the delivery email and dismiss the keyboard so Submit is visible.
    ...                Ionic rotates ion-input resource-ids after focus, so Clear Text on the
    ...                original locator fails — type into whatever EditText is present.

    ${field}=    Set Variable    ${STATEMENTS_EMAIL_INPUT}
    ${ok}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${field}    timeout=5s
    IF    not ${ok}
        ${field}=    Set Variable    ${STATEMENTS_EMAIL_INPUT_ANY}
        Wait Until Element Is Visible    ${field}    timeout=15s
    END
    Click Element    ${field}
    Sleep    0.3s
    # Re-resolve after focus — Ionic may rebuild the input node.
    ${field}=    Set Variable    ${STATEMENTS_EMAIL_INPUT_ANY}
    Wait Until Element Is Visible    ${field}    timeout=10s
    Input Text    ${field}    ${email}
    Run Keyword And Ignore Error    Hide Keyboard
    Sleep    0.5s
    ${actual}=    Get Text    ${STATEMENTS_EMAIL_INPUT_ANY}
    Should Be Equal    ${actual}    ${email}
    ...    msg=Expected statement email '${email}' but field has '${actual}'
    ...    values=${FALSE}


Submit Get Statements Form
    [Documentation]    Tap Get Statements once the form enables it; opens Confirm Summary.

    Wait Until Element Is Visible    ${STATEMENTS_SUBMIT_BUTTON}    timeout=15s
    Wait Until Keyword Succeeds    20s    1s    Expect Element    ${STATEMENTS_SUBMIT_BUTTON}    enabled
    Click Element    ${STATEMENTS_SUBMIT_BUTTON}
    Wait Until Element Is Visible    ${STATEMENTS_CONFIRM_TITLE}    timeout=30s


Verify Statements Confirm Summary
    [Arguments]    ${email}=${STATEMENT_EMAIL}    ${format}=PDF
    [Documentation]    Confirm sheet shows format and email before Continue.
    ...                Period is a date range the app computes; only assert it is non-empty.

    Wait Until Element Is Visible    ${STATEMENTS_CONFIRM_TITLE}    timeout=30s

    ${period}=    Get Text    ${STATEMENTS_CONFIRM_PERIOD}
    ${period}=    Strip String    ${period}
    Should Not Be Empty    ${period}    msg=Confirm Summary has no period range

    ${fmt}=    Get Text    ${STATEMENTS_CONFIRM_FORMAT}
    ${fmt}=    Strip String    ${fmt}
    Should Be Equal    ${fmt}    ${format}
    ...    msg=Confirm format is '${fmt}', expected '${format}'
    ...    values=${FALSE}

    ${mail}=    Get Text    ${STATEMENTS_CONFIRM_EMAIL}
    ${mail}=    Strip String    ${mail}
    Should Be Equal    ${mail}    ${email}
    ...    msg=Confirm email is '${mail}', expected '${email}'
    ...    values=${FALSE}


Confirm Get Statements Request
    [Documentation]    Tap Continue on Confirm Summary (content-desc=continue, empty text).

    Wait Until Element Is Visible    ${STATEMENTS_CONTINUE_BUTTON}    timeout=15s
    Click Element    ${STATEMENTS_CONTINUE_BUTTON}


Verify Statement Email Verification Screen
    [Documentation]    After Continue, app asks for the email OTP before issuing the statement.

    Wait Until Element Is Visible    ${STATEMENTS_VERIFY_EMAIL_TITLE}    timeout=30s
    Wait Until Element Is Visible    ${STATEMENTS_VERIFY_EMAIL_BODY}    timeout=15s

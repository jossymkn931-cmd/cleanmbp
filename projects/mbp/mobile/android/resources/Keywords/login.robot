*** Settings ***
Documentation    Mobile Android login keywords
Library          AppiumLibrary
Library          String
Library          ../libraries/image_assertions.py
Resource         ../locators/login_locators.robot


*** Keywords ***
Verify Saved Number Login Screen Is Visible
    [Documentation]    Welcome-back screen with the saved-number login control.

    ${ok}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${LOGIN_AS_SAVED_NUMBER_BUTTON}    timeout=20s
    IF    not ${ok}
        Wait Until Element Is Visible    ${LOGIN_AS_SAVED_NUMBER_BUTTON_ALT}    timeout=10s
    END


Resolve Login As Button
    [Documentation]    Prefer resource-id container; fall back to Log in as text button.

    ${ok}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${LOGIN_AS_SAVED_NUMBER_BUTTON}
    IF    ${ok}    RETURN    ${LOGIN_AS_SAVED_NUMBER_BUTTON}
    RETURN    ${LOGIN_AS_SAVED_NUMBER_BUTTON_ALT}


Tap Login As Saved Number
    [Documentation]    Open PIN entry from the welcome-back screen.
    ...                Prefer a normal click on the Log in as button. If PIN does not
    ...                open (common right after Restart Application), center-tap once.

    Verify Saved Number Login Screen Is Visible
    ${btn}=    Resolve Login As Button
    Click Element    ${btn}

    ${pin_up}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${MOBILE_PIN_TITLE}    timeout=8s
    IF    not ${pin_up}
        ${btn}=    Resolve Login As Button
        ${tapped}=    Run Keyword And Return Status    Tap Login Control Center    ${btn}
        IF    not ${tapped}
            Click Element    ${btn}
        END
        Wait Until Element Is Visible    ${MOBILE_PIN_TITLE}    timeout=15s
    END


Tap Login Control Center
    [Arguments]    ${locator}
    [Documentation]    Tap the painted center of a login control (W3C pointer fallback).

    ${loc}=     Get Element Location    ${locator}
    ${size}=    Get Element Size        ${locator}
    ${x}=    Evaluate    int(${loc}[x] + ${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y] + ${size}[height] / 2)
    Tap With Positions    300ms    ${{(int($x), int($y))}}


Verify Pin Screen Is Visible
    [Documentation]    PIN title and on-screen keypad are showing.

    Wait Until Element Is Visible    ${MOBILE_PIN_TITLE}    timeout=10s
    Wait Until Element Is Visible    ${MOBILE_PIN_KEYPAD}    timeout=8s


Enter Mobile Pin
    [Arguments]    ${pin}
    [Documentation]    Enter PIN on the in-app keypad (field is not typeable).
    ...                Keypad auto-submits after the last digit — no login button.
    ...                Per-digit waits stay short; keys are already painted.

    Wait Until Element Is Visible    ${MOBILE_PIN_KEYPAD}    timeout=8s
    @{digits}=    Split String To Characters    ${pin}
    FOR    ${digit}    IN    @{digits}
        ${key}=    Format String    ${MOBILE_PIN_KEY}    ${digit}
        Click Element    ${key}
    END


Open Pin Screen
    [Documentation]    Welcome-back → PIN. Single path used by login tests and helpers.

    Tap Login As Saved Number
    Verify Pin Screen Is Visible


Return To Saved Number Login
    [Documentation]    Android back from PIN to welcome-back / saved-number login.

    Press Keycode    4
    Verify Saved Number Login Screen Is Visible


Verify Dashboard Is Displayed
    [Documentation]    Bottom-nav Home is visible after a successful login.

    Wait Until Element Is Visible    ${MOBILE_DASHBOARD_HOME}    timeout=45s


Login With Saved Number
    [Arguments]    ${pin}=${MOBILE_PIN}
    [Documentation]    Full login to dashboard for tests that need an authenticated session.

    Open Pin Screen
    Enter Mobile Pin    ${pin}
    Verify Dashboard Is Displayed


Show Account Balance
    [Documentation]    Tap the eye icon beside the balance to reveal the amount.

    Wait Until Element Is Visible    ${MOBILE_BALANCE_AMOUNT}    timeout=30s
    Click Element    ${MOBILE_BALANCE_TOGGLE}


Balance Should Be Unmasked
    [Documentation]    Fail while the balance still shows masking asterisks.

    ${balance}=    Get Text    ${MOBILE_BALANCE_AMOUNT}
    Should Not Contain    ${balance}    *    msg=Balance is still masked: ${balance}


Verify Account Balance Is Displayed
    [Documentation]    Balance is revealed as an actual KES amount.

    Wait Until Keyword Succeeds    15s    1s    Balance Should Be Unmasked
    ${balance}=    Get Text    ${MOBILE_BALANCE_AMOUNT}
    Should Contain    ${balance}    KES
    RETURN    ${balance}


Verify Login Error Message
    [Documentation]    Invalid-PIN banner is painted but missing from the a11y tree.

    ${screenshot}=    Set Variable    ${OUTPUT DIR}${/}login_error.png
    Wait Until Keyword Succeeds    20s    1s    Capture And Verify Login Error Banner    ${screenshot}


Capture And Verify Login Error Banner
    [Arguments]    ${screenshot}
    Capture Page Screenshot    ${screenshot}
    Login Error Banner Should Be Visible    ${screenshot}

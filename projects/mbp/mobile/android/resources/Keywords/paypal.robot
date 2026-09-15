*** Settings ***
Documentation    PayPal keywords for opening the module from the Transact tab.
Library          AppiumLibrary
Library          Process
Resource         ../locators/paypal_locators.robot
Resource         ../variables/test_data.robot
Resource         send_money.robot


*** Keywords ***
Open PayPal From Transact
    [Documentation]    Navigate Transact → scroll to PayPal → open module → enter PIN.
    ...                Success is the Agree/Disagree consent screen after PIN.
    [Arguments]    ${pin}=${MOBILE_PIN}

    Wait Until Element Is Visible    ${PAYPAL_TRANSACT_TAB}    timeout=30s
    Click Element    ${PAYPAL_TRANSACT_TAB}
    Scroll Transact Menu To PayPal
    Wait Until Keyword Succeeds    20s    1s    Tap PayPal Tile
    Enter Transaction Pin    ${pin}
    Wait Until Element Is Visible    ${PAYPAL_CONSENT_SCREEN}    timeout=30s


Tap PayPal Tile
    [Documentation]    Re-find exact PayPal label, verify text, tap tile center only.

    Wait Until Page Contains Element    ${PAYPAL_TILE}    timeout=5s
    ${label}=    Get Text    ${PAYPAL_TILE}
    Should Be Equal    ${label}    PayPal
    ...    msg=Expected tile text 'PayPal' but found '${label}' — refusing to tap (avoids PAPSS)
    ...    values=${FALSE}

    ${parent_ok}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${PAYPAL_TILE_CLICKABLE}
    ${target}=    Set Variable If    ${parent_ok}    ${PAYPAL_TILE_CLICKABLE}    ${PAYPAL_TILE}

    ${loc}=    Get Element Location    ${target}
    ${size}=    Get Element Size    ${target}
    ${x}=    Evaluate    int(${loc}[x]) + int(${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y]) + int(${size}[height] / 2)
    # Only tap when the tile is mid-screen (edge taps often hit a neighbour like PAPSS)
    IF    ${y} < 350 or ${y} > 2100
        Fail    PayPal tile y=${y} is at screen edge — scroll again before tap
    END
    Tap With Positions    150ms    ${{ (${x}, ${y}) }}


Scroll Transact Menu To PayPal
    [Documentation]    Swipe until exact PayPal tile is on screen and not at the edge.

    FOR    ${i}    IN RANGE    10
        ${found}=    Run Keyword And Return Status
        ...    Page Should Contain Element    ${PAYPAL_TILE}
        IF    ${found}
            ${label}=    Get Text    ${PAYPAL_TILE}
            IF    '${label}' == 'PayPal'
                ${loc}=    Get Element Location    ${PAYPAL_TILE}
                ${y}=    Set Variable    ${loc}[y]
                IF    ${y} >= 350 and ${y} <= 2100    RETURN
            END
        END
        Swipe    start_x=540    start_y=1900    end_x=540    end_y=700    duration=200ms
    END
    Page Should Contain Element    ${PAYPAL_TILE}
    ${label}=    Get Text    ${PAYPAL_TILE}
    Should Be Equal    ${label}    PayPal
    ...    msg=Could not bring exact PayPal tile into view (got '${label}')
    ...    values=${FALSE}


Scroll Until Element Visible
    [Arguments]    ${locator}    ${max_swipes}=12
    [Documentation]    Fast full-height flings until target is visible. No Get Source
    ...                (that dumps the whole tree every swipe and makes the flow crawl).

    FOR    ${i}    IN RANGE    ${max_swipes}
        ${visible}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${locator}    timeout=0.8s
        IF    ${visible}    RETURN
        Swipe    start_x=540    start_y=2200    end_x=540    end_y=300    duration=180ms
    END
    Wait Until Element Is Visible    ${locator}    timeout=8s


Tap PayPal Agree
    [Documentation]    Tap Agree at the bottom of the consent screen.

    Scroll Until Element Visible    ${PAYPAL_AGREE_BUTTON}
    Wait Until Keyword Succeeds    15s    1s    Tap PayPal Agree And Confirm


Tap PayPal Agree And Confirm
    [Documentation]    Re-find Agree, tap center, expect Access PayPal next.

    Wait Until Page Contains Element    ${PAYPAL_AGREE_BUTTON}    timeout=8s
    Click Element    ${PAYPAL_AGREE_BUTTON}
    Wait Until Element Is Visible    ${PAYPAL_ACCESS_BUTTON}    timeout=15s


Tap Access PayPal
    [Documentation]    Wait for accessPayPal button and tap until Link Account shows.

    Wait Until Element Is Visible    ${PAYPAL_ACCESS_BUTTON}    timeout=20s
    Wait Until Keyword Succeeds    20s    1s    Tap Access PayPal And Confirm


Tap Access PayPal And Confirm
    [Documentation]    Click content-desc=accessPayPal; confirm Link Account appears.

    Wait Until Element Is Visible    ${PAYPAL_ACCESS_BUTTON}    timeout=5s
    Click Element    ${PAYPAL_ACCESS_BUTTON}
    Wait Until Element Is Visible    ${PAYPAL_LINK_ACCOUNT_BUTTON}    timeout=8s


Tap Link Account
    [Documentation]    "Link account" is a non-clickable TextView — tap its painted center
    ...                (Click Element is swallowed). Confirm by Terms screen / Accept path.

    Wait Until Element Is Visible    ${PAYPAL_LINK_ACCOUNT_BUTTON}    timeout=30s
    Wait Until Keyword Succeeds    20s    1s    Tap Link Account And Confirm


Tap Link Account And Confirm
    [Documentation]    Re-find Link account label, center-tap, expect Terms next.

    Wait Until Page Contains Element    ${PAYPAL_LINK_ACCOUNT_BUTTON}    timeout=8s
    ${loc}=    Get Element Location    ${PAYPAL_LINK_ACCOUNT_BUTTON}
    ${size}=    Get Element Size    ${PAYPAL_LINK_ACCOUNT_BUTTON}
    ${x}=    Evaluate    int(${loc}[x]) + int(${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y]) + int(${size}[height] / 2)
    Tap With Positions    300ms    ${{ (${x}, ${y}) }}
    ${terms}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${PAYPAL_TERMS_MARKER}    timeout=4s
    IF    ${terms}    RETURN
    ${x2}=    Evaluate    max(80, int(${loc}[x]) - 80)
    Tap With Positions    300ms    ${{ (${x2}, ${y}) }}
    ${terms}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${PAYPAL_TERMS_MARKER}    timeout=4s
    IF    ${terms}    RETURN
    Run Keyword And Ignore Error    Click Text    Link account
    ${has}=    Run Keyword And Return Status    Page Should Contain Element    ${PAYPAL_TERMS_MARKER}
    IF    ${has}    RETURN
    ${has2}=    Run Keyword And Return Status    Page Should Contain Text    Terms
    IF    ${has2}    RETURN
    Fail    Link account tap did not open Terms screen


Accept PayPal Terms And Conditions
    [Documentation]    Terms is a WebView (custom mini-app kernel — no WEBVIEW context
    ...                exposed to Appium). Scroll to the bottom, then tap Accept by
    ...                coordinate (see Tap Accept Terms And Confirm).

    FOR    ${i}    IN RANGE    8
        Swipe    start_x=540    start_y=2000    end_x=540    end_y=350    duration=160ms
    END
    Sleep    0.5s
    Wait Until Keyword Succeeds    40s    2s    Tap Accept Terms And Confirm


PayPal Left Terms Screen
    [Documentation]    True when email / continue appears after Accept (NATIVE context).

    ${email}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${PAYPAL_EMAIL_INPUT}
    IF    ${email}    RETURN    ${TRUE}
    ${edit}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//android.widget.EditText
    IF    ${edit}    RETURN    ${TRUE}
    ${cont}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${PAYPAL_CONTINUE_BUTTON}
    IF    ${cont}    RETURN    ${TRUE}
    ${mail_txt}=    Run Keyword And Return Status    Page Should Contain Text    Email
    IF    ${mail_txt}    RETURN    ${TRUE}
    ${accept_gone}=    Run Keyword And Return Status
    ...    Page Should Not Contain Element    xpath=//*[@content-desc='agree']
    ${terms_gone}=    Run Keyword And Return Status
    ...    Page Should Not Contain Element    ${PAYPAL_TERMS_MARKER}
    IF    ${accept_gone} and ${terms_gone}    RETURN    ${TRUE}
    RETURN    ${FALSE}


Adb Tap Screen Point
    [Arguments]    ${x}    ${y}
    [Documentation]    Device-level tap — works on custom mini-app WebView CTAs
    ...                where Appium's own tap/click is unreliable.

    Run Process    adb    shell    input    tap    ${x}    ${y}
    Sleep    0.4s


Tap Accept Terms And Confirm
    [Documentation]    Accept Terms button confirmed via screenshot pixel analysis:
    ...                blue CTA center sits at ~82% of screen height (not 88-94%
    ...                as with other native buttons). No WEBVIEW context is exposed
    ...                (custom mini-app WebView kernel), so tap by coordinate only.

    ${width}=    Get Window Width
    ${height}=    Get Window Height
    # Primary: exact ratio measured from screenshot (button center y=2020/2460=0.821)
    ${x}=    Evaluate    int(${width} * 0.37)
    ${y}=    Evaluate    int(${height} * 0.821)
    Adb Tap Screen Point    ${x}    ${y}
    ${done}=    PayPal Left Terms Screen
    IF    ${done}    RETURN
    Tap With Positions    300ms    ${{ (${x}, ${y}) }}
    ${done}=    PayPal Left Terms Screen
    IF    ${done}    RETURN

    # Fallback: nearby ratios in case of resolution/DPI variance
    FOR    ${y_ratio}    IN    0.79    0.83    0.80    0.85    0.77
        ${y2}=    Evaluate    int(${height} * ${y_ratio})
        Adb Tap Screen Point    ${x}    ${y2}
        ${done}=    PayPal Left Terms Screen
        IF    ${done}    RETURN
    END

    Fail    Accept Terms & Conditions tap at measured coordinates did not leave Terms screen


Enter PayPal Email And Continue
    [Arguments]    ${email}=${PAYPAL_EMAIL}
    [Documentation]    Scroll to the email field, enter Gmail, tap Continue.

    Scroll Until Element Visible    ${PAYPAL_EMAIL_INPUT}    10
    Wait Until Element Is Visible    ${PAYPAL_EMAIL_INPUT}    timeout=30s
    Clear Text    ${PAYPAL_EMAIL_INPUT}
    Input Text    ${PAYPAL_EMAIL_INPUT}    ${email}
    Run Keyword And Ignore Error    Hide Keyboard
    Scroll Until Element Visible    ${PAYPAL_CONTINUE_BUTTON}    6
    Wait Until Keyword Succeeds    20s    2s    Click Element    ${PAYPAL_CONTINUE_BUTTON}


Verify PayPal Email Verification Popup
    [Documentation]    Confirm the verify-email / verification-code popup is shown.

    Wait Until Element Is Visible    ${PAYPAL_VERIFY_EMAIL_POPUP}    timeout=60s
    Page Should Contain Element    ${PAYPAL_VERIFY_EMAIL_POPUP}


Verify PayPal Module Opened
    [Documentation]    Confirm PayPal opened: Agree/Disagree consent screen is shown.

    Wait Until Element Is Visible    ${PAYPAL_CONSENT_SCREEN}    timeout=30s
    Page Should Contain Element    ${PAYPAL_CONSENT_SCREEN}

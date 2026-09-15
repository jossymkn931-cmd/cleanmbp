*** Settings ***
Documentation    QR Code keywords
Library          AppiumLibrary
Library          String
Resource         ../locators/qr_code_locators.robot
Resource         ../locators/login_locators.robot


*** Keywords ***
Open Qr Code
    [Documentation]    Open the QR screen from the icon in the Home header.
    ...
    ...                The header icons are excluded from the accessibility tree, so
    ...                no locator can reach them. The icon is therefore tapped by
    ...                position, expressed as a fraction of the window so the mapping
    ...                is not bound to a single device.

    Wait Until Element Is Visible    ${MOBILE_DASHBOARD_HOME}    timeout=60s
    # A tap sent mid-render is swallowed, so let the dashboard settle first.
    Sleep    3s

    ${width}=    Get Window Width
    ${height}=    Get Window Height
    ${x}=    Evaluate    int(${width} * ${QR_ICON_X_RATIO})
    ${y}=    Evaluate    int(${height} * ${QR_ICON_Y_RATIO})
    Tap With Positions    200ms    ${{ ($x, $y) }}

    Wait Until Element Is Visible    ${QR_SCREEN_TITLE}    timeout=30s
    Wait Until Element Is Visible    ${QR_MY_QR_TAB}    timeout=30s


Verify My Qr Is Displayed
    [Documentation]    Verify the My QR tab opens with a code ready to share.
    ...                My QR is the tab the screen lands on.

    Wait Until Element Is Visible    ${QR_SELECT_ACCOUNT_LABEL}    timeout=30s
    Expect Element    ${QR_SET_AMOUNT_BUTTON}    visible
    Expect Element    ${QR_DOWNLOAD_BUTTON}    visible
    Expect Element    ${QR_SWITCH_TO_BARCODE}    visible


Verify Qr Source Account Is
    [Arguments]    ${account}
    [Documentation]    Verify the code is generated against the expected account.

    Wait Until Element Is Visible    ${QR_SELECTED_ACCOUNT}    timeout=30s
    ${actual}=    Get Text    ${QR_SELECTED_ACCOUNT}
    Should Be Equal    ${actual}    ${account}
    ...    msg=Expected the QR code to be drawn on '${account}' but it is on '${actual}'


Select Scan Qr Tab
    [Documentation]    Switch to the scanner and wait for the camera to come up.
    ...                The tab occasionally swallows the first tap while the page is
    ...                still settling, so the switch is retried.

    Wait Until Element Is Visible    ${QR_SCAN_TAB}    timeout=30s
    Wait Until Keyword Succeeds    3x    2s    Open Scanner View


Open Scanner View
    [Documentation]    Tap the Scan QR tab and confirm the camera is running.

    Click Element    ${QR_SCAN_TAB}
    Wait Until Element Is Visible    ${QR_SCANNER_HINT}    timeout=20s


Open Set Amount
    [Documentation]    Open the sheet used to attach an amount to the code.

    Wait Until Element Is Visible    ${QR_SET_AMOUNT_BUTTON}    timeout=30s
    Click Element    ${QR_SET_AMOUNT_BUTTON}
    Wait Until Element Is Visible    ${QR_SET_AMOUNT_TITLE}    timeout=30s
    Expect Element    ${QR_GENERATE_BUTTON}    disabled


Enter Qr Amount
    [Arguments]    ${amount}    ${expected_on_form}
    [Documentation]    Enter the amount and verify how the sheet formats it.
    ...                The field is a label until tapped, so it is focused first.
    ...
    ...                The keyboard closes itself once the amount is committed, and it
    ...                must not be dismissed with Hide Keyboard: that sends Back,
    ...                which closes the sheet.

    Wait Until Element Is Visible    ${QR_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${QR_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${QR_AMOUNT_INPUT}    timeout=15s
    Input Text    ${QR_AMOUNT_INPUT}    ${amount}
    ${value}=    Format String    ${QR_AMOUNT_VALUE}    ${expected_on_form}
    Wait Until Element Is Visible    ${value}    timeout=15s


Tap Generate Qr
    [Documentation]    Generate the code and close the sheet.

    Wait Until Element Is Visible    ${QR_GENERATE_BUTTON}    timeout=30s
    Expect Element    ${QR_GENERATE_BUTTON}    enabled
    Click Element    ${QR_GENERATE_BUTTON}
    Expect Element    ${QR_SET_AMOUNT_TITLE}    not visible


Verify Qr Was Generated For
    [Arguments]    ${account}    ${expected_amount}
    [Documentation]    Verify the code carries the account it was drawn on and the
    ...                amount requested.
    ...
    ...                The code itself is rendered on a canvas that Appium cannot
    ...                read, so what it encodes is verified through the account and
    ...                amount the screen prints alongside it.

    Wait Until Element Is Visible    ${QR_AMOUNT_LABEL}    timeout=60s

    ${amount}=    Get Text    ${QR_ENCODED_AMOUNT}
    Should Be Equal    ${amount}    ${expected_amount}    msg=The code was generated for the wrong amount

    Verify Qr Source Account Is    ${account}
    Expect Element    ${QR_DOWNLOAD_BUTTON}    visible
*** Settings ***
Documentation    Keywords for creating a Money Market Fund investment account
Library          AppiumLibrary
Library          OperatingSystem
Library          String
Resource         common.robot
Resource         login.robot
Resource         send_money.robot
Resource         ../locators/mmf_fund_locators.robot
Resource         ../variables/test_data.robot


*** Variables ***
${MMF_TERMS_MAX_SWIPES}      ${40}
${MMF_AGREE_BUTTON_POINT}    ${{(540, 2226)}}


*** Keywords ***
Open Investments
    [Documentation]    Reach the investment product catalogue from the dashboard.
    ...                The home tile is not clickable, so it is tapped where it is painted.

    Wait Until Element Is Visible    ${INVEST_HOME_TILE}    timeout=30s
    Tap Element Centre    ${INVEST_HOME_TILE}
    Wait Until Element Is Visible    ${INVESTMENT_PRODUCTS_TAB}    timeout=30s
    Tap Element Centre    ${INVESTMENT_PRODUCTS_TAB}
    Wait Until Element Is Visible    ${INVESTMENT_FACT_SHEET}    timeout=30s


Open A Fresh Investments Catalogue
    Restart Application
    Login With Saved Number    ${MOBILE_PIN}
    Open Investments


Start Money Market Fund Application
    [Arguments]    ${currency}
    [Documentation]    Open the product page for the given currency fund.

    ${get_started}=    Format String    ${MMF_GET_STARTED_BUTTON}    ${currency}
    Wait Until Element Is Visible    ${get_started}    timeout=30s

    # The catalogue is a WebView and swallows the first tap while it settles.
    FOR    ${i}    IN RANGE    3
        Click Element    ${get_started}
        ${opened}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${MMF_ACCEPT_CONTINUE_BUTTON}    timeout=10s
        IF    ${opened}    RETURN
    END
    Fail    The ${currency} Money Market Fund product page did not open


Accept Money Market Fund Terms
    [Documentation]    Tick the terms box, read the agreement it opens, and continue.

    Reveal Terms Checkbox
    ${already_accepted}=    Get Element Attribute    ${MMF_TERMS_CHECKBOX}    checked
    IF    '${already_accepted}' != 'true'
        Click Element    ${MMF_TERMS_CHECKBOX}
        ${terms_opened}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${MMF_TERMS_AGREE_BUTTON}    timeout=10s
        IF    ${terms_opened}    Read And Agree To The Terms Document
    END

    Wait Until Element Is Visible    ${MMF_ACCEPT_CONTINUE_BUTTON}    timeout=30s
    Click Element    ${MMF_ACCEPT_CONTINUE_BUTTON}
    Wait Until Element Is Visible    ${MMF_DETAILS_TITLE}    timeout=30s


Reveal Terms Checkbox
    [Documentation]    The checkbox sits below the fold of the product page.

    FOR    ${i}    IN RANGE    8
        ${shown}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${MMF_TERMS_CHECKBOX}    timeout=2s
        IF    ${shown}    RETURN
        Swipe    start_x=540    start_y=1700    end_x=540    end_y=950    duration=600ms
    END
    Wait Until Element Is Visible    ${MMF_TERMS_CHECKBOX}    timeout=10s


Read And Agree To The Terms Document
    [Documentation]    Agree stays disabled until the agreement has been read to the end.

    Scroll Terms To The Bottom
    # The rendered agreement leaves the accessibility tree, taking the footer with it,
    # so Agree can only be tapped where it is painted.
    Tap With Positions    200ms    ${MMF_AGREE_BUTTON_POINT}
    Wait Until Element Is Visible    ${MMF_ACCEPT_CONTINUE_BUTTON}    timeout=30s


Scroll Terms To The Bottom
    [Documentation]    The agreement is a multi page document rendered into a WebView that
    ...                reports nothing to the accessibility tree, so neither its length nor
    ...                its scroll position can be read. The end is recognised by the screen
    ...                no longer changing between swipes.

    ${previous}=    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    ${MMF_TERMS_MAX_SWIPES}
        Swipe    start_x=540    start_y=2050    end_x=540    end_y=350    duration=300ms
        Sleep    0.3s
        ${digest}=    Screen Digest
        IF    $digest == $previous    RETURN
        ${previous}=    Set Variable    ${digest}
    END
    Fail    The terms document never reached its end after ${MMF_TERMS_MAX_SWIPES} swipes


Screen Digest
    [Documentation]    A fingerprint of what is currently painted on screen.

    Capture Page Screenshot    mmf_terms_probe.png
    ${bytes}=    Get Binary File    ${OUTPUT DIR}${/}mmf_terms_probe.png
    ${digest}=    Evaluate    hashlib.md5($bytes).hexdigest()    modules=hashlib
    RETURN    ${digest}


Name The Money Market Fund
    [Arguments]    ${fund_name}

    Wait Until Element Is Visible    ${MMF_NAME_INPUT}    timeout=30s
    Input Text    ${MMF_NAME_INPUT}    ${fund_name}
    Run Keyword And Ignore Error    Hide Keyboard
    Field Should Contain Value    ${MMF_NAME_INPUT}    ${fund_name}    MMF name


Select Destination Account
    [Arguments]    ${currency}
    [Documentation]    Choose the account the fund pays withdrawals into, and return its
    ...                masked number. The page defaults to the shilling account, so a
    ...                dollar fund must be pointed at a dollar account explicitly.

    ${marker}=    Account Balance Marker    ${currency}

    Wait Until Element Is Visible    ${MMF_DESTINATION_ACCOUNT_DROPDOWN}    timeout=30s
    Tap Element Centre    ${MMF_DESTINATION_ACCOUNT_DROPDOWN}

    ${row}=      Format String    ${ACCOUNT_PICKER_BALANCE_ROW}    ${marker}
    ${radio}=    Format String    ${ACCOUNT_PICKER_ROW_RADIO}      ${marker}

    # Accounts that cannot fund the investment report no balance, so they never match.
    Wait Until Element Is Visible    ${row}    timeout=30s
    ...    error=No ${currency} account was offered as a destination

    Click Element    ${radio}
    Click Element    ${ACCOUNT_PICKER_CONTINUE_BUTTON}

    # Waiting on the sheet to disappear goes stale as it closes, so the selection is
    # waited on where it lands instead.
    Wait Until Keyword Succeeds    30s    1s    Destination Account Should Be Chosen

    ${account}=    Get Text    ${MMF_DESTINATION_ACCOUNT_DROPDOWN}
    RETURN    ${account.strip()}


Destination Account Should Be Chosen
    ${account}=    Get Text    ${MMF_DESTINATION_ACCOUNT_DROPDOWN}
    Should Contain    ${account}    ****
    ...    msg=The destination account still reads '${account}'
    ...    values=${FALSE}


Account Balance Marker
    [Arguments]    ${currency}
    [Documentation]    How the picker writes each currency on an account's balance line.

    ${marker}=    Set Variable If    '${currency}' == 'USD'    $    ${currency}
    RETURN    ${marker}


Continue To Summary
    Click Element    ${MMF_DETAILS_CONTINUE_BUTTON}
    Wait Until Element Is Visible    ${MMF_SUMMARY_TITLE}    timeout=30s


Verify Money Market Fund Summary
    [Arguments]    ${fund_name}    ${currency}    ${expected_account}
    [Documentation]    The summary is the last point the application can be corrected,
    ...                so what is about to be submitted is checked against what was asked for.

    Field Should Contain Value    ${MMF_SUMMARY_NAME}        ${SPACE}${fund_name}          MMF name
    Field Should Contain Value    ${MMF_SUMMARY_CURRENCY}    ${SPACE}${currency}           MMF currency
    Field Should Contain Value    ${MMF_SUMMARY_ACCOUNT}     ${SPACE}${expected_account}   destination account


Confirm Money Market Fund Application
    Click Element    ${MMF_SUMMARY_CONTINUE_BUTTON}
    Enter Transaction Pin    ${MOBILE_PIN}
    Wait Until Element Is Visible    ${MMF_RESULT_TITLE}    timeout=60s


Verify Money Market Fund Was Submitted
    [Arguments]    ${expected_account}
    [Documentation]    Confirm the receipt describes the account that was applied for,
    ...                and return its reference.

    Field Should Contain Value    ${MMF_RESULT_STATUS}          In Processing                     transaction status
    Field Should Contain Value    ${MMF_RESULT_SERVICE_TYPE}    Create MMF Investment Account     service type
    Field Should Contain Value    ${MMF_RESULT_ACCOUNT}         ${expected_account}               destination account

    ${reference}=    Get Text    ${MMF_RESULT_REFERENCE}
    Should Not Be Empty    ${reference}    msg=The receipt did not show a transaction reference
    RETURN    ${reference}


Dismiss Money Market Fund Receipt
    [Documentation]    Acknowledge the success dialog, then close the receipt behind it.

    ${dialog}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${MMF_SUCCESS_TITLE}    timeout=10s
    IF    ${dialog}
        Click Element    ${MMF_SUCCESS_OKAY_BUTTON}
        Wait Until Page Does Not Contain Element    ${MMF_SUCCESS_TITLE}    timeout=30s
    END

    Click Element    ${MMF_RESULT_DONE_BUTTON}
    Wait Until Element Is Visible    ${INVESTMENT_PRODUCTS_TAB}    timeout=30s


Open My Portfolio
    Wait Until Element Is Visible    ${INVESTMENT_PORTFOLIO_TAB}    timeout=30s
    Tap Element Centre    ${INVESTMENT_PORTFOLIO_TAB}
    Sleep    2s


Refresh Portfolio
    [Documentation]    Pull down to reload the portfolio from the back end.

    Swipe    start_x=540    start_y=700    end_x=540    end_y=1800    duration=800ms
    Sleep    3s


Portfolio Should Contain Fund
    [Arguments]    ${fund_name}    ${attempts}=${6}
    [Documentation]    The application is accepted for processing before the fund exists,
    ...                so the portfolio is refreshed until it reports the new fund.

    Open My Portfolio
    ${entry}=    Format String    ${PORTFOLIO_FUND_ENTRY}    ${fund_name}

    FOR    ${i}    IN RANGE    ${attempts}
        ${found}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${entry}    timeout=5s
        IF    ${found}    RETURN
        Refresh Portfolio
    END
    Fail    The portfolio did not show '${fund_name}' after ${attempts} refreshes


Tap Element Centre
    [Arguments]    ${locator}
    [Documentation]    Tap where the element is painted rather than clicking it.
    ...                The investment screens are WebViews whose tiles and tabs are not
    ...                themselves clickable, so an element click is swallowed.

    ${loc}=     Get Element Location    ${locator}
    ${size}=    Get Element Size        ${locator}
    ${x}=    Evaluate    int(${loc}[x] + ${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y] + ${size}[height] / 2)
    Tap With Positions    300ms    ${{(int($x), int($y))}}


Generate Fund Name
    [Arguments]    ${prefix}
    [Documentation]    A fund name is retained by the account, so each run needs its own.

    ${stamp}=    Get Time    epoch
    RETURN    ${prefix} ${stamp}

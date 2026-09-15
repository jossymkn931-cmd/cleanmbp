*** Settings ***
Documentation    Keywords for the MMF Calculator
Library          AppiumLibrary
Library          String
Resource         common.robot
Resource         login.robot
Resource         calculators.robot
Resource         ../locators/mmf_locators.robot
Resource         ../variables/test_data.robot


*** Keywords ***
Open MMF Calculator
    Wait Until Element Is Visible    ${MMF_CALCULATOR_TILE}    timeout=30s
    Tap Element Center    ${MMF_CALCULATOR_TILE}
    Wait Until Element Is Visible    ${MMF_INVESTMENT_TYPE_LABEL}    timeout=30s

Open A Fresh MMF Calculator
    [Documentation]    Start from an uncosted calculator, for the cases that depend on
    ...                nothing having been projected yet.

    Restart Application
    Login With Saved Number    ${MOBILE_PIN}
    Open Calculators
    Open MMF Calculator

Ensure MMF Calculator Is Open
    ${on_form}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${MMF_INVESTMENT_TYPE_LABEL}
    IF    not ${on_form}    Open A Fresh MMF Calculator

Select Investment Type
    [Arguments]    ${investment_type}

    Scroll Form To Top
    Wait Until Element Is Visible    ${MMF_INVESTMENT_TYPE_VALUE}    timeout=30s
    Tap Element Center    ${MMF_INVESTMENT_TYPE_VALUE}
    Wait Until Element Is Visible    ${MMF_INVESTMENT_SHEET}    timeout=30s

    ${option}=    Format String    ${MMF_INVESTMENT_OPTION}    ${investment_type}
    Tap Element Center    ${option}

    Wait Until Page Does Not Contain Element    ${MMF_INVESTMENT_SHEET}    timeout=30s
    Wait Until Keyword Succeeds    15s    1s
    ...    Field Should Contain Value    ${MMF_INVESTMENT_TYPE_VALUE}    ${investment_type}    investment type

Enter Initial Capital
    [Arguments]    ${amount}    ${formatted_amount}
    Enter MMF Amount    ${MMF_CAPITAL_VALUE}    ${MMF_CAPITAL_INPUT}    ${amount}    ${formatted_amount}

Enter Contribution
    [Arguments]    ${amount}    ${formatted_amount}
    Enter MMF Amount    ${MMF_CONTRIBUTION_VALUE}    ${MMF_CONTRIBUTION_INPUT}    ${amount}    ${formatted_amount}

Enter MMF Amount
    [Arguments]    ${value_locator}    ${input_locator}    ${amount}    ${formatted_amount}
    [Documentation]    Type an amount, unless it is already on the form.
    ...                Each amount is a label until it is tapped and reverts to one once
    ...                the value commits, so the entry is confirmed against the label.

    ${already_entered}=    Run Keyword And Return Status
    ...    Field Should Contain Value    ${value_locator}    ${formatted_amount}    amount
    IF    ${already_entered}    RETURN

    Scroll Form To Top
    Tap Element Center    ${value_locator}
    Wait Until Element Is Visible    ${input_locator}    timeout=15s
    Clear Text    ${input_locator}
    Input Text    ${input_locator}    ${amount}
    Wait Until Keyword Succeeds    15s    1s
    ...    Field Should Contain Value    ${value_locator}    ${formatted_amount}    amount

Select Duration
    [Arguments]    ${months}    ${duration_on_form}
    [Documentation]    Use the shortcut buttons under the duration field. Typing into the
    ...                field instead re-focuses it and scrolls the page out from under the
    ...                next step.

    Scroll Form To Top
    ${preset}=    Format String    ${MMF_DURATION_PRESET}    ${months}
    Wait Until Element Is Visible    ${preset}    timeout=30s
    Bring Duration Clear Of The Footer    ${preset}
    Tap Element Center    ${preset}
    Wait Until Keyword Succeeds    15s    1s
    ...    Field Should Contain Value    ${MMF_DURATION_VALUE}    ${duration_on_form}    duration

Bring Duration Clear Of The Footer
    [Arguments]    ${preset}
    [Documentation]    Calculate and Apply sit in a footer that is painted over the bottom
    ...                of the page, so a shortcut left underneath it takes the tap on the
    ...                footer's behalf instead of setting the duration.

    FOR    ${i}    IN RANGE    4
        ${loc}=    Get Element Location    ${preset}
        IF    ${loc}[y] < ${2050}    BREAK
        Swipe    start_x=540    start_y=1700    end_x=540    end_y=1400    duration=600ms
        Sleep    0.8s
    END

Tap Calculate Now
    Wait Until Element Is Visible    ${MMF_CALCULATE_BUTTON}    timeout=30s
    Click Element    ${MMF_CALCULATE_BUTTON}

Scroll Form To Top
    [Documentation]    Typing pushes the page down far enough to take the summary off the
    ...                top of the screen. The pickers report positions that are offset by
    ...                however far the page behind them has scrolled, so it is pulled back
    ...                before anything is tapped or read.

    FOR    ${i}    IN RANGE    4
        ${showing}=    Run Keyword And Return Status
        ...    Page Should Contain Element    ${MMF_FUTURE_BALANCE_LABEL}
        IF    ${showing}    BREAK
        Swipe    start_x=540    start_y=900    end_x=540    end_y=1800    duration=600ms
        Sleep    0.8s
    END
    Wait Until Element Is Visible    ${MMF_FUTURE_BALANCE_LABEL}    timeout=15s

Verify Investment Was Projected
    [Arguments]    ${currency}
    Scroll Form To Top
    ${quoted}=     Get Text    ${MMF_FUTURE_BALANCE_VALUE}
    Should Start With    ${quoted}    ${currency}
    ...    msg=The projection was quoted as '${quoted}', not in ${currency}
    ${balance}=    Get MMF Figure    ${MMF_FUTURE_BALANCE_VALUE}
    ${interest}=   Get MMF Figure    ${MMF_INTEREST_EARNED_VALUE}
    ${rate}=       Get MMF Figure    ${MMF_INTEREST_RATE_VALUE}
    Should Be True    ${balance} > 0     msg=No future balance was projected
    Should Be True    ${interest} > 0    msg=No interest was projected
    Should Be True    ${rate} > 0        msg=No interest rate was quoted
    RETURN    ${balance}

Future Balance Should Exceed
    [Arguments]    ${balance}    ${capital}
    Should Be True    ${balance} > ${capital}
    ...    msg=The projected balance ${balance} is no better than the capital ${capital}

Get MMF Figure
    [Arguments]    ${locator}
    [Documentation]    Take the first figure out of the text, which carries a currency in
    ...                front of it or a p.a suffix behind it depending on the field.

    ${raw}=      Get Text    ${locator}
    ${clean}=    Replace String    ${raw}    ,    ${EMPTY}
    ${figures}=  Get Regexp Matches    ${clean}    [0-9]+(?:[.][0-9]+)?
    ${value}=    Convert To Number    ${figures}[0]
    RETURN    ${value}

Project An MMF Investment
    [Arguments]    ${investment_type}    ${currency}
    [Documentation]    The contribution frequency is left at its default, Monthly being the
    ...                only thing the picker offers.

    Select Investment Type          ${investment_type}
    Enter Initial Capital           ${MMF_CAPITAL}         ${MMF_CAPITAL_ON_FORM}
    Enter Contribution              ${MMF_CONTRIBUTION}    ${MMF_CONTRIBUTION_ON_FORM}
    Select Duration                 ${MMF_DURATION_MONTHS}    ${MMF_DURATION_ON_FORM}
    Tap Calculate Now
    ${balance}=    Verify Investment Was Projected    ${currency}
    Future Balance Should Exceed    ${balance}    ${MMF_CAPITAL}
    RETURN    ${balance}
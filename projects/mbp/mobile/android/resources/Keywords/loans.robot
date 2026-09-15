*** Settings ***
Documentation    Loans and Loan Calculator keywords
Library          AppiumLibrary
Library          String
Resource         common.robot
Resource         ../locators/loan_locators.robot


*** Keywords ***
Open Loans
    [Documentation]    Open the Loans section from the dashboard.

    Wait Until Element Is Visible    ${LOANS_TILE}    timeout=60s
    Click Element    ${LOANS_TILE}
    Wait Until Element Is Visible    ${LOANS_MOBILE_TAB}    timeout=30s


Select Personal Loans
    [Documentation]    Switch the Loans landing page to the Personal Loans tab.

    Wait Until Element Is Visible    ${LOANS_PERSONAL_TAB}    timeout=30s
    Click Element    ${LOANS_PERSONAL_TAB}
    Wait Until Element Is Visible    ${LOANS_APPLY_LOAN_TAB}    timeout=30s


Open Loan Calculator
    [Documentation]    Open the Loan Calculator from the Loans landing page.
    ...                The same calculator is reached from either loan category tab.

    Wait Until Element Is Visible    ${LOAN_CALCULATOR_BUTTON}    timeout=30s
    Click Element    ${LOAN_CALCULATOR_BUTTON}
    Wait Until Element Is Visible    ${LOAN_CALC_TITLE}    timeout=30s


Select Loan Type
    [Arguments]    ${loan_type}
    [Documentation]    Pick a loan product from the Select Loan sheet.
    ...                Choosing a product replaces the empty prompt with the results
    ...                panel, which is what confirms the sheet closed.

    Wait Until Element Is Visible    ${LOAN_CALC_TYPE_SELECTOR}    timeout=30s
    Click Element    ${LOAN_CALC_TYPE_SELECTOR}

    ${option}=    Format String    ${LOAN_CALC_TYPE_OPTION}    ${loan_type}
    Wait Until Element Is Visible    ${option}    timeout=30s
    Click Element    ${option}

    Wait Until Element Is Visible    ${LOAN_CALC_RESULTS_HEADING}    timeout=30s
    Field Should Contain Value    ${LOAN_CALC_TYPE_SELECTOR}    ${loan_type}    loan type


Enter Loan Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Focus the borrow field, then type the amount.
    ...                The field is a label until it is tapped, and it reverts to one
    ...                the moment the value commits, so the entry is confirmed against
    ...                the label rather than the input.

    Wait Until Element Is Visible    ${LOAN_CALC_AMOUNT_VALUE}    timeout=30s
    Click Element    ${LOAN_CALC_AMOUNT_VALUE}
    Wait Until Element Is Visible    ${LOAN_CALC_AMOUNT_INPUT}    timeout=15s
    Input Text    ${LOAN_CALC_AMOUNT_INPUT}    ${amount}
    Wait Until Keyword Succeeds    15s    1s
    ...    Field Should Contain Value    ${LOAN_CALC_AMOUNT_VALUE}    ${formatted_amount}    loan amount


Select Loan Duration
    [Arguments]    ${duration}    ${duration_on_form}
    [Documentation]    Pick a repayment period from the Loan Duration sheet.
    ...                The periods on offer depend on the loan type, so this can only
    ...                run after a product has been chosen.

    Wait Until Element Is Visible    ${LOAN_CALC_DURATION_PLACEHOLDER}    timeout=30s
    Click Element    ${LOAN_CALC_DURATION_PLACEHOLDER}

    Wait Until Element Is Visible    ${LOAN_CALC_DURATION_SHEET}    timeout=30s
    ${option}=    Format String    ${LOAN_CALC_DURATION_OPTION}    ${duration}
    Click Element    ${option}

    Wait Until Keyword Succeeds    15s    1s
    ...    Field Should Contain Value    ${LOAN_CALC_DURATION_VALUE}    ${duration_on_form}    duration


Drag Loan Duration To
    [Arguments]    ${months}    ${duration_on_form}
    [Documentation]    Set the tenure on the duration slider.
    ...                Check Off Loan offers a slider instead of the Select Period
    ...                sheet. A single drag lands a month or two out, so the label is
    ...                re-read and the thumb dragged again until it matches.

    Wait Until Element Is Visible    ${LOAN_CALC_DURATION_SLIDER}    timeout=30s
    ${min}=    Get Month Count    ${LOAN_CALC_DURATION_MIN}
    ${max}=    Get Month Count    ${LOAN_CALC_DURATION_MAX}

    FOR    ${attempt}    IN RANGE    8
        ${current}=    Get Month Count    ${LOAN_CALC_DURATION_VALUE}
        IF    ${current} == ${months}    BREAK
        Drag Duration Thumb To Month    ${months}    ${min}    ${max}
    END

    Field Should Contain Value    ${LOAN_CALC_DURATION_VALUE}    ${duration_on_form}    duration


Drag Duration Thumb To Month
    [Arguments]    ${months}    ${min}    ${max}
    [Documentation]    Drag the slider thumb to where the month sits on the track.

    ${thumb}=         Get Element Location    ${LOAN_CALC_DURATION_SLIDER}
    ${thumb_size}=    Get Element Size        ${LOAN_CALC_DURATION_SLIDER}
    ${track}=         Get Element Location    ${LOAN_CALC_DURATION_TRACK}
    ${track_size}=    Get Element Size        ${LOAN_CALC_DURATION_TRACK}

    ${start_x}=    Evaluate    int(${thumb}[x] + ${thumb_size}[width] / 2)
    ${start_y}=    Evaluate    int(${thumb}[y] + ${thumb_size}[height] / 2)
    ${end_x}=      Evaluate    int(${track}[x] + (${months} - ${min}) / (${max} - ${min}) * ${track_size}[width])

    Swipe    start_x=${start_x}    start_y=${start_y}    end_x=${end_x}    end_y=${start_y}    duration=800ms


Get Month Count
    [Arguments]    ${locator}
    [Documentation]    Read a slider label such as '5 Months' and return the number.

    ${raw}=       Get Text    ${locator}
    ${digits}=    Get Regexp Matches    ${raw}    (\\d+)
    ${count}=     Convert To Integer    ${digits}[0]
    RETURN    ${count}


Tap Calculate Now
    [Documentation]    Ask the calculator to cost the requested loan.

    Wait Until Element Is Visible    ${LOAN_CALC_CALCULATE_BUTTON}    timeout=30s
    Click Element    ${LOAN_CALC_CALCULATE_BUTTON}


Verify Loan Was Costed
    [Arguments]    ${principal}
    [Documentation]    Verify the calculator returned a priced repayment plan.
    ...                The figures come back from pricing several seconds after the
    ...                tap, so the panel is polled rather than read once.

    Wait Until Keyword Succeeds    60s    3s    Total Repayment Should Exceed    ${principal}

    ${monthly}=    Get Loan Figure    ${LOAN_CALC_MONTHLY_REPAYMENT}
    Should Be True    ${monthly} > 0    msg=No monthly repayment was quoted

    ${interest}=    Get Loan Figure    ${LOAN_CALC_INTEREST}
    Should Be True    ${interest} > 0    msg=No interest was quoted

    ${rate}=    Get Loan Figure    ${LOAN_CALC_RATE}
    Should Be True    ${rate} > 0    msg=No interest rate was quoted


Verify Loan Was Not Costed
    [Documentation]    Verify the calculator produced no quote.

    Wait Until Element Is Visible    ${LOAN_CALC_EMPTY_PROMPT}    timeout=30s
    Page Should Not Contain Element    ${LOAN_CALC_RESULTS_HEADING}


Total Repayment Should Exceed
    [Arguments]    ${principal}
    [Documentation]    Verify the quoted total is more than the sum borrowed.

    ${total}=    Get Loan Figure    ${LOAN_CALC_TOTAL_REPAYMENT}
    Should Be True    ${total} > ${principal}
    ...    msg=Total repayment ${total} should be more than the ${principal} borrowed


Get Loan Figure
    [Arguments]    ${locator}
    [Documentation]    Read a money or rate label and return it as a number.

    ${raw}=    Get Text    ${locator}
    ${clean}=    Replace String    ${raw}    KES    ${EMPTY}
    ${clean}=    Replace String    ${clean}    p.m    ${EMPTY}
    ${clean}=    Replace String    ${clean}    %    ${EMPTY}
    ${clean}=    Replace String    ${clean}    ,    ${EMPTY}
    ${clean}=    Strip String    ${clean}
    ${value}=    Convert To Number    ${clean}
    RETURN    ${value}


User Navigates To Loans Section
    [Documentation]    From the home dashboard, open the Loans section.

    Wait Until Element Is Visible    ${MOBILE_DASHBOARD_HOME}    timeout=60s
    Click Element    ${MOBILE_DASHBOARD_HOME}
    Wait Until Element Is Visible    ${LOANS_TILE}    timeout=30s
    Open Loans
    Wait Until Element Is Visible    ${LOANS_MOBILE_TAB}    timeout=30s


Loan Products Should Be Activated And Visible
    [Documentation]    Verify loan product tabs and options are visible, indicating activation.

    Wait Until Element Is Visible    ${LOANS_MOBILE_TAB}    timeout=30s
    Wait Until Element Is Visible    ${LOANS_PERSONAL_TAB}    timeout=30s
    Wait Until Element Is Visible    ${LOAN_CALCULATOR_BUTTON}    timeout=30s
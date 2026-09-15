*** Settings ***
Documentation    Keywords for the Tariff Calculator
Library          AppiumLibrary
Library          String
Resource         common.robot
Resource         login.robot
Resource         calculators.robot
Resource         ../locators/tariff_locators.robot
Resource         ../variables/test_data.robot


*** Keywords ***
Open Tariff Calculator
    Wait Until Element Is Visible    ${TARIFF_CALCULATOR_TILE}    timeout=30s
    Tap Element Center    ${TARIFF_CALCULATOR_TILE}
    Wait Until Element Is Visible    ${TARIFF_SOURCE_OF_FUNDS}    timeout=30s

Open A Fresh Tariff Calculator
    [Documentation]    Start from an empty calculator, for the cases that depend on
    ...                nothing having been costed yet.

    Restart Application
    Login With Saved Number    ${MOBILE_PIN}
    Open Calculators
    Open Tariff Calculator

Ensure Tariff Calculator Is Open
    [Documentation]    Reuse the open calculator where possible.
    ...                Reaching it means scrolling the drawer every time, so the page is
    ...                only rebuilt when a test has left it.

    ${on_form}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${TARIFF_SOURCE_OF_FUNDS}
    IF    not ${on_form}    Open A Fresh Tariff Calculator

Select Transaction Type
    [Arguments]    ${transaction_type}

    Wait Until Element Is Visible    ${TARIFF_TYPE_VALUE}    timeout=30s
    Tap Element Center    ${TARIFF_TYPE_VALUE}
    Wait Until Element Is Visible    ${TARIFF_TYPE_SHEET}    timeout=30s

    ${option}=    Format String    ${TARIFF_TYPE_OPTION}    ${transaction_type}
    Scroll Sheet To    ${option}
    Tap Element Center    ${option}

    Wait Until Page Does Not Contain Element    ${TARIFF_TYPE_SHEET}    timeout=30s
    Wait Until Keyword Succeeds    15s    1s
    ...    Field Should Contain Value    ${TARIFF_TYPE_VALUE}    ${transaction_type}    transaction type

Scroll Sheet To
    [Arguments]    ${locator}
    [Documentation]    The sheet lists every type whether it is painted or not, so the
    ...                option is scrolled up until it is within reach of a tap, or until
    ...                the sheet has hit its end and stopped moving.

    ${previous}=    Set Variable    ${-1}
    FOR    ${i}    IN RANGE    4
        ${y}=    Option Position    ${locator}
        IF    ${y} < 2100 or ${y} == ${previous}    BREAK
        ${previous}=    Set Variable    ${y}
        Swipe    start_x=540    start_y=1800    end_x=540    end_y=1000    duration=600ms
        Sleep    0.8s
    END

Option Position
    [Arguments]    ${locator}
    [Documentation]    Where the option sits, or off screen when it is not in the tree yet.

    ${found}    ${loc}=    Run Keyword And Ignore Error    Get Element Location    ${locator}
    IF    '${found}' != 'PASS'    RETURN    ${9999}
    RETURN    ${loc}[y]

Enter Tariff Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Type the amount, unless it is already on the form.
    ...                Changing the transaction type re-costs whatever is in the field, so
    ...                the amount is only typed when it actually has to change.

    ${already_entered}=    Run Keyword And Return Status
    ...    Field Should Contain Value    ${TARIFF_AMOUNT_VALUE}    ${formatted_amount}    amount
    IF    ${already_entered}    RETURN

    Focus The Amount Field
    Clear Text    ${TARIFF_AMOUNT_INPUT}
    Focus The Amount Field
    Input Text    ${TARIFF_AMOUNT_INPUT}    ${amount}
    Wait Until Keyword Succeeds    15s    1s
    ...    Field Should Contain Value    ${TARIFF_AMOUNT_VALUE}    ${formatted_amount}    amount

Focus The Amount Field
    [Documentation]    Put the amount field into its editable state.
    ...                Emptying it drops it back to a label, so it has to be focused again
    ...                between a clear and the next entry.

    ${editable}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${TARIFF_AMOUNT_INPUT}
    IF    ${editable}    RETURN

    Wait Until Element Is Visible    ${TARIFF_AMOUNT_VALUE}    timeout=30s
    Tap Element Center    ${TARIFF_AMOUNT_VALUE}
    Wait Until Element Is Visible    ${TARIFF_AMOUNT_INPUT}    timeout=15s

Verify Transaction Charge Is Quoted
    [Documentation]    The charge is costed as the amount is typed, so no button is
    ...                pressed. The calculator's only button opens the payment form.

    Wait Until Element Is Visible    ${TARIFF_CHARGE_LABEL}    timeout=30s
    ${charge}=    Get Transaction Charge
    Should Be True    ${charge} >= 0    msg=No transaction charge was quoted
    RETURN    ${charge}

Verify No Transaction Charge Is Quoted
    Page Should Not Contain Element    ${TARIFF_CHARGE_LABEL}

Get Transaction Charge
    ${raw}=      Get Text    ${TARIFF_CHARGE_VALUE}
    ${clean}=    Replace String    ${raw}      KES    ${EMPTY}
    ${clean}=    Replace String    ${clean}    ,      ${EMPTY}
    ${clean}=    Strip String      ${clean}
    ${value}=    Convert To Number    ${clean}
    RETURN    ${value}

Tariff Should Be Quoted For
    [Arguments]    ${transaction_type}
    Select Transaction Type    ${transaction_type}
    Enter Tariff Amount        ${TARIFF_AMOUNT}    ${TARIFF_AMOUNT_ON_FORM}
    ${charge}=    Verify Transaction Charge Is Quoted
    Log    ${transaction_type} costs KES ${charge} on KES ${TARIFF_AMOUNT}
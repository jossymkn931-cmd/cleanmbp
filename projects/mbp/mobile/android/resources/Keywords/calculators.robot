*** Settings ***
Documentation    Keywords shared by the calculators behind the Calculator menu
Library          AppiumLibrary
Resource         ../locators/calculator_locators.robot


*** Keywords ***
Open Calculators
    [Documentation]    Reach the Calculators menu from the profile drawer.
    ...                Once the drawer scrolls it reports entry positions that no longer
    ...                match where they are painted, so it is driven to the end of the
    ...                list, where the layout is fixed, and the entry is tapped by point.

    Click Element    ${SETTINGS_AVATAR}
    Wait Until Element Is Visible    ${SETTINGS_MENU_TITLE}    timeout=30s

    FOR    ${i}    IN RANGE    4
        Swipe    start_x=540    start_y=1950    end_x=540    end_y=350    duration=300ms
        Sleep    0.2s
        # One swipe never covers the drawer, so the first is not worth checking.
        IF    ${i} == ${0}    CONTINUE
        ${y}=    Drawer Version Position
        IF    ${y} < ${200}    BREAK
    END
    Sleep    0.3s
    Tap With Positions    300ms    ${{(343, 1537)}}

    Wait Until Element Is Visible    ${CALCULATOR_HUB_TITLE}    timeout=30s

Drawer Version Position
    [Documentation]    Where the drawer reports its version footer, or off screen while it
    ...                is still below the last entry. It comes to rest against the top of
    ...                the drawer, which is how the end of the list is recognised.

    ${found}    ${loc}=    Run Keyword And Ignore Error    Get Element Location    ${SETTINGS_VERSION}
    IF    '${found}' != 'PASS'    RETURN    ${9999}
    RETURN    ${loc}[y]

Tap Element Center
    [Arguments]    ${locator}
    [Documentation]    Tap where the element is painted rather than clicking it.
    ...                The calculators are WebViews, and an element click on their rows is
    ...                swallowed without the row ever reacting.

    ${loc}=     Get Element Location    ${locator}
    ${size}=    Get Element Size        ${locator}
    ${x}=    Evaluate    int(${loc}[x] + ${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y] + ${size}[height] / 2)
    Tap With Positions    500ms    ${{(int($x), int($y))}}
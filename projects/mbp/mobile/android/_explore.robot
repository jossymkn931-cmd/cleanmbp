*** Settings ***
Documentation    Temporary exploration suite for capturing MMF fund creation locators.
Library          AppiumLibrary
Library          OperatingSystem
Resource         resources/Keywords/common.robot
Resource         resources/Keywords/login.robot
Resource         resources/Keywords/send_money.robot
Resource         resources/Keywords/mmf_fund.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application


*** Keywords ***
Dump Screen
    [Arguments]    ${name}
    ${source}=    Get Source
    Create File    ${OUTPUT DIR}${/}${name}.xml    ${source}
    Capture Page Screenshot    ${name}.png
    Log    Wrote ${name}


Tap Text Centre
    [Arguments]    ${label}
    ${locator}=    Set Variable    xpath=//android.widget.TextView[@text='${label}']
    Wait Until Element Is Visible    ${locator}    timeout=30s
    ${loc}=     Get Element Location    ${locator}
    ${size}=    Get Element Size        ${locator}
    ${x}=    Evaluate    int(${loc}[x] + ${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y] + ${size}[height] / 2)
    Tap With Positions    200ms    ${{(int($x), int($y))}}


Tap View Centre
    [Arguments]    ${label}
    ${locator}=    Set Variable    xpath=//android.view.View[@text='${label}']
    Wait Until Element Is Visible    ${locator}    timeout=30s
    ${loc}=     Get Element Location    ${locator}
    ${size}=    Get Element Size        ${locator}
    ${x}=    Evaluate    int(${loc}[x] + ${size}[width] / 2)
    ${y}=    Evaluate    int(${loc}[y] + ${size}[height] / 2)
    Tap With Positions    200ms    ${{(int($x), int($y))}}


Terms Agree Button Is Enabled
    Wait Until Element Is Visible    accessibility_id=agree    timeout=5s
    ${state}=    Get Element Attribute    accessibility_id=agree    enabled
    Should Be Equal    ${state}    true    msg=Agree is still disabled (enabled=${state})


Drag Terms Down
    [Documentation]    Short slow drag inside the document, above the Agree footer.
    Swipe    start_x=540    start_y=1700    end_x=540    end_y=950    duration=2s


Drag Terms Up
    [Documentation]    Bring the Agree footer back if a drag overshoots.
    Swipe    start_x=540    start_y=950    end_x=540    end_y=1700    duration=800ms


Screen Digest
    Capture Page Screenshot    _probe.png
    ${bytes}=    Get Binary File    ${OUTPUT DIR}${/}_probe.png
    ${digest}=    Evaluate    hashlib.md5($bytes).hexdigest()    modules=hashlib
    RETURN    ${digest}


Scroll Terms To The Bottom
    [Documentation]    The T&C WebView leaves the accessibility tree once the PDF renders,
    ...    so the end of the document is detected by the screen no longer changing.
    ${previous}=    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    40
        Swipe    start_x=540    start_y=2050    end_x=540    end_y=350    duration=300ms
        Sleep    0.3s
        ${digest}=    Screen Digest
        IF    $digest == $previous
            Log To Console    terms bottom reached after ${i} swipes
            RETURN
        END
        ${previous}=    Set Variable    ${digest}
    END
    Fail    Terms document never stopped scrolling


Scroll Until Enabled
    [Arguments]    ${locator}    ${attempts}=20
    [Documentation]    Slow-drag until the control reports enabled=true.
    FOR    ${i}    IN RANGE    ${attempts}
        ${ok}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${locator}    timeout=3s
        IF    not $ok
            Log To Console    scroll ${i} ${locator} not visible
            Drag Terms Up
            CONTINUE
        END
        ${state}=    Get Element Attribute    ${locator}    enabled
        Log To Console    scroll ${i} enabled=${state}
        IF    $state == 'true'    RETURN
        Drag Terms Down
        Sleep    0.3s
    END
    ${state}=    Get Element Attribute    ${locator}    enabled
    Should Be Equal    ${state}    true    msg=${locator} stayed disabled after scrolling


*** Test Cases ***
Explore MMF Withdrawal
    Open A Fresh Investments Catalogue
    Open My Portfolio
    Dump Screen    portfolio_now
    Tap Element Centre    xpath=(//android.widget.TextView[contains(@text,'MMF ')])[1]
    Wait Until Element Is Visible    accessibility_id=withdrawMMF    timeout=30s
    Dump Screen    fund_detail_before
    Click Element    accessibility_id=withdrawMMF
    Sleep    6s
    Dump Screen    withdraw_first
    ${notice}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    accessibility_id=done    timeout=5s
    IF    ${notice}
        Click Element    accessibility_id=done
        Sleep    4s
        Dump Screen    withdraw_form
    END


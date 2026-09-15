*** Settings ***
Documentation    Buy Airtime keywords
Library          AppiumLibrary
Library          String
Resource         ../locators/airtime_locators.robot
Resource         ../locators/send_money_locators.robot


*** Keywords ***
Open Buy Airtime
    [Documentation]    Open the Buy Airtime form from the dashboard.
    ...                The tile opens the form directly, with no transfer type sheet.

    Wait Until Element Is Visible    ${AIRTIME_TILE}    timeout=60s
    Click Element    ${AIRTIME_TILE}
    Wait Until Element Is Visible    ${AIRTIME_FORM_TITLE}    timeout=30s


Verify Buy Airtime Options Are Listed
    [Documentation]    Verify the form offers both airtime purchase modes.

    Wait Until Element Is Visible    ${AIRTIME_BUY_SELF_TAB}    timeout=30s
    Expect Element    ${AIRTIME_BUY_OTHER_TAB}    visible


Select Buy For Self
    [Documentation]    Switch the airtime form to the Buy for Self tab.

    Wait Until Element Is Visible    ${AIRTIME_BUY_SELF_TAB}    timeout=30s
    Click Element    ${AIRTIME_BUY_SELF_TAB}
    Wait Until Element Is Visible    ${AIRTIME_MOBILE_PREFIX}    timeout=30s


Select Buy For Other
    [Documentation]    Switch the airtime form to the Buy for Other tab.
    ...                Waits for the empty input, because until the tab has rendered
    ...                the Mobile Number label resolves to whatever field follows it.

    Wait Until Element Is Visible    ${AIRTIME_BUY_OTHER_TAB}    timeout=30s
    Click Element    ${AIRTIME_BUY_OTHER_TAB}
    Wait Until Element Is Visible    ${AIRTIME_MOBILE_PREFIX}    timeout=30s
    Wait Until Element Is Visible    ${AIRTIME_MOBILE_NUMBER_INPUT}    timeout=30s


Own Mobile Number Should Be Prefilled
    [Documentation]    Verify Buy for Self prefills the registered number.

    Wait Until Element Is Visible    ${AIRTIME_SELF_NUMBER_LABEL}    timeout=30s
    ${number}=    Get Text    ${AIRTIME_SELF_NUMBER_LABEL}
    Should Match Regexp    ${number}    ^[0-9]{9,}$
    ...    msg=Buy for Self did not prefill a mobile number, got '${number}'


Enter Airtime Recipient Mobile Number
    [Arguments]    ${mobile_number}
    [Documentation]    Enter a Kenyan mobile number after the fixed +254 prefix.

    ${local_number}=    Strip String    ${mobile_number}
    IF    $local_number.startswith('+254')
        ${local_number}=    Get Substring    ${local_number}    4
    ELSE IF    $local_number.startswith('254')
        ${local_number}=    Get Substring    ${local_number}    3
    ELSE IF    $local_number.startswith('0')
        ${local_number}=    Get Substring    ${local_number}    1
    END
    Should Match Regexp    ${local_number}    ^[17][0-9]{8}$    msg=Invalid Kenyan mobile number: ${mobile_number}
    Wait Until Element Is Visible    ${AIRTIME_MOBILE_NUMBER_INPUT}    timeout=30s
    Input Text    ${AIRTIME_MOBILE_NUMBER_INPUT}    ${local_number}
    ${actual}=    Get Text    ${AIRTIME_MOBILE_NUMBER_INPUT}
    Should Be Equal    ${actual}    ${local_number}
    ...    msg=Expected the mobile number field to contain '${local_number}' but it contains '${actual}'


Verify Airtime Provider Is Detected
    [Arguments]    ${provider}
    [Documentation]    Verify the app resolved the number to a mobile network.

    ${detected}=    Format String    ${AIRTIME_PROVIDER_LABEL}    ${provider}
    Wait Until Element Is Visible    ${detected}    timeout=60s


Enter Airtime Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Focus the amount field, then type the amount.
    ...                The field only becomes an EditText once it has focus, and it
    ...                reverts to a formatted label afterwards, so the entry is
    ...                confirmed against that label rather than the input.

    Wait Until Element Is Visible    ${AIRTIME_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${AIRTIME_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${AIRTIME_AMOUNT_INPUT}    timeout=15s
    Input Text    ${AIRTIME_AMOUNT_INPUT}    ${amount}
    ${value}=    Format String    ${AIRTIME_AMOUNT_VALUE}    ${formatted_amount}
    Wait Until Element Is Visible    ${value}    timeout=15s


Verify Airtime Purchase Was Submitted
    [Arguments]    ${expected_amount}    ${provider}
    [Documentation]    Verify the receipt confirms the airtime request was accepted.
    ...
    ...                The airtime receipt carries no Principal row, so the amount is
    ...                read from the first Amount row instead.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=60s

    ${status}=    Get Text    ${SEND_RESULT_STATUS}
    Should Be Equal    ${status}    In Processing    msg=Unexpected transaction status

    ${reference}=    Get Text    ${SEND_RESULT_REFERENCE}
    Should Not Be Empty    ${reference}    msg=No MBP reference number was issued

    ${type}=    Get Text    ${AIRTIME_RESULT_TYPE}
    Should Be Equal    ${type}    Buy Airtime    msg=Unexpected transaction type

    ${detected}=    Get Text    ${AIRTIME_RESULT_PROVIDER}
    Should Be Equal    ${detected}    ${provider}    msg=Unexpected airtime provider

    ${amount}=    Get Text    ${AIRTIME_RESULT_AMOUNT}
    Should Be Equal    ${amount}    ${expected_amount}    msg=Receipt amount does not match

    Expect Element    ${SEND_DONE_BUTTON}    visible
    RETURN    ${reference}
*** Settings ***
Documentation    Send to Mobile transfer keywords
Library          AppiumLibrary
Library          Collections
Library          String
Library          ../libraries/money.py
Resource         ../locators/send_money_locators.robot


*** Keywords ***
Verify Send To Mobile Is Available
    [Documentation]    Verify the dashboard exposes the Send to Mobile action.

    Wait Until Element Is Visible    ${SEND_TO_MOBILE_TILE}    timeout=60s


Open Send To Mobile
    [Documentation]    From the dashboard, open Send to Mobile and pick the
    ...                Send to Mobile transfer type from the bottom sheet

    Open Mobile Transfer Type Sheet
    Select Send To Mobile Transfer Type


Open Mobile Transfer Type Sheet
    [Documentation]    Open the dashboard mobile transfer type sheet.

    Wait Until Element Is Visible    ${SEND_TO_MOBILE_TILE}    timeout=60s
    Click Element    ${SEND_TO_MOBILE_TILE}


Select Send To Mobile Transfer Type
    [Documentation]    Pick Send to Mobile from the transfer type sheet.

    Wait Until Element Is Visible    ${SEND_TO_MOBILE_OPTION}    timeout=30s
    Click Element    ${SEND_TO_MOBILE_OPTION}

    Wait Until Element Is Visible    ${SEND_TO_SELF_TAB}    timeout=30s


Select Vooma Transfer Type
    [Documentation]    Pick Vooma from the mobile transfer type sheet.

    Wait Until Element Is Visible    ${VOOMA_OPTION}    timeout=30s
    Click Element    ${VOOMA_OPTION}
    Wait Until Element Is Visible    ${VOOMA_FORM_TITLE}    timeout=30s


Select Vooma Send To Other
    [Documentation]    Switch the Vooma form to Send to Other.

    Wait Until Element Is Visible    ${SEND_TO_OTHER_TAB}    timeout=30s
    Click Element    ${SEND_TO_OTHER_TAB}
    Wait Until Element Is Visible    ${VOOMA_MOBILE_NUMBER_INPUT}    timeout=30s


Search And Select Vooma Contact
    [Arguments]    ${contact_name}
    [Documentation]    Search the contact list and select a Vooma recipient.

    Wait Until Element Is Visible    ${SEND_CONTACT_SEARCH_INPUT}    timeout=30s
    Input Text    ${SEND_CONTACT_SEARCH_INPUT}    ${contact_name}
    ${contact}=    Format String    ${SEND_CONTACT_RESULT}    ${contact_name}
    Wait Until Element Is Visible    ${contact}    timeout=30s
    Click Element    ${contact}
    Wait Until Element Is Visible    ${VOOMA_MOBILE_NUMBER_INPUT}    timeout=30s


Selected Vooma Recipient Should Be
    [Arguments]    ${expected_local_number}
    [Documentation]    Verify the selected contact populated the Vooma recipient field.

    ${actual_number}=    Get Text    ${VOOMA_MOBILE_NUMBER_INPUT}
    Should Be Equal    ${actual_number}    ${expected_local_number}


Verify Empty Transfer Form Cannot Be Submitted
    [Documentation]    Verify payment submission is disabled until an amount is entered.

    Wait Until Element Is Visible    ${SEND_AMOUNT_PLACEHOLDER}    timeout=30s
    Expect Element    ${SEND_MAKE_PAYMENT_BUTTON}    disabled    timeout=10s


Select Send To Self
    [Documentation]    Switch the transfer form to the Send to Self tab

    Wait Until Element Is Visible    ${SEND_TO_SELF_TAB}    timeout=30s
    Click Element    ${SEND_TO_SELF_TAB}


Select Send To Other
    [Documentation]    Switch the transfer form to the Send to Other tab.

    Wait Until Element Is Visible    ${SEND_TO_OTHER_TAB}    timeout=30s
    Click Element    ${SEND_TO_OTHER_TAB}
    Wait Until Element Is Visible    ${SEND_MOBILE_NUMBER_INPUT}    timeout=30s


Open Contact List
    [Documentation]    Open the device contact picker from Send to Other.

    Wait Until Element Is Visible    ${SEND_CONTACT_PICKER_BUTTON}    timeout=30s
    Click Element    ${SEND_CONTACT_PICKER_BUTTON}


Search And Select Contact
    [Arguments]    ${contact_name}
    [Documentation]    Search the app contact list and select an exact contact name.

    Wait Until Element Is Visible    ${SEND_CONTACT_SEARCH_INPUT}    timeout=30s
    Input Text    ${SEND_CONTACT_SEARCH_INPUT}    ${contact_name}
    ${contact}=    Format String    ${SEND_CONTACT_RESULT}    ${contact_name}
    Wait Until Element Is Visible    ${contact}    timeout=30s
    Click Element    ${contact}
    Wait Until Element Is Visible    ${SEND_MOBILE_NUMBER_INPUT}    timeout=30s


Selected Recipient Mobile Number Should Be
    [Arguments]    ${expected_local_number}
    [Documentation]    Verify the selected contact populated the recipient field.

    ${actual_number}=    Get Text    ${SEND_MOBILE_NUMBER_INPUT}
    Should Be Equal    ${actual_number}    ${expected_local_number}


Enter Recipient Mobile Number
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
    Input Text    ${SEND_MOBILE_NUMBER_INPUT}    ${local_number}


Enter Transfer Amount
    [Arguments]    ${amount}
    [Documentation]    Focus the amount field, then type the amount.
    ...                The field only becomes an EditText once it has focus.

    Wait Until Element Is Visible    ${SEND_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${SEND_AMOUNT_PLACEHOLDER}

    Wait Until Element Is Visible    ${SEND_AMOUNT_INPUT}    timeout=15s
    Input Text    ${SEND_AMOUNT_INPUT}    ${amount}


Tap Make Payment
    [Documentation]    Submit the transfer form. The button stays disabled until the
    ...                form is valid, so wait for it to become enabled first.

    Expect Element    ${SEND_MAKE_PAYMENT_BUTTON}    enabled    timeout=30s
    Click Element    ${SEND_MAKE_PAYMENT_BUTTON}


Verify Confirm Summary Is Displayed
    [Arguments]    ${expected_amount}
    [Documentation]    Verify the confirmation sheet shows the expected amount

    Wait Until Element Is Visible    ${SEND_CONFIRM_TITLE}    timeout=30s
    Page Should Contain Text    ${expected_amount}


Tap Continue
    [Documentation]    Confirm the transfer. Cancel sits directly below Continue,
    ...                so this must be located by accessibility id, never by position.

    Wait Until Element Is Visible    ${SEND_CONTINUE_BUTTON}    timeout=30s
    Click Element    ${SEND_CONTINUE_BUTTON}


Enter Transaction Pin
    [Arguments]    ${pin}
    [Documentation]    Enter the transaction PIN.
    ...
    ...                Unlike the login PIN pad, this keypad is deliberately excluded
    ...                from the accessibility tree, so no locator can reach its keys.
    ...                Keys are therefore tapped by position, expressed as a fraction
    ...                of the window so the mapping is not bound to a single device.

    # Pad slides in after previous screen — short settle so taps aren't swallowed.
    Sleep    1.2s

    ${width}=    Get Window Width
    ${height}=    Get Window Height

    @{digits}=    Split String To Characters    ${pin}
    ${digit_count}=    Get Length    ${digits}
    ${index}=    Set Variable    ${0}
    FOR    ${digit}    IN    @{digits}
        ${x_ratio}    ${y_ratio}=    Get Transaction Pin Key Ratio    ${digit}
        ${x}=    Evaluate    int(${width} * ${x_ratio})
        ${y}=    Evaluate    int(${height} * ${y_ratio})
        Tap With Positions    100ms    ${{ ($x, $y) }}
        # Last digit: extra delay to ensure registration before screen closes
        ${index}=    Evaluate    ${index} + 1
        IF    ${index} == ${digit_count}
            Sleep    300ms
        ELSE
            Sleep    150ms
        END
    END


Wait For Vooma Otp Authorization
    [Documentation]    Wait for the app to receive and autofill the SMS OTP.
    ...                Vooma shows a loading overlay after PIN and continues to the
    ...                receipt when OTP authorization succeeds.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=120s


Get Transaction Pin Key Ratio
    [Arguments]    ${digit}
    [Documentation]    Return the x/y centre of a keypad key as a fraction of the window

    ${columns}=    Create Dictionary
    ...    1=0.190    2=0.500    3=0.810
    ...    4=0.190    5=0.500    6=0.810
    ...    7=0.190    8=0.500    9=0.810
    ...    0=0.500
    ${rows}=    Create Dictionary
    ...    1=0.537    2=0.537    3=0.537
    ...    4=0.631    5=0.631    6=0.631
    ...    7=0.726    8=0.726    9=0.726
    ...    0=0.820

    ${x_ratio}=    Get From Dictionary    ${columns}    ${digit}
    ${y_ratio}=    Get From Dictionary    ${rows}    ${digit}
    RETURN    ${x_ratio}    ${y_ratio}


Verify Transfer Was Submitted
    [Arguments]    ${expected_amount}
    [Documentation]    Verify the receipt screen confirms the transfer was accepted
    ...
    ...                The transfer is asynchronous, so the bank only acknowledges
    ...                receipt here. Final settlement arrives later by SMS and is
    ...                outside the scope of this test.

    Wait Until Element Is Visible    ${SEND_RESULT_TITLE}    timeout=60s

    ${status}=    Get Text    ${SEND_RESULT_STATUS}
    Should Be Equal    ${status}    In Processing    msg=Unexpected transaction status

    ${reference}=    Get Text    ${SEND_RESULT_REFERENCE}
    Should Not Be Empty    ${reference}    msg=No MBP reference number was issued

    ${principal}=    Get Text    ${SEND_RESULT_PRINCIPAL}
    Should Be Equal    ${principal}    ${expected_amount}    msg=Receipt amount does not match

    Expect Element    ${SEND_DONE_BUTTON}    visible
    RETURN    ${reference}


Tap Done
    [Documentation]    Dismiss the receipt and return to the dashboard.

    Wait Until Element Is Visible    ${SEND_DONE_BUTTON}    timeout=30s
    Click Element    ${SEND_DONE_BUTTON}


Get Receipt Principal
    [Documentation]    Return the principal shown on the receipt, in minor units.

    Wait Until Element Is Visible    ${SEND_RESULT_PRINCIPAL}    timeout=30s
    ${principal}=    Get Text    ${SEND_RESULT_PRINCIPAL}
    ${amount}=    Parse Money    ${principal}
    RETURN    ${amount}
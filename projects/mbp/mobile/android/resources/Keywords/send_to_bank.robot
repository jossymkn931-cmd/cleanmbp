*** Settings ***
Documentation    Send to Bank transfer keywords
Library          AppiumLibrary
Library          String
Resource         common.robot
Resource         ../locators/bank_transfer_locators.robot


*** Keywords ***
Open Bank Transfer Type Sheet
    [Documentation]    Open the dashboard bank transfer type sheet.

    Wait Until Element Is Visible    ${BANK_TILE}    timeout=60s
    Click Element    ${BANK_TILE}
    Wait Until Element Is Visible    ${BANK_KCB_OPTION}    timeout=30s


Verify Bank Transfer Types Are Listed
    [Documentation]    Verify the sheet offers every supported bank transfer type.

    Wait Until Element Is Visible    ${BANK_KCB_OPTION}    timeout=30s
    Expect Element    ${BANK_RTGS_OPTION}    visible
    Expect Element    ${BANK_PESALINK_OPTION}    visible
    Expect Element    ${BANK_GLOBAL_TRANSFER_OPTION}    visible


Select KCB Bank Transfer
    [Documentation]    Open the Send to KCB Bank form.

    Wait Until Element Is Visible    ${BANK_KCB_OPTION}    timeout=30s
    Click Element    ${BANK_KCB_OPTION}
    Wait Until Element Is Visible    ${KCB_FORM_TITLE}    timeout=30s


Select Pesalink Transfer
    [Documentation]    Open the Send to Pesalink form.

    Wait Until Element Is Visible    ${BANK_PESALINK_OPTION}    timeout=30s
    Click Element    ${BANK_PESALINK_OPTION}
    Wait Until Element Is Visible    ${PESALINK_FORM_TITLE}    timeout=30s


Select Bank Send To Self
    [Documentation]    Switch the bank transfer form to the Send to Self tab.

    Wait Until Element Is Visible    ${BANK_SEND_TO_SELF_TAB}    timeout=30s
    Click Element    ${BANK_SEND_TO_SELF_TAB}


Select Bank Send To Other
    [Documentation]    Switch the bank transfer form to the Send to Other tab.

    Wait Until Element Is Visible    ${BANK_SEND_TO_OTHER_TAB}    timeout=30s
    Click Element    ${BANK_SEND_TO_OTHER_TAB}
    Wait Until Element Is Visible    ${BANK_ACCOUNT_NUMBER_INPUT}    timeout=30s


Select Pesalink Send To Bank
    [Documentation]    Switch the Pesalink form to the Send to Bank tab.

    Wait Until Element Is Visible    ${PESALINK_SEND_TO_BANK_TAB}    timeout=30s
    Click Element    ${PESALINK_SEND_TO_BANK_TAB}
    Wait Until Element Is Visible    ${PESALINK_SELECT_BANK}    timeout=30s


Select Pesalink Send To Mobile
    [Documentation]    Switch the Pesalink form to the Send to Mobile tab.
    ...                Waits for the +254 prefix first. Until the tab has rendered,
    ...                the Mobile Number label resolves to the reason input, so
    ...                typing too early silently fills the wrong field.

    Wait Until Element Is Visible    ${PESALINK_SEND_TO_MOBILE_TAB}    timeout=30s
    Click Element    ${PESALINK_SEND_TO_MOBILE_TAB}
    Wait Until Element Is Visible    ${PESALINK_MOBILE_PREFIX}    timeout=30s
    Wait Until Element Is Visible    ${BANK_MOBILE_NUMBER_INPUT}    timeout=30s


Select Bank Source Account
    [Arguments]    ${account_masked}=${ACCOUNT_MASKED}
    [Documentation]    Open Source of Funds, stay on Accounts, pick the source account,
    ...                then Continue. Used before asserting same-account transfers are blocked.

    Wait Until Element Is Visible    ${BANK_SOURCE_OF_FUNDS_LABEL}    timeout=30s
    Click Element    ${BANK_SOURCE_OF_FUNDS_LABEL}
    ${sheet_open}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${BANK_ACCOUNTS_TAB}    timeout=8s
    IF    not ${sheet_open}
        Click Element    ${BANK_SOURCE_OF_FUNDS_VALUE}
        Wait Until Element Is Visible    ${BANK_ACCOUNTS_TAB}    timeout=15s
    END
    Click Element    ${BANK_ACCOUNTS_TAB}
    ${account}=    Format String    ${BANK_SOURCE_ACCOUNT_OPTION}    ${account_masked}
    Wait Until Element Is Visible    ${account}    timeout=30s
    Click Element    ${account}
    Wait Until Element Is Visible    ${BANK_SELECT_ACCOUNT_CONTINUE}    timeout=15s
    Click Element    ${BANK_SELECT_ACCOUNT_CONTINUE}
    Wait Until Page Does Not Contain Element    ${BANK_ACCOUNTS_TAB}    timeout=15s


Verify Payer Cannot Be The Recipient
    [Documentation]    Verify Send to Self cannot pay the same source account.
    ...                Destination Select Account stays non-clickable and Make Payment
    ...                stays disabled so a same-account transfer cannot be submitted.

    Wait Until Element Is Visible    ${BANK_SELECT_ACCOUNT}    timeout=30s
    Element Attribute Should Match    ${BANK_SELECT_ACCOUNT}    clickable    false
    Expect Element    ${BANK_MAKE_PAYMENT_BUTTON}    disabled    timeout=10s


Select Recipient Bank
    [Arguments]    ${bank_name}
    [Documentation]    Pick the recipient bank from the Pesalink bank picker.

    Wait Until Element Is Visible    ${PESALINK_SELECT_BANK}    timeout=30s
    Click Element    ${PESALINK_SELECT_BANK}
    Wait Until Element Is Visible    ${BANK_SEARCH_INPUT}    timeout=30s
    Input Text    ${BANK_SEARCH_INPUT}    ${bank_name}
    ${bank}=    Format String    ${BANK_SEARCH_RESULT}    ${bank_name}
    Wait Until Element Is Visible    ${bank}    timeout=30s
    Click Element    ${bank}
    Wait Until Element Is Visible    ${BANK_ACCOUNT_NUMBER_INPUT}    timeout=30s


Enter Bank Account Number
    [Arguments]    ${account_number}
    [Documentation]    Enter the recipient bank account number.

    Wait Until Element Is Visible    ${BANK_ACCOUNT_NUMBER_INPUT}    timeout=30s
    Input Text    ${BANK_ACCOUNT_NUMBER_INPUT}    ${account_number}
    Field Should Contain Value    ${BANK_ACCOUNT_NUMBER_INPUT}    ${account_number}    account number


Enter Bank Recipient Mobile Number
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
    Wait Until Element Is Visible    ${BANK_MOBILE_NUMBER_INPUT}    timeout=30s
    Input Text    ${BANK_MOBILE_NUMBER_INPUT}    ${local_number}
    Field Should Contain Value    ${BANK_MOBILE_NUMBER_INPUT}    ${local_number}    mobile number


Recipient Name Should Be Resolved
    [Arguments]    ${expected_name}
    [Documentation]    Verify the bank resolved the account into a recipient name.

    ${recipient}=    Format String    ${BANK_RESOLVED_RECIPIENT}    ${expected_name}
    Wait Until Element Is Visible    ${recipient}    timeout=60s


Enter Payment Reason
    [Arguments]    ${reason}
    [Documentation]    Enter the reason for payment.

    Wait Until Element Is Visible    ${BANK_REASON_INPUT}    timeout=30s
    Input Text    ${BANK_REASON_INPUT}    ${reason}
    Field Should Contain Value    ${BANK_REASON_INPUT}    ${reason}    reason for payment


Enter Bank Transfer Amount
    [Arguments]    ${amount}    ${formatted_amount}
    [Documentation]    Focus the amount field, then type the amount.
    ...                The field only becomes an EditText once it has focus, and it
    ...                reverts to a formatted label afterwards, so the entry is
    ...                confirmed against that label rather than the input.

    Wait Until Element Is Visible    ${BANK_AMOUNT_PLACEHOLDER}    timeout=30s
    Click Element    ${BANK_AMOUNT_PLACEHOLDER}
    Wait Until Element Is Visible    ${BANK_AMOUNT_INPUT}    timeout=15s
    Input Text    ${BANK_AMOUNT_INPUT}    ${amount}
    ${value}=    Format String    ${BANK_AMOUNT_VALUE}    ${formatted_amount}
    Wait Until Element Is Visible    ${value}    timeout=15s


Open Global Transfer Options
    [Documentation]    Open the Global Transfer sheet from the bank transfer types.

    Wait Until Element Is Visible    ${BANK_GLOBAL_TRANSFER_OPTION}    timeout=30s
    Click Element    ${BANK_GLOBAL_TRANSFER_OPTION}
    Wait Until Element Is Visible    ${GLOBAL_SWIFT_OPTION}    timeout=30s


Verify Global Transfer Options Are Listed
    [Documentation]    Verify the Global Transfer sheet offers every cross-border option.

    Wait Until Element Is Visible    ${GLOBAL_PAYPAL_OPTION}    timeout=30s
    Expect Element    ${GLOBAL_SWIFT_OPTION}    visible
    Expect Element    ${GLOBAL_WESTERN_UNION_OPTION}    visible
    Expect Element    ${GLOBAL_PAPSS_OPTION}    visible


Open Swift Transfer
    [Documentation]    Open the SWIFT transfer form.
    ...                The SWIFT screen renders nothing into Android's accessibility
    ...                hierarchy, so it is confirmed by the options sheet closing
    ...                rather than by asserting on its own fields.

    Wait Until Element Is Visible    ${GLOBAL_SWIFT_OPTION}    timeout=30s
    Click Element    ${GLOBAL_SWIFT_OPTION}
    Wait Until Page Does Not Contain Element    ${GLOBAL_SWIFT_OPTION}    timeout=60s
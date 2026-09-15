*** Settings ***
Documentation    Keywords for buying and quoting insurance covers from the Transact tab.
Library          AppiumLibrary
Library          String
Resource         ../locators/insurance_locators.robot
Resource         ../variables/test_data.robot


*** Keywords ***
Open Insurance Hub
    [Documentation]    Reach the Insurance hub from the Transact tab. The hub loads its
    ...                covers from the insurer, which is slow enough to need a long wait.

    Wait Until Element Is Visible    ${INSURANCE_TRANSACT_TAB}    timeout=60s
    Click Element    ${INSURANCE_TRANSACT_TAB}
    Wait Until Element Is Visible    ${INSURANCE_TILE}    timeout=30s
    Click Element    ${INSURANCE_TILE}
    Wait Until Element Is Visible    ${INSURANCE_BUY_A_COVER_BUTTON}    timeout=180s


Open Cover Catalogue
    [Documentation]    Open the list of covers that can be quoted. A draft left by an
    ...                earlier quote is offered here instead of the catalogue, and it
    ...                swallows the tap that opened it, so it is dismissed and retried.

    Click Element    ${INSURANCE_BUY_A_COVER_BUTTON}
    Wait Until Keyword Succeeds    60s    2s    The Catalogue Or The Resume Prompt Is Shown
    Dismiss Resume Prompt
    Wait Until Keyword Succeeds    90s    3s    Reach Cover Catalogue


Dismiss Resume Prompt
    [Documentation]    Discard an offered draft, if one is offered at all.

    ${offered}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${INSURANCE_RESUME_PROMPT}
    IF    ${offered}    Wait Until Keyword Succeeds    60s    2s    Cancel Resume Prompt


Cancel Resume Prompt
    [Documentation]    Discard the offered draft. The button is replaced while the prompt
    ...                animates, so the tap is repeated until the prompt is gone.

    Run Keyword And Ignore Error    Click Element    ${INSURANCE_RESUME_CANCEL}
    Page Should Not Contain Element    ${INSURANCE_RESUME_PROMPT}


Reach Cover Catalogue
    [Documentation]    Cancelling the prompt lands on the catalogue or back on the hub,
    ...                so the hub is tapped through only when it is still shown.

    ${motor}=    Format String    ${INSURANCE_PRODUCT_BUTTON}    ${MOTOR_PRIVATE_INDEX}
    ${catalogue}=    Run Keyword And Return Status    Page Should Contain Element    ${motor}
    IF    not ${catalogue}    Click Element    ${INSURANCE_BUY_A_COVER_BUTTON}
    Page Should Contain Element    ${motor}


The Catalogue Or The Resume Prompt Is Shown
    ${motor}=    Format String    ${INSURANCE_PRODUCT_PATH}    ${MOTOR_PRIVATE_INDEX}
    Page Should Contain Element    xpath=${motor} | ${INSURANCE_RESUME_PROMPT_PATH}


Start A Quote For
    [Arguments]    ${product_index}
    [Documentation]    Open a cover from the catalogue and accept its terms.

    ${product}=    Format String    ${INSURANCE_PRODUCT_BUTTON}    ${product_index}
    Wait Until Element Is Visible    ${product}    timeout=120s
    Click Element    ${product}
    Accept Cover Terms And Conditions
    Skip Sales Code


Accept Cover Terms And Conditions
    [Documentation]    The terms are a PDF in a web view that reports nothing to
    ...                accessibility, and Agree only enables once it has been read to the
    ...                end, so the document is flung through and the button tapped by
    ...                position.

    Wait Until Element Is Visible    ${INSURANCE_TERMS_CHECKBOX}    timeout=60s
    Click Element    ${INSURANCE_TERMS_CHECKBOX}
    Wait Until Element Is Visible    ${INSURANCE_TERMS_AGREE_BUTTON}    timeout=60s
    FOR    ${i}    IN RANGE    ${INSURANCE_TERMS_PAGE_FLINGS}
        Swipe    start_x=540    start_y=2050    end_x=540    end_y=300    duration=100ms
    END
    Tap With Positions    300ms    ${{(538, 2226)}}
    Wait Until Element Is Visible    ${INSURANCE_GET_QUOTE_BUTTON}    timeout=60s
    Click Element    ${INSURANCE_GET_QUOTE_BUTTON}


Skip Sales Code
    [Documentation]    Decline to attribute the quote to a sales agent. The draft prompt
    ...                can be offered again here.

    Wait Until Keyword Succeeds    60s    2s    The Sales Code Or The Resume Prompt Is Shown
    Dismiss Resume Prompt
    Wait Until Element Is Visible    ${INSURANCE_SKIP_SALES_CODE}    timeout=90s
    Click Element    ${INSURANCE_SKIP_SALES_CODE}


The Sales Code Or The Resume Prompt Is Shown
    Page Should Contain Element    xpath=${INSURANCE_SKIP_PATH} | ${INSURANCE_RESUME_PROMPT_PATH}


Select Insurance Option
    [Arguments]    ${step_title}    ${option_index}
    [Documentation]    Pick an option on one of the wizard steps and move on.

    ${step}=    Format String    ${INSURANCE_STEP_TITLE}    ${step_title}
    ${option}=    Format String    ${INSURANCE_OPTION}    ${option_index}
    Wait Until Element Is Visible    ${step}    timeout=90s
    Wait Until Element Is Visible    ${option}    timeout=60s
    Click Element    ${option}
    Click Element    ${INSURANCE_CONTINUE_BUTTON}
    Wait Until Page Does Not Contain Element    ${step}    timeout=60s


Enter Vehicle Details
    [Arguments]    ${registration}    ${estimated_value}
    [Documentation]    Describe the vehicle being covered.

    Wait Until Element Is Visible    ${MOTOR_VEHICLE_DETAILS_TITLE}    timeout=60s
    Wait Until Element Is Visible    ${MOTOR_REGISTRATION_INPUT}    timeout=60s
    Input Text    ${MOTOR_REGISTRATION_INPUT}    ${registration}
    Enter Insurance Amount    Vehicle Estimated Value    Enter Vehicle Estimated Value    ${estimated_value}
    Leave Step    ${MOTOR_VEHICLE_DETAILS_TITLE}


Enter Vehicle Registration
    [Arguments]    ${registration}
    [Documentation]    Third party cover prices off the vehicle alone, so its vehicle step
    ...                asks for nothing but the registration.

    Wait Until Element Is Visible    ${MOTOR_VEHICLE_DETAILS_TITLE}    timeout=60s
    Wait Until Element Is Visible    ${MOTOR_REGISTRATION_INPUT}    timeout=60s
    Input Text    ${MOTOR_REGISTRATION_INPUT}    ${registration}
    Leave Step    ${MOTOR_VEHICLE_DETAILS_TITLE}


Leave Step
    [Arguments]    ${step_title}
    [Documentation]    The keyboard opened by an amount field covers Continue, so the tap
    ...                lands on the keyboard until it has closed. Each tap is given time
    ...                to navigate, or the next one lands on the following step.

    Run Keyword And Ignore Error    Hide Keyboard
    Wait Until Keyword Succeeds    60s    3s    Tap Continue And Leave    ${step_title}


Tap Continue And Leave
    [Arguments]    ${step_title}
    Run Keyword And Ignore Error    Click Element    ${INSURANCE_CONTINUE_BUTTON}
    Wait Until Page Does Not Contain Element    ${step_title}    timeout=20s


Enter Additional Covers
    [Arguments]    ${windscreen}    ${entertainment}
    [Documentation]    Add the optional benefits that carry a declared value.

    Wait Until Element Is Visible    ${MOTOR_ADDITIONAL_COVERS_TITLE}    timeout=60s
    Enter Insurance Amount    Windscreen Cover    Enter Windscreen Cover    ${windscreen}
    Enter Insurance Amount    Entertainment Unit    Enter Entertainment Unit    ${entertainment}
    Leave Step    ${MOTOR_ADDITIONAL_COVERS_TITLE}


Enter Insurance Amount
    [Arguments]    ${label}    ${placeholder}    ${amount}
    [Documentation]    Currency fields render as a placeholder label and only become an
    ...                input once tapped.

    ${label_placeholder}=    Format String    ${INSURANCE_AMOUNT_PLACEHOLDER}    ${placeholder}
    ${field}=    Format String    ${INSURANCE_AMOUNT_INPUT}    ${label}
    Click Element    ${label_placeholder}
    Wait Until Element Is Visible    ${field}    timeout=15s
    Input Text    ${field}    ${amount}


Continue Past The Quote List
    [Documentation]    Accept the cheapest quote, which the list preselects. The list is
    ...                inert until the insurers have priced it, so Continue is retried.

    Wait Until Element Is Visible    ${QUOTE_LIST_TITLE}    timeout=90s
    Wait Until Page Contains Element    ${QUOTE_LIST_PRICED_ROW}    timeout=120s
    Wait Until Keyword Succeeds    90s    5s    Tap Continue On The Quote List


Tap Continue On The Quote List
    Click Element    ${INSURANCE_CONTINUE_BUTTON}
    Wait Until Page Does Not Contain Element    ${QUOTE_LIST_TITLE}    timeout=10s


Pick The First Quote
    [Documentation]    Personal accident lists each quote with its own button instead of a
    ...                radio and a shared Continue, so a quote is opened directly.

    Wait Until Element Is Visible    ${QUOTE_LIST_TITLE}    timeout=90s
    Wait Until Page Contains Element    ${QUOTE_LIST_PRICED_ROW}    timeout=120s
    ${first}=    Format String    ${QUOTE_LIST_QUOTE_BUTTON}    0
    Wait Until Element Is Visible    ${first}    timeout=90s
    Click Element    ${first}
    Wait Until Element Is Visible    ${QUOTE_SAVE_BUTTON}    timeout=90s


Save The Quote
    [Documentation]    Keep the quote without buying the cover. Returns to the hub.

    Wait Until Element Is Visible    ${QUOTE_SAVE_BUTTON}    timeout=90s
    Wait Until Keyword Succeeds    90s    3s    Tap Save Quote


Tap Save Quote
    Click Element    ${QUOTE_SAVE_BUTTON}
    Wait Until Page Does Not Contain Element    ${QUOTE_SAVE_BUTTON}    timeout=20s


Verify Quote Is Saved
    [Arguments]    ${product}    ${identifier}
    [Documentation]    Confirm the saved quote is listed on the hub.

    ${card}=    Format String    ${INSURANCE_QUOTE_CARD_PRODUCT}    ${product}
    ${value}=    Format String    ${INSURANCE_QUOTE_CARD_VALUE}    ${identifier}
    Wait Until Element Is Visible    ${card}    timeout=90s
    Page Should Contain Element    ${value}


Verify Quote Is Listed
    [Arguments]    ${product}
    [Documentation]    Confirm a saved quote for the cover is on the hub. Quotes are listed
    ...                oldest first, so the newest is reached by scrolling.

    ${card}=    Format String    ${INSURANCE_QUOTE_CARD_PRODUCT}    ${product}
    Wait Until Element Is Visible    ${INSURANCE_TILE}    timeout=90s
    FOR    ${i}    IN RANGE    10
        ${found}=    Run Keyword And Return Status    Page Should Contain Element    ${card}
        IF    ${found}    BREAK
        Swipe    start_x=540    start_y=1900    end_x=540    end_y=700    duration=200ms
    END
    Page Should Contain Element    ${card}
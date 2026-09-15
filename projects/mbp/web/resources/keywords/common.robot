*** Settings ***
Documentation     Common page keywords and utilities for admin portal automation
Library           Browser
Library           Collections
Library           String

*** Keywords ***
Start Browser Session
    [Documentation]    Initialize browser session once for all tests in suite
    [Arguments]    ${browser}=chromium    ${headless}=False    ${timeout}=20s
    New Browser    ${browser}    headless=${headless}
    # Explicitly provide an empty permissions list so geolocation and other
    # permission prompts are automatically denied by the context (prevents
    # browser-level permission popups from blocking the UI).
    ${permissions}=    Create List
    New Context    permissions=${permissions}
    Set Browser Timeout    ${timeout}

Close All Browsers
    [Documentation]    Close all open browser instances
    Close Browser

Close Current Page
    [Documentation]    Close the current page (cleanup between tests)
    Close Page

Wait For Navigation
    [Documentation]    Wait for page navigation to complete
    [Arguments]    ${timeout}=20s
    Wait For Load State    networkidle    timeout=${timeout}

Get Current URL
    [Documentation]    Get the current page URL
    ${url}=    Get Url
    RETURN    ${url}

Take Screenshot
    [Documentation]    Take a screenshot of the current page
    [Arguments]    ${filename}
    Take Screenshot    filename=${filename}

Verify Page Title
    [Documentation]    Verify the page title contains expected text
    [Arguments]    ${expected_title}
    ${title}=    Get Title
    Should Contain    ${title}    ${expected_title}

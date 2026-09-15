*** Settings ***
Documentation     Login page object model with page-specific keywords
Library           Browser
Resource          ../locators/login.robot

*** Keywords ***
Open Login Page
    [Documentation]    Navigate to the login page
    [Arguments]    ${base_url}
    New Page    ${base_url}#/login

Login Page Should Be Visible
    [Documentation]    Verify that the login page is displayed with all required elements
    Wait For Elements State    ${LOGIN_STAFF_NO_FIELD}    visible    timeout=20s
    Wait For Elements State    ${LOGIN_PASSWORD_FIELD}    visible    timeout=20s
    Wait For Elements State    ${SIGN_IN_WITH_PASSWORD_BUTTON}    visible    timeout=20s

Enter Username
    [Documentation]    Enter staff number in the login form
    [Arguments]    ${username}
    Fill Text    ${LOGIN_STAFF_NO_FIELD}    ${username}

Enter Password
    [Documentation]    Enter password in the login form
    [Arguments]    ${password}
    Fill Text    ${LOGIN_PASSWORD_FIELD}    ${password}

Click Login Button
    [Documentation]    Click the login submit button
    Click    ${SIGN_IN_WITH_PASSWORD_BUTTON}

Attempt Login
    [Documentation]    Open the login page and submit the given credentials
    [Arguments]    ${username}    ${password}
    Open Login Page    ${BASE_URL}
    Enter Username    ${username}
    Enter Password    ${password}
    Click Login Button

Dashboard Should Be Displayed
    [Documentation]    Verify the welcome/home page is displayed after successful login
    Wait For Elements State    ${HOME_PAGE_CONTENT}    visible    timeout=20s

Ensure Logged In
    [Documentation]    Idempotent login - opens a new page and skips credentials if already authenticated.
    ...    Detects login state by the presence of the login form (not "Welcome to KCB Group",
    ...    which also appears on the login page banner).
    [Arguments]    ${base_url}    ${username}    ${password}
    New Page    ${base_url}
    ${needs_login}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${LOGIN_STAFF_NO_FIELD}    visible    timeout=10s
    IF    ${needs_login}
        Fill Text    ${LOGIN_STAFF_NO_FIELD}    ${username}
        Fill Text    ${LOGIN_PASSWORD_FIELD}    ${password}
        Click    ${SIGN_IN_WITH_PASSWORD_BUTTON}
        Wait For Elements State    ${LOGIN_STAFF_NO_FIELD}    hidden    timeout=20s
    END

Ensure Admin Logged In
    [Documentation]    Idempotent login for admin user with credentials from environment variables.
    ...    Wrapper around "Ensure Logged In" to centralize admin credential management.
    Ensure Logged In    ${BASE_URL}    ${ADMIN_USERNAME}    ${ADMIN_PASSWORD}

Ensure Checker Logged In
    [Documentation]    Idempotent login for checker user with credentials from environment variables.
    ...    Wrapper around "Ensure Logged In" to centralize checker credential management.
    Ensure Logged In    ${BASE_URL}    ${CHECKER_USERNAME}    ${CHECKER_PASSWORD}

Verify Login Error Message
    [Documentation]    Verify error message is displayed on failed login
    [Arguments]    ${expected_error}
    Wait For Elements State    ${LOGIN_ERROR_MESSAGE}    visible    timeout=30s
    ${error_text}=    Get Text    ${LOGIN_ERROR_MESSAGE}
    Should Contain    ${error_text}    ${expected_error}

Remember Me Checkbox Is Checked
    [Documentation]    Check the remember me checkbox
    Click    ${LOGIN_REMEMBER_ME_CHECKBOX}

Remember Me Checkbox Is Unchecked
    [Documentation]    Uncheck the remember me checkbox
    Click    ${LOGIN_REMEMBER_ME_CHECKBOX}

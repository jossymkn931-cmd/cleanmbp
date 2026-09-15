*** Settings ***
Documentation     Login page locators and UI element selectors

*** Variables ***
# Login Form Elements
${LOGIN_STAFF_NO_FIELD}              css=input[placeholder='Staff No.']
${LOGIN_PASSWORD_FIELD}              css=input[placeholder='Password'][type='password']
${SIGN_IN_WITH_PASSWORD_BUTTON}      xpath=//span[normalize-space()='Sign in with Password']

${LOGIN_ERROR_MESSAGE}               xpath=//p[normalize-space()='Staff information does not exist']
${LOGIN_REMEMBER_ME_CHECKBOX}        id=rememberMe

# Welcome/Home Page Elements
${WELCOME_PAGE_TITLE}                text=Welcome to KCB Group
${HOME_PAGE_CONTENT}                 text=Welcome to KCB Group

# Page Titles
${LOGIN_PAGE_TITLE}                  Login - Admin Portal

${FORGOTTEN_PASSWORD_LINK}           xpath=//a[contains(normalize-space(), 'Forgot Password')]
${SIGNUP_LINK}                       xpath=//a[contains(normalize-space(), 'Sign Up')]

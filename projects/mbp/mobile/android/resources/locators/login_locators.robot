*** Settings ***
Documentation    Android login screen locators


*** Variables ***
# Welcome-back / saved-number screen. Prefer resource-ids (fast, stable).
# Button copy is "Log in as 254…"; keep text fallbacks for older builds.
${LOGIN_WELCOME_TITLE}               id=${APP_PACKAGE}:id/oneui_bar_text
# Real control is the Button inside btn_back_login (copy: "Log in as 254…").
${LOGIN_AS_SAVED_NUMBER_BUTTON}      xpath=//*[@resource-id='${APP_PACKAGE}:id/btn_back_login']//android.widget.Button
${LOGIN_AS_SAVED_NUMBER_BUTTON_ALT}  xpath=//android.widget.Button[contains(@text,'Log in as') or contains(@text,'Login as') or contains(@text,'254')]

${MOBILE_PIN_TITLE}                  id=${APP_PACKAGE}:id/tv_password_title
${MOBILE_PIN_KEYPAD}                 id=${APP_PACKAGE}:id/keyboard_password
${MOBILE_PIN_KEY}                    xpath=//*[@resource-id='${APP_PACKAGE}:id/keyboard_password']//android.widget.TextView[@text='{}']

# Bottom nav Home tab (last match avoids other "Home" labels in content).
${MOBILE_DASHBOARD_HOME}             xpath=(//android.widget.TextView[@text='Home'])[last()]

${MOBILE_BALANCE_AMOUNT}             xpath=//*[@resource-id='home-card']//android.widget.TextView[starts-with(@text, 'KES')]
${MOBILE_BALANCE_TOGGLE}             xpath=//*[@resource-id='home-card']//android.widget.TextView[starts-with(@text, 'KES')]/following-sibling::android.view.View[1]

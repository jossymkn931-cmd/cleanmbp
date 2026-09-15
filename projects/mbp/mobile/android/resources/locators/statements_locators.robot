*** Settings ***
Documentation    Manage Statements / Get Statements locators (Transact menu)


*** Variables ***
${STATEMENTS_TRANSACT_TAB}           xpath=(//android.widget.TextView[@text='Transact'])[last()]
${STATEMENTS_TILE}                   xpath=//android.widget.TextView[@text='Manage Statements']
${STATEMENTS_TILE_CLICKABLE}         xpath=//android.widget.TextView[@text='Manage Statements']/parent::*

${STATEMENTS_HUB_TITLE}              xpath=//android.widget.TextView[@text='My Statements']
${STATEMENTS_HUB_SUBTITLE}           xpath=//android.widget.TextView[@text='Manage your statements']
${STATEMENTS_HUB_EMPTY}              xpath=//android.widget.TextView[contains(@text,'do not have any statements') or contains(@text,'schedule set up')]
${STATEMENTS_GET_BUTTON}             xpath=//android.widget.Button[contains(@text,'Get Statements')]

${STATEMENTS_FORM_TITLE}             xpath=//android.widget.TextView[@text='Get Statements']
${STATEMENTS_SELECT_ACCOUNT_LABEL}   xpath=//android.widget.TextView[@text='Select Account']
${STATEMENTS_ACCOUNT_VALUE}          xpath=//android.widget.TextView[@text='Select Account']/following::android.widget.TextView[1]
${STATEMENTS_ACCOUNT_MASKED}         xpath=//android.widget.TextView[@text='Select Account']/following::android.widget.TextView[contains(@text,'****')][1]
${STATEMENTS_PERIOD_LABEL}           xpath=//android.widget.TextView[@text='Period']
${STATEMENTS_PERIOD_1M}              xpath=//android.widget.RadioButton[@content-desc='period_1M']
${STATEMENTS_PERIOD_1D}              xpath=//android.widget.RadioButton[@content-desc='period_1D']
${STATEMENTS_PERIOD_3M}              xpath=//android.widget.RadioButton[@content-desc='period_3M']

# Dropdown rows are non-clickable TextViews — tap by center (see Tap Statements Control).
${STATEMENTS_FORMAT_DROPDOWN}        xpath=//android.widget.TextView[@text='Statement Format']/following::android.widget.TextView[1]
${STATEMENTS_FORMAT_OPTION_PDF}      xpath=//android.widget.TextView[@text='PDF']
${STATEMENTS_FORMAT_OPTION_XLS}      xpath=//android.widget.TextView[@text='XLS']
${STATEMENTS_FORMAT_VALUE_PDF}       xpath=//android.widget.TextView[@text='Statement Format']/following::android.widget.TextView[@text='PDF'][1]

${STATEMENTS_DELIVERY_DROPDOWN}      xpath=//android.widget.TextView[@text='Delivery Method']/following::android.widget.TextView[1]
${STATEMENTS_DELIVERY_VIA_EMAIL}     xpath=//android.widget.TextView[@text='Via Email']
${STATEMENTS_DELIVERY_DOWNLOAD}      xpath=//android.widget.TextView[@text='Download']
${STATEMENTS_DELIVERY_VALUE_EMAIL}   xpath=//android.widget.TextView[@text='Delivery Method']/following::android.widget.TextView[@text='Via Email'][1]

# Ionic input id rotates (ion-input-N); match any EditText under the Email label.
${STATEMENTS_EMAIL_INPUT}            xpath=//android.widget.TextView[@text='Email Address']/following::android.widget.EditText[1]
${STATEMENTS_EMAIL_INPUT_ANY}        xpath=//android.widget.EditText[contains(@resource-id,'ion-input')]
${STATEMENTS_SUBMIT_BUTTON}          xpath=//android.widget.Button[@text='Get Statements']

${STATEMENTS_CONFIRM_TITLE}          xpath=//android.widget.TextView[@text='Confirm Summary']
${STATEMENTS_CONFIRM_PERIOD}         xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Period'][1]/following::android.widget.TextView[1]
${STATEMENTS_CONFIRM_FORMAT}         xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Format'][1]/following::android.widget.TextView[1]
${STATEMENTS_CONFIRM_EMAIL}          xpath=//android.widget.TextView[@text='Confirm Summary']/following::android.widget.TextView[@text='Email Address'][1]/following::android.widget.TextView[1]
${STATEMENTS_CONTINUE_BUTTON}        xpath=//*[@content-desc='continue']
${STATEMENTS_CANCEL_BUTTON}          xpath=//*[@content-desc='cancel']

${STATEMENTS_VERIFY_EMAIL_TITLE}     xpath=//android.widget.TextView[@text='Verify Email']
${STATEMENTS_VERIFY_EMAIL_BODY}      xpath=//android.widget.TextView[contains(@text,'secret code') or contains(@text,'Check Your Email')]

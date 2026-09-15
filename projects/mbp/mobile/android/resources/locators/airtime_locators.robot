*** Settings ***
Documentation    Buy Airtime locators


*** Variables ***
${AIRTIME_TILE}                   xpath=//android.widget.TextView[@text='Airtime']
${AIRTIME_FORM_TITLE}             xpath=//android.widget.TextView[@text='Buy Airtime']

${AIRTIME_BUY_SELF_TAB}           xpath=//android.view.View[@text='Buy for Self']
${AIRTIME_BUY_OTHER_TAB}          xpath=//android.view.View[@text='Buy for Other']

${AIRTIME_MOBILE_PREFIX}          xpath=//android.widget.TextView[@text='+254']
${AIRTIME_MOBILE_NUMBER_INPUT}    xpath=//android.widget.TextView[@text='Mobile Number']/following::android.widget.EditText[1]
${AIRTIME_PROVIDER_LABEL}         xpath=//android.widget.TextView[@text='{}']

${AIRTIME_AMOUNT_PLACEHOLDER}     xpath=//android.widget.TextView[@text='Enter Amount']
${AIRTIME_AMOUNT_INPUT}           xpath=//android.widget.TextView[@text='Amount']/following::android.widget.EditText[1]
${AIRTIME_AMOUNT_VALUE}           xpath=//android.widget.TextView[@text='{}']

${AIRTIME_SELF_NUMBER_LABEL}      xpath=//android.widget.TextView[@text='+254']/following::android.widget.TextView[1]

${AIRTIME_RESULT_AMOUNT}          xpath=(//android.widget.TextView[@text='Amount'])[1]/following-sibling::android.widget.TextView[1]
${AIRTIME_RESULT_TYPE}            xpath=//android.widget.TextView[@text='Transaction Type']/following-sibling::android.widget.TextView[1]
${AIRTIME_RESULT_PROVIDER}        xpath=//android.widget.TextView[@text='Provider']/following-sibling::android.widget.TextView[1]
*** Settings ***
Documentation    Dashboard Pay entry point and its payment method sheet


*** Variables ***
${PAY_TILE}                        xpath=//android.widget.TextView[@text='Pay']

${PAY_VOOMA_OPTION}                xpath=//android.widget.TextView[contains(@text, 'Pay to Vooma')]
${PAY_LIPA_NA_KCB_OPTION}          xpath=//android.widget.TextView[@text='Lipa na KCB']
${PAY_MPESA_OPTION}                xpath=//android.widget.TextView[@text='M-Pesa']
${PAY_UTILITY_BILLS_OPTION}        xpath=//android.widget.TextView[@text='Utility Bills & Services']
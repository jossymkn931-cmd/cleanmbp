*** Settings ***
Documentation    QR code locators, covering My QR and the scanner


*** Variables ***
${QR_ICON_X_RATIO}              0.808
${QR_ICON_Y_RATIO}              0.083

${QR_SCREEN_TITLE}              xpath=//android.widget.TextView[@text='Scan QR Code']
${QR_SCAN_TAB}                  xpath=//android.view.View[@text='Scan QR']
${QR_MY_QR_TAB}                 xpath=//android.view.View[@text='My QR']
${QR_SCANNER_HINT}              xpath=//android.widget.TextView[contains(@text, 'automatically detected')]

${QR_SELECT_ACCOUNT_LABEL}      xpath=//android.widget.TextView[@text='Select Account']
${QR_SELECTED_ACCOUNT}          xpath=//android.widget.TextView[@text='Select Account']/following::android.widget.TextView[1]
${QR_SET_AMOUNT_BUTTON}         xpath=//android.widget.Button[contains(@text, 'Set amount')]
${QR_DOWNLOAD_BUTTON}           xpath=//android.widget.Button[contains(@text, 'Download')]
${QR_SWITCH_TO_BARCODE}         xpath=//android.widget.TextView[@text='Switch to Barcode']

${QR_SET_AMOUNT_TITLE}          xpath=//android.widget.TextView[@text='Set amount']
${QR_AMOUNT_PLACEHOLDER}        xpath=//android.widget.TextView[@text='0.00']
${QR_AMOUNT_INPUT}              xpath=//android.widget.TextView[@text='KES']/following::android.widget.EditText[1]
${QR_AMOUNT_VALUE}              xpath=//android.widget.TextView[@text='KES']/following::android.widget.TextView[@text='{}'][1]
${QR_GENERATE_BUTTON}           xpath=//android.widget.Button[contains(@text, 'Generate QR')]

${QR_AMOUNT_LABEL}              xpath=//android.widget.TextView[@text='Amount']
${QR_ENCODED_AMOUNT}            xpath=//android.widget.TextView[@text='Amount']/following::android.widget.TextView[1]
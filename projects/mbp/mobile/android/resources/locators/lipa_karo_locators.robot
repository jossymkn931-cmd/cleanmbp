*** Settings ***
Documentation    Lipa Karo locators (Transact menu)


*** Variables ***
${LIPA_KARO_TRANSACT_TAB}              xpath=(//android.widget.TextView[@text='Transact'])[last()]
${LIPA_KARO_TILE}                      xpath=//android.widget.TextView[@text='Lipa Karo']
${LIPA_KARO_TILE_CLICKABLE}            xpath=//android.widget.TextView[@text='Lipa Karo']/parent::*
${LIPA_KARO_TITLE}                     xpath=//android.widget.TextView[@text='Lipa Karo']
${LIPA_KARO_SCHOOL_PLACEHOLDER}        xpath=//android.widget.TextView[@text='Select School Name']
${LIPA_KARO_SCHOOL_SEARCH_ICON}        xpath=//android.widget.TextView[@text='Select School Name']/following::android.widget.Image[1]
${LIPA_KARO_SEARCH_SHEET_TITLE}        xpath=//android.widget.TextView[@text='Search School']
${LIPA_KARO_SCHOOL_SEARCH}             xpath=//android.widget.EditText[not(@resource-id='ion-input-1')]
${LIPA_KARO_SCHOOL_SEARCH_ANY}         xpath=//android.widget.EditText
${LIPA_KARO_SCHOOL_RESULT}             xpath=//android.widget.TextView[@text='{}']
${LIPA_KARO_ACCOUNT_PLACEHOLDER}       xpath=//android.widget.TextView[@text='Select Account number']
${LIPA_KARO_ACCOUNT_FIELD}             xpath=//android.widget.TextView[@text='Select Account number']/ancestor::android.view.View[1]
${LIPA_KARO_ACCOUNT_SHEET_TITLE}       xpath=//android.widget.TextView[contains(@text,'Select School Acc')]
${LIPA_KARO_ACCOUNT_NUMBER}            xpath=//android.widget.TextView[@text='{}']
${LIPA_KARO_ACCOUNT_CONTINUE}          accessibility_id=continue
${LIPA_KARO_ACCOUNT_CONTINUE_ALT}      xpath=//android.widget.TextView[@text='Continue']
${LIPA_KARO_ADMISSION_LABEL}           xpath=//android.widget.TextView[@text="Student's admission number"]
${LIPA_KARO_ADMISSION_INPUT}           xpath=//android.widget.EditText[@resource-id='ion-input-1']
${LIPA_KARO_ADMISSION_INPUT_ALT}       xpath=//android.widget.TextView[@text="Student's admission number"]/following::android.widget.EditText[1]
${LIPA_KARO_ADMISSION_PLEASE_ENTER}    xpath=//android.widget.TextView[@text='Please Enter']
${LIPA_KARO_STUDENT_NAME_LABEL}        xpath=//android.widget.TextView[@text="Student's name"]
${LIPA_KARO_STUDENT_NAME_PLACEHOLDER}  xpath=//android.widget.TextView[@text="Student's name"]/following::android.widget.TextView[@text='Please Enter'][1]
${LIPA_KARO_STUDENT_NAME_INPUT}        xpath=//android.widget.TextView[@text="Student's name"]/following::android.widget.EditText[1]
${LIPA_KARO_AMOUNT_PLACEHOLDER}        xpath=//android.widget.TextView[@text='Enter Amount']
${LIPA_KARO_AMOUNT_INPUT}              xpath=//android.widget.TextView[@text='Amount']/following::android.widget.EditText[1]
${LIPA_KARO_AMOUNT_VALUE}              xpath=//android.widget.TextView[@text='{}']
${LIPA_KARO_RESULT_TITLE}              xpath=//android.widget.TextView[@text='Request Sent']
${LIPA_KARO_RESULT_STATUS}             xpath=//android.widget.TextView[@text='In Processing']
${LIPA_KARO_RESULT_SERVICE_TYPE}       xpath=//android.widget.TextView[@text='Lipa Karo']
${LIPA_KARO_RESULT_AMOUNT}             xpath=//android.widget.TextView[@text='KES 30,000.00']
${LIPA_KARO_RESULT_TRANSACTION_ID}     xpath=//android.widget.TextView[@text='Transaction ID']/following-sibling::android.widget.TextView[1]
${LIPA_KARO_RESULT_SCHOOL}             xpath=//android.widget.TextView[@text='ALLIANCE GIRLS HIGH SCHOOL']

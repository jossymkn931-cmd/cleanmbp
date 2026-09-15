*** Variables ***
${INSURANCE_TRANSACT_TAB}          xpath=//android.widget.TextView[@text='Transact']
${INSURANCE_TILE}                  xpath=//android.widget.TextView[@text='Insurance']
${INSURANCE_BUY_A_COVER_BUTTON}    accessibility_id=buyACover

${INSURANCE_RESUME_PROMPT_PATH}    //android.widget.TextView[@text='Pick up where you left off']
${INSURANCE_RESUME_PROMPT}         xpath=${INSURANCE_RESUME_PROMPT_PATH}
${INSURANCE_RESUME_CANCEL}         accessibility_id=cancel

${INSURANCE_PRODUCT_BUTTON}        accessibility_id=getQuote_{}
${INSURANCE_PRODUCT_PATH}          //*[@content-desc='getQuote_{}']
${INSURANCE_SKIP_PATH}             //*[@content-desc='skip']
${INSURANCE_TERMS_CHECKBOX}        xpath=//android.widget.CheckBox
${INSURANCE_TERMS_AGREE_BUTTON}    accessibility_id=agree
${INSURANCE_GET_QUOTE_BUTTON}      accessibility_id=getQuote
${INSURANCE_SKIP_SALES_CODE}       accessibility_id=skip

${INSURANCE_CONTINUE_BUTTON}       accessibility_id=continue
${INSURANCE_OPTION}                accessibility_id=radio_{}
${INSURANCE_STEP_TITLE}            xpath=//android.widget.TextView[@text='{}']

${MOTOR_TYPE_TITLE}                xpath=//android.widget.TextView[@text='Type of Motor Insurance']
${MOTOR_COVER_TITLE}               xpath=//android.widget.TextView[@text='Type of Cover']
${MOTOR_VEHICLE_DETAILS_TITLE}     xpath=//android.widget.TextView[@text='Vehicle Details']
${MOTOR_ADDITIONAL_COVERS_TITLE}   xpath=//android.widget.TextView[@text='Additional Covers']
${MOTOR_REGISTRATION_INPUT}        xpath=//android.widget.TextView[@text='Vehicle Registration']/following::android.widget.EditText[1]

${INSURANCE_AMOUNT_PLACEHOLDER}    xpath=//android.widget.TextView[@text='{}']
${INSURANCE_AMOUNT_INPUT}          xpath=//android.widget.TextView[@text='{}']/following::android.widget.EditText[1]

${QUOTE_LIST_TITLE}                xpath=//android.widget.TextView[@text='Select your Preferred Quote']
${QUOTE_LIST_PRICED_ROW}           xpath=//android.widget.TextView[contains(@text,'KES')]

${QUOTE_LIST_QUOTE_BUTTON}         accessibility_id=buyCover_{}
${QUOTE_SAVE_BUTTON}               accessibility_id=saveQuote
${QUOTE_BUY_COVER_BUTTON}          accessibility_id=buyCover

${INSURANCE_QUOTE_CARD_PRODUCT}    xpath=//android.widget.TextView[@text='{}']
${INSURANCE_QUOTE_CARD_VALUE}      xpath=//android.widget.TextView[@text='{}']
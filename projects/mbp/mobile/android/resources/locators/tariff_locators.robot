*** Variables ***
${TARIFF_CALCULATOR_TILE}          xpath=//android.widget.TextView[@text='Tariff Calculator']

${TARIFF_TITLE}                    xpath=//android.widget.TextView[@text='Tariff Calculator']
${TARIFF_SOURCE_OF_FUNDS}          xpath=//android.widget.TextView[@text='Source of Funds']

${TARIFF_TYPE_VALUE}               xpath=//android.widget.TextView[@text='Select transaction type']/following::android.widget.TextView[1]
${TARIFF_TYPE_SHEET}               xpath=//android.widget.TextView[@text='Transaction Type']
${TARIFF_TYPE_OPTION}              xpath=//android.widget.TextView[@text='Transaction Type']/following::android.widget.TextView[@text='{}'][1]

${TARIFF_AMOUNT_VALUE}             xpath=//android.widget.TextView[@text='Amount']/following::android.widget.TextView[2]
${TARIFF_AMOUNT_INPUT}             xpath=//android.widget.EditText[@resource-id='ion-input-0']

${TARIFF_CHARGE_LABEL}             xpath=//android.widget.TextView[@text='Transaction charge']
${TARIFF_CHARGE_VALUE}             xpath=//android.widget.TextView[@text='Transaction charge']/following::android.widget.TextView[1]
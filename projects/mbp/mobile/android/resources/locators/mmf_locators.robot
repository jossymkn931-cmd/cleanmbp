*** Variables ***
${MMF_CALCULATOR_TILE}             xpath=//android.widget.TextView[@text='MMF Calculator']

${MMF_ANALYSIS_TITLE}              xpath=//android.widget.TextView[@text='Start Your Analysis']

${MMF_INVESTMENT_TYPE_LABEL}       xpath=//android.widget.TextView[@text='Select Investment Type']
${MMF_INVESTMENT_TYPE_VALUE}       xpath=//android.widget.TextView[@text='Select Investment Type']/following::android.widget.TextView[1]
${MMF_INVESTMENT_SHEET}            xpath=//android.widget.TextView[@text='Select Investment']
${MMF_INVESTMENT_OPTION}           xpath=//android.widget.TextView[@text='Select Investment']/following::android.widget.TextView[@text='{}'][1]

${MMF_CAPITAL_VALUE}               xpath=//android.widget.TextView[@text='Initial Capital Amount']/following::android.widget.TextView[2]
${MMF_CAPITAL_INPUT}               xpath=//android.widget.TextView[@text='Initial Capital Amount']/following::android.widget.EditText[1]

${MMF_CONTRIBUTION_VALUE}          xpath=//android.widget.TextView[@text='Contribution Frequency']/following::android.widget.TextView[2]
${MMF_CONTRIBUTION_INPUT}          xpath=//android.widget.TextView[@text='Contribution Frequency']/following::android.widget.EditText[1]

${MMF_DURATION_VALUE}              xpath=//android.widget.TextView[@text='Duration']/following::android.widget.TextView[1]
${MMF_DURATION_PRESET}             accessibility_id=button-{}

${MMF_FUTURE_BALANCE_LABEL}        xpath=//android.widget.TextView[@text='Potential Future Balance']
${MMF_FUTURE_BALANCE_VALUE}        xpath=//android.widget.TextView[@text='Potential Future Balance']/following::android.widget.TextView[1]
${MMF_INTEREST_EARNED_VALUE}       xpath=//android.widget.TextView[@text='Interest Earned']/following::android.widget.TextView[1]
${MMF_INTEREST_RATE_VALUE}         xpath=//android.widget.TextView[@text='Interest Rate']/following::android.widget.TextView[1]

${MMF_CALCULATE_BUTTON}            accessibility_id=investmentCalculateNow

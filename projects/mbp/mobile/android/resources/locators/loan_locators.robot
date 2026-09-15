*** Settings ***
Documentation    Loans and Loan Calculator locators


*** Variables ***
${LOANS_TILE}                      xpath=//android.widget.TextView[@text='Loans']
${LOANS_MOBILE_TAB}                xpath=//android.view.View[@text='Mobile Loans']
${LOANS_PERSONAL_TAB}              xpath=//android.view.View[@text='Personal Loans']
${LOANS_APPLY_LOAN_TAB}            xpath=//android.view.View[@text='Apply Loan']

${LOAN_CALCULATOR_BUTTON}          accessibility_id=loanCalculator

${LOAN_CALC_TITLE}                 xpath=//android.widget.TextView[@text='Loan Calculator']
${LOAN_CALC_EMPTY_PROMPT}          xpath=//android.widget.TextView[@text='Select Loan type']

${LOAN_CALC_TYPE_SELECTOR}         xpath=(//android.widget.TextView[@text='Select Loan'])[1]/following::android.widget.TextView[1]
${LOAN_CALC_TYPE_OPTION}           xpath=(//android.widget.TextView[@text='Select Loan'])[last()]/following::android.widget.TextView[@text='{}'][1]

${LOAN_CALC_AMOUNT_VALUE}          xpath=//android.widget.TextView[@text='KES']/following::android.widget.TextView[1]
${LOAN_CALC_AMOUNT_INPUT}          xpath=//android.widget.EditText[@resource-id='ion-input-0']

${LOAN_CALC_DURATION_VALUE}        xpath=//android.widget.TextView[@text='Duration']/following::android.widget.TextView[1]
${LOAN_CALC_DURATION_PLACEHOLDER}  xpath=//android.widget.TextView[@text='Select Period']
${LOAN_CALC_DURATION_SHEET}        xpath=//android.widget.TextView[@text='Loan Duration']
${LOAN_CALC_DURATION_OPTION}       xpath=//android.widget.TextView[@text='Loan Duration']/following::android.widget.TextView[@text='{}'][1]

${LOAN_CALC_DURATION_SLIDER}       xpath=//android.widget.SeekBar
${LOAN_CALC_DURATION_TRACK}        xpath=//android.view.View[@resource-id='range-label']
${LOAN_CALC_DURATION_MIN}          xpath=//android.view.View[@resource-id='range-label']/following::android.widget.TextView[1]
${LOAN_CALC_DURATION_MAX}          xpath=//android.view.View[@resource-id='range-label']/following::android.widget.TextView[2]

${LOAN_CALC_RESULTS_HEADING}       xpath=//android.widget.TextView[@text='Monthly Repayments']
${LOAN_CALC_MONTHLY_REPAYMENT}     xpath=//android.widget.TextView[@text='Monthly Repayments']/following::android.widget.TextView[1]
${LOAN_CALC_INTEREST}              xpath=//android.widget.TextView[@text='Interest']/following::android.widget.TextView[1]
${LOAN_CALC_TOTAL_REPAYMENT}       xpath=//android.widget.TextView[@text='Total Repayments']/following::android.widget.TextView[1]
${LOAN_CALC_RATE}                  xpath=//android.widget.TextView[@text='Rate']/following::android.widget.TextView[1]

${LOAN_CALC_CALCULATE_BUTTON}      accessibility_id=loanCalculateNow
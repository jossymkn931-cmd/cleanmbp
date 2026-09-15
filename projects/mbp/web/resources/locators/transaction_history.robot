*** Variables ***
# Navigation menu
${TRANSACTION_MENU}               xpath=//span[normalize-space()='Transaction']
${TRANSACTION_HISTORY_MENU}       xpath=//span[normalize-space()='Transaction History']

# Loan submenu
${LOAN_DIRECT_MENU}               xpath=//li[contains(@class,'lastitem') and contains(@class,'nest-menu')]//div[contains(@class,'el-sub-menu__title')]//span[@class='el-tooltip__trigger' and normalize-space()='Loan'][not(ancestor::*[@data-test-id='交易历史'])]
${LOAN_TH_MENU}                   xpath=//span[normalize-space()='Transaction History']/ancestor::div[contains(@class,'el-sub-menu__title')]/parent::li//ul[@role='menu']//span[@class='el-tooltip__trigger' and normalize-space()='Loan']
${DISBURSEMENT_MENU}              xpath=//li[@class='el-sub-menu is-opened lastitem nest-menu']//span[@class='el-tooltip__trigger'][normalize-space()='Disbursement']
${SAVINGS_TH_MENU}                xpath=//span[normalize-space()='Transaction History']/ancestor::div[contains(@class,'el-sub-menu__title')]/parent::li//ul[@role='menu']//span[@class='el-tooltip__trigger' and normalize-space()='Savings']
${PAYMENT_TH_MENU}                xpath=//span[normalize-space()='Transaction History']/ancestor::div[contains(@class,'el-sub-menu__title')]/parent::li//ul[@role='menu']//span[@class='el-tooltip__trigger' and normalize-space()='Payment']
${TRANSFER_TH_MENU}               xpath=//span[normalize-space()='Transaction History']/ancestor::div[contains(@class,'el-sub-menu__title')]/parent::li//ul[@role='menu']//span[@class='el-tooltip__trigger' and normalize-space()='Transfer']

# Insurance submenu
${INSURANCE_TH_MENU}              xpath=//span[normalize-space()='Insurance']
${POLICY_TRANSACTION_MENU}        xpath=//span[normalize-space()='Policy Transaction Re...'] or xpath=//span[contains(text(),'Policy Transaction')]

# Common page elements
${SEARCH_BUTTON}                  xpath=//span[normalize-space()='Search']
${TRANSACTION_TYPE_DROPDOWN}      xpath=//input[@placeholder='Transaction type']
${DROPDOWN_FIRST_OPTION}          xpath=//ul[contains(@class,'el-select-dropdown__list')]//li[contains(@class,'el-option')][1]
${DATE_EDITOR_RANGE}              xpath=//*[contains(@class,'el-date-editor--daterange')]
${DATE_RANGE_CLEAR_BUTTON}        xpath=//i[@class='el-icon el-input__icon el-range__close-icon']//*[name()='svg']
${DATE_CREATED_START}             xpath=(//*[contains(@class,'el-date-editor--daterange')]//input[@class='el-range-input'])[1]
${DATE_CREATED_END}               xpath=(//*[contains(@class,'el-date-editor--daterange')]//input[@class='el-range-input'])[2]
# Date picker calendar cells
${DATE_PICKER_TABLE}              xpath=(//table[@class='el-date-table'])[1]
${DATE_PICKER_FIRST_DAY_CELL}     xpath=(//table[@class='el-date-table'])[1]//td[contains(@class,'available') and not(contains(@class,'prev-month'))][.//span[normalize-space()='1']]
${TABLE_MBP_REF_HEADER}           xpath=//th//div[normalize-space()='MBP Reference No.']
${FIRST_TABLE_ROW}                xpath=(//tr[contains(@class,'el-table__row')])[1]
${DETAIL_BUTTON}                  xpath=//span[normalize-space()='Detail']

*** Variables ***
# Navigation menu
${SERVICE_PARAMETER_MENU}         xpath=//span[normalize-space()='Service Parameter']
${LOAN_MENU}                      xpath=//li[@class='el-sub-menu is-opened borderbottomdashed outer-most select-none']//ul[@role='menu']//li[@role='menuitem']//div[@class='el-sub-menu__title']//div//span[@class='el-tooltip__trigger'][normalize-space()='Loan']
${SALARY_ADVANCE_WHITELIST_MENU}  xpath=//span[contains(text(),'Salary Advance Whitelist')]

# Page elements - View menu item in Salary Advance Whitelist submenu (contextual: View within Salary Advance Whitelist menu item)
${VIEW_MENU_ITEM}                 xpath=//span[contains(text(),'Salary Advance Whitelist')]/ancestor::li//span[@class='el-tooltip__trigger' and normalize-space()='View']
${SEARCH_BUTTON}                  xpath=//span[normalize-space()='Search']
${FIRST_TABLE_ROW}                xpath=//tbody//tr[1]
${FIRST_ROW_RADIO_BUTTON}         xpath=//tbody//tr[1]//input[@type='radio' and @class='el-radio__original']
${CHANGE_STATUS_BUTTON}           xpath=//span[normalize-space()='Change status']
${STATUS_DROPDOWN}                xpath=//input[@placeholder='Product white status']
${DROPDOWN_SECOND_OPTION}         xpath=//ul[contains(@class,'el-select-dropdown__list')]//li[contains(@class,'el-option')][2]
${SUBMIT_BUTTON}                  xpath=//span[normalize-space()='Submit']

# Table content
${TABLE_HEADER}                   xpath=//th//div[normalize-space()='MBP customer No.']
${TABLE_FIRST_ROW_DATA}           xpath=//tbody//tr[1]

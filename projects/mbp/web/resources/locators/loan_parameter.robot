*** Variables ***
# Navigation menu locators
${SERVICE_PARAMETER_MENU}         xpath=//span[normalize-space()='Service Parameter']
${LOAN_SUBMENU}                   xpath=//li[@class='el-sub-menu is-opened borderbottomdashed outer-most select-none']//ul[@role='menu']//li[@role='menuitem']//div[@class='el-sub-menu__title']//div//span[@class='el-tooltip__trigger'][normalize-space()='Loan']
${LOAN_PARAMETER_MENU}            xpath=//span[normalize-space()='Loan Parameter']
${SEARCH_BUTTON}                  xpath=//span[normalize-space()='Search']

# Content waits - use table row instead of container
${TABLE_HEADER_PRODUCT_CODE}      xpath=//th//div[normalize-space()='Product code']
${TABLE_FIRST_ROW}                xpath=//tbody//tr[1]
${LOAN_PARAMETER_LOADING}         xpath=//div[@class='v-loading-mask']

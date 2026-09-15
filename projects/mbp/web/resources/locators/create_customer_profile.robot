*** Settings ***
Documentation     Create Customer Profile page locators and UI element selectors

*** Variables ***
${CUSTOMER_MENU}                     xpath=//li[@data-test-id='客户管理']//div[@class='el-sub-menu__title']//div//span[@class='el-tooltip__trigger'][normalize-space()='Customer']
${INDIVIDUAL_CUSTOMER_MENU}          xpath=//li[@data-test-id='客户管理']//div[@class='el-sub-menu__title']//span[@class='el-tooltip__trigger'][normalize-space()='Individual Customer']
${CREATE_CUSTOMER_PROFILE_MENU}      xpath=//*[@data-test-id='neo_cus_create']//span[@class='el-tooltip__trigger'][normalize-space()='Create Customer Profile']

# Account search
${ACCOUNT_NO_FIELD}                  css=input[placeholder='Account No.']
${SEARCH_BUTTON}                     xpath=//span[normalize-space()='Search']
${CLEAR_BUTTON}                      xpath=//span[normalize-space()='Clear']

# Customer Information from T24 section
${T24_INFO_SECTION}                  xpath=//*[normalize-space()='Customer Information from T24']
${MOBILE_NO_FIELD}                   css=input[placeholder='Mobile No.']
${CUSTOMER_NAME_FIELD}               css=input[placeholder='Customer name']
${GENDER_SELECT}                     css=input[placeholder='Select']
${LEGAL_ID_TYPE_SELECT}              css=input[placeholder='Legal ID type']
${LEGAL_ID_NO_FIELD}                 css=input[placeholder='Legal ID No.']
${DATE_OF_BIRTH_FIELD}               css=input[placeholder='Date of birth']

# Legal ID type dropdown options (item 4 - supported document types)
${LEGAL_ID_TYPE_DROPDOWN_LIST}       xpath=//ul[contains(@class,'el-select-dropdown__list')]

# Action
${CREATE_CUSTOMER_PROFILE_BUTTON}    xpath=//span[normalize-space()='Create customer profile']
# A populated (found) customer ENABLES the create button; a non-existent account leaves it disabled
${CREATE_BUTTON_ENABLED}             xpath=//button[not(contains(@class,'is-disabled'))]//span[normalize-space()='Create customer profile']
${CREATE_BUTTON_DISABLED}            xpath=//button[contains(@class,'is-disabled')]//span[normalize-space()='Create customer profile']

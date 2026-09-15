*** Settings ***
Documentation     Customer Profile (search) page locators and UI element selectors

*** Variables ***
# Navigation menu (Customer > Individual Customer > Customer Profile)
# Scoped under the Customer container (data-test-id='客户管理' = "Customer Management")
${CUSTOMER_MENU}                 xpath=//li[@data-test-id='客户管理']//div[@class='el-sub-menu__title']//div//span[@class='el-tooltip__trigger'][normalize-space()='Customer']
${INDIVIDUAL_CUSTOMER_MENU}      xpath=//li[@data-test-id='客户管理']//div[@class='el-sub-menu__title']//span[@class='el-tooltip__trigger'][normalize-space()='Individual Customer']
# Customer Profile scoped to the Individual Customer sub-menu so it does not collide
# with the Business Customer "Customer Profile" item.
${CUSTOMER_PROFILE_MENU}         xpath=//div[contains(@class,'el-sub-menu__title')][.//span[normalize-space()='Individual Customer']]/following-sibling::ul//span[@class='el-tooltip__trigger'][normalize-space()='Customer Profile']

# Search form
${SEARCH_INPUT}                  css=input[placeholder='Mobile No.']
${SEARCH_BUTTON}                 xpath=//span[normalize-space()='Search']
${CLEAR_BUTTON}                  xpath=//span[normalize-space()='Clear']

# Result detail view (searching a specific number opens the customer's profile detail,
# not a paginated results table)
${CUSTOMER_PROFILE_DETAILS}      xpath=//*[normalize-space()='Customer Profile Details']
${PROFILE_INFO_TAB}              xpath=//*[normalize-space()='Profile Info']

# The detail panel is always rendered; a populated profile ENABLES the action buttons
# while a non-existent number leaves them disabled (Element UI 'is-disabled' class).
${UPDATE_PROFILE_BUTTON_ENABLED}     xpath=//button[not(contains(@class,'is-disabled'))]//span[normalize-space()='Update Profile']
${UPDATE_PROFILE_BUTTON_DISABLED}    xpath=//button[contains(@class,'is-disabled')]//span[normalize-space()='Update Profile']

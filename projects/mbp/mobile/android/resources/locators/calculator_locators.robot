*** Variables ***
# The calculator menu is reached from the profile drawer, which is the only menu in the
# app that has to be scrolled before its entries can be used.
${SETTINGS_AVATAR}                 xpath=//android.view.View[@resource-id='head-avatar']
${SETTINGS_MENU_TITLE}             xpath=//android.widget.TextView[@text='Settings']
${SETTINGS_VERSION}                xpath=//android.widget.TextView[starts-with(@text,'v ')]

${CALCULATOR_HUB_TITLE}            xpath=//android.widget.TextView[@text='Calculator']
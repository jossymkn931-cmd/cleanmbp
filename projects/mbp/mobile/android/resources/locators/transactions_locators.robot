*** Settings ***
Documentation    Recent mobile transactions locators on Home


*** Variables ***
${RECENT_TRANSACTIONS_TITLE}          xpath=//android.widget.TextView[@text='Recent Mobile Transactions']
${RECENT_TRANSACTIONS_VIEW_ALL}       xpath=//android.widget.TextView[@text='Recent Mobile Transactions']/following::android.widget.TextView[@text='View All'][1]
${TRANSACTIONS_SCREEN_TITLE}          xpath=//android.widget.TextView[@text='Transactions']
${TRANSACTIONS_LIST_ITEM}             xpath=(//android.widget.TextView[contains(@text,'KES')])[1]
${TRANSACTIONS_SUCCESS_ROW}           xpath=(//android.widget.TextView[@text='Successful'])[1]
${TRANSACTION_STATUS_LABEL}           xpath=//android.widget.TextView[@text='Transaction Status']
${TRANSACTION_STATUS_SUCCESS}         xpath=//android.widget.TextView[@text='Successful']
${TRANSACTION_MBP_REFERENCE}          xpath=//android.widget.TextView[@text='MBP Reference No.']
${TRANSACTION_RECEIPT}                xpath=//android.widget.TextView[contains(@text,'Receipt')]
${NOTIFICATIONS_TITLE}                xpath=//android.widget.TextView[@text='Notifications']

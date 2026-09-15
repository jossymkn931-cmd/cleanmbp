*** Settings ***
Documentation    PayPal module locators (Transact menu)


*** Variables ***
${PAYPAL_TRANSACT_TAB}             xpath=(//android.widget.TextView[@text='Transact'])[last()]
${PAYPAL_TILE}                     xpath=//android.widget.TextView[@text='PayPal']
${PAYPAL_TILE_CLICKABLE}           xpath=//android.widget.TextView[@text='PayPal']/parent::*
${PAYPAL_AGREE_BUTTON}             xpath=//*[@text='Agree' or @content-desc='Agree' or @content-desc='agree']
${PAYPAL_CONSENT_SCREEN}           xpath=//*[@text='Agree' or @text='Disagree' or @content-desc='Agree' or @content-desc='Disagree' or @content-desc='agree' or @content-desc='disagree']
${PAYPAL_ACCESS_BUTTON}            xpath=//android.widget.Button[@content-desc='accessPayPal']
${PAYPAL_LINK_ACCOUNT_BUTTON}      xpath=//*[@text='Link account' or @text='Link Account' or @content-desc='Link account' or @content-desc='Link Account' or contains(@content-desc,'linkAccount') or contains(@content-desc,'link account')]
${PAYPAL_TERMS_MARKER}             xpath=//*[contains(@text,'Terms') or contains(@text,'terms') or contains(@content-desc,'Terms')]
${PAYPAL_EMAIL_INPUT}              xpath=//android.widget.EditText[contains(@text,'mail') or contains(@hint,'mail') or contains(@text,'Email') or contains(@hint,'Email') or contains(@content-desc,'mail') or contains(@content-desc,'Email')] | //android.widget.EditText[1]
${PAYPAL_CONTINUE_BUTTON}          xpath=//*[self::android.widget.Button or self::android.widget.TextView][@text='Continue' or @content-desc='Continue' or @content-desc='continue']
${PAYPAL_VERIFY_EMAIL_POPUP}       xpath=//*[contains(@text,'Verify') or contains(@text,'verification') or contains(@text,'Verification') or contains(@text,'verify email') or contains(@text,'Verify email') or contains(@content-desc,'Verify') or contains(@content-desc,'verification')]

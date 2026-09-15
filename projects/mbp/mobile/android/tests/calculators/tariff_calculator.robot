*** Settings ***
Documentation     Tariff Calculator tests, one per transaction type the calculator offers
Library           AppiumLibrary

Resource          ../../resources/Keywords/common.robot
Resource          ../../resources/Keywords/login.robot
Resource          ../../resources/Keywords/tariff.robot
Resource          ../../resources/variables/test_data.robot

Suite Setup       Open Mobile Application    ${APP_PACKAGE}    ${APP_ACTIVITY}    ${DEVICE_NAME}    ${PLATFORM_NAME}    ${PLATFORM_VERSION}
Suite Teardown    Close Mobile Application
Test Setup        Ensure Tariff Calculator Is Open
Test Teardown     Take Screenshot On Failure
Test Template     Tariff Should Be Quoted For


*** Test Cases ***                              TRANSACTION TYPE
Tariff For Sending To Airtel Money              Send to Airtel Money
    [Tags]    smoke    calculator    tariff    mobile-money    positive    AdoTestCaseId=255944

Tariff For Sending To M-Pesa                    Send to M-Pesa
    [Tags]    calculator    tariff    mobile-money    positive    AdoTestCaseId=255946

Tariff For Sending To T-Kash                    Send to T-Kash
    [Tags]    calculator    tariff    mobile-money    positive    AdoTestCaseId=255948

Tariff For Sending To Vooma                     Send to Vooma
    [Tags]    calculator    tariff    mobile-money    positive    AdoTestCaseId=255945

Tariff For A PAPSS Transfer                     PAPSS
    [Tags]    calculator    tariff    bank-transfer    positive    AdoTestCaseId=255947

Tariff For A Pesalink Transfer                  Pesalink
    [Tags]    calculator    tariff    bank-transfer    positive    AdoTestCaseId=255948

Tariff For An RTGS Transfer                     RTGS
    [Tags]    calculator    tariff    bank-transfer    positive    AdoTestCaseId=255949

Tariff For A KCB Internal Transfer              KCB Internal Transfer
    [Tags]    calculator    tariff    bank-transfer    positive

Tariff For Vooma Buy Goods                      Vooma Buy Goods
    [Tags]    calculator    tariff    vooma    positive

Tariff For A Vooma Pay Bill                     Vooma Pay Bill
    [Tags]    calculator    tariff    vooma    positive

Tariff For M-Pesa Buy Goods                     M-Pesa Buy Goods
    [Tags]    calculator    tariff    mpesa    positive

Tariff For An M-Pesa Pay Bill                   M-Pesa Pay Bill
    [Tags]    calculator    tariff    mpesa    positive


Tariff Calculator Quotes Nothing Until An Amount Is Entered
    [Documentation]    Verify picking a transaction type alone quotes no charge, so a
    ...                customer is never shown a cost for an amount they have not given.
    [Tags]    calculator    tariff    negative    AdoTestCaseId=255949
    [Setup]      Open A Fresh Tariff Calculator
    [Template]    NONE
    Select Transaction Type    ${TARIFF_TRANSACTION_TYPE}
    Verify No Transaction Charge Is Quoted


Tariff Grows With The Amount Being Sent
    [Documentation]    Verify a larger transfer is never cheaper than a smaller one on
    ...                the same transaction type.
    [Tags]    calculator    tariff    positive    AdoTestCaseId=255947
    [Template]    NONE

    Select Transaction Type    ${TARIFF_TRANSACTION_TYPE}
    Enter Tariff Amount    ${TARIFF_AMOUNT}    ${TARIFF_AMOUNT_ON_FORM}
    ${small}=    Verify Transaction Charge Is Quoted
    Enter Tariff Amount    ${TARIFF_HIGHER_AMOUNT}    ${TARIFF_HIGHER_AMOUNT_ON_FORM}
    ${large}=    Verify Transaction Charge Is Quoted
    Should Be True    ${large} >= ${small}
    ...    msg=KES ${TARIFF_HIGHER_AMOUNT} costs KES ${large}, less than KES ${TARIFF_AMOUNT} at KES ${small}
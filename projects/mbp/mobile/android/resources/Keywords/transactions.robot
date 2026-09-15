*** Settings ***
Documentation    Keywords for recent mobile transactions on Home
Library          AppiumLibrary
Resource         ../locators/transactions_locators.robot
Resource         ../locators/login_locators.robot


*** Keywords ***
Open Recent Mobile Transactions
    [Documentation]    From Home mid-section, open Recent Mobile Transactions View All.
    ...                Must land on Transactions, not Notifications.

    Wait Until Element Is Visible    ${MOBILE_DASHBOARD_HOME}    timeout=20s
    Click Element    ${MOBILE_DASHBOARD_HOME}

    ${found}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${RECENT_TRANSACTIONS_TITLE}
    IF    not ${found}
        Swipe    start_x=540    start_y=1300    end_x=540    end_y=800    duration=200ms
        ${found}=    Run Keyword And Return Status
        ...        Page Should Contain Element    ${RECENT_TRANSACTIONS_TITLE}
        IF    not ${found}
            Swipe    start_x=540    start_y=1300    end_x=540    end_y=800    duration=200ms
        END
    END

    Wait Until Element Is Visible    ${RECENT_TRANSACTIONS_TITLE}    timeout=10s
    Wait Until Element Is Visible    ${RECENT_TRANSACTIONS_VIEW_ALL}    timeout=5s
    Click Element    ${RECENT_TRANSACTIONS_VIEW_ALL}

    ${on_notifications}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${NOTIFICATIONS_TITLE}
    IF    ${on_notifications}
        Fail    Opened Notifications instead of Recent Mobile Transactions
    END
    Wait Until Element Is Visible    ${TRANSACTIONS_SCREEN_TITLE}    timeout=12s


Open First Successful Recent Transaction
    [Documentation]    Open a Successful transaction row from the transactions list.

    ${found}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${TRANSACTIONS_SUCCESS_ROW}
    IF    not ${found}
        FOR    ${i}    IN RANGE    3
            Swipe    start_x=540    start_y=1500    end_x=540    end_y=900    duration=200ms
            ${found}=    Run Keyword And Return Status
            ...    Page Should Contain Element    ${TRANSACTIONS_SUCCESS_ROW}
            IF    ${found}    BREAK
        END
    END
    Wait Until Element Is Visible    ${TRANSACTIONS_SUCCESS_ROW}    timeout=8s
    Click Element    ${TRANSACTIONS_SUCCESS_ROW}
    Wait Until Element Is Visible    ${TRANSACTION_STATUS_LABEL}    timeout=12s


Verify Successful Transaction Details Are Shown
    [Documentation]    Confirm detail screen shows Successful status and MBP reference.

    Wait Until Element Is Visible    ${TRANSACTION_STATUS_SUCCESS}    timeout=8s
    Wait Until Element Is Visible    ${TRANSACTION_MBP_REFERENCE}    timeout=5s


View Transfer Receipt
    [Documentation]    View receipt if present; otherwise leave detail with reference visible.

    ${has_receipt}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${TRANSACTION_RECEIPT}
    IF    not ${has_receipt}
        Swipe    start_x=540    start_y=1500    end_x=540    end_y=900    duration=200ms
        ${has_receipt}=    Run Keyword And Return Status
        ...    Page Should Contain Element    ${TRANSACTION_RECEIPT}
    END
    IF    ${has_receipt}
        Click Element    ${TRANSACTION_RECEIPT}
        Wait Until Page Contains    Receipt    timeout=8s
    END


Verify Transfer Receipt Is Visible
    [Documentation]    Confirm receipt or MBP reference is visible for viewing.

    ${has_receipt}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${TRANSACTION_RECEIPT}
    IF    ${has_receipt}
        Element Should Be Visible    ${TRANSACTION_RECEIPT}
    ELSE
        Element Should Be Visible    ${TRANSACTION_MBP_REFERENCE}
    END

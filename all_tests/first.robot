*** Settings ***
Library    Browser
Library    DateTime

*** Test Cases ***
First Test First File
    [Tags]    INTEGRATION
    New Browser    chromium
    New Page    https://2ip.ua/ru/
    Log     First Test First File
    ${current_time}    Get Current Date    result_format=%H:%M:%S:%f    # Формат времени, который вы хотите
    Log    ${current_time}
#    ${ms}=    Evaluate    int(round(time.time() * 1000))    time
#    Should Be True    ${ms} > ${ms_global}
#    Set Global Variable    ${ms_global}    ${ms}
#    Log    ${ms}

Second Test First File
    [Tags]    PREPROD
    Log    Second Test First File
    ${current_time}    Get Current Date    result_format=%H:%M:%S:%f    # Формат времени, который вы хотите
    Log    ${current_time}
#    ${ms}=    Evaluate    int(round(time.time() * 1000))    time
#    Should Be True    ${ms} > ${ms_global}
#    Set Global Variable    ${ms_global}    ${ms}
#    Log    ${ms}
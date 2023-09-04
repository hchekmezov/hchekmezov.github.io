*** Settings ***
Library    Browser
Library    DateTime

*** Test Cases ***
First Test Second File
    [Tags]    PREPROD
    Log     First Test First File
    ${current_time}    Get Current Date    result_format=%H:%M:%S:%f    # Формат времени, который вы хотите
    Log    ${current_time}
#    ${ms}=    Evaluate    int(round(time.time() * 1000))    time
#    Should Be True    ${ms} > ${ms_global}
#    Set Global Variable    ${ms_global}    ${ms}
#    Log    ${ms}

Second Test Second File
    [Tags]    INTEGRATION
    FOR    ${tag}    IN    @{TEST_TAGS}
    Log    tag: ${tag}
    END
    Log    Second Test First File
    ${current_time}    Get Current Date    result_format=%H:%M:%S:%f    # Формат времени, который вы хотите
    Log    ${current_time}
#    ${ms}=    Evaluate    int(round(time.time() * 1000))    time
#    Should Be True    ${ms} > ${ms_global}
#    Set Global Variable    ${ms_global}    ${ms}
#    Log    ${ms}

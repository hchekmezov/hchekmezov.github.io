*** Settings ***
Library    Collections
Library    DateTime

Suite Setup    Setup Firstly
Suite Teardown    Setup Final


*** Keywords ***
Setup Firstly
    Log    ${OPTIONS.include}
    @{lower_includes}    Create List
    FOR    ${element}    IN    @{OPTIONS.include}
        Append To List    ${lower_includes}    ${element.lower()}
    END
    ${integration}    Set Variable    integration
    ${preprod}    Set Variable    preprod
    ${is_integration}    Run Keyword And Return Status    Should Contain    ${lower_includes}    ${integration}
    ${is_preprod}    Run Keyword And Return Status    Should Contain    ${lower_includes}    ${preprod}
    IF    ${is_integration}
        Set Global Variable    ${CURENV}    ${integration}
        Log    Integration
    ELSE IF    ${is_preprod}
        Set Global Variable    ${CURENV}    ${preprod}
        Log    PREPROD
    END
    ${current_time}    Get Current Date    result_format=%H:%M:%S:%f    # Формат времени, который вы хотите
    Log    ${current_time}
#    ${ms}=    Evaluate    int(round(time.time() * 1000))    time
#    Set Global Variable    ${ms_global}    ${ms}
#    Log    ${ms}

Setup Final
    Log    Setup Final
    ${ms}=    Evaluate    int(round(time.time() * 1000))    time
    Log    ${CURENV}
    ${current_time}    Get Current Date    result_format=%H:%M:%S:%f    # Формат времени, который вы хотите
    Log    ${current_time}
#    Should Be True    ${ms} > ${ms_global}
#    Set Global Variable    ${ms_global}    ${ms}
#    Log    ${ms}
*** Settings ***

Library    Browser


*** Variables ***
${url}    https://www.developermail.com/mail/
${xpath_mail}    //a[contains(text(), '@')]
${id_refresh}    mailbox-refresh
${xpath_verify_email}    //div[contains(text(), 'gleeebka')]/following-sibling::div/a[@id='link-1']

#${xpath_verify_email_link}    //p[@title='Verify email']/..//following-sibling::div//a


*** Keywords ***
METHOD: Get The Mail Address
    New Browser    chromium    headless=false
    New Page    ${url}
    Sleep    1
    ${email_text}    Get Text    ${xpath_mail}
    ${email_text_stripped}    Set Variable    ${email_text.strip()}
    FOR    ${i}    IN RANGE    5
        Click    id=${id_refresh}
        Sleep    1
        ${is_needed_email_received}    Run Keyword And Return Status    Get Element    ${xpath_verify_email}
        IF    ${is_needed_email_received}
            Click    ${xpath_verify_email}
            BREAK
        END
    END
    Run Keyword If    '${is_needed_email_received}' == '${False}'    Fail    msg=Needed message is not received!
#        Click    ${xpath_verify_email}
#    ${confirmation_link}    Get Property    ${xpath_verify_email_link}    href
#    New Page    ${confirmation_link}
    Close Browser

METHOD: Temporary Method
    Set Global Variable    ${global_hiha}    prosto_tak
    Set Global Variable    ${global_hahi}    HAHI

*** Test Cases ***
Temporary
    METHOD: Temporary Method
    ${variables}    Get Variables
    ${is_temp_email_defined}    Run Keyword And Return Status    Should Be True    "\${global_hiha}" in $variables
    ${is_temp_pass_defined}    Run Keyword And Return Status    Should Be True    "\${global_hahi}" in $variables
    IF    ${is_temp_email_defined} and ${is_temp_pass_defined}
         Set Global Variable    ${is_temp_email_defined}    ${None}
         Set Global Variable    ${is_temp_pass_defined}    ${None}
    END

    IF    ${is_temp_pass_defined} != ${None} or ${is_temp_email_defined} == ${None}
        Log   Hurray!!
    END

#    Log    ${is_temp_email_defined}
#    Log    ${is_temp_pass_defined}


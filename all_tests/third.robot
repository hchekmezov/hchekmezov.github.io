*** Settings ***
Library    Browser
Library    OperatingSystem
Library    String
Library    ../scripts.py
Library    Collections
Library    DateTime

#Suite Setup        Suite Setup Action

*** Variables ***
#${BROWSER_TYPE}    chromium
#${HEAD_MODE}    false
${USERNAME}    username
${link_herokuapp}    https://the-internet.herokuapp.com
${link_download}    https://the-internet.herokuapp.com/download
${link_basic_auth}    https://admin:admin@the-internet.herokuapp.com/basic_auth
${link_drag_and_drop}    https://the-internet.herokuapp.com/drag_and_drop
${link_dropdown}    https://the-internet.herokuapp.com/dropdown
${link_exit_intent}    https://the-internet.herokuapp.com/exit_intent
${link_login}    https://the-internet.herokuapp.com/login
${link_nested_frames}    https://the-internet.herokuapp.com/nested_frames
${link_iframes}    https://the-internet.herokuapp.com/iframe
${link_geolocation}    https://the-internet.herokuapp.com/geolocation
${link_horizontal_slider}    https://the-internet.herokuapp.com/horizontal_slider
${link_hovers}    https://the-internet.herokuapp.com/hovers
${link_alerts}    https://the-internet.herokuapp.com/javascript_alerts
${link_key_presses}    https://the-internet.herokuapp.com/key_presses
${link_multiple_windows}    https://the-internet.herokuapp.com/windows
${link_secure_file_download}    https://the-internet.herokuapp.com/download_secure
${link_shadowdom}    https://the-internet.herokuapp.com/shadowdom
${link_shifting_content}    https://the-internet.herokuapp.com/shifting_content

${another_demo_link_for_learning}    https://demoqa.com
${demo_link_books_store}    https://demoqa.com/books
${demo_link_checkbox}    https://demoqa.com/checkbox
${demo_automation_practice_form}    https://demoqa.com/automation-practice-form
${demo_link_buttons}    https://demoqa.com/buttons
${demo_link_select}    https://demoqa.com/select-menu
${demo_link_sortable}    https://demoqa.com/sortable
${demo_link_droppable}    https://demoqa.com/droppable
${demo_link_progress_bar}    https://demoqa.com/progress-bar
${demo_link_browser_windows}    https://demoqa.com/browser-windows
${demo_link_webtables}    https://demoqa.com/webtables
${test_link_tables}    https://testrigor.com/samples/table1/

*** Keywords ***
Suite Setup Action
    Set Log Level    INFO

*** Test Cases ***
Test Download With Promise
    [Tags]    TEST-1
    New Browser    browser=${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_download}
    Wait For Elements State    //h3    visible    timeout=5s
    ${download_promise}    Promise To Wait For Download
    ${txt_files}    Get Elements    //a[contains(@href, '.txt')]
    Click    ${txt_files}[0]
    ${file_obj}=    Wait For    ${download_promise}
    ${absolute_file_path}    Get Parent Directory    ${file_obj}[saveAs]
    ${new_file_location}    Set Variable    ${CURDIR}/${file_obj}[suggestedFilename]
    Move File    ${file_obj}[saveAs]    ${new_file_location}
    File Should Exist    ${new_file_location}
    Remove File    ${new_file_location}
    File Should Not Exist    ${new_file_location}
    Close Browser    ALL

Test Download With Download Keyword
    [Tags]    TEST-2
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_download}
    Wait For Elements State    //h3    visible    timeout=5s
    ${txt_files}    Get Elements    //a[contains(@href, '.txt')]
    ${href}    Get Property    ${txt_files}[0]    href
    Log    info-message
#    can not be saved with the same name as on the website
    Download    ${href}    saveAs=${CURDIR}/downloads/downloaded_file.txt
    File Should Exist    ${CURDIR}/downloads/downloaded_file.txt
    Remove File    ${CURDIR}/downloads/downloaded_file.txt
    File Should Not Exist    ${CURDIR}/downloads/downloaded_file.txt
    Remove Directory    ${CURDIR}/downloads
    Directory Should Not Exist    ${CURDIR}/downloads
    Close Browser    ALL

Test Basic Auth
    [Tags]    TEST-3
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    Set Log Level    WARN
    New Page    ${link_basic_auth}
    Wait For Elements State      //p[contains(text(), 'Congratulations! You must have the proper credentials.')]    timeout=2s
    Set Log Level    INFO
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL
    
Test Drag And Drop
    [Tags]    TEST-4
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_drag_and_drop}
    Wait For Elements State    //h3    visible    timeout=2s
    FOR    ${i}    IN RANGE    0    5
        Sleep    0.15s
        Take Screenshot    EMBED
        Drag And Drop    id=column-a    id=column-b
        Sleep    0.15s
        Take Screenshot    EMBED
    END
    Close Browser    ALL

Test Dropdown
    [Tags]    TEST-5
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_dropdown}
    Wait For Elements State    //h3    visible    timeout=2s
    Select Options By    id=dropdown    text    Option 1
    ${select_options}    Get Select Options    id=dropdown
    ${selected_options}    Get Selected Options    id=dropdown
    Log    ${select_options}
    Log    ${selected_options}
    ${selected_options_length}    Get Length    ${selected_options}
    Should Be Equal As Integers    ${selected_options_length}    ${1}
    Should Contain    ${selected_options}    Option 1
    Sleep    0.3s
    Take Screenshot    EMBED
    Deselect Options    id=dropdown
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Exit Intent
    [Tags]    TEST-6
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_exit_intent}
    Wait For Elements State    //h3[contains(text(), 'Exit Intent')]    visible    timeout=2s
    Mouse Move Relative To    //h3[contains(text(), 'Exit Intent')]
    Mouse Move    0    -50
    Wait For Elements State    //h3[contains(text(), 'This is a modal window')]    visible    timeout=2s
    Sleep    0.3s
    Take Screenshot    EMBED
    Click    //p[contains(text(), 'Close')]
    Wait For Elements State    //h3[contains(text(), 'This is a modal window')]    hidden    timeout=2s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Login 1 - NEGATIVE login with USERNAME
    [Tags]    TEST-7
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_login}
    Wait For Elements State    //h2[contains(text(), 'Login Page')]    visible    timeout=2s
    Sleep    0.15s
    Take Screenshot    EMBED
    Type Text    id=username    wrongUsername
    Sleep    0.15s
    Take Screenshot    EMBED
    Click    //button[@type='submit']
    Wait For Elements State    //*[@id='flash' and contains(@class, 'error')]    visible    timeout=5s
    ${flash_message}    Get Text    //*[@id='flash' and contains(@class, 'error')]
    Should Contain    ${flash_message.strip()}    Your username is invalid!
    Sleep    0.15s
    Take Screenshot    EMBED
#   closing the alert
    Focus    //*[@id='flash' and contains(@class, 'error')]/a
    Keyboard Key    press    Enter
    Wait For Elements State    //*[@id='flash' and contains(@class, 'error')]    detached    timeout=5s
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Login 2 - NEGATIVE login with PASSWORD
    [Tags]    TEST-8
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_login}
    Wait For Elements State    //h2[contains(text(), 'Login Page')]    visible    timeout=2s
    Sleep    0.15s
    Take Screenshot    EMBED
    Type Text    id=password    wrongPassword
    Sleep    0.15s
    Take Screenshot    EMBED
    Click    //button[@type='submit']
    Wait For Elements State    //*[@id='flash' and contains(@class, 'error')]    visible    timeout=5s
    ${flash_message}    Get Text    //*[@id='flash' and contains(@class, 'error')]
    Should Contain    ${flash_message.strip()}    Your username is invalid!
    Sleep    0.15s
    Take Screenshot    EMBED
#   closing the alert
    Focus    //*[@id='flash' and contains(@class, 'error')]/a
    Keyboard Key    press    Enter
    Wait For Elements State    //*[@id='flash' and contains(@class, 'error')]    detached    timeout=5s
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL
    
Test Login 3 - POSITIVE
    [Tags]    TEST-9
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_login}
    Wait For Elements State    //h2[contains(text(), 'Login Page')]    visible    timeout=2s
    Sleep    0.15s
    Take Screenshot    EMBED
    ${username}    Get Text    (//h4/em)[1]
    ${password}    Get Text    (//h4/em)[2]
    Type Text    id=username    ${username}
    Type Text    id=password    ${password}
    Sleep    0.15s
    Take Screenshot    EMBED
    Click    //button[@type='submit']
    Wait For Elements State   //h4[contains(text(), 'Welcome to the Secure Area. When you are done click logout below.')]
    ...    visible    timeout=5s
    Wait For Elements State    //*[@id='flash' and contains(@class, 'success')]    visible    timeout=5s
    ${flash_message}    Get Text    //*[@id='flash' and contains(@class, 'success')]
    Should Contain    ${flash_message.strip()}    You logged into a secure area!
    Sleep    0.15s
    Take Screenshot    EMBED
#   closing the alert
    Focus    //*[@id='flash' and contains(@class, 'success')]/a
    Keyboard Key    press    Enter
    Wait For Elements State    //*[@id='flash' and contains(@class, 'success')]    detached    timeout=5s
    Sleep    0.15s
    Take Screenshot    EMBED
    Click    //a[contains(@href, 'logout')]
    Wait For Elements State    //h2[contains(text(), 'Login Page')]    visible    timeout=2s
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Nested Frames
    [Tags]    TEST-10
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_nested_frames}
    Wait For Elements State    //frame[@name='frame-top'] >>> //frame[@name='frame-left'] >>> //body[contains(text(), 'LEFT')]
    ...    visible    timeout=2s
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test IFrames
    [Tags]    TEST-11
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_iframes}
    Wait For Elements State    //iframe    visible    timeout=2s
    Sleep    0.15s
    Take Screenshot    EMBED
    Click    //iframe >>> //p
    ${text}    Get Text    //iframe >>> //p
    ${len_text}    Get Length    ${text}
    Keyboard Key    down     Shift
    FOR    ${i}    IN RANGE    0    ${len_text}
        Keyboard Key    press    ArrowLeft
    END
    Keyboard Key    press    Delete
    Keyboard Key    up       Shift
    Keyboard Input    insertText    my test text
#    type text keyword does not work
    Sleep    0.15s
    Take Screenshot    EMBED
    ${cur_text}    Get Text    //iframe >>> //p
    Should Contain    ${cur_text}    my test text
    Close Browser    ALL

Test Geolocation
    [Tags]    TEST-12
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    ${permissions}    Create List    geolocation
    New Context    viewport=${None}    acceptDownloads=true    permissions=${permissions}
    New Page    ${link_geolocation}
    Wait For Elements State    //h3    visible    timeout=5s
    Set Geolocation    60.173708    24.982263    3    # Points to Korkeasaari in Helsinki.
    Click    //button
    Wait For Elements State    id=lat-value    visible    timeout=5s
    ${latitude}    Get Text    id=lat-value
    ${longtitude}    Get Text    id=long-value
    Sleep    0.15s
    Take Screenshot    EMBED
    Should Be Equal As Strings    ${latitude}    60.173708
    Should Be Equal As Strings    ${longtitude}    24.982263
    Close Browser    ALL

Test Horizontal Slider
    [Tags]    TEST-13
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_horizontal_slider}
    Wait For Elements State    //h3    visible    timeout=5s
    Focus    //input
    FOR    ${i}    IN RANGE    0    4
        Keyboard Key    press    ArrowRight
    END
    ${value}    Get Text    id=range
    Sleep    1
    Take Screenshot    EMBED
    Should Be Equal As Integers    ${value}    2
    Close Browser    ALL

Test Hovers
    [Tags]    TEST-14
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_hovers}
    Wait For Elements State    //h3    visible    timeout=5s
    Wait For Elements State    //h5[contains(text(), 'user1')]    hidden    timeout=1s
    Wait For Elements State    //h5[contains(text(), 'user2')]    hidden    timeout=1s
    Wait For Elements State    //h5[contains(text(), 'user2')]    hidden    timeout=1s
    Hover    //div[@class='figure'][1]
    Wait For Elements State    //h5[contains(text(), 'user1')]    visible    timeout=1s
    Sleep    0.3s
    Take Screenshot    EMBED
    Hover    //div[@class='figure'][2]
    Wait For Elements State    //h5[contains(text(), 'user2')]    visible    timeout=1s
    Sleep    0.3s
    Take Screenshot    EMBED
    Hover    //div[@class='figure'][3]
    Wait For Elements State    //h5[contains(text(), 'user3')]    visible    timeout=1s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Alerts ONE
    [Tags]    TEST-15    ALERTS
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_alerts}
    Wait For Elements State    //h3    visible    timeout=5s
    ${promise}    Promise To    Wait For Alert    action=accept
    Click    //li/button[contains(text(), 'Alert')]
    ${text}    Wait For      ${promise}
    Log    ${text}
    ${result}    Get Text    id=result
    Should Contain    ${result}    You successfully clicked an alert
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Alerts TWO
    [Tags]    TEST-16    ALERTS
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_alerts}
    Wait For Elements State    //h3    visible    timeout=5s
    Handle Future Dialogs    action=accept
    Click    //li/button[contains(text(), 'Alert')]
    ${result}    Get Text    id=result
    Should Contain    ${result}    You successfully clicked an alert
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Confirm ONE
    [Tags]    TEST-17
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_alerts}
    Wait For Elements State    //h3    visible    timeout=5s
    ${promise}    Promise To    Wait For Alert    action=accept
    Click    //li/button[contains(text(), 'Confirm')]
    ${text}    Wait For      ${promise}
    Log    ${text}
    ${result}    Get Text    id=result
    Should Contain    ${result}    You clicked: Ok
    Sleep    0.15s
    Take Screenshot    EMBED
    ${promise}    Promise To    Wait For Alert    action=dismiss
    Click    //li/button[contains(text(), 'Confirm')]
    ${text}    Wait For      ${promise}
    Log    ${text}
    ${result}    Get Text    id=result
    Should Contain    ${result}    You clicked: Cancel
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Confirm TWO
    [Tags]    TEST-18
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_alerts}
    Wait For Elements State    //h3    visible    timeout=5s
    Handle Future Dialogs    action=dismiss
    Click    //li/button[contains(text(), 'Confirm')]
    ${result}    Get Text    id=result
    Should Contain    ${result}    You clicked: Cancel

#    dialog.accept: Cannot accept dialog which is already handled!

#    Sleep    0.15s
#    Take Screenshot    EMBED
#    Handle Future Dialogs    action=accept
#    Click    //li/button[contains(text(), 'Confirm')]
#    ${result}    Get Text    id=result
#    Should Contain    ${result}    You clicked: Ok
#    Sleep    0.15s
#    Take Screenshot    EMBED
    Close Browser    ALL

Test Prompt ONE
    [Tags]    TEST-19
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_alerts}
    Wait For Elements State    //h3    visible    timeout=5s
    ${promise}    Promise To    Wait For Alert    action=accept    prompt_input=my accept text
    Click    //li/button[contains(text(), 'Prompt')]
    ${text}    Wait For      ${promise}
    Log    ${text}
    ${result}    Get Text    id=result
    Should Contain    ${result}    You entered: my accept text
    Sleep    0.15s
    Take Screenshot    EMBED
    ${promise}    Promise To    Wait For Alert    action=dismiss    prompt_input=my dismiss text
    Click    //li/button[contains(text(), 'Prompt')]
    ${text}    Wait For      ${promise}
    Log    ${text}
    ${result}    Get Text    id=result
    Should Contain    ${result}    You entered: null
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Prompt TWO
    [Tags]    TEST-20
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_alerts}
    Wait For Elements State    //h3    visible    timeout=5s
    Handle Future Dialogs    action=accept    prompt_input=my accept text
    Click    //li/button[contains(text(), 'Prompt')]
    ${result}    Get Text    id=result
    Should Contain    ${result}    You entered: my accept text
    Sleep    0.15s
    Take Screenshot    EMBED

#    prompt_input is only valid if action is 'accept'

#    Handle Future Dialogs    action=dismiss    prompt_input=my dismiss text
#    Click    //li/button[contains(text(), 'Prompt')]
#    ${result}    Get Text    id=result
#    Should Contain    ${result}    You entered: null
#    Sleep    0.15s
#    Take Screenshot    EMBED
    Close Browser    ALL

Test Key Presses
    [Tags]    TEST-21
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_key_presses}
    Wait For Elements State    //h3    visible    timeout=5s
    Click    id=target
    Keyboard Key    press    h
    Wait For Condition    Text    id=result    contains    You entered: H
    Keyboard Key    press    E
    Wait For Condition    Text    id=result    contains    You entered: E
    Keyboard Key    press    l
    Wait For Condition    Text    id=result    contains    You entered: L
    Keyboard Key    press    l
    Wait For Condition    Text    id=result    contains    You entered: L
    Keyboard Key    press    O
    Wait For Condition    Text    id=result    contains    You entered: O
    Keyboard Key    press    Space
    Wait For Condition    Text    id=result    contains    You entered: SPACE
    Keyboard Key    press    w
    Wait For Condition    Text    id=result    contains    You entered: W
    Keyboard Key    press    O
    Wait For Condition    Text    id=result    contains    You entered: O
    Keyboard Key    press    r
    Wait For Condition    Text    id=result    contains    You entered: R
    Keyboard Key    press    L
    Wait For Condition    Text    id=result    contains    You entered: L
    Keyboard Key    press    d
    Wait For Condition    Text    id=result    contains    You entered: D
    Keyboard Key    down    Shift
    Keyboard Key    press    Digit1
    Keyboard Key    up    Shift
    Sleep    0.3s
    Take Screenshot    EMBED
    ${entered_value}    Get Property    id=target    value
    Should Contain    ${entered_value}    hEllO wOrLd!
    Close Browser    ALL

Test Multiple Windows
    [Tags]    TEST-22
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_multiple_windows}
    Wait For Elements State    //h3    visible    timeout=5s
    Click    //a[@href='/windows/new']
    Sleep    0.3s
    Take Screenshot    EMBED

    ${current_context_id}    Get Context Ids    ACTIVE    ACTIVE
    ${current_context_id}    Set Variable    ${current_context_id}[0]
    ${current_browser_id}    Get Browser Ids    ACTIVE
    ${current_browser_id}    Set Variable    ${current_browser_id}[0]

    ${browser_catalog}    Get Browser Catalog
    
    ${new_page_id}    Get Page Id By Url Part    ${browser_catalog}    ${current_browser_id}    ${current_context_id}
    ...    /windows/new
    ${is_browser_switched}    Run Keyword And Return Status    Switch Browser    ${current_browser_id}
    ${is_context_switched}    Run Keyword And Return Status    Switch Context    ${current_context_id}
    ${is_page_switched}    Run Keyword And Return Status    Switch Page    ${new_page_id}
    Wait For Elements State    //h3[contains(text(), 'New Window')]    visible    timeout=3s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

#    25.01

Test Secure File Download
    [Tags]    TEST-23
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    ${log_level}    Set Log Level    WARN
    ${splitted_link}    Set Variable    ${link_secure_file_download.split("//")}
    New Page    ${splitted_link}[0]//${USERNAME_SECURE}:${PASSWORD_SECURE}@${splitted_link}[1]
    Wait For Elements State    //h3    visible    timeout=3s
    Go To    ${link_secure_file_download}
    Wait For Elements State    //h3    visible    timeout=3s
    Set Log Level    ${log_level}
    ${cur_link}    Get Url
    Log    ${cur_link}
    Wait For Elements State    //h3    visible    timeout=5s
    ${download_promise}    Promise To Wait For Download
#    ${txt_files}    Get Elements    //a[contains(@href, '.txt')]
#    Click    ${txt_files}[0]
    Click    (//a[contains(@href, '.txt')])[1]
    ${file_obj}=    Wait For    ${download_promise}
    ${absolute_file_path}    Get Parent Directory    ${file_obj}[saveAs]
    ${new_file_location}    Set Variable    ${CURDIR}/${file_obj}[suggestedFilename]
    Move File    ${file_obj}[saveAs]    ${new_file_location}
    File Should Exist    ${new_file_location}
    ${contents}    Get File    ${new_file_location}
    @{lines}    Split To Lines    ${contents}
    ${result_text}    Set Variable    ${EMPTY}
    FOR    ${line}    IN    @{lines}
        ${result_text}    Set Variable    ${result_text}\n${line}
    END
    Remove File    ${new_file_location}
    File Should Not Exist    ${new_file_location}
    Log    ${result_text}
    Close Browser    ALL

Test Secure Shadowdom
    [Tags]    TEST-24
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_shadowdom}
    Wait For Elements State    //h1    visible    timeout=3s

    ${elem}    Get Element    div#content > my-paragraph >> nth=0
    ${text}    Get Text    ${elem}
    Should Contain    ${text}    Let's have some different text!

    ${elem}    Get Element    div#content > my-paragraph >> nth=1
    ${text}    Get Text    ${elem}
    Should Contain    ${text}    Let's have some different text!\nIn a list!
    
#    ${elem}    Get Text    css=p >> nth=0 >> slot

#    ${paragraphs_p_elem}    Get Elements    css=p
#    ${paragraphs_slot_elem}    Create List
#    ${len}    Get Length    ${paragraphs_p_elem}
#    FOR    ${i}    IN RANGE    0    ${len}
#        ${slot}    Get Element    ${paragraphs_p_elem}[${i}] >> slot
#        Append To List    ${paragraphs_slot_elem}    ${slot}
#    END
#    Log    ${paragraphs_slot_elem}
    Close Browser    ALL

Test Shifting Content Menu Element
    [Tags]    TEST-25
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_shifting_content}
    Wait For Elements State    //h3    visible    timeout=3s
    Click    //a[@href='/shifting_content/menu']

    ${current_context_id}    Get Context Ids    ACTIVE    ACTIVE
    ${current_context_id}    Set Variable    ${current_context_id}[0]
    ${current_browser_id}    Get Browser Ids    ACTIVE
    ${current_browser_id}    Set Variable    ${current_browser_id}[0]
    ${browser_catalog}    Get Browser Catalog
    ${menu_page_id}    Get Page Id By Url Part    ${browser_catalog}    ${current_browser_id}    ${current_context_id}
    ...    /shifting_content/menu
    ${is_browser_switched}    Run Keyword And Return Status    Switch Browser    ${current_browser_id}
    ${is_context_switched}    Run Keyword And Return Status    Switch Context    ${current_context_id}
    ${is_page_switched}    Run Keyword And Return Status    Switch Page    ${menu_page_id}
    Wait For Elements State    //h3[contains(text(), 'Shifting Content: Menu Element')]    visible    timeout=3s
    Sleep    0.3s
    Take Screenshot    EMBED
    Click    //a[@href='/shifting_content/menu?pixel_shift=100']
#    Cannot click
#    Click    //a[@href='/portfolio/']
    Focus    //a[@href='/portfolio/']
    Keyboard Key    press    Enter
    ${current_context_id}    Get Context Ids    ACTIVE    ACTIVE
    ${current_context_id}    Set Variable    ${current_context_id}[0]
    ${current_browser_id}    Get Browser Ids    ACTIVE
    ${current_browser_id}    Set Variable    ${current_browser_id}[0]
    ${browser_catalog}    Get Browser Catalog
    ${portfolio_page_id}    Get Page Id By Url Part    ${browser_catalog}    ${current_browser_id}    ${current_context_id}
    ...    /portfolio/
    ${is_browser_switched}    Run Keyword And Return Status    Switch Browser    ${current_browser_id}
    ${is_context_switched}    Run Keyword And Return Status    Switch Context    ${current_context_id}
    ${is_page_switched}    Run Keyword And Return Status    Switch Page    ${portfolio_page_id}
    Sleep    0.3s
    Take Screenshot    EMBED
    ${cur_url}    Get Url
    Should Contain    ${cur_url}    https://the-internet.herokuapp.com/portfolio/
    Close Browser    ALL


Test Books Store 1
    [Tags]    TEST-26    DEMO    BOOKS
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_books_store}
    Wait For Elements State    //h1[contains(text(), 'Book Store')]    visible    timeout=5s
    Scroll To Element    (//a[contains(@href, '/books')])[1]
    Sleep    0.5s
    Take Screenshot    EMBED
    Add Style Tag    a[href] { color: #000000; background-color: #FFFF00; }
    Sleep    0.5s
    Take Screenshot    EMBED
    Scroll To Element    //span[@class='text' and contains(text(), 'Login')]
    Sleep    0.5s
    Take Screenshot    EMBED
    Add Style Tag    span.text { color: #0000ff; }
    Sleep    0.5s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Cookies
    [Tags]    TEST-27    DEMO    BOOKS
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_books_store}
    Wait For Elements State    //h1[contains(text(), 'Book Store')]    visible    timeout=5s
    ${date}    Get Current Date    increment=15 secs
    Add Cookie    hlib    chekmezov    domain=example.com    path=/foo/bar    expires=${date}
    ${cookies}    Get Cookies
    Log    ${cookies}
    ${is_cookie_exist}    Is Cookie Exist By Name    ${cookies}    hlib
    Should Be True    ${is_cookie_exist}
    Sleep    15
#    in firefox fox for some reason temporary cookie is not deleted after time
    IF    '${BROWSER_TYPE}' == 'firefox'
        Delete All Cookies
    END
    ${cookies}    Get Cookies
    Log    ${cookies}
    ${is_cookie_exist}    Is Cookie Exist By Name    ${cookies}    hlib
    Should Not Be True    ${is_cookie_exist}
    Close Browser    ALL

Test Checkbox
    [Tags]    TEST-28    DEMO
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_checkbox}
    Wait For Elements State    //h1[contains(text(), 'Check Box')]    visible    timeout=5s
    Scroll To Element    //span[@class='rct-title' and contains(text(), 'Home')]
    Sleep    0.3s
    Take Screenshot    EMBED
    ${home_checkbox}    Get Element    //span[@class='rct-title' and contains(text(), 'Home')]/preceding-sibling::input
    ${is_home_checked}    Get Checkbox State    ${home_checkbox}
    Should Not Be True    ${is_home_checked}
    ${home_toggle}    Get Element    //span[@class='rct-title' and contains(text(), 'Home')]/../preceding-sibling::button
    Click    ${home_toggle}
    Sleep    0.3s
    Take Screenshot    EMBED
    ${desktop_checkbox}    Get Element    //span[@class='rct-title' and contains(text(), 'Desktop')]/preceding-sibling::input
    ${is_desktop_checked}    Get Checkbox State    ${desktop_checkbox}
    Should Not Be True    ${is_desktop_checked}
    ${desktop_toggle}    Get Element    //span[@class='rct-title' and contains(text(), 'Desktop')]/../preceding-sibling::button
    Click    ${desktop_toggle}
    Sleep    0.3s
    Take Screenshot    EMBED
    ${commands_checkbox}    Get Element    //span[@class='rct-title' and contains(text(), 'Commands')]/preceding-sibling::input
    ${is_commands_checked}    Get Checkbox State    ${commands_checkbox}
    Should Not Be True    ${is_commands_checked}
    Check Checkbox    //span[@class='rct-title' and contains(text(), 'Commands')]/preceding-sibling::span[@class='rct-checkbox']
    Sleep    0.3s
    Take Screenshot    EMBED
    ${is_commands_checked}    Get Checkbox State    ${commands_checkbox}
    Should Be True    ${is_commands_checked}
    ${is_desktop_checked}    Get Checkbox State    ${desktop_checkbox}
    Should Not Be True    ${is_desktop_checked}
    ${is_home_checked}    Get Checkbox State    ${home_checkbox}
    Should Not Be True    ${is_home_checked}
    ${result}    Get Text    css=\#result
    Should Contain    ${result}    You have selected :\ncommands
    Uncheck Checkbox    //span[@class='rct-title' and contains(text(), 'Commands')]/preceding-sibling::span[@class='rct-checkbox']
    Sleep    0.3s
    Take Screenshot    EMBED
    ${is_commands_checked}    Get Checkbox State    ${commands_checkbox}
    Should Not Be True    ${is_commands_checked}
    Wait For Elements State    id=result    detached    timeout=5s
    Close Browser    ALL


Test Permissions DEMO
    [Tags]    TEST-29    DEMO
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    Grant Permissions    geolocation    notifications
    New Page    ${demo_automation_practice_form}
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]    visible    timeout=4s

    ${js_command}    Create Javascript Command For Permission Status    geolocation
    ${result}    Evaluate Javascript    ${None}    ${js_command}
    ${is_failed}    Run Keyword And Return Status    Should Contain    ${result}    Error
    Run Keyword If    ${is_failed}    Fail    msg=Some Error Occured:\n ${result}
    Should Be Equal As Strings    granted    ${result}

#    does not work for Firefox
#    ${js_command}    Create Javascript Command For Permission Status    camera
#    ${result}    Evaluate Javascript    ${None}    ${js_command}
#    ${is_failed}    Run Keyword And Return Status    Should Contain    ${result}    Error
#    Run Keyword If    ${is_failed}    Fail    msg=Some Error Occured:\n ${result}
#    Should Be Equal As Strings    denied    ${result}

    ${js_command}    Create Javascript Command For Permission Status    notifications
    ${result}    Evaluate Javascript    ${None}    ${js_command}
    ${is_failed}    Run Keyword And Return Status    Should Contain    ${result}    Error
    Run Keyword If    ${is_failed}    Fail    msg=Some Error Occured:\n ${result}
    Should Be Equal As Strings    granted    ${result}

    Clear Permissions

    ${js_command}    Create Javascript Command For Permission Status    geolocation
    ${result}    Evaluate Javascript    ${None}    ${js_command}
    ${is_failed}    Run Keyword And Return Status    Should Contain    ${result}    Error
    Run Keyword If    ${is_failed}    Fail    msg=Some Error Occured:\n ${result}
    Should Be Equal As Strings    prompt    ${result}

    ${js_command}    Create Javascript Command For Permission Status    notifications
    ${result}    Evaluate Javascript    ${None}    ${js_command}
    ${is_failed}    Run Keyword And Return Status    Should Contain    ${result}    Error
    Run Keyword If    ${is_failed}    Fail    msg=Some Error Occured:\n ${result}
    Should Be Equal As Strings    prompt    ${result}

    Close Browser    ALL

Test Clear Text
    [Tags]    TEST-30    DEMO
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_automation_practice_form}
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]    visible    timeout=4s
    ${name}    Get Text    id=firstName
    Should Be Equal As Strings    ${EMPTY}    ${name}
    Sleep    0.3s
    Take Screenshot    EMBED
    Type Text    id=firstName    Hlib4ik
    ${name}    Get Text    id=firstName
    Should Be Equal As Strings    Hlib4ik    ${name}
    Sleep    0.3s
    Take Screenshot    EMBED
    Clear Text    id=firstName
    ${name}    Get Text    id=firstName
    Should Be Equal As Strings    ${EMPTY}    ${name}
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Buttons
    [Tags]    TEST-31    DEMO
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_buttons}
    Wait For Elements State    //h1[contains(text(), 'Buttons')]    visible    timeout=5s
    Click With Options    id=doubleClickBtn    clickCount=2
    Wait For Condition    Text    id=doubleClickMessage    contains    You have done a double click
    Sleep    0.3s
    Take Screenshot    EMBED
    Click    id=rightClickBtn    button=right
    Wait For Condition    Text    id=rightClickMessage    contains    You have done a right click
    Sleep    0.3s
    Take Screenshot    EMBED
    Click    (//button[contains(text(), 'Click Me')])[3]
    Wait For Condition    Text    id=dynamicClickMessage    contains    You have done a dynamic click
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Close Context
    [Tags]    TEST-32
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_buttons}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State    
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Buttons')]    visible    timeout=5s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Context    CURRENT    CURRENT
    New Context    acceptDownloads=true
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]    visible    timeout=4s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Close Page 1
    [Tags]    TEST-33
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_buttons}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Buttons')]    visible    timeout=5s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Page    CURRENT    CURRENT    CURRENT
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]    visible    timeout=4s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Close Page 2
    [Tags]    TEST-34
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_buttons}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Buttons')]    visible    timeout=5s
    Sleep    0.3s
    Take Screenshot    EMBED
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]    visible    timeout=4s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Page    CURRENT    CURRENT    CURRENT
    Sleep    1.5s
    New Page    ${demo_link_checkbox}
    Wait For Elements State    //h1[contains(text(), 'Check Box')]    visible    timeout=5s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test Close Page 3
    [Tags]    TEST-35
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_buttons}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Buttons')]    visible    timeout=5s
    Sleep    0.3s
    Take Screenshot    EMBED
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]    visible    timeout=4s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Page    ALL    ALL    ALL
    Sleep    1.5s
    New Page    ${demo_link_checkbox}
    Wait For Elements State    //h1[contains(text(), 'Check Box')]    visible    timeout=5s
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL
    
Test Browser Server
    [Tags]    TEST-36
    Log    here should be Launch Browser Server, but in Github Actions it does not work    level=WARN
#    ${browser_server}    Launch Browser Server    headless=false
#    Sleep    1
#    Connect To Browser    ${browser_server}
#    Sleep    1
#    Close Browser Server    ${browser_server}
    
Test Crawl Site
    [Tags]    TEST-37
    Crawl Site    ${link_herokuapp}    max_number_of_page_to_crawl=20
    Delete All Cookies

Test Select Options 1
    [Tags]    TEST-38
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_select}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Select Menu')]    visible    timeout=5s
    Sleep    0.3s
    Take Screenshot    EMBED
    Scroll To Element    id=oldSelectMenu
    Mouse Wheel    0    75
    Deselect Options    id=oldSelectMenu
    Sleep    0.3s
    Take Screenshot    EMBED
    Take Screenshot    EMBED    id=oldSelectMenu
    Select Options By    id=oldSelectMenu    text    Indigo
    Sleep    0.3s
    Take Screenshot    EMBED    id=oldSelectMenu
    Take Screenshot    EMBED
    Close Browser    ALL

Test Select Options 2
    [Tags]    TEST-39
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_select}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Select Menu')]    visible    timeout=5s
    Scroll To Element    id=cars
    Mouse Wheel    0    75
    Sleep    0.3s
    Take Screenshot    EMBED
    Take Screenshot    EMBED    id=cars
    Select Options By    id=cars    value    volvo    opel    audi
    Scroll To Element    id=cars
    Mouse Wheel    0    75
    Sleep    0.3s
    Take Screenshot    EMBED
    Take Screenshot    EMBED    id=cars
    Deselect Options    id=cars
    Scroll To Element    id=cars
    Mouse Wheel    0    75
    Sleep    0.3s
    Take Screenshot    EMBED    id=cars
    Close Browser    ALL

Test Eat All Cookies
    [Tags]    TEST-40
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_select}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Eat All Cookies
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Select Menu')]    visible    timeout=5s
    Close Browser    ALL

Test Drag And Drop Relative To - LIST
    [Tags]    TEST-41
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_sortable}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //div[@aria-hidden='false']//div[contains(text(), 'One')]    timeout=5s
    ${offsetTopOne}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'One')]    offsetTop
    ${offsetLeftOne}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'One')]    offsetLeft
    ${offsetTopFive}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'Five')]    offsetTop
    ${offsetLeftFive}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'Five')]    offsetLeft
    ${differenceTop}    Evaluate    ${offsetTopFive} - ${offsetTopOne}
    ${differenceLeft}    Evaluate    ${offsetLeftFive} - ${offsetLeftOne}
    Take Screenshot    EMBED

    ${elems}    Get Elements    //div[contains(@class, "vertical-list-container")]/div
    ${text_before}    Create List
    FOR    ${elem}    IN   @{elems}
        ${txt}    Get Text    ${elem}
        Append To List    ${text_before}    ${txt}
    END
    ${should_be_before}    Create List    One    Two    Three    Four    Five    Six
    Should Be Equal    ${text_before}    ${should_be_before}

    Drag And Drop Relative To    //div[@aria-hidden='false']//div[contains(text(), 'One')]    ${differenceLeft}
    ...    ${differenceTop}
    Sleep    0.4s
    Take Screenshot    EMBED

    ${elems}    Get Elements    //div[contains(@class, "vertical-list-container")]/div
    ${text_after}    Create List
    FOR    ${elem}    IN   @{elems}
        ${txt}    Get Text    ${elem}
        Append To List    ${text_after}    ${txt}
    END
    ${should_be_after}    Create List    Two    Three    Four    Five    One    Six
    Should Be Equal    ${text_after}    ${should_be_after}
    Close Browser    ALL

Test Drag And Drop Relative To - GRID
    [Tags]    TEST-42
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_sortable}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    id=demo-tab-grid    visible    timeout=3s
    Click    id=demo-tab-grid
    Wait For Elements State    //div[@aria-hidden='false']//div[contains(text(), 'One')]    timeout=5s
    ${offsetTopOne}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'One')]    offsetTop
    ${offsetLeftOne}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'One')]    offsetLeft
    ${offsetTopFive}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'Five')]    offsetTop
    ${offsetLeftFive}    Get Property    //div[@aria-hidden='false']//div[contains(text(), 'Five')]    offsetLeft
    ${differenceTop}    Evaluate    ${offsetTopFive} - ${offsetTopOne}
    ${differenceLeft}    Evaluate    ${offsetLeftFive} - ${offsetLeftOne}
    Take Screenshot    EMBED

    ${elems}    Get Elements    //div[@class="create-grid"]/div
    ${text_before}    Create List
    FOR    ${elem}    IN   @{elems}
        ${txt}    Get Text    ${elem}
        Append To List    ${text_before}    ${txt}
    END
    ${should_be_before}    Create List    One    Two    Three    Four    Five    Six    Seven    Eight    Nine
    Should Be Equal    ${text_before}    ${should_be_before}

    Drag And Drop Relative To    //div[@aria-hidden='false']//div[contains(text(), 'One')]    ${differenceLeft}
    ...    ${differenceTop}
    Sleep    0.4s
    Take Screenshot    EMBED

    ${elems}    Get Elements    //div[@class="create-grid"]/div
    ${text_after}    Create List
    FOR    ${elem}    IN   @{elems}
        ${txt}    Get Text    ${elem}
        Append To List    ${text_after}    ${txt}
    END
    ${should_be_after}    Create List    Two    Three    Four    Five    One    Six    Seven    Eight    Nine
    Should Be Equal    ${text_after}    ${should_be_after}
    Close Browser    ALL

Test Drag And Drop To Greedy
    [Tags]    TEST-43
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_droppable}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    id=droppableExample-tab-preventPropogation    timeout=5s
    Click    id=droppableExample-tab-preventPropogation
    ${offsetTopOuter}    Get Property    id=notGreedyDropBox    offsetTop
    ${offsetLeftOuter}    Get Property    id=notGreedyDropBox    offsetLeft
    ${offsetTopDragMe}    Get Property    id=dragBox    offsetTop
    ${offsetLeftDragMe}    Get Property    id=dragBox    offsetLeft
    ${differenceTop}    Evaluate    ${offsetTopOuter} - ${offsetTopDragMe}
    ${differenceLeft}    Evaluate    ${offsetLeftOuter} - ${offsetLeftDragMe}
    Drag And Drop Relative To    id=dragBox    ${differenceLeft}    ${differenceTop}
    Sleep    0.3s
    Take Screenshot    EMBED
    ${result_txt}    Get Text    //div[@id='notGreedyDropBox']/p
    Should Contain    ${result_txt}    Dropped!
    ${result_txt}    Get Text    //div[@id='notGreedyInnerDropBox']/p
    Should Contain    ${result_txt}    Inner droppable (not greedy)

    ${offsetTopOuter}    Get Property    id=notGreedyInnerDropBox    offsetTop
    ${offsetLeftOuter}    Get Property    id=notGreedyInnerDropBox    offsetLeft
    ${offsetTopDragMe}    Get Property    id=dragBox    offsetTop
    ${offsetLeftDragMe}    Get Property    id=dragBox    offsetLeft
    ${differenceTop}    Evaluate    ${offsetTopOuter} - ${offsetTopDragMe}
    ${differenceLeft}    Evaluate    ${offsetLeftOuter} - ${offsetLeftDragMe}
    Drag And Drop Relative To    id=dragBox    ${differenceLeft}    ${differenceTop}
    Sleep    0.3s
    Take Screenshot    EMBED
    ${result_txt}    Get Text    //div[@id='notGreedyDropBox']/p
    Should Contain    ${result_txt}    Dropped!
    ${result_txt}    Get Text    //div[@id='notGreedyInnerDropBox']/p
    Should Contain    ${result_txt}    Dropped!
    Close Browser    ALL

Test Fill Secret
    [Tags]    TEST-44
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]    timeout=5s
    Fill Secret    id=firstName    $username
    Scroll To Element    id=firstName
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL
   
Test Get Attribute
    [Tags]    TEST-45
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    ${value_min}    Get Attribute    //div[@id="progressBar"]/div    aria-valuemin
    ${value_max}    Get Attribute    //div[@id="progressBar"]/div    aria-valuemax
    Should Be Equal As Integers    ${value_min}    ${0}
    Should Be Equal As Integers    ${value_max}    ${100}
    Click    id=startStopButton
    Sleep    1.37s
    Click    id=startStopButton
    ${value_now}    Get Attribute    //div[@id="progressBar"]/div    aria-valuenow
    ${cur_text}    Get Text    //div[@id="progressBar"]/div
    Should Not Be Equal As Integers    ${value_now}    ${0}
    Should Contain    ${cur_text}    ${value_now}
    Close Browser    ALL

Test Get Attribute Names
    [Tags]    TEST-46
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    Click    id=startStopButton
    Sleep    1.37s
    Click    id=startStopButton
    ${attribute_names}    Get Attribute Names    //div[@id="progressBar"]/div
    Log    ${attribute_names}
    Close Browser    ALL

Test Bounding Box
    [Tags]    TEST-47
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_droppable}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Droppable')]
    ${bounding_box}    Get Boundingbox    //div[@id='droppableExample-tabpane-simple']//*[@id='droppable']
    Log    ${bounding_box}
    Close Browser    ALL

Test Get Classes
    [Tags]    TEST-48
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    Click    id=startStopButton
    Sleep    1.37s
    Click    id=startStopButton
    ${classes}    Get Classes    //div[@id="progressBar"]/div
    Log    ${classes}
    Close Browser    ALL

Test Get Client Size
    [Tags]    TEST-49
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    ${page_client_size}    Get Client Size
    Log    ${page_client_size}
    ${size_of_elem}    Get Client Size    id=startStopButton
    Log    ${size_of_elem}
    Close Browser    ALL

Test Get Console Log
    [Tags]    TEST-50
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    ${console_log}    Get Console Log
    Log    ${console_log}
    Close Browser    ALL

Test Get Device
    [Tags]    TEST-51
    ${device}=    Get Device       iPhone X
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    &{device}
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    ${viewport_size}    Get Viewport Size
    Should Be Equal As Integers    ${375}    ${viewport_size}[width]
    Should Be Equal As Integers    ${812}    ${viewport_size}[height]
    Sleep    0.4s
    Take Screenshot    EMBED
    Close Browser    ALL
    
Test Get Devices
    [Tags]    TEST-52
    ${possible_devices}    Get Devices
    Log    ${possible_devices}

Test Get Element By
    [Tags]    TEST-53
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    ${elem_start}    Get Element By    Text    Start
    Click    ${elem_start}
    Sleep    2.36s
    ${elem_stop}    Get Element By    Text    Stop
    Click    ${elem_stop}
    ${value_now}    Get Attribute    //div[@id="progressBar"]/div    aria-valuenow
    Should Not Be Equal As Integers    ${value_now}    ${0}
    Close Browser    ALL

Test Get Element By Role
    [Tags]    TEST-54
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_progress_bar}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Progress Bar')]
    ...    visible    timeout=5 s
    ${elem_start}    Get Element By Role    button    name=/start/i
    Click    ${elem_start}
    Sleep    2.36s
    ${elem_stop}    Get Element By Role    button    name=/stop/i
    Click    ${elem_stop}
    ${value_now}    Get Attribute    //div[@id="progressBar"]/div    aria-valuenow
    Should Not Be Equal As Integers    ${value_now}    ${0}
    Close Browser    ALL

Test Get Element Count
    [Tags]    TEST-55
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    Get Element Count    //button    >=    3
    Close Browser    ALL

Test Get Element States
    [Tags]    TEST-56
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${states}    Get Element States    id=tabButton
    Log    ${states}
    Should Contain    ${states}    defocused
    Should Not Contain    ${states}    focused
    Focus    id=tabButton
    Sleep    0.9s
    ${states}    Get Element States    id=tabButton
    Log    ${states}
    Should Contain    ${states}    focused
    Should Not Contain    ${states}    defocused
    Close Browser    ALL
    
Test Get Elements
    [Tags]    TEST-57
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${btns}    Get Elements    //button
    FOR    ${btn}    IN    @{btns}
        ${states}    Get Element States    ${btn}
        ${is_visible}    Run Keyword And Return Status    Should Contain    ${states}    visible
        Run Keyword If    ${is_visible}    Click    ${btn}
    END
    Sleep    0.4s
    ${browser_catalog}    Get Browser Catalog
    Log    ${browser_catalog}
    Close Browser    ALL

Test Get Page Errors
    [Tags]    TEST-58
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${btns}    Get Elements    //button
    FOR    ${btn}    IN    @{btns}
        ${states}    Get Element States    ${btn}
        ${is_visible}    Run Keyword And Return Status    Should Contain    ${states}    visible
        Run Keyword If    ${is_visible}    Click    ${btn}
    END
    Sleep    0.336s
    ${page_errors}    Get Page Errors
    Log    ${page_errors}
    Close Browser    ALL

Test Get Page Ids
    [Tags]    TEST-59
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${btns}    Get Elements    //button
    FOR    ${btn}    IN    @{btns}
        ${states}    Get Element States    ${btn}
        ${is_visible}    Run Keyword And Return Status    Should Contain    ${states}    visible
        Run Keyword If    ${is_visible}    Click    ${btn}
    END
    Sleep    0.336s
    ${page_ids}    Get Page Ids
    Log    ${page_ids}
    Close Browser    ALL
    
Test Get Page Source
    [Tags]    TEST-60
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${html}    Get Page Source
    Log    ${html}
    Close Browser    ALL
    
Test Get Property
    [Tags]    TEST-61
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${innerText}    Get Property    id=windowButton    innerText
    Log    ${innerText}
    Should Be Equal As Strings    ${innerText}    New Window
    Close Browser    ALL
    
Test Get Scroll Position
    [Tags]    TEST-62
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${scroll_pos}    Get Scroll Position
    Log    ${scroll_pos}
    ${scroll_pos_elem}    Get Scroll Position    id=messageWindowButton
    Log    ${scroll_pos_elem}
    Close Browser    ALL
    
Test Get Scroll Size
    [Tags]    TEST-63
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${scroll_pos}    Get Scroll Size
    Log    ${scroll_pos}
    ${scroll_pos_elem}    Get Scroll Size    id=messageWindowButton
    Log    ${scroll_pos_elem}
    Close Browser    ALL

Test Get Style
    [Tags]    TEST-64
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_browser_windows}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Browser Windows')]
    ...    visible    timeout=5 s
    ${style}    Get Style    id=messageWindowButton
    Log    ${style}
    Close Browser    ALL

Test Get Table Cell Element
    [Tags]    TEST-65
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${test_link_tables}
    Wait For Elements State    //h1[contains(text(), 'Sample Table')]    timeout=3 s
    ${table}=    Set Variable    //table/thead/..
    Scroll To Element    ${table}
    ${e}=    Get Table Cell Element    ${table}    "Name"    "york1"
    ${txt}    Get Text    ${e}
    Log    ${txt}
    Should Be Equal As Strings    Yorktown    ${txt}
    ${table_cell_index}    Get Table Cell Index    ${table} >> "Name"
    ${table_row_index}    Get Table Row Index    ${table} >> "Spock"
    ${e}=    Get Table Cell Element    ${table}    ${table_cell_index}    ${table_row_index}
    ${txt}    Get Text    ${e}
    Log    ${txt}
    Should Be Equal As Strings    Spock    ${txt}
    Close Browser    ALL

Test Get Title
    [Tags]    TEST-66
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_webtables}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Web Tables')]
    ...    visible    timeout=5 s
    ${title}    Get Title
    Log    ${title}
    Close Browser    ALL

Test Get Url
    [Tags]    TEST-67
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_webtables}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Web Tables')]
    ...    visible    timeout=5 s
    ${cur_url}    Get Url
    Should Be Equal As Strings    ${cur_url}    ${demo_link_webtables}
    Close Browser    ALL

Test Get Viewport Size
    [Tags]    TEST-68
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_webtables}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Web Tables')]
    ...    visible    timeout=5 s
    ${viewport_size}    Get Viewport Size
    Log    ${viewport_size}
    Close Browser    ALL

Test Go Back / Go Forward / Go To
    [Tags]    TEST-69
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    ${google_link}    Set Variable    https://www.google.com/
    New Page    ${google_link}
    Sleep    0.3s
    Take Screenshot    EMBED
    ${cur_url}    Get Url
    Should Be Equal As Strings    ${google_link}    ${cur_url}
    ${is_accept_cookies}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/div[contains(text(), 'Accept all')]/..    visible    timeout=3 s
    Run Keyword If    ${is_accept_cookies}    Click    //button/div[contains(text(), 'Accept all')]/..
    Go To    ${demo_link_webtables}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Web Tables')]
    ...    visible    timeout=5 s
    Sleep    0.3s
    Take Screenshot    EMBED
    ${cur_url}    Get Url
    Should Be Equal As Strings    ${cur_url}    ${demo_link_webtables}
    Go Back
    Sleep    0.3s
    Take Screenshot    EMBED
    ${cur_url}    Get Url
    Should Be Equal As Strings    ${cur_url}    ${google_link}
    Go Forward
    Sleep    0.3s
    Take Screenshot    EMBED
    ${cur_url}    Get Url
    Should Be Equal As Strings    ${cur_url}    ${demo_link_webtables}
    Close Browser    ALL

Test Highlight Elements
    [Tags]    TEST-70
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]
    ...    visible    timeout=5 s
    Scroll To Element    id=firstName
    Log    Highlight Elements keyword does not work properly!    level=WARN
    Highlight Elements    id=firstName
    Close Browser    ALL

Test Keyboard Input
    [Tags]    TEST-71
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]
    ...    visible    timeout=5 s
    Scroll To Element    id=firstName
    Click    id=firstName
    Keyboard Input    insertText    glepchik
    Click    id=lastName
    Keyboard Input    type    mezov
    Sleep    0.3s
    Take Screenshot    EMBED
    Close Browser    ALL

Test LocalStorage
    [Tags]    TEST-72
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_automation_practice_form}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Practice Form')]
    ...    visible    timeout=5 s
    Local Storage Set Item    localKey    localValue
    Sleep    1
    ${value}    Local Storage Get Item    localKey
    Should Be Equal As Strings    ${value}    localValue
    Local Storage Remove Item    localKey
    Sleep    1
    ${item}=    Local Storage Get Item    localKey
    Should Be Equal    ${item}    ${None}
    Local Storage Set Item    newLocalKey    newLocalValue
    Sleep    1
    ${value}    Local Storage Get Item    newLocalKey
    Should Be Equal As Strings    ${value}    newLocalValue
    Local Storage Clear    
    Sleep    1
    ${item}=    Local Storage Get Item    newLocalKey
    Should Be Equal    ${item}    ${None}
    Close Browser

Test Mouse Button
    [Tags]    TEST-73
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${demo_link_buttons}
    ${is_consent}    Run Keyword And Return Status    Wait For Elements State
    ...    //button/p[contains(text(), 'Consent')]/..    timeout=1.5s
    Run Keyword If    ${is_consent}    Click    //button/p[contains(text(), 'Consent')]/..
    Wait For Elements State    //h1[contains(text(), 'Buttons')]
    ...    visible    timeout=5 s
    Mouse Move Relative To    (//button[contains(text(), 'Click Me')])[3]
    Sleep    1
    Mouse Button    action=click    clickCount=2    delay=20 ms
    Wait For Elements State    id=dynamicClickMessage    visible    timeout=5 s
    Close Browser    ALL

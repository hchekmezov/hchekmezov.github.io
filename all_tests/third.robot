*** Settings ***
Library    Browser
Library    OperatingSystem
Library    ../scripts.py

#Suite Setup        Suite Setup Action

*** Variables ***
#${BROWSER_TYPE}    chromium
#${HEAD_MODE}    false
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

*** Keywords ***
Suite Setup Action
    Set Log Level    INFO

*** Test Cases ***
Test Download With Promise
    [Tags]    TEST-1
    New Browser    browser=${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
    New Context    viewport=${None}    acceptDownloads=true
    New Page    ${link_nested_frames}
    Wait For Elements State    //frame[@name='frame-top'] >>> //frame[@name='frame-left'] >>> //body[contains(text(), 'LEFT')]
    ...    visible    timeout=2s
    Sleep    0.15s
    Take Screenshot    EMBED
    Close Browser    ALL

Test IFrames
    [Tags]    TEST-11
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    Should Be Equal As Strings    ${cur_text}    my test text
    Close Browser    ALL

Test Geolocation
    [Tags]    TEST-12
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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
    New Browser    ${BROWSER_TYPE}    headless=${HEAD_MODE}    downloadsPath=.    args=["-start-maximized"]
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

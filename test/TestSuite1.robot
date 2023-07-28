*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    RequestsLibrary
Library  JSONLibrary

Suite Setup    Log  I am inside Test Suite Setup
Suite Teardown    Log    I am inside Test Suite Teardown
Test Setup    Log    I am inside Test Setup
Test Teardown    Log   I am inside Test Teardown

*** Keywords ***
LoginKW
    Input Text                         name=username                                           ${CREDENTIALS_ORANGE}[0]
    Input Password                     name=password                                     ${LOGIN_DATA_ORANGE}[password]
    Click Button               //button[@class='oxd-button oxd-button--medium oxd-button--main orangehrm-login-button']

Parse Price
    [Arguments]        ${price_text}
    ${price_string}    Remove String    ${price_text}    ₴
    ${price_without_space}    Remove String    ${price_string}    ${SPACE}
    ${price}    Convert To Integer    ${price_without_space}
    [Return]        ${price}

List Should Be Sorted In Ascending Order
    [Arguments]    @{list}
    @{sorted_list}      Create List
    @{sorted_list}      Copy List    ${list}
    Log     ${list}
    Sort List    ${sorted_list}
    Log         ${sorted_list}
    Lists Should Be Equal    ${list}    ${sorted_list}


# *** Keywords ***
# we have LIBRARY and USER keywords

# Test Case Set Up – run before every Test Case
# Test Case Tear Down – run after every Test Case
# Test Suite Set Up – run before Test Suite
# Test Suite Tear Down – run after Test Suite

*** Variables ***
${PRODUCT}         TP-LINK
${CHROME}          chrome
${SOLVD}           Solvd Inc
${URL_BING}        https://www.bing.com/
${URL_ORANGE}      https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
${URL_ROZETKA}     https://rozetka.com.ua/ua
${POST_URL}        https://jsonplaceholder.typicode.com
${GET_URL}         https://catfact.ninja
@{CREDENTIALS_ORANGE}  Admin   admin123
&{LOGIN_DATA_ORANGE}   username=Admin  password=admin123

# robot has
# - scalar *** Variables ***       -> simple variables: ${variable_name}
# - list *** Variables ***         -> @{variable_name}<|tab|>item1<|tab|>item2...
#                                  ... для вывода всего листа пишем @{variable_name},
#                                  ... для вывода элемента ${variable_name}[index]
#                                  ... (в одном месте собака, в другом – доллар)
#                                  ... (https://docs.robotframework.org/docs/variables)
# - dictionary *** Variables ***   -> &{variable_name}<|tab|>K1=V1<|tab|>K2=V2...
#                                  ... правило как в предыдущем случае
# - environment *** Variables ***  -> built-in variables in environment
# - built-in *** Variables ***     -> https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide
#                                  ... .html#built-in-variables

*** Test Cases ***
MyFirstTest
    Log     Hello World...

FirstSeleniumTest
    Open Browser    ${URL_BING}    ${CHROME}
    Set Browser Implicit Wait    5
    Input Text      name=q     ${SOLVD}
    Press Keys    name=q    ENTER
    Sleep    2
    Close Browser

SampleLoginTest
    [Documentation]    This is a sample login test
    Open Browser                       ${URL_ORANGE}      ${CHROME}
    Maximize Browser Window
    Wait Until Element Is Visible      name=username
    LoginKW
    Wait Until Element Is Visible   //*[@class='oxd-icon bi-caret-down-fill oxd-userdropdown-icon']
    Click Element              //*[@class='oxd-icon bi-caret-down-fill oxd-userdropdown-icon']
    Wait Until Element Is Visible   link=Logout
    Click Element              link=Logout  # локатор для текста
    Close Browser
    Log                        Test completed
    Log                        This test was executed by %{USER}
    Log                        This test named ${TEST NAME}



RozetkaSortTest
    [Documentation]    This is a Rozetka Sort Test
    Open Browser    ${URL_ROZETKA}  ${CHROME}
    Maximize Browser Window
    Input Text    name=search   ${PRODUCT}
    Press Keys    name=search   ENTER
    Wait Until Element Is Visible       //select/option[contains(@value, 'cheap')]
    Click Element    //select/option[contains(@value, 'cheap')]
    Wait Until Element Is Visible       //span[@class='goods-tile__price-value']
    Sleep    7
    @{prices}   Get Webelements    //span[@class='goods-tile__price-value']
    @{prices_texts}    Create List
    FOR    ${price}    IN    @{prices}
        ${text}    Get Text    ${price}
        Append To List    ${prices_texts}    ${text}
    END
    @{parced_prices}    Create List
    FOR    ${price}  IN   @{prices_texts}
        ${parsed_price}     Run Keyword     Parse Price    ${price}
        Append To List      ${parced_prices}    ${parsed_price}
    END
    List Should Be Sorted In Ascending Order    @{parced_prices}
    Close Browser

RozetkaSearchTest
    [Documentation]    This is a Sample Rozetka Search Test
    Open Browser    ${URL_ROZETKA}  ${CHROME}
    Maximize Browser Window
    Input Text    name=search   ${PRODUCT}
    Press Keys    name=search   ENTER
    Wait Until Element Is Visible       //span[@class='goods-tile__title']
    @{names}   Get Webelements    //span[@class='goods-tile__title']
    @{names_texts}    Create List
    FOR    ${name}    IN    @{names}
        ${text}    Get Text    ${name}
        Append To List    ${names_texts}    ${text}
    END
    FOR    ${string}    IN    @{names_texts}
        Should Contain      ${string}       ${PRODUCT}     ignore_case=True
    END
    Log     ${names_texts}


POST_API_Test
    [Documentation]    This is a POST API Test
    Create Session    mysession     ${POST_URL}    verify=true
    &{body}     Create Dictionary  title=just_a_title  body=jst_bd  userId=11345
    &{header}       Create Dictionary  Cache-Control=no-cache
    ${response}     POST On Session    mysession    /posts      data=${body}    headers=${header}
    Status Should Be    201     ${response}

    @{id}   Get Value From Json  ${response.json()}  id
    Log    ${id}[0]
    Should Be Equal As Strings    101   ${id}[0]


GET_API_Test
    [Documentation]     This is a GET API Test
    Create Session    mysession     ${GET_URL}       verify=true
    ${response}     GET On Session      mysession    /fact
    Status Should Be  200       ${response}

    @{fact_list}     Get Value From Json    ${response.json()}   fact
    ${fact}  Get From List   ${fact_list}   0
    @{length_list}  Get Value From Json    ${response.json()}   length
    ${length_string}    Get From List    ${length_list}     0
    ${length_from_json}   Convert To Integer    ${length_string}
    ${length_by_robot}      Get Length    ${fact}
    Should Be Equal As Integers     ${length_by_robot}      ${length_from_json}



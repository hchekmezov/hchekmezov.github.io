*** Settings ***
Library    Browser
Library    Collections
Library    String

Resource    uk_UA.resource
Resource    credentials.resource


*** Variables ***
${browser}      Chromium
${url}          https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
${expected_url}     https://opensource-demo.orangehrmlive.com/web/index.php/dashboard/index
${URL_ROZETKA}     https://rozetka.com.ua/ua
@{CREDENTIALS_ORANGE}  Admin   admin123
${PRODUCT}         TP-LINK
${get_order_button}     //*[@class='button button_size_large button_color_green cart-receipt__submit ng-star-inserted']

*** Keywords ***
Parse Price
    [Arguments]        ${string_price}
    ${string_price}    Remove String    ${string_price}    ₴
    ${string_price}    Remove String    ${string_price}    ${SPACE}
    ${price}    Convert To Integer    ${string_price}
    [Return]        ${price}

List Should Be Sorted In Ascending Order
    [Arguments]    @{list}
    @{sorted_list}      Create List
    @{sorted_list}      Copy List    ${list}
    Log     Unsorted list: ${list}
    Sort List    ${sorted_list}
    Log         Sorted list: ${sorted_list}
    Lists Should Be Equal    ${list}    ${sorted_list}



*** Test Cases ***
My First Test
    [Documentation]    This is my first Browser Test
    New Browser    browser=${browser}       headless=False
    New Page        ${url}
    Set Viewport Size       width=1500       height=900
    Type Text     //*[@name='username']       ${CREDENTIALS_ORANGE}[0]
    Type Secret     //*[@name='password']       $CREDENTIALS_ORANGE[1]
    Click       //button[@type='submit']
    Sleep    4
    ${current_url}=      Get Url
    Should Be Equal As Strings    ${current_url}    ${expected_url}
    Click     //*[@class='oxd-icon bi-caret-down-fill oxd-userdropdown-icon']
    Click     //*[contains(@href, 'logout')]
    ${current_url}=      Get Url
    Should Be Equal As Strings    ${current_url}    ${url}
    Close Browser


RozetkaSortTest
    [Documentation]    Rozetka Sort Test by Browser
    New Browser    browser=${browser}       headless=False
    New Page        ${URL_ROZETKA}
    Set Viewport Size       width=1500       height=900
    Type Text     //*[@name='search']     ${PRODUCT}
    Click        //*[@name='search']/../../following-sibling::button
    @{prices}=   Get Elements    //span[@class='goods-tile__price-value']
    Select Options By   //select      value     1: cheap
    Sleep    2
    @{string_prices}=    Create List
    FOR     ${price}    IN      @{prices}
        ${string_price}=     Get Text    ${price}
        Append To List      ${string_prices}    ${string_price}
    END
    @{parced_prices}=    Create List
    FOR    ${price}  IN   @{string_prices}
        ${parsed_price}=     Run Keyword     Parse Price    ${price}
        Append To List      ${parced_prices}    ${parsed_price}
    END
    List Should Be Sorted In Ascending Order    @{parced_prices}
    Close Browser

RozetkaAddToCartTest
    [Tags]    CART_TEST
    [Documentation]    AddToCart test implementation
    New Browser    browser=${browser}       headless=False
    New Page        ${URL_ROZETKA}
    Set Viewport Size       width=1500       height=900
    Type Text     //*[@name='search']     ${PRODUCT}
    Click        //*[@name='search']/../../following-sibling::button
    ${product_name}=    Get Element    (//*[@class='goods-tile__title'])[1]
    ${product_name}=    Get Text    ${product_name}
    ${product_price}=    Get Element    (//*[@class='goods-tile__price-value'])[1]
    ${product_price}=   Get Text    ${product_price}
    ${product_price}=    Run Keyword     Parse Price    ${product_price}
    Click       (//*[@class='goods-tile ng-star-inserted'])[1]
    ${product_page_name}=   Get Element    //*[@class='product__title']
    ${product_page_name}=   Get Text    ${product_page_name}
    ${product_page_price}=   Get Element    //*[@class='product-price__big product-price__big-color-red']
    ${product_page_price}=   Get Text    ${product_page_price}
    ${product_page_price}=   Run Keyword    Parse Price    ${product_page_price}
    Should Be Equal As Integers    ${product_page_price}    ${product_price}
    Should Be Equal As Strings    ${product_page_name}      ${product_name}
    Click       //button[@class='buy-button button button--with-icon button--green button--medium buy-button--tile ng-star-inserted']
    ${title_robot}=    Get Element        //h3[@class='modal__heading']
    ${title_robot}=    Get Text           ${title_robot}
    Should Contain      ${title_robot}      ${title_uk_ua}
    Get Element States  ${get_order_button}     contains        visible
    ${get_order_robot}=       Get Element    ${get_order_button}
    ${get_order_robot}=       Get Text    ${get_order_robot}
    Should Contain    ${get_order_robot}    ${get_order_uk_ua}
    ${cart_product_title}=      Get Element    //*[@class='cart-product__title']
    ${cart_product_title}=      Get Text    ${cart_product_title}
    ${cart_product_price}=      Get Element    //*[@class='cart-receipt__sum-price']/span
    ${cart_product_price}=      Get Text    ${cart_product_price}
    ${cart_product_price}=      Run Keyword    Parse Price    ${cart_product_price}
    Should Be Equal As Integers    ${cart_product_price}    ${product_page_price}
    Should Be Equal As Strings    ${cart_product_title}     ${product_page_name}
    Close Browser

RozetkaLoginTest
    [Tags]    LOGIN_TEST
    [Documentation]    Login test implementation
    New Browser    browser=${browser}       headless=False
    New Page        ${URL_ROZETKA}
    Set Viewport Size       width=1500       height=900
    Click                   //rz-user
    ${login_window_title}=      Get Element    //*[@class='modal__heading']
    ${login_window_title}=      Get Text       ${login_window_title}
    Should Contain      ${login_window_title}   ${login_window_title_uk_ua}
    Type Secret       id=auth_email       $phone_rozetka
    Type Secret       id=auth_pass        $password_rozetka
    Click       //button[contains(text(), '${login_window_enter_button_text_uk_ua}')]
    Sleep    4
    Wait For Condition    Element States      id=auth_email   contains      detached   timeout=200 s
    Wait For Condition      Element States    id=confirmPhoneCode       contains      detached   timeout=200 s
#    ${attr}=       Get Property    //app-root[@ng-server-context="ssr"]/..        className
#    Log        ${attr}
#    Wait For Condition    Property    //app-root[@ng-server-context="ssr"]/..   className   ==      timeout=5000s
    Focus    //rz-mobile-user-menu
    Click    //rz-mobile-user-menu
    Sleep   1
    ${logout_button}=       Get Element    //button[contains(text(), '${log_out_uk_ua}')]
    Close Browser

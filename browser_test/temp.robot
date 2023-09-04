*** Settings ***
Documentation       Portal Workbench – Home Page Object

Library    Browser
Library    String

Test Setup    Setting Up An English Variable

*** Variables ***
${pw_top_panel_english}    English
${pw_top_panel_deutsch}    Deutsch

${pw_top_panel_xpath_en_sign_in}    (//span[contains(text(), 'Sign In')])[1]/..
${pw_top_panel_xpath_de_sign_in}    (//span[contains(text(), 'Anmelden')])[1]/..
${pw_top_panel_xpath_actual_language}    (//button[@id='dropdownMenuButton'])[1]/span

${pw_top_panel_xpath_my_educ_opportunities}    //ul[contains(@id, 'SiteNavigationMenuPortlet_')]/preceding-sibling::div/a
${pw_top_panel_xpath_en_wallet_onboarding}    //a[contains(text(), 'Wallet Onboarding')]
${pw_top_panel_xpath_de_wallet_onboarding}    //a[contains(text(), 'Wallet Verbinden')]

*** Keywords ***
Setting Up An English Variable
    ${is_english_current}    Run Keyword And Return Status    Should Be Equal As Strings    English    English
    Set Test Variable    ${local_english_current}    ${is_english_current}

ReturningValue
    ${nmshd_start}=    Set Variable    nmshd://qr#
    ${raw_qr_link}    Set Variable    nmshd://qr#VE9LSDBqamp3VHZhTEVvUUthUXR8M3xCVGU5Nmw5X0RqX0hFb3R5eTY3bTZZQnc2SFdrekI4LVlVS2xmU1ZZQm9R
    ${clean_qr_link}    Replace String    ${raw_qr_link}    ${nmshd_start}    ${EMPTY}
    [Return]    ${clean_qr_link}


#[Portal Workbench - Top Panel] Open Sign In Page
#    ${is_english_current}    Run Keyword And Return Status    Should Be Equal As Strings    English    English
#    Set Test Variable    ${local_english_current}    ${is_english_current}

[Portal Workbench - Top Panel] Open Wallet Onboarding Page
    Log    ${local_english_current}

*** Test Cases ***
Temporary
     New Browser    chromium    headless=false
     New Page

*** Settings ***
Library    Browser
Library    DateTime

*** Test Cases ***
First Test First File
    [Tags]    INTEGRATION
    Log    mi electrik

Second Test First File
    [Tags]    PREPROD
    Fail    msg=mi ne electrik

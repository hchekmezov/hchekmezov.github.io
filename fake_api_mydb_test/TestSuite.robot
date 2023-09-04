*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary
Library    JSONLibrary
Library    ../fake_api_db_test/faker_using.py

Suite Setup    Create Session    session     http://localhost:3000
Suite Teardown    Delete All Sessions


*** Variables ***
${id_50}=   50
${id_100}=  100


*** Test Cases ***
UsersGetTest
    [Documentation]    This is a getting user info test
    [Tags]    USER_TEST
    ${response}=    GET On Session    session   /users/${id_50}
    Status Should Be    200     ${response}
    Log     ${response.json()}

UsersPostTest
    [Documentation]    This is a posting user info test
    [Tags]    USER_TEST
    ${user_name}=       GET FAKE NAME
    ${avatar}=          GET FAKE IMAGE URL
    &{data}=    Create Dictionary    user_name=${user_name}     avatar=${avatar}
    ${response}=    POST On Session    session      /users      json=${data}
    Status Should Be    201     ${response}

UsersPatchTest
    [Documentation]    This is a patching user test
    [Tags]    USER_TEST
    ${avatar}=      GET FAKE IMAGE URL
    &{data}=        Create Dictionary    avatar=${avatar}
    ${response}=    PATCH On Session    session     /users/${id_100}    json=${data}
    Status Should Be    200     ${response}

UsersPutTest
    [Documentation]    This is a putting user test
    [Tags]    USER_TEST
    ${avatar}=      GET FAKE IMAGE URL
    ${user_name}=   GET FAKE NAME
    &{data}=        Create Dictionary       user_name=${user_name}     avatar=${avatar}
    ${response}=        PUT On Session    session   /users/${id_100}    json=${data}
    Status Should Be    200     ${response}

UsersOptionsTest
    [Documentation]    This is a getting options user test
    [Tags]    USER_TEST
    ${response}=    OPTIONS On Session    session   /users
    Status Should Be    204     ${response}

UsersDeleteTest
    [Documentation]    This is a deleting user test
    [Tags]    USER_TEST
    ${response}=    DELETE On Session    session    /users/${id_100}
    Status Should Be    200     ${response}





CatsGetTest
    [Documentation]    This is a getting cat test
    [Tags]    CAT_TEST
    ${response}=    GET On Session      session     /cats/${id_50}
    Status Should Be    200     ${response}

CatsPostTest
    [Documentation]    This is a posting cat test
    [Tags]    CAT_TEST
    ${cat_name}=    GET FAKE NAME
    ${avatar}=      GET FAKE IMAGE URL
    &{data}=    Create Dictionary       cat_name=${cat_name}    avatar=${avatar}
    ${response}=    POST On Session    session      /cats       json=${data}
    Status Should Be    201     ${response}

CatsDeleteTest
    [Documentation]    This is a deleting cat test
    [Tags]    CAT_TEST
    ${response}=    DELETE On Session    session    /cats/${id_100}
    Status Should Be    200     ${response}



DogsGetTest
    [Documentation]    This is a getting dog test
    [Tags]    DOG_TEST
    ${response}=    GET On Session      session     /dogs/${id_50}
    Status Should Be    200     ${response}

DogsPostTest
    [Documentation]    This is a posting dog test
    [Tags]    DOG_TEST
    ${cat_name}=    GET FAKE NAME
    ${avatar}=      GET FAKE IMAGE URL
    &{data}=    Create Dictionary       dog_name=${cat_name}    avatar=${avatar}
    ${response}=    POST On Session    session      /dogs       json=${data}
    Status Should Be    201     ${response}

DogsDeleteTest
    [Documentation]    This is a deleting dog test
    [Tags]    DOG_TEST
    ${response}=    DELETE On Session    session    /dogs/${id_100}
    Status Should Be    200     ${response}



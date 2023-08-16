*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary
Library    JSONLibrary
Library    faker_using.py

Suite Setup    Create Session    session     http://localhost:3000
Suite Teardown    Delete All Sessions


*** Variables ***
${daniel_rath}=      Daniel Rath
${id_john_doe}=      50
${name_john_doe}=    John Doe


*** Test Cases ***
FakeApiTest1_GET
    [Documentation]    This is the first fake json server api test
    ${response}=    GET On Session    session    /people/1
    Status Should Be    200     ${response}

    Should Be Equal As Strings    ${daniel_rath}     ${response.json()["name"]}

FakeApiTest2_POST
    ${avatar}=  GET FAKE IMAGE URL
    &{data}=    Create Dictionary     name=${name_john_doe}   id=${id_john_doe}   avatar=${avatar}
    ${response}=    POST On Session    session      /people       json=${data}
    Status Should Be    201     ${response}

    ${response}=        GET On Session    session       /people/${id_john_doe}
    Status Should Be    200     ${response}
    Should Be Equal As Strings    ${name_john_doe}     ${response.json()["name"]}


FakeApiTest3_DELETE
    [Documentation]    Delete method
    ${response}=        DELETE On Session    session    /people/${id_john_doe}

    Status Should Be    200     ${response}

FakeApiTest4_PATCH
    [Documentation]    PATCH method
    ${avatar}=  GET FAKE IMAGE URL
    &{data}=    Create Dictionary   avatar=${avatar}
    ${response}=    PATCH On Session    session     /people/${id_john_doe}      json=${data}
    Status Should Be    200     ${response}

FakeApiTest5_PUT
    [Documentation]    PUT method
    ${avatar}=  GET FAKE IMAGE URL
    &{data}=    Create Dictionary   id=${id_john_doe}    name=${name_john_doe}      avatar=${avatar}    gender=male
    ${response}=    PUT On Session    session     /people/${id_john_doe}      json=${data}
    Status Should Be    200     ${response}
    Log    ${response.json()['gender']}





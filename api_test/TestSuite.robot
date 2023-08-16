*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary
Library    JSONLibrary

Suite Setup    Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com/


*** Test Cases ***
JSON_Placeholder_test1
    [Documentation]    This is a first JSON Placeholder test
    ${response}=     GET On Session    jsonplaceholder       /posts/1
    Status Should Be    200     ${response}
    Set Test Variable    ${predicted_title}  sunt aut facere repellat provident occaecati excepturi optio reprehenderit
    Should Be Equal As Strings    ${predicted_title}     ${response.json()['title']}

JSON_Placeholder_test2
    [Documentation]     This is a second JSON Placeholder test
    &{data}=      Create Dictionary    title=I want to use Java instead     id=1    body=please give me java at solvd
    ${response}=        POST On Session    jsonplaceholder      /posts      json=${data}
    Status Should Be    201     ${response}

JSON_Placeholder_test3
    [Documentation]    Test 3 JSON Placeholder
    &{data}=        Create Dictionary    title=another title
    ${response}=        PUT On Session     jsonplaceholder      /posts/99    json=${data}
    Status Should Be    200     ${response}

JSON_Placeholder_test4
    [Documentation]    Test 4 JSON Placeholder
    ${response}=        DELETE On Session    jsonplaceholder      /posts/88
    Status Should Be    200     ${response}



*** Settings ***
Documentation       The exercises implemented with the Browser library.

Resource            ../resources/bad_flask_app.robot

Suite Setup         Open Browser To Our Application     headless=${TRUE}
Test Setup          Authenticate And Set Headers

Force Tags          api

*** Variables ***
${NEW_FORM_DATA}    { "id": 11, "name": "Harrison Ford" }
${NEW_EMAIL}        { "email": "firstname.lastname@example.com" }

*** Test Cases ***
Get First Form And Verify Poster's Identity
    [Tags]      get
    ${response}=        Http      /api/forms/1      GET        headers=${HEADERS}
    Should Be Equal         ${response["body"]["name"]}      John Doe
    
Post New Form And Verify Creation Succeeded
    [Tags]      post
    ${response}=        Http      /api/forms        POST       body=${NEW_FORM_DATA}    headers=${HEADERS}
    Should Be Equal As Integers      ${response["status"]}      201

Modify Form's Email Address And Verify It Succeeded
    [Tags]      put
    ${response}=        Http      /api/forms/1      GET        headers=${HEADERS}
    ${old}=     Set Variable       ${response["body"]["email"]}
    ${response}=        Http      /api/forms/1      PUT            body=${NEW_EMAIL}        headers=${HEADERS}
    Should Be Equal As Integers      ${response["status"]}      200
    ${new}=     Set Variable       ${response["body"]["email"]}
    Should Not Be Equal     ${old}      ${new}


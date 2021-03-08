*** Settings ***
Documentation   Suite description
Library         REST        http://localhost:5000
Suite Setup     Authenticate And Set Headers
Force Tags      api

*** Variables ***
${NEW_FORM_DATA}            { "id": 11, "name": "Harrison Ford" }
${NEW_EMAIL}                { "email": "firstname.lastname@example.com" }

*** Test Cases ***
Get First Form And Verify Poster's Identity
    [Tags]      get
    GET         /api/forms/1
    ${res}=     Output      response body name
    Should Be Equal         ${res}      John Doe
    String      response body name      John Doe

Post New Form And Verify Creation Succeeded
    [Tags]      post
    POST        /api/forms       ${NEW_FORM_DATA}
    ${res}=     Output      response status
    Should Be Equal As Integers         ${res}      201
    Integer     response status         201

Modify Form's Email Address And Verify It Succeeded
    [Tags]      put
    GET         /api/forms/1
    ${old}=     String      response body email
    PUT         /api/forms/1            ${NEW_EMAIL}
    Integer     response status     200
    ${new}=     String      response body email
    Should Not Be Equal     ${old}        ${new}

*** Keywords ***

Authenticate And Set Headers
    Post        /api/auth
    ${token}=   Output      $
    Set Headers     { "Authorization": "Bearer ${token}" }

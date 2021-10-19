*** Settings ***
Documentation           Your task is to fill rest of the file
Resource                ../resources/bad_flask_app.robot

*** Variables ***
${NEW_FORM_DATA}            { "id": 11, "name": "Harrison Ford" }

*** Test Cases ***
Get First Form And Verify Poster's Identity
    Replace this with an actual implementation

Post New Form And Verify Creation Succeeded
    Replace this with an actual implementation

Modify Form's Email Address And Verify It Succeeded
    Replace this with an actual implementation

*** Keywords ***
Authenticate And Set Headers
    Replace this with an actual implementation
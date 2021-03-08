*** Settings ***
Documentation       The exercises implemented with the Browser library.

Resource            ../resources/bad_flask_app.robot

Suite Setup         Open Browser To Our Application

Test Setup          Run Keywords
...                 Close Dropdown If Opened
...                 AND
...                 Show Form

Force Tags          browser

*** Test Cases ***
Form Filled With Valid Data Should Submit Successfully
    [Tags]      ui
    Fill Form With Valid Data
    Submit Form
    Validate That Form Submit Succeeded
 

*** Settings ***
Documentation         Your task is to fill rest of the file
Resource              ../resources/bad_flask_app.robot

Suite Setup           Open Browser To Our Application

Test Setup            Close Dropdown If Opened

*** Test Cases ***
Form Filled With Valid Data Should Submit Successfully
    Fill Form With Valid Data
    Submit Form
    Validate That Form Submit Succeeded
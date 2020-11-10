*** Settings ***
Resource            ../resources/bad_flask_app.robot
Library             SeleniumLibrary

Suite Setup         Open Browser To Our Application
Suite Teardown      Close Browser

Test Setup          Run Keywords
...                 Close Dropdown If Opened
...                 AND
...                 Show Form

Force Tags          contacts        UI

*** Test Cases ***

Form Filled With Valid Data Should Submit Successfully
    [Tags]      ABC-123     smoke
    Fill Form With Valid Data
    Submit Form
    Validate That Form Submit Succeeded

    # Alternatiely, we could fill our fields with embedded variables like this
    # Input "John Doe" into Name field
    # Input "john.doe@example.com" into E-mail field
    # Input "Hello, my name is John Doe." into Message field
    # We would also need to implement similar formats to date and important number.
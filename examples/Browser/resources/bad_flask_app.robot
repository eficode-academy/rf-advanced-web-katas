*** Settings ***
Library         Browser     strict=${FALSE}
Library         DateTime

*** Variables ***
${SERVER}       http://localhost:5000
${BROWSER}      chromium
${DATEPICKER_NEXT_BUTTON}       //a[contains(@class,'ui-datepicker-next')]
${FORM_IFRAME}                  //div[not(contains(@class,'hidden'))]/iframe
${OPENED DROPDOWN}              //div[contains(@class, 'open')]
${IMPORTANT_NUMBER_FIELD}       //input[@type='range']
${INPUT_FIELD}                  following-sibling::*[self::input or self::textarea]
${SUBMIT_SUCCESSFUL_TEXT}       Submit successful!

# Default input values
${DEFAULT_NAME}                 John Doe
${DEFAULT_EMAIL}                john.doe@example.com
${DEFAULT_MESSAGE}              Hello, my name is John Doe
${DEFAULT_DAYS}                 3
${DEFAULT_IMPORTANT_NUMBER}     15

*** Keywords ***
# Exercise 01
Authenticate And Set Headers
    [Documentation]     Must be called before any other API call as this sets the HEADERS variable.
    &{response}=        Http        /api/auth       POST
    Set Suite Variable      ${HEADERS}      { "Authorization": "Bearer ${response.body}" }

# Exercise 01 and 02
Open Browser To Our Application
    [Arguments]     ${headless}=${FALSE}
    New Browser     browser=${BROWSER}      headless=${headless}
    New Page        ${SERVER}
    Get Title       ==      Bad Flask App

# Exercise 03
Close Dropdown If Opened
    ${states}=     Get Element States       .dropdown-menu>li>a
    IF      'visible' in @{states}      Click       ${OPENED DROPDOWN}

# Exercise 03
Show Form
    ${states}=     Get Element States       ${FORM_IFRAME}
    IF      'visible' not in @{states}      Click           button

# Exercise 05
Fill All Form Fields
    [Arguments]         ${name}=${DEFAULT_NAME}
    ...                 ${email}=${DEFAULT_EMAIL}
    ...                 ${message}=${DEFAULT_MESSAGE}
    ...                 ${days}=${DEFAULT_DAYS}
    ...                 ${important_number}=${DEFAULT_IMPORTANT_NUMBER}
    Fill Form Field     Name        ${name}
    Fill Form Field     E-mail      ${email}
    Fill Form Field     Message     ${message}
    Select Date From Future         ${days}
    Change Important Number         ${important_number}

# Exercise 05
Fill Form With Valid Data
    Fill All Form Fields

# Exercise 05
Fill Form Field
    [Arguments]     ${field}        ${value}
    Fill Text       ${FORM_IFRAME} >>> //label[contains(text(), "${field}")]/${INPUT_FIELD}
    ...             ${value}

# Exercise 05
Input "${value}" Into ${field} Field
    Fill Text       ${FORM_IFRAME} >>> //label[contains(text(), "${field}")]/${INPUT_FIELD}
    ...             ${value}

# Exercise 06
Select Date From Future
    [Arguments]     ${days}
    Click           ${FORM_IFRAME} >>> id=datepicker
    ${current_date}=        Get Current Date    result_format=datetime
    ${future_date}=         Add Time To Date    ${current_date}     ${days} days    result_format=datetime
    Run Keyword If      ${current_date.month} < ${future_date.month} or ${current_date.year} < ${future_date.year}
    ...         Click       ${FORM_IFRAME} >>> ${DATEPICKER_NEXT_BUTTON}
    Click           ${FORM_IFRAME} >>> //a[text()='${future_date.day}']

# Exercise 07 and 08
Change Important Number
    [Documentation]     If `execute_javascript` is TRUE,
    ...                 the UI doesn't update with the value.
    [Arguments]     ${wanted_value}     ${execute_javascript}=${TRUE}
    # Exercise 08
    IF    ${execute_javascript}
        Change slider value with JS    ${wanted_value}
        RETURN
    END
    # Exercise 07
    ${width}=      Get BoundingBox        ${FORM_IFRAME} >>> ${IMPORTANT_NUMBER_FIELD}     width
    Hover           ${FORM_IFRAME} >>> ${IMPORTANT_NUMBER_FIELD}
    Mouse Button    down
    FOR     ${pixel}        IN RANGE        ${width}
        ${current_value}=       Get Text    ${FORM_IFRAME} >>> id=number
        Exit For Loop If        ${current_value} == ${wanted_value}
        ${position}=        Evaluate        -(${width}/2) + ${pixel}
        Mouse Move Relative To     ${FORM_IFRAME} >>> ${IMPORTANT_NUMBER_FIELD}
        ...       ${position}     0
    END
    Mouse Button     up

# Exercise 08
Change slider value with JS
    [Arguments]    ${wanted_value}
    ${ref}=    Get Element    xpath=${FORM_IFRAME} >>> xpath=${IMPORTANT_NUMBER_FIELD}
    Get Property    ${ref}    value    ==    0
    Evaluate JavaScript    ${ref}       (elem) => elem.value = "${wanted_value}"
    Get Property    ${ref}    value    ==    ${wanted_value}

Submit Form
    Click       ${FORM_IFRAME} >>> button

# Exercise 08
Validate That Form Submit Succeeded
    Get Text    ${FORM_IFRAME} >>> h3   ==      ${SUBMIT_SUCCESSFUL_TEXT}

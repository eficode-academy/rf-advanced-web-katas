*** Settings ***
Documentation                   Resource file for the Bad Flask App. The keywords are organized
...                             in the appearance of exercises for ease of following.
Library                         SeleniumLibrary
Library                         DateTime

*** Variables ***
${SERVER}                       http://localhost:5000
${BROWSER}                      firefox
${BUTTON}                       //button
${DATEPICKER_NEXT_BUTTON}       //a[contains(@class,'ui-datepicker-next')]
${FORM_IFRAME}                  //div[not(contains(@class,'hidden'))]/iframe
${OPENED DROPDOWN}              //div[contains(@class, 'open')]
${INPUT_FIELD}                  following-sibling::*[self::input or self::textarea]
${SUBMIT_SUCCESSFUL_TEXT}       Submit successful!

# Default input values
${DEFAULT_NAME}                 John Doe
${DEFAULT_EMAIL}                john.doe@example.com
${DEFAULT_MESSAGE}              Hello, my name is John Doe
${DEFAULT_DAYS}                 3
${DEFAULT_IMPORTANT_NUMBER}     15

*** Keywords ***

# Exercise 02
Open Browser To Our Application
    Open Browser        ${SERVER}       ${BROWSER}

# Exercise 03
Close Dropdown If Opened
    ${open}=        Run Keyword And Return Status
    ...         Page Should Contain Element     ${OPENED DROPDOWN}
    Run Keyword If      ${open}     Click Element       xpath:${OPENED DROPDOWN}/a

# Exercise 03
Show Form
    Click Element       ${BUTTON}

# Exercise 04
Run Inside Iframe
    [Arguments]     ${frame}     ${keyword}     @{args}
    Select Frame    xpath:${frame}
    Run Keyword     ${keyword}      @{args}
    [Teardown]      Unselect Frame

# Exercise 05
Fill All Form Fields
    [Documentation]     Must be called inside an iframe
    [Arguments]         ${name}=${DEFAULT_NAME}
    ...                 ${email}=${DEFAULT_EMAIL}
    ...                 ${message}=${DEFAULT_MESSAGE}
    ...                 ${days}=${DEFAULT_DAYS}
    ...                 ${important_number}=${DEFAULT_IMPORTANT_NUMBER}
    Fill Form Field     Name        ${name}
    Fill Form Field     E-mail      ${email}
    Fill Form Field     Message     ${message}
    Select Date From Future         ${days}
    Change Important Number         ${important_number}     ${TRUE}

# Exercise 05
Fill Form With Valid Data
    Run Inside Iframe       ${FORM_IFRAME}      Fill All Form Fields

# Exercise 05
Fill Form Field
    [Documentation]     Must be called inside an iframe
    [Arguments]     ${field}        ${value}
    Input Text      xpath://label[contains(text(), "${field}")]/${INPUT_FIELD}      ${value}

# Exercise 05
Input "${value}" Into ${field} Field
    Run Inside Iframe       ${FORM_IFRAME}
    ...      Input Text      xpath://label[contains(text(), "${field}")]/${INPUT_FIELD}      ${value}

# Exercise 06
Select Date From Future
    [Documentation]     Must be called inside an iframe
    [Arguments]     ${days}
    Click Element           id:datepicker
    ${current_date}=        Get Current Date    result_format=datetime
    ${future_date}=         Add Time To Date    ${current_date}     ${days} days    result_format=datetime
    Run Keyword If      ${current_date.month} < ${future_date.month} or ${current_date.year} < ${future_date.year}
    ...         Click Element       xpath:${DATEPICKER_NEXT_BUTTON}
    Click Element           xpath://a[text()='${future_date.day}']

# Exercise 07 and 08
Change Important Number
    [Documentation]     Must be called inside an iframe. If `execute_javascript` is TRUE,
    ...                 the UI doesn't update with the value. If `execute_javascript` is FALSE,
    ...                 the keyword execution takes _much_ longer.
    [Arguments]     ${wanted_value}     ${execute_javascript}=${FALSE}
    # Exercise 08
    Run Keyword If      ${execute_javascript}
    ...         Execute Javascript      document.querySelector("input[name='important_number']").value = ${wanted_value}
    Return From Keyword If      ${execute_javascript}
    # Exercise 07
    ${width}    ${height}=      Get Element Size        name:important_number
    FOR     ${pixel}        IN RANGE        ${width}
        ${current_value}=       Get Text    id:number
        Exit For Loop If        ${current_value} == ${wanted_value}
        ${position}=        Evaluate        -(${width}/2) + 3 * ${pixel}
        Drag And Drop By Offset     name:important_number       ${position}     0
    END

# Exercise 08
Submit Form
    Run Inside Iframe  ${FORM_IFRAME}   Click Element           ${BUTTON}

# Exercise 08
Validate That Form Submit Succeeded
    Run Inside Iframe  ${FORM_IFRAME}   Page Should Contain    ${SUBMIT_SUCCESSFUL_TEXT}

*** Settings ***
Library         Browser
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

Open Browser To Our Application
    New Browser     browser=${BROWSER}      headless=${FALSE}
    New Page        ${SERVER}
    Get Title       ==      Bad Flask App

Close Dropdown If Opened
    ${visible}=     Get Element State       .dropdown-menu>li>a     visible
    Run Keyword If      ${visible}      Click       ${OPENED DROPDOWN}

Show Form
    ${visible}=     Get Element State       ${FORM_IFRAME}      visible
    Run Keyword If      not ${visible}      Click           button

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
    Change Important Number         ${important_number}     ${FALSE}

Fill Form With Valid Data
    Fill All Form Fields

Fill Form Field
    [Arguments]     ${field}        ${value}
    Fill Text       ${FORM_IFRAME} >>> //label[contains(text(), "${field}")]/${INPUT_FIELD}
    ...             ${value}

Select Date From Future
    [Arguments]     ${days}
    Click           ${FORM_IFRAME} >>> id=datepicker
    ${current_date}=        Get Current Date    result_format=datetime
    ${future_date}=         Add Time To Date    ${current_date}     ${days} days    result_format=datetime
    Run Keyword If      ${current_date.month} < ${future_date.month} or ${current_date.year} < ${future_date.year}
    ...         Click       ${FORM_IFRAME} >>> ${DATEPICKER_NEXT_BUTTON}
    Click           ${FORM_IFRAME} >>> //a[text()='${future_date.day}']

Change Important Number
    [Documentation]     If `execute_javascript` is TRUE,
    ...                 the UI doesn't update with the value. If `execute_javascript` is FALSE,
    ...                 the keyword execution takes _much_ longer.
    [Arguments]     ${wanted_value}     ${execute_javascript}=${FALSE}
    # Exercise 08
    Run Keyword If      ${execute_javascript}
    ...         Execute Javascript      document.querySelector("input[name='important_number']").value = ${wanted_value}
    Return From Keyword If      ${execute_javascript}
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

Submit Form
    Click       ${FORM_IFRAME} >>> button

Validate That Form Submit Succeeded
    Get Text    ${FORM_IFRAME} >>> h3   ==      ${SUBMIT_SUCCESSFUL_TEXT}
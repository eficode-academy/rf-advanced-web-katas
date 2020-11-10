*** Variables ***
${MYVAR}        MIKKI HIIRI
${MIKKI}        Mikki
${Mikkihiiri}   Mikki Hiiri

*** Test Cases ***
My Test
    Log To Console      ${${MIKKI}hiiri}
    Run Keyword If      $MYVAR.lower() == 'mikki hiiri'
    ...         Log to Console      This works
    Run Keyword If      '${MYVAR.lower()}' == 'mikki hiiri'
    ...         Log To Console      This also works

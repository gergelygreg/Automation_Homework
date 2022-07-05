*** Settings ***
Library    Browser

*** Variables ***
# *** SUITE VARIABLES ***
${headless}            false
${browser_timeout} =     30s
${browser} =    firefox
${url} =    http://automationpractice.com

*** Keywords ***
Prepare test case
    New Browser    ${browser}   headless=${headless}    args=['--ignore-certificate-errors']
    New context  viewport={'width': 1280, 'height': 1024}
    New Page    ${url}
    Get title    equal    My Store
    Set Browser Timeout    ${browser_timeout}

End test case
    close browser



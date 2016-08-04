*** Settings ***
Documentation     This module is a common OS utility keywords

Library           OperatingSystem
Resource          connection_client.robot
Resource          resource.txt


*** Variables ***


*** Keywords ***

validate OS
    [Documentation]   Validate OS if it is active
    Log To Console    \n Waiting for OS to come online

    Wait For Host To Ping    ${OPENPOWER_LPAR}
    Open Lpar Connection And Log In
    ${stdout}   ${stderr}=    Execute Command    uptime   return_stderr=True
    Should Be Empty     ${stderr}
    Log To Console    \n OS up and running: ${stdout}



*** Settings ***
Documentation     This module is for validating hardbootme

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot

Suite Teardown    Close All Connections

*** Variables ***

*** Test Cases ***

test hardbootme
    [Documentation]   Multiple iteration of hardbootme
    [Teardown]   Log FFDC If Test Case Failed
    : FOR    ${count}    IN RANGE    0    7
    \    Log To Console  \n [ *** hardbootme test count: ${count} *** ] \n
    \    hard boot me

*** Keywords ***

hard boot me
    [Documentation]   Hard boot me
 
    power off
    power on
   
    Log To Console       \n Wait for OS to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}
    Log To Console       \n partition now online

    # Allow for OS to get to prompt
    Sleep    2min
    Open Lpar Connection And Log In
    Log To Console       \n Shutting down partition
    ${stdout}   ${stderr}=    Execute Command    sudo shutdown -f
    ...         return_stderr=True
    Log To Console      \n ${stdout}
    Log To Console      \n ${stderr}
    Should contain      ${stderr}   Shutdown scheduled

    Log To Console      \n Waiting for few minutes to shutdown gracefully
    Sleep    2min

    ${status}=    chassis power status
    Should be equal   ${status}  Chassis Power is off   msg=Poweroff failed
    Log To Console      \n hardbootme completed succesfully
    


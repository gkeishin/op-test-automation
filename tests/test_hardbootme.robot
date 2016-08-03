*** Settings ***
Documentation     This module is for validating hardbootme

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot

#Suite Setup       Open Lpar Connection And Log In
Suite Teardown    Close All Connections

*** Variables ***

*** Test Cases ***

hard boot me
    [Documentation]   Hard boot me
    #[Teardown]   Log FFDC If Test Case Failed
 
    #Power off and power on
    power off
    power on
   
    # Wait for partition to come alive
    Log To Console       \n Wait for LPAR to come online
    Wait For Host To Ping    ${OPENPOWER_LPAR}
    Log To Console       \n partition now online


    Log To Console       \n Shutting down partition
    Open Lpar Connection And Log In
    ${stdout}   ${stderr}=    Execute Command    sudo shutdown -f
    ...         return_stderr=True
    Should contain      ${stdout}   Shutdown scheduled
    Log To Console      ${stdout}

    Log To Console      \n Waiting for few minutes to shutdown gracefully
    Sleep    2min
    # Wait for partition to come alive

    ${status}=    chassis power status
    Should be equal     Chassis Power is off   msg=Chassis not powered off
    Log To Console      \n hardbootme completed succesfully
    
*** Keywords ***


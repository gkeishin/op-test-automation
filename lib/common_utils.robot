*** Settings ***
Documentation     This module is a common utility keywords

Library           SSHLibrary
Library           OperatingSystem

Resource          resource.txt
Resource          ipmi_client.robot


*** Variables ***

${IPMI_CMD}      ${HELP_CMD}${OPENPOWER_HOST}${PREFIX_CMD}

*** Keywords ***

Wait For Host To Ping
    [Arguments]     ${host}
    Wait Until Keyword Succeeds     10min    5 sec   Ping Host   ${host}

Ping Host
    [Arguments]     ${host}
    ${RC}   ${output} =     Run and return RC and Output    ping -c 4 ${host}
    Log     RC: ${RC}\nOutput:\n${output}
    Should be equal     ${RC}   ${0}

Ping and wait For Reply
    [Arguments]     ${lpar_ip}
    # Runs the given command in the system and returns the RC and output
    # ping -c 5  ip  This means count for 5 instance of succcess and return
    ${rc}   ${output} =    Run and return RC and Output     ping -c 5 ${lpar_ip}
    Should be equal     ${rc}    ${0}

chassis power status
    [Documentation]  Chassis power status
    ${status}=    Run IPMI Command   ${POWER_STATUS}
    Log To Console   \n ${status}
    [return]   ${status}

chassis power IPL status
    [Documentation]  Chassis power IPL status
    ${status}=    Run IPMI Command   ${HOST_STATUS}
    Log To Console   \n ${status}
    Should contain   ${status}     S0/G0: working
    [return]   ${status}

chassis SEL check
    ${status}=    Run IPMI Command   ${SEL_ELIST}
    Log To Console   ${status}
    Should be equal   ${status}    SEL has no entries

chassis SEL clear
    ${status}=    Run IPMI Command   ${SEL_CLEAR}
    Log To Console   ${status}
    Should Contain   ${status}    Clearing SEL

power off
    [Documentation]  Chassis power off
    ${status}=    Run IPMI Command   ${POWER_OFF}
    Log To Console   ${status}
    ${status}=  chassis power status
    Should be equal   ${status}    Chassis Power is off


power on
    [Documentation]  Chassis power on
    ${status}=    Run IPMI Command   ${POWER_ON}
    Log To Console   ${status}
    ${status}=  chassis power status
    Should be equal   ${status}    Chassis Power is on


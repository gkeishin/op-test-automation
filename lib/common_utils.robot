*** Settings ***
Documentation     This module is a common utility keywords

Library           SSHLibrary
Library           OperatingSystem

Resource          resource.txt


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

chassis power state
    [Documentation]  Chassis power status
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_STATUS}
    ${state}=  Run   ${ipmi_cmd}
    Log To Console   \n ${state}
    [return]   ${state}

chassis power IPL state
    [Documentation]  Chassis power IPL state
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${HOST_STATUS}
    ${state}=  Run   ${ipmi_cmd}
    Log To Console   \n ${state}
    Should contain   ${state}     S0/G0: working
    [return]   ${state}

chassis SEL check
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${SEL_ELIST}
    Log To Console   \n Executing : ${ipmi_cmd}
    ${status}=  Run  ${ipmi_cmd}
    Log To Console   ${status}
    Should be equal   ${status}    SEL has no entries

chassis SEL clear
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${SEL_CLEAR}
    Log To Console   \n Executing : ${ipmi_cmd}
    ${status}=  Run  ${ipmi_cmd}
    Log To Console   ${status}
    Should Contain   ${status}    Clearing SEL

power off
    [Documentation]  Chassis power off
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_OFF}
    Log To Console   \n Executing : ${ipmi_cmd}
    ${status}=  Run  ${ipmi_cmd}
    Log To Console   ${status}
    ${state}=  chassis power state
    Should be equal   ${state}    Chassis Power is off


power on
    [Documentation]  Chassis power on
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_ON}
    Log To Console   \n Executing : ${ipmi_cmd}
    ${status}=  Run  ${ipmi_cmd}
    Log To Console   ${status}
    ${state}=  chassis power state
    Should be equal   ${state}    Chassis Power is on


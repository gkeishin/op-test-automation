*** Settings ***
Documentation     This module is a common utility keywords

Library           SSHLibrary
Library           OperatingSystem

Resource          ../lib/resource.txt


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
   ${ipmi_cmd_list}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${SEL_ELIST}
   Log To Console   \n Executing : ${ipmi_cmd_list}
   ${status}=  Run  ${ipmi_cmd_list}
   Log To Console   ${status}
   Should be equal   ${status}    SEL has no entries


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


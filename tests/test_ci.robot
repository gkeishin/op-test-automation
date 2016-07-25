*** Settings ***
Documentation     This module is a CI test suite

Library           OperatingSystem

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/resource.txt

Suite Setup       Open Connection And Log In
Suite Teardown    Close All Connections

*** Variables ***
${IPMI_CMD}      ${HELP_CMD}${OPENPOWER_HOST}${PREFIX_CMD}

# Wait for IPL working state
${Retry}         5 min
${Interval}      30s

${SYSTEM_SHUTDOWN_TIME}     1min
${WAIT_FOR_SERVICES_UP}     3min

*** Test Cases ***

chassis sel clear
   [Documentation]  Chassis SEL clear
   [Teardown]   Log FFDC If Test Case Failed
   ${ipmi_cmd_clr}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${SEL_CLEAR}
   Log To Console   \n Executing : ${ipmi_cmd_clr}
   ${status}=  Run  ${ipmi_cmd_clr}
   Log To Console   ${status}

   Sleep   10sec
   chassis SEL check


chassis warm reset
   [Documentation]  Chassis warm reset
   [Teardown]   Log FFDC If Test Case Failed
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${WARM_RESET}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Log To Console   ${status}
   Should contain   ${status}   Sent warm reset command to MC

   Sleep   150sec


chassis power soft
   [Documentation]  Chassis power off soft
   [Teardown]   Log FFDC If Test Case Failed
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_SOFT}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Log To Console   ${status}
   Should not be equal   ${status}    Power Soft Failed

chassis BMC reboot
   [Documentation]  Reboot BMC
   [Teardown]   Log FFDC If Test Case Failed

   ${output}=      Execute Command    /sbin/reboot
   Sleep   ${SYSTEM_SHUTDOWN_TIME}
   Wait For Host To Ping   ${OPENPOWER_HOST}
   Sleep   ${WAIT_FOR_SERVICES_UP}


chassis power off
   [Documentation]  Chassis power off
   [Teardown]   Log FFDC If Test Case Failed
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_OFF}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Log To Console   ${status}
   ${state}=  chassis power state
   Should be equal   ${state}    Chassis Power is off


chassis power on
   [Documentation]  Chassis power on
   [Teardown]   Log FFDC If Test Case Failed
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_ON}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Log To Console   ${status}
   ${state}=  chassis power state
   Should be equal   ${state}    Chassis Power is on


chassis IPL status
   [Documentation]   Chassis power IPL status
   [Teardown]   Log FFDC If Test Case Failed
   chassis power state
   # Check the state of the system is working
   Wait Until Keyword Succeeds    ${Retry}    ${Interval}
   ...    chassis power IPL state


*** Keywords ***

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

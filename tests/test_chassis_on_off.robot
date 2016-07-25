*** Settings ***
Documentation     This suite is used for testing power on and off

Library           OperatingSystem

Resource          ../lib/connection_client.robot
Resource          ../lib/openbmc_ffdc.robot
Resource          ../lib/resource.txt


*** Variables ***
${IPMI_CMD}      ${HELP_CMD}${OPENPOWER_HOST}${PREFIX_CMD}

*** Test Cases ***

chassis power off
   [Teardown]   Log FFDC If Test Case Failed
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_OFF}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Should be equal   ${status}    Chassis Power Control: Down/Off
   chassis power state

chassis power on
   [Teardown]   Log FFDC If Test Case Failed
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_ON}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Should be equal   ${status}    Chassis Power Control: Up/On
   chassis power state


*** Keywords ***

chassis power state
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${POWER_STATUS}
   ${state}=  Run  ${ipmi_cmd}
   Log To Console   \n Executing : ${ipmi_cmd}
   Log To Console    \n ${state}

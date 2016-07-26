*** Settings ***
Documentation     This module is for basic sanity test

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot

*** Variables ***
${IPMI_CMD}      ${HELP_CMD}${OPENPOWER_HOST}${PREFIX_CMD}

*** Test Cases ***

out of band fw and pnor update hpm
   [Documentation]   Out of band PNOR update hpm
   [Teardown]   Log FFDC If Test Case Failed
   preserve network settings

   # Needs BMC_HPM_UPDATE + image  TBD
   # ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${BMC_HPM_UPDATE}
   # Log To Console   \n Executing : ${ipmi_cmd}
   # ${status}=  Run  ${ipmi_cmd}
   # Should be equal    ${status}  Firmware upgrade procedure successful
   # ipmi cold reset

   #Sleep   ${SYSTEM_SHUTDOWN_TIME}
   Wait For Host To Ping   ${OPENPOWER_HOST}
   #Sleep   ${WAIT_FOR_SERVICES_UP}

   Log To Console   "code update TBD"

*** Keywords ***

ipmi cold reset
   [Documentation]   cold reset BMC
   Log To Console   \n Cold reset to proceed code update
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${BMC_COLD_RESET}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Should be equal   ${status}   Sent cold reset command to MC

preserve network settings
   [Documentation]  Network setting is preserved
   Log To Console   \n preserve network settings
   ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${BMC_PRESRV_LAN}
   Log To Console   \n Executing : ${ipmi_cmd}
   ${status}=  Run  ${ipmi_cmd}
   Should not contain   ${status}   Unable to establish LAN session


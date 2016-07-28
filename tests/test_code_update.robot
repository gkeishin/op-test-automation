*** Settings ***
Documentation     This module is for code update

Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot
Resource          ../lib/ipmi_client.robot

*** Variables ***

*** Test Cases ***

out of band fw and pnor update hpm
   [Documentation]   Out of band PNOR update hpm
   [Teardown]   Log FFDC If Test Case Failed
   preserve network settings

   # Needs BMC_HPM_UPDATE + image  TBD
   # ${status}=  Run IPMI Command    ${BMC_HPM_UPDATE}
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
   ${status}=  Run IPMI Command   ${BMC_COLD_RESET}
   Should be equal   ${status}   Sent cold reset command to MC

preserve network settings
   [Documentation]  Network setting is preserved
   Log To Console   \n preserve network settings
   ${status}=  Run IPMI Command   ${BMC_PRESRV_LAN}
   Should not contain   ${status}   Unable to establish LAN session


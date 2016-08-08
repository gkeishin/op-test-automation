*** Settings ***
Documentation     This module is for code update

Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot
Resource          ../lib/ipmi_client.robot

*** Variables ***
${SUFFIX}         component 1 force

*** Test Cases ***

# For Garrison
out of band fw and pnor update hpm
   [Documentation]   Out of band PNOR update hpm
   [Teardown]   Log FFDC If Test Case Failed

   Should not be empty    ${HPM_IMG_PATH}

   # Preserve network and applies fix to BMC
   ${prefix}=   Catenate  SEPARATOR=    ${BMC_HPM_UPDATE}${SPACE}
   ${hpm_cmd}=  Catenate  SEPARATOR=   ${prefix}${HPM_IMG_PATH}${SPACE}${SUFFIX}
   Log To Console      ${hpm_cmd}
   check if image exist  ${HPM_IMG_PATH}

   preserve network settings
   ${status}=  Run IPMI Command    ${hpm_cmd}
   Should be equal    ${status}  Firmware upgrade procedure successful

   # Wait for 2 minutes and then applies fix to SBE pointers
   Wait For Host To Ping  ${OPENPOWER_HOST}   2min

   ipmi cold reset
   Sleep   ${SYSTEM_SHUTDOWN_TIME}
   Wait For Host To Ping   ${OPENPOWER_HOST}
   Sleep   ${WAIT_FOR_SERVICES_UP}


*** Keywords ***

check if image exist
   [Documentation]   Check if the given image exist
   [Arguments]       ${arg}
   OperatingSystem.File Should Exist    ${arg}   msg=File ${arg} doesn't exist..


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


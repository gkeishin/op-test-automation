*** Settings ***
Documentation     This module is a ipmi common client keywords

Library           OperatingSystem

Resource          resource.txt


*** Variables ***

${IPMI_CMD}      ${HELP_CMD}${OPENPOWER_HOST}${PREFIX_CMD}

*** Keywords ***

Run IPMI Command
    [arguments]    ${args}
    ${ipmi_cmd}=   Catenate  SEPARATOR=    ${IPMI_CMD}${SPACE}${args}
    Log To Console     \n Execute: ${ipmi_cmd}
    ${rc}    ${output}=    Run and Return RC and Output   ${ipmi_cmd}
    Should Be Equal As Integers     ${rc}   0
    [return]   ${output}
    

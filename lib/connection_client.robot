*** Settings ***
Documentation     This module is for SSH connection override to QEMU
...               based openbmc systems.

Library           SSHLibrary
Library           OperatingSystem


*** Variables ***

*** Keywords ***
Open Connection And Log In
    Open connection     ${OPENPOWER_HOST}
    Login   ${OPENPOWER_USERNAME}    ${OPENPOWER_PASSWORD}

Open Connection for scp
    Import Library      SCPLibrary      WITH NAME       scp
    scp.Open connection   ${OPENPOWER_HOST}   username=${OPENPOWER_USERNAME}  password=${OPENPOWER_PASSWORD}

Wait For Host To Ping
    [Arguments]     ${host}
    Wait Until Keyword Succeeds     10min    5 sec   Ping Host   ${host}

Ping Host
    [Arguments]     ${host}
    ${RC}   ${output} =     Run and return RC and Output    ping -c 4 ${host}
    Log     RC: ${RC}\nOutput:\n${output}
    Should be equal     ${RC}   ${0}


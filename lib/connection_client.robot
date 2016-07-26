*** Settings ***
Documentation     This module is a common connection clients for
...               open power systems

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


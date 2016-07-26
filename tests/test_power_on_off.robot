*** Settings ***
Documentation     This suite is used for testing power on and off

Library           OperatingSystem

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot

*** Variables ***
${IPMI_CMD}      ${HELP_CMD}${OPENPOWER_HOST}${PREFIX_CMD}

*** Test Cases ***

chassis power off
   [Documentation]  Chassis power off
   [Teardown]   Log FFDC If Test Case Failed
   power off

chassis power on
   [Documentation]  Chassis power on
   [Teardown]   Log FFDC If Test Case Failed
   power on


*** Keywords ***


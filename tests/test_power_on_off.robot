*** Settings ***
Documentation     This module is for basic sanity test

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot
Resource          ../lib/os_utils.robot

*** Variables ***

*** Test Cases ***

chassis power off
    [Documentation]  Chassis power off
    [Teardown]   Log FFDC If Test Case Failed
    power off


chassis power on
    [Documentation]  Chassis power on
    [Teardown]   Log FFDC If Test Case Failed
    power on


Check if OS is online
    [Documentation]   Validate OS if it is active
    [Teardown]   Log FFDC If Test Case Failed
    validate OS

*** Keywords ***


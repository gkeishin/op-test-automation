*** Settings ***
Documentation     This module is a CI test suite

Library           OperatingSystem

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot
Resource          ../lib/ipmi_client.robot

Suite Setup       Open Connection And Log In
Suite Teardown    Close All Connections

*** Variables ***

# Wait for IPL working state
${Retry}         5 min
${Interval}      30s

${SYSTEM_SHUTDOWN_TIME}     1min
${WAIT_FOR_SERVICES_UP}     3min

*** Test Cases ***

chassis sel clear
    [Documentation]  Chassis SEL clear
    [Teardown]   Log FFDC If Test Case Failed
    chassis SEL clear
    Sleep   10s
    chassis SEL check


chassis warm reset
    [Documentation]  Chassis warm reset
    [Teardown]   Log FFDC If Test Case Failed
    ${status}=   Run IPMI Command   ${WARM_RESET}
    Log To Console   ${status}
    Should contain   ${status}   Sent warm reset command to MC
    Sleep   150sec


chassis power soft
    [Documentation]  Chassis power off soft
    [Teardown]   Log FFDC If Test Case Failed
    ${status}=   Run IPMI Command   ${POWER_SOFT}
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
    power off


chassis power on
    [Documentation]  Chassis power on
    [Teardown]   Log FFDC If Test Case Failed
    power on


chassis IPL status
    [Documentation]   Chassis power IPL status
    [Teardown]   Log FFDC If Test Case Failed
    chassis power status
    # Check the state of the system is working
    Wait Until Keyword Succeeds    ${Retry}    ${Interval}
    ...    chassis power IPL status


validate BMC LPAR 
    [Documentation]   Validate BMC LPAR if it is active
    [Teardown]   Log FFDC If Test Case Failed
    Log To Console    \n Ping LPAR
    Ping and wait For Reply    ${OPENPOWER_LPAR}


*** Keywords ***


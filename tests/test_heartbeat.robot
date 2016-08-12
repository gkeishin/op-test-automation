*** Settings ***
Documentation     This module is for testing check for os level,kernel version,
...               existence of ps command and check kopald service is running


Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot

Suite Setup       Open OS Connection And Log In
Suite Teardown    Close All Connections

*** Variables ***


*** Test Cases ***


test kopald service
    [Documentation]  Verify kopald service running or not
    #[Teardown]   Log FFDC If Test Case Failed

    # Kernel version
    ${version}=   Get os info      uname -a | awk {'print $3'}
    Log To Console     \n Kernel Version: ${version}

    #  OS release
    ${release}=   Get os info    cat /etc/os-release | grep -w NAME=
    Log To Console     \n OS Release: ${release.strip("NAME=")}

    # Checking for ps command
    ${stdout}   ${stderr}=    Execute Command    ps   return_stderr=True
    Should Be Empty   ${stderr}
    Log To Console     \n Process status available

    # Checking for ps command
    ${stdout}   ${stderr}=    Execute Command    ps -ef | grep -i kopald   return_stderr=True
    Should Be Empty    ${stderr}
    Should contain     ${stdout}    [kopald]   msg=kopald service is not running
    Log To Console     \n kopald service is running


*** Keywords ***

Get os info
    [Documentation]   Get OS release
    [Arguments]       ${args}
    ${stdout}   ${stderr}=    Execute Command    ${args}   return_stderr=True
    Should Be Empty     ${stderr}
    [return]    ${stdout}


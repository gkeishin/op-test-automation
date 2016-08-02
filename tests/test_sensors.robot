*** Settings ***
Documentation     This module is for testing sensors and modules in the system

Resource          ../lib/connection_client.robot
Resource          ../lib/openpower_ffdc.robot
Resource          ../lib/common_utils.robot

Suite Setup       Open Lpar Connection And Log In
Suite Teardown    Close All Connections

*** Variables ***

${BOOT_CONFIG}     /boot/config-

*** Test Cases ***


Verify Sensor hwmon driver
    [Documentation]  Verify sensor config, driver and lm sensors
    #[Teardown]   Log FFDC If Test Case Failed

    # Kernel version
    ${version}=   Get os info      uname -a | awk {'print $3'}
    ${config}=    Catenate  SEPARATOR=    ${BOOT_CONFIG}${version}
    Log To Console     \n Config File: ${config}

    #SSHException: Channel closed error
    #SSHLibrary.File Should Exist     ${config}

    ${rc}=    Execute Command    ls ${config}  return_stdout=False  return_rc=True
    Should Be Equal As Integers     ${rc}   0
    Log To Console     \n Config file is available
    
    ${rc}=    Run Keyword And Return Status   Config option   ${config}
    Run Keyword If  ${rc} == 0    Log To Console    \n Driver build into kernel

    #  OS release
    ${release}=   Get os info    cat /etc/os-release | grep -w NAME=
    Log To Console     \n OS Release: ${release.strip("NAME=")}

    # loads ibmpowernv driver only on powernv platform
    Run Keyword if   '${release.strip("NAME=")}' != 'PowerKVM'   lpar load ibm power nv

    # Checking for sensors command and lm_sensors package
    Run Keyword and Ignore Error    check sensor on lpar

    #Run Keyword if   '${release.strip("NAME=")}' != 'Ubuntu'   lpar check pkg for utility   dpkg -S
    #...   ELSE   Run Keyword and Ignore Error    lpar check pkg for utility   rpm -qf

    # Restart the lm_sensor service
    @{lm_list} =   Create List    stop   start  status
    :FOR  ${cmd}   IN    @{lm_list}
    \    Run Keyword and Ignore Error    lpar start lm sensor svc   ${cmd}

    # To detect different sensor chips and modules
    Run Keyword and Ignore Error    detect sensor chips and modules

    # Checking sensors command functionality with different options
    @{cmd_list} =   Create List   sensors   sensors -f   sensors -A   sensors -u
    :FOR  ${cmd}   IN    @{cmd_list}
    \    Run Keyword and Ignore Error   sensors command functionalities   ${cmd}



*** Keywords ***

Get os info
    [Documentation]   Get OS release
    [Arguments]       ${args}
    ${stdout}   ${stderr}=    Execute Command    ${args}   return_stderr=True
    Should Be Empty     ${stderr}
    [return]    ${stdout}


Config option
    [Documentation]   Get set command from config file
    [Arguments]      ${file}= 
    ${stdout}   ${stderr}=    Execute Command    cat ${file} | grep -i --color=never CONFIG_SENSORS_IBMPOWERNV   return_stderr=True
    Should Be Empty     ${stderr}     msg=config option is not set
    Should contain      ${stdout}     =y    msg=Driver will be built as module
    [return]   ${stdout}


lpar load ibm power nv
    [Documentation]   loads ibmpowernv driver only on powernv platform

    ${rc}=    Execute Command    sudo modprobe ibmpowernv   return_stdout=False  return_rc=True
    Should Be Equal As Integers     ${rc}   0    msg=modprobe failed while loading ibmpowernv

    ${stdout}   ${stderr}=    Execute Command    lsmod | grep -i ibmpowernv   return_stderr=True
    Should Be Empty     ${stderr}
    Should contain      ${stdout}  ibmpowernv    msg=ibmpowernv module is not loaded
    Log To Console      \n ibmpowernv module is loaded


check sensor on lpar
    [Documentation]   Sensor command
    ${rc}=    Execute Command    which sensors   return_stdout=False  return_rc=True
    Should Be Equal As Integers     ${rc}   0    msg=sensor command is not present on lpar


lpar check pkg for utility
    [Documentation]   installed package on lpar
    [Arguments]       ${args}=
    ${rc}=    Execute Command       ${args} `which sensors`   return_stdout=False  return_rc=True
    Should Be Equal As Integers     ${rc}   0


lpar start lm sensor svc
    [Documentation]   lm_sensors service on lpar using systemctl
    [Arguments]       ${args}=
    ${rc}=    Execute Command   /bin/systemctl ${args} lm_sensors.service    return_stdout=False  return_rc=True
    Should Be Equal As Integers     ${rc}   0   msg=loading lm_sensors service failed
    

detect sensor chips and modules
    [Documentation]   detect sensor chips and modules
    ${rc}=    Execute Command    sudo yes | sensors-detect   return_stdout=False  return_rc=True
    Should Be Equal As Integers     ${rc}   0


sensors command functionalities
    [Documentation]   execute different commands
    [Arguments]       ${args}=
    ${rc}=    Execute Command    ${args}   return_stdout=False  return_rc=True
    Should Be Equal As Integers     ${rc}   0


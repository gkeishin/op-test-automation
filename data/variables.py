
class variables():
    HELP_CMD = "ipmitool -H "
    PREFIX_CMD = " -I lanplus -U ADMIN -P admin"

    # Powering on/off/status
    POWER_ON   = "chassis power on"
    POWER_OFF  = "chassis power off"
    POWER_STATUS = "chassis power status"

    POWER_SOFT   = "chassis power soft"
    WARM_RESET   = "mc reset warm"

    # SEL commands
    SEL_CLEAR   = "sel clear"
    SEL_ELIST   = "sel elist"

    # Host status 
    HOST_STATUS  = "sdr elist |grep 'Host Status'"

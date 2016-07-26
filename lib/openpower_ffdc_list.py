#!/usr/bin/python
'''
#############################################################
#    @file     openpower_ffdc_list.py
#    @author:  George Keishing
#
#    @brief    List for FFDC ( First failure data capture )
#              commands and files to be collected as a part
#              of the test case failure.
#############################################################
'''

#-------------------
# FFDC default list
#-------------------

#-----------------------------------------------------------------
#Dict Name {  Index string : { Key String :  Comand string} }
#-----------------------------------------------------------------
FFDC_CMD = {
             'FIRMWARE INFO' :
                 {
                    'AMI Level'  : 'cat /proc/ractrends/Helper/FwInfo',
                    'Mem info' : 'cat /proc/meminfo',
                    'CPU info'  : 'cat /proc/cpuinfo',
                    'OS info'  : 'uname -a',
                    'Driver Message'  : 'dmesg',
                 },
           }

FFDC_IPMI_CMD = {
             'SYSTEM DATA' :
                 {
                    'Chassis power info'  : 'chassis status',
                    'Host Status'  : 'sdr list | grep -e "OS Boot" -e "FW Boot Progress" -e "Host Status"',
                    'Product info'  : 'fru print 43',
                    'Boot Count'  : 'sensor get "Boot Count"',
                    'Checking BIOS and BMC Boot Sides'  : 'sensor list | grep -i "Golden Side"',
                    'Availble Active Sensor'  : 'sensor list',
                 },
           }

# add file list needed to be offload from BMC
FFDC_FILE = {
             'BMC FILES' :
                     {
                        # SCP not supported in OP BMC
                        #'bmc data' : '/var/log/dmesg',
                     },
           }

#-----------------------------------------------------------------


# base class for FFDC default list
class openpower_ffdc_list():

    ########################################################################
    #   @@brief   This method returns the list from the dictionary for cmds
    #   @param    i_type: @type string: string index lookup
    #   @return   List of key pair from the dictionary
    ########################################################################
    def get_ffdc_cmd(self,i_type):
        return FFDC_CMD[i_type].items()

    ########################################################################
    #   @@brief   This method returns the list from the dictionary for ipmi
    #             cmds
    #   @param    i_type: @type string: string index lookup
    #   @return   List of key pair from the dictionary
    ########################################################################
    def get_ffdc_ipmi_cmd(self,i_type):
        return FFDC_IPMI_CMD[i_type].items()

    ########################################################################
    #   @@brief   This method returns the list from the dictionary for scp
    #   @param    i_type: @type string: string index lookup
    #   @return   List of key pair from the dictionary
    ########################################################################
    def get_ffdc_file(self,i_type):
        return FFDC_FILE[i_type].items()

    ########################################################################
    #   @@brief   This method returns the list index from dictionary
    #   @return   List of index to the dictionary
    ########################################################################
    def get_ffdc_index(self):
        return FFDC_CMD.keys()

    ########################################################################
    #   @@brief   This method returns the list index from dictionary
    #   @return   List of index to the dictionary
    ########################################################################
    def get_ffdc_IPMI_index(self):
        return FFDC_IPMI_CMD.keys()


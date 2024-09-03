Author: Jon Bartee


!!!WARNING!!!
---------------------------------------------------------
 - Please run this script in the order below
 - Keep all .ps1 and .txt files in the same folder
 - AppManBackup will delete files/folders that are necessary 
---------------------------------------------------------

PRE UPGRADE:

    1. AppManBackup.ps1
    ##########################################################################
    Perform backup steps for upgrade as instructed by ManageEngine Vendor Support
    ##########################################################################



    2. FileUpload.ps1 
    ##########################################################################
    Upload selected file to all app man servers
    ##########################################################################


UPGRADE: 

    3. AppManUpgrade.ps1
    ##########################################################################
    This script will run the upgrade steps given by ManageEngine Vendor Support
    ##########################################################################


POST UPGRADE:

    4. CheckRunningStatus.ps1
    ##########################################################################
    This script checks the running status of the Applications Manager service.

    It is separated by standby and primary servers.

    * If any errors related to .txt files please make sure you are running the
    script from the folder that the script and .txt files are located in.

    ##########################################################################





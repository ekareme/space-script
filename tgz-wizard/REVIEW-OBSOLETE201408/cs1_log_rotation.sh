#!/bin/sh -e
#**********************************************************************************************************************
# AUTHORS : Space Concordia 2014, Joseph
#
# PURPOSE : calls the tgzWizard on each file present under CS1_LOGS
#           To be run as a cron job
#
# ARGUMENTS : NONE
#
#**********************************************************************************************************************
source /etc/profile # source SpaceDecl.sh instead

SPACE_LIB="../../space-lib/include"
if [ -f $SPACE_LIB/SpaceDecl.sh ]; then
    source $SPACE_LIB/SpaceDecl.sh
fi


#
# TODO check disk usage and make room if needed (by deleting the oldest tgz files under CS1_TGZ
#




#
# Runs tgzWizard of each file present under CS1_LOGS    
#
for FILE in $CS1_LOGS/*
do
    # removes the extension
    filepath=`echo $FILE | awk -F "." '{print $1}'` 
    
    # removes /home/logs/
    file_no_path_no_ext=`echo $filepath | awk -F "/" '{print $4}'` 

    while [ -f $FILE ]
    do
        ./tgzWizard -f $file_no_path_no_ext -s 500        
    done
done




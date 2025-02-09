
#!/bin/sh -e
#**********************************************************************************************************************
# AUTHORS : Space Concordia 2014, Joseph
#
# PURPOSE : Checks disk usage, if greater than MAX_DU, delete oldest tgz files under CS1_TGZ
#
# ARGUMENTS : 
#           -f  filesystem
#           -m  maximum disk usage accepted, this is a percentage
#           -p  prompt before performing cleanup
#           -u  display usage
#
#**********************************************************************************************************************
DIR=`dirname $0`
SPACE_LIB="$HOME/CONSAT1/space-lib/include"
#
# Includes
#
if [ -f $SPACE_LIB/SpaceDecl.sh ]; then     # on PC
    source $SPACE_LIB/SpaceDecl.sh
else                                        # on Q6
    source $DIR/SpaceDecl.sh
fi

#
# Local variables
#
FILESYSTEM='sda1'           # -f    filesystem
MAX_DU=90                   # -m    maximum disk usage accepted, this is a percentage
PROMPT_BEFORE_CLEANUP=0     # -p

echo "[START] === CS1 DU Checker ==="

display_usage()
{
    echo "Usage :           [-m maxDu] [-p] [-f targetFilesystem] [-u]"
    echo
    echo "          -p  prompt before cleanup"
    exit 0
}


ARGS=$(getopt -o um:pf: -n "$0"  -- "$@");

if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$ARGS";

while true; do
    case "$1" in
        -f) shift     
            FILESYSTEM=$1
            shift
        ;;
        -u)  
            shift
            display_usage
        ;;
        -m)  
            shift 
            MAX_DU=$1
            shift 
        ;;
        -p) 
            shift 
            PROMPT_BEFORE_CLEANUP=1
        ;;
        --)
            shift;
            break;
        ;;
    esac
done


#
# Execution
#
CURRENT_DU=`df | grep $FILESYSTEM| awk '{print $5}' | awk -F "%" '{print $1}'`

echo "[INFO] Current DU is $CURRENT_DU%"

if [ $CURRENT_DU -gt $MAX_DU ]; then

    if [ $PROMPT_BEFORE_CLEANUP -ne 0 ]; then 
	    read -p "Do you want to perform the cleanup and delete oldest files under $CS1_TGZ? [y|N]" choice
    else
        choice=y
    fi

	case "$choice" in 
	    y|Y )  
            echo "[INFO] Performing deletion of the oldest files under CS1_TGZ"
            sts=0

            while [ $CURRENT_DU -gt $MAX_DU -a $sts -eq 0 ]; do
                ls -tr  $CS1_TGZ | head -n 1 | awk '{printf("'$CS1_TGZ'/%s", $1)}' | xargs rm -v  2>/dev/null 
                sts=$?
                CURRENT_DU=`df | grep $FILESYSTEM| awk '{print $5}' | awk -F "%" '{print $1}'`
            done

            echo "[INFO] DU is now $CURRENT_DU%"
        ;;
	    n|N|'' ) 
            echo "Skipping cleanup..."; echo
        ;;
	esac

fi


echo "[END] === CS1 DU Checker ==="

#!/bin/bash


############################################################
# Help                                                     #
############################################################
ErrMsg()
{
   echo "Error: Invalid option"
   echo "use -h  for  Help."
}
Help()
{
   # Display Help
   echo
   echo "use for trace processID and cpuId."
   echo
   echo "options:"
   echo "-h     Print this Help."
   echo "-c     cpuId   - Syntax: 'id1|id1|...'"
   echo "-p     pId     - Syntax: 'pid1|pid1|...'"
   echo "-w     watcher flag"
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Set variables
WATCH_FLAG=false
FQY=1

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts "hwp:c:f:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      w) # Enter a watch flag
         WATCH_FLAG=true;;
      c) # Enter a CPU ID
         CPU_IDs=$OPTARG;;
      p) # Enter a PID
         P_IDs=$OPTARG;;
      f) # Enter a frequency flag
         FQY=$OPTARG;;
     \?) # Invalid option
         ErrMsg
         exit;;
   esac
done


#------
exp=""
for i in ${CPU_IDs//|/ }
    do
        exp=$exp'$1=='$i'||'
    done
for i in ${P_IDs//|/ }
    do
        exp=$exp'$2=='$i'||'
    done
exp=${exp%"||"}
#------

echo "FQY $FQY!"
echo "WATCH_FLAG $WATCH_FLAG!"
echo "CPU_IDs $CPU_IDs!"
echo "P_IDs $P_IDs!"
echo "exp $exp!"


if [ $WATCH_FLAG == true ]; then
        if [ ${#exp} -lt 4 ]; then
            watch -n$FQY 'ps  -o cpuid,pid,command | tail -n +2 | sort |  awk '\''{$1=$1;print}'\'''
        else
            watch -n$FQY 'ps  -o cpuid,pid,command | tail -n +2 | sort |  awk '\''{$1=$1;print}'\'' | awk '\'''$exp''\'''
        fi
else
    while true; do
        echo $'\n\n==> '$(date)
        if [ ${#exp} -lt 4 ]; then
            ps  -o cpuid,pid,command | tail -n +2 | sort |  awk '{$1=$1;print}'
        else
            ps  -o cpuid,pid,command | tail -n +2 | sort |  awk '{$1=$1;print}' | awk $exp
        fi
        sleep $FQY
    done
fi

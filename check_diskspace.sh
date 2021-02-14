#!/bin/bash
# Script that monitors the main filesystem ('/') and simply records the amount of diskapce available.

LOGFILE=/var/log/freespace
FREE_DISK_SPACE=$(df -h / | awk '{print $4}'| grep -v "Avail")
DATE=$(date +"%Y-%m-%d %H:%M:%S")

check_log_file_exists()
{
if [[ -f ${LOGFILE} ]]; then
 echo "Log file exists, continuing script."
else
 echo "Log file does not exist, attempting to create log file"
 touch ${LOGFILE}
fi

if [ $? != 0 ]
then
 echo "Error: No log file exists."
 exit 1;
fi
}

check_free_diskspace()
{
if [[ ! -z ${FREE_DISK_SPACE} ]]; then
 echo "Writing to disk space usage to logfile."
 echo "$DATE  $FREE_DISK_SPACE" >> $LOGFILE
else
 echo "Error obtaining disk space information."
 exit 1;
fi
}

check_log_file_exists
check_free_diskspace



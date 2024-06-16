#!/bin/bash

# Fucntion to check disk space
check_disk_space() {
    # Get available disk space in percentage
    disk_space=$(df -h /| awk 'NR==2 {print $5}'| cut -d'%' -f1)

    # Threshold for disk space exceeds th threshold
    threshold=10

    # Check if disk space exceeds the threshold
    if [ "$disk_space" -ge "$threshold" ]; then
        return 1 # Disk space is critacally low
    else
        return 0 # Disk space is normal
    fi
}

hostname=$(hostname)
subject="Disk Space Alert from: $hostname"
receiver="mastengkorak@gmail.com"
body="Disk space is critically low. Please take necessary action."

send_mail(){
    echo "$body"| mutt -s "$subject" $receiver
    if [ $? -eq 0 ]; then
        echo "Email sent."
    else
        echo "Failed to send email"
    fi
}

# Main script
check_disk_space
if [ $? -eq 1 ]; then
    send_mail
fi
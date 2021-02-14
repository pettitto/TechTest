#!/bin/bash
# Script that ichecks and amends the default SSH Port.

#Amend the port value in sshd_config
change_port()
{
sudo sed -i 's/#Port 22/Port 5522/g' /etc/ssh/sshd_config
}

check_current_port()
{
CURRENT_PORT=$(sudo netstat -tulpn | grep sshd | awk '{print $4}' | head -n 1 | cut -f2 -d":")
if [[ ${CURRENT_PORT} == "5522" ]]; then
 echo "Port is already ${CURRENT_PORT}"
 exit 0;
else
change_port
fi
}

# Check that the value matches what we expect
check_port_has_changed()
{
EXPECTED_PORT=$(sudo grep Port /etc/ssh/sshd_config | grep -v '^\s*$\|^\s*\#')
if [[ ${EXPECTED_PORT} == "Port 5522" ]] ; then
 echo "Port has been amended correctly"
else
 echo "Port has not been set correctly. Port is set to ${EXPECTED_PORT}."
 exit 1;
fi
}

restart_sshd_daemon()
{
sudo systemctl restart sshd
}

check_running_ssh_port()
{
sudo netstat -tplugn | grep ssh
}

check_current_port
restart_sshd_daemon
check_running_ssh_port

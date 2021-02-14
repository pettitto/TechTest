Please see main.tf for the terraform configuration for deploying my instance in AWS.

main.tf covers: 

- The creation of the intance
- Insertion of my public key onto the VM for access to the host

Modified the defult SSH port by editing the /etc/ssh/sshd_config file and specifying port 5522 instead of port 22. I then restarted the sshd service with sudo systemctl restart sshd
Following this, I also had to add this port into the default security group in AWS too. (This can be done in terraform)

(Now scripted, see: See the script "change_ssh_port.sh" for further details on changing the default SSH Port.)

Disabling root log in was actually done already as part of the standard Amazon Linux 2 AMI, however, this can be controlled by commenting out #PermitRootLogin yes or explicitly setting PermitRootLogin no

I have removed the ability to access the host using SSH Keys and opted for Passwords only, we could rotate passwords which should be obtained from a secure password store, rather than relying on SSH keys which are much harder to keep on top of (employees leave the business for example). e're able to limit who can actually attempt to connect to the host via Firewall rules.

Setting up a standard user with full sudo privileges:

(As the root user)

1. useradd skyuser
2. passwd skyuser (set a strong password)
3. vi /etc/sudoers.d/90-cloud-init-users
 - Added the skyuser into this file with the following: skyuser ALL=(ALL) NOPASSWD:ALL

For additional security, it's worth bearing in mind that on a standard Amazon Linux 2 AMI that it comes with a user already set up with full sudo privileges, which in this case is called ec2-user. It's good practice to remove any entries in the sudoers file that you either don't recognise or are standard users that come with the OS by AWS. Leaving these in could give an intruder unwanted access.

With relation to trying to protect the VM from attacks, we've already changed the SSH port and disabled logging in as the root user. Additional to that, within the AWS console, I have restricted which IP address can connect to the VM, this can be useful for internal based services or if you want to limit various IP ranges from being able to access the host/service. This was done within the security section with the AWS security panel. This can be done as part of a standard build within Terraform too by adding a resource "aws_security_group". I did attempt this but came across a few issues with remote execution - the idea was that I was looking to have the SSH Port change script deployed as part of the build and executed, that way, we could automarically just SSH onto the host on port 5522 - I'd need a bit more time to investigate and test this further.

Wrote a script to check diskspace '/'. This logs out to a logfile as requested with a datetime and the amount if space that's left available. This has been added to cron and runs every 5 minutes as requested.

Logrotate rotates the logs every 1 hour and compresses the rotated logfile and keeps a maximum of 10 rotated logfiles. Since hourly logrotates don't quite come out of the box, I had to create my own /etc/cron.hourly/logrotate directory and configuration file:

/var/log/freespace {
        hourly
        create 700 skyuser skyuser
        rotate 10
        compress
        nomail
}

Installing netdata: I had to teporarily enable outbound connectivity to netdata to allow the netdata to be installed. The installation took around 5 minutes to complete with this command: bash <(curl -Ss https://my-netdata.io/kickstart.sh). The dashboard for this was available for viewing on <INSTANCE_IP>:19999

Installing Nginx: This was straight forward in that AWS has an nginx package available on their repository that's available out of the box, so the following was run to install: sudo amazon-linux-extras install nginx1

I added a new page here: /usr/share/nginx/html/hellosky.htm which outputs "Hello, Sky", as requested.

To ensure that nginx runs automatically on boot, I ran: systemctl enable nginx


Additional comments:

The build for this assignment is partially automated, with more work and thorough investigation, I'm confident it could be completely automated with Terraform. I've set the initial VM build with SSH Ports being 22, however the script I have included "change_ssh_port.sh" will change that to port 5522 as soon as you run it (including te restarting of the necessary services), this process could do to be done at build time, with the TCP port in the Terraform build being 5522, example shown here:

ingress {
    from_port   = 5522
    to_port     = 5522
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["MyIPRange"]
  }

As well as this, I'd consider using puppet to automate the deployment of the crontab contents and potentially the check_diskspace.sh script could be deployed via this method and scheduled (as well as directory/permissions being handled too). 

AMI Has been exported. AMI ID: ami-0e84dbfa3515ae899 and is available publicly. 
Username and password to access the host will be e-mailed over as part of my response.

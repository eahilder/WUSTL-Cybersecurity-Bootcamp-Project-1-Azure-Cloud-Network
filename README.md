# WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network
Azure cloud network
## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![alt text](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/Diagrams/AzureELKnetwork.png "Network Diagram")

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the ansible folder may be used to install only certain pieces of it, such as Filebeat.

  - [Install-DVWA.yml](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/Ansible/install-DVWA.yml)
  - [Install-ELK.yml](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/Ansible/install-ELK.yml)
  - [Install-filebeat.yml](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/Ansible/install-filebeat.yml)
  - [Install-metricbeat.yml](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/Ansible/install-metricbeat.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly accessible, in addition to restricting access to the network.
Load balancers help protect the availability of the network by shifting the load between different servers to ensure that a single server does not become overwhelmed and thus unavailable. 
This network also utlilizes a jumpbox. A jumpbox helps restrict access to the network by acting as a single gateway or "door" to the network. Utilizing a jumpbox allows for a much more easy to follow ACL in the NSG/firewall rules. In this project, the jumpbox also provided an administrative type workstation that can be utilized to manage and configurate the other systems in the network. 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the files and system metrics.
Filebeat monitors the log files or locations that you specify, collects log events, and forwards them either to Elasticsearch or Logstash for indexing. For example, in my network referenced above, my ELK server would recieve system logs from web1 and web2. I could then log into my Kibana application and observe things such as any SSH logins, and any sudo commands ran. Having quick access to these records could help identify indications of attack and compromise within the network. 

Metricbeat is another tool that can be utilized with ELK. Metricbeat collects the metric data from the services and the operating system and sends it to the ELK server. In my network above, Metricbeat was able to monitor web1 and web2's dockers. I was able to verify that both my DVWA docker containers were running. I was also able to monitor the network traffic data to and from my docker containers. 

The configuration details of each machine may be found below.

| Name                | Function   | IP Address                | Operating System |
|---------------------|------------|---------------------------|------------------|
| Jumpbox Provisioner | Gateway    | 13.91.242.167             | Linux OS         |
| Web-1               | web server | 10.0.0.8                  | Linux OS         |
| Web-2               | Web server | 10.0.0.9                  | Linux OS         |
| ELK                 | ELK        | 10.1.0.4<br>20.85.225.146 | Linux OS         |
### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jumpbox provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
-66.232.187.156, this is my homestation public IP. 

Machines within the network can only be accessed by the Jumpbox Provisioner. As previously mentioned, the Jumpbox Provisioner acts as a single point of entry to the network. The jumpbox provisioner was further hardened by disabling all outgoing access from the jumpbox. Utilizing outgoing NSG rules, the Jumpbox provisioner is denied access to anything outside the network. NOTE: an outgoing security rule had to be created for SSH to the internal subnet of 10.0.0.0/24 and 10.1.0.0/24 in order for the Jumpbox provisioner to be able to still access the internal private subnets. While this creates an extra step, this also guarantees that even if an unauthorized party gains access to the Jumpbox provisioner, they will not be able to access the internet from the jumpbox. 

The ELK VM is only accessible inside the network from the Jumpbox Provisioner. utilizing my homestation with the Public IP of 66.232.187.156 and port 5601, I am able to use kibana to monitor and view the Kibana dashboards. However due to my firewall configuration, I cannot gain full access to the ELK VM via port 5601, I am only able to view the Kibana. 

A summary of the access policies in place can be found in the table below.

| Name                | publicly accessible | Allowed IPs    |
|---------------------|---------------------|----------------|
| Jumpbox Provisioner | Yes                 | 66.232.187.156 |
| WEB-1               | no                  | N/A            |
| WEB-2               | no                  | N/A            |
| ELK                 | no                  | N/A            |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because this allows for a much faster reinstall of ELK onto Web-1 and Web-2 and it also allows for a faster configuration for ELK on newly added VMs. 

The playbook implements the following tasks:
- Install docker.io
- Install Python3-pip
- Install Docker Module
- Increase Max virtual Memory for the VM
- Download and Launch a Docker Elk Container with the appropriate config ports
- Enable Docker to restart on boot


The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![alt text](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/images/docker_ps_output.png)


### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1 10.0.0.8
- Web-2 10.0.0.7

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- **Filebeat**-  As previously mentioned,  Filebeat monitors the log files or locations that you specify, collects log events, and forwards them either to Elasticsearch or Logstash for indexing. In this instance, filebeat can monitor the changes to the system log files on Web1 and Web2. Below is a screenshot of Kibana that demonstrates how Kibana with Filebeat would show that a new user "bob" was created on Web-1. If the adding of new users is prohibited on the Web1 VM, then this information could be an Indicator of Compromise. This is just one example of information that can be pulled from the syslog while utilizing ELK.

![alt text](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/images/kibana_user_added_example.PNG "user added example")

- **Metricbeat**- Metricbeat collects the metric data from the services and the operating system and sends it to the ELK server. For example, Kibana can be used to monitor the docker metrics on web1 and web2. Using this with the docker config, I can verify that both the containers are running on Web1 and Web2. Quick access to this information can greatly speed up the troubleshooting process if there are reported outages of the webserver.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the install-elk.yml, install-filebeat.yml, and the install-metric.yml file to etc/ansible.
- Copy the filebeat-config.yml and metricbeat-config.yml files to etc/ansible/files -This is the directory the install playbooks pull the configuration files from when the playbook is ran.
- Update the hosts file of ansible to create a host for Elk. Note: The host must be named Elk or the install-elk.yml will not be able to find the correct host to install ELK.
- Below is an example of a host file with a host created for Elk. For your install be sure to replace 10.1.0.4 with the private IP of your ELK VM. The ansible_python_interpreter=/usr/bin/python3 must be included after the IP address of your elk machine.
- ![alt text](https://github.com/eahilder/WUSTL-Cybersecurity-Bootcamp-Project-1-Azure-Cloud-Network/blob/main/images/hosts.png)
- Update the filebeat-config.yml and metricbeat-config.yml files to include the correct hosts IP for your network. This would be the Public IP of your ELK VM.
- Run the install-elk.yml, and navigate to  http://<yourelkVMpublicIP>:5601/ to check that the installation worked as expected.
- Run the install-filebeat.yml and the install-metricbeat.yml to install each beat. 
  - you can verify the installation in Kibana by navigating to their respective dashboards.
    - for the install-filebeat.yml, the monitoring of syslogs is already enabled.
    - for the install-metricbeat.config.yml, the monitoring of docker metrics is already enabled. 
      - Both of these yml files can be changed to meet yours needs. Utilize the metricbeat and filebeat reference pages for more. 

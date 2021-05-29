# MediaWiki with CFT, ANSIBLE and Jenkins

### Dependencies

We need to install these dependencies to perform the Infrastructure creation
through cloudformation

- Ansible 
- Jenkins
- aws cli

#### To Install ANSIBLE in Ubuntu

Please use the below commands to install Ansible in Ubuntu

```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```

Once Ansible is installed you can verify its version

```
ubuntu@ip-172-31-38-247:~$ ansible --version
ansible 2.5.1
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/ubuntu/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.17 (default, Feb 27 2021, 15:10:58) [GCC 7.5.0]

```

#### To Install Jenkins in Ubuntu

Jenkins have Java Dependency. We first have to install Java and then we need to Install Jenkins.
Please use the below command to install Java & Jenkins in Ubuntu

```
$ sudo apt update
$ sudo apt install openjdk-8-jdk
$ wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
$ sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
$ sudo apt-get update
$ sudo apt-get install jenkins
```

Once you done everything you'll see the status active just like above

```
ubuntu@ip-172-31-38-247:~$ systemctl status jenkins.service
● jenkins.service - LSB: Start Jenkins at boot time
   Loaded: loaded (/etc/init.d/jenkins; generated)
   Active: active (exited) since Wed 2021-05-26 03:09:19 UTC; 7min ago
     Docs: man:systemd-sysv-generator(8)
  Process: 20862 ExecStart=/etc/init.d/jenkins start (code=exited, status=0/SUCCESS)

May 26 03:09:18 ip-172-31-38-247 systemd[1]: Starting LSB: Start Jenkins at boot time...
May 26 03:09:18 ip-172-31-38-247 jenkins[20862]: Correct java version found
May 26 03:09:18 ip-172-31-38-247 jenkins[20862]:  * Starting Jenkins Automation Server jenkins
May 26 03:09:18 ip-172-31-38-247 su[20912]: Successful su for jenkins by root
May 26 03:09:18 ip-172-31-38-247 su[20912]: + ??? root:jenkins
May 26 03:09:18 ip-172-31-38-247 su[20912]: pam_unix(su:session): session opened for user jenkins by (uid=0)
May 26 03:09:18 ip-172-31-38-247 su[20912]: pam_unix(su:session): session closed for user jenkins
May 26 03:09:19 ip-172-31-38-247 jenkins[20862]:    ...done.
May 26 03:09:19 ip-172-31-38-247 systemd[1]: Started LSB: Start Jenkins at boot time.
```

*Note: Jenkins default password will be in this location(password used for first time access) '/var/lib/jenkins/secrets/initialAdminPassword'*

#### Installing aws cli in Ubuntu

```
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```

You can access aws `/usr/local/bin/aws` or you can add `alias aws='/usr/local/bin/aws'` to `~/.bashrc` file

```
$ aws --version
aws-cli/2.2.6 Python/3.8.8 Linux/5.4.0-1045-aws exe/x86_64.ubuntu.18 prompt/off
```


*Note: If you don't have resource to Install the above packages you could always use the EC2 instance predefined in my AWS account*

#### Configuring aws Cli

To use AWS cli you must configure it. configuring aws cli is Trivial
Just need to run the below command and provide the details in prompt

```
$ aws configure
AWS Access Key ID [None]: AKIxxxxxxxxxxxxxEXAMPLE
AWS Secret Access Key [None]: wxxxxxxxxxxxxxxxxxxxxxxxEXAMPLEKEY
Default region name [None]: ap-south-1
Default output format [None]: json
```

#### Architecture

![Architecture](https://i.imgur.com/Ice96W8.png)

This Mediawiki architecture was completely built in AWS with the help of AWS CloudFormation Template. The Infra has a ubuntu Jump box [ec2 instance] with Jenkins, Ansible and aws-cli installed. From this Jump box we're going to create the AWS Infra for mediawiki deployment. 

We need to create a Stack using AWS CloudFormation template (This can be in JSON or YAML format, I preferred JSON). The template will be stored in a S3 Bucket. This stack should have a EC2 Instance and RDS (I used MySQL Engine). 


I've created three Jobs in Jenkins

1. **STACK_DELETION** - To Delete and clear up the previous Instances,DBs (If any).
2. **STACK_CREATION** - To Create a Stack with RDS and EC2 Instance  
3. **CFT-ANSIBLE-MediaWiki** - This is actual pipeline which handles Cloning the latest Repo, Installing dependencies, configuring MYSQL for MediaWiki DB, Finally Installing Mediawiki 

These Jobs will help us in creating our Infra in just few clicks from Jenkins through browser.
This way Deployment doesn't need any much interaction with AWS console.

### How To

This section we can see how we can delete existing Stack and create new Stack, Deploying Mediawiki, configuring DB through Jenkins. These can be achieved with just few clicks.

#### Deleting Existing Stack

- **STACK_DELETION** - This Jenkins Job will Delete the existing Stacks and resources (EC2 instance, RDS)
It is always recommended to Delete the previous stack to Avoid Conflict.


![Deleting](https://i.imgur.com/ssg02u6.png)

Since AWS Credentials were already vaulted in Jenkins, We just need provide Stack Name to be deleted and click Build.

![Deleting](https://i.imgur.com/9zuMp1Y.png)

The Job will run for few minutes and Delete the EC2 Instance first and then RDS (EC2 is Dependant on RDS).


#### Creating a New Stack

**STACK_CREATION** - This Jenkins Job will create a Stack with the name you specify.The stack has EC2 Instance and RDS Mysql DB Engine to store the mediawiki user and other details

![Creating](https://i.imgur.com/1iBbQLR.png)

Similar to Stack Deletion, we just need to pass the Name of Stack to be created and click Build.
It will take a while to build and give a success message. Several details like Instance ID, Public IP, RDS Endpoint would be Displayed on Successfull creation. 

![Creating](https://i.imgur.com/8nGCEgq.png)

Kindly Note them down since we need these details while installing mediawiki.

#### Installing Mediawiki using Jenkins Pipeline

**CFT-ANSIBLE-MediaWiki** - This Jenkins Job have the pipeline contains several stages like Cloning the latest Repo from Github, Installing dependencies like PHP, apache etc in the EC2 instance, configuring MYSQL for MediaWiki DB in the RDS which we created through Cloudformation, Finally Installing Mediawiki.

This is were we need to perform a couple of changes. In this pipeline Script Just change the IP address which we noted down while creating the Stack in previous section. Change it with new IP in both the lines like below

![Installing](https://i.imgur.com/dZn2yfI.png)

Since we didn't use hostname or Static Elastic Ip while creating the stack. This workaround is required for smooth run. If not the job will through error and fail.  

Once the change has been made, Click Build Now button. 
You will see progress in every stage we created in the Jenkins pipeline as below

![Installing](https://i.imgur.com/MP94e4t.png)

If all stages turned green like the below, The deployment went smooth without any failure.

![Installing](https://i.imgur.com/CjwA2fI.png)

Once the pipeline succesfully completed, we could see the mediawiki page in the `PublicIp/wiki/` of Instance we created through Cloudformation just like the below image

![Installing](https://i.imgur.com/02n7zQy.png)


#### Warnings

- The Stack Deletion and creation takes almost 10 mins since I'm using only free tier with less resource in the Cloudformation Template.
- I haven't created any seperate VPC, security groups for the sake of simplicity. This can be impletemented too using Cloudformation Templates. 
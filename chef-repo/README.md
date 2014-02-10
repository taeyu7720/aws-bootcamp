###Table Of Contents###
- [Overview](#overview)
- [Repository Directories](#repository-directories)
- [Before you begin](#before-you-begin)
- [Exercise 1: Workstation Setup](#exercise-1-workstation-setup)
- [Exercise 2: My First Chef](#exercise-2-my-first-chef)
- [[EXTRA] Using Vagrant](#extra-using-vagrant)

## Overview ##
===

Every Chef installation needs a Chef Repository. This is the place where cookbooks, roles, config files and other artifacts for managing systems with Chef will live. We strongly recommend storing this repository in a version control system such as Git and treat it like source code.

While we prefer Git, and make this repository available via GitHub, you are welcome to download a tar or zip archive and use your favorite version control system to manage the code.

## Repository Directories ##
===
This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* ```.chef/``` - This directory contains Chef configuration files.
* ```cookbooks/``` - Cookbooks you download or create.
* ```data_bags/``` - Store data bags and items  in .json in the repository.
* ```roles/``` - Store roles in .rb or .json in the repository.

### ```.chef``` ###

* ```chef-validator.pem``` - private key used to authenticate requests to Chef Server.
* ```knife.rb``` - ```knife``` configuration file ([docs](http://docs.opscode.com/config_rb_knife.html))
* ```workshop.pem``` - private key for your workstation.

Before you begin
===

Make sure you've downloaded this Git repository to your machine. Just click [this](https://github.com/paprins/aws-bootcamp/archive/master.zip) link to download the ZIP file. 

## Exercise 1: Workstation Setup

### Install Chef ###

* Goto: http://www.getchef.com/chef/install/
 * Select your OS (and version and architecture)
* Download most recent version (currently: 11.10.0-1) 
* Follow installation instructions.

### Quick Download Links ###

* [Windows](https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.10.0-1.windows.msi)
* [OSX](https://opscode-omnibus-packages.s3.amazonaws.com/mac_os_x/10.7/x86_64/chef-11.10.0_1.mac_os_x.10.7.2.sh)
* [Ubuntu 12.04](https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef_11.10.0-1.ubuntu.12.04_amd64.deb)

For Linux/OSX you can use the Omnibus installer to download and install Chef:

```bash
$ curl -L https://www.opscode.com/chef/install.sh | sudo bash
```

### Test your installation ###

You can test if your installation is ok by following these steps:

* Open a Command Prompt or Shell and go to the ```chef-repo``` directory. (Remember: all Chef commands are executed from the so-called kitchen)
* Type: ```knife client list```

It should display something like this:

```bash
chef-validator
chef-webui
workshop
```

## Exercise 2: My First Chef ##

You've seen the presentation. So, you know about Roles, Cookbooks, Recipes, and what not. Let's create some ourselves. The ultimate goal would be that we create an instance (same) and provision it using Chef. 

> I assume you already cloned this Git repository or [downloaded](https://github.com/paprins/aws-bootcamp/archive/master.zip) it as as ZIP file. If you haven't, do so now.

### Create a Role ###

Make sure you

```bash
$ knife role create <your_id>
```

### Create a Cookbook ####

```bash
$ knife cookbook create mycookbook
```

### Create a Recipe ###

```bash
$ knife cookbook upload mycookbook
```

### Bootstrap your EC2 Node ###

First, we need an S3 Bucket to store some artifacts needed for provisioning our nodes.

* Goto the AWS Dashboard and select S3.
* Create an S3 Bucket. Make sure you use Region 'Ireland' (```eu-west-1```).

If you get a message like this:

```bash
The requested bucket name is not available. 
The bucket namespace is shared by all users of the system. 
Please select a different name and try again.
```

... use a unique name. As the message indicates, the namespace is shares by all users of S3. In short, this means that the S3 Bucket name should be unique accross all Regions. Best practice is to use a reverse domain name convention. 

This Git Repository contains a directory called ```chef-repo/.chef```. That directory contains a file called ```chef-validator.pem```. This file is the permissions certificate for communicating with the Chef Server.

![eu-west-1](https://raw.github.com/paprins/aws-bootcamp/master/images/chef-run.png)


* Upload ```.chef/chef-validator.pem``` to your S3 Bucket. 

* Make a copy of ```cfn-simple.json``` and name it ```cfn-simple-bootstrap.json``` 

* Add the following ```Metadata``` snippet to the ```MyEc2Instance``` instance.

```json
"Metadata": {
  "AWS::CloudFormation::Init": {
    "config": {
      "packages": {
        "yum": {
          "ruby": [],
          "rubygems": [],
          "ruby-devel": [],
          "make": [],
          "glibc-devel": [],
          "gcc": [],
          "python-setuptools": []
        },
        "rubygems": {
          "chef": [],
          "ohai": []
        }
      },
      "sources": {
        "/etc/chef/": {
          "Fn::Join": [
            "",
            [ "https://s3-eu-west-1.amazonaws.com/", {"Ref": "S3Bucket"}, "/chef-validator.pem" ]
          ]
        }
      },
      "files": {
        "/etc/chef/client.rb": {
          "content": {
            "Fn::Join": [
              "\n",
              [
                "log_location             STDOUT",
                "validation_client_name   'chef-validator'",
                { "Fn::Join": ["",["environment '",{"Ref": "ChefEnvironment"},"'"]] },
                { "Fn::Join": ["",["chef_server_url '",{"Fn::FindInMap": ["Settings","Chef","ChefServerURL"]},"'"]] }
              ]
            ]
          },
          "mode": "000644",
          "owner": "root",
          "group": "root"
        },
        "/etc/chef/first-boot.json": {
          "content": {
            "run_list": [
              {
                "Fn::Join": ["",["role[",{"Ref": "ServerRole"},"]"]]
              }
            ]
          },
          "mode": "000644",
          "owner": "root",
          "group": "root"
        }
      },
      "commands": {
        "01ChefClientRun": {
          "command": {
            "Fn::Join": [""
               ,["/usr/bin/chef-client -j /etc/chef/first-boot.json -E ",{"Ref": "ChefEnvironment"}
               ," --logfile /etc/chef/first-boot.log"
              ]
            ]
          }
        }
      }
    }
  },
  "AWS::CloudFormation::Authentication": {
    "S3AccessCreds": {
      "type": "S3",
      "accessKeyId": {"Ref": "HostKeys"},
      "secretKey": {"Fn::GetAtt": ["HostKeys","SecretAccessKey"]},
      "buckets": [ {"Ref": "S3Bucket"} ]
    }
  }
```

For more info on Metadata and User Data see [here](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html).

## [EXTRA] Using Vagrant ##

* Download (and install) Vagrant from [here](http://www.vagrantup.com/downloads.html)
* Install the following Vagrant plugins, by typing:
 * ```vagrant plugin install vagrant-aws```
 * ```vagrant plugin install vagrant-omnibus```
* Verify installation of plugins by typing: ```vagrant plugin list```

More info about:
* the ```vagrant-aws``` plugin here: https://github.com/mitchellh/vagrant-aws
* the ```vagrant-omnibus``` plugin here: https://github.com/schisamo/vagrant-omnibus
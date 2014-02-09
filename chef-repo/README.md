###Table Of Contents###
- [Overview](#overview)
- [Repository Directories](#repository-directories)
- [Before you begin](#before-you-begin)
- [Exercise 1: Workstation Setup](#exercise-1-workstation-setup)

## Overview ##
===

Every Chef installation needs a Chef Repository. This is the place where cookbooks, roles, config files and other artifacts for managing systems with Chef will live. We strongly recommend storing this repository in a version control system such as Git and treat it like source code.

While we prefer Git, and make this repository available via GitHub, you are welcome to download a tar or zip archive and use your favorite version control system to manage the code.

## Repository Directories ##
===
This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* ```cookbooks/``` - Cookbooks you download or create.
* ```data_bags/``` - Store data bags and items  in .json in the repository.
* ```roles/``` - Store roles in .rb or .json in the repository.

Before you begin
===

Make sure you've downloaded this Git repository to your machine. Just click [this](https://github.com/paprins/aws-bootcamp/archive/master.zip) link to download the ZIP file. 

## Exercise 1: Workstation Setup

### Install Chef ###

* Goto: http://www.getchef.com/chef/install/
 * Select your OS (and version and architecture)
* Download most recent version (currently: 11.10.0-1) and follow installation instructions.

Quick Links
---
* [Windows](https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.10.0-1.windows.msi)
* [OSX](https://opscode-omnibus-packages.s3.amazonaws.com/mac_os_x/10.7/x86_64/chef-11.10.0_1.mac_os_x.10.7.2.sh)
* [Ubuntu 12.04](https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef_11.10.0-1.ubuntu.12.04_amd64.deb)

For Linux/OSX you can use this command line to download and install Chef:

```bash
$ curl -L https://www.opscode.com/chef/install.sh | sudo bash
```

Exercise 1: Create a Role

Make sure you

```bash
knife role create <your_id>
```

Exercice 2: Create a Cookbook

```bash
knife cookbook create mycookbook
```

Exercise 3: Create a Recipe

Exercise 4; Bootstrap your EC2 Node

EXTRA: Using Vagrant



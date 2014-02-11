###Table Of Contents###
- [Overview](#overview)
- [Repository Directories](#repository-directories)
- [Before you begin](#before-you-begin)
- [Exercise 1: Workstation Setup](#exercise-1-workstation-setup)
- [Exercise 2: My First Chef](#exercise-2-my-first-chef)
- [[EXTRA] Using Vagrant](#extra-using-vagrant)

## Overview ##

Every Chef installation needs a Chef Repository. This is the place where cookbooks, roles, config files and other artifacts for managing systems with Chef will live. We strongly recommend storing this repository in a version control system such as Git and treat it like source code.

While we prefer Git, and make this repository available via GitHub, you are welcome to download a tar or zip archive and use your favorite version control system to manage the code.

## Repository Directories ##

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

Make sure you've downloaded this Git repository to your machine. Just click [this link](https://github.com/paprins/aws-bootcamp/archive/master.zip) to download the ZIP file. 

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
* **Type:** ```knife client list```

It should display something like this:

```bash
chef-validator
chef-webui
workshop
```

**Note:** if you get an error message when creating resources using the ```knife``` command like this:

```bash
Chef - ERROR: RuntimeError: Please set EDITOR environment variable.
```

On **Linux/OSX** you can fix this by typing ```export EDITOR=$(which nano)``` (or any other editor you would like to use). On **Windows**, create an environment variable ```EDITOR``` with value ```notepad```. Or, use an other editor, e.g. ```set EDITOR="C:\Program Files\Notepad++\notepad++.exe"```

## Exercise 2: My First Chef ##

You've seen the presentation. So, you know about Roles, Cookbooks, Recipes, and what not. Let's create some ourselves. The ultimate goal would be that we create an instance (same) and provision it using Chef. 

#### Create a Cookbook ###
First, we'll create a new ```cookbook```. This ```cookbook``` will contain the recipes we need to provision our Amazon AWS EC2 instance.

>To prevent us from overwriting someone elses ```cookbook```, we need to use a unique name. We are using a single Chef Server repository. Unique names will be appointed to you during the workshop.

>PS: In this exercise, I'll be using ```user_one``` as an example.

>PPS: All ```knife``` commands should be executed from the ```chef-repo``` directory. This way, it can find the ```.chef/knife.rb``` configuration file. This file contains all information to reach the Chef Server.

* **Type:** ```knife cookbook create user_<your_number>```, e.g. ```knife cookbook create user_one```

Output should be something like this:

```bash
** Creating cookbook user_one
** Creating README for cookbook: user_one
** Creating CHANGELOG for cookbook: user_one
** Creating metadata for cookbook: user_one
** Creating specs for cookbook: user_one
```

* **Edit** ```cookbooks/user_one/recipes/default.rb``` and add: ```include_recipe "nginx"```
>The ```default.rb``` is called the default recipe (duuuh). This recipe is executed if no other recipe is mentioned when calling a cookbook from a run_list. 
>We just added a reference to the ```nginx``` cookbook without reference to a specific recipe, so you now know that the *default* recipe will be executed. Curious what that recipe contains? See here: https://github.com/opscode-cookbooks/nginx

* **Edit** ```cookbooks/user_one/metadata.rb``` and add ```depends "nginx"```

* **Upload** Cookbook to Chef Server by typing:

```bash
$ knife cookbook upload user_one

Uploading user_one       [0.1.0]
Uploaded 1 cookbook.
```

* Verify that your ```cookbook``` has been uploaded correctly:

```bash
$ knife cookbook list
```

**Output**
```bash
apt               2.3.4
bluepill          2.3.1
build-essential   1.4.2
chef-client       3.2.2
chef_handler      1.1.4
cron              1.2.8
logrotate         1.4.0
nginx             2.2.2
ohai              1.1.12
rsyslog           1.10.2
runit             1.5.8
s3_file           2.3.0
user_one          0.1.0 <-- LOOK HERE!
yum               3.0.6
yum-epel          0.2.0
```

Your cookbook should be in that list.

>That's is for now. Let's create a Role that includes a reference to our Cookbook.

#### Create a Role ####

* **Create** a new ```role``` by typing:

```bash
$ knife role create role_<your_number>
```

If you've configured everyting correctly, an editor should open with the following data:

```json
{
  "name": "role_one",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [

  ],
  "env_run_lists": {
  }
}
```

* Modify the ```run_list``` to this:

```json
{
  ...
  "run_list": [
    "recipe[user_one]"
  ],
  ...
}
```

* Exit your editor. Changes should be uploaded automagically. Output should be similar to ```Created role[role_one]```

* **Verify** your ```role``` by typing: ```knife role show role_one -F j```

>We've created a ```cookbook```, edited the default ```recipe``` and created a ```role```. Let's use those resources to provision an EC2 instance.

### Create an S3 Bucket ###

Before we continue, we need to create an S3 Bucket to store some artifacts needed for provisioning our nodes.

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

* Upload ```.chef/chef-validator.pem``` to the root folder of your S3 Bucket. 

### Bootstrap your EC2 Node ###

Now, let's create an EC2 instance using CloudFormation. Just like before, only now we'll use ```AWS::CloudFormation::Init``` and ```cfn-init``` to install the Chef software.

* **Open** CloudFormation template ```cloudformation/cfn-simple-cloudinit.json``` in a text-editor or your browser.
* Search for ```AWS::CloudFormation::Init``` and study it's contents. Use the [documentation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html) if some parts are not clear.
* Now, search for the ```UserData``` property of the ```AWS::EC2::Instance``` and study it's contents. Use the [documentation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-waitcondition-article.html) if some parts are not clear.
* **Go to** the CloudFormation dashboard and create a new Stack using the ```cfn-simple-cloudinit.json``` template. 
* Use the following values:

 | Parameter | Description |
 | --------- | ----------- |
 | KeyName | The name of the keypair you generated earlier. |
 | InstanceType | Instance type (use ```t1.micro``` for Free Tier) |
 | ChefEnvironment | Reference to the Chef environment in which you would like to register this node (use ```development```) |
 | ServerRole | Use the name of the Chef Role you created earlier (e.g. ```role_one```) |
 | S3Bucket | The name of the S3 Bucket you created (not an url, just a name) |
* **Create** the Stack.

The CloudFormation template is already prepped and ready to go, so it should create an EC2 instance that after 5 mins (or so) automagically registers with Chef, gets all relevant cookbooks and provisions that node.

* After is Stack has been created (status = ```CREATE_COMPLETE```), check the EC2 dashboard and find the public IP address.

* Log into to EC2 instance using SSH or Putty. 

```bash
ssh ec2-user@<public_ip> -i /path/to/private/keypair.pem
```

* Check the log to verify everything is OK

```bash
sudo less /etc/chef/first-boot.log
```

>The ```cfn-init``` command logs it results to ```/var/log/cfn-init.log```. Take a look at that logfile as well.

The Chef software should be installed. Verify by typing: ```chef-client``` ... Congratulations, you just triggered your first (manual) ```chef-client``` run (read [this](#anatomy-of-a-chef-client-run)). Look at the console and see what ```chef-client``` does.

### Dev, Test, Publish, Repeat ###

* **Open** the public IP of your instance in a browser. It should show a ```404 Not Found```.

>The default ```document_root``` directory does not exist after installing the ```nginx``` package. You'll have to create that directory yourself. Let's use Chef to create that directory for us.

* **Open** ```cookbooks/user_<your_number>/recipes/default.rb``` in your favorite editor and add the following (just before ```include_recipe "nginx"``` )

```
directory "/var/www/nginx-default" do
   owner "nginx"
   group "nginx"
   mode "0755"
   action :create
   recursive true
end

file "/var/www/nginx-default/index.html" do
   action :create
   owner "nginx"
   group "nginx"
   mode "0644"
   content <<-EOS
Hello World from '#{node.name}' !
EOS
end
```
* **Upload** your changed cookbook to the Chef Server:

```bash
$ knife cookbook upload user_one
```

* Now, run ```chef-client``` again on your bootstrapped EC2 instance. The changes should be applied to your node. 
* Verify by browsing to the public IP of your instance in a browser. It should show the ```Hello World``` message.

>Notice that we used an attribute of the node in the recipe. Your free to use any attributes in your recipe.

#### Provision the HTML5 App ###

* **Upload** the ```app/h5demo.zip``` to your S3 Bucket. 
* **Edit** ```cookbooks/recipes/default.rb``` and add the following on the bottom:

```
s3_file "/tmp/h5demo.zip" do
   remote_path            "h5demo.zip"
   bucket                 "<your_bucket>"
   aws_access_key_id      "<your_aws_access_key>"
   aws_secret_access_key  "<your_aws_secret_access_key>"
   notifies :run, "execute[unzip]"
end

execute "unzip" do
   action :nothing
   only_if {::File.exists?('/tmp/h5demo.zip')}
   cwd "/var/www/nginx-default"
   command "unzip -o -j /tmp/h5demo.zip"
end
```

>Notice the ```notifies```. This means that the ```.zip``` file will only be unzipped when the resource we downloaded from S3 actually changes (```s3_file``` actually looks at the MD5Hash or Etag to decide if it should download the resource)

* **Edit** ```cookbooks/user_one/metadata.rb``` and add ```depends "s3_file"```

* **Upload** your changed cookbook to the Chef Server:

```bash
$ knife cookbook upload user_one
```

* Now, run ```chef-client``` again on your bootstrapped EC2 instance. The changes should be applied to your node. 
* Verify by browsing to the public IP of your instance in a browser. It should now show the HTML5 demo application we saw earlier.

### Anatomy of a Chef Client Run ###

The following figure shows the anatomy of an a ```chef-client``` run:

![eu-west-1](https://raw.github.com/paprins/aws-bootcamp/master/images/chef-run.png)

## [EXTRA] Bootstrapping Existing Nodes ##

```bash
$ knife bootstrap <public_ip> 
    --ssh-user <username> 
    --sudo -i /path/to/private.pem 
    --node-name <node_name> 
    --run-list "role[role_one]"
```
[Documentation](http://docs.opscode.com/knife_bootstrap.html)

## [EXTRA] Attributes and Data Bags ##

You might have noticed that we used hardcoded values in our recipe.

```
s3_file "/tmp/h5demo.zip" do
   remote_path            "h5demo.zip"
   bucket                 "<your_bucket>"
   aws_access_key_id      "<your_aws_access_key>"
   aws_secret_access_key  "<your_aws_secret_access_key>"
   notifies :run, "execute[unzip]"
end
```

Try to move the hardcoded values to either the [attributes](http://docs.opscode.com/essentials_cookbook_attribute_files.html) (```cookbooks/user_one/attributes/default.rb```) or create an (encrypted) [data bag](http://docs.opscode.com/essentials_data_bags.html) to hold these values.

## [EXTRA] Community Cookbooks ##

Have a look at this: http://community.opscode.com/cookbooks and find your favorite cookbook. Try to apply to to your node.

1. Download cookbook: ```knife cookbook site download <cookbook_name>```
1. Unpack in cookbooks directory.
1. Upload to Chef Server: ```knife cookbook upload <cookbook_name>```
1. Modify ```default.rb``` (or create a new recipe) to include recipe from new cookbook.
1. Converge node: ```chef-client --log_level info --logfile my.log```
1. Verify.

## [EXTRA] Chef and Windows
We only focussed on provisioning Chef on Linux based notes. You can use Chef to provision Windows nodes as well. The most simple way is to use the combination of ```AWS::CloudFormation::Init``` and ```UserData```.

For existing Windows servers, you can have two options:
* install an SSH server
* use [```winrm```](http://msdn.microsoft.com/en-us/library/aa384426(v=vs.85).aspx)

More info:
* [knife windows](http://docs.opscode.com/plugin_knife_windows.html)
* [Cooking on Windows with Chef](http://www.getchef.com/blog/2013/08/27/cooking-on-windows-with-chef/)

## [EXTRA] Using Vagrant ##

Should you have some time left, try to install and use [Vagrant](http://www.vagrantup.com). Vagrant support both AWS as a provider and [Chef](http://docs.vagrantup.com/v2/provisioning/chef_client.html) as a provisioner. I've already include a ```Vagrantfile```. 

* Download (and install) Vagrant from [here](http://www.vagrantup.com/downloads.html)
* Install the following Vagrant plugins, by typing:
 * ```vagrant plugin install vagrant-aws```
 * ```vagrant plugin install vagrant-omnibus```
 * ```vagrant plugin install vagrant-butcher```
* Verify installation of plugins by typing: ```vagrant plugin list```
* Edit the ```Vagrantfile``` to your needs.
* Type: ```$ vagrant up```

More info about:
* the ```vagrant-aws``` plugin here: https://github.com/mitchellh/vagrant-aws
* the ```vagrant-omnibus``` plugin here: https://github.com/schisamo/vagrant-omnibus
* the ```vagrant-butcher``` plugin here: https://github.com/cassianoleal/vagrant-butcher

~ THE END
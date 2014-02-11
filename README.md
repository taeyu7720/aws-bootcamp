aws-bootcamp
============

This repository contains (most) resources needed for the AWS Bootcamp organized by [4Synergy](http://www.4synergy.nl) on wednesday feb, 12.

You can either clone this Git repository, or just click [here](https://github.com/paprins/aws-bootcamp/archive/master.zip) to download all resources as a ```zip``` file.

###Table Of Contents###
- [Getting Started](#getting-started)
- [Sign Up](#sign-up)
- [Install the AWS CLI](#install-the-aws-cli)
- [Configuring the AWS Command Line Interface](#configuring-the-aws-command-line-interface)

## Getting Started ##

Before you can start this workshop, you must sign up for an Amazon AWS account (if you don't already have one) and set up your environment. The following sections will help you setup your workstation and get started.

### Sign Up ###

To access AWS, you will need to sign up for an AWS account. If you already have an AWS account, you can skip to the next section.

##### To sign up for an AWS account #####

1. Go to http://aws.amazon.com, and then click **Sign Up**.
1. Follow the on-screen instructions.

Part of the sign-up procedure involves receiving a phone call and entering a PIN using the phone keypad.

AWS sends you a confirmation email after the sign-up process is complete. At any time, you can view your current account activity and manage your account by going to http://aws.amazon.com and clicking **My Account/Console**.

#### Get your access key and secret access key ####

Access keys consist of an access key ID and secret access key, which are used to sign programmatic requests that you make to AWS. If you don't have access keys, you can create them by using the AWS Management Console.

**Note:**
To create access keys, you must have permissions to perform the required IAM actions. For more information, see [Granting IAM User Permission to Manage Password Policy and Credentials](http://docs.aws.amazon.com/IAM/latest/UserGuide/PasswordPolicyPermission.html) in Using IAM.

1. Go to the [IAM console](https://console.aws.amazon.com/iam/home?#home).
1. From the navigation menu, click **Users**.
1. Select your IAM user name.
1. Click **User Actions**, and then click **Manage Access Keys**.
1. Click **Create Access Key**.
```
   Your keys will look something like this:
   Access key ID example: AKIAIOSFODNN7EXAMPLE
   Secret access key example: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```
1. Click **Download Credentials**, and store the keys in a secure location.

Your secret key will no longer be available through the AWS Management Console; you will have the only copy. Keep it confidential in order to protect your account, and never email it. Do not share it outside your organization, even if an inquiry appears to come from AWS or Amazon.com. No one who legitimately represents Amazon will ever ask you for your secret key.

## Install the AWS CLI ###

### Install the AWS CLI Using the MSI Installer (Windows) ###
For Windows users, an MSI installation package offers a familiar and convenient way to install the AWS CLI without any prerequisites. This is the recommended way for Windows users looking to quickly get started with the AWS CLI.

1. Download the appropriate MSI installer
 * [Download the AWS CLI MSI installer for Windows (64-bit)](https://s3.amazonaws.com/aws-cli/AWSCLI64.msi)
 * [Download the AWS CLI MSI installer for Windows (32-bit)](https://s3.amazonaws.com/aws-cli/AWSCLI32.msi)
1. Run the downloaded MSI installer.
1. Follow the instructions that appear.

### Install the AWS CLI Using the Bundled Installer (Linux, OS X, or Unix) ###

If you are on Linux, OS X, or Unix, you can use the bundled installer to install the AWS CLI. The bundled installer handles all the details in setting up an isolated environment for the AWS CLI and its dependencies. You don't have to be fluent in advanced pip/virtualenv usage, nor do you have to worry about installing pip.

To see if you have Python installed, type the following at a command prompt:

```bash
$ python --version
```

#### Install Python ###

If your computer doesn't already have Python installed, or you would like to install a different version of Python, follow this procedure.

1. [Download the Python package](http://python.org/download/) for your operating system.
1. Install Python.

Verify the Python installation by typing the following at a command prompt:

```bash
$ python --version
```
#### Install the AWS CLI Using the Bundled Installer ####

Follow these steps to install the AWS CLI using the bundled installer.

1. Download the [AWS CLI Bundled Installer](https://s3.amazonaws.com/aws-cli/awscli-bundle.zip).
1. Unzip the package.
1. Run the install command.

On Linux, here are the three commands that correspond to each step:

```bash
$ wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
$ unzip awscli-bundle.zip
$ sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
```

Assuming you have sudo permissions, the last command will install the AWS CLI at ```/usr/local/aws``` and create the symlink ```aws``` at the ```/usr/local/bin``` directory. Using the ```-b``` option to create a symlink eliminates the need to specify the install directory in the user's ```$PATH``` variable. This should enable all users to call the AWS CLI by typing ```aws``` from any directory.

Alternatively, if you have no sudo permissions or want to install the AWS CLI only for the current user, you can run the following command.

```bash
$ ./awscli-bundle/install -b ~/bin/aws
```

This will install the AWS CLI to the default location (```~/.local/lib/aws```) and create a symlink at ```~/bin/aws```. Make sure that ```~/bin``` is in your ```$PATH``` variable for the symlink to work.

To see further explanation of the ```-i``` and ```-b``` options, type the following at the command prompt.

```bash
$ ./awscli-bundle/install -h
```

The bundled installer does not put anything outside of the installation directory with the exception of the optional symlink, so uninstalling is as easy as simply deleting the installation directory.

### Install the AWS CLI Using pip (Windows, Linux, OS X, or Unix) ###

pip is a Python-based tool that offers convenient ways to install, upgrade, and remove Python packages and their dependencies.

Verify the Python installation by typing the following at a command prompt:

```bash
$ python --version
```

To see if you have pip installed, type the following at a command prompt:

```bash
pip --help
```
If your computer doesn't already have Python installed, follow the instructions above.

If your computer doesn't already have pip installed, follow this procedure.

1. Download [ setuptools(ez_setup.py)](https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py) and [pip(get-pip.py)](https://raw.github.com/pypa/pip/master/contrib/get-pip.py). 
1. Run the following two commands.
```bash
$ python ez_setup.py
$ python get-pip.py
```
1. Verify your pip installation by typing the following at your command prompt:
```bash
$ pip --help
```
**Note:**
If you are using Windows, you must update your path with the directory where pip was installed, which defaults to the Scripts subdirectory of the Python installation directory. For example, if you installed Python 2.7 to ```C:\Python27```, you would add the path ```C:\Python27\Scripts``` to your ```PATH``` environment variable.

#### Install the AWS CLI Using pip ###

With Python and pip installed, you can use the following command to install the AWS CLI.

```bash
$ pip install awscli
```

To upgrade, simply use the ```--upgrade``` option.

```bash
$ pip install --upgrade awscli
```

To ensure that the AWS CLI is installed and set up correctly, type the following AWS CLI command at a command prompt:

```bash
$ aws help
```

If the test is successful, you will see the help displayed.

## Configuring the AWS Command Line Interface ##

To get started quickly with minimal configuration, use the ```aws configure``` command. This command prompts for your AWS credentials, default region, and default output format. Your inputs are then saved in a file named ```config``` located in a folder named ```.aws``` in your home directory. On Windows, that would look like ```C:\Users\USERNAME\.aws\config```. On Linux, OS X, or Unix, that is ```~/.aws/config```. The following shows how this command works.

```bash
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: eu-west-1
Default output format [None]: json
```

More info needed? http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

#### Command Completion ####

On Unix-like systems, the AWS CLI includes a command-completion feature that enables you to use the **Tab** key to complete a partially typed command. This feature is not automatically installed so you need to configure it manually.

To enable tab completion for *bash*, use the built-in command ```complete```:

```bash
$ complete -C aws_completer aws
```

**PRO TIP:** You can add this command to your ```~/.bash_profile```. This way it gets executed each time you open a shell session.
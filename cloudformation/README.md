AWS BOOTCAMP

CLOUDFORMATION
===

###Table Of Contents###
- [Exercise 1: My First CloudFormation Stack](#exercise-1-my-first-cloudFormation-stack)
 - [Create the Stack](#create-the-stack)
 - [Update the Stack](#update-the-stack)
 - [Delete the Stack](#delete-the-stack)
- [Exercise 2: Auto Scaling + Load Balancer](#exercise-2-auto-scaling--load-balancer)

##Exercise 1: My First CloudFormation Stack##

###Create the Stack###

####Log in####
* Login into the AWS Dashboard https://console.aws.amazon.com and go to CloudFormation.

![AWS Dashboard](https://raw.github.com/paprins/aws-bootcamp/master/cloudformation/img/aws-dashboard.png)

* Next, make sure you selected the correct region. It should be "Ireland" (which is ```eu-west-1```)

 ![eu-west-1](https://raw.github.com/paprins/aws-bootcamp/master/cloudformation/img/aws-region.png)

####Create a New Stack####
Push the "Create Stack" button, enter a sensible name for your Stack and upload the ```cfn-simple.json``` template (see figure).

![Create a New Stack](https://raw.github.com/paprins/aws-bootcamp/master/cloudformation/img/aws-cfn-create-stack-1.png)
*  When you press the *Next Step* button, CloudFormation will validate the template you just uploaded. If the template is not valid, you will be notified. If you would like to validate before the template before upload, type the following on the command line (assuming you installed the AWS CLI):
```bash
$ aws cloudformation validate-template --template-body file://path/to/cloudformation.template
```
**Pro Tip:**
If you use [Sublime Text 2](http://www.sublimetext.com/2) (which you should ... excellent editor!) you can add a Builder to validate the CloudFormation templates. Goto: ```Tools - Build System - New Build System ...``` and add the following code:

```json
{
   "cmd": ["/usr/local/bin/aws","--region","eu-west-1","cloudformation","validate-template","--template-body", "file://$file"],
   "selector": "source.json"
}
```

After setting up a Builder for CloudFormation, all you have to do is press ```Command-B``` (or ```Win-B```) to validate the CloudFormation template.

Press *Next Step*

####Specify Parameters####

This step will show a form in wich you enter the values for the Parameters you specified in your template (see figure).

![Specify Parameters](https://raw.github.com/paprins/aws-bootcamp/master/cloudformation/img/aws-cfn-create-stack-2.png) 

* Note that default values are already filled in and descriptions are displayed as help text. Remember that Free Tier allows you to create a ```t1.micro``` instance for free. All other values for **InstanceType** will cost money (not that much, but don't say I haven't warned you). Specify the name for the Key Pair you created earlier as value for **KeyName**. In case you forgot: goto EC2 -> Key Pairs. 

Press *Next Step*

####Add Tags####

This step allows you to add Tags to your Stack. This can be handy for billing purposes or to identify which Stacks/Resources have been created for a specific department/customer/developer/...

![eu-west-1](https://raw.github.com/paprins/aws-bootcamp/master/cloudformation/img/aws-cfn-create-stack-3.png)

Press *Next Step*

####Review####

![eu-west-1](https://raw.github.com/paprins/aws-bootcamp/master/cloudformation/img/aws-cfn-create-stack-4.png)

Review all values (go Back if needed) and press *Create* to create the CloudFormation Stack.

After you pressed the *Create* button, the CloudFormation framework starts creating the Resources as defined in the template. Progress and results can be monitored from the tabs in the Dashboard (see figure).

![eu-west-1](https://raw.github.com/paprins/aws-bootcamp/master/cloudformation/img/aws-cfn-create-stack-5.png)

####Testing Access####

Since we added a Security Group that includes Inbound access on port 22 (SSH), let's test if we can access the instance.

**Linux/OSX**

If you're on Linux or Mac OSX, use the following command to access the instance.

```bash
$ ssh ec2-user@<public-ip> -i /path/to/keypair.pem
```

If you get an error message like this:
```bash
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0755 for 'keypair.pem' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
bad permissions: ignore key: keypair.pem
Permission denied (publickey).
```
... restrict the privileges on your private key by typing: ```chmod 400 /path/to/keypair.pem```

**Windows**

If you use Windows to access the Linux-based instance, you first have to convert the Private Key to Putty format (.ppk). 

Follow [this guide](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html) and you should be good to go in no time.

###Update the Stack###
Let's update our template and update the Stack we just created.

* Open the ```cfn-simple.json``` template in an editor.
* Look for the ```Ec2SecurityGroup``` resource and add inbound access for port 443.
* Go to the CloudFormation Dashboard, select your Stack and press **Update Stack**
* Upload your modified template and press **Next Step**
* Notice that values you entered earlier are displayed. Press **Next Step**
* We won't add a [Policy](http://docs.aws.amazon.com/console/cloudformation/stackpolicy) to protect our Stack Resources. Press **Next Step**
* Review all values and press **Update**

This is a fairly trivial update, but (in theory) you can update any resource created in the Stack. Depending on the type of Resource and its dependencies, the resource will be updated without interruption, or they will be replaced. See [here](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks.html) for more information about Updating Stacks.

###Delete the Stack###
If you would like to delete an entire stack of resources, just select the Stack from the Dashboard and press **Delete Stack**.

- - -

##Exercise 2: Auto Scaling + Load Balancer##




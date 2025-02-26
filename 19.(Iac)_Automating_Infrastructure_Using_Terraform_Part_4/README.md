# Automating Infrastructure With IaC using Terraform 4 (Terraform Cloud)

## Table of Contents
1. [Introduction](#introduction)
2. [What Is Terraform Cloud and Why Use It](#what-is-terraform-cloud-and-why-use-it)
3. [Migrating Your `.tf` Code to Terraform Cloud](#migrating-your-tf-code-to-terraform-cloud)
   - [Step 1: Create a Terraform Cloud Account](#step-1-create-a-terraform-cloud-account)
   - [Step 2: Create an Organization](#step-2-create-an-organization)
   - [Step 3: Configure a Workspace](#step-3-configure-a-workspace)
   - [Step 4: Configure Variables](#step-4-configure-variables)
   - [Step 5: Run Terraform Scripts](#step-5-run-terraform-scripts)
   - [Step 6: Apply Terraform Changes](#step-6-apply-terraform-changes)
   - [Step 7: Test Automated Terraform Plans](#step-7-test-automated-terraform-plans)
4. [Configuring the Infrastructure With Ansible](#configuring-the-infrastructure-with-ansible)
5. [Extra Task №1](#extra-task-1)
   - [1. Configure Branches for Environments](#1-configure-branches-for-environments)
   - [2. Automate Runs for Dev Environment](#2-automate-runs-for-dev-environment)
   - [3. Set Up Email and Slack Notifications](#3-set-up-email-and-slack-notifications)
   - [4. Apply and Destroy Infrastructure](#4-apply-and-destroy-infrastructure)
6. [Public vs. Private Module Registry](#public-vs-private-module-registry)
7. [Extra Task №2](#extra-task-2)
   - [Working with a Private Repository](#working-with-a-private-repository)
   - [1. Create a Terraform Module Repository](#1-create-a-terraform-module-repository)
   - [2. Import the Module into Your Private Registry](#2-import-the-module-into-your-private-registry)
   - [3. Use the Module in Your Configuration](#3-use-the-module-in-your-configuration)
   - [4. Initialize and Deploy](#4-initialize-and-deploy)
   - [5. Destroy the Deployment](#5-destroy-the-deployment)
8. [Conclusion](#conclusion)
9. [References](#references)

---

## Introduction

In this project, we are going to explore how to automate AWS infrastructure using Terraform Cloud and integrating tools like Packer and Ansible for a streamlined Infrastructure as Code (IaC) workflow. When we migrate our Terraform configurations to Terraform Cloud, we are going to benefit from managed states, remote operations, and collaborative features that enhance our DevOps practices.

---

## What Is Terraform Cloud and Why We Use It

Terraform Cloud is a managed service by HashiCorp that provides a collaborative environment for Terraform users. Unlike running Terraform locally or on a self-managed VM, Terraform Cloud offers us the following benefits:

- **Remote State Management:** Safely store and manage Terraform state files.
- **Collaboration:** Enable team-based workflows with shared state and locking.
- **Automated Runs:** Trigger Terraform operations based on version control changes.
- **Integrated VCS:** Seamlessly connect with GitHub, GitLab, and other version control systems.
- **Policy Enforcement:** Apply governance rules to our infrastructure deployments.

**Our Terraform Cloud Workflow**

```mermaid
graph TD;
A[Version Control System] --> B[Terraform Cloud Workspace]
B --> C[Tf Plan]
C --> D[Tf Apply]
D --> E[AWS Infrastructure]
B --> F[Team Collaboration]
B --> G[Remote State Management]
```

*Fig: High-Level Workflow of Terraform Cloud Integration*

---

## Migrating our `.tf` Code to Terraform Cloud

Migrating our existing Terraform configurations to Terraform Cloud involves us taking different steps, from account creation to running our first Terraform scripts in the cloud environment.

### Step 1: Create a Terraform Cloud Account

1. **Sign Up:**
   - Visit the [Terraform Cloud Sign-Up Page](https://app.terraform.io/public/signup/account).
   - Create a new account and verify your email address.

   ![Screenshot: Create Terraform Account](./images/create-tf-acct.png)  
   ![Screenshot: Create Terraform Account - Profiles Page](./images/create-tf-acct-2.png)  
   *Fig: Creating a Terraform Cloud Account*

2. **Explore Plans:**
   - Terraform Cloud offers both free and paid plans. Review the [pricing details](https://www.hashicorp.com/products/terraform/pricing) to choose the plan that best fits your needs - in our case, we will go with the free plan.

   ![Screenshot: Terraform Pricing Plans](./images/tf-pricing.png)  
   *Fig: Terraform Cloud Pricing Overview*

### Step 2: Create an Organization

1. **Start Fresh:**
   - Select `Start from scratch` when prompted.
   - Choose a unique name for your organization.

2. **Confirmation:**
   - Once created, you will receive a confirmation message.

   ![Screenshot: Create Terraform Organization](./images/create-tf-org.png)  
   *Fig: Creating a Terraform Organization*

### Step 3: Configure a Workspace

1. **Understand The Workflows:**
   - Terraform Cloud supports multiple workflows:
     - **Version Control Workflow**
     - **CLI-Driven Workflow**
     - **API-Driven Workflow**

   > **Tip:** Watch [this video](https://www.youtube.com/watch?v=m3PlM4erixY&t=287s) to understand the differences and choose the best workflow for your project _(in our case, we will go with the Version Control Workflow)_.

2. **Choose Workflow:**
   - Select the **Version Control Workflow** as it's the most common and recommended.

3. **Connect to GitHub:**
   - Create a new GitHub repository named `terraform-cloud`.
   - Push your existing Terraform code(s) to this repository.
   - Connect your GitHub account to Terraform Cloud and add the repository to your workspace.

   ![Screenshot: GitHub Workspace Connection](./images/github-workspace.png)  
   ![Screenshot: GitHub Workspace Connection](./images/github-workspace-2.png)  
   *Fig: Connecting GitHub to Terraform Cloud Workspace*
> **Note:** Always allow pop-ups on the browser you are using to access Terraform cloud for the github-terraform workspace connection to be successful
4. **Finalize Workspace:**
   - Provide a descriptive name for your workspace like `github-terraform-cloud`.
   - Leave default settings or adjust as you see fit.
   - Click `Create workspace`.

   ![Screenshot: New Workspace](./images/new-workspace.png)  
   *Fig: Creating a New Workspace*

### Step 4: Configure Variables

Terraform Cloud allows you to manage both environment and Terraform variables securely.

1. **Set Environment Variables:**
   - Add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` with the credentials used in previous projects. 
   > > These credentials will be used to provision your AWS infrastructure by Terraform Cloud

   ![Screenshot: Setting Environment Variables](./images/env-var.png)  
   ![Screenshot: Setting Environment Variables](./images/env-var-2.png)  
   *Fig: Configuring AWS Credentials in Terraform Cloud*

2. **Security:**
   - Mark sensitive variables to ensure they are hidden in the UI and treated as write-only.

### Step 5: Run Terraform Scripts

Before executing Terraform scripts, ensure that Packer and Ansible are installed on your local machine.

---
Let's take a little detour to explain the action plan for this project phase and you will understand why we need packer, ansible, etc... :
#### Action Plan:

- Build images using packer
- confirm the AMIs in the console
- update terrafrom script with new ami IDs generated from packer build
- create terraform cloud account and backend
- run terraform script
- update ansible script with values from teraform output
     - RDS endpoints for wordpress and tooling
     - Database name, password and username for wordpress and tooling
     - Access point ID for wordpress and tooling
     - Internal load balancee DNS for nginx reverse proxy

- run ansible script
- check the 

> **NB:** In our previous project, we talked about using `Packer` to build our images, and `Ansible` to configure the infrastructure, so for that reason we are going to make few changes to our our existing respository from the last project.

below are some explanations of the files that would be added to our repository;

- **AMI:** for building packer images
- **Ansible:** for configuring the infrastructure
---

1. **Install Required Tools:**
   - **Packer:** [Installation Guide](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
   - **Ansible:** [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

   ![Screenshot: Packer Installation](./images/packer-install.png)  
   *Fig: Installing Packer*

   ![Screenshot: Ansible Installation](./images/ansible-install.png)  
   *Fig: Installing Ansible*

2. **Repository Updates:**
   Take a look at this [repository](https://github.com/Kosenuel/IAIUT-AMI-Packer-) and you will know what the contents of the files in these directory seek to achieve. We will replicate the same in our repository.
   - Add Packer templates:
     - `AMI/bastion.pkr.hcl`
     - `AMI/ubuntu.pkr.hcl`
     - `AMI/nginx.pkr.hcl`
     - `AMI/web.pkr.hcl`
     - `AMI/etc...`

   ![Screenshot: Folder Structure](./images/folder-structure.png)  
   *Fig: Updated Repository Structure with AMI Templates*

> **Important: 💡** After you are done _**[Creating the images using packer](./Packer_Build.md)**_, proceed with the steps below.
> **Also Note: 📝** The new ami-ids of your packer-generated ami's are to be supplied to your terraform configuration for consumption

### Step 6: Apply Terraform Changes

1. **Initiate Plan:**
   - First, push your terraform code configs to the github repository integrated with our terraform cloud workspace.
   - Navigate to the `Runs` tab in Terraform Cloud.
   - Click `Run plan` or `Start new run` to preview changes.

   > **Note: 📝** The images you would supply to your terraform config modules should be the packer images ami you have just built.

   ![Screenshot: Queue Terraform Plan](./images/plan0.png)  
   ![Screenshot: Queue Terraform Plan](./images/plan1.png)  
   *Fig: Queuing a Terraform Plan*

2. **Apply Changes:**
   - After a successful plan, click `Confirm and apply`.
   - Provide a meaningful comment and confirm the plan.

   ![Screenshot: Apply Terraform Changes](./images/tf-cloud-apply.png)  
   ![Screenshot: Apply Terraform Changes](./images/tf-cloud-apply2.png)  
   *Fig: Applying Terraform Changes*

   ![Screenshot: Apply Terraform Changes](./images/tf-cloud-error.png)  
   ![Screenshot: Apply Terraform Changes](./images/tf-cloud-error-fix.png)
   *Fig: Errors Encountered and fixes*  

3. **Verification:**
   - Monitor the logs to ensure all operations succeed.
   - Check the AWS Console for newly created resources.

   ![Screenshot: AWS Instances](./images/instances.png)  
   *Fig: AWS EC2 Instances*

### Step 7: Test Automated Terraform Plans

1. **Integrate with GitHub:**
   - Push a change to any `.tf` file in your GitHub repository.
   - Terraform Cloud should automatically trigger a `plan`.

   ![Screenshot: Automated Terraform Plan](./images/tf-auto-plan.png)
   
   #### Ensure to click on the "confirm and apply" button, then watch your infra (infrastructure) gets provisioned.
   ![Screenshot: Automated Terraform Plan](./images/tf-cloud-apply3.png)  
   *Fig: Automated Plan Triggered by GitHub Push*

2. **Review and Apply:**
   - Even though we allowed `plan` to run automatically, we should always ensure that `apply` requires manual approval to prevent unintended changes.

---

## Configuring the Infrastructure With Ansible

After deploying our infrastructure with Terraform, Ansible can be used to configure and manage our instances.

0. **Connect to Bastion Server:**
   - SSH into the Bastion server using the forwarded key.

   ```bash
   ssh -i your-key.pem ec2-user@<bastion-pub-ip>
   ```

   - Verify Ansible installation.

   ![Screenshot: Ansible Version](./images/ansible-version.png)  
   *Fig: Verifying Ansible Installation*

1. **SSH-Agent and AWS Cli Setup:**
   - (Optional) On our bastion machine, we need to forward our SSH key to our Bastion server:
   - Forward your SSH key to the Bastion server.

   ```bash
   eval `ssh-agent -s`
   ssh-add .ssh/Ansible_key
   ssh-add -l # View added keys
   ```

   - Setup Aws cli like so:
      
      > Check out **[this link](https://stackoverflow.com/questions/21440709/how-do-i-get-aws-access-key-id-for-amazon)** to know how to create and see your **aws access key id** and **secret key**
   ```bash
   aws configure
   ```
   #### When prompted, paste the following;
      - Aws access id
      - Aws secret key
      - default region (I used: eu-west-2)
      - default output format: json

   Without running `aws configure`, the ansible inventory wouldn't be able to spool and group your aws instances so that ansible can communicate and configure them.

   ![Screenshot: Update Nginx Configuration](./images/aws-cli-config.png)  
     *Fig: Configuring Aws Cli*

2. **Update Configuration Files:**
   - **Nginx Configuration:**
     - Update the `"internal_alb_dns_name"` variable value in the  `roles/nginx/defaults/main.yml`file with the internal load balancer DNS.

     ![Screenshot: Update Nginx Configuration](./images/update-nginx-conf.png)  
     *Fig: Updating Nginx Configuration*

   - **Database Configurations:**
     - Update the variable values in `roles/<role-name>/defaults/main.yml` for both `tooling` and `wordpress` roles.

     ![Screenshot: Update Tooling DB](./images/update-tooling-vars.png)  
     *Fig: Updating Tooling Database Configuration*

     ![Screenshot: Update Wordpress DB](./images/update-wordpress-vars.png)  
     *Fig: Updating Wordpress Database Configuration*

   - **Push and Pull**
     - Push all your changes to your Ansible repository.

     ![Screenshot: Update Tooling EFS](./images/push-ansible-changes.png)  
     *Fig: Updating Tooling EFS Access Point*

      - Pull your new changes from your repo into your bastion/ansible server

     ![Screenshot: Update Wordpress EFS](./images/pull-ansible-changes.png)  
     *Fig: Updating Wordpress EFS Access Point*

3. **Run Ansible Playbooks:**
   - Export the Ansible configuration path and execute the playbook.

   ```bash
   export ANSIBLE_CONFIG=/home/ec2-user/IAIUT-Ansible/ansible.cfg
   ansible-playbook playbook/site.yml
   ```

   - Run Ansible ping to confirm that ansible can reach all nodes

      ![Screenshot: Running Ansible Ping](./images/ansible-ping.png)  
      *Fig: Ansible Ping*

      It ran successfully, however you might say "Emmanuel, I can see one block of red text that indicates ansible's failure to communicate to a node". Yes, you are correct, it failed to commuicate to that node because that is the bastion/ansible node with that ip (it cannot ssh to itself).

   ![Screenshot: Running Ansible Playbook](./images/run-playbook1.png)  
   *Fig: Executing Ansible Playbook*

   ![Screenshot: Playbook Execution](./images/run-playbook2.png)  
   *Fig: Ansible Playbook Running*

   ![Screenshot: Playbook Completion](./images/run-playbook3.png)  
   *Fig: Ansible Playbook Successful Completion*

4. **Accessing our Deployed Services:**

   Passing our request via the nginx proxy server generated a lot of ssl certification issues for me, so I had to bypass the nginx route and went directly to creating a DNS CNAME record that points to the internal ALB's DNS name, run necessary modificaations and obtain use the valid SSL certificate (from acm) for the custom domain.

   - **Tooling Website:**

     ![Screenshot: Tooling Website](./images/tooling-website.png)  
     *Fig: Accessing Tooling Website*

   - **Wordpress Website:**

     ![Screenshot: Wordpress Website](./images/wp-website.png)  
     *Fig: Accessing Wordpress Website*

---

## Extra Task №1

### 1. Configure Branches for Environments

We are going to set up three branches in our `terraform-cloud` repository to manage different environments: `dev`, `test`, and `prod`.

![Screenshot: GitHub Branches](./images/github-branches.png)  
![Screenshot: GitHub Branches](./images/github-branches2.png)  
*Fig: Creating Development, Testing, and Production Branches*

### 2. Automate Runs for Dev Environment

1. **Create Workspaces:**
   - Create separate workspaces in Terraform Cloud for `dev`, `test`, and `prod`.

   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces.png)  
   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces2.png)  
   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces3.png)  
   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces4.png)  
   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces5.png)  
   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces6.png)  
   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces7.png)  
   ![Screenshot: Creating Multiple Workspaces](./images/create-workspaces8.png)  
   *Fig: Configuring Multiple Terraform Workspaces*

 1.1 **Set Environment Variables:**
   - Add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` with the credentials used in previous projects. 
   > > These credentials will be used to provision your AWS infrastructure by Terraform Cloud.
   **Navigate to** Your-org > Workspaces > your-dev-branch-workspace > Variables
   Then configure like so:

   ![Screenshot: Setting Environment Variables](./images/env-var-dev2.png)  
   ![Screenshot: Setting Environment Variables](./images/env-var-dev3.png)  
   *Fig: Configuring AWS Credentials in Terraform Cloud*

2. **Enable Auto-Apply for Dev:**
   - Navigate to the `dev` workspace.
   - Go to **Settings > General Settings > Auto-apply**.
   - Check the `Auto-Apply` option to allow automatic application after successful plans.

   ![Screenshot: Enable Auto-Apply](./images/auto-run-dev.png)  
   *Fig: Enabling Auto-Apply for Development Environment*

### 3. Set Up Email and Slack Notifications

**Email Notifications:**

1. **Configure Notifications:**
   - Still in the `dev` workspace, navigate to **Settings > Notifications > Create a notification**.
   - Add a new email notification for events like `started plan`, or `errored run` _(but in my case, I checked all the boxes)_.

   ![Screenshot: Email Notification Setup](./images/email-notification-config.png)  
   *Fig: Setting Up Email Notifications*

2. **Test Email Notifications:**
   - Modify the Bastion instance type so as to trigger a plan and we observe the email notifications _(In my case, I modified it to t2.medium)_.

   ![Screenshot: Test Email Notification](./images/test-email.jpg)  
   *Fig: Testing Email Notification on Change*

**Slack Notifications:**

1. **Create a Slack Webhook:**
   - Visit [Slack API: Incoming Webhooks](https://api.slack.com/apps?new_app=1) to create a new app.
      select Create an app > From scratch > Choose a name > Select the workspace you would like to send your notifications to > Create App
   - **Install** the app to your workspace and obtain the Webhook URL.

   ![Screenshot: Create Slack App](./images/create-slack-app.png)  
   *Fig: Creating a Slack App for Webhooks*

   - **Enable Webhooks:**
      After creating the app you will be redirected to the settings page for your new app [if you're using an existing app, you can load its settings via your app's management dashboard](https://api.slack.com/apps). Under the **Features** section, click on the **Incoming webhooks** option and toggle on webhooks.
      
      ![Screenshot: Enabling Webhook](./images/enable-webhook.png)  
      *Fig: Installing Slack App to Workspace*

   - **Create an Incoming Webhook:**
      Now that incoming webhooks are enabled, the settings page should refresh and you will see some additional features. One of these options are very helpful, it's called **"Add a new webhook to workspace"** -- click on it!
      What this button does is to trigger a shortcut version of the installation flow for slack apps, one that is completely self-contained for that matter. So that you don't have to build any code to generate an incoming webhook URL.

   ![Screenshot: Install Slack App](./images/install-slack.png)  
   ![Screenshot: Deploy Slack App](./images/deploy-app.png)  
   ![Screenshot: Integrate Slack App](./images/Integrating-app.png)  
   *Fig: Installing/Integrating Slack App to Workspace*

   - **After Integrating** the new slack app to your slack channel, check your app settings and you should see a new entry under the **Webhook URLs** section, the webhook url would look like this:
   ![Screenshot: New Slack App](./images/new-webhook-url.png)
   ```bash
   https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
   ```
   This url is what we would copy into our Terraform cloud for our notification config.

2. **Configure Webhook in Terraform Cloud:**
   - In Terraform Cloud dev workspace, go to **Settings > Notifications**.
   - Add a new Slack notification using the Webhook URL.

   ![Screenshot: Slack Notification Setup](./images/create-slack-notification.png)  
   *Fig: Configuring Slack Notifications in Terraform Cloud*

3. **Test Slack Notifications:**
   - Revert the Bastion instance type, save and push your change and confirm the notification appears in Slack.

   ![Screenshot: Test Slack Notification](./images/test-slack-notify.png)  
   *Fig: Slack Notification Upon Terraform Apply*

### 4. Apply and Destroy Infrastructure

1. **Apply Changes:**
   - Observe automatic `plan` and `apply` actions in Terraform Cloud linked to the `dev` workspace.
   [Auto Plan Image Here](https://github.com/Kosenuel/DevOps_CloudEngr-StegHub/blob/main/18.(Iac)_Automating_Infrastructure_Using_Terraform_Part_3/images/auto-plan-n-apply.png)
   ![Screenshot: Bastion Change](./images/bastion-change.png)  
   ![Screenshot: Email Notification](./images/email-notify.png)  
   ![Screenshot: Slack Notification](./images/slack-notify.png)  
   ![Screenshot: Auto-Apply Confirmation](./images/auto-run.png)  
   *Fig: Auto-Apply Triggered by Terraform Cloud*

   > **Note:** This apply failed because an Identical set of resources are already existing in the aws environment (created by your first workspace)

2. **Destroy Infrastructure:**
   - From the Terraform Cloud dev workspace web console, navigate to **Settings > Destruction and Deletion** to tear down our resources.

   ![Screenshot: Queue Destroy](./images/queue-destroy.png)  
   ![Screenshot: Queue Destroy](./images/queue-destroy2.png)  
   ![Screenshot: Queue Destroy Slack Notification](./images/slack-destroy-notify.png)  
   *Fig: Initiating Destroy Operation*

   ![Screenshot: Queue Destroy](./images/queue-destroy-successful.png)  
   *Fig: Destroy Operation Successful*

---

## Public vs. Private Module Registry

Terraform's Module Registry allows us to be able to reuse our configurations to promote efficiency and consistency.

- **Public Registry:**
  - Community-contributed modules.
  - Browsable and searchable via [Terraform Registry](https://registry.terraform.io/browse/modules).

- **Private Registry:**
  - Create and manage proprietary modules.
  - Ideal for organizational use to encapsulate internal best practices.

![Screenshot: Terraform Module Registry](./images/terraform-module-registry.png)  
*Fig: Public vs. Private Module Registry*

**Resource:** [Terraform Module Registry Documentation](https://developer.hashicorp.com/terraform/registry)

---

## Extra Task №2

### Working with a Private Repository

We will enhance our Terraform workflow by creating and utilizing private modules within our organization.

### 1. Creating a Terraform Module Repository

1. **Clone or Create a Repository:**
   - Clone an existing module repository like [This HashiCorp's module repo](https://github.com/hashicorp-education/learn-private-module-aws-s3-webapp) or create a new one.

   ![Screenshot: Module Repository](./images/module-repo.png)  
   *Fig: Creating a Terraform Module Repository*

2. **Tagging the Module:**
   - Navigate to the repository's **Releases** tab.
   - Create a new release, we will tag it as `v1.0.0`.

   ![Screenshot: Create Module Release](./images/releasev1.png)  
   *Fig: Tagging Module Version*

### 2. Importing the Module into our Private Registry

1. **Adding the Module to our Registry:**
   - Head over to your Terraform web console, go to **Registry > Module > Publish > Module** in Terraform Cloud.
   - Select **GitHub (Custom)** and connect our repository.

   ![Screenshot: Add Module to Registry](./images/add-module-repo.png)  
   *REmember to add your github repo like this `Kosenuel/Aws-s3-webapp-terraform` instead of `https://github.com/Kosenuel/Aws-s3-webapp-terraform.git`*

   ![Screenshot: Add Module to Registry](./images/publish-module-repo.png)  
   ![Screenshot: Add Module to Registry](./images/added-private-module-repo.png)  
   *Fig: Adding Module to Private Registry*

2. **Configuring our Credentials:**
   - Create an API token in Terraform Cloud (by going to **Account Settings > Tokens > Create an Api token > Generate an organization token**).
   - We will add the token to our Terraform CLI configuration (`~/.terraformrc`) or you can export it as an environment variable (whatever method  that pleases us).

   ```hcl
   credentials "app.terraform.io" {
     token = "xxxxxxxxx.atlasv1.zzzzzzzzzzzzzzzzz"
   }
   ```
    or

   ```bash
   export TF_TOKEN_app_terraform_io="xxxxxxxxx.atlasv1.zzzzzzzzzzzzzzzzz"
   ```

   ![Screenshot: API Token Creation](./images/create-api-token.png)  
   ![Screenshot: API Token Creation](./images/create-api-token2.png)  
   ![Screenshot: API Token Creation](./images/apply-api-token.png)  
   *Fig: Creating and Applying API Token for Module Registry*

   > **Note:** The reason we are doing this is to allow our terraform localhost cli communicate to our terraform cloud workspace.

### 3. Using the Module in our Configuration

1. **Integrating the Module:**
   - In our local configuration directory, we will create a `main.tf` file.
   - We will use the **Copy Configuration** feature from the module's **Usage Instructions** and paste it into `main.tf`.

   ![Screenshot: Module Usage Instructions](./images/usage-instruction.png)  
   *Fig: Copying Module Usage Instructions*

2. **Example Module Integration:**

   ```hcl
      module "webapp-terraform" {
         source  = "app.terraform.io/kosenuel-org/webapp-terraform/s3"
         version = "1.0.0"
         
         prefix      = "kosenuel"
         name        = "webapp"
         region      = "eu-west-2"
      }
   ```

   ![Screenshot: Module Usage in Configuration](./images/module-consumption.png)  
   *Fig: Using the Private Module in Our Terraform Configuration*

### 4. Initialize and Deploy

1. **Initialize Terraform:**
   - Run `terraform init` to set up the backend and download modules.

   ```bash
   terraform init
   ```

   ![Screenshot: Terraform Initialization](./images/tf-init.png)  
   *Fig: Terraform Initialization Process*

2. **Create a workspace for the configuration to run through:**
   - Select **CLI-driven workflow**, and Name the workspace s3-webapp-workspace

   ![Screenshot: Terraform Apply](./images/create-s3-webapp-ws.png)  
   ![Screenshot: Terraform Apply](./images/create-s3-webapp-ws2.png)  
   *Fig: Applying Terraform Configuration (I had to apply this config twice for it to work fully)*


   > **Note:** Ensure to create environment variables for your new workspace so that it can be able to communicate with your aws environment.
   ![Screenshot: Creating Aws environment variables to hold our credentials](./images/setup-env-vars.png)
   *Fig: Creating Aws environment variables to hold our credentials*

3. **Deploying our Infrastructure:**
   - Make sure you include in your `main.tf` or any `.tf` file, the code to link your terraform cli to your s3-webapp-workspace like so:
      ```hcl
         terraform { 
      cloud { 
         
         organization = "kosenuel-org" 

         workspaces { 
            name = "s3-webapp-workspace" 
         } 
      } 
      }
      ```
   - After including it, run `terraform init` so that everything would gel.
   ![Screenshot: Terraform Apply](./images/tf-init2.png)  
   *Fig: Applying Terraform Configuration (I had to apply this config twice for it to work fully)*

      ```hcl
         terraform {
      required_version = ">= 1.0.0"
      }

      provider "aws" {
         region = "eu-west-2"
      }

      terraform { 
      cloud { 
         
         organization = "kosenuel-org" 

         workspaces { 
            name = "s3-webapp-workspace" 
         } 
      } 
      }

      module "webapp-terraform" {
         source  = "app.terraform.io/kosenuel-org/webapp-terraform/s3"
         version = "1.0.0"
         
         prefix      = "kosenuel"
         name        = "webapp"
         region      = "eu-west-2"
      }
      ```
      *Final `main.tf` config*

   - Apply the configuration to deploy resources we defined in the module.

   ```bash
   terraform apply
   ```

   ![Screenshot: Terraform Apply](./images/tf-apply.png)  
   *Fig: Applying Terraform Configuration (I had to apply this config twice for it to work fully)*
   > **I believe** the reason that made me have to run this apply operation twice was because terraform was trying
   to populate an s3 bucket that hasn't been fully created yet.


   ![Screenshot: Terraform Cloud Run](./images/tf-cloud-run.png)  
   *Fig: Terraform Cloud Running Apply Operation*

3. **Verifying our Deployment:**
   - Confirm the creation of S3 buckets and access objects.

   ![Screenshot: S3 Bucket and Objects](./images/s3.png)  
   *Fig: S3 Bucket Created by Terraform*

   ![Screenshot: S3 Bucket Object](./images/s3-object.png)  
   *Fig: Uploaded Object in S3 Bucket*

   - Access the deployed web application.

   ![Screenshot: Web Application](./images/s3-endpoint-game-website.png)  
   *Fig: Accessing our Deployed Web Application via our s3 endpoint url*

### 5. Destroy the Deployment

1. **Destroying our Resources:**
   - Run `terraform destroy` to tear down the deployed infrastructure.

   ```bash
   terraform destroy
   ```

   ![Screenshot: Terraform Destroy](./images/tf-destroy.png)  
   *Fig: Running Terraform Destroy*

   ![Screenshot: Terraform Cloud Destroy](./images/tf-cloud-destroy.png)   *Fig: Terraform Cloud Running Destroy Operation*


---

## Conclusion

In this project, we have successfully:

- **Migrated our Terraform Configurations to Terraform Cloud:** Leveraging remote state management and collaborative workflows.
- **Integrated Packer and Ansible:** This helped us to automate image creation and instance configuration.
- **Set Up Automated Workflows:** We achieved this feat using Terraform Cloud's version control integration and notifications.
- **Implemented Best Practices:** Including security considerations and cost optimization strategies.
- **Utilized Private Module Registries:** This helped us to enhance our code reuse and maintainability.

When we follow these steps we will always ensure that we have a scalable, secure, and efficient infrastructure management process.

---

## References

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [AWS Terraform Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Cloud](https://www.terraform.io/cloud)
- [Ansible Documentation](https://docs.ansible.com/)
- [Packer Documentation](https://www.packer.io/docs)
- [Terraform Module Registry](https://registry.terraform.io/browse/modules)
- [AWS Best Practices](https://aws.amazon.com/architecture/well-architected/)
- [Slack Webhook Configuration](https://api.slack.com/messaging/webhooks?form=MG0AV3)

---
---
---
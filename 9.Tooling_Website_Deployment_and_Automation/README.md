# Automating Website Deployment with Jenkins: A Continuous Integration Approach

In this project, we will explore how to streamline our development workflow by automating routine tasks using Jenkins, a popular open-source automation server widely used for Continuous Integration and Continuous Deployment (CI/CD).

Continuous Integration, as defined by CircleCI, is a software development strategy tshat accelerates development while maintaining code quality. It involves de1pp1velopers frequently committing small code increments, which are automatically built and tested before merging with the shared repository.

## What we intend to achieve

We will enhance our existing architecture by integrating a Jenkins server and setting up an automated job. This job will deploy source code changes from Git to our NFS server whenever updates occur.

Illustrated below, is a visual representation of our updated architecture:

![Updated architecture diagram](./images/architecture.png)

# Step 1: Setting Up the Jenkins Server

## 1. Launch an EC2 Instance for Jenkins

Let us start by creating an AWS EC2 instance based on Ubuntu Server 24.04 LTS. We will name this instance "Jenkins".

![Creating Jenkins EC2 instance](./images/create-jenkins-ec2.png)
![Jenkins EC2 instance details](./images/ec2-detail-jenkins.png)

## 2. Install Java Development Kit (JDK)

Jenkins is a Java-based application, so we need to install the JDK.

First, let us access our new instance:

```bash
ssh -i "my-devec2key" ubuntu@<your host ip>
```
![SSH into Jenkins instance](./images/ssh-jenkins.png)

Now, let's update the instance:

```bash
sudo apt-get update
```
![Updating Ubuntu](./images/update-jenkins-ubuntu.png)

Next, we will download the Jenkins key:

```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
```
![Downloading Jenkins key](./images/download-jenkins-key.png)

Add the Jenkins repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```
![Adding Jenkins repository](./images/add-jenkins-repo.png)

Now, let us install Java. Jenkins requires a specific version, so we'll install OpenJDK 17:

```bash
sudo apt install fontconfig openjdk-17-jre
```
![Installing JDK](./images/install-jdk.png)

## 3. Install Jenkins

First, let's update Ubuntu again:

```bash
sudo apt-get update
```
![Updating Ubuntu repositories](./images/update-repo.png)

Now, we can now install Jenkins:

```bash
sudo apt-get install jenkins -y
```
![Installing Jenkins](./images/install-jenkins.png)

Let us make sure Jenkins is up and running:

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```
![Checking Jenkins status](./images/jenkins-status.png)

## 4. Configure Security Group

Jenkins uses TCP port 8080 by default. We need to open this port by creating a new inbound rule in the EC2 Security Group.

![Configuring Jenkins security rule](./images/jenkins-security-rule.png)

## 5. Initial Jenkins Setup

Access Jenkins through your web browser at `http://<Jenkins-Server-Public-IP-Address>:8080`.

You will be prompted for an admin password. Retrieve it from the server:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
![Unlocking Jenkins](./images/unlock-jenkins.png)

Next, we will be asked to choose plugins. Select the suggested plugins.

![Installing Jenkins plugins](./images/install-plugins.png)
![Plugin installation progress](./images/plugin-progress.png)

After the plugins are installed, create an admin user. You'll then see the Jenkins server address.

![Jenkins instance configuration](./images/jenkins-instance-config.png)

Congratulations! The installation is now complete.

![Jenkins ready screen](./images/jenkins-is-ready.png)

# Step 2: Configuring Jenkins for GitHub Integration

Now, we'll set up Jenkins to retrieve source code from GitHub using webhooks.

## 1. Enable GitHub Webhooks

In your GitHub repository:

1. Go to Settings
2. Click on Webhooks
3. Click "Add webhook"

![Configuring GitHub webhook](./images/webhook-config.png)

## 2. Create a Jenkins Freestyle Project

1. In the Jenkins web console, click "New Item"
2. Create a "Freestyle project"

![Creating Jenkins project](./images/create-jenkins-project.png)

To connect our GitHub repository, we need its URL, e.g:

```
https://github.com/kosenuel/tooling2.git
```
![Copying GitHub repo URL](./images/cp-github-repo.png)

In the Jenkins project configuration, choose Git (repository) and provide the link to your Tooling GitHub repository along with your credentials.

![Configuring SCM (source code manager) in Jenkins](./images/config-scm-jenkins.png)

Save the configuration and run the build manually by clicking "Build Now". If everything is set up correctly, you should see a successful build (like Build #1 in the image).

![Successful Jenkins build](./images/build-1.png)

## 3. Configure Automated Builds

Let's set up automated builds triggered by GitHub webhooks:

1. Click "Configure" for your job/project
2. Set up "triggering the job from GitHub webhook"
3. Configure "Post-build Actions" to "archive all the files"

![Configuring post-build actions](./images/post-build-action.png)

Now, make a change in your GitHub repository (e.g., edit the README.MD file) and push it to the main branch.

![Editing README on GitHub](./images/edit-readme.png)

You should see a new build launched automatically by the webhook, with the results (artifacts) saved on the Jenkins server.

![Build artifacts](./images/build-artifact-3.png)
![Build #3 artifacts](./images/build-3-artifact.png)

We have now set up an automated Jenkins job that receives files from GitHub via webhook triggers. This method is considered a "push" because GitHub initiates the file transfer when changes are pushed.

By default, artifacts are stored locally on the Jenkins server:

```bash
ls /var/lib/jenkins/jobs/tooling_github/builds/<build_number>/archive/
```
![Jenkins server artifact](./images/jenkins-server-artifacts.png)
and this below:
![Jenkins server artifacts](./images/jenkins-server-artifact.png)

# Step 3: Configuring Jenkins to Copy Files to NFS Server

Now that we have our artifacts saved locally on the Jenkins server, let's set up Jenkins to copy them to our NFS server's `3uikolp; n  ctory.

We will use the "Publish Over SSH" plugin for this task.

## 1. Install the Publish Over SSH Plugin

1. On the main dashboard, go to "Manage Jenkins" > "Manage Plugins"
2. Click on the "Available" tab
3. Search for "Publish over SSH" and install it without restarting

![Searching for Publish over SSH plugin](./images/search-publish-ssh.png)
![Installing Publish over SSH plugin](./images/install-pub-ov-ssh-plugin.png)

## 2. Configure Jenkins to Copy Artifacts to NFS Server

1. On the main dashboard, go to "Manage Jenkins" > "Configure System"
2. Scroll down to the "Publish over SSH" plugin configuration section

Configure the plugin to connect to your NFS server:

- Provide a private key (content of .pem file used to connect to NFS server via SSH)
- Add an arbitrary name
- Enter the hostname (private IP address of your NFS server)
- Set the username as "ec2-user" (assuming your NFS server is an EC2 instance with RHEL 9)
- Set the remote directory as "/mnt/apps" (the mounting point for your web servers)

![Configuring NFS in Jenkins](./images/config-nfs-ssh-jenkins.png)

Test the configuration to ensure a successful connection. Remember to open TCP port 22 on your NFS server to allow SSH connections.

![Testing SSH configuration](./images/test-config.png)

Save the configuration, then open your Jenkins job/project configuration page and add another Post-build Action ("Send build artifacts over SSH").

Configure it to send all files produced by the build to your previously defined remote directory. Use "**" to copy all files and directories.

![Configuring NFS SSH in Jenkins](./images/add-another-post-build-action.png)
![Configuring NFS SSH in Jenkins 2](./images/add-another-post-build-action-2.png)

Save this configuration and make another change in the README.MD file in your GitHub Tooling repository.

![Editing README again](./images/edit-readme2.png)

The webhook should trigger a new job.

![Unstable build #4](./images/unstable-build-4.png)

If you encounter an error in the build, you may need to adjust permissions on the NFS server. Ensure the target directory (/mnt) and its contents have the correct permissions that allows for reading and writing contents to the `/mnt/apps` directory.

If the permissions are not properly, set, kindly fix this else, try disabling the selinux enforcement of the nfs server by following the below:
- Open the selinux config file by running: ` sudo vim /etc/selinux/config`.
- Find a line that looks like `SELINUX=enforcing`
- And change the setting to `SELINUX=disabled` 
- Reboot the nfs server like so: `sudo reboot`
- Check the status of `SELINUX` in the os by running this command `sestatus`, you should expect to see `SELinux status:  disabled`

![Disabling SELinux](./images/disable-selinux.png)

Run the build again from the Jenkins GUI. The webhook should trigger a new job, and you should see a success message in the Console Output:

```bash
SSH: Transferred 24 file(s)
Finished: SUCCESS
```

![Successful NFS transfer in build #5](./images/build-5-nfs-transfer.png)

To verify that the files in `/mnt/apps` have been updated, connect via SSH to your NFS Server and check the README.MD file:

```bash
ls /mnt/apps

# or

ls -l /mnt/apps
```
![Checking artifacts on NFS](./images/check-artifacts.png)

```bash
cat /mnt/apps/README.md
```
![Verifying README content on NFS](./images/check-readme-artifact.png)

If you see the changes you previously made in your GitHub repository, congratulations! Your Jenkins job is working as expected.

This setup now automatically deploys your code changes from GitHub to your NFS server, thus, streamlining your development workflow and enabling continuous integration.
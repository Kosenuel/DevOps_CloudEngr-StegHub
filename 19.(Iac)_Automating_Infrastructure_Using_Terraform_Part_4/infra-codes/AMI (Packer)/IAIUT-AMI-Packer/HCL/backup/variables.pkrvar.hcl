region = "eu-west-2"

tags = {
    Owner = "DevOps Team"
    Project = "Terraform-Cloud"
    Environment = "dev"
}

bastion_public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLjnhQa+AhbWnG8kwr2lPeSa0d3WGAnmOUaeWWReCkKBnIpkvXlIQ9ILUuddV7t956nK/Q4qRhDvglmfB06u7Vh+OienTg1LZdCCtOrjbJlIxLgAtLjeEn/Puvq2aWCcVykOBl5ylJoGaS7GrolBwl13WWhHWyU34XQy0ky1BlIQorg/R9NOfisaY4eieh6M7pdENE1yuLLL3X3NpZTAOfdzKHbTafDWSnvEJdN+mPREl9YdzZOpy1UmUKtgX48Q4QPXsWm/G0Qf901EQAK1g4yqPBp32IV3xSa3S7PqutBP/FaMXecjsj6cG6ZiyUU/yAka8gSrbT9Z0VswTFQBiEZStPLba7ni3WkC4Syv3HRvtoe5JBjwJ/Cn+4sDbc3MCPWJvKFBfHWRBVTCmPkGh1/LHqtK5B05kYizgISwRXPxJYrar5RTQUcMZq3NgfW0M/3K/YcooWH6G7+Y+CmDXYvZQX8H2+KAQK5lm260yBP/a67VKjJ5+igthcirSCOdMidH+LJIKfJ58j/2grUbadhiAfx2+DmwUDr6YhO0u4JsPWAwSwxOU4dBobDD1dq6PCkyuU+n7CZlLLwZWBzSf4Zv1/XUd9Y1M1vU9wHV2QKIHqaxV+NxwMiUSFYMs4hUt01YJpUteOyTkiee2R4VYcAhY8StvSYz8e7G20C6QvaQ== ec2-user@ip-172-31-18-113.eu-west-2.compute.internal"
source_ami           = "ami-0f9535ac605dc21d5" # Bro, remember to replace with the latest RHEL AMI ID. This is for web instances.
# source_ami           = "ami-0aa938b5c246ef111" # Bro, remember to replace with the latest CentOs AMI ID. This is for web instances.
source_ami_ubuntu    = "ami-091f18e98bc129c4e" # Bro, remember to replace with the latest Ubuntu AMI ID
source_ami_bastion   = "ami-0aa938b5c246ef111" # Bro, remember to replace with the latest CentOs AMI ID
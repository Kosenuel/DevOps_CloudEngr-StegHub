# AWS IAM Role Policies: Assume Role vs Role Policies

## Overview

AWS Identity and Access Management (IAM) roles use two distinct types of policies to manage access:
1. Assume Role Policy (Trust Policy) - This controls **who** can use the role
2. Role Policy - Defines **what** the role can do

## Assume Role Policy (Trust Policy)

A Trust Policy determines which entities can assume (use) an IAM role. It establishes the trust relationship between the role and other AWS entities.

### Components

- **Principal**: The entity allowed to assume the role (AWS services, IAM users, other roles)
- **Action**: Usually `sts:AssumeRole`
- **Effect**: Allow/Deny
- **Optional Conditions**: Additional requirements for assuming the role

### Example Trust Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

## Role Policy (Permission Policy)

A Role Policy defines the actual permissions granted to the role. It specifies which AWS resources can be accessed and what actions can be performed.

### Components

- **Action**: AWS service actions (e.g., `s3:GetObject`, `ec2:StartInstances`)
- **Resource**: AWS resource ARNs
- **Effect**: Allow/Deny
- **Optional Conditions**: Circumstances under which permissions apply

### Example Role Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ]
    }
  ]
}
```

## Quick Reference: Differences between Assume Role Policy and a Role Policy

| Feature | Assume Role Policy | Role Policy |
|---------|-------------------|-------------|
| Purpose | Controls who can use the role | Defines what the role can do |
| Primary Focus | Trust relationships | Permissions |
| Key Action | `sts:AssumeRole` | Service-specific actions |
| Attachment | One per role | Multiple policies possible |

## Best Practices to follow

1. **Least Privilege**: Grant minimum necessary permissions in Role Policies
2. **Specific Trust**: Limit role assumption to specific principals
3. **Use Conditions**: Add extra security with condition statements where necessary
4. **Regular Review**: Audit both policy types periodically
5. **Documentation**: Maintain clear documentation of policy purposes

## Common Use Cases

1. **EC2 Instance Roles**: Allow EC2 instances to access AWS services
2. **Cross-Account Access**: Enable secure access between AWS accounts
3. **Service-Linked Roles**: Allow AWS services to perform actions on your behalf
4. **Application Roles**: Grant applications specific AWS service permissions

## Conclusion

It is important to understand the distinction between Assume Role and Role Policies, this is crucial for AWS IAM security:
- Assume Role Policy controls access **to** the role
- Role Policy controls access **by** the role

They work hand-in-hand to provide a comprehensive access control mechanism for AWS resources.









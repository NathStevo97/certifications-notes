# 3.0 - Identity and Access Management

## 3.1 - Securing the Root Account

- IAM = Identity Access Management
- Allows management of users and their access to the AWS Console via:
  - User creation and granting of permissions
  - Group and role creation for ease of management
  - Access control to particular AWS resources

### Root Account

- The email address used to sign up for AWS
- Has full administrative access to AWS, it must therefore be secured.

### Securing the AWS Account

- From the Console -> IAM
- Options presented for:
  - Rotate credentials regularly
  - Multi-Factor Authentication (MFA) e.g. Google Authenticator

### Summary

- Securing the root AWS account is achieved via:
  - Enabling MFA
  - Creating an admin group for administrators and assigning appropriate permissions
  - Create user accounts for administrators and add them to the admin group.

---

## 3.2 - Controlling Users' Actions with IAM Policy Documents

- Permissions using IAM are assigned via JSON Policy Documents
- An example policy follows:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
```

- Policies are typically comprised of one or more Statement, within each statement one finds:
  - Effect - Are the actions defined for the associated resources allowed or prohibited?
  - Action - What actions does this statement apply to e.g. Read, Write, etc?
  - Resource - What resources are affected by this statement?

- Policies can be assigned to groups, users, and roles.
  - Typically, only groups and roles will be assigned policies, any users assigned to these will then inherit the permissions.

- From the console:
  - AWS Console -> IAM
  - Access Management -> Policies
    - Many default policies are provided by Amazon, typically prefixed by "Amazon", or noted by "AWS Managed" in the Type column
  - Custom policies can be defined via the "Create Policy" option, however AWS has so many, most people just use what they provide.
  - Policy content can be viewed for confirmation on "what policy does what".

---

## 3.3 - Permanent IAM Credentials

### Building Blocks of IAM

- Users
- Groups: Functions such as admins, developers, which users get assigned to.
- Roles: Used internally within AWS to allow services of AWS to interact with one another

- It's best practice to have users inherit permissions from roles and groups.
  - That's not to say they cannot be applied to users directly, but it would be much harder to manage.

- It's never advised to share an account across multiple users

### Principle of Least Privilege

- Only assign a user the *minimum* amount of privileges they need to do their job.
- Common example, you'd not give the finance team the same permissions as developers interacting with EC2 instances.

### Demo

- AWS Console -> IAM -> Create User
  - Console access and / or programmatic access selected
  - Permissions added from group / role etc -> create an groups desired
  - Add any tags desired in key-value pairs
  - Outputs (ONLY VIEWABLE ONCE):
    - Access Key (used for programmatic access)
    - Secret Access Key (used for programmatic access)
    - User Password

- View user from Users and / or Groups under "Access Management" in the left sidebar.

- Additionally from the sidebar, one can view Account Settings and Identity Providers:
  - Account Settings can configure password rotation and reusability
  - Identity providers can be used to configure Single-Sign-On if desired

- **Note:** By default, if no permissions are provided, users will not be able to do anything -> In line with the principle of least privilege

---

## 3.4 - IAM Exam Tips

- The root account can be secured by:
  - Enabling MFA for the root account
  - Create an admin group for administrators and assign appropriate permissions to this group
  - Create user accounts for administrators
  - Add users to the admin group

- Permissions are assigned via IAM policy documents:
  - These are a series of statements outlining the actions allowed / prohibited against particular resources or services.

- IAM is universal, it does not apply to regions
- Root account is the account created upon initial AWS setup and has full access to AWS, it should be secured ASAP
- Users are created with no permissions unless specified upon creation

- Access and Secret Keys are used for AWS CLI (or applicable) access, they are not the same as Username/Password credentials
  - They are only viewable once, like passwords

- Password rotations should always be used
- Existing user accounts can be liked to IAM via IAM Federation and SAML.

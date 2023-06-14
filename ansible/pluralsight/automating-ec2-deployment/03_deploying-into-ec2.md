# 3.0 - Deploying into EC2

##  3.1 - Provisioning the VPC

- VPC = logically isolated virtual network across an AWS region containing the whatever resources you want.
  - Protects instances from network intrusion and allows control of network traffic to/from resources.

- Base playbook (no tasks):

```yaml
- name: Start
  hosts: localhost
  remote_user: testuser
  gather_facts: false
  vars_Files:
  - vars/info.yml
```

- Tasks-wise, each AWS resource provisioned will require its own module, a breakdown follows:

| Task                           | Module                |
| ------------------------------ | --------------------- |
| Configure the VPC              | `ec2_vpc_net`         |
| Configure the Internet Gateway | `ec2_vpc_igw`         |
| Configure the public subnet    | `ec2_vpc_subnet`      |
| Configure a routing table      | `ec2_vpc_route_table` |
| Configure a security group     | `ec2_group`           |

### VPC Configuration

- Example task:

```yaml
tasks:
  - name: Create a VPC
    ec2_vpc_net:
      aws_access_key: "{{ aws_access_key }}"
      aws_secret_key: "{{ aws_secret_key }}"
      region: "{{ aws_region }}"
      name:  test_vpc_net
      cidr_block: 10.10.0.0/16
      tags:
        module: ec2_vpc_net
      tenancy: default
    register: ansibleVPC

  - name: debug VPC
    debug:
      var: ansibleVPC
```

- Anything with `"{{ }}"` is a variable loaded from the variables.
- **Note:** Each variable will have its own required parameters, in the case of above, it;s `name` and `cidr_block`
- If tenancy's set to `default`, new instances run on shared hardware. If `dedicated`, new instances will run on single-tenant hardware.
- The result / output of the task creating the VPC is registered to a new variable `ansibleVPC`, which is then passed to the debug module to inspect the task.

- **Note:** - One can check the playbook syntax with `ansible-playbook --syntax-check <playbook>.yaml` in the directory of the playbook

### Creating the Internet Gateway

- Advised parameters:
  - `aws_access_key` - (as before)
  - `aws_secret_key` - (as before)
  - `region` - (pass from variable)
  - `ec2_url` - The URL to use to connect to EC2.
  - `state` - should the Internet Gateway be **present** or **absent**
  - `tags`
  - `vpc_id` - VPC ID for the IGW to be associated with, obtainable via the registered variable from the VPC task via `ansibleVPC['vpc']['id']` or `ansibleVPC.vpc.id`

- Example usage:

```yaml
- name: Create the Internet Gateway
  ec2_vpc_igw:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    state: present
    vpc_id: "{{ ansibleVPC.vpc.id }}"
    tags:
      name: ansibleVPC_IGW
  register: ansibleVPC_igw

- name:
  debug:
    var: ansibleVPC_igw
```

### Creating the Subnet(s)

- Required parameter:  `vpc_id` - reference in a similar manner to how it was in the internet gateway task.
- Example Usage:

```yaml
- name: Create the Public Subnet
  ec2_vpc_subnet:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    state: present
    cidr: 10.10.0.0/16
    vpc_id: "{{ ansibleVPC.vpc.id }}"
    map_public: yes
    tags:
      name: public_subnet
  register: public_subnet

- name: show public subnet details
  debug:
    var: public_subnet
```

- **Note:** - Usage of the `map_public` parameter assigns instances a public ip address by default
- The results of the task are registered to the `public_subnet` variable for use later in the play

### Creating the Routing Table

- Requires the ID of the VPC and IGW, which can be referenced via the registered variable defined with each task
- Example usage:

```yaml
- name: create a new route table for pulbic subnet
  ec2_vpc_route_Table:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    state: present
    vpc_id: "{{ ansibleVPC.vpc.id }}"
    tags:
      name: rt_ansibleVPC_PublicSubnet
    subnets:
    - "{{ public_subnet.subnet.id }}"
    routes:
    - dest: 0.0.0.0
      gateway_id: "{{ ansibleVPC_igw.gateway_id }}"

- name: display public route table
  debug:
    var: rt_ansibleVPC_PublicSubnet
```

- `routes` defines a list of routes to be added to the route table
  - each route in the list is a dictionary comprising of, at minimum:
    - `dest` - the networking being routed to, `0.0.0.0` is the default
    - `gateway_id` is the ID of the IGW for the route to be associated with the route.

###  Creating the Security gROUP

- Example Usage:

```yaml
- name: Create Security Group
  ec2_group:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    name: "Test Security Group"
    description: "Test Security Group"
    vpc_id: "{{ ansibleVPC.vpc.id }}"
    tags:
      name: Test Security Group
    rules:
    - proto: "tcp"
      ports: "22"
      cidr_ip: 0.0.0.0/0
  register: my_vpc_sg

- name: Set security group ID as variable
  set_fact:
    sg_id: "{{ my_vpc_sg.group_id }}"
```

##  3.2 - Provisioning EC2 Instances

- Steps to create the EC2 Instance:
  1. Specify the AMI desired
  1. Declare the instance type
  1. Associate an SSH key with the instance
  1. Attach a security group
  1. Attach a subnet
  1. Assign a public IP address

- Upon creation, you can use other Ansible modules to provision and configure it further, e.g. deploy an application on it.

### Finding an Existing AMI

- AWS has many AMIs available for use, their IDs typically vary from region to region -> need to programmatically determine what's required for the deployment.
- One can leverage the `ec2_ami_info` module (formerly `ec2_ami_facts`)

- Example Usage:

```yaml
- name: Find AMIs published by Red Hat (309956199498) that are Non-beta and x86 architecture
  ec2_ami_info:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    owners: 309956199498
    filters:
      architecture: x86_64
      name: RHEL-8*HVM-*
  register: amis

- name: Show the AMIs
  debug:
    var: amis

- name: Get the latest AMI from the list provided:
  set_fact:
    latest_ami: "{{ amis.images | sort(attribute='creation_date') | last }}"
```

- `filter` dictionary filters the list of amis returned that are owned by the specified `owners`
- The list is registered as `amis`
- The `set_fact` task then filters the list of images for the one with the most recent creation date and saves it as a new variable

## Creating the SSH Key Pair for the EC2 Instance

- If you don't already have a key pair, one can be created via the `ec2_key` module.
- For EC2 instance, an SSH key located in the same region must be used to ensure secure credential management.
- Requires a `name` (SSH key name defined in vars file)
- The `copy` module can be used to save the private key locally.

- Example Usage:

```yaml
- name: Create SSH Key
  ec2_key:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    name: "{{ ssh_keyname }}"
  register: ec2_key_result

- name: Save private key
  copy:
    content: "{{ ec2_key_result.key.private_key }}"
    dest: "./demo_key.pem"
    mode: 0600
  when: ec2_key_result.changed
```

### Create the EC2 Instance

- Leverages the data from previous tasks, in particular:
  - `image: "{{ latest_ami.image_id }}"`
  - `group_id: "{{ my_vpc_sg.group_id }}"`
  - `vpc_subnet_id: "{{ public_subnet.subnet.id }}"`

- Example Usage:

```yaml
- name: Provision the EC2 Instance
  ec2:
    aws_access_key: "{{ aws_access_key }}"
    aws_secret_key: "{{ aws_secret_key }}"
    region: "{{ aws_region }}"
    image: "{{ latest_ami.image_id }}"
    instance_type: t2.micro
    key_name: "{{ ssh_keyname }}"
    count: 2
    state: present
    group_id: "{{ my_vpc_sg.group_id }}"
    wait: yes
    vpc_subnet_id: "{{ public_subnet.subnet.id }}"
    assign_public_ip: yes
    instance_tags:
      name: new_demo_template
  register: ec2info

- name: print the results:
  debug:
    var: ec2info
```

- Once created, one can verify the EC2 instance operation via the AWS Console, SSH via the key pair and/or connect via the AWS Console.

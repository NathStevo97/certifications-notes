# 4.0 - Generating an Inventory of EC2 Instances

- [4.0 - Generating an Inventory of EC2 Instances](#40---generating-an-inventory-of-ec2-instances)
  - [4.1 - Using a Dynamic Inventory Script](#41---using-a-dynamic-inventory-script)
    - [Using a Dynamic Inventory Script](#using-a-dynamic-inventory-script)
  - [4.2 - Using the AWS EC2 Inventory Plugin](#42---using-the-aws-ec2-inventory-plugin)
    - [Inventory Plugins](#inventory-plugins)

## 4.1 - Using a Dynamic Inventory Script

- At small resource numbers, management is easy. In practice, one could be dealing with anywhere from  10,000 - 100,000 instances (or more).
  - Each of these instances may have frequently changing IPs (either they're spun up on-demand or frequently autoscaled)
- To help manage these, one can utilise `EC2.py` and `EC2.ini` files, which leverage the AWS CLI.
- `EC2.py` is a script using the Boto EC2 library, which queries AWS for any particular running EC2 instances for a given account.
- `EC2.ini` acts as configuration for `EC2.py` and is used to limit the scope of Ansible's reach.

- Environment variables need to be set for these files to be leveraged:
  - `export ANSIBLE_HOSTS=/working_dir/ec2.py`
- Make the file executable: `chmod +x ec2.py`

- If the `ec2.ini` is in a different location to the `.py` script, run `export ANSIBLE_HOSTS=/working_dir/ec2.ini`
- The `ec2.ini` file will have default configurations read by the `ec2.py` file, there's a specifier for `regions = all` which can be commented out to save time for one-region deployments.

- Export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as env vars if required, and verify authentication with `./ec2.py --list`
  - If `~/.aws/credentials` exists, then the keys associated with the selected profile will work / be used.

- Output will be returned in JSON, with the IP(s) and other relevant metadata.
- By default, `ec2.ini` is configured for running Ansible from outside EC2.
  - If running from within EC2 with an internal DNS, one should modify the `desination` variable
  - For VPC instances, `vpc_destination_variable` allows usage of whatever value of `boto.ec2.instance_variable` makes the most sense

---

- **Note** - The links have now been deprecated, This is now an AWS Plugin! Refer to guidance on how to use
  - <https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html>
  - <https://docs.ansible.com/ansible/latest/collections/amazon/aws/docsite/aws_ec2_guide.html>
  - <https://devopscube.com/setup-ansible-aws-dynamic-inventory/>

---

### Using a Dynamic Inventory Script

- The EC2 external inventory can map to instances using methods including:
  - Instance ID
  - Region
  - Availability Zone
  - Security Group

- Instance variables retrieved by the script are prefixed with `ec2_` - variables include region, ip address, owner ID, and vpc id.

- Red Hat Ansible Tower 3.3 uses this mechanism with a graphical frontend to generate inventory information from EC2. This is generally easier to use but as powerful as the CLI.

## 4.2 - Using the AWS EC2 Inventory Plugin

### Inventory Plugins

- Allow users to point at data sources to compile the inventory of hosts that Ansible uses in playbooks
- Inventory plugins take advantage of the most recent updates to Ansible core code -> Recommended for use over scripts for dynamic inventory.

- Plugins are specified via the CLI using `ansible-inventory -i`. The `inventory` path can be defaulted by the inventory path in the `ansible.cfg` file in `[defaults]` or the `ANSIBLE_INVENTORY` environment variable.

- Example usage: `ansible-inventory -i aws_ec2.yaml --graph`

- The plugin gets inventory hosts from AWS EC2. Example usage:

```yaml
plugin: aws_ec2
regions:
    - us-east-2
keyed_groups:
    # add hosts to tag_Name_value groups for each aws_ec2 host's tags.Name variable
    - key: tags.Name
      prefix: tag_Name
      separator: ""
groups:
  # add hosts to the group development if any of the dictionarys keys or values is the word 'dev'
  development: "'dev' in tags.env"
compose:
  # set the env variable to the value of the env tag
  env: tags.env
```

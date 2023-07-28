# About

This is a terraform module that provisions security groups meant to be restrict network access to an coredns servers.

The following security groups are created:
- **server**: Security group for coredns servers. It can make external requests and allows all outside communication on **icmp** and **dns** ports

Additionally, you can pass a list of groups that will fulfill each of the following roles:
- **bastion**: Security groups that will have access to the coredns servers on port **22**.
- **metrics_server**: Security groups that will have access to the coredns servers on port **8080** (health endpoint), port **9100** (node exporter) as well as port **9153** (coredns exporter).

# Usage

## Variables

The module takes the following variables as input:

- **server_group_name**: Name to give to the security group for the coredns servers
- **bastion_group_ids**: List of ids of security groups that should have **bastion** access to the coredns servers.
- **metrics_server_group_ids**: List of ids of security groups that should have **metrics server** access to the coredns servers.

## Output

The module outputs the following variables as output:

- **server_group**: Security group for the coredns servers that got created. It contains a resource of type **openstack_networking_secgroup_v2**
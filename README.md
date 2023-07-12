# About

This is a terraform module that provisions security groups meant to be restrict network access to an coredns servers.

The following security groups are created:
- **server**: Security group for coredns servers. It can make external requests and allows all outside communication on **icmp** and **dns** ports
- **bastion**: Security group to any machine that needs **ssh** access to the servers. It can communicate with any server of the **server** group on port **22**. I can also make any external request, receive external **icmp** traffic and receive external requests on port **22**.

The **server** and **bastion** security groups are self-contained. They can be applied by themselves on vms with no other security groups and the vms will be functional in their role.

# Usage

## Variables

The module takes the following variables as input:

- **namespace**: Namespace to differenciate the security group names across etcd clusters. The generated security groups will have the following names: 

```
<namespace>-coredns-server
<namespace>-coredns-bastion
```

## Output

The module outputs the following variables as output:

- groups: A map with 2 keys: server, bastion. Each key map entry contains a resource of type **openstack_networking_secgroup_v2**
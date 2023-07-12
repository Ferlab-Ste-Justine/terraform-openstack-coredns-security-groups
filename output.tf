output "groups" {
  value = {
    server  = openstack_networking_secgroup_v2.coredns_server
    bastion = openstack_networking_secgroup_v2.coredns_bastion
  }
}
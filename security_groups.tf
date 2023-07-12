resource "openstack_networking_secgroup_v2" "coredns_server" {
  name                 = "${var.namespace}-coredns-server"
  description          = "Security group for coredns servers"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "coredns_bastion" {
  name                 = "${var.namespace}-coredns-bastion"
  description          = "Security group for the bastion connecting to coredns servers"
  delete_default_rules = true
}

//Allow all outbound traffic from coredns servers and bastion
resource "openstack_networking_secgroup_rule_v2" "coredns_server_outgoing_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

resource "openstack_networking_secgroup_rule_v2" "coredns_server_outgoing_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

resource "openstack_networking_secgroup_rule_v2" "coredns_bastion_outgoing_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.coredns_bastion.id
}

resource "openstack_networking_secgroup_rule_v2" "coredns_bastion_outgoing_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.coredns_bastion.id
}

//Allow port 22 traffic from the bastion
resource "openstack_networking_secgroup_rule_v2" "internal_ssh_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id  = openstack_networking_secgroup_v2.coredns_bastion.id
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

//Allow port 22 traffic on the bastion
resource "openstack_networking_secgroup_rule_v2" "external_ssh_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_bastion.id
}

//Allow port 53 traffic on the dns server
resource "openstack_networking_secgroup_rule_v2" "external_dns_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 53
  port_range_max    = 53
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

//Allow icmp traffic
resource "openstack_networking_secgroup_rule_v2" "bastion_external_icmp_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_bastion.id
}

resource "openstack_networking_secgroup_rule_v2" "coredns_server_external_icmp_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}
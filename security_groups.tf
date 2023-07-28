resource "openstack_networking_secgroup_v2" "coredns_server" {
  name                 = var.server_group_name
  description          = "Security group for coredns servers"
  delete_default_rules = true
}

//Allow all outbound traffic 
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

//Allow dns and icmp traffic from all
resource "openstack_networking_secgroup_rule_v2" "external_dns_access_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 53
  port_range_max    = 53
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

resource "openstack_networking_secgroup_rule_v2" "external_dns_access_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 53
  port_range_max    = 53
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

resource "openstack_networking_secgroup_rule_v2" "coredns_server_external_icmp_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

resource "openstack_networking_secgroup_rule_v2" "coredns_server_external_icmp_access_v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

//Allow port 22 traffic from the bastion
resource "openstack_networking_secgroup_rule_v2" "internal_ssh_access" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

//Allow port 9153, 9100 and 8080 from metrics server
resource "openstack_networking_secgroup_rule_v2" "metrics_server_node_exporter_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_coredns_exporter_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9153
  port_range_max    = 9153
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_healthpoint_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.coredns_server.id
}
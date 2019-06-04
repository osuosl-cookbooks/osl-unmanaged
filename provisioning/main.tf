resource "openstack_networking_network_v2" "network" {
    name            = "network"
    admin_state_up  = "true"
}

resource "openstack_networking_port_v2" "port" {
    name            = "port"
    network_id      = "${openstack_networking_network_v2.network.id}"
    admin_state_up  = "true"
}

resource "openstack_compute_instance_v2" "chef_zero" {
    name            = "chef-zero"
    image_name      = "${var.image}"
    flavor_name     = "m1.small"
    key_pair        = "${var.ssh_key_name}"
    security_groups = ["default"]
    connection {
        user = "centos"
    }
    network {
        uuid = "${data.openstack_networking_network_v2.network.id}"
    }
    provisioner "remote-exec" {
        inline = [
            "until [ -S /var/run/docker.sock ] ; do sleep 1 && echo 'docker not started...' ; done",
            "sudo docker run -d -p 8889:8889 --name chef-zero osuosl/chef-zero"
        ]
    }
}

# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

# set cloud.yaml part in OS_CLOUD variable on your system to be used below
provider "openstack" {
    #Name of the cloud defined in the cloud.yaml file.
    cloud = "openstack"
}

#open stack vm configuration for terraform
resource "openstack_compute_instance_v2" "VM_terra" {
  name = var.instance_name
  # VW image ID to be used
  # To obtain this id, type openstack flavor list in Command prosmpt. make sure openstack CLI is installed first.
  # check below for openstack CLI installation
  image_id = "3ca7c40e-004e-4ac1-baba-89b02ccbb065"
  # Flavors manage the sizing for the compute, memory and storage capacity of the instance.
  # To obtain this id, type openstack flavor list in Command prompt. make sure openstack CLI is installed first.
  # check below for openstack CLI installation
  flavor_name = "c4-15gb-83"
  key_pair = "LexMapr_key"
  # default security group grands ssh permissions and other inbound access
  # Web grand access to internet on the VM and opens port 80 for inbound request
  security_groups = ["default", "outbound traffic"]

}

# Allocating floating IP address
resource "openstack_networking_floatingip_v2" "VM_terra_fip" {
  # Network on which to create the floating ip
  pool = var.network
}

#assigning floating IP address to created vm instance above
resource "openstack_compute_floatingip_associate_v2" "VM_terra_fip" {
  floating_ip = openstack_networking_floatingip_v2.VM_terra_fip.address
  instance_id = openstack_compute_instance_v2.VM_terra.id
}

resource "null_resource" "docker_install" {

  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = openstack_compute_floatingip_associate_v2.VM_terra_fip.floating_ip
    agent    = true
    private_key = file("~/.ssh/lexmapr_cedar")
  }


  provisioner "file" {
    source      = "docker_install.sh"
    destination = "/tmp/docker_install.sh"
  }

  provisioner "file" {
    source      = var.deploymentfile
    destination = "/tmp/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker_install.sh",
      "sudo /tmp/docker_install.sh",
      "chmod +x /tmp/deploy.sh",
      "sudo /tmp/deploy.sh",
    ]
  }



}
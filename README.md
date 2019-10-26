# terraform-module-virtualbox-cloudinit

> A Terraform module to create virtual machines and cloudinit based configuration (AWS EC2 style).

## Table of contents
* [General info](#general-info)
* [Screenshots](#screenshots)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)
* [Status](#status)
* [Usage](#usage)
* [Contact](#contact)

## General info

This project has been created to launch servers on Virtualbox in an AWS EC2 style.

## Technologies
Project uses:
* Terraform version: >= 0.12
* Virtualbox

## Features

* Virtual machines creation
* Cloudinit OS configuration
* Port forwarding into machines

## Status

Project is: _in progress_

## Usage

See also [examples](github.com/philipsahli/terraform-module-virtualbox-cloudinit) folder.

### Module

Use the module in your TF root project

    # amzn2.tf:

    module "amzn2" {
        source = "github.com/philipsahli/terraform-module-virtualbox-cloudinit"

        vm_name  = var.vm_name
        vm_count = var.vm_count
        vdi      = var.vdi
        userdata = var.userdata
    }

Define variables for your setup.

    # terraform.tfvars:

    vm_name = "node"
    vm_count = 2
    vdi = "https://cdn.amazonlinux.com/os-images/2.0.20190823.1/virtualbox/amzn2-virtualbox-2.0.20190823.1-x86_64.xfs.gpt.vdi"

    userdata = <<EOF
    #cloud-config
    #vim:syntax=yaml
    users:
    # A user by the name `ec2-user` is created in the image by default.
    - default
    chpasswd:
    list: |
        ec2-user:plain_text_password
    # In the above line, do not add any spaces after 'ec2-user:'.
    ssh_authorized_keys:
    - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEkNFRkip9a16pc+nwWTUiMcSxePRCNw1PrylLMpnyKo5pT/ user@station
    EOF


### Input Variables

| Variable |      Type     |  Example | Default|
|----------|:-------------:|----------|-------:|
| vm_name  |    string     |  node    |   -    |
| vm_count |    int        |  2       |   1    |
| userdata |    string     |#cloud-config <br> #vim:syntax=yaml <br>users: <br>- default|   -    |

### Output Variable

At the moment the module does not output any variable.

## Contact

Created by [@philipsahli](https://github.com/philipsahli) - feel free to contact me!
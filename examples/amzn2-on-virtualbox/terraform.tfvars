vm_name = "vm"

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

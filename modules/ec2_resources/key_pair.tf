# create a new private-public key pair
resource "tls_private_key" "tls_key" {
  count = var.allow_ec2_direct_access ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

# push the public key of the new key-pair into AWS
resource "aws_key_pair" "push_public_key" {
  count = var.allow_ec2_direct_access ? 1 : 0

  key_name   = var.key_pair_name
  public_key = tls_private_key.tls_key[0].public_key_openssh # index starts from 0
}

# save the private key in a pem file locally
resource "local_file" "dl_private_key" {
  count = var.allow_ec2_direct_access ? 1 : 0

  content = tls_private_key.tls_key[0].private_key_pem # index starts from 0

  # root/modules/ec2_capacity_provider
  # therefore store the file in root
  filename = "${path.module}/../../${var.key_pair_name}.pem"

  provisioner "local-exec" {
    when    = destroy

    command = "icacls.exe ${self.filename} /reset && del /f ${self.filename}"
  }

  provisioner "local-exec" {
    when = create

    command = "icacls.exe ${self.filename} /reset && icacls.exe ${self.filename} /grant:r %username%:(r) && icacls.exe ${self.filename} /inheritance:r"

    on_failure = fail
  }
}

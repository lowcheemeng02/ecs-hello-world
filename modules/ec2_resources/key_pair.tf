# create a new private-public key pair
resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# push the public key of the new key-pair into AWS
resource "aws_key_pair" "push_public_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.tls_key.public_key_openssh
}

# save the private key in a pem file locally
resource "local_file" "dl_private_key" {
  content = tls_private_key.tls_key.private_key_pem

  # root/modules/ec2_capacity_provider
  # therefore store the file in root
  filename = "${path.module}/../../${var.key_pair_name}.pem"

  provisioner "local-exec" {
    when    = destroy

    command = "icacls.exe ${self.filename} /reset && Remove-Item ${self.filename}"
  }

  provisioner "local-exec" {
    when = create

    command = "icacls.exe ${self.filename} /reset && icacls.exe ${self.filename} /grant:r %username%:(r) && icacls.exe ${self.filename} /inheritance:r"

    on_failure = fail
  }
}

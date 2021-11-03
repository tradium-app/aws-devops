resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVULzOBRUEyVCEEpCjiheO+ryXkOeYsmoAQLiqttdax syuraj@gmail.com"
}
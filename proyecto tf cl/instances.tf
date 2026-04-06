# ─────────────────────────────────────────
# AMI — Amazon Linux 2023 (el pinche linux de toda la vida)
# ─────────────────────────────────────────
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}
# ─────────────────────────────────────────
# 1. EC2 FRONTEND (se conecta con la subred pública)
#    Puertos: 80, 443 públicos — admin via SSM
# profe si lee esto invitenos una pizza :)
# ─────────────────────────────────────────
resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.front_sg.id]
  iam_instance_profile   = "LabInstanceProfile"

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker git
              systemctl enable --now docker
              EOF

  tags = { Name = "EC2-Frontend" }
}
# ─────────────────────────────────────────
# 2. EC2 BACKEND (usra la subred privada que se comunicara con el DBA)
#    Puerto 8080 interno — acceso via NAT
# ─────────────────────────────────────────
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.back_sg.id]
  iam_instance_profile   = "LabInstanceProfile"

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker git
              systemctl enable --now docker
              EOF

  tags = { Name = "EC2-Backend" }
}
# ─────────────────────────────────────────
# 3. EC2 DATABASE ( usa la subred privada)
#    Puerto 3306 — MySQL Community Server
# el user data son comandos que ejecuta la instancia para que se transforme en un servidor de base de datos
# ─────────────────────────────────────────
resource "aws_instance" "database" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  iam_instance_profile   = "LabInstanceProfile"

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
              dnf install -y mysql-community-server
              systemctl enable --now mysqld
              EOF

  tags = { Name = "EC2-Database" }
}

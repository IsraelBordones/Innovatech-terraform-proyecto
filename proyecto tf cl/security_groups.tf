# ─────────────────────────────────────────
# 1. SECURITY GROUP — FRONTEND (subred pública)
#    Entrada: 80, 443 desde Internet | 22 solo admin
# la entrada 80 y 443 para los plebeyos y el 22 para el admin
# ─────────────────────────────────────────
resource "aws_security_group" "front_sg" {
  name        = "front-sg"
  description = "Permite trafico HTTP, HTTPS y SSH/SSM"
  vpc_id      = aws_vpc.main.id

  # HTTP / puerto 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP publico"
  }

  # HTTPS  / el puerot 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS publico"
  }

  # Puerto 22 (SSH) eliminado — el acceso admin se hace via SSM
  # sin necesidad de key pair ni puerto abierto
  # no hubo key pair pq al chile no lo entendimos asi que nimodo el puerto 22 es eliminado, quedara pospuesto
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "front-sg" }
}

# ─────────────────────────────────────────
# 2. SECURITY GROUP — BACKEND (subred privada)
#    Entrada: puerto 8080 SOLO desde front-sg
# ─────────────────────────────────────────
resource "aws_security_group" "back_sg" {
  name        = "back-sg"
  description = "Solo permite trafico desde el Frontend"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.front_sg.id]
    description     = "App port desde front-sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "back-sg" }
}

# ─────────────────────────────────────────
# 3. SECURITY GROUP — BASE DE DATOS (subred privada)
#    Entrada: 3306 (MySQL) y 5432 (PostgreSQL) SOLO desde back-sg
# ─────────────────────────────────────────
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Solo permite trafico desde el Backend"
  vpc_id      = aws_vpc.main.id

  # MySQL / MariaDB
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.back_sg.id]
    description     = "MySQL desde back-sg"
  }

  # PostgreSQL  ← faltaba en la versión original
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.back_sg.id]
    description     = "PostgreSQL desde back-sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "db-sg" }
}

# 📦 Taller 3 - Infraestructura con Terraform en AWS

Este repositorio contiene múltiples carpetas, cada una con un módulo de Terraform independiente para desplegar recursos específicos en AWS. Cada carpeta aborda una asignación puntual descrita a continuación.

## 📁 Estructura del Repositorio

- `PANDAS/`: EC2 con Python y Pandas
- `POLARS/`: EC2 con Python y Polars
- `DUCK/`: EC2 con Python y DuckDB
- `SPARK/`: EC2 con Python y Spark
- `EMR/`: Cluster EMR para Spark distribuido
- `ec2/`: Código base o compartido para instancias EC2
- `scripts/`: Scripts auxiliares para instalación o validación

---

## 🚀 Instrucciones Generales de Ejecución

En cada carpeta se incluye:

- Código Terraform modular.
- Instrucciones de ejecución en un archivo `README.md` local.
- Comandos necesarios para instalar los paquetes requeridos.
- Pantallazo de validación: evidencia visual de que la instalación fue correcta.

---

## 🔑 Conexión a Instancias AWS (EC2 y EMR)

### ✅ Requisitos Previos

- Haber configurado correctamente el rol de IAM con permisos de Systems Manager (SSM).
- Tener AWS CLI instalado y autenticado (`aws configure`).
- Contar con permisos para iniciar sesiones SSM.

---

### 📡 Conexión a EC2 vía SSM

Puedes conectarte a cualquier instancia EC2 que tenga el agente SSM activo mediante el siguiente comando:

aws ssm start-session --target <instance-id>

Donde `<instance-id>` se puede obtener con:

aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text


**Nota:** Asegúrate de que la instancia esté en estado `running` y que tenga conectividad con los endpoints de SSM (vía Internet Gateway o VPC Endpoint).

---

### 💻 Validación de Instalación

Una vez conectado a la instancia vía SSM, puedes validar los paquetes con:


python3 --version
pip list | grep pandas    # o polars, duckdb, según el caso

También puedes correr scripts simples como:


python3 -c "import pandas as pd; print(pd.__version__)"
---

### ☁️ Conexión al Nodo Master del EMR

Para conectarse al nodo maestro del cluster EMR vía SSM:

1. **Identifica el ID del cluster:**


aws emr list-clusters --active

2. **Obtén el Instance ID del master:**

aws emr list-instances --cluster-id <cluster-id> --instance-group-types MASTER --query 'Instances[*].InstanceId' --output text

3. **Conéctate vía SSM:**


aws ssm start-session --target <instance-id>

---

## 📸 Evidencias

Cada carpeta contiene una imagen (pantallazo) que valida:

- La instalación correcta de cada herramienta (pandas, polars, duckdb, spark).
- La conexión exitosa vía SSM.
- En el caso del EMR, la conexión al nodo master y ejecución de comandos Spark.

---

## 🔐 Seguridad y Buenas Prácticas

- No se incluyen claves, IPs públicas ni nombres de instancias.
- Toda la conexión se realiza vía SSM, sin necesidad de exponer puertos ni usar claves SSH.
- Las instancias no tienen acceso a Internet sin configuración explícita. Se recomienda el uso de NAT Gateway o VPC Endpoints si se requiere conectividad saliente.
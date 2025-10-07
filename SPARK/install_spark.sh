#!/bin/bash
set -eux

# Update and install dependencies
apt-get update -y
apt-get install -y openjdk-11-jdk python3 python3-pip curl wget tar

# Upgrade pip and install PySpark
pip3 install --upgrade pip
pip3 install pyspark findspark

# Download Spark directly (3.5.1 Hadoop 3 build)
wget https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz -O /tmp/spark.tgz

# Extract to /opt
tar -xvzf /tmp/spark.tgz -C /opt/

# Symlink for convenience
ln -s /opt/spark-3.5.1-bin-hadoop3 /opt/spark || true

# Add environment variables
echo "export SPARK_HOME=/opt/spark" >> /etc/profile
echo "export PATH=\$SPARK_HOME/bin:\$PATH" >> /etc/profile
echo "export PYSPARK_PYTHON=python3" >> /etc/profile

# Preload for current session
source /etc/profile

# Log Spark version
/opt/spark/bin/spark-submit --version >> /var/log/spark_install.log 2>&1 || true

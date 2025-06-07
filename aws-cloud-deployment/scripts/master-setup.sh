#!/bin/bash

# --- Configuration Variables (intended to be set by Terraform) ---


# --- Functions for Logging and Error Handling ---
log_info() {
    echo -e "\n\e[1;34m[INFO]\e[0m $1"
}

log_success() {
    echo -e "\n\e[1;32m[SUCCESS]\e[0m $1"
}

log_error() {
    echo -e "\n\e[1;31m[ERROR]\e[0m $1"
    exit 1
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (or with sudo)."
    fi
}

# --- Main Script ---

check_root

log_info "Starting Hadoop Master installation (3.4.1) on Ubuntu..."

# 1. Update and install prerequisites
log_info "Updating system packages and installing OpenJDK 11, SSH, and other utilities."
apt update -y || log_error "Failed to update apt."
apt install -y openjdk-11-jdk openjdk-11-jre ssh openssh-server rsync curl wget || log_error "Failed to install required packages."

# Verify Java installation
if ! command -v java &> /dev/null || ! java -version 2>&1 | grep "openjdk version \"11\." > /dev/null; then
    log_error "OpenJDK 11 not found or not correctly installed."
fi
log_success "OpenJDK 11 and SSH installed successfully."

# 2. Create Hadoop user and group
log_info "Creating Hadoop user: hadoop and group: hadoop."
addgroup --system "hadoop" &>/dev/null || log_info "Group hadoop might already exist."
adduser --system --ingroup "hadoop" --home "/home/hadoop" --shell /bin/bash "hadoop" &>/dev/null || log_info "User hadoop might already exist."
log_success "Hadoop user and group created."

# 3. Setup SSH for passwordless login for hadoop user (important for master to communicate with workers)
log_info "Setting up SSH for passwordless login for hadoop."
# Switch to hadoop user to generate keys, then switch back
su - "hadoop" -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"
su - "hadoop" -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
su - "hadoop" -c "chmod 0600 ~/.ssh/authorized_keys"
chown -R "hadoop:hadoop" "/home/hadoop/.ssh" # Ensure correct ownership
log_success "SSH keys generated and authorized for hadoop."

# Test SSH connectivity to localhost for hadoop user (self-test)
log_info "Testing SSH connection for hadoop to localhost..."
if su - "hadoop" -c "ssh -o BatchMode=yes -o StrictHostKeyChecking=no localhost exit"; then
    log_success "SSH connection to localhost as hadoop is successful."
else
    log_error "SSH connection to localhost as hadoop failed. Please check SSH setup."
fi

# 4. Download and Extract Hadoop
log_info "Downloading Hadoop 3.4.1 from https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz..."
wget -q --show-progress "https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz" -P /tmp || log_error "Failed to download Hadoop."

log_info "Extracting Hadoop to /opt."
tar -xzf "/tmp/hadoop-3.4.1.tar.gz" -C "/opt" || log_error "Failed to extract Hadoop."

# Rename extracted directory to 'hadoop' for consistent path
if [ -d "/opt/hadoop-3.4.1" ]; then
    mv "/opt/hadoop-3.4.1" "/opt/hadoop" || log_error "Failed to rename Hadoop directory."
else
    log_error "Hadoop extracted directory not found at /opt/hadoop-3.4.1."
fi

# 5. Set ownership and permissions
log_info "Setting ownership and permissions for Hadoop directories."
chown -R "hadoop:hadoop" "/opt/hadoop" || log_error "Failed to set ownership for Hadoop home."
log_success "Hadoop ownership set."

# 6. Configure Environment Variables for hadoop user
log_info "Configuring environment variables for hadoop."
echo "
# Hadoop Environment Variables
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop
export HADOOP_COMMON_HOME=/opt/hadoop
export HADOOP_HDFS_HOME=/opt/hadoop
export YARN_HOME=/opt/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=/opt/hadoop/lib/native
export PATH=\$PATH:\$JAVA_HOME/bin:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
" | tee -a "/home/hadoop/.bashrc" > /dev/null || log_error "Failed to update .bashrc for hadoop."
su - "hadoop" -c "source /home/hadoop/.bashrc"
log_success "Environment variables configured for hadoop."

# 7. Configure Hadoop XML files
log_info "Configuring Hadoop XML files for Master node."

# Create Hadoop data directories
log_info "Creating Hadoop data directories: NameNode and DataNode."
mkdir -p "/opt/hadoop/data/nameNode" || log_error "Failed to create namenode directory."
mkdir -p "/opt/hadoop/data/dataNode" || log_error "Failed to create datanode directory."
chown -R "hadoop:hadoop" "/opt/hadoop/data" || log_error "Failed to set ownership for data directories."

# Update hadoop-env.sh
log_info "Updating hadoop-env.sh to set JAVA_HOME."
sed -i "s|^export JAVA_HOME=.*|export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64|g" "/opt/hadoop/etc/hadoop/hadoop-env.sh" || log_error "Failed to update JAVA_HOME in hadoop-env.sh."
log_success "hadoop-env.sh updated."

# core-site.xml
log_info "Configuring core-site.xml."
echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>file:///opt/hadoop/data/tmp</value>
    </property>
</configuration>' | tee "/opt/hadoop/etc/hadoop/core-site.xml" > /dev/null || log_error "Failed to write core-site.xml."
log_success "core-site.xml configured."

# hdfs-site.xml
log_info "Configuring hdfs-site.xml."
echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>'${WORKER_COUNT}'</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///opt/hadoop/data/nameNode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///opt/hadoop/data/dataNode</value>
    </property>
</configuration>' | tee "/opt/hadoop/etc/hadoop/hdfs-site.xml" > /dev/null || log_error "Failed to write hdfs-site.xml."
log_success "hdfs-site.xml configured."

# mapred-site.xml
log_info "Configuring mapred-site.xml."
echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>' | tee "/opt/hadoop/etc/hadoop/mapred-site.xml" > /dev/null || log_error "Failed to write mapred-site.xml."
log_success "mapred-site.xml configured."

# yarn-site.xml
log_info "Configuring yarn-site.xml."
echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>localhost</value>
    </property>
    <property>
        <name>yarn.acl.enable</name>
        <value>0</value>
    </property>
    <property>
        <name>yarn.log-aggregation-enable</name>
        <value>true</value>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address</name>
        <value>localhost:8088</value>
    </property>
    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>128</value>
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>2048</value>
    </property>
    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
</configuration>' | tee "/opt/hadoop/etc/hadoop/yarn-site.xml" > /dev/null || log_error "Failed to write yarn-site.xml."
log_success "yarn-site.xml configured."

# 8. Format the NameNode
log_info "Formatting the HDFS NameNode (run as hadoop)..."
# IMPORTANT: This command should only be run ONCE on a fresh installation.
# Running it again will erase existing HDFS data.
if su - "hadoop" -c "source /home/hadoop/.bashrc && yes | /opt/hadoop/bin/hdfs namenode -format"; then
    log_success "NameNode formatted successfully."
else
    log_error "NameNode formatting failed. Check logs."
fi

# 9. Start Hadoop Daemons
log_info "Starting Hadoop daemons (NameNode, ResourceManager, DataNode)..."
log_info "Please allow some time for services to start..."
su - "hadoop" -c "source /home/hadoop/.bashrc && /opt/hadoop/sbin/start-dfs.sh" || log_error "Failed to start HDFS daemons."
su - "hadoop" -c "source /home/hadoop/.bashrc && /opt/hadoop/sbin/start-yarn.sh" || log_error "Failed to start YARN daemons."
log_success "Hadoop daemons started (check jps for verification)."

# 10. Verify Installation
log_info "Verifying Hadoop services with 'jps'."
sleep 30 # Give services time to fully start
if ! su - "hadoop" -c "jps | grep -q 'NameNode'"; then
    log_error "NameNode is not running."
fi
if ! su - "hadoop" -c "jps | grep -q 'ResourceManager'"; then
    log_error "ResourceManager is not running."
fi
if ! su - "hadoop" -c "jps | grep -q 'DataNode'"; then
    log_error "DataNode is not running on Master (expected in pseudo-distributed/master-as-datanode setup)."
fi
if ! su - "hadoop" -c "jps | grep -q 'NodeManager'"; then
    log_error "NodeManager is not running on Master (expected in pseudo-distributed/master-as-nodemanager setup)."
fi
log_success "All expected Hadoop services are running on the Master node."

log_info "Creating a sample HDFS directory for testing."
su - "hadoop" -c "source /home/hadoop/.bashrc && /opt/hadoop/bin/hdfs dfs -mkdir -p /user/hadoop" || log_error "Failed to create HDFS directory."
log_success "Sample HDFS directory /user/hadoop created."

log_success "Hadoop Master node setup completed successfully!"
echo -e "\e[1;33mRemember to check Hadoop Web UIs:\n  - HDFS NameNode: http://localhost:9870/\n  - YARN ResourceManager: http://localhost:8088/\e[0m"
log_info "Cleaning up temporary files."
rm -f "/tmp/hadoop-3.4.1.tar.gz"

log_success "Master setup script finished."
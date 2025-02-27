# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Update packages and install required dependencies
RUN yum update -y && \
    yum install -y python3 python3-pip jq unzip && \
    yum clean all

# Install AWS CLI v2 for ARM64
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Ansible via pip3
RUN pip3 install ansible

# Verify installations
RUN aws --version && ansible --version

# Set the default command
CMD [ "bash" ]
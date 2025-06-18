
## General Methodology

This methodology is for cloud penetration testing and configuration covers Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP). 
It includes the phases of testing, recommended tools with their permissions required, installation, execution commands, and key reference frameworks.


When conducting cloud security assessments, it is a good practice to align the methodology with established frameworks. Some of them are:

* **CIS Benchmarks:** The Centre for Internet Security provides detailed, prescriptive guidance for securing AWS, Azure, and GCP. The tools mentioned above, particularly Powerpipe, Prowler and ScoutSuite, have built-in checks for these benchmarks.

* **OWASP Cloud Top 10:** This project from the Open Web Application Security Project outlines the most critical security risks in cloud environments. It provides a valuable lens through which to analyse findings and prioritise remediation efforts. The top risks include misconfigured cloud storage, insecure APIs, and inadequate identity and access management.

* **Cloud Security Alliance (CSA) Cloud Controls Matrix (CCM):** The CCM is a cybersecurity control framework for cloud computing. It provides a comprehensive set of security controls that can be mapped to various industry standards and regulations. It's an excellent resource for developing a holistic cloud security programme.


The cloud security assessment can be broken down into four key phases, regardless of the cloud service provider (CSP)

### 1. Reconnaissance and Scoping
This initial phase involves gathering as much information as possible about the target cloud environment. The scope of the penetration test should be clearly defined and agreed upon with the client, including the assets to be tested and the permitted testing window.

* **Objective:** To identify the external attack surface, enumerate cloud assets, and understand the relationships between them.
* **Activities:**
    * Identifying public-facing services (e.g., websites, APIs, storage buckets).
    * Enumerating subdomains and related cloud services.
    * Gathering information about the organisation's cloud usage patterns.

### 2. Vulnerability Analysis and Configuration Review
This phase involves actively scanning for vulnerabilities and misconfigurations within the cloud environment. This is where the automated tools play a crucial role in identifying deviations from security good practices and compliance benchmarks.

* **Objective:** To identify security weaknesses, misconfigurations, and compliance violations.
* **Activities:**
    * Scanning for open ports and vulnerable services.
    * Reviewing Identity and Access Management (IAM) policies for excessive permissions.
    * Assessing network security configurations (e.g., security groups, firewalls).
    * Checking for publicly exposed storage and databases.
    * Auditing logging and monitoring configurations.

### 3. Exploitation
Once vulnerabilities are identified, this phase involves attempting to exploit them to understand their potential impact. This should always be conducted in a controlled and non-disruptive manner.

* **Objective:** To demonstrate the real-world risk of identified vulnerabilities.
* **Activities:**
    * Attempting to gain unauthorised access to data or services.
    * Testing for privilege escalation paths.
    * Simulating lateral movement across the cloud environment.

### 4. Reporting and Remediation
The final phase involves documenting all findings in a clear and actionable report. This report should prioritise vulnerabilities based on risk and provide detailed remediation guidance.

* **Objective:** To provide a comprehensive overview of the security posture and a roadmap for improvement.
* **Activities:**
    * Creating a detailed report with an executive summary and technical findings.
    * Providing evidence of vulnerabilities (e.g., screenshots, logs).
    * Offering clear and concise remediation steps.
    * Presenting the findings to the client and discussing the remediation plan.

---

## Recomended Tools
The tools we will be using are 
 * **Prowler**
 * **ScoutSuite**
 * **Powerpipe**
 * **Stormspotter**
 * **Pacu**
 * **GCPBucketBrute**
 * **gcp-scanner**


## Permissions Needed

To run compliance assessments across AWS, Azure, and GCP, each of the specified tools—Powerpipe, Prowler, and Scout Suite—requires the following IAM permissions. These permissions are designed to grant the tools the necessary read-only access to configuration data without allowing for modifications, ensuring the security of your cloud resources.


### Azure

When assessing Azure environments, Powerpipe uses the Steampipe Azure and Azure Active Directory (Azure AD) plugins.
The tools require a user or Service Principal with the following roles assigned at the subscription level:

  * **`Reader`**
  * **`Security Reader`**

For Azure AD-related checks, the user or service principal requires the following Microsoft Graph API permissions:

  * `Application.Read.All`
  * `AuditLog.Read.All`
  * `Directory.Read.All`
  * `Domain.Read.All`
  * `Group.Read.All`
  * `IdentityProvider.Read.All`
  * `Policy.Read.All`
  * `User.Read.All`


### AWS

To run any of the tools on an AWS environment, it is recommended to attach the following AWS managed policies to the IAM user or role:

  * **`SecurityAudit`**
  * **`ViewOnlyAccess`**



### GCP

To run a compliance assessment on a GCP project, the user or service account needs the following predefined IAM roles:

  * **`Viewer`**
  * **`Security Reviewer`**
  
  Scout Suite may need the * **`Stackdriver Account Viewer`** following predefined IAM role.



## Assessment Tools Installation

We will cover the installation, authentication configuration, and usage of the top three cloud security assessment tools: **Powerpipe**, **Prowler**, and **ScoutSuite**.


## Powerpipe

**Powerpipe** is a modern dashboard and benchmarking tool for visualising cloud configurations and assessing security posture against compliance frameworks like CIS, NIST, PCI, HIPAA, and FedRAMP.

### Installation

#### Linux/Ubuntu Installation
```bash
# Using the official installation script (recommended)
sudo /bin/sh -c "$(curl -fsSL https://powerpipe.io/install/powerpipe.sh)"

# Verify installation
powerpipe --version
```

#### macOS Installation
```bash
# Using Homebrew
brew install turbot/tap/powerpipe

# Verify installation
powerpipe --version
```

#### Alternative: Docker Installation
```bash
# Pull the latest image
docker pull turbot/powerpipe

# Run Powerpipe in Docker
docker run --rm -it turbot/powerpipe --version
```

### Basic Configuration

Powerpipe requires **Steampipe** for data access. Install Steampipe first:

```bash
# Install Steampipe
sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)"

# Install cloud provider plugins
steampipe plugin install aws
steampipe plugin install azure
steampipe plugin install gcp
```

### Assessment Commands

```bash
# Install compliance mods
powerpipe mod install github.com/turbot/steampipe-mod-aws-compliance
powerpipe mod install github.com/turbot/steampipe-mod-azure-compliance
powerpipe mod install github.com/turbot/steampipe-mod-gcp-compliance

# Run AWS CIS benchmark
powerpipe benchmark run aws_compliance.benchmark.cis_v140

# Run Azure CIS benchmark
powerpipe benchmark run azure_compliance.benchmark.cis_v140

# Run GCP CIS benchmark
powerpipe benchmark run gcp_compliance.benchmark.cis_v120

# Run specific controls
powerpipe control run aws_compliance.control.cis_v140_2_1_1

# Generate dashboard
powerpipe server
# Open browser to http://localhost:9033
```

**Documentation**: [https://powerpipe.io/docs](https://powerpipe.io/docs)

---

## Prowler

**Prowler** is an open-source cloud security tool that performs security assessments, audits, and compliance checks across AWS, Azure, GCP, and Kubernetes.

### Installation

#### Method 1: Using pipx (Recommended)
```bash
# Install pipx if not already installed
sudo apt update
sudo apt install pipx
pipx ensurepath

# Install Prowler
pipx install prowler

# Verify installation
prowler --version
```

#### Method 2: Using pip
```bash
# Install Python 3.9+ if not available
sudo apt update
sudo apt install python3 python3-pip

# Install Prowler
pip3 install prowler

# Verify installation
prowler --version
```

#### Method 3: Docker
```bash
# Pull Prowler image
docker pull prowler/prowler

# Run with Docker
docker run --rm -it \
  -v ~/.aws:/home/prowler/.aws \
  -v /tmp/prowler-output:/home/prowler/output \
  prowler/prowler aws
```

#### Method 4: Git Installation (Development)
```bash
# Clone repository
git clone https://github.com/prowler-cloud/prowler
cd prowler

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run Prowler
python prowler.py --version
```

### Assessment Commands

#### AWS Assessments
```bash
# Basic AWS scan (all regions, all checks)
prowler aws

# Scan specific AWS regions
prowler aws --filter-region eu-west-1 eu-west-2

# Run specific compliance framework
prowler aws --compliance aws_foundational_security_best_practices_aws
prowler aws --compliance cis_2.0_aws
prowler aws --compliance pci_3.2.1_aws
prowler aws --compliance nist_800_53_revision_5_aws

# Run specific services
prowler aws --services s3 ec2 iam

# Run specific checks
prowler aws --checks s3_bucket_public_access_block

# Exclude specific checks
prowler aws --excluded-checks s3_bucket_logging_enabled

# Generate specific output formats
prowler aws --output-modes csv json-ocsf html

# Send findings to AWS Security Hub
prowler aws --security-hub --status FAIL
```

#### Azure Assessments
```bash
# Service Principal authentication
prowler azure --sp-env-auth

# Azure CLI authentication
prowler azure --az-cli-auth

# Browser authentication
prowler azure --browser-auth --tenant-id "your-tenant-id"

# Scan specific subscriptions
prowler azure --az-cli-auth --subscription-ids sub-id-1 sub-id-2

# Run Azure CIS compliance
prowler azure --compliance cis_2.0_azure

# Run specific Azure services
prowler azure --services keyvault storage
```

#### GCP Assessments
```bash
# Using default credentials
prowler gcp

# Using service account key file
prowler gcp --credentials-file /path/to/service-account.json

# Scan specific projects
prowler gcp --project-ids project-1 project-2

# Run GCP CIS compliance
prowler gcp --compliance cis_1.2.0_gcp

# Run specific GCP services
prowler gcp --services iam compute
```

#### Kubernetes Assessments
```bash
# In-cluster scan
prowler kubernetes

# External scan with kubeconfig
prowler kubernetes --kubeconfig-file ~/.kube/config

# Scan specific namespaces
prowler kubernetes --namespaces kube-system default

# Run CIS Kubernetes benchmark
prowler kubernetes --compliance cis_1.6.0_kubernetes
```

### List Available Options
```bash
# List all checks for a provider
prowler aws --list-checks
prowler azure --list-checks
prowler gcp --list-checks

# List all services
prowler aws --list-services

# List compliance frameworks
prowler aws --list-compliance
```

**Documentation**: [https://docs.prowler.com](https://docs.prowler.com)

---

## ScoutSuite

**ScoutSuite** is a multi-cloud security auditing tool that provides a comprehensive security assessment with an HTML report interface.

### Installation

#### Method 1: pip Installation (Recommended)
```bash
# Install Python 3 and pip
sudo apt update
sudo apt install python3 python3-pip python3-venv

# Install ScoutSuite
pip3 install scoutsuite

# Verify installation
scout --help
```

#### Method 2: Git Installation
```bash
# Clone repository
git clone https://github.com/nccgroup/ScoutSuite
cd ScoutSuite

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install requirements
pip install -r requirements.txt

# Verify installation
python scout.py --help
```

### Assessment Commands

#### AWS Assessments
```bash
# Basic AWS scan (requires AWS CLI configured)
scout aws

# Using specific AWS profile
scout aws --profile myprofile

# Using access keys directly
scout aws --access-key-id AKIAIOSFODNN7EXAMPLE \
         --secret-access-key wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# Scan specific regions
scout aws --regions us-east-1 eu-west-1

# Generate report with custom name
scout aws --report-name my-aws-assessment
```

#### Azure Assessments
```bash
# Using Azure CLI authentication
scout azure --cli

# Using service principal with environment variables
scout azure --sp-env-auth

# Using managed identity (from Azure VM)
scout azure --msi

# Using browser authentication
scout azure --browser-auth --tenant-id your-tenant-id

# Using credentials file
scout azure --file-auth /path/to/credentials.json

# Scan specific subscriptions
scout azure --cli --subscription-ids sub1 sub2
```

#### GCP Assessments
```bash
# Using default credentials
scout gcp

# Using service account key file
scout gcp --service-account /path/to/service-account.json

# Using access token
scout gcp --access-token $(gcloud auth print-access-token)

# Scan specific projects
scout gcp --project-id my-project-id
```

#### Generate Reports
```bash
# All providers generate HTML reports automatically
# Reports are saved in scoutsuite-report/ directory
# Open the HTML file in your browser to view results

# Example: Open AWS report
firefox scoutsuite-report/scoutsuite-results/aws-account-*.html
```

**Documentation**: [https://github.com/nccgroup/ScoutSuite/wiki](https://github.com/nccgroup/ScoutSuite/wiki)

---

## Authentication Setup

### AWS Authentication

#### Option 1: AWS CLI Configuration
```bash
# Install AWS CLI
sudo apt install awscli

# Configure credentials
aws configure
# Enter: Access Key ID, Secret Access Key, Default Region, Output format

# Or manually edit credentials file
nano ~/.aws/credentials
```

Add to `~/.aws/credentials`:
```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region = eu-west-1

[myprofile]
aws_access_key_id = AKIAI44QH8DHBEXAMPLE
aws_secret_access_key = je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
region = us-east-1
```

#### Option 2: Environment Variables
```bash
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="eu-west-1"
```

### Azure Authentication

#### Option 1: Azure CLI
```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login to Azure
az login

# Set default subscription
az account set --subscription "your-subscription-id"
```

#### Option 2: Service Principal
```bash
# Create service principal (requires Azure CLI)
az ad sp create-for-rbac --name "security-assessment-sp" --role "Reader"

# Set environment variables
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
export AZURE_TENANT_ID="your-tenant-id"
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
```

### GCP Authentication

#### Option 1: gcloud CLI
```bash
# Install gcloud CLI
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Authenticate
gcloud auth login
gcloud auth application-default login

# Set default project
gcloud config set project your-project-id
```

#### Option 2: Service Account
```bash
# Download service account key file from GCP Console
# Set environment variable
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
```

---

## Quick Reference Commands

### Complete Assessment Workflow

```bash
# 1. AWS Assessment with all tools
prowler aws --compliance cis_2.0_aws
scout aws --profile default
powerpipe benchmark run aws_compliance.benchmark.cis_v140

# 2. Azure Assessment with all tools
prowler azure --az-cli-auth --compliance cis_2.0_azure
scout azure --cli
powerpipe benchmark run azure_compliance.benchmark.cis_v140

# 3. GCP Assessment with all tools
prowler gcp --compliance cis_1.2.0_gcp
scout gcp --project-id your-project
powerpipe benchmark run gcp_compliance.benchmark.cis_v120
```

### Common Compliance Frameworks

#### CIS Benchmarks
```bash
# AWS CIS v1.4.0
prowler aws --compliance cis_2.0_aws
powerpipe benchmark run aws_compliance.benchmark.cis_v140

# Azure CIS v1.4.0
prowler azure --compliance cis_2.0_azure
powerpipe benchmark run azure_compliance.benchmark.cis_v140

# GCP CIS v1.2.0
prowler gcp --compliance cis_1.2.0_gcp
powerpipe benchmark run gcp_compliance.benchmark.cis_v120
```

#### NIST Frameworks
```bash
# NIST 800-53 Rev 5
prowler aws --compliance nist_800_53_revision_5_aws
powler azure --compliance nist_cybersecurity_framework_v1.1_azure

# NIST CSF
prowler aws --compliance nist_csf_1.1_aws
```

#### Industry-Specific Compliance
```bash
# PCI-DSS
prowler aws --compliance pci_3.2.1_aws

# HIPAA
prowler aws --compliance hipaa_aws

# SOC 2
prowler aws --compliance soc2_aws

# GDPR
prowler aws --compliance gdpr_aws
```

### Output and Reporting

```bash
# Generate multiple output formats
prowler aws --output-modes csv json-ocsf html

# Custom output directory
prowler aws --output-directory /path/to/reports

# Send findings to AWS Security Hub
prowler aws --security-hub --status FAIL

# Generate dashboard
powerpipe server --port 9033
```

---

## Additional Resources

- **Powerpipe Documentation**: [https://powerpipe.io/docs](https://powerpipe.io/docs)
- **Powerpipe Hub**: [https://hub.powerpipe.io](https://hub.powerpipe.io)
- **Prowler Documentation**: [https://docs.prowler.com](https://docs.prowler.com)
- **Prowler GitHub**: [https://github.com/prowler-cloud/prowler](https://github.com/prowler-cloud/prowler)
- **ScoutSuite GitHub**: [https://github.com/nccgroup/ScoutSuite](https://github.com/nccgroup/ScoutSuite)
- **ScoutSuite Wiki**: [https://github.com/nccgroup/ScoutSuite/wiki](https://github.com/nccgroup/ScoutSuite/wiki)





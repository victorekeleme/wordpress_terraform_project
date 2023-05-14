
# WordPress Application On AWS Cloud Using Terraform
![terraform_infra drawio](https://github.com/victorekeleme/wordpress_terraform_project/assets/74677661/c42d1a46-ccb1-4f0a-b02c-c8b215bff2a7)

### AWS Services Utilized:
- Virtual Private Cloud (VPC)
- AutoSclaing Group (ASG)
- Relational Database Service (RDS)
- Identity Access Management (IAM)
- Secrets Manager
- Elastic FileSystem (EFS)
- Route53 (DNS Service)
- Elastic Compute Cloud (EC2)
- Simple Storage Service (S3)

### Tools Utilized:
- HashiCorp Terrafrom v1.3.6
- HashiCorp Packer v1.8.6
- Docker v1.13.1+
- Docker Compose file format v3.1
- Visual Studio Code (IDE)
- Bash Scripting Language
- HashiCorp Configuration Language

## What is Terraform?
Terraform is a tool for creating and changing infrastructure quickly and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

## Terraform Installation using Chocolatey
### What is chocolatey?
Chocolatey is a package manager for Windows that aims to automate the entire software lifecycle from installation through upgrade and removal on Windows operating systems.

### Chocolatey installation
#### Requirements:
1. Windows 7+ / Windows Server 2003+
2. PowerShell v2+ (minimum is v3 for install from this website due to TLS 1.2 requirement)
3. .NET Framework 4+ (the installation will attempt to install .NET 4.0 if you do not have it installed)

#### Steps:
1. Open PowerShell cmd as Administrator
2. Type the following command and press Enter:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```
3. Wait for command to complete
4. Check that chocolatey is installed:
```powershell

C:\WINDOWS\system32>choco version #terraform version used in this project "v1.3.6"
```


## Terraform installation
1. Open cmd as Administrator
2. Run the following command and press Enter
```powershell
choco install -y terraform
```
3. Wait for command to finish
4. Check that terraform is installed :
```powershell
C:\WINDOWS\system32>terraform -version
```

## Note: Packer must be used to build Ami's for Prometheus and WordPress in the ami_creation packer folder

## What is packer?
Packer is a free and open-source tool for creating golden images for multiple platforms from a single source configuration.

### Packer installation using Chocolatey
```powershell
choco install packer -y #packer version used in this project "v1.8.6"
```
### Building Packer AMIs
```bash
#change the directory into each folder and run provided you have configured your programmatic access credentials:
packer build .
```
## Initializing and applying Terraform scripts
```bash
### Initialize Terraform ###
Terraform init

### Format Terraform Scripts ###
Terraform fmt

### Validate Terraform Scripts ###
Terraform validate

### Plan Terraform Scripts ###
Terraform plan

### Apply Terraform Scripts ###
Terraform apply --auto-approve
```
## Outputs Expected

| Outputs                | Values                                |
|------------------------|---------------------------------------|
| database_name          | aws_db_instance.wordpress_db.db_name  |
| database_user          | aws_db_instance.wordpress_db.username |
| database_endpoint      | aws_db_instance.wordpress_db.endpoint |
| load_balancer_dns      | aws_lb.wordpress_alb.dns_name         |
| baiston_host_public_ip | aws_instance.baiston_host.public_ip   |

## Contributing
Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

## License
[MIT](https://github.com/victorekeleme/wordpress_terraform_project/blob/main/LICENSE)

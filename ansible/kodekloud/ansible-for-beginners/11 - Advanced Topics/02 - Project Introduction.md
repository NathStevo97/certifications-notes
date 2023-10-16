# 11.2 - Project Introduction

Complete: No
Flash Cards: No
Lab: No
Read: No
Status: Complete
Watch: No
You done?: 🌚🌚🌚🌚

## Project Introduction

- Project Aim: Use Ansible to automate the provisioning of the Kodekloud Store
  - LAMP Stack Application (Linux - Apache - MySQL - PHP)
- Note: MariaDB will be used instead of MySQL
- Need to understand what we actually want to achieve.
- System:
  - CentOS / Linux target machines
    - Need to ensure Firewall is configured appropriately or installed if not there
  - Apache HTTPD Server needs to be installed:
    - install httpd
    - configure httpd
    - configure Firewall to allow httpd
    - Start httpd service
  - MariaDB needs to be set up and configured
    - Install MariaDB
    - Configure MariaDB
    - Start MariaDB
    - Configure Firewall
    - Configure Database
    - Load data
  - PHP
    - Install PHP
    - Configure Code
  - Configure any other system requirements
- For ease with the project, the steps will go:
  - Install firewall (system)
  - Install and setup MariaDB
  - Install and Setup Apache HTTPD Server
  - Download PHP Code and Run/Test it

---

## Firewall

```bash
sudo yum install firewalld # install firewalld package
sudo service firewalld start # start firewalld service
sudo systemctl enable firewalld # enable the firewalld service
```

## MariaDB

```bash
sudo yum install mariadb-server
sudo vi /etc/my.cnf # configure file with right port
sudo service mariadb start
sudo systemctl enable mariadb
# enable mariadb via firewall
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload
# Configure the DB and setup user(s)
mysql
MariaDB > CREATE DATABASE ecomdb;
MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
MariaDB > FLUSH PRIVILEGES;
mysql < db-load-script.sql
```

---

## Apache

```bash
sudo yum install -y httpd php php-mysql
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

sudo vi /etc/httpd/conf/httpd.conf
# configures DirectoryIndex to use index.php instead of index.html

sudo service httpd start
sudo systemctl enable httpd
```

## Code

```bash
sudo yum install -y git
git clone https://github.com/application.git /var/www/html
#update index.php to use the right database address, name and credentials
curl http:://localhost # test code
```

---

## Setup Variations

- Could just run all of the above on a single node, however in practice, one would have a DB server and a web server.
  - The MariaDB instructions are to be carried out on one target
  - Apache and PHP-related operations on another
  - Firewall operations will need to be ran on both
- In a multi-node setup, the index.php file needs to be configured a bit differently
  - On the web server, configure with the IP address of the DB server
  - On the DB server, supply the IP Address of the web server to ensure it is given sufficient permissions in the MariaDB commands
- As far as the code goes, the only modification will be to index.php at around line 107 as this contains details regarding the MariaDB connection
- Repo link kodekloudhub/learning-app-ecommerce

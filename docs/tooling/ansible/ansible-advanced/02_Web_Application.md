# 2.0 - Web Application

## 2.1 - Web Application

- The web application to be used as a sample can be found at the following Github [repo](https://github.com/mmumshad/simple-webapp):

- It runs on the Python web framework Flask and the database system MySQL
- The application setup can be broken down into steps:
  - Server designation
  - Install Python and associated dependencies
  - Install, Configure and Start MySQL
  - Install Flask
  - Pull the source code
  - Deploy / Start the web server.

## 2.2 - Web Application Deployment Walkthrough

- It can be beneficial to test deployment out manually on one system before creating the playbook.
- To do so, simply run the required commands within the VM.
- Steps:

```bash
# Initial Dependencies
apt-get install -y python python-setuptools python-dev build-essential python-pip python-mysqldb

# Install MySQL and Configure
apt-get install -y mysql-server mysql-client

# Start the DB
service mysql start

# Create database user and sample table
# mysql -u <username> -p

mysql> CREATE DATABASE employee_db;
mysql> GRANT ALL ON *.* to db_user@'%' IDENTIFIED BY 'Passw0rd';
mysql> USE employee_db;
mysql> CREATE TABLE employees (name VARCHAR(20));

# Insert test data
mysql> INSERT INTO employees VALUES ('JOHN');

# Install Flask and associated web server tools
pip install flask
pip install flask-mysql

# Test deployment by running web server
FLASK_APP=app.py flask run --host=0.0.0.0

http://<IP>:5000                            => Welcome
http://<IP>:5000/how%20are%20you            => I am good, how about you?
http://<IP>:5000/read%20from%20database     => JOHN
```

## 2.3 - WebApp Installation Notes: CentOS

```bash
# Python and Pip Dependencies
sudo yum install -y epel-release python python-pip

sudo pip install flask flask-mysql

# If the above 2 throw errors:
sudo pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org flask flask-mysql

# MySQL Server
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm

sudo yum update

sudo yum -y install mysql-server

sudo service mysql start
```

- Reference playbook: <https://github.com/kodekloudhub/simple_web_application>

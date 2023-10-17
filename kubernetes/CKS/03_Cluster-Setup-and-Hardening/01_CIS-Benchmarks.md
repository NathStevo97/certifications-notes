# 3.1 - CIS Benchmarks

- **Security Benchmark** - Predefined standards and best practices that should be
implemented for server (or other appropriate device) security.
- **Areas of consideration include:**
  - Physical device configuration and limitation - USB ports that aren't expected to be used frequently / at all must have their access managed appropriately
  - Access configurations - What user accounts need to be configured? Can users log in as root?
    - Recommended that root is disabled by default and admins use sudo where required
    - Leads into only certain users having access to sudo, amongst other configurations
  - Network configuration
    - Firewall & IP Tables
    - Port Security
  - Service configuration
    - Ensure only certain services are allowed
  - Filesystem Configuration
    - All required permissions are set to the desired files
  - Auditing
    - Make sure all changes are logged for auditing purposes
  - Logging
- **CIS** - Centre for Internet Security
  - Commonly used tool to check if security best practices are implemented
  - Available on Linux, Windows, Cloud platforms, Mobile and many other platforms as well as Kubernetes.
- Can be downloaded from `https://www.cisecurity.org/cis-benchmarks/`
- Guides come with predefined instructions for your associated platform(s) best practices and how to implement them (commands included)
- CIS Provide tools such as the CIS-CAT tool to automate the assessment of best
practices implementation
  - If any best practices aren't implemented, they are logged in the resultant HTML output report in a detailed manner.

## Lab - Run CIS Benchmark Assessment Tool on Ubuntu

Q1: What is full form of CIS?
A: Center for Internet Security

Q2: What is not a function of CIS?
A: Monitor Global Internet Traffic

Q3: We have installed the CIS-CAT Pro Assessor tool called Assessor-CLI, under /root.

Please run the assessment with the Assessor-CLI.sh script inside Assessor-CLI directory and generate a report called index.html in the output directory `/var/www/html/`.

Once done, the report can be viewed using the Assessment Report tab located above the terminal.

Run the test in interactive mode and use below settings:

Benchmarks/Data-Stream Collections: : CIS Ubuntu Linux 18.04 LTS Benchmark
v2.1.0
Profile : Level 1 - Server

A:

- Run Assessor-CLI.sh
- Note options:
  - `-i (interactive)`
  - `--rd <reports dir>`
  - `--rp <report prefix>`
- Run Assessor-CLI.sh with options for `/var/www/html/` and
index.html respectively (and `--nts`) and `-i`
- **Note:** Run options in order that they are displayed
- Apply conditions for benchmark setting and profiles

**Q4:** How many tests failed for 1.1.1 Disable unused filesystems?

**A:** View report via tab and note - 6

**Q5:** How many tests passed for 2.1 Special Purpose Services?

**A:** ditto - 18

**Q6:** What parameters should we set to fix the failed test 5.3.10 Ensure SSH
root login is disabled?

**A:** PermitRootLogin no

**Q7:** Fix the failed test - 1.7.6 Ensure local login warning banner is
configured properly?

**A:** Find in CIS Report, run the associated command

**Q8:** Fix the failed test - 4.2.1.1 Ensure rsyslog is installed

**A:** Find area in report and run command

**Q9:** Fix the failed test - 5.1.2 Ensure permissions on /etc/crontab
are configured

**A:** Find area in report and run command

**Q10:** In the previous questions we fixed the below 3 failed tests. Now run
CIS-CAT tool test again and verify that all the below tests pass.

- 1.7.6 Ensure local login warning banner is configured properly
- 4.2.1.1 Ensure rsyslog is installed
- 5.1.2 Ensure permissions on /etc/crontab are configured

Run below command again to confirm that tests are passing now
`sh ./Assessor-CLI.sh -i -rd /var/www/html/ -nts -rp index`

Use below setting while running tests
Benchmarks/Data-Stream Collections: : CIS Ubuntu Linux 18.04 LTS
Benchmark v2.1.0
Profile : Level 1 - Server
A: Copy command and check associated tests pass - revisit questions
if failed

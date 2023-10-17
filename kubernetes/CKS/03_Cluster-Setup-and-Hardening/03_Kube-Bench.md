# 3.3 - Kube-Bench

- An open-source tool from Acqua security that can automate assessment of
Kubernetes deployments in line with best practices
- The assessment occurs against the CIS Benchmarks
- To get started can either:
  - Deploy via Docker Container
  - Deploy as a pod in Kubernetes
  - Install the associated binaries
  - Compile from source

## Lab - Kube-Bench

Q1: Kube-Bench is a product of which company?
A: Aqua Security

Q2: What should Kube-Bench be used for?
A: To check whether Kubernetes is deployed in line with best practices for security

Q3: Install Kube Bench in /root - version 0.4.0, Download file:
kube-bench_0.4.0_linux_amd64.tar.gz

A:
`curl -L https://github.com/aquasecurity/kube-bench/releases/download/v0.4.0/kube-bench_0.4.0_l
inux_amd64.tar.gz -o kube-bench_0.4.0_linux_amd64.tar.gz
tar -xvf kube-bench_0.4.0_linux_amd64.tar.gz`

Q4: Run a kube-bench test now and see the results Run below command to run kube bench

`./kube-bench --config-dir <pwd>/cfg --config <pwd>/cfg/config.yaml`

A: Follow instructions

Q5: How many tests passed forEtcd Node Configuration?

A: Review and report back - Section 2 and 7 pass

Q6: How many tests failed for Control Plane Configuration?
A: Review and report back - Section 3 and 0 failed

Q7: Fix this failed test 1.3.1 Ensure that the `--terminated-pod-gc-threshold`
argument is set as appropriate
Follow exact commands given in Remediation of given test

A: Find section in output and follow command

Edit the Controller Manager pod specification file
`/etc/kubernetes/manifests/kube-controller-manager.yaml`
on the master node and set the `--terminated-pod-gc-threshold` to an appropriate
threshold,
for example:
`--terminated-pod-gc-threshold=10`

Q8: Fix this failed test 1.3.6 Ensure that the RotateKubeletServerCertificate
argument is set to true
Follow exact commands given in Remediation of given test

A: Find section and follow instructions: Edit the Controller Manager pod specification file `/etc/kubernetes/manifests/kube-controller-manager.yaml`
on the master node and set the `--feature-gates` parameter to include
RotateKubeletServerCertificate=true.

`--feature-gates=RotateKubeletServerCertificate=true`

Q9: Fix this failed test 1.4.1: Ensure that the --profiling argument is set
to false

A: Follow exact commands given in Remediation of given test

Q10:
Run the kube-bench test again and ensure that all tests for the fixes we
implemented now pass

- 1.3.1 Ensure that the --terminated-pod-gc-threshold argument
is set as appropriate
- 1.3.6 Ensure that the RotateKubeletServerCertificate
argument is set to true
- 1.4.1: Ensure that the --profiling argument is set to false

A: Run command - ./kube-bench --config-dir `pwd`/cfg --config `pwd`/cfg/config.yaml

And verify

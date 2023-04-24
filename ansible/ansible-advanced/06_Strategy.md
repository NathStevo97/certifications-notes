# 6.0 - Strategy

Status: Done

# 6.1 - Introduction

- Strategy defines how a playbook is executed within Ansible
- When ansible runs, it runs one task after another by default - Linear strategy
- On a single-node application, this is pretty straightforward, but suppose you have a database and web server, and you cannot run the web server until the database server is configured, but other tasks could be ran in parallel, e.g. common dependency installation.
- Free strategy will cause each server to run its own tasks on its own, no server will wait for another.
- Batch processing, whilst not an out-and-out strategy (uses the linear strategy), can be used to run x sets of tasks simultaneously e.g. for a group of 10 servers, run on 2 servers at any given point. Use `serial` to define this.
    - `serial` will accept arrays, this is commonly used for rolling updates e.g.:
    `- 2`
    `- 3`
    `-5`
    - For percentages e.g. run on 20% of a group at any given point: `serial: "20%"`
- Other strategies can be implemented by developing custom plugins.

---

# Forks

- Ansible utilises forks to do parallel processing on hosts
- By default, the maximum is 5 for forks.
- This value can be edited in ansible.cfg, but one must ensure sufficient compute resources are available to allow this level of processing.
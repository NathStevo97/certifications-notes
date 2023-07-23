# 7.4 - Falco Configuration Files

- Main falco configuration file is located at /etc/falco/falco.yaml
  - Vieweable via either `journalctl -fu falco` or `/usr/lib/systemd/system/falco.service`
  - Contains all the configuration parameters associated with falco e.g. display format, output channel configuration etc.

- **Common options:**
  - How are rules loaded? Rules_file list
  - **Note:** The order of the rules files is important, as this is the order that falco will check them -> stick top priority rule files first.
  - Logging of events - what format or verbosity is used.
  - Minimum priority that should be logged determined by priority key (debug is the default)
  - Output channels:
    - `stdoutput` is set to true by default
    - Can configure output to a particular file in a similar manner or a particular program

```yaml
# Rules file prioritisation

rules_file:
- /etc/falco/falco_rules.yaml
- /etc/falco/falco_rules.local.yaml
- /etc/falco/k8s_audit_rules.yaml
- /etc/falco/rules.d

# Logging parameters:
json_output: false
log_stderr: true
log_syslog: true
log_level: info
```

```yaml
# Output channel example
file_output:
  enabled: true
  filename: /opt/falco/events.txt

program_output:
  enabled: true
  program: "jq '{text: .output}' | curl -d @- X POST https://hooks.slack.com/services/XXX"
```

- HTTP Endpoint Output Example:

```yaml
http_output:
  enabled: true
  url: http://some.url/some/path
```

- **Note:** For any changes made to this file, Falco must be restarted to take effect
- **Rules:**
  - Default file: `/etc/falco/falco_rules.yaml`
  - Any changes made to this file will be overwritten when updating the Falco package. To avoid, add to `/etc/falco/falc_rules.yaml`
- Example Config:

```yaml
- rule: Terminal Shell in container
  desc: A shell was used as the entrypoint/exec point into a container with an attached terminal
  condition: >
    spawned_process and container
    and shell_procs and proc.tty != 0
    and container_entrypoint
    and not user_expected_terminal_shell_in_container_conditions
  output: >
    A shell was spawned in a container with an attached terminal (user=%user.name user_loginuid=%user.loginuid %container.info
    shell=%proc.name parent=%proc.name cmdline=%proc.cmdline terminal=%proc.tty container_id=%container.id image=%container.image.repository)
  priority: NOTICE
```

- Hot reload can be used to avoid restarting the falco service and allow changes to take place:
  - Find the process ID of Falco at `/var/run/falco.pid`
  - Run a kill -l command: `kill -1 $(cat /var/run/falco.pid)`

## Reference Links

https://falco.org/docs/getting-started/installation/
https://github.com/falcosecurity/charts/tree/master/falco
https://falco.org/docs/rules/supported-fields/
https://falco.org/docs/rules/default-macros/
https://falco.org/docs/configuration/

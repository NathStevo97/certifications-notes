# 7.3 - Use Falco to Detect Threats

- Check that falco is running:
  - `systemctl status falco` (if running on host)
- Creating a pod as normal, in a separate terminal, one can ssh into the node and run: `journalctl -fu falco`
  - This allows inspection of the events generated / picked up by the falco service
  - **Note:** the `fu` flag allows events to be automatically added as they appear
- In the original terminal, executing a shell in the pod generates an event picked up by falco.
  - Details displayed include pod, namespace, container name, commands ran, etc.
- The same is applied for any activity ran.
- Falco implements several rules by default to detect events, such as creating a shell and reading particular files.
  - Rules are defined in `rules.yaml` file.
  - Elements included: rules, lists and macros
  - Rules:
    - Defines all the conditions for which an event should be triggered
      - **Rule** - Name of the rule
      - **Desc** - What is the detailed explanation of the rule
      - **Condition** - filtering expression applied against events matching the rule
      - **Output** - output generated for any events matching the rule
      - **Priority** - severity of the rule

- Custom rule example - shell opening in a contaienr anywhere not equal to root:

```yaml
- rule: detect shell inside a container
  desc: alert if a shell such as bash is open inside the container
  condition: container.id != host and proc.name = bash
  output: bash shell opened (user=%user.name %container.id)
  priority: WARNING
```

- **Note:** Conditions are used via Sysdig filters e.g:
  - `container.id`
  - `fd.name` (file descriptor)
  - `evt.type` (event type)
  - `user.name`
  - `container.image.repository`
- Outputs can utilise similar filters to the above.
- Priority can be any of the following, amongst others:
  - EMERGENCY
  - ALERT
  - DEBUG
  - NOTICE
- **Note:** For a set of similar commands e.g. opening any possible shell for the container, lists can be used:

```yaml
- rule: detect shell inside a container
  desc: alert if a shell such as bash is open inside the container
  condition: container.id != host and proc.name = bash
  output: bash shell opened (user=%user.name %container.id)
  priority: WARNING

  - list: linux_shells
    items: [bash, zsh, ksh, sh, csh]
```

- Macros can be used to shorten filters e.g.:

```yaml
- macro: container
  condition: container.id != host
```

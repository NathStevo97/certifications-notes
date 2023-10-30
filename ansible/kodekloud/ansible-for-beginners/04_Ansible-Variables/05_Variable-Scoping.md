# 4.5 - Variable Scoping

- Scope = How accessible a variable's value is.
- For example, if one host in a particular inventory file has an extra parameter set, that value is not available to the other hosts.
- Multiple scopes are available in ansible to deal with varying scenarios.

- **Host:**
  - A variable defined as a host variable, and is only accessible in a play(s) on that specific host.

- **Play:**
  - Variables defined at play-level and cannot be referenced by any other plays.

- **Global:**
  - Variables available across all plays, these are typically variables defined at CLI levels via `--extra-vars "<var name>=<var value>`
  
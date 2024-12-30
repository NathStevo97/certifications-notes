# 3.09 - Vault Auto-Complete

- [3.09 - Vault Auto-Complete](#309---vault-auto-complete)
  - [Auto-Completion Overview](#auto-completion-overview)

## Auto-Completion Overview

- Vault auto-complete allows automatic completion for input flags, subcommands and arguments in the vault CLI
- This would be achieved by pressing `[TAB]` when writing any commands like `seal`
- Note, this is is very similar to the autocomplete feature in Linux.
- To enable autocomplete, simply run the following command: `vault -autocomplete-install`
- Note: When a command hasn't been written following `vault <x>`, the autocomplete would provide options for the command.

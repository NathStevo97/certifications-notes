# 5.4 - Ansible-Lint

- Playbooks can become increasingly complex over time, leading to increased likelihood of deviation from best practice.
- Ansible-lint aims to mitigate these issues, this is a CLI tool that performs linting on ansible playbooks, roles, and collections.
  - The tool checks code for potential errors, bugs, stylistic errors and deviations from best practice.
- To use: `ansible-lint <yaml file>`
- Output provides guidance on any errors it finds and the locations of the incidents.

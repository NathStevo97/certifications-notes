# 5.16 - Raft Storage - Snapshot and Restore

- [5.16 - Raft Storage - Snapshot and Restore](#516---raft-storage---snapshot-and-restore)
  - [Overview](#overview)

## Overview

Snapshot and restore operations can be carried out via raft for the following commands:

`vault operator raft snapshot save <file>.snap`

`vault operator raft snapshot restore <file>.snap`

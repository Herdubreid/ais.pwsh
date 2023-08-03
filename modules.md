---
layout: default
title: Modules
nav_order: 5
has_children: true
---

## Modules

Celin.AIS is the basic module that with connection parameters that the other modules rely on.  It must be configured and authenticated before the other modules are used.

The connection parameters are stored in a PowerShell variable with the same name and the default variable is stored in an environment variable.

### Example

Connection named `Demo` is stored in variable `$Demo` and when in used as `$env:CELIN_DEFAULT_AIS = Demo`.

The other modules are.

- Celin.AIS.Query.  Submitting `CQL` statements.
- Celin.AIS.Script.  Managing `App Stack`.
- Celin.AIS.Ube.  Retrieving specification and submitting Ube.
- Celin.AIS.Text.  Managing Text Attachments.
- Celin.AIS.File.  Managing File Attachments.

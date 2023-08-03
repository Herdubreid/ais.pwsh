---
layout: default
title: Quick View
nav_order: 1
parent: How To's
---

## Quick View

This is the short introduction to the results of an Celin.AIS.Query or Celin.AIS.Script command.

Let's assume we have the `$ab` of the following Address Book query (from Get Started):

```powershell
$ab = Submit-Celin.AIS.Query "f0101 (an8,alph,at1) all(at1=C)"
```

### The State

The results are layered with the generic information in the top, or outer layer and becoming more specific on further drill down.

The top layer, or the state gives information such as the source and time of execution, as well as any error text returned from the execution.

**Note** There are two types of failures.  A terminal failure such as authorisation expired or invalid requests result in termination of the command with exception.  A successful request can however result in error which means that no data is returned.

To view the state, simply type the variable name.

![State Result](../img/result-state.png)

Individual state members are accessed with the dot operator.  For example to test if the command was successful, we check the `Error` member.

```powershell
$success = -not $ab.error
if ($success) { write-host "Success" } else { write-host "Failed" }
```

**Note** PowerShell is not case sensitive, so `Error` and `error` are equivalent.

## The Data

Most of the time the interest is on the `Data` member, exception being update scripts where success/failure is the only relevant result.

The `Data` members can be accessed with the dot operator, but a more informative display can be achieved with the `Get-Member` command.

![Data Result](../img/result-data.png)


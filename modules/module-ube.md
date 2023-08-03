---
layout: default
title: Celin.AIS.Ube
nav_order: 4
parent: Modules
---

## Celin.AIS.Ube

Module to manage batch jobs, or Ube's.

### Get-Celin.AIS.Ube

Get Ube's specification.

_Name_
: Ube name.

_Version_
: Ube version.

#### Example

Get specs for R0006P, version TEST001.  Store the result in variable `$ube`.

```powershell
$ube = get-celin.ais.ube r0006p test001
```

### Submit-Celin.AIS.Ube

Submit a Ube.

_Name_
: Ube name.

_Version_
: Ube version.

_DataSelection_ (Optional)
: Data selection.

_RiValues_ (Optional)
: Report Interchange values.

_PoValues_ (Optional)
: Processing Option values.

FireAndForget (Optional)
: Return after submission, don't wait for Ube's completion.

#### Example

Submit R0006P, version TEST001, with data selection. and don't wait for completion. Store the result in variable `$ube`.

```powershell
$ube = submit-celin.ais.ube r0006p test001 "MCU = 10" -FireAndForget
```

### Show-Celin.AIS.Ube

Show Ube's job status.

_JobNumber_
: The job number to show.

#### Example

Check the status on the job number from the previous submission.
Display the job status flag.

```powershell
$ube = show-celin.ais.ube $ube.data.jobnumber
$ube.data.jobstatus
```

---
layout: default
title: Celin.AIS.Script Module
nav_order: 5
has_children: false
---

## Celin.AIS.Script

Module for `Celin Script Language` statements.

### Open-Celin.AIS.Script

Open an [Application Stack Service](https://docs.oracle.com/en/applications/jd-edwards/cross-product/9.2/rest-api/api-application-stack-service.html) and store the `App Stack` in the default variable.

_FormName_
: Form name to open, with optional version.

_Action_ (Optional)
: One or more actions to perform.  See [Form/Grid Actions](https://celin.io/xl-docs/script.html) for reference.

_Query_ (Optional)
: Find Query.  See [Conditions](https://celin.io/xl-docs/query.html) for reference.

_Max_ (Optional)
: Max number of grid rows to return (use -1 for `No Max`).

_returnControlIDs_ (Optional)
: Controls to return.  See [Request Body](https://docs.oracle.com/en/applications/jd-edwards/cross-product/9.2/rest-api/op-v2-appstack-post.html) for reference.

#### Example

Open `Work With Orders to Receive` and press Find.  Store the results in variable `$rec`.
The `$rec.app` property should display `P4312_W4312F_ZJDE0001`;

```powershell
$rec = open-celin.ais.script "w4312f,zjde0001" "do(21)"
$rec.app
```

### Step-Celin.AIS.Script

Execute Form Action for default Application Stack.

_Action_
: : One or more actions to perform.  See [Form/Grid Actions](https://celin.io/xl-docs/script.html) for reference.

#### Example

Using the `App Stack` from the above example, select the first grid row and press Ok.  Store the results in variable `$rec1`
The `rec1.app` property should display `P4312_W4312A_ZJDE0001`.

```powershell
$rec1 = step-celin.ais.script "select(1.0) do(4)"
$rec1.app
```

### Close-Celin.AIS.Script

Close the `App Stack`.

#### Example

Close the default `App Stack`.  Since we don't assign the results a variable, it will be displayed.

```powershell
close-celin.ais.script
```

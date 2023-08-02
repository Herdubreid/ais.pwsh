---
layout: default
title: Celin.AIS.Query Module
nav_order: 4
has_children: false
---

## Celin.AIS.Query

Module for `Celin Query Language` statements.

### Submit-Celin.AIS.Query

Submit a `CQL` statement.

_Query_
: The `CQL` Statement.  For detail see [Query Reference](https://celin.io/xl-docs/query.html)


#### Examples

Get a list of address book number and name where search type is 'C' and store the results in variable `$ab`.

```powershell
$ab = submit-celin.ais.query "f0101 (an8,alph) all(at1=C)"
```

Get a list of open purchase orders and store the result in variable `$openPos`.

```powershell
$openPos = submit-celin.ais.query `
"f4311
(doco,dcto,lnid,litm,dsc1,uopn,prrc,aopn)
all(nxtr bw 280,400)"
```

__Note__: The above command use backtick (\`) to continue on the next line.

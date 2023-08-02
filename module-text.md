---
layout: default
title: Celin.AIS.Text Module
nav_order: 7
has_children: false
---

## Celin.AIS.Text

Module for managing Text Attachments.

### Get-Celin.AIS.Text

Get text attachment.

_Name_
: Attachment name.

_Key_
: Attachment key.

_Sequence_ (Optional)
: Attachment sequence if provided, otherwise all.

#### Example

Get address book text attachments (`ABGT`) for address book number 4242.

```powershell
$tmos = get-celin.ais.text abgt 4242
```

### Set-Celin.AIS.Text

Set text attachment.

_Name_
: Attachment name.

_Key_
: Attachment key.

_Text_
: Attachment Text.

_ItemName_ (Optional)
: Attachment's item name.

_Sequence_ (Optional)
: Attachment sequence.

_Append_ (Optional)
: Append to existing text (overwrites by default).

#### Example

Append the address book attachment.

```powershell
set-celin.ais.text abgt 4242 `
"Working on the Help..." -Sequence 1 -Append
```

### Remove-Celin.AIS.Text

Remove text attachment.

_Name_
: Attachment name.

_Key_
: Attachment key.

_Sequence_
: Attachment sequence.

### Example

Remove address book text attachment number 1 from 4242.

```powershell
remove-celin.ais.text abgt 4242  1
```

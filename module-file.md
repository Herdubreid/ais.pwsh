---
layout: default
title: Celin.AIS.File
nav_order: 8
has_children: false
---

## Celin.AIS.File

Module for managing File Attachments.

### Get-Celin.AIS.File

Download file attachments.

_Name_
: Attachment name.

_Key_
: Attachment key.

_Sequence_ (Optional)
: Attachment sequence.  A list of file attachments if not provided.

_Path_ (Optional)
: The file's destination.

#### Example

Get address book file attachment (`ABGT`) for address book number 4242 and sequence 1.  Use the default file name.

```powershell
$fa  = get-celin.ais.file abgt 4242 2
```

### Set-Celin.AIS.File

Upload file attachment.

_Name_
: Attachment name.

_Key_
: Attachment key.

_InputPath_
: File's source path.

_ItemName_ (Optional)
: Attachment's item name.

#### Example

Upload local file `celin.png` to address book attachment number 4242.

```powershell
$up = set-celin.ais.file abgt 4242 celin.png -ItemName "Smile"
```

### Remove-Celin.AIS.File

Remove file attachment.

_Name_
: Attachment name.

_Key_
: Attachment key.

_Sequence_
: Attachment sequence.

### Example

Remove address book file attachment number 2 from 4242.

```powershell
remove-celin.ais.file abgt 4242  1
```

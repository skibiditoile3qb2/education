' Fake "Virus" Prank VBScript -- Harmless!
Set sh = CreateObject("Wscript.Shell")

MsgBox "Critical Error: Unusual activity detected.", vbCritical, "System Alert"
MsgBox "Initializing system check...", vbInformation, "System"
WScript.Sleep 500

' Open Notepad
sh.Run "notepad.exe"
WScript.Sleep 800

' Open Calculator
sh.Run "calc.exe"
WScript.Sleep 900

' Open Paint
sh.Run "mspaint.exe"
WScript.Sleep 700

' Attempt to open Camera app (works on Windows 10+)
sh.Run "start microsoft.windows.camera:", 0, False
WScript.Sleep 1000

MsgBox "Encrypting your files...", vbExclamation, "Encryption"
WScript.Sleep 1000

' Flash Caps Lock (harmless, might not work on all systems)
For i = 1 To 3
    sh.SendKeys "{CAPSLOCK}"
    WScript.Sleep 400
Next

MsgBox "Your data is being uploaded...", vbCritical, "Data Leak"

MsgBox "Just kidding! This is NOT a virus.", vbInformation, "Lesson"
MsgBox "This was only a prank, no files were touched!", vbInformation, "You're Safe!"
MsgBox "Lesson: Never run downloads from people you don't absolutely trust! Stay safe :)", vbExclamation, "Safety First"

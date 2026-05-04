On Error Resume Next

Set sh = CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 1. Wallpaper: Download and set creepy image
Dim imgUrl, wallpapertmp, objXMLHTTP, objADOStream
imgUrl = "https://tse3.mm.bing.net/th/id/OIP.6EJEGYCZ2fQnowK0KxrBKAHaE8?rs=1&pid=ImgDetMain&o=7&rm=3"
wallpapertmp = fso.GetSpecialFolder(2) & "\creepywallpaper.jpg"

On Error Resume Next
' Download the image
Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
objXMLHTTP.Open "GET", imgUrl, False
objXMLHTTP.Send
If objXMLHTTP.Status = 200 Then
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Type = 1
    objADOStream.Open
    objADOStream.Write objXMLHTTP.responseBody
    objADOStream.SaveToFile wallpapertmp, 2
    objADOStream.Close
    sh.RegWrite "HKCU\Control Panel\Desktop\Wallpaper", wallpapertmp
    sh.Run "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters", 0, True
End If

' 2. Open system and web apps (creepy effects)
OpenIt "notepad.exe"
WScript.Sleep 800
OpenIt "calc.exe"
WScript.Sleep 700
OpenIt "mspaint.exe"
WScript.Sleep 700
OpenIt "explorer.exe"
WScript.Sleep 500
OpenIt "https://en.wikipedia.org/wiki/Uncanny_valley"
OpenIt "https://theuselessweb.com/"
WScript.Sleep 1100

' 3. Play beeps and popups
For i = 1 To 4
    sh.Beep
    WScript.Sleep 300 + (i*50)
Next

MsgBox "!!! UNKNOWN ERROR !!!", vbCritical, "0x80000423"
WScript.Sleep 700
MsgBox "A critical operation failed.", vbCritical, "System Failure"
WScript.Sleep 1100
MsgBox "WARNING: Malicious activity detected.", vbExclamation, "Security Center"
MsgBox "You cannot escape.", vbCritical, "RUN"
sh.Beep

' 4. Flicker keyboard lights (harmless, most modern PCs)
For i = 1 To 4
    sh.SendKeys "{CAPSLOCK}"
    sh.SendKeys "{SCROLLLOCK}"
    WScript.Sleep 280
Next

' 5. Move mouse randomly (if PowerShell available)
On Error Resume Next
sh.Run "powershell -NoP -W Hidden -Command for ($i=0; $i -lt 25; $i++) {Add-Type -AssemblyName PresentationCore; [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 900), (Get-Random -Minimum 0 -Maximum 600)); Start-Sleep -Milliseconds (Get-Random -Minimum 50 -Maximum 200)}", 0, False
WScript.Sleep 2000

' 6. Flash/flicker all open windows (simulate Alt+Tab and minimize/maximize)
For i = 1 To 5
    sh.SendKeys "%{TAB}"  ' Alt+Tab
    WScript.Sleep 250
    sh.SendKeys "^{ESC}"  ' Win key
    WScript.Sleep 200
Next
sh.SendKeys "^{ESC}"  ' minimize all
WScript.Sleep 500

MsgBox "Your computer belongs to us...", vbCritical, "WHO'S THERE?"
WScript.Sleep 1500

' Final message
MsgBox "This was only a LESSON: Be safe and don't run random files!" & vbCrLf & "Wallpaper and programs opened can be closed normally.", vbInformation, "EDUCATIONAL PRANK"

' ================= Helper: App/Web open with error handling ================
Sub OpenIt(s)
    On Error Resume Next
    sh.Run s, 1, False
End Sub

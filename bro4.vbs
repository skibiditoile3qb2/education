On Error Resume Next

Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Step 1: Download and set the new wallpaper
Dim imgUrl, imgPath, http, stream
imgUrl = "https://wallpaperaccess.com/full/2332759.jpg"
imgPath = fso.GetSpecialFolder(2) & "\mywallpaper.jpg"

Set http = CreateObject("MSXML2.XMLHTTP")
http.Open "GET", imgUrl, False
http.Send

If http.Status = 200 Then
    Set stream = CreateObject("ADODB.Stream")
    stream.Type = 1
    stream.Open
    stream.Write http.responseBody
    stream.SaveToFile imgPath, 2
    stream.Close
    sh.RegWrite "HKCU\Control Panel\Desktop\Wallpaper", imgPath
    sh.Run "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters", 0, True
End If

' Step 2: Open Camera app via explorer and wait a moment
sh.Run "explorer.exe microsoft.windows.camera:", 1, False
WScript.Sleep 2200  ' Wait for camera to launch

' Step 3: Show message
MsgBox "I'm watching you", vbExclamation, "Camera"

WScript.Sleep 900  ' Brief pause to ensure Camera app regains focus

' Step 4: Simulate spacebar (should trigger shutter/record)
sh.SendKeys " "

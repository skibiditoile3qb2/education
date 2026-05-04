On Error Resume Next

Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' --- 1. Download and set wallpaper ---
Dim imgUrl, imgPath, http, stream
imgUrl = "https://tse3.mm.bing.net/th/id/OIP.6EJEGYCZ2fQnowK0KxrBKAHaE8?rs=1&pid=ImgDetMain&o=7&rm=3"
imgPath = fso.GetSpecialFolder(2) & "\mywall.jpg"

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

' --- 2. Open Camera app (UWP) ---
sh.Run "start microsoft.windows.camera:", 1, False
WScript.Sleep 2000  ' Give camera app time to open

' --- 3. Show message ---
MsgBox "I'm watching you", vbExclamation, "Camera"

WScript.Sleep 1000 ' Give focus back to Camera app just in case

' --- 4. Simulate spacebar press ---
sh.SendKeys " "

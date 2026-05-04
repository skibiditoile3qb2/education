Dim sUrl, sPath, oXMLHTTP, oStream, oShell

sUrl = "https://wallpaperaccess.com/full/2332759.jpg"
sPath = Environ("TEMP") & "\wallpaper.jpg"

Set oXMLHTTP = CreateObject("MSXML2.XMLHTTP")
oXMLHTTP.Open "GET", sUrl, False
oXMLHTTP.setRequestHeader "User-Agent", "Mozilla/5.0"
oXMLHTTP.Send

If oXMLHTTP.Status = 200 Then
    Set oStream = CreateObject("ADODB.Stream")
    oStream.Type = 1
    oStream.Open
    oStream.Write oXMLHTTP.ResponseBody
    oStream.SaveToFile sPath, 2
    oStream.Close

    Set oShell = CreateObject("WScript.Shell")
    oShell.RegWrite "HKCU\Control Panel\Desktop\Wallpaper", sPath, "REG_SZ"
    oShell.RegWrite "HKCU\Control Panel\Desktop\WallpaperStyle", "10", "REG_SZ"
    oShell.RegWrite "HKCU\Control Panel\Desktop\TileWallpaper", "0", "REG_SZ"
    oShell.Run "rundll32.exe user32.dll,UpdatePerUserSystemParameters ,1, True", 1, True

    ' Open Camera app (UWP) using explorer protocol
    oShell.Run "explorer.exe microsoft.windows.camera:", 1, False

    ' Wait for camera to launch (increase if your PC is slow)
    WScript.Sleep 2200

    MsgBox "I'm watching you", vbExclamation, "Camera"

    ' Wait a little, then send spacebar to trigger shutter
    WScript.Sleep 900
    oShell.SendKeys " "
    
Else
    MsgBox "Failed. HTTP Status: " & oXMLHTTP.Status, vbCritical, "Error"
End If

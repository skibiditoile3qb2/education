' Download and set desktop wallpaper, open Camera app, simulate spacebar, show message

Dim sUrl, sPath, oXMLHTTP, oStream, oShell

sUrl = "https://wallpaperaccess.com/full/2332759.jpg"
sPath = Environ("TEMP") & "\wallpaper.jpg"

' Download the image
Set oXMLHTTP = CreateObject("MSXML2.XMLHTTP")
oXMLHTTP.Open "GET", sUrl, False
oXMLHTTP.Send

If oXMLHTTP.Status = 200 Then
    ' Save image to disk
    Set oStream = CreateObject("ADODB.Stream")
    oStream.Open
    oStream.Type = 1 ' Binary
    oStream.Write oXMLHTTP.ResponseBody
    oStream.SaveToFile sPath, 2 ' Overwrite
    oStream.Close

    Set oShell = CreateObject("WScript.Shell")

    ' Set as wallpaper via Registry
    oShell.RegWrite "HKCU\Control Panel\Desktop\Wallpaper", sPath, "REG_SZ"
    oShell.RegWrite "HKCU\Control Panel\Desktop\WallpaperStyle", "10", "REG_SZ"
    oShell.RegWrite "HKCU\Control Panel\Desktop\TileWallpaper", "0", "REG_SZ"

    ' Apply the change
    oShell.Run "rundll32.exe user32.dll,UpdatePerUserSystemParameters ,1, True", 1, True

    ' Open Camera app (UWP) using the recommended URI/explorer method
    oShell.Run "explorer.exe microsoft.windows.camera:", 1, False

    ' Wait for camera app to open (increase if system is slow)
    WScript.Sleep 2200

    ' Show creepy message
    MsgBox "I'm watching you", vbExclamation, "Camera"

    ' Wait and then simulate Spacebar (take picture/record)
    WScript.Sleep 900
    oShell.SendKeys " "

Else
    MsgBox "Failed to download image. HTTP Status: " & oXMLHTTP.Status, vbCritical, "Error"
End If

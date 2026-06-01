[Setup]
AppName=Among Us Modded Servers
AppVersion=1.0.0
AppPublisher=Fruityisgood
DefaultDirName={localappdata}\..\LocalLow\Innersloth\Among Us
DisableDirPage=yes
DefaultGroupName=Among Us Modded Servers
DisableProgramGroupPage=yes
OutputBaseFilename=AU_ModdedServersInstaller_v1.0.0
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

; Resources
SetupIconFile=resources\amongus.ico
WizardSmallImageFile=resources\amongus.bmp
WizardImageFile=resources\amongus.bmp
InfoBeforeFile=resources\before.txt
InfoAfterFile=resources\after.txt

AppMutex=Among Us.exe

[Files]
Source: "resources\regioninfo.json"; DestDir: "{app}"; Flags: ignoreversion

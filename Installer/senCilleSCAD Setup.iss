
[Setup]
OutputBaseFilename=Install senCilleSCAD
AppName=senCilleSCAD
AppVersion=1.0
DefaultDirName={pf}\senCilleSCAD
DefaultGroupName=senCilleSCAD
UninstallDisplayIcon={app}\uninstall senCilleSCAD.exe
Compression=lzma2
SolidCompression=yes
OutputDir=..\bin

[Files]
Source: "..\bin\senCilleSCAD.exe"; DestDir: "{app}"

[Icons]
Name: "{group}\senCilleSCAD"; Filename: "{app}\senCilleSCAD.exe"

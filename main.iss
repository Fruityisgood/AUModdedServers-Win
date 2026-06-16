[Setup]
AppName=Among Us Modded Servers
AppVersion=1.1.0
AppPublisher=Fruityisgood
DefaultDirName={code:GetTargetDir}
DisableDirPage=yes
DefaultGroupName=Among Us Modded Servers
DisableProgramGroupPage=yes
OutputBaseFilename=AU_ModdedServersInstaller_v1.1.0
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest
AppMutex=Among Us.exe

; Resources
SetupIconFile=resources\amongus.ico
WizardSmallImageFile=resources\amongus.bmp
WizardImageFile=resources\amongus.bmp
InfoBeforeFile=resources\before.txt
InfoAfterFile=resources\after.txt

[Files]
Source: "resources\regioninfo.json"; DestDir: "{app}"; Flags: ignoreversion

[Code]
var
  SelectedDir: String;
  msinstall: Boolean;
  targetFileName: String;

// Recursively search for file content
function FindFileWithContent(Path: String; SearchString: String): String;
var
  FindRec: TFindRec;
  FilePath: String;
  FileContent: AnsiString;
begin
  if FindFirst(Path + '\*', FindRec) then begin
    try
      repeat
        if (FindRec.Name <> '.') and (FindRec.Name <> '..') then begin
          FilePath := Path + '\' + FindRec.Name;
          if (FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then begin
            Result := FindFileWithContent(FilePath, SearchString);
            if Result <> '' then Exit;
          end else begin
            if LoadStringFromFile(FilePath, FileContent) then begin
              if Pos(SearchString, String(FileContent)) > 0 then begin
                Result := FilePath;
                Exit;
              end;
            end;
          end;
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

// Function called by {code:GetTargetDir}
function GetTargetDir(Param: String): String;
var
  SteamDir, MSBase: String;
begin
  SteamDir := ExpandConstant('{localappdata}\..\LocalLow\Innersloth\Among Us');
  
  if DirExists(SteamDir) then begin
    SelectedDir := SteamDir;
  end else begin
    MSBase := ExpandConstant('{localappdata}\Packages\Innersloth.AmongUs_fw5x688tam7rm\SystemAppData\wgs');
    if DirExists(MSBase) then begin
      targetFileName := FindFileWithContent(MSBase, 'CurrentRegionIdx');
      if targetFileName <> '' then begin
        SelectedDir := ExtractFilePath(targetFileName);
        msinstall := True;
      end else begin
        MsgBox('Error: Among Us is not installed or config file not found.', mbError, MB_OK);
        Abort;
      end;
    end else begin
      MsgBox('Error: Among Us installation path not found.', mbError, MB_OK);
      Abort;
    end;
  end;
  Result := SelectedDir;
end;

// Rename file after installation if needed
procedure CurStepChanged(CurStep: TSetupStep);
var
  SourcePath, DestPath: String;
begin
  // Only run this if we are in the post-install phase and msinstall is true
  if (CurStep = ssPostInstall) and msinstall then begin
    SourcePath := ExpandConstant('{app}\regioninfo.json');
    DestPath := targetFileName;

    // 1. Check if the destination file already exists
    if FileExists(DestPath) then begin
      // 2. Delete it to allow the rename to proceed
      DeleteFile(DestPath);
    end;

    // 3. Proceed with the rename
    if FileExists(SourcePath) then begin
      if not RenameFile(SourcePath, DestPath) then begin
        MsgBox('Failed to rename regioninfo.json. Please ensure the game is closed and try again.', mbError, MB_OK);
      end;
    end;
  end;
end;

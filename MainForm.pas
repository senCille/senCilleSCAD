unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.TMSBaseControl,
  FMX.TMSMemo, FMX.Controls.Presentation, FMX.Menus, FMX.Edit, FMX.Layouts, FMX.Objects,
  FMX.TMSMemoStyles, FMX.TMSMemoDialogs, FMX.ListBox;

type
  TOpenSCADStyler = class(TTMSFMXMemoCustomStyler)
     constructor Create(AOwner: TComponent); override;
  end;

  TFView = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    MainMenu: TMainMenu;
    MenuItemFile: TMenuItem;
    MenuItemSearch: TMenuItem;
    MenuItemNew: TMenuItem;
    Separator01: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemSaveAs: TMenuItem;
    Separator02: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemFind: TMenuItem;
    MenuItemReplace: TMenuItem;
    MenuItemRun: TMenuItem;
    MenuItemRunRun: TMenuItem;
    ToolBar: TToolBar;
    BtnLoadFromFile: TSpeedButton;
    Image4: TImage;
    BtnSaveToFile: TSpeedButton;
    Image5: TImage;
    BtnCut: TSpeedButton;
    Image6: TImage;
    BtnCopy: TSpeedButton;
    Image7: TImage;
    BtnPaste: TSpeedButton;
    Image8: TImage;
    BtnUndo: TSpeedButton;
    Image9: TImage;
    BtnRedo: TSpeedButton;
    Image10: TImage;
    LayoutSeparator1: TLayout;
    BtnBookmark: TSpeedButton;
    Image11: TImage;
    LayoutSeparator2: TLayout;
    BtnSearch: TSpeedButton;
    Image12: TImage;
    Layout2: TLayout;
    EditHighlight: TEdit;
    BtnHighlight: TSpeedButton;
    Image13: TImage;
    DialogSave: TSaveDialog;
    DialogOpen: TOpenDialog;
    DialogSearch: TTMSFMXMemoFindDialog;
    BtnRun: TSpeedButton;
    Image1: TImage;
    BtnLaunchOpenSCAD: TSpeedButton;
    DialogFindAndReplace: TTMSFMXMemoFindAndReplaceDialog;
    CheckBoxAutoSave: TCheckBox;
    CheckBoxAutoExecute: TCheckBox;
    TimerExecute: TTimer;
    BtnChangeTimerInterval: TSpeedButton;
    Image2: TImage;
    Layout1: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    MenuItemAbout: TMenuItem;
    ExpanderExecuteOptions: TExpander;
    TextEditor: TTMSFMXMemo;
    DialogGetOpenSCADPath: TOpenDialog;
    CheckBoxApplyViewAll: TCheckBox;
    PathDialog: TOpenDialog;
    BtnPathToExe: TSpeedButton;
    Image3: TImage;
    LabelExePath: TLabel;
    ComboBoxFileType: TComboBox;
    CheckBoxAndOpen: TCheckBox;
    BtnExport: TSpeedButton;
    Image14: TImage;
    EditFileName: TEdit;
    LabelExport: TLabel;
    StyleBookCustomized: TStyleBook;
    procedure BtnLoadFromFileClick(Sender: TObject);
    procedure BtnSaveToFileClick(Sender: TObject);
    procedure BtnUndoClick(Sender: TObject);
    procedure BtnRedoClick(Sender: TObject);
    procedure BtnPasteClick(Sender: TObject);
    procedure BtnCutClick(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure BtnBookmarkClick(Sender: TObject);
    procedure BtnHighlightClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure BtnRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItemReplaceClick(Sender: TObject);
    procedure MenuItemSaveAsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MenuItemNewClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure TextEditorKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure CheckBoxAutoExecuteChange(Sender: TObject);
    procedure BtnChangeTimerIntervalClick(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure BtnPathToExeClick(Sender: TObject);
    procedure EditFileNameDblClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  private
   const
    MainCaption = 'senCilleSCAD IDE';
    TextNotPath = 'Path to exe not informed';
   var
    FFileName       :string;
    FTempFileName   :string;
    FOpenSCADPath   :string;
    FINIFileName    :string;
    FTimerInterval  :Integer;
    FOpenSCADStyler :TOpenSCADStyler;
    FPathToExe      :string;
    procedure SetFileName(Value :string);
    function  GetOpenSCADPath:string;
    procedure CallWebHelp;
    procedure CreateDefaultConfigFile;
    procedure SaveConfiguration;
    function  CheckExtension(AFileName :string):string;
    function  OpenURL(sCommand: string):Integer;
    procedure SetPathToExe(Value :string);
  public
    property FileName     :string read FFileName       write SetFileName;
    property OpenSCADPath :string read GetOpenSCADPath write FOpenSCADPath;
    property PathToExe    :string read FPathToExe      write SetPathToExe;
  end;

var
  FView: TFView;

implementation

{$R *.fmx}

uses {$IFDEF ANDROID}
    FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText,
    Androidapi.JNI.Net, Androidapi.JNI.JavaTypes,
  {$ELSE}
     {$IFDEF IOS}
       iOSapi.Foundation, FMX.Helpers.iOS,
     {$ENDIF IOS}
  {$ENDIF ANDROID}

  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI, Winapi.Windows,
  {$ELSEIF DEFINED(MACOS)}
        Posix.Stdlib,
  {$ENDIF}
  {IdURI,}
  System.IOUtils, System.INIFiles,
  FMX.DialogService, FMX.DialogService.Async,
  AboutsenCille;
{}
constructor TOpenSCADStyler.Create(AOwner: TComponent);
var itm :TElementStyle;
begin
   inherited;
   BlockStart        := '{';
   BlockEnd          := '}';
   LineComment       := '//';
   MultiCommentLeft  := '/*';
   MultiCommentRight := '*/';
   CommentStyle.TextColor := TAlphaColorRec.Navy;
   CommentStyle.BkColor   := TAlphaColorRec.Null;
   CommentStyle.Style     := [TFontStyle.fsItalic];
   NumberStyle.TextColor  := TAlphaColorRec.Fuchsia;
   NumberStyle.BkColor    := TAlphaColorRec.Null   ;
   NumberStyle.Style      := [TFontStyle.fsBold]  ;

   itm := AllStyles.Add;
   itm.Info := 'OpenSCAD';
   itm.FontColor := TAlphaColorRec.Green;
   itm.Font.Style := [TFontStyle.fsBold];
   {--- Syntax ---}
   itm.KeyWords.Add('var'     );
   itm.KeyWords.Add('value'   );
   itm.KeyWords.Add('module'  );
   itm.KeyWords.Add('function');
   itm.KeyWords.Add('include' );
   itm.KeyWords.Add('use'     );
   {--- 2D ---}
   itm.KeyWords.Add('circle'  );
   itm.KeyWords.Add('square'  );
   itm.KeyWords.Add('polygon' );
   itm.KeyWords.Add('text'    );
   {--- 3D ---}
   itm.KeyWords.Add('sphere'    );
   itm.KeyWords.Add('cube'      );
   itm.KeyWords.Add('cylinder'  );
   itm.KeyWords.Add('polyhedron');
   {--- Transformations ---}
   itm.KeyWords.Add('translate');
   itm.KeyWords.Add('rotate'   );
   itm.KeyWords.Add('scale'    );
   itm.KeyWords.Add('resize'   );
   itm.KeyWords.Add('mirror'   );
   itm.KeyWords.Add('mulmatrix');
   itm.KeyWords.Add('color'    );
   itm.KeyWords.Add('offset'   );
   itm.KeyWords.Add('hull'     );
   itm.KeyWords.Add('minkowsky');
   {--- Boolean operations ---}
   itm.KeyWords.Add('union'       );
   itm.KeyWords.Add('difference'  );
   itm.KeyWords.Add('intersection');
   {--- Mathematical ---}
   itm.KeyWords.Add('abs'  );
   itm.KeyWords.Add('sign' );
   itm.KeyWords.Add('sin'  );
   itm.KeyWords.Add('cos'  );
   itm.KeyWords.Add('tan'  );
   itm.KeyWords.Add('acos' );
   itm.KeyWords.Add('asin' );
   itm.KeyWords.Add('atan' );
   itm.KeyWords.Add('atan2');
   itm.KeyWords.Add('floor');
   itm.KeyWords.Add('round');
   itm.KeyWords.Add('cell' );
   itm.KeyWords.Add('ln'   );
   itm.KeyWords.Add('len'  );
   itm.KeyWords.Add('let'  );
   itm.KeyWords.Add('log'  );
   itm.KeyWords.Add('pow'  );
   itm.KeyWords.Add('sqrt' );
   itm.KeyWords.Add('exp'  );
   itm.KeyWords.Add('rands');
   itm.KeyWords.Add('min'  );
   itm.KeyWords.Add('max'  );
   //itm.KeyWords.Add('
   //itm.KeyWords.Add('
   //itm.KeyWords.Add('
   //itm.KeyWords.Add('

     (*item
        Font.Family = 'Courier New'
        Font.Size = 8.000000000000000000
        FontColor = claBlue
        BGColor = claNull
        StyleType = stBracket
        BracketStart = #39
        BracketEnd = #39
        Info = 'Simple Quote'
      end
      item
        Font.Family = 'Courier New'
        Font.Size = 8.000000000000000000
        FontColor = claBlue
        BGColor = claNull
        StyleType = stBracket
        BracketStart = '"'
        BracketEnd = '"'
        Info = 'Double Quote'
      end
      item
        Font.Family = 'Courier New'
        Font.Size = 8.000000000000000000
        FontColor = claRed
        BGColor = claNull
        StyleType = stSymbol
        BracketStart = #0
        BracketEnd = #0
        Symbols = ' ,;:.()[]=-*/^%&^<>|!~'#13#10
        Info = 'Symbols Delimiters'
      end
      item
        CommentLeft = '/*'
        CommentRight = '*/'
        Font.Family = 'Courier New'
        Font.Size = 9.000000000000000000
        FontColor = claBlack
        BGColor = claNull
        StyleType = stKeyword
        BracketStart = #0
        BracketEnd = #0
        Info = 'Open SCAD'
      end>*)
    HintParameter.TextColor              := TAlphaColorRec.Black;
    HintParameter.BkColor                := TAlphaColorRec.Yellow;
    HintParameter.HintCharStart          := '(';
    HintParameter.HintCharEnd            := ')';
    HintParameter.HintCharDelimiter      := ';';
    HintParameter.HintClassDelimiter     := '.';
    HintParameter.HintCharWriteDelimiter := ',';
    HexIdentifier    := '0x'              ;
    Description      := 'Open SCAD Styler';
    Filter           := 'Open SCAD|*.scad';
    DefaultExtension := '.scad'           ;
    StylerName       := 'Open SCAD Styler';
    Extensions       := 'scad'            ;
    (*RegionDefinitions = <
      item
        Identifier = 'namespace'
        RegionStart = '{'
        RegionEnd = '}'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = '#region'
        RegionStart = '#region'
        RegionEnd = '#endregion'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'public'
        RegionStart = '{'
        RegionEnd = '}'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'private'
        RegionStart = '{'
        RegionEnd = '}'
        RegionType = rtClosed
        ShowComments = False
      end>*)
end;

procedure TFView.FormCreate(Sender: TObject);
var INIFile   :TIniFile;
    ExeName   :string;
    Extension :string;
    AppName   :string;
    AppFolder :string;
    FileType  :string;
begin
   FTimerInterval := 1500;
   FView.TimerExecute.Enabled := False;
   FView.ExpanderExecuteOptions.IsExpanded := False;
   FView.LabelExePath.Text := TextNotPath;
   FPathToExe := '';
   FView.TextEditor.Font.Family := 'Courier New';
   FView.TextEditor.Font.Size := 12;

   AppFolder    := TPath.GetDirectoryName(ParamStr(0));
   ExeName      := ExtractFileName(ParamStr(0));
   Extension    := ExtractFileExt (ParamStr(0));
   AppName      := Copy(ExeName, 1, Length(ExeName) - Length(Extension));
   FINIFileName := GetEnvironmentVariable('APPDATA')+PathDelim+AppName+'.ini';

   {--- Things in development ---}
   FView.CheckBoxApplyViewAll.Visible := False;
   FView.CheckBoxAndOpen.Visible      := False;
   {-----------------------------}

   if not TFile.Exists(FINIFileName) then begin
      CreateDefaultConfigFile;
   end;

   INIFile := TIniFile.Create(FINIFileName);
   try
      {OPTIONS}
      OpenSCADPath := INIFile.ReadString('OPTIONS', 'OpenSCADPath', '');
      FView.CheckBoxAutoSave.IsChecked    := INIFile.ReadString('OPTIONS', 'AutoSave', 'N') = 'Y';
      FView.CheckBoxAutoExecute.IsChecked := INIFile.ReadString('OPTIONS', 'AutoExecute', 'N') = 'Y';
      FileName := INIFile.ReadString('OPTIONS', 'LastFile', '');
      if FileName <> '' then begin
         if TFile.Exists(FileName) then begin
            FView.TextEditor.Lines.LoadFromFile(FileName);
            FView.TextEditor.SyntaxStyles := FOpenSCADStyler;
            FView.TextEditor.UseStyler    := True;
         end;
      end;
      FTimerInterval := INIFile.ReadInteger('OPTIONS', 'TimerInterval', 1500);

      PathToExe := INIFile.ReadString('EXECUTE', 'PathToExe', '');
      FView.CheckBoxApplyViewAll.IsChecked := INIFile.ReadString('EXECUTE', 'ApplyViewAll', 'Y') = 'Y';

      FView.CheckBoxAndOpen.IsChecked := INIFile.ReadString('EXPORT', 'AndOpen', 'Y') = 'Y';
      FView.EditFileName.Text         := INIFile.ReadString('EXPORT', 'FileName', '');
      FileType := INIFile.ReadString('EXPORT', 'FileType', '');
      if FileType = 'PNG' then FView.ComboBoxFileType.ItemIndex := 0 else
      if FileType = 'STL' then FView.ComboBoxFileType.ItemIndex := 1 else
      if FileType = 'OFF' then FView.ComboBoxFileType.ItemIndex := 2 else
      if FileType = 'DXF' then FView.ComboBoxFileType.ItemIndex := 3 else
      if FileType = 'CSG' then FView.ComboBoxFileType.ItemIndex := 4
      else FView.ComboBoxFileType.ItemIndex := -1;
   finally
      INIFile.Free;
   end;
   {--- Editor Configuration ---}
   FView.TextEditor.ActiveLineSettings.ActiveLineAtCursor      := True;
   FView.TextEditor.ActiveLineSettings.ShowActiveLine          := True;
   FView.TextEditor.ActiveLineSettings.ShowActiveLineIndicator := True;
   FView.TextEditor.AutoIndent      := True;
   FView.TextEditor.DelErase        := True;
   FView.TextEditor.SmartTabs       := True;
   FView.TextEditor.WantTab         := True;
   FView.TextEditor.ShowRightMargin := False;
   {---}
   FOpenSCADStyler := TOpenSCADStyler.Create(FView);
   FView.TextEditor.SyntaxStyles    := FOpenSCADStyler;
   FView.TextEditor.UseStyler       := True;
end;

procedure TFView.SaveConfiguration;
var INIFile :TIniFile;
    lBool   :string;
begin

   INIFile := TIniFile.Create(FINIFileName);
   try
      if FView.CheckBoxAutoSave.IsChecked then
         lBool := 'Y'
      else lBool := 'N';
      INIFile.WriteString('OPTIONS', 'AutoSave', lBool);

      if FView.CheckBoxAutoExecute.IsChecked then
         lBool := 'Y'
      else lBool := 'N';
      INIFile.WriteString('OPTIONS', 'AutoExecute', lBool);

      INIFile.WriteString('OPTIONS', 'LastFile', FileName);
      INIFile.WriteString('OPTIONS', 'LastFile', FileName);

      INIFile.WriteInteger('OPTIONS', 'TimerInterval', FTimerInterval);

      {-----}

      INIFile.WriteString('EXECUTE', 'PathToExe', PathToExe);

      if FView.CheckBoxApplyViewAll.IsChecked then
         lBool := 'Y'
      else lBool := 'N';
      INIFile.WriteString('EXECUTE', 'ApplyViewAll', lBool);

      if FView.CheckBoxAndOpen.IsChecked then
         lBool := 'Y'
      else lBool := 'N';
      INIFile.WriteString('EXPORT', 'AndOpen', lBool);

      INIFile.WriteString('EXPORT', 'FileName', EditFileName.Text);

      case FView.ComboBoxFileType.ItemIndex of
         0    :INIFile.WriteString('EXPORT', 'FileType', 'PNG');
         1    :INIFile.WriteString('EXPORT', 'FileType', 'STL');
         2    :INIFile.WriteString('EXPORT', 'FileType', 'OFF');
         3    :INIFile.WriteString('EXPORT', 'FileType', 'DXF');
         4    :INIFile.WriteString('EXPORT', 'FileType', 'CSG');
         else  INIFile.WriteString('EXPORT', 'FileType', ''   );
      end;

      INIFile.UpdateFile;
   finally
      INIFile.Free;
   end;
end;

procedure TFView.SetFileName(Value :string);
begin
   if FFileName <> Value then begin
      FFileName := Value;
      FView.Caption := ExtractFileName(Value) + '    ('+MainCaption+')';
   end;
end;

procedure TFView.SetPathToExe(Value: string);
begin
   if FPathToExe <> Value then begin
      FPathToExe := Value;
      LabelExePath.Text := Value;
   end;
end;

procedure TFView.BtnPathToExeClick(Sender: TObject);
begin
   if FView.PathDialog.Execute then begin
      PathToExe := FView.PathDialog.FileName;
   end;
end;

procedure TFView.TextEditorKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
   FView.TimerExecute.Enabled  := False;
   FView.TimerExecute.Interval := FTimerInterval;
   FView.TimerExecute.Enabled  := True;
end;

procedure TFView.BtnBookmarkClick(Sender: TObject);
begin
   FView.TextEditor.Bookmark[FView.TextEditor.CurY] := not FView.TextEditor.Bookmark[FView.TextEditor.CurY];
end;

procedure TFView.BtnChangeTimerIntervalClick(Sender: TObject);
var Value :Integer;
begin
   TDialogServiceAsync.InputQuery('Interval Between Executions', ['Miliseconds'], [IntToStr(FTimerInterval)],
      procedure(const AResult: TModalResult; const AValues: array of string)
      begin
         if AResult = mrOk then begin
            if TryStrToInt(AValues[0], Value) then
               FTimerInterval := Value;
         end;
      end
   );
end;

procedure TFView.BtnCopyClick(Sender: TObject);
begin
   FView.TextEditor.CopyToClipboard;
end;

procedure TFView.BtnCutClick(Sender: TObject);
begin
   FView.TextEditor.CutToClipboard;
end;

{$IFDEF MSWINDOWS}
// Runs application and returns PID. 0 if failed.
function RunApplication(const AExecutableFile, AParameters: string; const AShowOption: Integer = SW_SHOWNORMAL): Integer;
var _SEInfo: TShellExecuteInfo;
begin
   Result := 0;
   if not FileExists(AExecutableFile) then
     Exit;

   FillChar(_SEInfo, SizeOf(_SEInfo), 0);
   _SEInfo.cbSize := SizeOf(TShellExecuteInfo);
   _SEInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
   // _SEInfo.Wnd := Application.Handle;
   _SEInfo.lpFile := PChar(AExecutableFile);
   _SEInfo.lpParameters := PChar(AParameters);
   _SEInfo.nShow := AShowOption;
   if ShellExecuteEx(@_SEInfo) then begin
      WaitForInputIdle(_SEInfo.hProcess, 3000);
      Result := GetProcessID(_SEInfo.hProcess);
   end;
end;
{$ENDIF}

procedure TFView.BtnExportClick(Sender: TObject);
var Parameters  :string;
    NewFileName :string;
begin
   if FView.PathToExe.Trim = '' then begin
      ShowMessage('Indicate first, the path to de OpenSCAD executable.');
      Exit;
   end;

   if FView.FileName.Trim = '' then begin
      ShowMessage('Specify a name for the output file.');
      Exit;
   end;

   NewFileName := TPath.GetDirectoryName(FileName)+'\'+EditFileName.Text.Trim+'.'+ComboBoxFileType.Items[ComboBoxFileType.ItemIndex];
   Parameters := ' -o ';
   {$IFDEF MSWINDOWS}
   RunApplication(PathToExe, Parameters+' "'+NewFileName+'" "'+FTempFileName+'"');
   {$ENDIF}
   if FView.CheckBoxAndOpen.IsChecked then begin
      OpenURL('"'+NewFileName+'"');
      //ShellExecute(0, 'OPEN', PChar(NewFileName), '', '', SW_SHOWNORMAL);
   end;
          (*
             [ --camera=translatex,y,z,rotx,y,z,dist | \
               --camera=eyex,y,z,centerx,y,z ] \
             [ --autocenter ] \
             [ --viewall ] \
             [ --imgsize=width,height ] [ --projection=(o)rtho|(p)ersp] \
             [ --render | --preview[=throwntogether] ] \
             [ --colorscheme=[Cornfield|Sunset|Metallic|Starnight|BeforeDawn|Nature|DeepOcean] ] \
             [ --csglimit=num ]\
          *)


end;

procedure TFView.BtnHighlightClick(Sender: TObject);
begin
   FView.TextEditor.HighlightText := FView.EditHighlight.Text;
end;

procedure TFView.BtnLoadFromFileClick(Sender: TObject);
begin
   if FView.DialogOpen.Execute then begin
      FileName := FView.DialogOpen.FileName;
      FView.TextEditor.Lines.LoadFromFile(FFileName);
      FView.TextEditor.SyntaxStyles := FOpenSCADStyler;
      FView.TextEditor.UseStyler    := True;
   end;
end;

procedure TFView.BtnPasteClick(Sender: TObject);
begin
   FView.TextEditor.PasteFromClipboard;
end;

procedure TFView.BtnRedoClick(Sender: TObject);
begin
   FView.TextEditor.Redo;
end;

procedure TFView.BtnRunClick(Sender: TObject);
var Parameters :string;
begin
   Parameters := '';
   if FView.CheckBoxApplyViewAll.IsChecked then
         Parameters := ' --viewall ';

   //Parameters := ' --colorscheme=Metallic ';

   if FTempFileName.Trim = '' then begin
      FTempFileName := TPath.GetTempPath+ExtractFileName(TPath.GetRandomFileName)+'.scad';
      FView.TextEditor.Lines.SaveToFile(FTempFileName);
      if PathToExe.Trim <> '' then begin
         //RunApplication(PathToExe, Parameters+' "'+FTempFileName+'"');
         OpenURL(FTempFileName{+' '+Parameters});
         //ShellExecute(0, 'OPEN', PChar('"'+PathToExe+'" '+Parameters+'"'+FTempFileName+'"'), '', '', SW_SHOWNORMAL);

         (*
         --colorscheme=Metallic
             [ --camera=translatex,y,z,rotx,y,z,dist | \
               --camera=eyex,y,z,centerx,y,z ] \
             [ --autocenter ] \
             [ --viewall ] \
             [ --imgsize=width,height ] [ --projection=(o)rtho|(p)ersp] \
             [ --render | --preview[=throwntogether] ] \
             [ --colorscheme=[Cornfield|Sunset|Metallic|Starnight|BeforeDawn|Nature|DeepOcean] ] \
             [ --csglimit=num ]\
          *)

      end
      else OpenURL(FTempFileName);
   end
   else begin
      FView.TextEditor.Lines.SaveToFile(FTempFileName);
   end;
end;

function TFView.OpenURL(sCommand: string):Integer;
begin
   {$IF DEFINED(MACOS)}
      _system(PAnsiChar('open ' + '"' + AnsiString(sCommand) + '"'));
   {$ELSEIF DEFINED(MSWINDOWS)}
      Result := ShellExecute(0, 'OPEN', PChar(sCommand), '', '', SW_SHOWNORMAL);
   {$ELSEIF DEFINED(IOS)}
      Result := prvOpenURL(sCommand);
   {$ELSEIF DEFINED(ANDROID)}
      Result := prvOpenURL(sCommand);
   {$ENDIF}
end;

procedure TFView.BtnSaveToFileClick(Sender: TObject);
begin
   if FFileName.Trim <> '' then begin
      FView.TextEditor.Lines.SaveToFile(FFileName);
   end else
   if FView.DialogSave.Execute then begin
      FView.TextEditor.Lines.SaveToFile(FView.DialogSave.FileName);
   end;
end;

procedure TFView.BtnSearchClick(Sender: TObject);
begin
   FView.DialogSearch.Memo := FView.TextEditor;
   FView.DialogSearch.Execute;
end;

procedure TFView.BtnUndoClick(Sender: TObject);
begin
   FView.TextEditor.Undo;
end;

procedure TFView.CallWebHelp;
begin
   OpenURL('https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#'+FView.TextEditor.FullWordAtCursor);
end;

function TFView.GetOpenSCADPath:string;
var Path :string;
begin
   if FOpenSCADPath.Trim = '' then begin
      if FView.DialogGetOpenSCADPath.Execute then begin
         Path := FView.DialogGetOpenSCADPath.FileName;
         FOpenSCADPath := Path;
         Result := FOpenSCADPath;
      end;
   end
   else Result := FOpenSCADPath;
end;

procedure TFView.MenuItemSaveAsClick(Sender: TObject);
begin
   if FFileName.Trim <> '' then begin
      FView.DialogSave.FileName := ExtractFileName(FileName);
   end;

   if FView.DialogSave.Execute then begin
      FView.TextEditor.Lines.SaveToFile(FView.DialogSave.FileName);
      FileName := FView.DialogSave.FileName;
   end;
end;

procedure TFView.MenuItemAboutClick(Sender: TObject);
var View :TAboutInvoicingView;
begin
   View := TAboutInvoicingView.Create(Application);
   try
      View.ShowModal;
   finally
      View.Close;
   end;
end;

procedure TFView.MenuItemExitClick(Sender: TObject);
begin
   FView.Close;
end;

procedure TFView.MenuItemNewClick(Sender: TObject);
var AllowClear :Boolean;
begin
   if FView.TextEditor.Modified then begin
      TDialogService.PreferredMode := TDialogService.TPreferredMode.Platform;
      TDialogService.MessageDialog('do you want to discard current changes?', TMsgDlgType.mtConfirmation,
         [TMsgDlgBtn.mbOk, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, 0,
         procedure(const AResult: TModalResult)
         begin
            case AResult of
               mrOk    : AllowClear := True;
               mrCancel: AllowClear := False;
            end;
         end);
   end
   else AllowClear := True;

   if AllowClear then begin
      FileName := '';
      TextEditor.Clear;
   end;
end;

procedure TFView.MenuItemReplaceClick(Sender: TObject);
begin
   FView.DialogFindAndReplace.Memo := FView.TextEditor;
   FView.DialogFindAndReplace.Execute;
end;

procedure TFView.CreateDefaultConfigFile;
var INIFile :TIniFile;
begin
   INIFile := TIniFile.Create(FINIFileName);
   try
      INIFile.WriteString('OPTIONS', 'OpenSCADPath', '');
      INIFile.UpdateFile;
   finally
      INIFile.Free;
   end;
end;

procedure TFView.EditFileNameDblClick(Sender: TObject);
var Name :string;
    Ext  :string;
begin
   Name := ExtractFileName(FileName);
   Ext  := ExtractFileExt (Name    );
   EditFileName.Text := Copy(Name, 1, Length(Name) - Length(Ext));
end;

procedure TFView.CheckBoxAutoExecuteChange(Sender: TObject);
begin
   FView.TimerExecute.Enabled := FView.CheckBoxAutoExecute.IsChecked;
end;

function TFView.CheckExtension(AFileName :string):string;
var Extension :string;
begin
   Extension := TPath.GetExtension(AFileName);
   if Extension.Trim = '' then
      Result := AFileName+'.scad'
   else Result := AFileName;
end;

procedure TFView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var AllowClose :Boolean;
begin
   if FView.CheckBoxAutoSave.IsChecked then begin
      if FView.TextEditor.Modified then begin
         if FileName <> '' then begin
            FView.TextEditor.Lines.SaveToFile(FFileName);
            CanClose := True;
         end
         else begin
            FView.DialogSave.FileName := ExtractFileName(FileName);
            if FView.DialogSave.Execute then begin
               FileName := CheckExtension(FView.DialogSave.FileName);
               FView.TextEditor.Lines.SaveToFile(FileName);
               CanClose := True;
            end
            else CanClose := False;
         end;
      end
      else begin {Not modified}
         CanClose := True;
      end;
   end
   else begin {not Autosave checked}
      if FView.TextEditor.Modified then begin
         TDialogService.PreferredMode := TDialogService.TPreferredMode.Platform;
         TDialogService.MessageDialog('do you want to discard current changes?', TMsgDlgType.mtConfirmation,
            [TMsgDlgBtn.mbOk, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, 0,
            procedure(const AResult: TModalResult)
            begin
               case AResult of
                  mrOk    : AllowClose := True;
                  mrCancel: AllowClose := False;
               end;
            end);
         CanClose := AllowClose;
      end;
   end;

   if CanClose then SaveConfiguration;
end;

procedure TFView.FormDestroy(Sender: TObject);
begin
   FOpenSCADStyler.Free;
end;

procedure TFView.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
   case Key of
      vkF1 :begin FView.CallWebHelp; Key := 0; end;
      else begin
         case Key of
            //vkF3    :begin if FView.BtnModify.Enabled   then begin FView.BtnModify.SetFocus;   FView.BtnModify.OnClick(Self);   Key := 0; end; end;
            //vkF8    :begin if FView.BtnReport.Enabled   then begin FView.BtnReport.SetFocus;   FView.BtnReport.OnClick(Self);   Key := 0; end; end;
            vkF9    :begin if FView.BtnRun.Enabled   then begin FView.BtnRun.SetFocus;   FView.BtnRun.OnClick(Self);   Key := 0; end; end;
            //vkESCAPE:begin if FView.BtnCancel.Enabled   then begin FView.BtnCancel.SetFocus;   FView.BtnCancel.OnClick(Self);   Key := 0; end; end;
         end;
      end;
   end;
end;

end.


openscad     [ -o output_file [ -d deps_file ] ]\

             [ -m make_command ] [ -D var=val [..] ] \
             [ --help ] print this help message and exit \
             [ --version ] [ --info ] \

             [ --camera=translatex,y,z,rotx,y,z,dist | \
               --camera=eyex,y,z,centerx,y,z ] \
             [ --autocenter ] \
             [ --viewall ] \
             [ --imgsize=width,height ] [ --projection=(o)rtho|(p)ersp] \
             [ --render | --preview[=throwntogether] ] \
             [ --colorscheme=[Cornfield|Sunset|Metallic|Starnight|BeforeDawn|Nature|DeepOcean] ] \
             [ --csglimit=num ]\

             filename

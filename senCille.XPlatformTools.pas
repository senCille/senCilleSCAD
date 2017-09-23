unit senCille.XPlatformTools;

interface

{$INCLUDE PRODUCT_CONSTS.INC}

type
  TXPlatform = class
  private
    {$IF DEFINED(IOS)}
    class function prvOpenURL(const URL: string; const DisplayError: Boolean = False):Integer;
    {$ELSEIF DEFINED(ANDROID)}
    class function prvOpenURL(const URL: string; const DisplayError: Boolean = False):Integer;
    {$ENDIF}
  public
    class function OpenURL(sCommand: string):Integer;
    class procedure CallWebHelp(aHelpPath :string);
    class procedure CallWebPage(aHelpPath :string);
  end;

implementation

uses
  {$IFDEF ANDROID}
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
  {IdURI,} System.SysUtils, Classes, FMX.Dialogs;

class function TXPlatform.OpenURL(sCommand: string):Integer;
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

{$IFDEF IOS}
class function TXPlatform.prvOpenURL(const URL: string; const DisplayError: Boolean = False):Integer;
var NSU :NSUrl;
begin
   // iOS doesn't like spaces, so URL encode is important.
   NSU := StrToNSUrl(TIdURI.URLEncode(URL));
   if SharedApplication.canOpenURL(NSU) then begin
     exit(SharedApplication.openUrl(NSU));
   end
   else begin
     if DisplayError then begin
       ShowMessage('Error: Opening "' + URL + '" not supported.');
     end;
     Exit(False);
   end;
end;
{$ENDIF}

{$IFDEF ANDROID}
class function TXPlatform.prvOpenURL(const URL: string; const DisplayError: Boolean = False):Integer;
var Intent :JIntent;
begin
  // There may be an issue with the geo: prefix and URLEncode.
  // will need to research
  Intent := TJIntent.JavaClass.Init(TJIntent.JavaClass.ACTION_VIEW,
     TJnet_Uri.JavaClass.Parse(StringToJString(TIdURI.URLEncode(URL))));
  try
     SharedActivity.StartActivity(Intent);
     Exit(True);
  except
     on e: Exception do begin
        if DisplayError then ShowMessage('Error: ' + e.Message);
        Exit(False);
     end;
  end;
end;
{$ENDIF}

class procedure TXPlatform.CallWebHelp(aHelpPath :string);
begin
   TXPlatform.OpenURL(RootHelpPath + LowerCase(aHelpPath));
end;

class procedure TXPlatform.CallWebPage(aHelpPath :string);
begin
   TXPlatform.OpenURL(RootWebPath + LowerCase(aHelpPath));
end;

end.

unit AboutsenCille;

interface

uses System.Classes, System.UITypes, System.Math.Vectors,
     FMX.Viewport3D, FMX.StdCtrls, FMX.MaterialSources, FMX.Forms, FMX.Dialogs, FMX.Types,
     FMX.Objects, FMX.Effects, FMX.Forms3D, FMX.Controls3D, FMX.Controls, FMX.Ani, FMX.Layouts,
     FMX.Objects3D, FMX.Types3D, FMX.Materials, FMX.Controls.Presentation;

type
  TAboutInvoicingView = class(TForm)
    Rectangle1: TRectangle;
    ShadowEffect1: TShadowEffect;
    BtnClose: TButton;
    Text1: TText;
    Viewport3D1: TViewport3D;
    Light1: TLight;
    GlowEffect1: TGlowEffect;
    GouraudMaterialSource1: TLightMaterialSource;
    GouraudMaterialSource2: TLightMaterialSource;
    Cube1: TCube;
    FloatAnimation1: TFloatAnimation;
    ColorAnimation1: TColorAnimation;
    Text3D1: TText3D;
    Panel1: TPanel;
    LabelIcons8: TLabel;
    Label6: TLabel;
    LabelWebSenCille: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    procedure BtnCloseClick(Sender: TObject);
    procedure LabelIcons8Click(Sender: TObject);
    procedure LabelWebSenCilleClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    function OpenURL(sCommand: string):Integer;
  public
  end;

implementation

{$R *.fmx}

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
  {IdURI,} System.SysUtils;

procedure TAboutInvoicingView.BtnCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TAboutInvoicingView.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
   case Key of
      vkF9 :begin BtnClose.SetFocus; BtnClose.OnClick(Self); Key := 0; end;
   end;
end;

procedure TAboutInvoicingView.LabelIcons8Click(Sender: TObject);
begin
   OpenURL('https://icons8.com')
end;

procedure TAboutInvoicingView.LabelWebSenCilleClick(Sender: TObject);
begin
   OpenURL('http://senCille.es');
end;

function TAboutInvoicingView.OpenURL(sCommand: string):Integer;
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

end.

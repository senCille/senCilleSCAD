program senCilleSCAD;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {FView},
  senCille.XPlatformTools in 'senCille.XPlatformTools.pas',
  AboutsenCille in 'AboutsenCille.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFView, FView);
  Application.Run;
end.

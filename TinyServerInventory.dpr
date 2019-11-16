program TinyServerInventory;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  MainForm in 'MainForm.pas' {TSIForm},
  AddNewServerForm in 'AddNewServerForm.pas' {AddServerForm},
  MsgHelpers in 'MsgHelpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTSIForm, TSIForm);
  Application.CreateForm(TAddServerForm, AddServerForm);
  TStyleManager.TrySetStyle('Obsidian');
  Application.Run;
end.

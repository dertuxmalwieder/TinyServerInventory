unit AddNewServerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

type
  TAddServerForm = class(TForm)
    btnAddServer: TButton;
    Label1: TLabel;
    etNickname: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    etIPv6: TEdit;
    Label6: TLabel;
    etOS: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    etComment: TRichEdit;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    FDConnection1: TFDConnection;
    etIPv4: TEdit;
    Label9: TLabel;
    etDomain: TEdit;
    Label10: TLabel;
    procedure etNicknameChange(Sender: TObject);
    procedure btnAddServerClick(Sender: TObject);
  end;

var
  AddServerForm: TAddServerForm;

const
  WM_TSIMessage = WM_USER + 1;

implementation

{$R *.dfm}

procedure TAddServerForm.btnAddServerClick(Sender: TObject);
var
  ExistingID: Integer;
begin
  // Eindeutigkeit des Anzeigenamens prüfen:
  ExistingID := FDConnection1.ExecSQLScalar
    ('SELECT id FROM servers WHERE Nickname = :name', [etNickname.Text]);
  if ExistingID > 0 then
  begin
    // Server existiert schon.
    MessageDlg('Server nicknames have to be unique (for now) - sorry!',
      mtInformation, [mbOK], 0);
  end
  else
  begin
    // Server hinzufügen:
    FDConnection1.ExecSQL
      ('INSERT INTO servers (Nickname, PrimaryDomain, IPv4, IPv6, OperatingSystem, Comment) VALUES (:nickname, :domain, :ipv4, :ipv6, :os, :comment)',
      [etNickname.Text, etDomain.Text, etIPv4.Text, etIPv6.Text, etOS.Text, etComment.Text]);

    // MainForm benachrichtigen (für UI-Updates):
    PostMessage(Application.MainForm.Handle, WM_TSIMessage, 0,
      DWORD(PChar('updatetree')));

    // Dialog schließen:
    Close;
  end;
end;

procedure TAddServerForm.etNicknameChange(Sender: TObject);
begin
  if Trim(etNickname.Text) = '' then
    btnAddServer.Enabled := false
  else
    btnAddServer.Enabled := true;
end;

end.

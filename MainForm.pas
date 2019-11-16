unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes,
  System.Variants, System.Classes, Vcl.Graphics, Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ShellApi, IdHttp, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.Grids, Vcl.ValEdit, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient,
  // Eigene Klassen:
  AddNewServerForm, MsgHelpers;

const
  TSIVersion = '1612.2';
  TSIDatabaseFile = 'TinyServerInventory.db';
  TSISchema = 1;
  ExportFileName = 'Serverlist.txt';
  WM_TSIMessage = WM_USER + 1;

type
  TTSIForm = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mnuAbout: TMenuItem;
    TreeView1: TTreeView;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    btnAddConn: TButton;
    btnRemoveConn: TButton;
    N2: TMenuItem;
    mnuNANY: TMenuItem;
    grpDetails: TGroupBox;
    Label1: TLabel;
    btnSaveChanges: TButton;
    etNickname: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    etIPv6: TEdit;
    Label4: TLabel;
    etComment: TRichEdit;
    Label8: TLabel;
    btnAddService: TButton;
    Label5: TLabel;
    etOS: TEdit;
    mnuLicense: TMenuItem;
    IdHTTP1: TIdHTTP;
    btnExit: TButton;
    etIPv4: TEdit;
    btnPingIPv4: TButton;
    btnPingIPv6: TButton;
    Label6: TLabel;
    Label7: TLabel;
    vleServices: TStringGrid;
    Label9: TLabel;
    etDomain: TEdit;
    btnPingDomain: TButton;
    btnOpenInWeb: TButton;
    btnExportList: TButton;
    FDQuery2: TFDQuery;
    lblNoServers: TLabel;
    procedure mnuAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddConnClick(Sender: TObject);
    procedure btnRemoveConnClick(Sender: TObject);
    procedure mnuNANYClick(Sender: TObject);
    procedure btnAddServiceClick(Sender: TObject);
    procedure etNicknameChange(Sender: TObject);
    procedure etIPv4Change(Sender: TObject);
    procedure etIPv6Change(Sender: TObject);
    procedure etCommentChange(Sender: TObject);
    procedure vleServicesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure btnSaveChangesClick(Sender: TObject);
    procedure mnuLicenseClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnPingIPv4Click(Sender: TObject);
    procedure btnPingIPv6Click(Sender: TObject);
    procedure btnPingDomainClick(Sender: TObject);
    procedure btnOpenInWebClick(Sender: TObject);
    procedure etDomainChange(Sender: TObject);
    procedure btnExportListClick(Sender: TObject);
  private
    procedure TreeView1Click(Sender: TObject);
    procedure receiveMessage(var msg: TMessage); message WM_TSIMessage;
  end;

var
  AboutText: string;
  ServerList: TDictionary<Integer, string>;
  ActiveSelection: TPair<Integer, string>;

  LicenseText: string;
  IdHttp: TIdHTTP;

  TSIForm: TTSIForm;
  AddServerForm: TAddServerForm;
  RootNode: TTreeNode;

implementation

{$R *.dfm}

procedure CheckDatabase();
var
  TempSchema: Integer;
begin
  // Datenbank auf Vorhandensein prüfen
  if not fileexists(TSIDatabaseFile) then
  begin
    MessageDlgWithTitle('They took our database!', 'The database file ' +
      TSIDatabaseFile + ' seems to be missing.' + sLineBreak +
      'Sorry, I cannot continue.', mtError, [mbOK], 0);
    Application.Terminate;
  end;

  // DB-Schema abgleichen
  TempSchema := TSIForm.FDConnection1.ExecSQLScalar
    ('SELECT schema_ver FROM meta');
  if TempSchema <> TSISchema then
  begin
    MessageDlgWithTitle('Wrong schema version!',
      'The database schema version is incorrect. Sorry, I cannot continue.',
      mtError, [mbOK], 0);
    Application.Terminate;
  end;
end;

function DBResultOrNotSet(query: TFDQuery; Param: string): string;
begin
  // Abkürzung: Hole Queryparameter - wenn leer oder NULL, gib "(not set)" zurück.
  if (query[Param] = NULL) or (query[Param] = '') then
    Result := '(not set)'
  else
    Result := query[Param];
end;

procedure PopulateTreeBar();
begin
  // DB initialisieren
  TSIForm.FDQuery1.SQL.Text :=
    'SELECT id, Nickname FROM servers ORDER BY Nickname ASC';
  TSIForm.FDQuery1.Open;

  ServerList := TDictionary<Integer, string>.Create(); // init.

  TSIForm.TreeView1.Items.Clear;

  RootNode := TSIForm.TreeView1.Items.Add(nil, 'My Servers');

  while (not TSIForm.FDQuery1.Eof) do
  begin
    // über die Ergebnisse iterieren
    ServerList.Add(strtoint(TSIForm.FDQuery1['id']),
      TSIForm.FDQuery1['Nickname']);
    TSIForm.TreeView1.Items.AddChild(RootNode, TSIForm.FDQuery1['Nickname']);
    TSIForm.FDQuery1.Next;
  end;

  // Gibt es keine Server, dann sollte ein Infotext angezeigt und
  // der Export verunmöglicht werden.
  if TSIForm.FDQuery1.RowsAffected > 0 then
  begin
    TSIForm.lblNoServers.Visible := false;
    TSIForm.btnExportList.Enabled := true;
  end
  else
  begin
    TSIForm.lblNoServers.Visible := true;
    TSIForm.btnExportList.Enabled := false;
  end;

  TSIForm.FDQuery1.Close;

  TSIForm.TreeView1.FullExpand; // alles ausklappen
  TSIForm.TreeView1.OnClick := TSIForm.TreeView1Click; // On-Click-Handler
end;

function GetNodeByCaption(NodeCaption: string): TTreeNode;
var
  i: Integer;
begin
  // Gibt den TreeNode mit der übergebenen Beschriftung zurück.
  Result := nil;
  for i := 0 to TSIForm.TreeView1.Items.Count - 1 do
  begin
    if (TSIForm.TreeView1.Items[i].Text = NodeCaption) then
      Result := TSIForm.TreeView1.Items[i];
    Break;
  end;
end;

procedure DeleteServerItem(id: Integer);
begin
  TSIForm.FDConnection1.ExecSQL('DELETE FROM servers WHERE id = :id',
    [id.ToString]);

  PopulateTreeBar;
end;

procedure TTSIForm.receiveMessage(var msg: TMessage);
var
  txt: PChar;
begin
  txt := PChar(msg.lParam);
  msg.Result := 1;
  if txt = 'updatetree' then
    PopulateTreeBar;
end;

procedure TTSIForm.btnAddConnClick(Sender: TObject);
begin
  AddServerForm := TAddServerForm.Create(nil);
  try
    AddServerForm.ShowModal;
  finally
    AddServerForm.Free;
  end;
end;

procedure TTSIForm.btnAddServiceClick(Sender: TObject);
begin
  vleServices.RowCount := vleServices.RowCount + 1;
  if Trim(etNickname.Text) <> '' then
    btnSaveChanges.Enabled := true;
end;

procedure TTSIForm.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TTSIForm.btnExportListClick(Sender: TObject);
var
  OutputString: string;
  OutputFile: TextFile;
  IndentationOuter, IndentationInner: string;
  i, j: Integer;
begin
  // Export als Textdatei
  OutputString := 'Servers' + sLineBreak;

  FDQuery1.SQL.Text :=
    'SELECT id, Nickname, PrimaryDomain, IPv4, IPv6, OperatingSystem, Comment FROM servers ORDER BY Nickname ASC';
  FDQuery1.Open;

  i := FDQuery1.RowsAffected - 1; // wird bis 0 runtergezählt

  while not FDQuery1.Eof do
  begin
    if i > 0 then
      // Es gibt ein nächstes Ergebnis. Zeichne Baum.
      IndentationOuter := ' |'
    else
      IndentationOuter := '  ';

    OutputString := OutputString + ' ├── ' + FDQuery1['Nickname'] + sLineBreak;
    OutputString := OutputString + IndentationOuter +
      '    ├── Primary Domain:   ';
    OutputString := OutputString + DBResultOrNotSet(FDQuery1, 'PrimaryDomain');
    OutputString := OutputString + sLineBreak;

    OutputString := OutputString + IndentationOuter +
      '    ├── IPv4 Address:     ';
    OutputString := OutputString + DBResultOrNotSet(FDQuery1, 'IPv4');
    OutputString := OutputString + sLineBreak;

    OutputString := OutputString + IndentationOuter +
      '    ├── IPv6 Address:     ';
    OutputString := OutputString + DBResultOrNotSet(FDQuery1, 'IPv6');
    OutputString := OutputString + sLineBreak;

    OutputString := OutputString + IndentationOuter +
      '    ├── Operating System: ';
    OutputString := OutputString + DBResultOrNotSet(FDQuery1,
      'OperatingSystem');
    OutputString := OutputString + sLineBreak;

    OutputString := OutputString + IndentationOuter +
      '    ├── Comment:          ';
    OutputString := OutputString + DBResultOrNotSet(FDQuery1, 'Comment');
    OutputString := OutputString + sLineBreak;

    OutputString := OutputString + IndentationOuter + '    └── Services';

    FDQuery2.SQL.Text :=
      'SELECT Name, Port, Comment FROM services WHERE Server=:id ORDER BY Name ASC';
    FDQuery2.ParamByName('id').Value := FDQuery1['id'];
    FDQuery2.Open;

    if FDQuery2.RowsAffected = 0 then
      OutputString := OutputString + ':         (not set)' + sLineBreak
    else
    begin
      OutputString := OutputString + sLineBreak;

      j := FDQuery2.RowsAffected - 1; // wird bis 0 runtergezählt

      while not FDQuery2.Eof do
      begin
        if j > 0 then
          // Es gibt ein nächstes Ergebnis. Zeichne Baum.
          IndentationInner := '        |'
        else
          IndentationInner := '         ';

        OutputString := OutputString + '        ├── Name: ' + FDQuery2['Name'] +
          sLineBreak;

        OutputString := OutputString + IndentationInner + '    ├── Port:      ';
        OutputString := OutputString + DBResultOrNotSet(FDQuery2, 'Port');
        OutputString := OutputString + sLineBreak;

        OutputString := OutputString + IndentationInner + '    └── Comment:   ';
        OutputString := OutputString + DBResultOrNotSet(FDQuery2, 'Comment');
        OutputString := OutputString + sLineBreak;

        // Abstand zwischen zwei Services
        OutputString := OutputString + IndentationInner + sLineBreak;

        j := j - 1;

        FDQuery2.Next;
      end;
    end;

    FDQuery2.Close;

    // Abstand zwischen zwei Servern
    OutputString := OutputString + IndentationOuter + sLineBreak;

    i := i - 1;

    FDQuery1.Next;
  end;
  FDQuery1.Close;

  AssignFile(OutputFile, ExportFileName);
  ReWrite(OutputFile);
  WriteLn(OutputFile, OutputString);
  CloseFile(OutputFile);

  MessageDlgWithTitle('Complete!',
    'A list of your servers has been exported as ' + ExportFileName + '.' +
    sLineBreak +
    'The file will be opened in your default text editor for your convenience.',
    mtInformation, [mbOK], 0);
  ShellExecute(Handle, 'open', PChar(ExportFileName), nil, nil, SW_SHOW);
end;

procedure TTSIForm.btnOpenInWebClick(Sender: TObject);
var
  URL: String;
begin
  URL := etDomain.Text;
  if not LowerCase(URL).StartsWith('http') then
    URL := 'http://' + URL;

  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOW);
end;

procedure TTSIForm.btnPingDomainClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar('cmd.exe'),
    PChar('/C ping -t -4 ' + etDomain.Text), nil, SW_SHOW);
end;

procedure TTSIForm.btnPingIPv4Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar('cmd.exe'),
    PChar('/C ping -t -4 ' + etIPv4.Text), nil, SW_SHOW);
end;

procedure TTSIForm.btnPingIPv6Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar('cmd.exe'),
    PChar('/C ping -t -4 ' + etIPv6.Text), nil, SW_SHOW);
end;

procedure TTSIForm.btnRemoveConnClick(Sender: TObject);
var
  buttonSelected: Integer;
begin
  buttonSelected := MessageDlgWithTitle('Confirmation',
    'Do you really intend to delete the server named "' +
    TreeView1.Selected.Text + '" from your database?', mtConfirmation,
    [mbYes, mbNo], 0);

  if buttonSelected = mrYes then
  begin
    DeleteServerItem(ActiveSelection.Key);

    // Durch das Löschen ist kein Eintrag mehr ausgewählt. UI anpassen.
    btnRemoveConn.Enabled := false;
    grpDetails.Visible := false;
  end;
end;

procedure TTSIForm.btnSaveChangesClick(Sender: TObject);
var
  i: Integer;
begin
  // Aktuellen Server wegspeichern :-)
  // 1. Metadaten:
  FDConnection1.ExecSQL
    ('UPDATE servers SET Nickname=:nick, PrimaryDomain=:domain, IPv4=:ipv4, IPv6=:ipv6, OperatingSystem=:os, Comment=:comment WHERE id = :id',
    [etNickname.Text, etDomain.Text, etIPv4.Text, etIPv6.Text, etOS.Text,
    etComment.Text, ActiveSelection.Key]);

  // 2. Services:
  FDConnection1.ExecSQL('DELETE FROM services WHERE Server=:id',
    [ActiveSelection.Key]);
  for i := 1 to vleServices.RowCount - 1 do
  begin
    // Jede Zeile als Service hinzufügen, sofern ein Name gesetzt ist.
    if vleServices.Rows[i].Strings[0] <> '' then
    begin
      FDQuery1.SQL.Text :=
        'INSERT INTO services (Name, Port, Comment, Server) VALUES (:name, :port, :comment, :server)';
      FDQuery1.ParamByName('name').Value := vleServices.Rows[i].Strings[0];
      FDQuery1.ParamByName('port').Value := vleServices.Rows[i].Strings[1];
      FDQuery1.ParamByName('comment').Value := vleServices.Rows[i].Strings[2];
      FDQuery1.ParamByName('server').Value := ActiveSelection.Key;
      FDQuery1.ExecSQL;
    end;
  end;

  // Liste aktualisieren:
  PopulateTreeBar;

  // Element im Baum neu fokussieren:
  TreeView1.Selected := GetNodeByCaption(etNickname.Text);
end;

procedure TTSIForm.etCommentChange(Sender: TObject);
begin
  if Trim(etNickname.Text) <> '' then
    btnSaveChanges.Enabled := true;
end;

procedure TTSIForm.etDomainChange(Sender: TObject);
begin
  if Trim(etNickname.Text) <> '' then
    btnSaveChanges.Enabled := true;

  if Trim(etDomain.Text) <> '' then
  begin
    btnPingDomain.Enabled := true;
    btnOpenInWeb.Enabled := true;
  end
  else
  begin
    btnPingDomain.Enabled := false;
    btnOpenInWeb.Enabled := false;
  end;
end;

procedure TTSIForm.etIPv4Change(Sender: TObject);
begin
  if Trim(etNickname.Text) <> '' then
    btnSaveChanges.Enabled := true;

  if Trim(etIPv4.Text) <> '' then
    btnPingIPv4.Enabled := true
  else
    btnPingIPv4.Enabled := false;
end;

procedure TTSIForm.etIPv6Change(Sender: TObject);
begin
  if Trim(etNickname.Text) <> '' then
    btnSaveChanges.Enabled := true;

  if Trim(etIPv6.Text) <> '' then
    btnPingIPv6.Enabled := true
  else
    btnPingIPv6.Enabled := false;
end;

procedure TTSIForm.etNicknameChange(Sender: TObject);
begin
  if Trim(etNickname.Text) = '' then
    btnSaveChanges.Enabled := false
  else
    btnSaveChanges.Enabled := true;
end;

procedure TTSIForm.FormCreate(Sender: TObject);
begin
  CheckDatabase;
  PopulateTreeBar;

  vleServices.Cells[0, 0] := 'Name';
  vleServices.Cells[1, 0] := 'Port';
  vleServices.Cells[2, 0] := 'Comment';

  vleServices.Options := vleServices.Options + [goAlwaysShowEditor];
  vleServices.ColWidths[0] := 135;
  vleServices.ColWidths[2] := 120;
end;

procedure TTSIForm.mnuAboutClick(Sender: TObject);
begin
  // About
  AboutText := 'This is the Tiny Server Inventory application.' + sLineBreak +
    'Version: ' + TSIVersion + sLineBreak + sLineBreak +
    'Licensed under the terms of the WTFPLv2.' + sLineBreak +
    'http://wtfpl.net/txt/copying/' + sLineBreak + sLineBreak +
    'NANY 2017 build for DonationCoder.com.';
  if Random(100) > 85 then
    AboutText := AboutText + sLineBreak + sLineBreak + 'Linux sucks.';

  MessageDlgWithTitle('Ohai!', AboutText, mtInformation, [mbOK], 0);
end;

procedure TTSIForm.mnuLicenseClick(Sender: TObject);
begin
  IdHttp := TIdHTTP.Create(nil);
  try
    LicenseText := IdHttp.Get('http://www.wtfpl.net/txt/copying/');
    MessageDlgWithTitle('WTFPL license', LicenseText, mtInformation, [mbOK], 0);
  finally
    IdHttp.Free;
  end;
end;

procedure TTSIForm.mnuNANYClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    'http://www.donationcoder.com/forum/index.php?topic=43325.0', nil,
    nil, SW_SHOW);
end;

procedure TTSIForm.TreeView1Click(Sender: TObject);
var
  TempPair: TPair<Integer, string>;
begin
  // Klick auf einen Eintrag im Baum. Oder den Baum selbst.
  if (TreeView1.Selected.AbsoluteIndex = 0) or (TreeView1.Selected = nil) then
  begin
    // Es wurde der Ursprungsknoten ausgewählt.
    btnRemoveConn.Enabled := false;
    grpDetails.Visible := false;
  end
  else
  begin
    // Es wurde ein Kindknoten ausgewählt.
    // ActiveSelection zuweisen:
    ActiveSelection.Value := TreeView1.Selected.Text;
    // ID suchen:
    for TempPair in ServerList do
      if TempPair.Value = ActiveSelection.Value then
      begin
        // Nicknamen sind einheitlich, aktuelle ID also = End-ID.
        ActiveSelection.Key := TempPair.Key;
        Break;
      end;

    // Editfelder befüllen:
    FDQuery1.SQL.Text :=
      'SELECT Nickname, PrimaryDomain, IPv4, IPv6, OperatingSystem, Comment FROM servers WHERE id=:id';
    FDQuery1.ParamByName('id').Value := ActiveSelection.Key;
    FDQuery1.Open;

    if FDQuery1['Nickname'] <> NULL then
      etNickname.Text := FDQuery1['Nickname'];

    if FDQuery1['PrimaryDomain'] <> NULL then
      etDomain.Text := FDQuery1['PrimaryDomain'];

    if FDQuery1['IPv4'] <> NULL then
      etIPv4.Text := FDQuery1['IPv4'];

    if FDQuery1['IPv6'] <> NULL then
      etIPv6.Text := FDQuery1['IPv6'];

    if FDQuery1['OperatingSystem'] <> NULL then
      etOS.Text := FDQuery1['OperatingSystem'];

    if FDQuery1['Comment'] <> NULL then
      etComment.Text := FDQuery1['Comment'];

    if Trim(etIPv4.Text) <> '' then
      btnPingIPv4.Enabled := true
    else
      btnPingIPv4.Enabled := false;

    if Trim(etIPv6.Text) <> '' then
      btnPingIPv6.Enabled := true
    else
      btnPingIPv6.Enabled := false;

    if Trim(etDomain.Text) <> '' then
    begin
      btnPingDomain.Enabled := true;
      btnOpenInWeb.Enabled := true;
    end
    else
    begin
      btnPingDomain.Enabled := false;
      btnOpenInWeb.Enabled := false;
    end;

    FDQuery1.Close;

    // Serviceliste laden:
    FDQuery1.SQL.Text :=
      'SELECT Name, Port, Comment FROM services WHERE Server=:id ORDER BY Name ASC';
    FDQuery1.ParamByName('id').Value := ActiveSelection.Key;
    FDQuery1.Open;

    vleServices.RowCount := 1;
    if FDQuery1.RowsAffected = 0 then
    // Dieser Server hat keine Services.
    begin
      vleServices.Cells[0, 1] := '';
      vleServices.Cells[1, 1] := '';
      vleServices.Cells[2, 1] := '';
    end
    else
    begin
      while not FDQuery1.Eof do
      begin
        // StringGrid füllen:
        vleServices.RowCount := vleServices.RowCount + 1;
        if FDQuery1['Name'] <> NULL then
          vleServices.Cells[0, vleServices.RowCount - 1] := FDQuery1['Name'];
        if FDQuery1['Port'] <> NULL then
          vleServices.Cells[1, vleServices.RowCount - 1] := FDQuery1['Port'];
        if FDQuery1['Comment'] <> NULL then
          vleServices.Cells[2, vleServices.RowCount - 1] := FDQuery1['Comment'];
        FDQuery1.Next;
      end;
    end;
    FDQuery1.Close;

    if vleServices.RowCount = 1 then
      vleServices.RowCount := 2;
    vleServices.FixedRows := 1;

    // Entfernen-Button aktivieren:
    btnRemoveConn.Enabled := true;
    grpDetails.Visible := true;
  end;
end;

procedure TTSIForm.vleServicesSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  if Trim(etNickname.Text) <> '' then
    btnSaveChanges.Enabled := true;
end;

end.

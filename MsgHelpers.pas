unit MsgHelpers;

interface

uses Vcl.Dialogs, Vcl.Forms;

// Als public im Interface definieren:
function MessageDlgWithTitle(const Title: String; const Msg: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;

implementation

function MessageDlgWithTitle(const Title: String; const Msg: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  // Zentrierter MessageDlg mit einstellbarem Titel
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Caption := Title;
      HelpContext := HelpCtx;
      HelpFile := '';
      Position := poMainFormCenter;
      result := ShowModal;
    finally
      Free;
    end;

end;

end.

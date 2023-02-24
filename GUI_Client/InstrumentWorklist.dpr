program InstrumentWorklist;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitEditSID in 'UnitEditSID.pas' {frmEditSID};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Instrument Worklist';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TfrmEditSID, frmEditSID);
  Application.Run;
end.

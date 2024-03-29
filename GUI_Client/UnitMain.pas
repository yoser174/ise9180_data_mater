unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, ComCtrls, DB, ADODB,
  Vcl.DBCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client;

type
  TFormMain = class(TForm)
    GroupBox2: TGroupBox;
    Panel2: TPanel;
    DBGrid2: TDBGrid;
    Label2: TLabel;
    dtpTgl: TDateTimePicker;
    ADOMySQL: TADOConnection;
    ADODSWorklist: TADODataSet;
    DSWorklist: TDataSource;
    ADODSMapped: TADODataSet;
    DSMapped: TDataSource;
    ADOCmd: TADOCommand;
    ADOQCek: TADOQuery;
    pnlDtl: TPanel;
    qDtl: TADOQuery;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DataSource1: TDataSource;
    BtnRefresh: TButton;
    lblSID: TPanel;
    btnEdit: TButton;
    btnKirim: TButton;
    DBText1: TDBText;
    cmdUpdate: TADOCommand;
    FDConnMySQL: TFDConnection;
    procedure FormActivate(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure dtpTglChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure btnEditClick(Sender: TObject);
    procedure btnKirimClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses UnitEditSID;

procedure TFormMain.BitBtn1Click(Sender: TObject);
begin
  // cek apakah sudah insert
  // if ADOQCek.Active then
  // ADOQCek.Active := False;
  // ADOQCek.SQL.Text := ' select id from worklist where sampleid = ' + quotedstr
  // (edSID.Text) + ' ';
  // ADOQCek.Active := True;
  // if (ADOQCek.RecordCount = 0) and (edSID.Text <> '') and
  // (length(edSID.Text) > 3) then
  // begin
  // ADOCmd.CommandText := '';
  // ADOCmd.CommandText := ' INSERT INTO worklist (sampleid) value(' + quotedstr
  // (edSID.Text) + ') ';
  // ADOCmd.Execute;
  // BtnRefreshClick(self);
  // edSID.Clear;
  // end
  // else
  // begin
  // edSID.SelectAll;
  // end;

end;

procedure TFormMain.btnEditClick(Sender: TObject);
begin
  frmEditSID.Seq := ADODSMapped.FieldByName('host_sample_id').AsString;
  frmEditSID.ShowModal;

end;

procedure TFormMain.btnKirimClick(Sender: TObject);
begin
  cmdUpdate.CommandText :=
    'UPDATE instrument_result set status = 2 where host_sample_id = ' +
    QuotedStr(ADODSMapped.FieldByName('host_sample_id').AsString);
  cmdUpdate.Execute;
  BtnRefreshClick(self);
  ShowMessage
    ('Pengiriman ke HOST berhasil. Harap sekitar 5 detik sebelum cek ke Infinity.');
end;

procedure TFormMain.BtnRefreshClick(Sender: TObject);
begin
  dtpTglChange(self);
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  if MessageDlg('Hapus semua SampleID pending di worklist ?', mtConfirmation,
    [mbYes, mbCancel], 0) = mrYes then
  begin
    ADOCmd.CommandText := '';
    ADOCmd.CommandText := ' DELETE FROM worklist ';
    ADOCmd.Execute;
    BtnRefreshClick(self);
  end;

end;

procedure TFormMain.DBGrid2CellClick(Column: TColumn);
begin
  if ADODSMapped.RecordCount > 0 then
  begin
    btnEdit.Enabled := True;
    if qDtl.Active then
      qDtl.Active := False;
    qDtl.SQL.Text := 'SELECT analyt_code,result_value ';
    qDtl.SQL.Text := qDtl.SQL.Text + ' FROM instrument_result ';
    qDtl.SQL.Text := qDtl.SQL.Text + 'WHERE  ';
    qDtl.SQL.Text := qDtl.SQL.Text + 'host_sample_id = ' +
      QuotedStr(ADODSMapped.FieldByName('host_sample_id').AsString);
    qDtl.SQL.Text := qDtl.SQL.Text + ' ORDER BY id desc ';
    qDtl.Active := True;
    if ADODSMapped.FieldByName('sample_id').AsString <> '' then
      btnKirim.Enabled := True;

  end;
end;

procedure TFormMain.dtpTglChange(Sender: TObject);
var
  y, m, d: word;
  sy, sm, sd, sSQL: string;
begin
  decodedate(dtpTgl.Date, y, m, d);
  sy := IntToStr(y);
  if m < 10 then
    sm := '0' + IntToStr(m)
  else
    sm := IntToStr(m);
  if d < 10 then
    sd := '0' + IntToStr(d)
  else
    sd := IntToStr(d);

  if ADODSMapped.Active then
    ADODSMapped.Active := False;
  sSQL := ' SELECT distinct sample_id,host_sample_id, max(audit_date) as audit_date  ';
  sSQL := sSQL + ' FROM  ';
  sSQL := sSQL + ' instrument_result ';
  sSQL := sSQL + ' WHERE host_sample_id is not null  ';
  sSQL := sSQL + ' AND DATE(audit_date) = ' +
    QuotedStr(sy + '-' + sm + '-' + sd);
  sSQL := sSQL + ' group by sample_id,host_sample_id ';
  sSQL := sSQL + ' ORDER BY id desc ';

  ADODSMapped.CommandText := sSQL;

  ADODSMapped.Active := True;

  btnKirim.Enabled := False;
  btnEdit.Enabled := False;

  if ADODSMapped.RecordCount > 0 then
  begin
    btnEdit.Enabled := True;
    if qDtl.Active then
      qDtl.Active := False;
    qDtl.SQL.Text := 'SELECT analyt_code,result_value ';
    qDtl.SQL.Text := qDtl.SQL.Text + ' FROM instrument_result ';
    qDtl.SQL.Text := qDtl.SQL.Text + 'WHERE  ';
    qDtl.SQL.Text := qDtl.SQL.Text + 'host_sample_id = ' +
      QuotedStr(ADODSMapped.FieldByName('host_sample_id').AsString);
    qDtl.SQL.Text := qDtl.SQL.Text + ' ORDER BY id desc ';
    qDtl.Active := True;
    if ADODSMapped.FieldByName('sample_id').AsString <> '' then
      btnKirim.Enabled := True;
  end;

end;

procedure TFormMain.FormActivate(Sender: TObject);
var
  y, m, d: word;
  sy, sm, sd, sSQL: string;
begin
  decodedate(now, y, m, d);
  sy := IntToStr(y);
  if m < 10 then
    sm := '0' + IntToStr(m)
  else
    sm := IntToStr(m);
  if d < 10 then
    sd := '0' + IntToStr(d)
  else
    sd := IntToStr(d);

  if ADOMySQL.Connected then
    ADOMySQL.Connected := False;
  ADOMySQL.Connected := True;
  if ADODSWorklist.Active then
    ADODSWorklist.Active := False;
  ADODSWorklist.Active := True;

  if ADODSMapped.Active then
    ADODSMapped.Active := False;
  sSQL := ' SELECT distinct sample_id,host_sample_id,max(audit_date) as audit_date  ';
  sSQL := sSQL + ' FROM  ';
  sSQL := sSQL + ' instrument_result ';
  sSQL := sSQL + ' WHERE ';
  sSQL := sSQL + ' DATE(audit_date) = ' + QuotedStr(sy + '-' + sm + '-' + sd);
  sSQL := sSQL + ' GROUP BY sample_id,host_sample_id ';
  sSQL := sSQL + ' ORDER BY id ';

  ADODSMapped.CommandText := sSQL;

  ADODSMapped.Active := True;

  dtpTgl.Date := now;
  // edSID.SetFocus;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  dtpTglChange(self);
end;

end.

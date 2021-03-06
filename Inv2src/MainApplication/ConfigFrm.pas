unit ConfigFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,omnixml,


  DB,
  DBXpress,
  FMTBcd,
  SqlExpr,

  DBClient,
  Provider;

type
  TfrmConfig = class(TForm)
    gbGroup: TGroupBox;
    Label10: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edServerIP: TEdit;
    edDbName: TEdit;
    edUserName: TEdit;
    edPassword: TEdit;
    btnOK: TButton;
    btnTestConnection: TButton;
    Label5: TLabel;
    edDbPort: TEdit;
    Label6: TLabel;
    edRptGroup: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnTestConnectionClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
     procedure readConfig();
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

uses uCiaXml, CommonLIB, CommonUtils;

{$R *.dfm}

{ TfrmConfig }

procedure TfrmConfig.readConfig;
var
xmlConn : TXMLConfig;
_app_address,_app_hostname,_app_database,_app_user,_app_password,_app_db_port,_app_rptgrooup:string;
begin

  try
    xmlConn:=TXMLConfig.Create(ExtractFilePath(Application.ExeName)+_config_file);

    if (xmlConn.ReadString('AppConfig','ADDRESS','')<>'') then
    begin
     _app_address:= xmlConn.ReadString('AppConfig','ADDRESS','');
     _app_hostname:= xmlConn.ReadString('AppConfig','HOSTNAME','');
     _app_database:=DecryptEx(xmlConn.ReadString('AppConfig','DATABASE',''));
     _app_user:=DecryptEx(xmlConn.ReadString('AppConfig','USER','sa'));
     _app_password:=DecryptEx(xmlConn.ReadString('AppConfig','PASSWORD','123456'));
     _app_db_port:=xmlConn.ReadString('AppConfig','PORT','3306');
     _app_rptgrooup:=xmlConn.ReadString('AppConfig','RPTGROUP','00');


     edServerIP.Text := _app_address;
     edDbName.Text := _app_database;
     edUserName.Text := _app_user;
     edPassword.Text := _app_password;
     edDbPort.Text := _app_db_port;
     edRptGroup.Text := _app_rptgrooup;
     
    end;


  except
    on err:Exception do
    begin
      MessageDlg(err.Message,mtError,[mbOK],0);
     // ShowMessage(_app_address+'-'+_app_database+'-'+_app_user+'-'+_app_password);

    end;
  end;


end;


procedure TfrmConfig.FormShow(Sender: TObject);
begin
readConfig;
end;

procedure TfrmConfig.btnOKClick(Sender: TObject);
var
xmlConn : TXMLConfig;
_app_address,_app_hostname,_app_database,_app_user,_app_password,_app_db_port:string;
begin

  try
    xmlConn:=TXMLConfig.Create(ExtractFilePath(Application.ExeName)+_config_file);

    //if (xmlConn.ReadString('AppConfig','ADDRESS','')='') then
    //begin
        // mssql connection
        xmlConn.WriteString('AppConfig','ADDRESS',edServerIP.Text);
        xmlConn.WriteString('AppConfig','HOSTNAME','localhost');
        xmlConn.WriteString('AppConfig','USER',EncryptEx(edUserName.Text));
        xmlConn.WriteString('AppConfig','PASSWORD',EncryptEx(edPassword.Text));
        xmlConn.WriteString('AppConfig','DATABASE',EncryptEx(edDbName.Text));
        xmlConn.WriteString('AppConfig','PORT',edDbPort.Text);
        xmlConn.WriteString('AppConfig','RPTGROUP',edRptGroup.Text);
        xmlConn.Save;
    //end;

     _app_address:= xmlConn.ReadString('AppConfig','ADDRESS','');
     _app_hostname:= xmlConn.ReadString('AppConfig','HOSTNAME','');
     _app_database:=DecryptEx(xmlConn.ReadString('AppConfig','DATABASE',''));
     _app_user:=DecryptEx(xmlConn.ReadString('AppConfig','USER','sa'));
     _app_password:=DecryptEx(xmlConn.ReadString('AppConfig','PASSWORD','123456'));
     _app_db_port:=xmlConn.ReadString('AppConfig','PORT','3306');


     ShowMessage('successfull.');
     Close;

  except
    on err:Exception do
    begin
      MessageDlg(err.Message,mtError,[mbOK],0);
     // ShowMessage(_app_address+'-'+_app_database+'-'+_app_user+'-'+_app_password);

    end;
  end;


end;


procedure TfrmConfig.btnTestConnectionClick(Sender: TObject);
var rep:boolean;
    conn : TSQLConnection;
xmlConn : TXMLConfig;
_app_address,_app_hostname,_app_database,_app_user,_app_password,_app_db_port:string;


begin

  try

    rep:=false;


    conn :=TSQLConnection.Create(nil);





    //xmlConn.Free;
     {
     _app_address:= xmlConn.ReadString('AppConfig','ADDRESS','');
     _app_hostname:= xmlConn.ReadString('AppConfig','HOSTNAME','');
     _app_database:=xmlConn.ReadString('AppConfig','DATABASE','');
     _app_user:=xmlConn.ReadString('AppConfig','USER','sa');
     _app_password:=xmlConn.ReadString('AppConfig','PASSWORD','123456');
     }
     _app_address:= edServerIP.Text;
     _app_hostname:= edServerIP.Text;
     _app_database:= edDbName.Text;
     _app_user:=edUserName.Text;
     _app_password:=edPassword.Text;
     _app_db_port := edDbPort.Text;


     with conn do
     begin

     { // for firebird with out delphi xe2
      Connected:=false;
      ConnectionName:='IBConnection';
      DriverName:='Interbase';
      GetDriverFunc:='getSQLDriverINTERBASE';
      LibraryName:='dbexpint.dll';
      //VendorLib:='fbembed.dll';
      VendorLib:='fbclient.dll';
      LoginPrompt:=false;

      //Params.Values['Database']:=ExtractFilePath(Application.ExeName)+'DB.FDB';
      Params.Values['Database']:='10.0.2.101:/fbdb/INV2.FDB';
      Params.Values['User_Name']:='sysdba';
      Params.Values['Password']:= 'masterkey';
      Params.Values['SQLDialect']:= '3';

      }

      Connected:=false;
      ConnectionName:='Devart MySQL Direct';
      DriverName:='DevartMySQLDirect';
      GetDriverFunc:='getSQLDriverMySQLDirect';
      LibraryName:='dbexpmda.dll';
      VendorLib:='not used';

      LoginPrompt:=false;
      (*
      //Params.Values['Database']:=ExtractFilePath(Application.ExeName)+'DB.FDB';
      Params.Values['HostName']:='10.0.2.101';// '192.168.2.16';//
      Params.Values['Database']:='inv2_db';
      Params.Values['DriverName']:='DevartMySQLDirect';
      Params.Values['User_Name']:='joni';
      Params.Values['Password']:= '123456';
      Params.Values['ServerCharSet']:= 'tis620';
      //Params.Values['SQLDialect']:= '3';
      *)
      //Params.Values['Database']:=ExtractFilePath(Application.ExeName)+'DB.FDB';
      Params.Values['HostName']:=_app_address;
      Params.Values['Database']:=_app_database;
      Params.Values['DriverName']:='DevartMySQLDirect';
      Params.Values['User_Name']:=_app_user;
      Params.Values['Password']:= _app_password;
      Params.Values['ServerCharSet']:= 'tis620';
      Params.Values['Server Port']:= _app_db_port;

      //Params.Values['SQLDialect']:= '3';






      Connected:=true;


      ShowMessage('Connection OK!!');




     end;
  except
    on err:Exception do
    begin
      rep:=false;
      MessageDlg(err.Message,mtError,[mbOK],0);
     // ShowMessage(_app_address+'-'+_app_database+'-'+_app_user+'-'+_app_password);

    end;
  end;



end;



procedure TfrmConfig.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then  Close;
end;

end.

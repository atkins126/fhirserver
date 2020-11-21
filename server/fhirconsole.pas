program fhirconsole;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ELSE}
  FastMM4,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, fsl_base, fsl_fpc, fsl_utilities, fdb_odbc_fpc,
  console_form, console_db_edit,
  console_tx_edit, console_ep_edit;

{$R *.res}

begin
  initialiseTZData(partnerFile('tzdata.tar.gz'));
  InitialiseODBC;

  RequireDerivedFormResource:=True;
  Application.Scaled:=True;

  Application.Initialize;
  Application.CreateForm(TMainConsoleForm, MainConsoleForm);
  Application.Run;
end.


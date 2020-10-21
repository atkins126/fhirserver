program FHIRConsole;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ELSE}
  FastMM4,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, ConsoleForm, FHIR.Support.Threads, frmServerConnection
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainConsoleForm, MainConsoleForm);
  Application.CreateForm(TServerConnectionForm, ServerConnectionForm);
  Application.Run;
end.


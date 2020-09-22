program ColorWheel_Test;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main
  { you can add units after this };

{$R *.res}

begin
  {$IF DECLARED(UseHeapTrace)}
	GlobalSkipIfNoLeaks := True; // supported as of debugger version 3.2.0
  {$ENDIF}

  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.


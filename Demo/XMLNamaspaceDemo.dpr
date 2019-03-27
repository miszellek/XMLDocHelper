// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program XMLNamaspaceDemo;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Fm_Main},
  XMLDocHelper in '..\XMLDocHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFm_Main, Fm_Main);
  Application.Run;
end.

program MiyelinMarking;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormMain},
  UMergeForm in 'UMergeForm.pas' {FormMerge},
  UHistForm in 'UHistForm.pas' {FormHist},
  UBlobColoring in '..\_ortak\UBlobColoring.pas',
  UGrayImage in '..\_ortak\UGrayImage.pas',
  UThresholding in '..\_ortak\UThresholding.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormMerge, FormMerge);
  Application.CreateForm(TFormHist, FormHist);
  Application.Run;
end.

unit Main;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdCtrls, ExtCtrls, Spin, Buttons,

  JPL.Colors, JPL.MemIniFile, ColorWheel, JPP.SimplePanel, JPP.ColorSwatch, JPP.BasicSpeedButton;

type


  { TFormMain }

  TFormMain = class(TForm)
    actEsc: TAction;
    actDrawWheels: TAction;
    Actions: TActionList;
    btnClose: TBitBtn;
    BtnChangeColor: TJppColorSwatchButton;
    BtnCopyColor: TJppColorSwatchButton;
    BtnPasteColor: TJppColorSwatchButton;
    cswComplementaryColor: TJppColorSwatchEx;
    cswTetradic3: TJppColorSwatchEx;
    cswTetradic1: TJppColorSwatchEx;
    cswTetradic2: TJppColorSwatchEx;
    imgTriadic: TImage;
    imgTetradic: TImage;
    cswCurrentColor: TJppColorSwatchEx;
    cswTriadic1: TJppColorSwatchEx;
    cswTriadic2: TJppColorSwatchEx;
    sbtnResetTriadicDegShift: TJppBasicSpeedButton;
    lblTriadicDegShift: TLabel;
    lblTetradicDegShift: TLabel;
    pnTriadicDegShift: TJppSimplePanel;
    lblTriadicColors: TLabel;
    lblTetradicColors: TLabel;
    pnTetradicDegShift: TJppSimplePanel;
    sbtnResetTetradicDegShift: TJppBasicSpeedButton;
    spedTriadicDegShift: TSpinEdit;
    spedTetradicDegShift: TSpinEdit;
    pnTriad: TJppSimplePanel;
    pnTriad1: TJppSimplePanel;
    procedure actDrawWheelsExecute(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure cswCurrentColorSelectedColorChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DrawColorWheel_Triadic;
    procedure DrawColorWheel_Tetradic;
    procedure SaveSettingsToIni;
    procedure LoadSettingsFromIni;
    procedure sbtnResetTetradicDegShiftClick(Sender: TObject);
    procedure sbtnResetTriadicDegShiftClick(Sender: TObject);
  private
    FIniFile: string;
    FUpdatingControls: Boolean;
    FCurrentColor: TColor;
    procedure SetCurrentColor(AValue: TColor);
  private
    property CurrentColor: TColor read FCurrentColor write SetCurrentColor;
  end;


const
  APP_NAME = 'Color Wheel';

var
  FormMain: TFormMain;



implementation


{$R *.lfm}



procedure TFormMain.FormCreate(Sender: TObject);
begin
  Caption := APP_NAME;
  Application.Title := APP_NAME;
  FIniFile := ChangeFileExt(ParamStr(0), '.ini');
  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;
  FCurrentColor := clYellow;
  LoadSettingsFromIni;
  cswCurrentColor.SelectedColor := FCurrentColor;
  actDrawWheels.Execute;
end;

procedure TFormMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SaveSettingsToIni;
end;

procedure TFormMain.actEscExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.cswCurrentColorSelectedColorChanged(Sender: TObject);
begin
  CurrentColor := cswCurrentColor.SelectedColor;
end;

procedure TFormMain.SetCurrentColor(AValue: TColor);
begin
  if FCurrentColor = AValue then Exit;
  FCurrentColor := AValue;
  actDrawWheels.Execute;
end;

procedure TFormMain.actDrawWheelsExecute(Sender: TObject);
var
  DegShiftTriadic, DegShiftTetradic: integer;
  clTriad1, clTriad2, clCompl, clTetr1, clTetr2, clTetr3: TColor;
begin
  if FUpdatingControls then Exit;

  DrawColorWheel_Triadic;
  DrawColorWheel_Tetradic;

  DegShiftTriadic := spedTriadicDegShift.Value;
  GetTriadicColors(FCurrentColor, clTriad1, clTriad2, DegShiftTriadic);
  cswTriadic1.SelectedColor := clTriad1;
  cswTriadic2.SelectedColor := clTriad2;
  clCompl := ComplementaryColor(FCurrentColor);
  cswComplementaryColor.SelectedColor := clCompl;
  sbtnResetTriadicDegShift.Visible := DegShiftTriadic <> 60;

  DegShiftTetradic := spedTetradicDegShift.Value;
  GetTetradicColors(FCurrentColor, clTetr1, clTetr2, clTetr3, DegShiftTetradic);
  cswTetradic1.SelectedColor := clTetr1;
  cswTetradic2.SelectedColor := clTetr2;
  cswTetradic3.SelectedColor := clTetr3;
  sbtnResetTetradicDegShift.Visible := DegShiftTetradic <> 90;
end;

procedure TFormMain.DrawColorWheel_Triadic;
begin
  DrawColorWheel(imgTriadic, CurrentColor, True, False, spedTriadicDegShift.Value, True, True, True, False);
end;

procedure TFormMain.DrawColorWheel_Tetradic;
begin
  DrawColorWheel(imgTetradic, CurrentColor, False, True, spedTetradicDegShift.Value, True, True, True, False);
end;

procedure TFormMain.SaveSettingsToIni;
var
  Ini: TJppMemIniFile;
begin
  Ini := TJppMemIniFile.Create(FIniFile, TEncoding.UTF8);
  try
    Ini.CurrentSection := 'MAIN';
    Ini.WriteFormPos(Self);
    Ini.WriteHtmlColor('CurrentColor', FCurrentColor);
    Ini.WriteInteger(spedTriadicDegShift, spedTriadicDegShift.Value);
    Ini.WriteInteger(spedTetradicDegShift, spedTetradicDegShift.Value);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

procedure TFormMain.LoadSettingsFromIni;
var
  Ini: TJppMemIniFile;
begin
  if not FileExists(FIniFile) then Exit;
  FUpdatingControls := True;
  Ini := TJppMemIniFile.Create(FIniFile, TEncoding.UTF8);
  try

    Ini.CurrentSection := 'MAIN';

    Ini.ReadFormPos(Self);

    FCurrentColor := Ini.ReadHtmlColor('CurrentColor', FCurrentColor);

    spedTriadicDegShift.Value :=
      Ini.ReadIntegerInRange(spedTriadicDegShift.Name, 60, spedTriadicDegShift.MinValue, spedTriadicDegShift.MaxValue);

    spedTetradicDegShift.Value :=
      Ini.ReadIntegerInRange(spedTetradicDegShift.Name, 90, spedTetradicDegShift.MinValue, spedTetradicDegShift.MaxValue);

  finally
    Ini.Free;
    FUpdatingControls := False;
  end;
end;

procedure TFormMain.sbtnResetTetradicDegShiftClick(Sender: TObject);
begin
  spedTetradicDegShift.Value := 90;
end;

procedure TFormMain.sbtnResetTriadicDegShiftClick(Sender: TObject);
begin
  spedTriadicDegShift.Value := 60;
end;


end.


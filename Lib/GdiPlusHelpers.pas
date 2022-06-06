unit GdiPlusHelpers;

{$IFDEF FPC}
  {$MODE DelphiUnicode} // must be UNICODE UTF-16! FPC default encoding = UTF-8
{$ENDIF}

{ Delphi GDI+ Library for use with Delphi 2009 or later.
  Copyright (C) 2009 by Erik van Bilsen.
  Email: erik@bilsen.com
  Website: www.bilsen.com/gdiplus

License in plain English:

1. I don't promise that this software works. (But if you find any bugs,
   please let me know!)
2. You can use this software for whatever you want. You don't have to pay me.
3. You may not pretend that you wrote this software. If you use it in a program,
   you must acknowledge somewhere in your documentation that you've used this
   code.

In legalese:

The author makes NO WARRANTY or representation, either express or implied,
with respect to this software, its quality, accuracy, merchantability, or
fitness for a particular purpose.  This software is provided "AS IS", and you,
its user, assume the entire risk as to its quality and accuracy.

Permission is hereby granted to use, copy, modify, and distribute this
software (or portions thereof) for any purpose, without fee, subject to these
conditions:
(1) If any part of the source code for this software is distributed, then the
License.txt file must be included, with this copyright and no-warranty notice
unaltered; and any additions, deletions, or changes to the original files
must be clearly indicated in accompanying documentation.
(2) If only executable code is distributed, then the accompanying
documentation must state that "this software is based in part on the Delphi
GDI+ library by Erik van Bilsen".
(3) Permission for use of this software is granted only if the user accepts
full responsibility for any undesirable consequences; the author accepts
NO LIABILITY for damages of any kind.

  ------------------------------------
  Jacek Pazera
  https://www.pazera-software.com
  https://github.com/jackdp

  2020.09.19
    Lazarus/FPC compatibility

  2022.05.06
    SetGPPenStyle
    GetGPFontName - Get the first GDI+ compatible font from the given array
    TransparencyToAlpha
    HatchStyleToStrID
    TryStrIDToHatchStyle
    GPFontList - List of GDI+ compatible fonts
}


{$IFDEF FPC}
  {$I GdiPlus_FPC.inc}
{$ELSE}
  {$I GdiPlus_DCC.inc}
{$ENDIF}


interface

uses
  Windows,
  {$IFDEF FPC}LCLIntf, LCLType,{$ENDIF}
  {$IFDEF DCC}{$IFDEF HAS_SYSTEM_UITYPES}System.UITypes,{$ENDIF}{$ENDIF}
  SysUtils,
  Classes,
  Graphics,
  Controls,
  GdiPlus;

type
  TGPCanvasHelper = class helper for TCanvas
  public
    function ToGPGraphics: IGPGraphics;
  end;

type
  TGPGraphicControlHelper = class helper for TGraphicControl
  public
    function ToGPGraphics: IGPGraphics;
  end;

type
  TGPCustomControlHelper = class helper for TCustomControl
  public
    function ToGPGraphics: IGPGraphics;
  end;

type
  TGPBitmapHelper = class helper for Graphics.TBitmap
  public
    function ToGPBitmap: IGPBitmap;
    procedure FromGPBitmap(const GPBitmap: IGPBitmap);
  end;

// jacek
procedure GdipCheck(const Status: TGPStatus); inline;
function GPPointF(const ax, ay: Single): TGPPointF; overload;
function GPPointF(const apt: TPoint): TGPPointF; overload;
function GPPointFMove(const Point: TGPPointF; const dx, dy: Single): TGPPointF;
function GPColor(const AColor: TColor; Alpha: Byte = 255): TAlphaColor;
function GPTextWidthF(gr: IGPGraphics; Text: {$IFDEF FPC}UnicodeString{$ELSE}string{$ENDIF}; Font: IGPFont; px: Single = 0; py: Single = 0): Single;
function GPTextHeightF(gr: IGPGraphics; Text: {$IFDEF FPC}UnicodeString{$ELSE}string{$ENDIF}; Font: IGPFont; px: Single = 0; py: Single = 0): Single;

procedure SetGPPenStyle(var Pen: IGPPen; const PenStyle: TPenStyle);
function GetGPFontName(const FontNameArray: array of string): string;
function TransparencyToAlpha(const TransparencyInPercent: Byte): Byte;
function FontStylesToGPFontStyle(const Style: TFontStyles): TGPFontStyle;
function GPFontStyleToFontStyles(const Style: TGPFontStyle): TFontStyles;
function GPFontStyleToStr(const FontStyle: TGPFontStyle): string;
function StrToGPFontStyle(FontStyleStr: string): TGPFontStyle;

function HatchStyleToStrID(const HatchStyle: TGPHatchStyle): string;
function TryStrIDToHatchStyle(const StrID: string; var hs: TGPHatchStyle): Boolean;



var
  GPFontList: TStringList;



implementation




{ TGPCanvasHelper }

function TGPCanvasHelper.ToGPGraphics: IGPGraphics;
begin
  Result := TGPGraphics.Create(Handle);
end;

{ TGPGraphicControlHelper }

function TGPGraphicControlHelper.ToGPGraphics: IGPGraphics;
begin
  Result := TGPGraphics.Create(Canvas.Handle);
end;

{ TGPCustomControlHelper }

function TGPCustomControlHelper.ToGPGraphics: IGPGraphics;
begin
  Result := TGPGraphics.Create(Canvas.Handle);
end;

{ TGPBitmapHelper }

procedure TGPBitmapHelper.FromGPBitmap(const GPBitmap: IGPBitmap);
begin
  Handle := GPBitmap.GetHBitmap(0);
end;

function TGPBitmapHelper.ToGPBitmap: IGPBitmap;
begin
  if (PixelFormat in [pf1Bit, pf4Bit, pf8Bit]) then
    Result := TGPBitmap.Create(Handle, Palette)
  else
    Result := TGPBitmap.Create(Handle, 0);
end;


// jacek
function HatchStyleToStrID(const HatchStyle: TGPHatchStyle): string;
var
  s: string;
begin
  case HatchStyle of
    HatchStyleHorizontal: s := 'Horizontal';
    HatchStyleVertical: s := 'Vertical';
    HatchStyleForwardDiagonal: s := 'ForwardDiagonal';
    HatchStyleBackwardDiagonal: s := 'BackwardDiagonal';
    HatchStyleCross: s := 'Cross';
    HatchStyleDiagonalCross: s := 'DiagonalCross';
    HatchStyle05Percent: s := '05Percent';
    HatchStyle10Percent: s := '10Percent';
    HatchStyle20Percent: s := '20Percent';
    HatchStyle25Percent: s := '25Percent';
    HatchStyle30Percent: s := '30Percent';
    HatchStyle40Percent: s := '40Percent';
    HatchStyle50Percent: s := '50Percent';
    HatchStyle60Percent: s := '60Percent';
    HatchStyle70Percent: s := '70Percent';
    HatchStyle75Percent: s := '75Percent';
    HatchStyle80Percent: s := '80Percent';
    HatchStyle90Percent: s := '90Percent';
    HatchStyleLightDownwardDiagonal: s := 'LightDownwardDiagonal';
    HatchStyleLightUpwardDiagonal: s:= 'LightUpwardDiagonal';
    HatchStyleDarkDownwardDiagonal: s := 'DarkDownwardDiagonal';
    HatchStyleDarkUpwardDiagonal: s := 'DarkUpwardDiagonal';
    HatchStyleWideDownwardDiagonal: s := 'WideDownwardDiagonal';
    HatchStyleWideUpwardDiagonal: s := 'WideUpwardDiagonal';
    HatchStyleLightVertical: s := 'LightVertical';
    HatchStyleLightHorizontal: s := 'LightHorizontal';
    HatchStyleNarrowVertical: s := 'NarrowVertical';
    HatchStyleNarrowHorizontal: s := 'NarrowHorizontal';
    HatchStyleDarkVertical: s := 'DarkVertical';
    HatchStyleDarkHorizontal: s := 'DarkHorizontal';
    HatchStyleDashedDownwardDiagonal: s := 'DashedDownwardDiagonal';
    HatchStyleDashedUpwardDiagonal: s := 'DashedUpwardDiagonal';
    HatchStyleDashedHorizontal: s := 'DashedHorizontal';
    HatchStyleDashedVertical: s := 'DashedVertical';
    HatchStyleSmallConfetti: s := 'SmallConfetti';
    HatchStyleLargeConfetti: s := 'LargeConfetti';
    HatchStyleZigZag: s := 'ZigZag';
    HatchStyleWave: s := 'Wave';
    HatchStyleDiagonalBrick: s := 'DiagonalBrick';
    HatchStyleHorizontalBrick: s := 'HorizontalBrick';
    HatchStyleWeave: s := 'Weave';
    HatchStylePlaid: s := 'Plaid';
    HatchStyleDivot: s := 'Divot';
    HatchStyleDottedGrid: s := 'DottedGrid';
    HatchStyleDottedDiamond: s := 'DottedDiamond';
    HatchStyleShingle: s := 'Shingle';
    HatchStyleTrellis: s := 'Trellis';
    HatchStyleSphere: s := 'Sphere';
    HatchStyleSmallGrid: s := 'SmallGrid';
    HatchStyleSmallCheckerBoard: s := 'SmallCheckerBoard';
    HatchStyleLargeCheckerBoard: s := 'LargeCheckerBoard';
    HatchStyleOutlinedDiamond: s := 'OutlinedDiamond';
    HatchStyleSolidDiamond: s := 'SolidDiamond';
  else
    s := 'DiagonalCross';
  end;
  Result := s;
end;

function TryStrIDToHatchStyle(const StrID: string; var hs: TGPHatchStyle): Boolean;
var
  s: string;

  function TrimFromStart(const s: string; const StringToCut: string): string;
  begin
    if UpperCase(Copy(s, 1, Length(StringToCut))) = UpperCase(StringToCut) then Result := Copy(s, Length(StringToCut) + 1, Length(s))
    else Result := s;
  end;

begin
  Result := False;
  s := StrID;
  s := TrimFromStart(s, 'HatchStyle');
  s := Trim(LowerCase(s));
  s := StringReplace(s, ' ', '', [rfReplaceAll]);

  if s = 'horizontal' then hs := HatchStyleHorizontal
  else if s = 'vertical' then hs := HatchStyleVertical
  else if s = 'forwarddiagonal' then hs := HatchStyleForwardDiagonal
  else if s = 'backwarddiagonal' then hs := HatchStyleBackwardDiagonal
  else if s = 'cross' then hs := HatchStyleCross
  else if s = 'diagonalcross' then hs := HatchStyleDiagonalCross
  else if s = '05percent' then hs := HatchStyle05Percent
  else if s = '10percent' then hs := HatchStyle10Percent
  else if s = '20percent' then hs := HatchStyle20Percent
  else if s = '25percent' then hs := HatchStyle25Percent
  else if s = '30percent' then hs := HatchStyle30Percent
  else if s = '40percent' then hs := HatchStyle40Percent
  else if s = '50percent' then hs := HatchStyle50Percent
  else if s = '60percent' then hs := HatchStyle60Percent
  else if s = '70percent' then hs := HatchStyle70Percent
  else if s = '75percent' then hs := HatchStyle75Percent
  else if s = '80percent' then hs := HatchStyle80Percent
  else if s = '90percent' then hs := HatchStyle90Percent
  else if s = 'lightdownwarddiagonal' then hs := HatchStyleLightDownwardDiagonal
  else if s = 'lightupwarddiagonal' then hs := HatchStyleLightUpwardDiagonal
  else if s = 'darkdownwarddiagonal' then hs := HatchStyleDarkDownwardDiagonal
  else if s = 'darkupwarddiagonal' then hs := HatchStyleDarkUpwardDiagonal
  else if s = 'widedownwarddiagonal' then hs := HatchStyleWideDownwardDiagonal
  else if s = 'wideupwarddiagonal' then hs := HatchStyleWideUpwardDiagonal
  else if s = 'lightvertical' then hs := HatchStyleLightVertical
  else if s = 'lighthorizontal' then hs := HatchStyleLightHorizontal
  else if s = 'narrowvertical' then hs := HatchStyleNarrowVertical
  else if s = 'narrowhorizontal' then hs := HatchStyleNarrowHorizontal
  else if s = 'darkvertical' then hs := HatchStyleDarkVertical
  else if s = 'darkhorizontal' then hs := HatchStyleDarkHorizontal
  else if s = 'dasheddownwarddiagonal' then hs := HatchStyleDashedDownwardDiagonal
  else if s = 'dashedupwarddiagonal' then hs := HatchStyleDashedUpwardDiagonal
  else if s = 'dashedhorizontal' then hs := HatchStyleDashedHorizontal
  else if s = 'dashedvertical' then hs := HatchStyleDashedVertical
  else if s = 'smallconfetti' then hs := HatchStyleSmallConfetti
  else if s = 'largeconfetti' then hs := HatchStyleLargeConfetti
  else if s = 'zigzag' then hs := HatchStyleZigZag
  else if s = 'wave' then hs := HatchStyleWave
  else if s = 'diagonalbrick' then hs := HatchStyleDiagonalBrick
  else if s = 'horizontalbrick' then hs := HatchStyleHorizontalBrick
  else if s = 'weave' then hs := HatchStyleWeave
  else if s = 'plaid' then hs := HatchStylePlaid
  else if s = 'divot' then hs := HatchStyleDivot
  else if s = 'dottedgrid' then hs := HatchStyleDottedGrid
  else if s = 'dotteddiamond' then hs := HatchStyleDottedDiamond
  else if s = 'shingle' then hs := HatchStyleShingle
  else if s = 'trellis' then hs := HatchStyleTrellis
  else if s = 'sphere' then hs := HatchStyleSphere
  else if s = 'smallgrid' then hs := HatchStyleSmallGrid
  else if s = 'smallcheckerboard' then hs := HatchStyleSmallCheckerBoard
  else if s = 'largecheckerboard' then hs := HatchStyleLargeCheckerBoard
  else if s = 'outlineddiamond' then hs := HatchStyleOutlinedDiamond
  else if s = 'soliddiamond' then hs := HatchStyleSolidDiamond
  else Exit;

  Result := True;
end;

function TransparencyToAlpha(const TransparencyInPercent: Byte): Byte;
begin
  if TransparencyInPercent = 0 then Result := 255
  else if TransparencyInPercent = 100 then Result := 0
  else Result := Round(255 - (TransparencyInPercent * 2.55));
end;

function GetGPFontName(const FontNameArray: array of string): string;
var
  FontName: string;
  i: integer;
begin
  for i := Low(FontNameArray) to High(FontNameArray) do
  begin
    FontName := FontNameArray[i];
    {$IFDEF FPC}
    if GPFontList.IndexOf(string(FontName)) >= 0 then
    {$ELSE}
    if GPFontList.IndexOf(FontName) >= 0 then
    {$ENDIF}
    begin
      Result := FontName;
      Break;
    end;
  end;
end;

function FontStylesToGPFontStyle(const Style: TFontStyles): TGPFontStyle;
begin
  Result := [];
  if fsBold in Style then Include(Result, FontStyleBold);
  if fsItalic in Style then Include(Result, FontStyleItalic);
  if fsUnderline in Style then Include(Result, FontStyleUnderline);
  if fsStrikeOut in Style then Include(Result, FontStyleStrikeout);
end;

function GPFontStyleToFontStyles(const Style: TGPFontStyle): TFontStyles;
begin
  Result := [];
  if FontStyleBold in Style then Include(Result, fsBold);
  if FontStyleItalic in Style then Include(Result, fsItalic);
  if FontStyleUnderline in Style then Include(Result, fsUnderline);
  if FontStyleStrikeout in Style then Include(Result, fsStrikeout);
end;

function GPFontStyleToStr(const FontStyle: TGPFontStyle): string;
begin
  Result := '';
  if FontStyleBold in FontStyle then Result := Result + ',bold';
  if FontStyleItalic in FontStyle then Result := Result + ',italic';
  if FontStyleUnderline in FontStyle then Result := Result + ',underline';
  if FontStyleStrikeout in FontStyle then Result := Result + ',strikeout';
  if Copy(Result, 1, 1) = ',' then Delete(Result, 1, 1);
end;

function StrToGPFontStyle(FontStyleStr: string): TGPFontStyle;
begin
  Result := [];
  FontStyleStr := LowerCase(FontStyleStr);
  if Pos('bold', FontStyleStr) > 0 then Include(Result, FontStyleBold);
  if Pos('italic', FontStyleStr) > 0 then Include(Result, FontStyleItalic);
  if Pos('underline', FontStyleStr) > 0 then Include(Result, FontStyleUnderline);
  if Pos('strikeout', FontStyleStr) > 0 then Include(Result, FontStyleStrikeout);
end;

procedure SetGPPenStyle(var Pen: IGPPen; const PenStyle: TPenStyle);
var
  PatternArray: array of Single;
  xDash, xSpace, xDot: Single;
begin
  xDash := 5;
  xSpace := 3;
  xDot := 1;

  case PenStyle of

    psSolid: Pen.SetDashStyle(DashStyleSolid);

    psDash:
      begin
        SetLength(PatternArray{%H-}, 2);
        PatternArray[0] := xDash;
        PatternArray[1] := xSpace;
        Pen.SetDashPattern(PatternArray);
      end;

    psDot:
      begin
        SetLength(PatternArray, 2);
        PatternArray[0] := xDot;
        PatternArray[1] := xSpace;
        Pen.SetDashPattern(PatternArray);
      end;

    psDashDot:
      begin
        SetLength(PatternArray, 4);
        PatternArray[0] := xDash;
        PatternArray[1] := xSpace;
        PatternArray[2] := xDot;
        PatternArray[3] := xSpace;
        Pen.SetDashPattern(PatternArray);
      end;

    psDashDotDot:
      begin
        SetLength(PatternArray, 6);
        PatternArray[0] := xDash;
        PatternArray[1] := xSpace;
        PatternArray[2] := xDot;
        PatternArray[3] := xSpace;
        PatternArray[4] := xDot;
        PatternArray[5] := xSpace;
        Pen.SetDashPattern(PatternArray);
      end;

    else
      // psinsideFrame, psPattern, psClear
      Pen.SetDashStyle(DashStyleSolid);
  end;
end;

procedure GdipCheck(const Status: TGPStatus); inline;
begin
  if (Status <> Ok) then
    raise EGdipError.Create(Status);
end;

function GPPointF(const ax, ay: Single): TGPPointF; overload;
begin
  Result.x := ax;
  Result.y := ay;
end;

function GPPointF(const apt: TPoint): TGPPointF; overload;
begin
  Result.x := apt.X;
  Result.y := apt.Y;
end;

function GPPointFMove(const Point: TGPPointF; const dx, dy: Single): TGPPointF;
begin
  Result.X := Point.X + dx;
  Result.Y := Point.Y + dy;
end;

function GPColor(const AColor: TColor; Alpha: Byte = 255): TAlphaColor;
begin
  Result := TGPColor.Create(Alpha, GetRValue(AColor), GetGValue(AColor), GetBValue(AColor));
end;

function GPTextWidthF(gr: IGPGraphics; Text: {$IFDEF FPC}UnicodeString{$ELSE}string{$ENDIF}; Font: IGPFont; px: Single = 0; py: Single = 0): Single;
var
  RectF: TGPRectF;
  Origin: TGPPointF;
begin
  Origin.X := px;
  Origin.Y := py;
  RectF := gr.MeasureString(Text, Font, Origin);
  Result := RectF.Width;
end;

function GPTextHeightF(gr: IGPGraphics; Text: {$IFDEF FPC}UnicodeString{$ELSE}string{$ENDIF}; Font: IGPFont; px: Single = 0; py: Single = 0): Single;
var
  RectF: TGPRectF;
  Origin: TGPPointF;
begin
  Origin.X := px;
  Origin.Y := py;
  RectF := gr.MeasureString(Text, Font, Origin);
  Result := RectF.Height;
end;





procedure InitGPFontList;
var
  FontCollection: IGPInstalledFontCollection;
  FontFamily: IGPFontFamily;
begin
  if not Assigned(GPFontList) then GPFontList := TStringList.Create;
  GPFontList.BeginUpdate;
  try
    FontCollection := TGPInstalledFontCollection.Create;
    for FontFamily in FontCollection.Families do
      {$IFDEF FPC}
      GPFontList.Add(AnsiString(FontFamily.FamilyName))
      {$ELSE}
      GPFontList.Add(FontFamily.FamilyName)
      {$ENDIF}
  finally
    GPFontList.EndUpdate;
  end;
end;

initialization
  InitGPFontList;

finalization
  if Assigned(GPFontList) then GPFontList.Free;


end.

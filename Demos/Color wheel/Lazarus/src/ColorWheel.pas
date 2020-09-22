unit ColorWheel;

{$mode objfpc}{$H+}

interface

uses
  Windows,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdCtrls, ExtCtrls,

  JPL.Colors, JPL.Math,
  GdiPlus, GdiPlusHelpers;



procedure DrawColorWheel(Image: TImage; const CurrentColor: TColor; bTriadic, bTetradic: Boolean; DegShift: integer;
  bDrawAxes: Boolean; bDrawDiagonals, bShowComplementaryColor: Boolean; bDrawFrame: Boolean);



implementation



{$region '                                   DrawColorWheel                                       '}
procedure DrawColorWheel(Image: TImage; const CurrentColor: TColor; bTriadic, bTetradic: Boolean; DegShift: integer;
  bDrawAxes: Boolean; bDrawDiagonals, bShowComplementaryColor: Boolean; bDrawFrame: Boolean);
const
  DEG = '°';
var
  bmp: TBitmap;
  xWidth, xHeight, i, xPies: integer;
  gr: IGPGraphics;
  Pen: IGPPen;
  Brush: IGPBrush;
  Margin, Radius, Hue, Sweep: Single;
  halfW, halfH: Single;
  SelColHue, SelColSat, SelColLum, CompColHue: integer;
  RectF: TGPRectF;
  AngleStart, AngleSweep, DeltaHue: Single;
  cl, clBg, clCurrent, clTriad1, clTriad2, clComplementary, clTetrad1, clTetrad2, clTetrad3: TColor;
  dxr, fi: Single;
  s: UnicodeString;
  xDegShift: integer;
  AFont: IGPFont;
  Point: TGPPointF;
  FontFamily: IGPFontFamily;
const
  DashValues: array [0..1] of Single = (4, 4);

  function GPColor(Color: TColor; Alpha: Byte = 255): TGPColor;
  begin
    Result.Initialize(Alpha, GetRValue(Color), GetGValue(Color), GetBValue(Color));
  end;


  {$region '     DrawHueLine     '}
  procedure DrawHueLine(const HueValue: Single; const AColor: TColor; const LineWidth: Single; bDashed: Boolean = False);
  var
    pt1, pt2: TGPPointF;
  begin
    gr.ResetTransform;
    gr.TranslateTransform(halfW, halfH);
    gr.ScaleTransform(1, -1);

    Pen.Color := GPColor(AColor, 220);
    Pen.Width := LineWidth;
    if bDashed then Pen.SetDashPattern(DashValues)
    else Pen.DashStyle := DashStyleSolid;
    pt1.X := 0;
    pt1.Y := 0;

    fi := 90 - HueValue;
    dxr := Radius + 0;
    pt2.X := dxr * CosDeg(fi);
    pt2.Y := dxr * SinDeg(fi);
    gr.DrawLine(Pen, pt1, pt2);
  end;
  {$endregion DrawHueLine}


  {$region '     DrawHuePolygon     '}
  procedure DrawHuePolygon(const Arr: array of Single; const AColor: TColor; const LineWidth: Single);
  var
    Points: array of TGPPointF;
    i: integer;
  begin

    if Length(Arr) = 0 then Exit;
    SetLength(Points{%H-}, Length(Arr));

    for i := 0 to High(Arr) do
    begin
      fi := 90 - Arr[i];
      Points[i].X := Radius * CosDeg(fi);
      Points[i].Y := Radius * SinDeg(fi);
    end;

    Pen.Color := GPColor(AColor, 255);
    Pen.Width := LineWidth;
    Pen.SetDashPattern(DashValues);

    gr.DrawPolygon(Pen, Points);
  end;
  {$endregion DrawHuePolygon}


  {$region '     DrawHuePoint     '}
  procedure DrawHuePoint(const Hue: Single; AColor: TColor);
  var
    pt1: TGPPointF;
  begin
    gr.ResetTransform;
    gr.TranslateTransform(halfW, halfH);
    gr.ScaleTransform(1, -1);

    // ------ punkt środkowy okręgu ---------------
    fi := 90 - Hue;
    pt1.X := Radius * CosDeg(fi);
    pt1.Y := Radius * SinDeg(fi);

    dxr := 4;
    RectF.X := pt1.X - dxr;
    RectF.Y := pt1.Y - dxr;
    RectF.Width := dxr * 2;
    RectF.Height := dxr * 2;

    Brush := nil;
    Brush := TGPSolidBrush.Create(GPColor(AColor, 140));
    Pen.Width := 2;
    Pen.Color := GPColor(clBlack, 255);
    Pen.DashStyle := DashStyleSolid;
    gr.DrawEllipse(Pen, RectF);
    gr.FillEllipse(Brush, RectF);

  end;
  {$endregion DrawHuePoint}


begin
  bmp := TBitmap.Create;
  try

    xWidth := Image.Width;
    xHeight := Image.Height;
    bmp.SetSize(xWidth, xHeight);
    bmp.PixelFormat := pf32bit;
    halfW := xWidth / 2;
    halfH := xHeight / 2;
    Margin := 38;

    xPies := 360;
    clCurrent := CurrentColor;
    clComplementary := ComplementaryColor(clCurrent);
    clBg := clWhite;



    gr := TGPGraphics.Create(bmp.Canvas.Handle);
    gr.SmoothingMode := SmoothingModeAntiAlias;
    gr.ResetTransform;

    Pen := TGPPen.Create(GPColor(clBg), 1);

    // ------------- background ----------------
    RectF.InitializeFromLTRB(0, 0, xWidth, xHeight);
    Brush := TGPSolidBrush.Create(GPColor(clBg));
    gr.FillRectangle(Brush, RectF);
    gr.DrawRectangle(Pen, RectF);

    //Pen := TGPPen.Create(GPColor($00A8A8A8), 1);

    // ------------ frame -------------
    if bDrawFrame then
    begin
      Pen.Color := GPColor($00A8A8A8);
      RectF.Width := RectF.Width - 1;
      RectF.Height := RectF.Height - 1;
      gr.DrawRectangle(Pen, RectF);
    end;


    // ----------- circle --------------
    Pen.DashStyle := DashStyleSolid;
    Pen.Color := GPColor(clGray);
    Pen.Width := 1;
    RectF.InitializeFromLTRB(Margin, Margin, xWidth - Margin, xHeight - Margin);
    gr.DrawEllipse(Pen, RectF);




    // ----------- transformation of the coordinate system -------------
    gr.TranslateTransform(halfW, halfH); // shifting the origin of the coordinate system to the center
    gr.RotateTransform(-90); // 0 degrees at the top



    // --------------------- Pies ---------------------------
    gr.SmoothingMode := SmoothingModeNone;
    Radius := halfW - Margin;
    DeltaHue := 360 / xPies;
    Sweep := DeltaHue;

    RectF.X := -Radius;
    RectF.Y := -Radius;
    RectF.Width := Radius * 2;
    RectF.Height := RectF.Width;

    SetHslCssMaxValues;
    ColortoHSLRange(clCurrent, SelColHue, SelColSat, SelColLum);
    CompColHue := GetHueCssValue(clComplementary);

    for i := 0 to xPies - 1 do
    begin
      Hue := i * DeltaHue;
      cl := HslCssToColor(Hue, SelColSat, SelColLum);
      Brush := nil;
      Brush := TGPSolidBrush.Create(GPColor(cl, 255));
      AngleStart := Hue;   // kąt początkowy
      AngleSweep := Sweep; // rozpiętość kątowa
      gr.FillPie(Brush, RectF, AngleStart, AngleSweep);
    end;



    gr.SmoothingMode := SmoothingModeAntiAlias;


    // ------------------ inner circle ------------------------
    Brush := nil;
    Brush := TGPSolidBrush.Create(GPColor(clWhite, 120));
    Pen.Color := GPColor(clGray, 100);
    dxr := Radius - (halfW / 2);
    RectF.InitializeFromLTRB(-dxr, dxr, dxr, -dxr);
    gr.FillEllipse(Brush, RectF);
    gr.DrawEllipse(Pen, RectF);



    gr.ResetTransform;
    Pen.SetDashPattern(DashValues);

    Pen.Color := GPColor(clSilver, 150);
    // ---------------- axes ------------------
    if bDrawAxes then
    begin
      gr.DrawLine(Pen, 0, xHeight / 2, xWidth, xHeight / 2); // X axis
      gr.DrawLine(Pen, xWidth / 2, xHeight, xWidth / 2, 0);  // Y axis
    end;

    // ------------ diagonals -------------
    if bDrawDiagonals then
    begin
      gr.DrawLine(Pen, 0, 0, xWidth, xHeight);
      gr.DrawLine(Pen, xWidth, 0, 0, xHeight);
    end;



    gr.ResetTransform;
    gr.TranslateTransform(halfW, halfH);
    gr.ScaleTransform(1, -1);

    xDegShift := DegShift;

    if bTriadic then
    begin
      GetTriadicColors(clCurrent, clTriad1, clTriad2, xDegShift);

      DrawHueLine(SelColHue, InvertColor(clCurrent), 3);
      DrawHueLine(SelColHue + 180 - xDegShift, InvertColor(clTriad1), 1, True);
      DrawHueLine(SelColHue + 180 + xDegShift, InvertColor(clTriad2), 1, True);

      DrawHuePolygon([SelColHue, SelColHue + 180 - xDegShift, SelColHue + 180 + xDegShift], RGB3(22), 1.4);

      DrawHuePoint(SelColHue, clCurrent);
      DrawHuePoint(SelColHue + 180 - xDegShift, clTriad1);
      DrawHuePoint(SelColHue + 180 + xDegShift, clTriad2);
      if bShowComplementaryColor then DrawHuePoint(CompColHue, clComplementary);
    end;

    if bTetradic then
    begin
      GetTetradicColors(clCurrent, clTetrad1, clTetrad2, clTetrad3, xDegShift);

      DrawHueLine(SelColHue, InvertColor(clCurrent), 3);
      DrawHueLine(SelColHue + xDegShift, InvertColor(clTetrad1), 1, True);
      DrawHueLine(SelColHue + 180, InvertColor(clTetrad2), 1, True);
      DrawHueLine(SelColHue + 180 + xDegShift, InvertColor(clTetrad3), 1, True);

      DrawHuePolygon([SelColHue, SelColHue + xDegShift, SelColHue + 180, SelColHue + 180 + xDegShift], RGB3(22), 1.4);

      DrawHuePoint(SelColHue, clCurrent);
      DrawHuePoint(SelColHue + xDegShift, clTetrad1);
      DrawHuePoint(SelColHue + 180, clTetrad2);
      DrawHuePoint(SelColHue + 180 + xDegShift, clTetrad3);
    end;

    gr.ResetTransform;


    // ----------------- Text ---------------------

    Brush := nil;
    Brush := TGPSolidBrush.Create(GPColor(clBlack));
    FontFamily := TGPFontFamily.Create('Verdana');
    AFont := TGPFont.Create(FontFamily, 8, [], UnitPoint);

    s := '0' + DEG;
    Point := GPPointF(halfW, 2);
    Point := GPPointFMove(Point, -(GPTextWidthF(gr, s, AFont) / 2), 0);
    gr.DrawString(s, AFont, Point, Brush);

    s := '90' + DEG;
    Point := GPPointF(xWidth, xHeight / 2);
    Point := GPPointFMove(Point, -GPTextWidthF(gr, s, AFont) - 4, -GPTextHeightF(gr, s, AFont) / 2);
    gr.DrawString(s, AFont, Point, Brush);

    s := '180' + DEG;
    Point := GPPointF(halfW, 7);
    Point := GPPointFMove(Point, -(GPTextWidthF(gr, s, AFont) / 2), xHeight - GPTextHeightF(gr, s, AFont) - 8);
    gr.DrawString(s, AFont, Point, Brush);

    s := '270' + DEG;
    Point := GPPointF(0, xHeight / 2);
    Point := GPPointFMove(Point, 4, -GPTextHeightF(gr, s, AFont) / 2);
    gr.DrawString(s, AFont, Point, Brush);


    Image.Picture.Assign(bmp);

  finally
    bmp.Free;
  end;

end;

{$endregion DrawColorWheel}


end.


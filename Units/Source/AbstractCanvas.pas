unit AbstractCanvas;
//---------------------------------------------------------------------------
// AbstractCanvas.pas                                   Modified: 20-May-2010
// Asphyre 2D Canvas Abstract declaration                        Version 1.05
//---------------------------------------------------------------------------
// Important Notice:
//
// If you modify/use this code or one of its parts either in original or
// modified form, you must comply with Mozilla Public License v1.1,
// specifically section 3, "Distribution Obligations". Failure to do so will
// result in the license breach, which will be resolved in the court.
// Remember that violating author's rights is considered a serious crime in
// many countries. Thank you!
//
// !! Please *read* Mozilla Public License 1.1 document located at:
//  http://www.mozilla.org/MPL/
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is AbstractCanvas.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2007 - 2010,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

// Enable the following option to use Line approach for FrameRect method. 
{.$define FrameRectLines}

//---------------------------------------------------------------------------
uses
 Types, Vectors2, Matrices3, AsphyreColors, AsphyreTypes, AbstractTextures,
 AsphyreImages;

//---------------------------------------------------------------------------
type
 TDrawingEffect = (deUnknown, deNormal, deShadow, deAdd, deMultiply,
  deSrcAlphaAdd, deSrcColor, deSrcColorAdd, deInvert, deSrcBright,
  deInvMultiply, deMultiplyAlpha, deInvMultiplyAlpha, deDestBright,
  deInvSrcBright, deInvDestBright, deBright, deBrightAdd, deGrayScale,
  deLight, deLightAdd, deAdd2X, deOneColor, deXOR);

//---------------------------------------------------------------------------
 TAsphyreCanvas = class
 private
  FDrawCalls: Integer;

  CreateHandle    : Cardinal;
  DestroyHandle   : Cardinal;
  ResetHandle     : Cardinal;
  LostHandle      : Cardinal;
  BeginSceneHandle: Cardinal;
  EndSceneHandle  : Cardinal;

  HexLookup: array[0..5] of TPoint2;

  procedure InitHexLookup();

  procedure OnDeviceCreate(Sender: TObject; Param: Pointer;
   var Handled: Boolean);
  procedure OnDeviceDestroy(Sender: TObject; Param: Pointer;
   var Handled: Boolean);
  procedure OnDeviceReset(Sender: TObject; Param: Pointer;
   var Handled: Boolean);
  procedure OnDeviceLost(Sender: TObject; Param: Pointer;
   var Handled: Boolean);

  procedure OnBeginScene(Sender: TObject; Param: Pointer;
   var Handled: Boolean);
  procedure OnEndScene(Sender: TObject; Param: Pointer;
   var Handled: Boolean);

  function GetClipRect(): TRect;
  procedure SetClipRect(const Value: TRect);
  procedure WuHoriz(x1, y1, x2, y2: Single;
   const Color0, Color1: TAsphyreColor);
  procedure WuVert(x1, y1, x2, y2: Single; const Color0,
   Color1: TAsphyreColor);
 protected
  function HandleDeviceCreate(): Boolean; virtual;
  procedure HandleDeviceDestroy(); virtual;
  function HandleDeviceReset(): Boolean; virtual;
  procedure HandleDeviceLost(); virtual;

  procedure HandleBeginScene(); virtual; abstract;
  procedure HandleEndScene(); virtual; abstract;

  procedure GetViewport(out x, y, Width, Height: Integer); virtual; abstract;
  procedure SetViewport(x, y, Width, Height: Integer); virtual; abstract;
  function GetAntialias(): Boolean; virtual; abstract;
  procedure SetAntialias(const Value: Boolean); virtual; abstract;
  function GetMipMapping(): Boolean; virtual; abstract;
  procedure SetMipMapping(const Value: Boolean); virtual; abstract;

  procedure NextDrawCall();
 public
  property DrawCalls: Integer read FDrawCalls;

  property ClipRect  : TRect read GetClipRect write SetClipRect;
  property Antialias : Boolean read GetAntialias write SetAntialias;
  property MipMapping: Boolean read GetMipMapping write SetMipMapping;

  procedure PutPixel(const Point: TPoint2;
   Color: Cardinal); overload; virtual; abstract;
  procedure PutPixel(x, y: Single; Color: Cardinal); overload;

  procedure Line(const Src, Dest: TPoint2; Color0,
   Color1: Cardinal); overload; virtual; abstract;
  procedure Line(const Src, Dest: TPoint2; Color: Cardinal); overload;
  procedure Line(x1, y1, x2, y2: Single; Color: Cardinal); overload;
  procedure LineArray(Points: PPoint2; Color: Cardinal;
   NoPoints: Integer); virtual;

  procedure WuLine(Src, Dest: TPoint2; Color0, Color1: Cardinal);

  procedure Ellipse(const Pos, Radius: TPoint2; Steps: Integer;
   Color: Cardinal);
  procedure Circle(const Pos: TPoint2; Radius: Single; Steps: Integer;
   Color: Cardinal);

  procedure DrawIndexedTriangles(Vertices: PPoint2; Colors: PCardinal;
   Indices: PInteger; NoVertices, NoTriangles: Integer;
   Effect: TDrawingEffect = deNormal); virtual; abstract;

  procedure FillTri(const p1, p2, p3: TPoint2; c1, c2, c3: Cardinal;
   Effect: TDrawingEffect = deNormal);

  procedure FillQuad(const Points: TPoint4; const Colors: TColor4;
   Effect: TDrawingEffect = deNormal);
  procedure WireQuad(const Points: TPoint4; const Colors: TColor4);

  procedure FillRect(const Rect: TRect; const Colors: TColor4;
   Effect: TDrawingEffect = deNormal); overload;
  procedure FillRect(const Rect: TRect; Color: Cardinal;
   Effect: TDrawingEffect = deNormal); overload;
  procedure FillRect(Left, Top, Width, Height: Integer; Color: Cardinal;
   Effect: TDrawingEffect = deNormal); overload;
  procedure FrameRect(const Rect: TRect; const Colors: TColor4;
   Effect: TDrawingEffect = deNormal);

  procedure FillHexagon(const Mtx: TMatrix3; c1, c2, c3, c4, c5, c6: Cardinal;
   Effect: TDrawingEffect = deNormal);

  procedure FrameHexagon(const Mtx: TMatrix3; Color: Cardinal);

  procedure FillArc(const Pos, Radius: TPoint2; InitPhi, EndPhi: Single;
   Steps: Integer; const Colors: TColor4;
   Effect: TDrawingEffect = deNormal); overload;
  procedure FillArc(x, y, Radius, InitPhi, EndPhi: Single; Steps: Integer;
   const Colors: TColor4; Effect: TDrawingEffect = deNormal); overload;

  procedure FillEllipse(const Pos, Radius: TPoint2;
   Steps: Integer; const Colors: TColor4; Effect: TDrawingEffect = deNormal);
  procedure FillCircle(x, y, Radius: Single; Steps: Integer;
   const Colors: TColor4; Effect: TDrawingEffect = deNormal);

  procedure FillRibbon(const Pos, InRadius, OutRadius: TPoint2;
   InitPhi, EndPhi: Single; Steps: Integer; const Colors: TColor4;
   Effect: TDrawingEffect = deNormal); overload;

  procedure FillRibbon(const Pos, InRadius, OutRadius: TPoint2;
   InitPhi, EndPhi: Single; Steps: Integer; InColor1, InColor2, InColor3,
   OutColor1, OutColor2, OutColor3: Cardinal;
   Effect: TDrawingEffect = deNormal); overload;

  procedure QuadHole(const Pos, Size, Center, Radius: TPoint2; OutColor,
   InColor: Cardinal; Steps: Integer;
   Effect: TDrawingEffect = deNormal); overload;

  procedure UseTexture(Texture: TAsphyreCustomTexture;
   const Mapping: TPoint4); virtual; abstract;
  procedure UseTexturePx(Texture: TAsphyreCustomTexture;
   const Mapping: TPoint4px); overload;
  procedure UseTexturePx(Texture: TAsphyreCustomTexture;
   const Mapping: TPoint4); overload;

  procedure UseImage(Image: TAsphyreImage; const Mapping: TPoint4;
   TextureNo: Integer = 0);

  procedure UseImagePt(Image: TAsphyreImage; Pattern: Integer); overload;
  procedure UseImagePt(Image: TAsphyreImage; Pattern: Integer;
   const SrcRect: TRect; Mirror: Boolean = False;
   Flip: Boolean = False); overload;

  procedure UseImagePx(Image: TAsphyreImage; const Mapping: TPoint4px;
   TextureNo: Integer = 0); overload;
  procedure UseImagePx(Image: TAsphyreImage; const Mapping: TPoint4;
   TextureNo: Integer = 0); overload;

  procedure TexMap(const Points: TPoint4; const Colors: TColor4;
   Effect: TDrawingEffect = deNormal); virtual; abstract;

  procedure Flush(); virtual; abstract;
  procedure ResetStates(); virtual;

  constructor Create(); virtual;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AbstractDevices;

//---------------------------------------------------------------------------
constructor TAsphyreCanvas.Create();
begin
 inherited;

 FDrawCalls:= 0;

 {$ifdef fpc}
 CreateHandle := EventDeviceCreate.Subscribe(@OnDeviceCreate, -1);
 DestroyHandle:= EventDeviceDestroy.Subscribe(@OnDeviceDestroy, -1);

 ResetHandle:= EventDeviceReset.Subscribe(@OnDeviceReset, -1);
 LostHandle := EventDeviceLost.Subscribe(@OnDeviceLost, -1);

 BeginSceneHandle:= EventBeginScene.Subscribe(@OnBeginScene, -1);
 EndSceneHandle  := EventEndScene.Subscribe(@OnEndScene, -1);
 {$else}
 CreateHandle := EventDeviceCreate.Subscribe(OnDeviceCreate, -1);
 DestroyHandle:= EventDeviceDestroy.Subscribe(OnDeviceDestroy, -1);

 ResetHandle:= EventDeviceReset.Subscribe(OnDeviceReset, -1);
 LostHandle := EventDeviceLost.Subscribe(OnDeviceLost, -1);

 BeginSceneHandle:= EventBeginScene.Subscribe(OnBeginScene, -1);
 EndSceneHandle  := EventEndScene.Subscribe(OnEndScene, -1);
 {$endif}

 InitHexLookup();
end;

//---------------------------------------------------------------------------
destructor TAsphyreCanvas.Destroy();
begin
 EventEndScene.Unsubscribe(EndSceneHandle);
 EventDeviceLost.Unsubscribe(LostHandle);
 EventDeviceReset.Unsubscribe(ResetHandle);
 EventDeviceDestroy.Unsubscribe(DestroyHandle);
 EventDeviceCreate.Unsubscribe(CreateHandle);

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.InitHexLookup();
const
 HexDelta = 1.154700538;
 AngleInc = Pi / 6.0;
 AngleMul = 2.0 * Pi / 6.0;
var
 i: Integer;
 Angle: Single;
begin
 for i:= 0 to 5 do
  begin
   Angle:= i * AngleMul + AngleInc;

   HexLookup[i].x:=  Cos(Angle) * HexDelta;
   HexLookup[i].y:= -Sin(Angle) * HexDelta;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.OnDeviceCreate(Sender: TObject; Param: Pointer;
 var Handled: Boolean);
var
 Success: Boolean;
begin
 Success:= HandleDeviceCreate();

 if (Param <> nil) then PBoolean(Param)^:= Success;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.OnDeviceDestroy(Sender: TObject; Param: Pointer;
 var Handled: Boolean);
begin
 HandleDeviceDestroy();
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.OnDeviceReset(Sender: TObject; Param: Pointer;
 var Handled: Boolean);
var
 Success: Boolean;
begin
 Success:= HandleDeviceReset();

 if (Param <> nil) then PBoolean(Param)^:= Success;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.OnDeviceLost(Sender: TObject; Param: Pointer;
 var Handled: Boolean);
begin
 HandleDeviceLost();
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.OnBeginScene(Sender: TObject; Param: Pointer;
 var Handled: Boolean);
begin
 FDrawCalls:= 0;

 HandleBeginScene();
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.OnEndScene(Sender: TObject; Param: Pointer;
 var Handled: Boolean);
begin
 HandleEndScene();
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.ResetStates();
begin
 // no code
end;

//---------------------------------------------------------------------------
function TAsphyreCanvas.GetClipRect(): TRect;
var
 x, y, Width, Height: Integer;
begin
 GetViewport(x, y, Width, Height);

 Result:= Bounds(x, y, Width, Height);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.SetClipRect(const Value: TRect);
begin
 SetViewport(Value.Left, Value.Top, Value.Right - Value.Left,
  Value.Bottom - Value.Top);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.UseTexturePx(Texture: TAsphyreCustomTexture;
 const Mapping: TPoint4px);
var
 Points: TPoint4;
begin
 if (Texture <> nil) then
  begin
   Points[0]:= Texture.PixelToLogical(Mapping[0]);
   Points[1]:= Texture.PixelToLogical(Mapping[1]);
   Points[2]:= Texture.PixelToLogical(Mapping[2]);
   Points[3]:= Texture.PixelToLogical(Mapping[3]);

   UseTexture(Texture, Points);
  end else UseTexture(Texture, TexFull4);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.UseTexturePx(Texture: TAsphyreCustomTexture;
 const Mapping: TPoint4);
var
 Points: TPoint4;
begin
 if (Texture <> nil) then
  begin
   Points[0]:= Texture.PixelToLogical(Mapping[0]);
   Points[1]:= Texture.PixelToLogical(Mapping[1]);
   Points[2]:= Texture.PixelToLogical(Mapping[2]);
   Points[3]:= Texture.PixelToLogical(Mapping[3]);

   UseTexture(Texture, Points);
  end else UseTexture(Texture, TexFull4);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.UseImage(Image: TAsphyreImage; const Mapping: TPoint4;
 TextureNo: Integer);
var
 Texture: TAsphyreCustomTexture;
begin
 if (Image <> nil) then Texture:= Image.Texture[TextureNo]
  else Texture:= nil;

 UseTexture(Texture, Mapping);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.UseImagePx(Image: TAsphyreImage;
 const Mapping: TPoint4px; TextureNo: Integer);
var
 Texture: TAsphyreCustomTexture;
begin
 if (Image <> nil) then Texture:= Image.Texture[TextureNo]
  else Texture:= nil;

 UseTexturePx(Texture, Mapping);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.UseImagePx(Image: TAsphyreImage;
 const Mapping: TPoint4; TextureNo: Integer);
var
 Texture: TAsphyreCustomTexture;
begin
 if (Image <> nil) then Texture:= Image.Texture[TextureNo]
  else Texture:= nil;

 UseTexturePx(Texture, Mapping);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.UseImagePt(Image: TAsphyreImage; Pattern: Integer);
var
 Mapping  : TPoint4;
 TextureNo: Integer;
begin
 TextureNo:= -1;
 if (Image <> nil) then TextureNo:= Image.RetreiveTex(Pattern, Mapping);

 UseImage(Image, Mapping, TextureNo);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.UseImagePt(Image: TAsphyreImage; Pattern: Integer;
 const SrcRect: TRect; Mirror, Flip: Boolean);
var
 Mapping  : TPoint4;
 TextureNo: Integer;
begin
 TextureNo:= -1;

 if (Image <> nil) then
  TextureNo:= Image.RetreiveTex(Pattern, SrcRect, Mirror, Flip, Mapping);

 UseImage(Image, Mapping, TextureNo);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.NextDrawCall();
begin
 Inc(FDrawCalls);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.PutPixel(x, y: Single; Color: Cardinal);
begin
 PutPixel(Point2(x, y), Color);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillArc(x, y, Radius, InitPhi, EndPhi: Single;
 Steps: Integer; const Colors: TColor4; Effect: TDrawingEffect);
begin
 FillArc(Point2(x, y), Point2(Radius, Radius), InitPhi, EndPhi, Steps, Colors,
  Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillEllipse(const Pos, Radius: TPoint2;
 Steps: Integer; const Colors: TColor4; Effect: TDrawingEffect);
begin
 FillArc(Pos, Radius, 0, Pi * 2.0, Steps, Colors, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillCircle(x, y, Radius: Single;
 Steps: Integer; const Colors: TColor4; Effect: TDrawingEffect);
begin
 FillArc(Point2(x, y), Point2(Radius, Radius), 0, Pi * 2.0, Steps, Colors,
  Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillRect(const Rect: TRect; const Colors: TColor4;
 Effect: TDrawingEffect = deNormal);
begin
 FillQuad(pRect4(Rect), Colors, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillRect(const Rect: TRect; Color: Cardinal;
 Effect: TDrawingEffect = deNormal);
begin
 FillRect(Rect, cColor4(Color), Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillRect(Left, Top, Width, Height: Integer;
 Color: Cardinal; Effect: TDrawingEffect = deNormal);
begin
 FillRect(Bounds(Left, Top, Width, Height), Color, Effect);
end;

//---------------------------------------------------------------------------
procedure SwapSingle(var a, b: Single);
var
 Temp: Single;
begin
 Temp:= a;
 a:= b;
 b:= Temp;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.WuHoriz(x1, y1, x2, y2: Single;
 const Color0, Color1: TAsphyreColor);
var
 Color: TAsphyreColor;
 xd, yd, Grad, yf: Single;
 xEnd, x, ix1, ix2, iy1, iy2: Integer;
 yEnd, xGap, Alpha1, Alpha2, Alpha, AlphaInc: Single;
begin
 xd:= x2 - x1;
 yd:= y2 - y1;

 if (x1 > x2) then
  begin
   SwapSingle(x1, x2);
   SwapSingle(y1, y2);
   xd:= x2 - x1;
   yd:= y2 - y1;
  end;

 Grad:= yd / xd;

 // End Point 1
 xEnd:= Trunc(x1 + 0.5);
 yEnd:= y1 + Grad * (xEnd - x1);

 xGap:= 1.0 - Frac(x1 + 0.5);

 ix1:= xEnd;
 iy1:= Trunc(yEnd);

 Alpha1:= (1.0 - Frac(yEnd)) * xGap;
 Alpha2:= Frac(yEnd) * xGap;

 PutPixel(Point2(ix1, iy1), cModulateAlpha(Color0, Alpha1));
 PutPixel(Point2(ix1, iy1 + 1.0), cModulateAlpha(Color0, Alpha2));

 yf:= yEnd + Grad;

 // End Point 2
 xEnd:= Trunc(x2 + 0.5);
 yEnd:= y2 + Grad * (xEnd - x2);

 xGap:= 1.0 - Frac(x2 + 0.5);

 ix2:= xEnd;
 iy2:= Trunc(yEnd);

 Alpha1:= (1.0 - Frac(yEnd)) * xGap;
 Alpha2:= Frac(yEnd) * xGap;

 PutPixel(Point2(ix2, iy2), cModulateAlpha(Color1, Alpha1));
 PutPixel(Point2(ix2, iy2 + 1.0), cModulateAlpha(Color1, Alpha2));

 Alpha:= 0.0;
 AlphaInc:= 1.0 / xd;

 // Main Loop
 for x:= ix1 + 1 to ix2 - 1 do
  begin
   Alpha1:= 1.0 - Frac(yf);
   Alpha2:= Frac(yf);

   Color:= cLerp(Color0, Color1, Alpha);

   PutPixel(Point2(x, Int(yf)), cModulateAlpha(Color, Alpha1));
   PutPixel(Point2(x, Int(yf) + 1.0), cModulateAlpha(Color, Alpha2));

   yf:= yf + Grad;
   Alpha:= Alpha + AlphaInc;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.WuVert(x1, y1, x2, y2: Single;
 const Color0, Color1: TAsphyreColor);
var
 Color: TAsphyreColor;
 xd, yd, Grad, xf: Single;
 yEnd, y, ix1, ix2, iy1, iy2: Integer;
 xEnd, yGap, Alpha1, Alpha2, Alpha, AlphaInc: Single;
begin
 xd:= x2 - x1;
 yd:= y2 - y1;

 if (y1 > y2) then
  begin
   SwapSingle(x1, x2);
   SwapSingle(y1, y2);
   xd:= x2 - x1;
   yd:= y2 - y1;
  end;

 Grad:= xd / yd;

 // End Point 1
 yEnd:= Trunc(y1 + 0.5);
 xEnd:= x1 + Grad * (yEnd - y1);

 yGap:= 1.0 - Frac(y1 + 0.5);

 ix1:= Trunc(xEnd);
 iy1:= yEnd;

 Alpha1:= (1.0 - Frac(xEnd)) * yGap;
 Alpha2:= Frac(xEnd) * yGap;

 PutPixel(Point2(ix1, iy1), cModulateAlpha(Color0, Alpha1));
 PutPixel(Point2(ix1 + 1.0, iy1), cModulateAlpha(Color0, Alpha2));

 xf:= xEnd + Grad;

 // End Point 2
 yEnd:= Trunc(y2 + 0.5);
 xEnd:= x2 + Grad * (yEnd - y2);

 yGap:= 1.0 - Frac(y2 + 0.5);

 ix2:= Trunc(xEnd);
 iy2:= yEnd;

 Alpha1:= (1.0 - Frac(xEnd)) * yGap;
 Alpha2:= Frac(xEnd) * yGap;

 PutPixel(Point2(ix2, iy2), cModulateAlpha(Color1, Alpha1));
 PutPixel(Point2(ix2 + 1.0, iy2), cModulateAlpha(Color1, Alpha2));

 Alpha:= 0.0;
 AlphaInc:= 1.0 / yd;

 // Main Loop
 for y:= iy1 + 1 to iy2 - 1 do
  begin
   Alpha1:= 1.0 - Frac(xf);
   Alpha2:= Frac(xf);

   Color:= cLerp(Color0, Color1, Alpha);

   PutPixel(Point2(Int(xf), y), cModulateAlpha(Color, Alpha1));
   PutPixel(Point2(Int(xf) + 1.0, y), cModulateAlpha(Color, Alpha2));

   xf:= xf + Grad;
   Alpha:= Alpha + AlphaInc;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.WuLine(Src, Dest: TPoint2; Color0, Color1: Cardinal);
begin
 if (Abs(Dest.x - Src.x) > Abs(Dest.y - Src.y)) then
  WuHoriz(Src.x, Src.y, Dest.x, Dest.y, Color0, Color1)
   else WuVert(Src.x, Src.y, Dest.x, Dest.y, Color0, Color1)
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.Ellipse(const Pos, Radius: TPoint2; Steps: Integer;
 Color: Cardinal);
const
 Pi2 = Pi * 2.0;
var
 i: Integer;
 Vertex, PreVertex: TPoint2;
 Alpha: Single;
begin
 Vertex:= ZeroVec2;

 for i:= 0 to Steps do
  begin
   Alpha:= i * Pi2 / Steps;

   PreVertex:= Vertex;
   Vertex.x:= Round(Pos.x + Cos(Alpha) * Radius.x);
   Vertex.y:= Round(Pos.y - Sin(Alpha) * Radius.y);

   if (i > 0) then
    WuLine(PreVertex, Vertex, Color, Color);
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.Circle(const Pos: TPoint2; Radius: Single;
 Steps: Integer; Color: Cardinal);
begin
 Ellipse(Pos, Point2(Radius, Radius), Steps, Color);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FrameRect(const Rect: TRect; const Colors: TColor4;
 Effect: TDrawingEffect);
begin
 {$ifndef FrameRectLines}
 WireQuad(pRect4(Rect), Colors);
 {$else}
 Line(
  Point2(Rect.Left, Rect.Top),
  Point2(Rect.Right, Rect.Top),
  Colors[0], Colors[1]);

 Line(
  Point2(Rect.Right - 1, Rect.Top + 1),
  Point2(Rect.Right - 1, Rect.Bottom - 1),
  Colors[1], Colors[2]);

 Line(
  Point2(Rect.Left, Rect.Bottom - 1),
  Point2(Rect.Right, Rect.Bottom - 1),
  Colors[3], Colors[2]);

 Line(
  Point2(Rect.Left, Rect.Top + 1),
  Point2(Rect.Left, Rect.Bottom - 1),
  Colors[0], Colors[3]);
 {$endif} 
end;

//---------------------------------------------------------------------------
function TAsphyreCanvas.HandleDeviceCreate(): Boolean;
begin
 Result:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.HandleDeviceDestroy();
begin
 // no code
end;

//---------------------------------------------------------------------------
function TAsphyreCanvas.HandleDeviceReset(): Boolean;
begin
 Result:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.HandleDeviceLost();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillTri(const p1, p2, p3: TPoint2; c1, c2,
 c3: Cardinal; Effect: TDrawingEffect);
const
 Indices: array[0..2] of Integer = (0, 1, 2);
var
 Vertices: array[0..2] of TPoint2;
 Colors  : array[0..2] of Cardinal;
begin
 Vertices[0]:= p1;
 Vertices[1]:= p2;
 Vertices[2]:= p3;

 Colors[0]:= c1;
 Colors[1]:= c2;
 Colors[2]:= c3;

 DrawIndexedTriangles(@Vertices[0], @Colors[0], @Indices[0], 3, 1, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillQuad(const Points: TPoint4;
 const Colors: TColor4; Effect: TDrawingEffect);
const
 Indices: array[0..5] of Integer = (2, 0, 1, 3, 2, 1);
var
 Vertices: array[0..3] of TPoint2;
 VColors : array[0..3] of Cardinal;
begin
 Vertices[0]:= Points[0];
 Vertices[1]:= Points[1];
 Vertices[2]:= Points[3];
 Vertices[3]:= Points[2];

 VColors[0]:= Colors[0];
 VColors[1]:= Colors[1];
 VColors[2]:= Colors[3];
 VColors[3]:= Colors[2];

 DrawIndexedTriangles(@Vertices[0], @VColors[0], @Indices[0], 4, 2, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillRibbon(const Pos, InRadius, OutRadius: TPoint2;
 InitPhi, EndPhi: Single; Steps: Integer; const Colors: TColor4;
 Effect: TDrawingEffect);
var
 Vertices: array of TPoint2;
 VColors : array of Cardinal;
 Indices : array of Integer;
 Pt1, Pt2: TPoint2;
 cs: TAsphyreColor4;
 i: Integer;
 Alpha: Single;
 xAlpha, yAlpha: Integer;
 NoVertex, NoIndex: Integer;
begin
 if (Steps < 1) then Exit;

 // (1) Convert 32-bit RGBA colors to fixed-point color set.
 cs:= ColorToFixed4(Colors);

 // (2) Find (x, y) margins for color interpolation.
 Pt1:= Pos - OutRadius;
 Pt2:= Pos + OutRadius;

 // (3) Specify the size of vertex/index arrays.
 SetLength(Vertices, (Steps * 2) + 2);
 SetLength(VColors, Length(Vertices));
 SetLength(Indices, Steps * 6);

 NoVertex:= 0;

 // (4) Create first inner vertex
 Vertices[NoVertex].x:= Pos.x + Cos(InitPhi) * InRadius.x;
 Vertices[NoVertex].y:= Pos.y - Sin(InitPhi) * InRadius.y;
 // -> color interpolation values
 xAlpha:= Round((Vertices[NoVertex].x - Pt1.x) * 255.0 / (Pt2.x - Pt1.x));
 yAlpha:= Round((Vertices[NoVertex].y - Pt1.y) * 255.0 / (Pt2.y - Pt1.y));
 // -> interpolate the color
 VColors[NoVertex]:= cBlend(cBlend(cs[0], cs[1], xAlpha), cBlend(cs[3], cs[2],
  xAlpha), yAlpha);
 Inc(NoVertex);

 // (5) Create first outer vertex
 Vertices[NoVertex].x:= Pos.x + Cos(InitPhi) * OutRadius.x;
 Vertices[NoVertex].y:= Pos.y - Sin(InitPhi) * OutRadius.y;
 // -> color interpolation values
 xAlpha:= Round((Vertices[NoVertex].x - Pt1.x) * 255.0 / (Pt2.x - Pt1.x));
 yAlpha:= Round((Vertices[NoVertex].y - Pt1.y) * 255.0 / (Pt2.y - Pt1.y));
 // -> interpolate the color
 VColors[NoVertex]:= cBlend(cBlend(cs[0], cs[1], xAlpha), cBlend(cs[3], cs[2],
  xAlpha), yAlpha);
 Inc(NoVertex);

 // (6) Insert the rest of vertices
 for i:= 1 to Steps do
  begin
   // 6a. Insert inner vertex
   // -> angular position
   Alpha:= (i * (EndPhi - InitPhi) / Steps) + InitPhi;
   // -> vertex position
   Vertices[NoVertex].x:= Pos.x + Cos(Alpha) * InRadius.x;
   Vertices[NoVertex].y:= Pos.y - Sin(Alpha) * InRadius.y;
   // -> color interpolation values
   xAlpha:= Round((Vertices[NoVertex].x - Pt1.x) * 255.0 / (Pt2.x - Pt1.x));
   yAlpha:= Round((Vertices[NoVertex].y - Pt1.y) * 255.0 / (Pt2.y - Pt1.y));
   // -> interpolate the color
   VColors[NoVertex]:= cBlend(cBlend(cs[0], cs[1], xAlpha),
    cBlend(cs[3], cs[2], xAlpha), yAlpha);
   Inc(NoVertex);

   // 6b. Insert outer vertex
   // -> angular position
   Alpha:= (i * (EndPhi - InitPhi) / Steps) + InitPhi;
   // -> vertex position
   Vertices[NoVertex].x:= Pos.x + Cos(Alpha) * OutRadius.x;
   Vertices[NoVertex].y:= Pos.y - Sin(Alpha) * OutRadius.y;
   // -> color interpolation values
   xAlpha:= Round((Vertices[NoVertex].x - Pt1.x) * 255.0 / (Pt2.x - Pt1.x));
   yAlpha:= Round((Vertices[NoVertex].y - Pt1.y) * 255.0 / (Pt2.y - Pt1.y));
   // -> interpolate the color
   VColors[NoVertex]:= cBlend(cBlend(cs[0], cs[1], xAlpha),
    cBlend(cs[3], cs[2], xAlpha), yAlpha);
   Inc(NoVertex);
  end;

 // (7) Insert indexes
 NoIndex:= 0;
 for i:= 0 to Steps - 1 do
  begin
   Indices[(i * 6) + 0]:= NoIndex;
   Indices[(i * 6) + 1]:= NoIndex + 1;
   Indices[(i * 6) + 2]:= NoIndex + 2;

   Indices[(i * 6) + 3]:= NoIndex + 1;
   Indices[(i * 6) + 4]:= NoIndex + 3;
   Indices[(i * 6) + 5]:= NoIndex + 2;

   Inc(NoIndex, 2);
  end;

 DrawIndexedTriangles(@Vertices[0], @VColors[0], @Indices[0], Length(Vertices),
  Steps * 2, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillRibbon(const Pos, InRadius, OutRadius: TPoint2;
 InitPhi, EndPhi: Single; Steps: Integer; InColor1, InColor2, InColor3,
 OutColor1, OutColor2, OutColor3: Cardinal; Effect: TDrawingEffect);
var
 Vertices: array of TPoint2;
 VColors : array of Cardinal;
 Indices : array of Integer;
 ic1, ic2, ic3, oc1, oc2, oc3, ic, oc: TAsphyreColor;
 i: Integer;
 Alpha, Theta: Single;
 NoVertex, NoIndex: Integer;
begin
 if (Steps < 1) then Exit;

 // (1) Convert 32-bit RGBA colors to fixed-point color set.
 ic1:= InColor1;
 ic2:= InColor2;
 ic3:= InColor3;
 oc1:= OutColor1;
 oc2:= OutColor2;
 oc3:= OutColor3;

 // (2) Specify the size of vertex/index arrays.
 SetLength(Vertices, (Steps * 2) + 2);
 SetLength(VColors, Length(Vertices));
 SetLength(Indices, Steps * 6);

 NoVertex:= 0;

 // (3) Create first inner vertex
 Vertices[NoVertex].x:= Pos.x + Cos(InitPhi) * InRadius.x;
 Vertices[NoVertex].y:= Pos.y - Sin(InitPhi) * InRadius.y;
 VColors[NoVertex]   := InColor1;
 Inc(NoVertex);

 // (5) Create first outer vertex
 Vertices[NoVertex].x:= Pos.x + Cos(InitPhi) * OutRadius.x;
 Vertices[NoVertex].y:= Pos.y - Sin(InitPhi) * OutRadius.y;
 VColors[NoVertex]   := OutColor1;
 Inc(NoVertex);

 // (6) Insert the rest of vertices
 for i:= 1 to Steps do
  begin
   Theta:= i / Steps;
   if (Theta < 0.5) then
    begin
     Theta:= 2.0 * Theta;
     ic:= cLerp(ic1, ic2, Theta);
     oc:= cLerp(oc1, oc2, Theta);
    end else
    begin
     Theta:= (Theta - 0.5) * 2.0;
     ic:= cLerp(ic2, ic3, Theta);
     oc:= cLerp(oc2, oc3, Theta);
    end;

   // 6a. Insert inner vertex
   // -> angular position
   Alpha:= (i * (EndPhi - InitPhi) / Steps) + InitPhi;
   // -> vertex position
   Vertices[NoVertex].x:= Pos.x + Cos(Alpha) * InRadius.x;
   Vertices[NoVertex].y:= Pos.y - Sin(Alpha) * InRadius.y;
   VColors[NoVertex]   := ic;
   Inc(NoVertex);

   // 6b. Insert outer vertex
   // -> angular position
   Alpha:= (i * (EndPhi - InitPhi) / Steps) + InitPhi;
   // -> vertex position
   Vertices[NoVertex].x:= Pos.x + Cos(Alpha) * OutRadius.x;
   Vertices[NoVertex].y:= Pos.y - Sin(Alpha) * OutRadius.y;
   VColors[NoVertex]   := oc;
   Inc(NoVertex);
  end;

 // (7) Insert indexes
 NoIndex:= 0;
 for i:= 0 to Steps - 1 do
  begin
   Indices[(i * 6) + 0]:= NoIndex;
   Indices[(i * 6) + 1]:= NoIndex + 1;
   Indices[(i * 6) + 2]:= NoIndex + 2;

   Indices[(i * 6) + 3]:= NoIndex + 1;
   Indices[(i * 6) + 4]:= NoIndex + 3;
   Indices[(i * 6) + 5]:= NoIndex + 2;

   Inc(NoIndex, 2);
  end;

 DrawIndexedTriangles(@Vertices[0], @VColors[0], @Indices[0], Length(Vertices),
  Steps * 2, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillArc(const Pos, Radius: TPoint2; InitPhi,
 EndPhi: Single; Steps: Integer; const Colors: TColor4;
 Effect: TDrawingEffect);
var
 Vertices: array of TPoint2;
 VColors : array of Cardinal;
 Indices : array of Integer;
 Pt1, Pt2: TPoint2;
 cs: TAsphyreColor4;
 i: Integer;
 Alpha: Single;
 xAlpha, yAlpha: Integer;
 NoVertex: Integer;
begin
 if (Steps < 1) then Exit;

 // (1) Convert 32-bit RGBA colors to fixed-point color set.
 cs:= ColorToFixed4(Colors);

 // (2) Find (x, y) margins for color interpolation.
 Pt1:= Pos - Radius;
 Pt2:= Pos + Radius;

 // (3) Before doing anything else, check cache availability.
 SetLength(Vertices, Steps + 2);
 SetLength(VColors, Length(Vertices));
 SetLength(Indices, Steps * 3);

 NoVertex:= 0;

 // (4) Insert initial vertex placed at the arc's center
 Vertices[NoVertex]:= Pos;
 VColors[NoVertex] := (cs[0] + cs[1] + cs[2] + cs[3]) * 0.25;
 Inc(NoVertex);

 // (5) Insert the rest of vertices
 for i:= 0 to Steps - 1 do
  begin
   // initial and final angles for this vertex
   Alpha:= (i * (EndPhi - InitPhi) / Steps) + InitPhi;

   // determine second and third points of the processed vertex
   Vertices[NoVertex].x:= Pos.x + Cos(Alpha) * Radius.x;
   Vertices[NoVertex].y:= Pos.y - Sin(Alpha) * Radius.y;

   // find color interpolation values
   xAlpha:= Round((Vertices[NoVertex].x - Pt1.x) * 255.0 / (Pt2.x - Pt1.x));
   yAlpha:= Round((Vertices[NoVertex].y - Pt1.y) * 255.0 / (Pt2.y - Pt1.y));

   VColors[NoVertex]:= cBlend(cBlend(cs[0], cs[1], xAlpha),
    cBlend(cs[3], cs[2], xAlpha), yAlpha);

   // insert new index buffer entry
   Indices[(i * 3) + 0]:= 0;
   Indices[(i * 3) + 1]:= NoVertex;
   Indices[(i * 3) + 2]:= NoVertex + 1;

   Inc(NoVertex);
  end;

 // find the latest vertex to finish the arc
 Vertices[NoVertex].x:= Pos.x + Cos(EndPhi) * Radius.x;
 Vertices[NoVertex].y:= Pos.y - Sin(EndPhi) * Radius.y;

 // find color interpolation values
 xAlpha:= Round((Vertices[NoVertex].x - Pt1.x) * 255.0 / (Pt2.x - Pt1.x));
 yAlpha:= Round((Vertices[NoVertex].y - Pt1.y) * 255.0 / (Pt2.y - Pt1.y));

 VColors[NoVertex]:= cBlend(cBlend(cs[0], cs[1], xAlpha),
  cBlend(cs[3], cs[2], xAlpha), yAlpha);

 DrawIndexedTriangles(@Vertices[0], @VColors[0], @Indices[0], Length(Vertices),
  Steps, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FillHexagon(const Mtx: TMatrix3; c1, c2, c3, c4, c5,
 c6: Cardinal; Effect: TDrawingEffect);
const
 Indices: array[0..17] of Integer =
  (0, 1, 2, 0, 2, 3, 0, 3, 4, 0, 4, 5, 0, 5, 6, 0, 6, 1);
var
 Vertices: array[0..6] of TPoint2;
 VColors : array[0..6] of Cardinal;
 Colors  : array[0..5] of TAsphyreColor;
 i: Integer;
 MiddleColor: Cardinal;
begin
 Colors[0]:= c1; Colors[1]:= c2; Colors[2]:= c3;
 Colors[3]:= c4; Colors[4]:= c5; Colors[5]:= c6;

 MiddleColor:= (Colors[0] + Colors[1] + Colors[2] + Colors[3] + Colors[4] +
  Colors[5]) / 6;

 Vertices[0]:= ZeroVec2 * Mtx;
 VColors[0] := MiddleColor;

 for i:= 0 to 5 do
  begin
   Vertices[1 + i]:= HexLookup[i] * Mtx;
   VColors[1 + i] := Colors[i];
  end;

 DrawIndexedTriangles(@Vertices[0], @VColors[0], @Indices[0], 7, 6, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.QuadHole(const Pos, Size, Center, Radius: TPoint2;
 OutColor, InColor: Cardinal; Steps: Integer; Effect: TDrawingEffect);
var
 Vertices: array of TPoint2;
 VtColors: array of Cardinal;
 Indices : array of Integer;
 Theta, Angle: Single;
 i, Base: Integer;
begin
 SetLength(Vertices, Steps * 2);
 SetLength(VtColors, Steps * 2);
 SetLength(Indices, (Steps - 1) * 6);

 for i:= 0 to Steps - 2 do
  begin
   Base:= i * 6;

   Indices[Base + 0]:= i;
   Indices[Base + 1]:= i + 1;
   Indices[Base + 2]:= Steps + i;

   Indices[Base + 3]:= i + 1;
   Indices[Base + 4]:= Steps + i + 1;
   Indices[Base + 5]:= Steps + i;
  end;

 for i:= 0 to Steps - 1 do
  begin
   Theta:= i / (Steps - 1);

   Vertices[i].x:= Pos.x + Theta * Size.x;
   Vertices[i].y:= Pos.y;
   VtColors[i]  := OutColor;

   Angle:= Pi * 0.25 + Pi * 0.5 - Theta * Pi * 0.5;

   Vertices[Steps + i].x:= Center.x + Cos(Angle) * Radius.x;
   Vertices[Steps + i].y:= Center.y - Sin(Angle) * Radius.y;
   VtColors[Steps + i]  := InColor;
  end;

 DrawIndexedTriangles(@Vertices[0], @VtColors[0], @Indices[0], Length(Vertices),
  Length(Indices) div 3, Effect);

 for i:= 0 to Steps - 1 do
  begin
   Theta:= i / (Steps - 1);

   Vertices[i].x:= Pos.x + Size.x;
   Vertices[i].y:= Pos.y + Theta * Size.y;
   VtColors[i]  := OutColor;

   Angle:= Pi * 0.25 - Theta * Pi * 0.5;

   Vertices[Steps + i].x:= Center.x + Cos(Angle) * Radius.x;
   Vertices[Steps + i].y:= Center.y - Sin(Angle) * Radius.y;
   VtColors[Steps + i]  := InColor;
  end;

 DrawIndexedTriangles(@Vertices[0], @VtColors[0], @Indices[0], Length(Vertices),
  Length(Indices) div 3, Effect);

 for i:= 0 to Steps - 1 do
  begin
   Theta:= i / (Steps - 1);

   Vertices[i].x:= Pos.x;
   Vertices[i].y:= Pos.y + Theta * Size.y;
   VtColors[i]  := OutColor;

   Angle:= Pi * 0.75 + Theta * Pi * 0.5;

   Vertices[Steps + i].x:= Center.x + Cos(Angle) * Radius.x;
   Vertices[Steps + i].y:= Center.y - Sin(Angle) * Radius.y;
   VtColors[Steps + i]  := InColor;
  end;

 DrawIndexedTriangles(@Vertices[0], @VtColors[0], @Indices[0], Length(Vertices),
  Length(Indices) div 3, Effect);

 for i:= 0 to Steps - 1 do
  begin
   Theta:= i / (Steps - 1);

   Vertices[i].x:= Pos.x + Theta * Size.x;
   Vertices[i].y:= Pos.y + Size.y;
   VtColors[i]  := OutColor;

   Angle:= Pi * 1.25 + Theta * Pi * 0.5;

   Vertices[Steps + i].x:= Center.x + Cos(Angle) * Radius.x;
   Vertices[Steps + i].y:= Center.y - Sin(Angle) * Radius.y;
   VtColors[Steps + i]  := InColor;
  end;

 DrawIndexedTriangles(@Vertices[0], @VtColors[0], @Indices[0], Length(Vertices),
  Length(Indices) div 3, Effect);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.FrameHexagon(const Mtx: TMatrix3; Color: Cardinal);
var
 i: Integer;
 Vertex, PreVertex: TPoint2;
begin
 Vertex:= ZeroVec2;

 for i:= 0 to 6 do
  begin
   PreVertex:= Vertex;
   Vertex:= HexLookup[i mod 6] * Mtx;

   if (i > 0) then
    WuLine(PreVertex, Vertex, Color, Color);
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.WireQuad(const Points: TPoint4;
 const Colors: TColor4);
var
 MyPts: TPoint4;
begin
 MyPts:= Points;

 // last pixel fix -> not very good implementation :(
 if (MyPts[0].y = MyPts[1].y)and(MyPts[2].y = MyPts[3].y)and
  (MyPts[0].x = MyPts[3].x)and(MyPts[1].x = MyPts[2].x) then
  begin
   MyPts[1].x:= MyPts[1].x - 1.0;
   MyPts[2].x:= MyPts[2].x - 1.0;
   MyPts[2].y:= MyPts[2].y - 1.0;
   MyPts[3].y:= MyPts[3].y - 1.0;
  end;

 Line(MyPts[0], MyPts[1], Colors[0], Colors[1]);
 Line(MyPts[1], MyPts[2], Colors[1], Colors[2]);
 Line(MyPts[2], MyPts[3], Colors[2], Colors[3]);
 Line(MyPts[3], MyPts[0], Colors[3], Colors[0]);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.Line(const Src, Dest: TPoint2; Color: Cardinal);
begin
 Line(Src, Dest, Color, Color);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.Line(x1, y1, x2, y2: Single; Color: Cardinal);
begin
 Line(Point2(x1, y1), Point2(x2, y2), Color, Color);
end;

//---------------------------------------------------------------------------
procedure TAsphyreCanvas.LineArray(Points: PPoint2; Color: Cardinal;
 NoPoints: Integer);
var
 i: Integer;
 NextPt: PPoint2;
begin
 for i:= 0 to NoPoints - 2 do
  begin
   NextPt:= Points;
   Inc(NextPt);

   Line(Points^, NextPt^, Color, Color);

   Points:= NextPt;
  end;
end;

//---------------------------------------------------------------------------
end.


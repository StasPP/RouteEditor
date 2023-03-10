unit HelperSets;
//---------------------------------------------------------------------------
// HelperSets.pas                                       Modified: 29-Dec-2010
// Helper classes to aid the development of application logic    Version 1.06
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
//
// If you require any clarifications about the license, feel free to contact
// us or post your question on our forums at: http://www.afterwarp.net
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
// The Original Code is HelperSets.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2007 - 2011,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
{$ifdef fpc}{$mode delphi}{$endif}
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Classes, SysUtils, Math, Vectors2px, AsphyreUtils;

//---------------------------------------------------------------------------
type
 TIntegerList = class;

//---------------------------------------------------------------------------
 TIntegerListEnumerator = class
 private
  FList: TIntegerList;
  Index: Integer;

  function GetCurrent(): Integer;
 public
  property Current: Integer read GetCurrent;

  function MoveNext(): Boolean;

  constructor Create(List: TIntegerList);
 end;

//---------------------------------------------------------------------------
 TIntegerList = class
 private
  Data: array of Integer;
  DataCount: Integer;

  function GetItem(Num: Integer): Integer;
  procedure SetItem(Num: Integer; const Value: Integer);
  procedure Request(Amount: Integer);
  function GetMemAddr(): Pointer;
  function GetIntAvg(): Integer;
  function GetIntSum(): Integer;
  function GetIntMax(): Integer;
  function GetIntMin(): Integer;
  function GetRandomValue(): Integer;
  procedure ListSwap(Index1, Index2: Integer);
  function ListCompare(Obj1, Obj2: Integer): Integer;
  function ListSplit(Start, Stop: Integer): Integer;
  procedure ListSort(Start, Stop: Integer);
  procedure SetCount(const Value: Integer);
 public
  property MemAddr: Pointer read GetMemAddr;
  property Count: Integer read DataCount write SetCount;
  property Items[Num: Integer]: Integer read GetItem write SetItem; default;

  property IntSum: Integer read GetIntSum;
  property IntAvg: Integer read GetIntAvg;
  property IntMax: Integer read GetIntMax;
  property IntMin: Integer read GetIntMin;

  property RandomValue: Integer read GetRandomValue;

  function IndexOf(Value: Integer): Integer;
  function Insert(Value: Integer): Integer; overload;
  procedure InsertFirst(Value: Integer);
  procedure Remove(Index: Integer);
  procedure Clear();
  procedure Sort();
  procedure Swap(Index0, Index1: Integer);

  procedure CopyFrom(Source: TIntegerList);
  procedure AddFrom(Source: TIntegerList);

  procedure Include(Value: Integer);
  procedure Exclude(Value: Integer);
  function Exists(Value: Integer): Boolean;
  procedure Serie(Count: Integer);
  procedure InsertRepeatValue(Value, Count: Integer);
  procedure Shuffle();
  procedure BestShuffle();

  function IsSameAs(OtherList: TIntegerList): Boolean;

  function GetEnumerator(): TIntegerListEnumerator;

  procedure SaveToStream(Stream: TStream);
  procedure LoadFromStream(Stream: TStream);

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 PPointHolder = ^TPointHolder;
 TPointHolder = record
  Point: TPoint2px;
  Data : Pointer;
 end;

//---------------------------------------------------------------------------
 TPointList = class
 private
  Data: array of TPointHolder;
  DataCount: Integer;

  function GetItem(Num: Integer): PPointHolder;
  procedure Request(Amount: Integer);
  function GetMemAddr(): Pointer;
  function GetPoint(Num: Integer): PPoint2px;
 public
  property MemAddr: Pointer read GetMemAddr;
  property Count: Integer read DataCount;

  property Item[Num: Integer]: PPointHolder read GetItem; default;
  property Point[Num: Integer]: PPoint2px read GetPoint;

  function Insert(const Point: TPoint2px; Data: Pointer = nil): Integer; overload;
  function Insert(x, y: Integer; Data: Pointer = nil): Integer; overload;
  function Insert(x, y: Integer; Data: Integer): Integer; overload;
  procedure Remove(Index: Integer);
  procedure Clear();
  function IndexOf(const Point: TPoint2px): Integer;
  procedure Include(const Point: TPoint2px; Data: Pointer = nil);
  procedure Exclude(const Point: TPoint2px);

  procedure CopyFrom(Source: TPointList);
  procedure AddFrom(Source: TPointList);

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TRectList = class
 private
  Data: array of TRect;
  DataCount: Integer;

  function GetItem(Num: Integer): PRect;
  procedure Request(Amount: Integer);
  function GetMemAddr(): Pointer;
 public
  property MemAddr: Pointer read GetMemAddr;
  property Count: Integer read DataCount;
  property Item[Num: Integer]: PRect read GetItem; default;

  function Add(const Rect: TRect): Integer; overload;
  function Add(x, y, Width, Height: Integer): Integer; overload;
  procedure Remove(Index: Integer);
  procedure Clear();

  procedure CopyFrom(Source: TRectList);
  procedure AddFrom(Source: TRectList);

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 PIntProbHolder = ^TIntProbHolder;
 TIntProbHolder = record
  Value: Integer;
  Prob : Single;
 end;

//---------------------------------------------------------------------------
 TIntProbList = class
 private
  Data: array of TIntProbHolder;
  DataCount: Integer;

  function GetItem(Num: Integer): PIntProbHolder;
  procedure Request(Amount: Integer);
  function GetMemAddr(): Pointer;
  function GetValue(Num: Integer): Integer;
  function GetProbability(Value: Integer): Single;
  procedure SetProbability(Value: Integer; const Prob: Single);
  function GetRandValue(): Integer;
 public
  property MemAddr: Pointer read GetMemAddr;
  property Count: Integer read DataCount;

  property Item[Num: Integer]: PIntProbHolder read GetItem;
  property Value[Num: Integer]: Integer read GetValue;

  property Probability[Value: Integer]: Single read GetProbability
   write SetProbability; default;

  property RandValue: Integer read GetRandValue;

  function Insert(Value: Integer; Prob: Single = 1.0): Integer;
  procedure Remove(Index: Integer);
  procedure Clear();
  function IndexOf(Value: Integer): Integer;
  procedure Include(Value: Integer; Prob: Single = 1.0);
  procedure Exclude(Value: Integer);
  procedure Serie(MaxValue: Integer; Prob: Single = 1.0);
  function Exists(Value: Integer): Boolean;

  procedure ScaleProbability(Value: Integer; Scale: Single);
  procedure ScaleProbExcept(Value: Integer; Scale: Single);

  procedure CopyFrom(Source: TIntProbList);
  procedure AddFrom(Source: TIntProbList);

  procedure SaveToStream(Stream: TStream);
  procedure LoadFromStream(Stream: TStream);

  function ExtractRandValue(): Integer;

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 StreamUtils;

//---------------------------------------------------------------------------
const
 CacheSize = 32;

//---------------------------------------------------------------------------
constructor TIntegerListEnumerator.Create(List: TIntegerList);
begin
 inherited Create();

 FList:= List;
 Index:= -1;
end;

//---------------------------------------------------------------------------
function TIntegerListEnumerator.GetCurrent(): Integer;
begin
 Result:= FList[Index];
end;

//---------------------------------------------------------------------------
function TIntegerListEnumerator.MoveNext(): Boolean;
begin
 Result:= Index < FList.Count - 1;
 if (Result) then Inc(Index);
end;

//---------------------------------------------------------------------------
constructor TIntegerList.Create();
begin
 inherited;

 DataCount:= 0;
end;

//---------------------------------------------------------------------------
destructor TIntegerList.Destroy();
begin
 DataCount:= 0;
 SetLength(Data, 0);

 inherited;
end;

//---------------------------------------------------------------------------
function TIntegerList.GetEnumerator(): TIntegerListEnumerator;
begin
 Result:= TIntegerListEnumerator.Create(Self);
end;

//---------------------------------------------------------------------------
function TIntegerList.GetMemAddr(): Pointer;
begin
 Result:= @Data[0];
end;

//---------------------------------------------------------------------------
function TIntegerList.GetItem(Num: Integer): Integer;
begin
 if (Num >= 0)and(Num < DataCount) then Result:= Data[Num]
  else Result:= Low(Integer);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.SetItem(Num: Integer; const Value: Integer);
begin
 if (Num >= 0)and(Num < DataCount) then
  Data[Num]:= Value;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Request(Amount: Integer);
var
 Required: Integer;
begin
 Required:= Ceil(Amount / CacheSize) * CacheSize;
 if (Length(Data) < Required) then SetLength(Data, Required);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.SetCount(const Value: Integer);
begin
 Request(Value);
 DataCount:= Value;
end;

//---------------------------------------------------------------------------
function TIntegerList.Insert(Value: Integer): Integer;
var
 Index: Integer;
begin
 Index:= DataCount;
 Request(DataCount + 1);

 Data[Index]:= Value;
 Inc(DataCount);

 Result:= Index;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.InsertFirst(Value: Integer);
var
 i: Integer;
begin
 Request(DataCount + 1);

 for i:= DataCount - 1 downto 1 do
  Data[i]:= Data[i - 1];

 Data[0]:= Value;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= DataCount) then Exit;

 for i:= Index to DataCount - 2 do
  Data[i]:= Data[i + 1];

 Dec(DataCount);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Clear();
begin
 DataCount:= 0;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.CopyFrom(Source: TIntegerList);
var
 i: Integer;
begin
 Request(Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i]:= Source.Data[i];

 DataCount:= Source.DataCount;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.AddFrom(Source: TIntegerList);
var
 i: Integer;
begin
 Request(DataCount + Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i + DataCount]:= Source.Data[i];

 Inc(DataCount, Source.DataCount);
end;

//---------------------------------------------------------------------------
function TIntegerList.IndexOf(Value: Integer): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to DataCount - 1 do
  if (Data[i] = Value) then
   begin
    Result:= i;
    Exit;
   end;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Include(Value: Integer);
begin
 if (IndexOf(Value) = -1) then Insert(Value);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Exclude(Value: Integer);
var
 Index: Integer;
begin
 Index:= IndexOf(Value);
 if (Index <> -1) then Remove(Index);
end;

//---------------------------------------------------------------------------
function TIntegerList.Exists(Value: Integer): Boolean;
begin
 Result:= (IndexOf(Value) <> -1);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.BestShuffle();
var
 Aux: TIntegerList;
 Index: Integer;
begin
 Aux:= TIntegerList.Create();
 Aux.CopyFrom(Self);

 Clear();

 while (Aux.Count > 0) do
  begin
   Index:= Random(Aux.Count);
   Insert(Aux[Index]);
   Aux.Remove(Index);
  end;

 FreeAndNil(Aux);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Shuffle();
var
 i, Aux, Indx: Integer;
begin
 for i:= DataCount - 1 downto 1 do
  begin
   Indx:= Random(i + 1);

   Aux:= Data[i];
   Data[i]:= Data[Indx];
   Data[Indx]:= Aux;
  end;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Serie(Count: Integer);
var
 i: Integer;
begin
 Request(Count);
 DataCount:= Count;

 for i:= 0 to DataCount - 1 do
  Data[i]:= i;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.InsertRepeatValue(Value, Count: Integer);
var
 i: Integer;
begin
 Request(DataCount + Count);

 for i:= 0 to Count - 1 do
  Data[DataCount + i]:= Value;

 Inc(DataCount, Count);
end;

//---------------------------------------------------------------------------
function TIntegerList.GetIntSum(): Integer;
var
 i: Integer;
begin
 Result:= 0;
 for i:= 0 to DataCount - 1 do
  Inc(Result, Data[i]);
end;

//---------------------------------------------------------------------------
function TIntegerList.GetIntAvg(): Integer;
begin
 if (DataCount > 0) then
  Result:= GetIntSum() div DataCount
   else Result:= 0;
end;

//---------------------------------------------------------------------------
function TIntegerList.GetIntMax(): Integer;
var
 i: Integer;
begin
 if (DataCount < 1) then
  begin
   Result:= 0;
   Exit;
  end;

 Result:= Data[0];
 for i:= 1 to DataCount - 1 do
  Result:= Max2(Result, Data[i]);
end;

//---------------------------------------------------------------------------
function TIntegerList.GetIntMin(): Integer;
var
 i: Integer;
begin
 if (DataCount < 1) then
  begin
   Result:= 0;
   Exit;
  end;

 Result:= Data[0];
 for i:= 1 to Length(Data) - 1 do
  Result:= Min2(Result, Data[i]);
end;

//---------------------------------------------------------------------------
function TIntegerList.GetRandomValue(): Integer;
begin
 if (DataCount > 0) then
  begin
   Result:= Data[Random(DataCount)];
  end else Result:= 0;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.ListSwap(Index1, Index2: Integer);
var
 Aux: Integer;
begin
 Aux:= Data[Index1];

 Data[Index1]:= Data[Index2];
 Data[Index2]:= Aux;
end;

//---------------------------------------------------------------------------
function TIntegerList.ListCompare(Obj1, Obj2: Integer): Integer;
begin
 Result:= 0;

 if (Obj1 < Obj2) then Result:= -1;
 if (Obj1 > Obj2) then Result:= 1;
end;

//---------------------------------------------------------------------------
function TIntegerList.ListSplit(Start, Stop: Integer): Integer;
var
 Left, Right, Pivot: Integer;
begin
 Left := Start + 1;
 Right:= Stop;
 Pivot:= Data[Start];

 while (Left <= Right) do
  begin
   while (Left <= Stop)and(ListCompare(Data[Left], Pivot) < 0) do
    Inc(Left);

   while (Right > Start)and(ListCompare(Data[Right], Pivot) >= 0) do
    Dec(Right);

   if (Left < Right) then ListSwap(Left, Right);
  end;

 ListSwap(Start, Right);

 Result:= Right;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.ListSort(Start, Stop: Integer);
var
 SplitPt: Integer;
begin
 if (Start < Stop) then
  begin
   SplitPt:= ListSplit(Start, Stop);

   ListSort(Start, SplitPt - 1);
   ListSort(SplitPt + 1, Stop);
  end;
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Sort();
begin
 if (DataCount > 1) then
  ListSort(0, DataCount - 1);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.Swap(Index0, Index1: Integer);
begin
 if (Index0 >= 0)and(Index0 < DataCount)and(Index1 >= 0)and(Index1 < DataCount) then
  ListSwap(Index0, Index1);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.SaveToStream(Stream: TStream);
var
 i: Integer;
begin
 StreamPutLongint(Stream, DataCount);

 for i:= 0 to DataCount - 1 do
  StreamPutLongint(Stream, Data[i]);
end;

//---------------------------------------------------------------------------
procedure TIntegerList.LoadFromStream(Stream: TStream);
var
 Amount, i: Integer;
begin
 Amount:= StreamGetLongint(Stream);
 Request(Amount);

 for i:= 0 to Amount - 1 do
  Data[i]:= StreamGetLongint(Stream);

 DataCount:= Amount;
end;

//---------------------------------------------------------------------------
function TIntegerList.IsSameAs(OtherList: TIntegerList): Boolean;
var
 i: Integer;
begin
 // (1) Check if the list points to itself or if both lists are empty.
 Result:= (Self = OtherList)or
  ((DataCount < 1)and(OtherList.DataCount < 1));
 if (Result) then Exit;

 // (2) If the lists have different number of elements, they are not equals.
 if (DataCount <> OtherList.DataCount) then Exit;

 // (3) Test element one by one.
 for i:= 0 to DataCount - 1 do
  if (Data[i] <> OtherList.Data[i]) then Exit;

 Result:= True; 
end;

//---------------------------------------------------------------------------
constructor TPointList.Create();
begin
 inherited;

 DataCount:= 0;
end;

//---------------------------------------------------------------------------
destructor TPointList.Destroy();
begin
 DataCount:= 0;
 SetLength(Data, 0);

 inherited;
end;

//---------------------------------------------------------------------------
function TPointList.GetMemAddr(): Pointer;
begin
 Result:= @Data[0];
end;

//---------------------------------------------------------------------------
function TPointList.GetItem(Num: Integer): PPointHolder;
begin
 if (Num >= 0)and(Num < DataCount) then Result:= @Data[Num]
  else Result:= nil;
end;

//---------------------------------------------------------------------------
function TPointList.GetPoint(Num: Integer): PPoint2px;
begin
 if (Num >= 0)and(Num < DataCount) then Result:= @Data[Num].Point
  else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TPointList.Request(Amount: Integer);
var
 Required: Integer;
begin
 Required:= Ceil(Amount / CacheSize) * CacheSize;
 if (Length(Data) < Required) then SetLength(Data, Required);
end;

//---------------------------------------------------------------------------
function TPointList.Insert(const Point: TPoint2px;
 Data: Pointer = nil): Integer;
var
 Index: Integer;
begin
 Index:= DataCount;
 Request(DataCount + 1);

 Self.Data[Index].Point:= Point;
 Self.Data[Index].Data := Data;
 Inc(DataCount);

 Result:= Index;
end;

//---------------------------------------------------------------------------
function TPointList.Insert(x, y: Integer; Data: Pointer = nil): Integer;
begin
 Result:= Insert(Point2px(x, y), Data);
end;

//---------------------------------------------------------------------------
function TPointList.Insert(x, y, Data: Integer): Integer;
begin
 Result:= Insert(Point2px(x, y), Pointer(Data));
end;

//---------------------------------------------------------------------------
procedure TPointList.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= DataCount) then Exit;

 for i:= Index to DataCount - 2 do
  Data[i]:= Data[i + 1];

 Dec(DataCount);
end;

//---------------------------------------------------------------------------
function TPointList.IndexOf(const Point: TPoint2px): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to DataCount - 1 do
  if (Data[i].Point = Point) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
procedure TPointList.Include(const Point: TPoint2px; Data: Pointer = nil);
begin
 if (IndexOf(Point) = -1) then Insert(Point, Data);
end;

//---------------------------------------------------------------------------
procedure TPointList.Exclude(const Point: TPoint2px);
begin
 Remove(IndexOf(Point));
end;

//---------------------------------------------------------------------------
procedure TPointList.Clear();
begin
 DataCount:= 0;
end;

//---------------------------------------------------------------------------
procedure TPointList.CopyFrom(Source: TPointList);
var
 i: Integer;
begin
 Request(Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i]:= Source.Data[i];

 DataCount:= Source.DataCount;
end;

//---------------------------------------------------------------------------
procedure TPointList.AddFrom(Source: TPointList);
var
 i: Integer;
begin
 Request(DataCount + Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i + DataCount]:= Source.Data[i];

 Inc(DataCount, Source.DataCount);
end;

//---------------------------------------------------------------------------
constructor TRectList.Create();
begin
 inherited;

 DataCount:= 0;
end;

//---------------------------------------------------------------------------
destructor TRectList.Destroy();
begin
 DataCount:= 0;
 SetLength(Data, 0);

 inherited;
end;

//---------------------------------------------------------------------------
function TRectList.GetMemAddr(): Pointer;
begin
 Result:= @Data[0];
end;

//---------------------------------------------------------------------------
function TRectList.GetItem(Num: Integer): PRect;
begin
 if (Num >= 0)and(Num < DataCount) then Result:= @Data[Num]
  else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TRectList.Request(Amount: Integer);
var
 Required: Integer;
begin
 Required:= Ceil(Amount / CacheSize) * CacheSize;
 if (Length(Data) < Required) then SetLength(Data, Required);
end;

//---------------------------------------------------------------------------
function TRectList.Add(const Rect: TRect): Integer;
var
 Index: Integer;
begin
 Index:= DataCount;
 Request(DataCount + 1);

 Data[Index]:= Rect;
 Inc(DataCount);

 Result:= Index;
end;

//---------------------------------------------------------------------------
function TRectList.Add(x, y, Width, Height: Integer): Integer;
begin
 Result:= Add(Bounds(x, y, Width, Height));
end;

//---------------------------------------------------------------------------
procedure TRectList.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= DataCount) then Exit;

 for i:= Index to DataCount - 2 do
  Data[i]:= Data[i + 1];

 Dec(DataCount);
end;

//---------------------------------------------------------------------------
procedure TRectList.Clear();
begin
 DataCount:= 0;
end;

//---------------------------------------------------------------------------
procedure TRectList.CopyFrom(Source: TRectList);
var
 i: Integer;
begin
 Request(Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i]:= Source.Data[i];

 DataCount:= Source.DataCount;
end;

//---------------------------------------------------------------------------
procedure TRectList.AddFrom(Source: TRectList);
var
 i: Integer;
begin
 Request(DataCount + Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i + DataCount]:= Source.Data[i];

 Inc(DataCount, Source.DataCount);
end;

//---------------------------------------------------------------------------
constructor TIntProbList.Create();
begin
 inherited;

 DataCount:= 0;
end;

//---------------------------------------------------------------------------
destructor TIntProbList.Destroy();
begin
 DataCount:= 0;
 SetLength(Data, 0);

 inherited;
end;


//---------------------------------------------------------------------------
function TIntProbList.GetMemAddr(): Pointer;
begin
 Result:= @Data[0];
end;

//---------------------------------------------------------------------------
function TIntProbList.GetItem(Num: Integer): PIntProbHolder;
begin
 if (Num >= 0)and(Num < DataCount) then Result:= @Data[Num]
  else Result:= nil;
end;

//---------------------------------------------------------------------------
function TIntProbList.GetValue(Num: Integer): Integer;
begin
 if (Num >= 0)and(Num < DataCount) then Result:= Data[Num].Value
  else Result:= 0;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.Request(Amount: Integer);
var
 Required: Integer;
begin
 Required:= Ceil(Amount / CacheSize) * CacheSize;
 if (Length(Data) < Required) then SetLength(Data, Required);
end;

//---------------------------------------------------------------------------
procedure TIntProbList.Clear();
begin
 DataCount:= 0;
end;

//---------------------------------------------------------------------------
function TIntProbList.IndexOf(Value: Integer): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to DataCount - 1 do
  if (Data[i].Value = Value) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TIntProbList.Insert(Value: Integer; Prob: Single): Integer;
var
 Index: Integer;
begin
 Index:= DataCount;
 Request(DataCount + 1);

 Data[Index].Value:= Value;
 Data[Index].Prob := Prob;
 Inc(DataCount);

 Result:= Index;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.Include(Value: Integer; Prob: Single);
var
 Index: Integer;
begin
 Index:= IndexOf(Value);
 if (Index <> -1) then Data[Index].Prob:= Prob
  else Insert(Value, Prob);
end;

//---------------------------------------------------------------------------
procedure TIntProbList.Exclude(Value: Integer);
begin
 Remove(IndexOf(Value));
end;

//---------------------------------------------------------------------------
function TIntProbList.Exists(Value: Integer): Boolean;
begin
 Result:= IndexOf(Value) <> -1;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= DataCount) then Exit;

 for i:= Index to DataCount - 2 do
  Data[i]:= Data[i + 1];

 Dec(DataCount);
end;

//---------------------------------------------------------------------------
procedure TIntProbList.CopyFrom(Source: TIntProbList);
var
 i: Integer;
begin
 Request(Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i]:= Source.Data[i];

 DataCount:= Source.DataCount;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.AddFrom(Source: TIntProbList);
var
 i: Integer;
begin
 Request(DataCount + Source.DataCount);

 for i:= 0 to Source.DataCount - 1 do
  Data[i + DataCount]:= Source.Data[i];

 Inc(DataCount, Source.DataCount);
end;

//---------------------------------------------------------------------------
function TIntProbList.GetProbability(Value: Integer): Single;
var
 Index: Integer;
begin
 Index:= IndexOf(Value);
 if (Index <> -1) then Result:= Data[Index].Prob else Result:= 0.0;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.SetProbability(Value: Integer; const Prob: Single);
var
 Index: Integer;
begin
 Index:= IndexOf(Value);
 if (Index <> -1) then Data[Index].Prob:= Prob
  else Insert(Value, Prob);
end;

//---------------------------------------------------------------------------
procedure TIntProbList.Serie(MaxValue: Integer; Prob: Single);
var
 i: Integer;
begin
 Clear();

 for i:= 0 to MaxValue - 1 do
  Insert(i, Prob);
end;

//---------------------------------------------------------------------------
function TIntProbList.GetRandValue(): Integer;
var
 Sample, SampleMax, SampleIn: Single;
 i: Integer;
begin
 Result:= 0;
 if (DataCount < 1) then Exit;

 SampleMax:= 0.0;

 for i:= 0 to DataCount - 1 do
  SampleMax:= SampleMax + Data[i].Prob;

 Sample:= Random() * SampleMax;

 SampleIn:= 0.0;
 for i:= 0 to DataCount - 1 do
  begin
   if (Sample >= SampleIn)and(Sample < SampleIn + Data[i].Prob) then
    begin
     Result:= Data[i].Value;
     Exit;
    end;

   SampleIn:= SampleIn + Data[i].Prob;
  end;
end;

//---------------------------------------------------------------------------
function TIntProbList.ExtractRandValue(): Integer;
var
 Sample, SampleMax, SampleIn: Single;
 i, SampleNo: Integer;
begin
 Result:= 0;
 if (DataCount < 1) then Exit;

 SampleMax:= 0.0;

 for i:= 0 to DataCount - 1 do
  SampleMax:= SampleMax + Data[i].Prob;

 Sample:= Random() * SampleMax;

 SampleIn:= 0.0;
 SampleNo:= -1;

 for i:= 0 to DataCount - 1 do
  begin
   if (Sample >= SampleIn)and(Sample < SampleIn + Data[i].Prob) then
    begin
     Result := Data[i].Value;
     SampleNo:= i;

     Break;
    end;

   SampleIn:= SampleIn + Data[i].Prob;
  end;

 if (SampleNo <> -1) then Remove(SampleNo);
end;

//---------------------------------------------------------------------------
procedure TIntProbList.SaveToStream(Stream: TStream);
var
 i, Total: Integer;
begin
 Total:= DataCount;

 Stream.WriteBuffer(Total, SizeOf(Integer));

 for i:= 0 to Total - 1 do
  begin
   Stream.WriteBuffer(Data[i].Value, SizeOf(Integer));
   Stream.WriteBuffer(Data[i].Prob, SizeOf(Single));
  end;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.LoadFromStream(Stream: TStream);
var
 i, Total: Integer;
begin
 Stream.ReadBuffer(Total, SizeOf(Integer));

 Request(Total);

 for i:= 0 to Total - 1 do
  begin
   Stream.ReadBuffer(Data[i].Value, SizeOf(Integer));
   Stream.ReadBuffer(Data[i].Prob, SizeOf(Single));
  end;

 DataCount:= Total;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.ScaleProbability(Value: Integer; Scale: Single);
var
 Index: Integer;
begin
 Index:= IndexOf(Value);
 if (Index <> -1) then Data[Index].Prob:= Data[Index].Prob * Scale;
end;

//---------------------------------------------------------------------------
procedure TIntProbList.ScaleProbExcept(Value: Integer; Scale: Single);
var
 i: Integer;
begin
 for i:= 0 to DataCount - 1 do
  if (Data[i].Value <> Value) then Data[i].Prob:= Data[i].Prob * Scale;
end;

//---------------------------------------------------------------------------
end.

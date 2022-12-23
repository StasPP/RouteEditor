unit PointClasses;

interface

  type
  TLatLong = record
      lat, long :Double
  end;

  TMyPoint = record
      x, y :Double
  end;

function MyPoint(x, y :Double): TMyPoint;
function LatLongToPoint(L :TLatLong):TMyPoint;
function PointToLatLong(P :TMyPoint):TLatLong;

implementation

function MyPoint(x, y :Double): TMyPoint;
begin
  result.x := x;
  result.y := y;
end;

function LatLongToPoint(L :TLatLong):TMyPoint;
begin
  result.x := L.lat;
  result.y := L.long;
end;

function PointToLatLong(P :TMyPoint):TLatLong;
begin
  result.lat  := P.x;
  result.long := P.y;
end;

end.

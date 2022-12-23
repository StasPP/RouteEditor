program GetMap;

uses
  Forms,
  MapperFm in 'MapperFm.pas' {MapFm},
  GetGoogle in 'Google\GetGoogle.pas' {WForm},
  FLoader in 'FLoader.pas' {FLoadGPS},
  TabFunctions in 'TabFunctions.pas',
  LoadData in 'LoadData.pas' {LoadRData},
  GeoCalcUnit in 'GeoCalcUnit.pas' {GeoCalcFm},
  MapFunctions in 'MapFunctions.pas',
  DrawFunctions in 'DrawFunctions.pas',
  BasicMapObjects in 'BasicMapObjects.pas',
  HUD1 in 'HUD1.pas',
  HintFm in 'HintFm.pas' {HintForm},
  CoordSysFm in 'CoordSysFm.pas' {CSForm},
  MapEditor in 'MapEditor.pas',
  LangLoader in 'LangLoader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TWForm, WForm);
  Application.CreateForm(TMapFm, MapFm);
  Application.CreateForm(TFLoadGPS, FLoadGPS);
  Application.CreateForm(TLoadRData, LoadRData);
  Application.CreateForm(TGeoCalcFm, GeoCalcFm);
  Application.CreateForm(THintForm, HintForm);
  Application.CreateForm(TCSForm, CSForm);
  Application.Run;
end.

﻿unit MapperFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, GeoFunctions, GeoFiles, GeoString, GeoClasses,
  Buttons, TabFunctions, StdCtrls, MapFunctions, BasicMapObjects, LangLoader,
  DrawFunctions, RTypes, HUD1, ComCtrls, Menus, MapEditor, XPMan, Spin,
  Imitator, TrackFunctions, Jpeg, GoogleMap, YandexMap, GoogleDownload,
  FloatSpinEdit, PointClasses, ImgList;

type

  TMapFm = class(TForm)
    Stats: TPanel;
    EX: TStaticText;
    EY: TStaticText;
    Csys: TStaticText;
    Comments: TLabel;
    Tools: TPanel;
    PC: TPageControl;
    POptions: TTabSheet;
    EZ: TStaticText;
    B1: TSpeedButton;
    B4: TSpeedButton;
    OpenRoutes: TOpenDialog;
    OpenMaps: TOpenDialog;
    B4a: TSpeedButton;
    PopupMenu3: TPopupMenu;
    SaveR: TSaveDialog;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    B5a: TSpeedButton;
    B5c: TSpeedButton;
    B4b: TSpeedButton;
    B6a: TSpeedButton;
    B01: TSpeedButton;
    B6c: TSpeedButton;
    B6b: TSpeedButton;
    Label1: TLabel;
    Step_: TSpinEdit;
    B001: TSpeedButton;
    Label2: TLabel;
    Deg_: TSpinEdit;
    NUm0: TSpinEdit;
    Label5: TLabel;
    PrevS: TSpeedButton;
    NextS: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SaverTXT: TSaveDialog;
    B4d: TSpeedButton;
    B25: TSpeedButton;
    B26: TSpeedButton;
    B21: TSpeedButton;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    Label8: TLabel;
    Label9: TLabel;
    MinShift_: TSpinEdit;
    Canv: TPanel;
    Blend: TTrackBar;
    B22: TSpeedButton;
    B24: TSpeedButton;
    B23: TSpeedButton;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Bm1: TSpeedButton;
    Bm3: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    B0001: TSpeedButton;
    B00001: TSpeedButton;
    SpeedButton10: TSpeedButton;
    OpenMarkers: TOpenDialog;
    PopupMenu2: TPopupMenu;
    MenuItem2: TMenuItem;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SaveGPS: TSaveDialog;
    imiLabel1: TLabel;
    ImiRad: TSpinEdit;
    imiSwicth: TCheckBox;
    imiStep: TSpinEdit;
    imiLabel3: TLabel;
    imiAnim: TCheckBox;
    imiLabel2: TLabel;
    imiRandom: TSpinEdit;
    EdW: TSpeedButton;
    NavPanel: TPanel;
    JumpXY: TSpeedButton;
    JumpRoutes: TSpeedButton;
    JumpBase: TSpeedButton;
    B27: TSpeedButton;
    B28: TSpeedButton;
    DopPan: TPanel;
    m1: TSpeedButton;
    m2: TSpeedButton;
    m3: TSpeedButton;
    DopPan2: TPanel;
    m4: TSpeedButton;
    DopPan3: TPanel;
    m5: TSpeedButton;
    RouteBoxPan: TPanel;
    RouteBox: TComboBox;
    DopPan4: TPanel;
    m6: TSpeedButton;
    DopPan5: TPanel;
    m7: TSpeedButton;
    OrdW: TSpeedButton;
    TabSheet5: TTabSheet;
    B000001: TSpeedButton;
    BNmea: TSpeedButton;
    OpenNMEA: TOpenDialog;
    Btxt: TSpeedButton;
    OpenTXT: TOpenDialog;
    DopPan6: TPanel;
    JumpTrack: TSpeedButton;
    B40: TSpeedButton;
    Bred: TSpeedButton;
    Button2: TSpeedButton;
    BDelTrack: TSpeedButton;
    isMinL: TCheckBox;
    MinL_: TSpinEdit;
    ScrPanel: TPanel;
    ScreenShot: TSpeedButton;
    Savejpg: TSaveDialog;
    SetB: TSpeedButton;
    Refreshbtn: TSpeedButton;
    TabSheet6: TTabSheet;
    B0000001: TSpeedButton;
    GPan: TPanel;
    GZoom: TComboBox;
    B50: TSpeedButton;
    Label3: TLabel;
    AGoogle: TSpeedButton;
    GDownLoad: TSpeedButton;
    GReset: TSpeedButton;
    Label4: TLabel;
    GStyle: TComboBox;
    Label6: TLabel;
    Gcount: TEdit;
    B5b: TSpeedButton;
    B5d: TSpeedButton;
    B5: TSpeedButton;
    Azoom: TCheckBox;
    SaveM: TSaveDialog;
    AGoogle2: TSpeedButton;
    B29: TSpeedButton;
    CutPan: TPanel;
    Bcut: TSpeedButton;
    Bres: TSpeedButton;
    InfCut: TCheckBox;
    PopupMenu4: TPopupMenu;
    extfiles1: TMenuItem;
    SurferBlnusingPulkovo19421: TMenuItem;
    SurferBlnCS42GaussKruger1: TMenuItem;
    NavisGalsListlstWGS841: TMenuItem;
    SaveBlN: TSaveDialog;
    SaveLst: TSaveDialog;
    Bm2: TSpeedButton;
    isDA: TSpeedButton;
    B5e: TSpeedButton;
    TabSheet7: TTabSheet;
    B51: TSpeedButton;
    Ypan: TPanel;
    Label7: TLabel;
    YDownload: TSpeedButton;
    YReset: TSpeedButton;
    Label10: TLabel;
    Label11: TLabel;
    Ystyle: TComboBox;
    Ycount: TEdit;
    YAZoom: TCheckBox;
    YZoom: TComboBox;
    B2b2: TSpeedButton;
    B5d2: TSpeedButton;
    B6: TSpeedButton;
    AYandex: TSpeedButton;
    B00000001: TSpeedButton;
    Ylang: TComboBox;
    Label12: TLabel;
    PopupMenu5: TPopupMenu;
    GoogleMaps1: TMenuItem;
    YandexMaps1: TMenuItem;
    Ruler: TSpeedButton;
    RulPan: TPanel;
    RulReset: TSpeedButton;
    Rlength: TStaticText;
    Rcount: TStaticText;
    DelLast: TSpeedButton;
    Label13: TLabel;
    Label14: TLabel;
    REllLength: TStaticText;
    Label15: TLabel;
    Garmingpx1: TMenuItem;
    SaveGPX: TSaveDialog;
    Rtops: TSpeedButton;
    B41: TSpeedButton;
    Rtt: TSpeedButton;
    RttSave: TSpeedButton;
    SaveRTT: TSaveDialog;
    OpenRTT: TOpenDialog;
    RTable: TSpeedButton;
    RouteBoxPan2: TPanel;
    RouteBox2: TComboBox;
    Estim: TSpeedButton;
    MrkRoutes: TSpeedButton;
    B31: TSpeedButton;
    BrkRoutes: TSpeedButton;
    MarkRoute: TSpeedButton;
    RulPan2: TPanel;
    RCL: TStaticText;
    DoneLine: TSpeedButton;
    ShowLength: TCheckBox;
    RCAZ: TStaticText;
    ShowAzmt: TCheckBox;
    RCDA: TStaticText;
    ShowDA: TCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    DopRul: TSpeedButton;
    MarkFrame: TSpeedButton;
    PopupMenu6: TPopupMenu;
    Doreload1: TMenuItem;
    DoAdd1: TMenuItem;
    PopupMenu7: TPopupMenu;
    DoReload2: TMenuItem;
    DoAdd2: TMenuItem;
    PopupMenu8: TPopupMenu;
    DoReaload3: TMenuItem;
    DoAdd3: TMenuItem;
    B30: TSpeedButton;
    KnotPanel: TPanel;
    KnotsNew: TSpeedButton;
    KnotsOpen: TSpeedButton;
    KnotsDestroy: TSpeedButton;
    KnotsSave: TSpeedButton;
    KnotsToMarkers: TSpeedButton;
    NewKnotPanel: TPanel;
    ApplyKnots: TSpeedButton;
    KnotAngRoute: TRadioButton;
    KnotAngOwn: TRadioButton;
    NoNewKnots: TSpeedButton;
    KnotAng_: TSpinEdit;
    Label20: TLabel;
    KnotAngAdd: TCheckBox;
    NewKnotPanel2: TPanel;
    KnotStart: TSpinEdit;
    Label22: TLabel;
    PopupMenu9: TPopupMenu;
    MenuItem3: TMenuItem;
    KnotSettings: TPanel;
    SOkKn: TSpeedButton;
    SCancelKn: TSpeedButton;
    SetKnName: TEdit;
    SetKnAng_: TSpinEdit;
    SetKnNameLabel: TLabel;
    SetKnAngLabel: TLabel;
    SetKnSize_: TSpinEdit;
    SetKnSizeLabel: TLabel;
    SViewKn: TSpeedButton;
    SDelKn: TSpeedButton;
    SetKnL: TSpinEdit;
    SetKnLLabel: TLabel;
    SetKnXY: TSpeedButton;
    SMoveKn: TSpeedButton;
    PopupMenu10: TPopupMenu;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    SaverKnots: TSaveDialog;
    KnotPts: TSpeedButton;
    Bevel1: TBevel;
    Label23: TLabel;
    Knex2: TLabel;
    KnEx1: TLabel;
    KnotNames: TComboBox;
    Label21: TLabel;
    SetKnNameKindLabel: TLabel;
    SetKnTest1: TLabel;
    SetKnTest2: TLabel;
    SetKnNameKind: TComboBox;
    Label24: TLabel;
    SetKnPts: TSpeedButton;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    NCPC: TPageControl;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    KnotLabel: TLabel;
    Label19: TLabel;
    ShowNewKnots: TSpeedButton;
    KnotOutpos: TLabel;
    Bevel2: TBevel;
    KnotSize_: TSpinEdit;
    KnotRoutes: TComboBox;
    KnotStep_: TSpinEdit;
    KnotStartL_: TSpinEdit;
    KnotContinue: TCheckBox;
    Bevel3: TBevel;
    Label29: TLabel;
    KnotAreaStepX_: TSpinEdit;
    Label30: TLabel;
    KnotAreaRadius_: TSpinEdit;
    Bevel4: TBevel;
    KnotAreaAngle_: TSpinEdit;
    Label32: TLabel;
    KnotAreaStepY_: TSpinEdit;
    Label33: TLabel;
    Label34: TLabel;
    KnotAreaOrder: TComboBox;
    KnotsNew2: TSpeedButton;
    NewKnotPanel3: TPanel;
    OpenerKnots: TOpenDialog;
    Label35: TLabel;
    KnotAreadX_: TSpinEdit;
    KnotAreadY_: TSpinEdit;
    Label36: TLabel;
    Label31: TLabel;
    NewKnShift: TSpeedButton;
    Label37: TLabel;
    KnotAreaName: TEdit;
    PopupMenu11: TPopupMenu;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    Surferbln1: TMenuItem;
    GPSeXchange1: TMenuItem;
    ShowPkts: TSpeedButton;
    Bevel5: TBevel;
    ShowNewAreaKnots: TSpeedButton;
    InvAreaOrder: TCheckBox;
    NewKnotPanel4: TPanel;
    Label38: TLabel;
    KnotsLFrom: TSpinEdit;
    KnotsLTogether: TCheckBox;
    StatBtn: TSpeedButton;
    DopAdd4: TMenuItem;
    AdvSplit: TGroupBox;
    Extra: TCheckBox;
    Extra2: TCheckBox;
    Extra3: TCheckBox;
    e1: TImage;
    e2: TImage;
    e3: TImage;
    URPan: TPanel;
    UndoB: TSpeedButton;
    RedoB: TSpeedButton;
    SaveKnotMarkers: TSpeedButton;
    SaverMarks: TSaveDialog;
    MeleskButton: TSpeedButton;
    GroupNum: TButton;
    Checkmates: TSpeedButton;
    LoopShape: TSpeedButton;
    SetSpan: TPanel;
    SStepLabel: TLabel;
    SetSStep_: TSpinEdit;
    PopupMenu12: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    SetS2Pan: TPanel;
    SetKnSizeLabel2: TLabel;
    SetKnSize2_: TSpinEdit;
    DevStar: TSpeedButton;
    UAVMissionmission1: TMenuItem;
    UAVMissionmission2: TMenuItem;
    SaveMis: TSaveDialog;
    KeyholeMarkupLanguagekml1: TMenuItem;
    SaveKML: TSaveDialog;
    PopupMenu13: TPopupMenu;
    DoReload4: TMenuItem;
    DoAdd4: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure MakeFloatSpins;
    procedure DestroyFloatSpins;
    procedure OnDeviceCreate(Sender: TObject; Param: Pointer; var Handled: Boolean);
    procedure TimerEvent(Sender:TObject);
    procedure RenderEvent(Sender:TObject);

    procedure OnShowHint(var HintStr: string;
               var CanShow: Boolean; var HintInfo: THintInfo);

    procedure ShowCurPos;
    procedure PointPos(_B, _L, _H :Double; var _EX, _EY, _EZ:String);
    procedure ModeButtons;
    procedure CheckUndoRedo;

    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);

    procedure CustomScale;
    procedure CustomFi;

    procedure DoAZoom(isAuto:Boolean);
    procedure DoYAZoom(isAuto:Boolean);

    procedure GetEdTools;

    procedure SetRtH;

    procedure SaveCtrlZ;
    procedure LoadCtrlZ(CtrlShift:Boolean);

    procedure RefreshRouteBox;

    procedure TreeSelectRoutePoint(RouteN, N: Integer);
    procedure TreeSelectFramePoint(N: Integer);

    procedure RenameRoute;
    procedure ShiftSelected(N, E : real);
    procedure DelSelected;
    procedure CoordForSelected;

    procedure CanvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CanvMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure CsysClick(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CanvMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Bm1Click(Sender: TObject);
    procedure N81Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure StaticText3Click(Sender: TObject);
    procedure DopAdd4Click(Sender: TObject);

    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure B2aClick(Sender: TObject);
    procedure B4Click(Sender: TObject);
    procedure B4aClick(Sender: TObject);
    procedure B5cClick(Sender: TObject);
    procedure B5aClick(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure B5dClick(Sender: TObject);

    procedure PopupMenuItemsClick(Sender: TObject);
    procedure AddPopupItems(var PopupMenu: TPopupMenu; ItmName:String);

    procedure PopupMarkerClick(Sender: TObject);
    procedure MarkerListPopup;

    procedure RefreshSt;
    procedure RefreshYSt;

    procedure B5bClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure B6aClick(Sender: TObject);
    procedure NextSClick(Sender: TObject);
    procedure PrevSClick(Sender: TObject);
    procedure B6bClick(Sender: TObject);
    procedure B6cClick(Sender: TObject);
    procedure B4dClick(Sender: TObject);
    procedure Deg_Change(Sender: TObject);
    procedure BlendChange(Sender: TObject);
    procedure POptionsShow(Sender: TObject);
    procedure Bm3Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure B25Click(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure EdWClick(Sender: TObject);
    procedure CanvMouseLeave(Sender: TObject);
    procedure B26Click(Sender: TObject);
    procedure JumpXYClick(Sender: TObject);
    procedure JumpBaseClick(Sender: TObject);
    procedure JumpRoutesClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure ResetMs;
    procedure SetM(N:Integer);
    procedure m1Click(Sender: TObject);
    procedure m2Click(Sender: TObject);
    procedure m3Click(Sender: TObject);
    procedure m5Click(Sender: TObject);
    procedure m4Click(Sender: TObject);
    procedure RouteBoxChange(Sender: TObject);
    procedure m6Click(Sender: TObject);
    procedure m7Click(Sender: TObject);
    procedure UndoBClick(Sender: TObject);
    procedure RedoBClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OrdWClick(Sender: TObject);
    procedure BNmeaClick(Sender: TObject);
    procedure JumpTrackClick(Sender: TObject);
    procedure BtxtClick(Sender: TObject);
    procedure BredClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RefreshbtnClick(Sender: TObject);
    procedure BDelTrackClick(Sender: TObject);
    procedure AppOnMessage(var MSG :TMsg; var Handled :Boolean);
    procedure B4cClick(Sender: TObject);
    procedure ScreenShotClick(Sender: TObject);
    procedure SaveScreen(FN:string);
    procedure GDownLoadClick(Sender: TObject);
    procedure B50Click(Sender: TObject);
    procedure GZoomChange(Sender: TObject);
    procedure GStyleChange(Sender: TObject);
    procedure GResetClick(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);

    procedure MapCombos;
    procedure MeanUTMZone;
    procedure MeanCenter;
    procedure DefineCsys;
    procedure DefaultCsys;

    procedure AGoogleClick(Sender: TObject);
    procedure AGoogle2Click(Sender: TObject);
    procedure BresClick(Sender: TObject);
    procedure BcutClick(Sender: TObject);
    procedure InfCutClick(Sender: TObject);
    procedure SaveRoutesTXT;

    procedure LoadSettings(FileName: String);
    procedure SaveSettings(FileName: String);
    procedure SetBClick(Sender: TObject);
    procedure SurferBlnusingPulkovo19421Click(Sender: TObject);
    procedure SurferBlnCS42GaussKruger1Click(Sender: TObject);
    procedure NavisGalsListlstWGS841Click(Sender: TObject);
    procedure MinShift_Change(Sender: TObject);
    procedure isDAClick(Sender: TObject);
    procedure B5eClick(Sender: TObject);
    procedure YResetClick(Sender: TObject);
    procedure YDownloadClick(Sender: TObject);
    procedure YstyleChange(Sender: TObject);
    procedure YZoomChange(Sender: TObject);
    procedure AYandexClick(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure YlangChange(Sender: TObject);
    procedure GoogleMaps1Click(Sender: TObject);
    procedure YandexMaps1Click(Sender: TObject);
    procedure CsysMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure RulerClick(Sender: TObject);
    procedure RulResetClick(Sender: TObject);
    procedure DelLastClick(Sender: TObject);

    procedure RulStat;
    procedure CurRulStat;
    procedure Garmingpx1Click(Sender: TObject);
    procedure RtopsClick(Sender: TObject);
    procedure RinfClick(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure RTableClick(Sender: TObject);
    procedure RttClick(Sender: TObject);
    procedure RttSaveClick(Sender: TObject);
    procedure EstimClick(Sender: TObject);
    procedure extfiles1Click(Sender: TObject);
    procedure BrkRoutesClick(Sender: TObject);
    procedure MrkRoutesClick(Sender: TObject);
    procedure B31Click(Sender: TObject);
    procedure MarkRouteClick(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure DevStarClick(Sender: TObject);
    procedure DoneLineClick(Sender: TObject);
    procedure ShowAzmtClick(Sender: TObject);
    procedure ShowDAClick(Sender: TObject);
    procedure DopRulClick(Sender: TObject);
    procedure MarkFrameClick(Sender: TObject);
    procedure Doreload1Click(Sender: TObject);
    procedure DoAdd1Click(Sender: TObject);
    procedure DoReload2Click(Sender: TObject);
    procedure DoAdd2Click(Sender: TObject);
    procedure BNmeaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtxtMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RttMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoReaload3Click(Sender: TObject);
    procedure DoAdd3Click(Sender: TObject);
    procedure ApplyKnotsClick(Sender: TObject);
    procedure KnotSize_Change(Sender: TObject);
    procedure KnotRoutesChange(Sender: TObject);
    procedure KnotsNewClick(Sender: TObject);
    procedure NoNewKnotsClick(Sender: TObject);
    procedure ShowNewKnotsClick(Sender: TObject);
    procedure KnotsDestroyClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure SViewKnClick(Sender: TObject);
    procedure SCancelKnClick(Sender: TObject);
    procedure SDelKnClick(Sender: TObject);
    procedure SMoveKnClick(Sender: TObject);
    procedure SetKnNameChange(Sender: TObject);
    procedure SetKnNameKindChange(Sender: TObject);
    procedure SetKnLChange(Sender: TObject);
    procedure SetKnAng_Change(Sender: TObject);
    procedure SetKnSize_Change(Sender: TObject);
    procedure SOkKnClick(Sender: TObject);

    procedure CheckKnSaver;
    procedure RefreshKnExamples;
    procedure SetKnNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetKnAng_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetKnSize_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetKnXYClick(Sender: TObject);
    procedure KnotsSaveClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure KnotPtsClick(Sender: TObject);
    procedure InitKnots(Kind:Integer);
    procedure KnotsToMarkersClick(Sender: TObject);
    procedure SetKnPtsClick(Sender: TObject);
    procedure KnotsNew2Click(Sender: TObject);
    procedure NewKnShiftClick(Sender: TObject);
    procedure SaveKnotMarkersClick(Sender: TObject);
    procedure ShowPktsClick(Sender: TObject);
    procedure ShowNewAreaKnotsClick(Sender: TObject);
    procedure TabSheet9Show(Sender: TObject);
    procedure TabSheet8Show(Sender: TObject);
    procedure KnotsLTogetherClick(Sender: TObject);
    procedure StatBtnClick(Sender: TObject);
    procedure e1Click(Sender: TObject);
    procedure e2Click(Sender: TObject);
    procedure e3Click(Sender: TObject);

    procedure JumpToRoutesMap(N:Integer);
    procedure SaverMarksTypeChange(Sender: TObject);
    procedure MeleskButtonClick(Sender: TObject);
    procedure GroupNumClick(Sender: TObject);
    procedure CheckmatesClick(Sender: TObject);
    procedure LoopShapeClick(Sender: TObject);
    procedure SetSStep_Change(Sender: TObject);
    procedure SetSStep_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N1Click(Sender: TObject);
    procedure B40Click(Sender: TObject);
    procedure SetKnSize2_KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetKnSize2_Change(Sender: TObject);
    procedure UAVMissionmission1Click(Sender: TObject);
    procedure UAVMissionmission2Click(Sender: TObject);
    procedure KeyholeMarkupLanguagekml1Click(Sender: TObject);
    procedure DoReload4Click(Sender: TObject);
    procedure DoAdd4Click(Sender: TObject);
  private
    procedure B4dClickNew(Sender: TObject);
    { Private declarations }

  public

    CoordSysN : Integer;
    
    { Public declarations }
  end;

const
  AskTrackTreshold = 10000;
var
  idx, oldIdX: longInt;
  HintX,HintY: Integer;

  MapFm: TMapFm;

  Step, MinShift, MinL, Deg :TFloatSpinEdit;
  KnotStartL, KnotAng, KnotSize, KnotStep, SetKnAng, SetKnSize,  SetKnSize2,
  KnotAreaStepX, KnotAreaStepY, KnotAreaAngle, KnotAreaRadius,
  KnotAreadX, KnotAreadY, SetSstep :TFloatSpinEdit;

  /// Settings
  DrawAll     :Boolean = false;
  LStyle      :Integer = 0;
  JustStarted :Boolean = false;
  OpenGL      :Boolean = false;
  ShowMaps    :Boolean = true;
  DoDrawLines :Boolean = true;
  BigCur      :Boolean = false;
  Smooth      :Boolean = true;
  AlwaysN     :Boolean = false;
  DegIsDA     :Boolean = false;  //// for Split

  AskNoSmooth :Boolean = false;
  AskNoSmoothN:real = 0;

  isFistStart :Boolean = true;

  Melesk      :Boolean = false;

  MyDir, TmpDir   :String;

  /// Colors
  BackGroundColor :Cardinal = $FF3A3A3A;
  LinesColor      :Cardinal = $FF5D5D5D;
  ChoosedColor    :Cardinal = $FFF00101;
  DopObjColor     :Cardinal = $FFF16161;
  ObjColor        :Cardinal = $FF0BC6F4;
  IntColor        :Cardinal = $9F0BC6F4;
  InfoColor       :Cardinal = $FFFFFFFF;
  TrackColor      :Cardinal = $FFF10101;
  RedTrackColor   :Cardinal = $FF01F101;
  FntColor        :Cardinal = $FFFFFFFF;

  Ticks           :Double = 0;

  CtrlZ           :integer = 0;
  CtrlShiftZ      :integer = 0;
  ArKind          :integer = 1;

  TrackMenuKind   :integer = 1;

  RulCreatingLines:boolean = true;
  NotChangeKnot   :boolean = false;

  ChessMode       :Byte = 0;
  RndLoop         :Byte = 0;
  
  MarkFmt :integer = 1;
implementation

uses
 Vectors2, Vectors2px, AsphyreTimer, AsphyreFactory, AsphyreTypes, AsphyreDb,
 AbstractDevices, AsphyreImages, AsphyreFonts, DX9Providers,
 AbstractCanvas, OGLProviders, LoadData, NewMark, CoordSysFm, GeoCalcUnit,
  SaveTXT, UMarkEd, UEdWin, UEdTools, UMovep, UNamer, UGetMapPos, UOrderW,
  LoadTrack, ParUnit1, USets, UROps, URList, UEopen, URNewOps, UMarkerList,
  UMarkerOps, UDevStar, UKnotList, UKnotPickets, UsaveKnots, ULoadBLNData,
  UReduseTr, UStatBox, UOpenUdf, FLoader, UGroupKnotRenum, UTrackCS,
  UCollapseFm, UOpenKML;

{$R *.dfm}


type
  //Виды кодировок.
  TEncode = (ENC_UNKNOWN, ENC_CP1251, ENC_CP866, ENC_UTF8, ENC_UTF16LE, ENC_UTF16BE); //ENC_UNKNOWN - неизвестная кодировка.
  //Виды BOM (Byte Order Mark).
  TBOM = (BOM_EMPTY, BOM_UTF8, BOM_UTF16LE, BOM_UTF16BE); //BOM_EMPTY - BOM не обнаружена.

procedure CheckCharSet(var F:string);

 const
    DRuCP1251 = [#$C0..#$FF, #$A8, #$B8]; //Множество кодов русских букв на кодовой странице CP1251.
    DRuCP866 = [#$80..#$AF, #$E0..#$F1];  //Множество кодов русских букв на кодовой странице CP866.

  //Проверка BOM (Byte Order Mark) для кодировок UTF-8, UTF-16LE, UTF-16BE.
  function GetBOM(const aStr : AnsiString) : TBOM;
  var
    Len : Integer;
  begin
    Result := BOM_EMPTY;
    Len := Length(aStr);
    if (Len >= 3) and (Copy(aStr, 1, 3) = #$EF#$BB#$BF) then
      Result := BOM_UTF8
    else if Len >= 2 then
      if Copy(aStr, 1, 2) = #$FF#$FE then
        Result := BOM_UTF16LE
      else if Copy(aStr, 1, 2) = #$FE#$FF then
        Result := BOM_UTF16BE;
  end;

  //Подсчёт количества русских букв, согласно кодовой странице CP1251.
  function CntRuCP1251(const aStr : AnsiString) : Integer;
  var  i : Integer;
  begin
    Result := 0;
    for i := 1 to Length(aStr) do
      if aStr[i] in DRuCP1251 then
        Inc(Result);
  end;
  //Предположение о наличии кодировки CP1251.
  function IsCP1251(const aStr : AnsiString) : Boolean;
  const
    DCP866 = DRuCP866 - DRuCP1251; //Множество кодов русских букв, которые определены в кодировке CP866 и отсутствуют в CP1251.
  var
   i, Cnt, CntCP866 : Integer;
  begin
    Cnt := 0;
    CntCP866 := 0;
    for i := 1 to Length(aStr) do
     if aStr[i] in DRuCP1251 then
      Inc(Cnt)
    else if aStr[i] in DCP866 then
      Inc(CntCP866);
    Result := (CntCP866 = 0) and (Cnt > 1);
  end;
  //Предположение о наличии кодировки CP866.
  function IsCP866(const aStr : AnsiString) : Boolean;
  const
    DCP1251 = DRuCP1251 - DRuCP866; //Множество кодов русских букв, которые определены в кодировке CP1251 и отсутствуют в CP866.
  var
    i, Cnt, CntCP1251 : Integer;
  begin
    Cnt := 0;
    CntCP1251 := 0;
    for i := 1 to Length(aStr) do
      if aStr[i] in DRuCP866 then
        Inc(Cnt)
      else if aStr[i] in DCP1251 then
        Inc(CntCP1251);
    Result := (CntCP1251 = 0) and (Cnt > 1);
  end;

  //Предположение о наличии кодировки UTF-8.
  function IsUTF8(const aStr : AnsiString) : Boolean;
  begin
    Result := GetBOM(aStr) = BOM_UTF8;
    if not Result then
      Result := CntRuCP1251(Utf8ToAnsi(aStr)) > 1;
  end;

  //Предположение о наличии кодировки UTF-16LE.
  function IsUTF16LE(const aStr : AnsiString) : Boolean;
  var
    Ws : WideString;
    Len : Integer;
  begin
    Result := GetBOM(aStr) = BOM_UTF16LE;
    if not Result then
    begin
      Len := Length(aStr) div SizeOf(WideChar);
      SetLength(Ws, Len);
      CopyMemory(Pointer(Ws), Pointer(aStr), Len * SizeOf(WideChar));
      //Здесь перед вызовом функции произойдёт автоматическое преобразование
      //WideString -> AnsiString (UTF-16LE -> ANSI).
      Result := CntRuCP1251(Ws) > 1;
    end;
  end;

  //Предположение о наличии кодировки UTF-16BE.
  function IsUTF16BE(const aStr : AnsiString) : Boolean;
  var
    Ws : WideString;
    P1, P2 : PAnsiChar;
    i, Len : Integer;
  begin
    Result := GetBOM(aStr) = BOM_UTF16BE;
    if not Result then
    begin
      Len := Length(aStr) div SizeOf(WideChar);
      SetLength(Ws, Len);
      P1 := Pointer(aStr);
      P2 := Pointer(Ws);
      //Копируем содержимое aStr в Ws и одновременное выполняем преобразование
      //UTF-16BE -> UTF-16LE путём обмена местами младшего и старшего бйата в каждом WideChar символе.
      for i := 1 to Len do //Перебор пар байтов.
      begin
        P2[0] := P1[1]; //Старший байт на место младшего.
        P2[1] := P1[0]; //Младший байт на место старшего.
        //Передвигаем указатели к слейдующей паре байтов.
        Inc(P1, 2);
        Inc(P2, 2);
      end;
      //Здесь перед вызовом функции произойдёт автоматическое преобразование
      //WideString -> AnsiString (UTF-16LE -> ANSI).
      Result := CntRuCP1251(Ws) > 1;
    end;
  end;

  //Определение кодировки.
  function GetEncode(const aStr : String) : TEncode;
  begin
    Result := ENC_UNKNOWN;
    if IsUTF8(aStr) then
      Result := ENC_UTF8
    else if IsUTF16LE(aStr) then
      Result := ENC_UTF16LE
    else if IsUTF16BE(aStr) then
      Result := ENC_UTF16BE
    //Проверку на CP1251 и CP866 выполянем только после проверок на UNICODE кодировки.
    else if IsCP1251(aStr) then
      Result := ENC_CP1251
    else if IsCP866(aStr) then
      Result := ENC_CP866;
  end;

  //Перекодировка OEM (DOS, CP866) -> ANSI (Windows, CP1251).
  function StrOemToAnsi(const aStr : AnsiString) : AnsiString;
  var
    Len : Integer;
  begin
    Len := Length(aStr);
    SetLength(Result, Len);
    OemToCharBuffA(PAnsiChar(aStr), PAnsiChar(Result), Len);
  end;

  //Перекодировка UTF-16BE -> UTF-16LE.
  function StrUTF16BEToLE(aWStr : WideString) : WideString;
  var
    P : PAnsiChar;
    ACh : AnsiChar;
    i : Integer;
  begin
    //Преобразование UTF-16BE -> UTF-16LE.
    P := Pointer(aWStr);
    for i := 1 to Length(aWStr) do
    begin
      ACh := P[0];
      P[0] := P[1];
      P[1] := ACh;
      Inc(P, 2); //Переводим указатель на следующую пару символов.
    end;
    Result := aWStr;
  end;

 const
  MaxBuffSize = 4000; //Размер буфера в байтах.
  var
    Od : TOpenDialog;
    Fs : TFileStream;
    S  : AnsiString;
    Ws : WideString;
    i, BuffSize : Integer;
    SL :TSTringList;
begin
   SL := TSTringList.Create;
  //Загрузка данных из файла и их обработка.
  Fs := TFileStream.Create(F, fmOpenRead + fmShareDenyWrite);
  try
    //Выбор размера буфера.
    BuffSize := MaxBuffSize;
    if BuffSize > Fs.Size then
      BuffSize := Fs.Size;
    //Загрузка в буфер данных из файла.
    SetLength(S, BuffSize);
    Fs.Read(S[1], BuffSize);
    Fs.Position := 0;

    case GetEncode(S) of
      ENC_UNKNOWN: //Если кодировка не определена, то загружаем, как ANSI текст с заменой символов с кодом #0.
      begin
        SetLength(S, Fs.Size);
        Fs.Read(S[1], Fs.Size);
        //Заменяем коды #0 на '?', чтобы при загрузке в Memo не возникало отсечки по терминальному нулю.
        for i := 1 to Length(S) do
          if S[i] = #0 then
            S[i] := '?';

         SL.Text := S;
      end;
      ENC_CP1251:
      begin
        SL.LoadFromStream(Fs);
      end;
      ENC_CP866:
      begin
        SetLength(S, Fs.Size);
        Fs.Read(S[1], Fs.Size);
        SL.Text := StrOemToAnsi(S);
      end;
      ENC_UTF8:
      begin
        if GetBOM(S) <> BOM_EMPTY then
          Fs.Position := 3;
        SetLength(S, Fs.Size - Fs.Position);
        Fs.Read(S[1], Fs.Size);
        SL.Text := UTF8Decode(S); //В Delphi 2007 и ниже преобразование UTF-16LE -> ANSI будет выполнено автоматически.
      end;
      ENC_UTF16LE:
      begin
        if GetBOM(S) <> BOM_EMPTY then
          Fs.Position := 2;
        SetLength(Ws, (Fs.Size - Fs.Position) div SizeOf(WideChar));
        Fs.Read(Ws[1], Length(Ws) * SizeOf(WideChar));
        SL.Text := Ws; //В Delphi 2007 и ниже преобразование UTF-16LE -> ANSI будет выполнено автоматически.
      end;
      ENC_UTF16BE:
      begin
        if GetBOM(S) <> BOM_EMPTY then
          Fs.Position := 2;
        SetLength(Ws, (Fs.Size - Fs.Position) div SizeOf(WideChar));
        Fs.Read(Ws[1], Length(Ws) * SizeOf(WideChar));
        SL.Text := StrUTF16BEToLE(Ws); //В Delphi 2007 и ниже преобразование UTF-16LE -> ANSI будет выполнено автоматически.
      end;
    else
      //raise Exception.Create('Незарегистрированный идентификатор кодировки!');
    end;
  finally
    F := 'Data\Tmp.tx_';
    SL.SaveToFile(F);
    FreeAndNil(Fs);
    SL.Free;
  end;


end;

// ---------------------

function InputCombo(const ACaption, APrompt: string; const AList: TStrings): string;

  function GetCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;  
  
var
  Form: TForm;
  Prompt: TLabel;
  Combo: TComboBox;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := '';
  Form   := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption     := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position    := poScreenCenter;
      Prompt      := TLabel.Create(Form);
      with Prompt do
      begin
        Parent   := Form;
        Caption  := APrompt;
        Left     := MulDiv(8, DialogUnits.X, 4);
        Top      := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Combo := TComboBox.Create(Form);
      with Combo do
      begin
        Parent := Form;
        Style  := csDropDownList;
        //für Eingabemöglichkeit in Combo verwende
        //For input possibility in combo uses
        //Style := csDropDown;
        Items.Assign(AList);
        ItemIndex := 0;
        Left      := Prompt.Left;
        Top       := Prompt.Top + Prompt.Height + 5;
        Width     := MulDiv(164, DialogUnits.X, 4);
      end;
      ButtonTop    := Combo.Top + Combo.Height + 15;
      ButtonWidth  := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := 'OK';
        ModalResult := mrOk;
        default     := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := inf[277];
        ModalResult := mrCancel;
        Cancel      := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Combo.Top + Combo.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Result := Combo.Text;
      end;
    finally
      Form.Free;
    end;
end;

// ---------------------

procedure CheckWFZ;
begin
  if (Length(Markers) = 0) and (RouteCount = 0) and (FrameCount = 0)
    and (Length(MainTrack) = 0) and (Length(MapList) = 0) then
       WaitForZone := true;
end;

procedure DoDoKnots;
var
   b: boolean; a:Double;
begin
  if MapFm.KnotAngRoute.Checked then
  begin
    a := 0;
    b := true;
  end
  else
    begin
       a := MapperFm.KnotAng.Value;
       b := MapFm.KnotAngAdd.Checked;
    end;


  with FKnotPickets do
  if MapFm.NCPC.ActivePageIndex = 0 then
    DoKnots(MapFm.KnotRoutes.ItemIndex-1, MapperFm.KnotStep.Value,
      MapperFm.KnotSize.Value, a, b, MapFm.KnotNames.ItemIndex, MapFm.KnotStart.Value,
      MapperFm.KnotStartL.Value,  MapFm.KnotContinue.Checked,
      pkt_PMethod, pkt_StartA, pkt_N, pkt_Lx, pkt_Ly, pkt_Lmax, pkt_NameKind1,
      pkt_NameKind2, pkt_N, pkt_Drop, (MapFm.KnotsLTogether.Checked)and
      (MapFm.KnotNames.ItemIndex > 1), MapFm.KnotsLFrom.Value, ChessMode)
  else
     DoAreaKnots(MapFm.KnotAreaOrder.ItemIndex, MapperFm.KnotAreaStepX.Value,
      MapperFm.KnotAreaStepY.Value, MapperFm.KnotAreaAngle.Value*pi/180,
      MapperFm.KnotAreaRadius.Value, a, b, MapFm.KnotNames.ItemIndex,
      MapFm.KnotStart.Value, MapperFm.KnotStartL.Value,
      pkt_PMethod, pkt_StartA, pkt_N, pkt_Lx, pkt_Ly, pkt_Lmax, pkt_NameKind1,
      pkt_NameKind2, pkt_N, MapperFm.KnotAreadY.Value, MapperFm.KnotAreadX.Value -1E-10,
      pkt_Drop, MapFm.KnotAreaName.Text, MapFm.InvAreaOrder.Checked,
      (MapFm.KnotsLTogether.Checked)and(MapFm.KnotNames.ItemIndex > 1),
      MapFm.KnotsLFrom.Value);


  if MapFm.NewKnotPanel.Visible then
     if length(KnotPoints) > KnotCount then
     begin
        //FKnotPickets.
        if length(KnotPoints) > 0 then
          GetKnotPickets(KnotPoints[length(KnotPoints)-1], false);
        MapFm.Label25.Caption := IntToStr(PktCount);
        MapFm.Label24.Caption := FKnotPickets.PktMethod.Items[KnotPoints[length(KnotPoints)-1].PMethod]
     end
      else
        MapFm.Label25.Caption := '-';
     
  
  SetLength(SelectedKnots, 0);
  MapFm.KnotSettings.Hide;
  if FKnotList <> nil then
    FKnotList.RefreshKnotList;
end;


procedure TMapFm.JumpToRoutesMap(N:Integer);
var xmax, ymax, xmin, ymin: real;
    i, j, k : integer;
begin
 if (FrameCount = 0) and (RouteCount = 0) then
 begin
    MapFm.Refreshbtn.Click;
    exit;
 end;

  xmax := Base[1].x;
  ymax := Base[1].y;
  xmin := Base[1].x;
  ymin := Base[1].y;

  RecomputeBaseObjects(WaitForZone);
// RecomputeRoutes(WaitForZone);
  RefreshSelectionArrays;

  if N <= -2 then
  if FrameCount > 0 then
  begin
     xmax := FramePoints[0,1].x;
     ymax := FramePoints[0,1].y;
     xmin := FramePoints[0,1].x;
     ymin := FramePoints[0,1].y;

     for j := 0 to FrameCount - 1 do
     Begin
        if FramePoints[j,1].x < xmin then
           xmin := FramePoints[j,1].x;
        if FramePoints[j,1].x > xmax then
           xmax := FramePoints[j,1].x;

        if FramePoints[j,1].y < ymin then
           ymin := FramePoints[j,1].y;
        if FramePoints[j,1].y > ymax then
           ymax := FramePoints[j,1].y;
     End;
  end;

  k := 0;
  if N >= 0  then
    K := N;

  if N <>-3 then
  if RouteCount > 0 then
  Begin
     xmax := Route[0].x1;
     ymax := Route[0].y1;
     xmin := Route[0].x1;
     ymin := Route[0].y1;

     if N < 0 then
     begin
       N := 0;
       K := RouteCount - 1;
     end
       else
       begin
         K := N;
       end;

     for I := N to K do
     Begin
       if I = N then
       begin
         xmax := Route[I].x1;
         ymax := Route[I].y1;
         xmin := Route[I].x1;
         ymin := Route[I].y1;
       end;

       for j := 0 to length(Route[i].WPT)- 1 do
       Begin
          if Route[i].WPT[j].x < xmin then
             xmin := Route[i].WPT[j].x;
          if Route[i].WPT[j].x > xmax then
             xmax := Route[i].WPT[j].x;

           if Route[i].WPT[j].y < ymin then
             ymin := Route[i].WPT[j].y;
          if Route[i].WPT[j].y > ymax then
             ymax := Route[i].WPT[j].y;
       End;
     End;
  End;

  Center.x := (xmin+xmax)/2;
  Center.y := (ymin+ymax)/2;

  I := 0;
  repeat
     inc(i);
     if abs(xmin-xmax) > abs(ymin-ymax) then
       J := trunc( abs(xmin-xmax) /TMashtab[I])
         else
          J := trunc( abs(ymin-ymax) /TMashtab[I])
  until (I >= MaxMashtab-1) or (J<= MapFm.Canv.Height div 100);
  Mashtab := I;

  if MapFm.NewKnotPanel.Visible then
  begin
    Center.y := Center.y + 50*TMashtab[Mashtab]/100;
  end;

  if OrderW.Visible then
  begin
    Center.x := Center.x + 100*TMashtab[Mashtab]/100;
  end;

  ShiftCenter.x := Center.x;
  ShiftCenter.y := Center.y;
end;

procedure TMapFm.ApplyKnotsClick(Sender: TObject);
begin
 if not FKnotPickets.Inited then
 begin
   KnotPts.Click;
 end;

 DoDoKnots;
 KnotCount := length(KnotPoints);
 NewKnotPanel.Visible := false;
 NewKnotPanel2.Visible := false;
 NewKnotPanel3.Visible := false;
 NewKnotPanel4.Visible := false;

 ModeButtons;

 if KnotCount > 0  then
 begin
   FKnotList.Show;
   FKnotList.Left := Left + Width - FKnotList.Width;
   FKnotList.Top  := Top  + ClientHeight - Stats.Height - FKnotList.Height;
 end
     else
     begin
      ClickMode := 1;
      ModeButtons;
     end;

 NewKnotPanel.Visible := false;
 NewKnotPanel2.Visible := false;
 NewKnotPanel3.Visible := false;
 NewKnotPanel4.Visible := false;
 KillNewKnots;

 FKnotList.RefreshKnotList;
 FKnotList.AllKnots.ClearSelection;
 FKnotList.AllKnots.OnClick(nil);
 SaveCtrlZ;
end;

procedure TMapFm.AppOnMessage(var MSG: TMsg; var Handled: Boolean);
begin
  if not MapFm.Active then
    exit;

  if not Timer.Enabled then
    exit;

  if (Step.Focused) or (Num0.Focused) or (Deg.Focused) or (MinShift.Focused) or
     (imiRandom.Focused) or (imiStep.Focused) or (imiRad.Focused) or
     (EdWin.TreeView1.Focused) or (Movep.StpEd.Focused) or (RouteBox.Focused) or
     (MinL.Focused) or (GZoom.Focused) or (GStyle.Focused)  or (YZoom.Focused) or
     (YStyle.Focused) or (YLang.Focused) or (RouteBox2.Focused) or
     (KnotRoutes.Focused)or (MarkerList.AllMarks.Focused) or (KnotSize.Focused) or
     (KnotNames.Focused) or (KnotAng.Focused) or (KnotAngRoute.Focused) or
     (KnotAngOwn.Focused)  or (KnotStep.Focused)  or (KnotStart.Focused) or
     (SetKnName.Focused) or (SetKnAng.Focused) or (SetKnNameKind.Focused) or
     (SetKnL.Focused) or (SetKnSize.Focused) or (SetKnSize2.Focused) or (KnotStartL.Focused) or
     (KnotAreaStepX.Focused) or (KnotAreaStepY.Focused) or
     (KnotAreaAngle.Focused) or (KnotAreaRadius.Focused) or
     (KnotAreadX.Focused) or (KnotAreadY.Focused) or (KnotAreaOrder.Focused) or
     (KnotAreaName.Focused) or (KnotsLFrom.Focused) or (SetSStep.Focused)
     then
    exit;

  if MSG.message = WM_MOUSEWHEEL then
  Begin
    Handled := true;
    Perform(WM_MOUSEWHEEL,MSG.wParam,0);
  End;

   if MSG.message = WM_KEYDOWN then
  Begin
    Handled := true;
    Perform(WM_KEYDOWN,MSG.wParam,0);
  End;
end;

procedure TMapFm.CanvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var j: Integer;
    NeedReset: Boolean;
begin
  MultiSelectMode := 0;

  if Timer.Enabled = false then
      exit;

  if (x > ScaleLineBounds.Left )and(x < ScaleLineBounds.Right ) then
  if (y > ScaleLineBounds.Top)and(y < ScaleLineBounds.Bottom) then
  begin
    CustomScale;
    Exit;
  end;


  if (NDalpha >0) then
  if (sqrt(sqr(X - NordDirectionXY.X)
          +sqr(Y - NordDirectionXY.Y)) <
      NordDirectionR ) then
  begin
    if Button = mbRight then
        CustomFi
    else
       _Fi := 0;
    Exit;
  end;


  MShift.X := x ;
  MShift.Y := y ;
  CanvMoveOnly := false;
  CanvMove := 0;

  Canv.SetFocus();

  case ClickMode of
     21: Begin /// ALL FRAME
          NeedReset := true;

          if FrameUnderMouse(MouseSenseZone) then
             if AlreadySelected then
              Begin
                 ShiftMode := true;
                 NeedReset := false;
              End
                else
                Begin
                  SelectedFramePointsCount := 0;
                  for j := 0 to FrameCount - 1 do
                    if j < length(SelectedFramePoints) then
                    Begin
                      SelectedFramePoints[j] := true;
                      Inc(SelectedFramePointsCount);
                    End;
                   ShiftMode := false;
                   NeedReset := false;
                End;

          {for I := 1 to FrameCount - 1 do
          Begin
            P1 := MapToScreen(FramePoints[i-1,1].x,FramePoints[i-1,1].y);
            P2 := MapToScreen(FramePoints[i,1].x,FramePoints[i,1].y);

            PD := GetPosAndDist(P1.X, P1.Y, P2.X, P2.Y, CanvCursor.x,CanvCursor.y) ;

            if (PD.Pos > 0) and (PD.Pos <= 1) then
            if PD.Dist < MouseSenseZone/2 then
            begin
              if (SelectedFramePoints[i-1] = true) and (SelectedFramePoints[i] = true) then
              Begin
                 ShiftMode := true;
                 NeedReset := false;
              End
                else
                Begin
                  SelectedFramePointsCount := 0;
                  for j := 0 to FrameCount - 1 do
                    if j < length(SelectedFramePoints) then
                    Begin
                      SelectedFramePoints[j] := true;
                      Inc(SelectedFramePointsCount);
                    End;
                   ShiftMode := false;
                   NeedReset := false;
                End;
              break;
            end;
          End;       }

          if NeedReset then
             RefreshSelectionArrays;

     End;

     22, 23, 24, 30, 31:
     Begin  /// FRAME POINTS
        if (ssShift in Shift)or(not m1.Flat) then
         MultiSelectMode := 1
          else
            if (ssCtrl in Shift)or(not m2.Flat) then
              MultiSelectMode := 2
              else
               if (ssAlt in Shift)or(not m3.Flat) then
                  MultiSelectMode := 3;

            if MultiSelectMode = 1 then
                RefreshSelectionArrays;

            {if ClickMode = 30 then
            begin
              if MultiSelectMode = 0 then
               SetLength(SelectedKnots, 0);

            end;}
               
            if MultiSelectMode > 0 then
            Begin
              CanvCursorBL0 := CanvCursorBL;
              SubCursor := MultiSelectMode;       
            End
              Else
               if (SubCursor=-3)or(SubCursor=-5)or(SubCursor=-6) then
                  ShiftMode := True;

     End;

     41:
     if RouteBox2.ItemIndex > 0 then  
     begin //// RoutesAdd
        if (ssCtrl in Shift)or(ssShift in Shift)or(not m2.Flat) then
           MultiSelectMode := 2
              else
               if (ssAlt in Shift)or(not m3.Flat) then
                  MultiSelectMode := 3;

         if MultiSelectMode > 0 then
            Begin
              CanvCursorBL0 := CanvCursorBL;
              SubCursor := MultiSelectMode;
            End
     end;

     29: /// scissors
     begin
       if CutMode = 2 then
          CutMode := CutMode + CuttingPointUnderMouse(MouseSenseZone);
     end;

     50: begin
      if (ssLeft in Shift)or(Button = mbLeft) then
      Begin
        if (ssCtrl in Shift) or (ssShift in Shift)or( m2.Flat = false ) then
        Begin
          GoogleMultiAdd := true;
          GoogleMultiAddMode := true;
          GoogleMultiAddBegin := CanvCursorBL;
          GoogleMultiAddEnd := CanvCursorBL;
        End;

        if  (ssAlt in Shift) or ( m3.Flat = false ) then
        Begin
          GoogleMultiAdd := true;
          GoogleMultiAddMode := false;
          GoogleMultiAddBegin := CanvCursorBL;
          GoogleMultiAddEnd:= CanvCursorBL;
        End;
      End;
    end;

    51: begin
      if (ssLeft in Shift)or(Button = mbLeft) then
      Begin
        if (ssCtrl in Shift) or (ssShift in Shift)or( m2.Flat = false ) then
        Begin
          YandexMultiAdd := true;
          YandexMultiAddMode := true;
          YandexMultiAddBegin := CanvCursorBL;
          YandexMultiAddEnd := CanvCursorBL;
        End;

        if  (ssAlt in Shift) or ( m3.Flat = false ) then
        Begin
          YandexMultiAdd := true;
          YandexMultiAddMode := false;
          YandexMultiAddBegin := CanvCursorBL;
          YandexMultiAddEnd:= CanvCursorBL;
        End;
      End;
    end;
  end;


 // GoogleMultiAdd := false;

  case PC.ActivePageIndex of
    0: begin


      {  if (ClickMode = 2) then
        begin
          ClickMode := 1;
          SetBaseBL(CanvCursorBL.Lat, CanvCursorBL.Long);
          ModeButtons;
        end;
       WaitForCenter := false;
       A := CanvCursorBL;
       B := BLToMap(A.lat, A.long);
       A := MapToBL(B.X, B.y);
       SetBaseBL(A.Lat, A.Long);}
    end;


  end;
end;

procedure TMapFm.CanvMouseLeave(Sender: TObject);
begin
  SubCursor := -1;
end;

const CanvMoveMax = 25;
var SelMode : Integer = 0; /// 0 - None; 1 - SelectionFrame; 2 - MovePoints

procedure TMapFm.CanvMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var P2 : TMyPoint;
    I, J: Integer;
begin

   if Timer.Enabled = false then
      exit;

   MapFm.SetFocus;
   SubCursor := -1;
   HasDropPoint := false;

   CanvCursor.X  := x;
   CanvCursor.Y  := y;
   CanvCursorBL := ScreenToBL(CanvCursor.X,CanvCursor.Y);

   if (ssLeft in Shift) and (ssShift in Shift) and (ssCtrl in Shift) then
   begin
      _fi := _fi - pi*(MShift.X-x)/400 ;

      MShift.X := x ;
      MShift.Y := y ;
      exit;
   end;

   if ((ClickMode <= 6)and(ssLeft in Shift)) or (ssMiddle in Shift)
      or ((ClickMode=10)and(ssLeft in Shift)and(SelMode=0)) then
         begin
            if MShift.X <> - 1000 then
            Begin

              Center.x := Center.x - ( x - MShift.X ) * Scale *Cos(Fi)
                                   - ( y - MShift.Y ) * Scale *Sin(Fi);
              Center.y := Center.y + ( y - MShift.Y ) * Scale *Cos(Fi)
                                   - ( x - MShift.x ) * Scale *Sin(Fi);

              if {(PC.ActivePageIndex = 1)and}(ssLeft in Shift) then
              begin
                if not CanvMoveOnly then
                   CanvMove := CanvMove + abs(x - MShift.X)+abs(y - MShift.Y);
                if CanvMove > CanvMoveMax then
                  CanvMoveOnly := true;
                  
                
              end;
              SubCursor := 0;
              MShift.X := x ;
              MShift.Y := y ;
            End;
        end;                                                                    

     if ((ClickMode = 10)or(ClickMode >20)or(ClickMode <= 30))and(ClickMode<>50)and(ClickMode<>51) then
         begin

            if(((ssLeft in Shift)and(CanvMoveOnly)) or (ssMiddle in Shift))
               and(ShiftMode = false) and (MultiSelectMode = 0) then
            begin
              Center.x := Center.x - ( x - MShift.X ) * Scale *Cos(Fi)
                                   - ( y - MShift.Y ) * Scale *Sin(Fi);
              Center.y := Center.y + ( y - MShift.Y ) * Scale *Cos(Fi)
                                   - ( x - MShift.x ) * Scale *Sin(Fi);
            end;

            if (ssLeft in Shift) and (ShiftMode = false) and (MultiSelectMode = 0) then
            begin
              if not CanvMoveOnly then
                 CanvMove := CanvMove + abs(x - MShift.X)+abs(y - MShift.Y);
              if CanvMove > CanvMoveMax then
              begin
                 CanvMoveOnly := true;
                 SubCursor := 0;
              end;
            end;

            if (ShiftMode = false) then
            Begin
              MShift.X := x ;
              MShift.Y := y ;
            End;
        end;

   
   case ClickMode of
     0 : SubCursor := 0;

     30: Begin
       if MultiSelectMode > 0 then
          SubCursor := MultiSelectMode;

       /// 16-08-21
       if ShiftMode then
       Begin
          SubCursor := -7;
          for I := 0 to Length(SelectedKnots)-1 do
          Try
              KnotPoints[SelectedKnots[I]].Cx := KnotPoints[SelectedKnots[I]].Cx
                  + ( x - MShift.X ) * Scale *Cos(Fi) + ( y - MShift.Y ) * Scale *Sin(Fi);

              KnotPoints[SelectedKnots[I]].Cy := KnotPoints[SelectedKnots[I]].Cy
                  - ( y - MShift.Y ) * Scale *Cos(Fi)+ ( x - MShift.x ) * Scale *Sin(Fi);
          Except
          End;
          MShift.X := x ;
          MShift.Y := y ;

        End
         else
          Begin
            if KnotsUnderMouse(MouseSenseZone div 2) then
                 SubCursor := -6;   
          End;


     End;

     31: Begin
       if MultiSelectMode > 0 then
          SubCursor := MultiSelectMode;


       if ShiftMode then
       Begin
          SubCursor := -7;
          for I := 0 to Length(SelectedMarkers)-1 do
          Try
              Markers[SelectedMarkers[I]].x := Markers[SelectedMarkers[I]].x
                  + ( x - MShift.X ) * Scale *Cos(Fi) + ( y - MShift.Y ) * Scale *Sin(Fi);

              Markers[SelectedMarkers[I]].y := Markers[SelectedMarkers[I]].y
                  - ( y - MShift.Y ) * Scale *Cos(Fi)+ ( x - MShift.x ) * Scale *Sin(Fi);
          Except
          End;
          MShift.X := x ;
          MShift.Y := y ;

          MarkersToGeo;
        End
         else
          Begin
            if MarkersUnderMouse(MouseSenseZone div 2) then
                 SubCursor := -6;
          End;


     End;

     29 : /// CUTTER
     Begin

       if CutMode <2 then
       Begin
          SubCursor := 4;

          P2 := ScreenToMap(CanvCursor.X, CanvCursor.Y);
          if (ssCtrl in Shift) or (M4.Flat = false) then
              P2 := DropPointToPoint(P2, MouseSenseZone*2, ClickMode);

          case CutMode of
            -1: begin
               CutMode := 0;
               CutPoints[1] := P2
            end;
            0: CutPoints[1] := P2;
            1: CutPoints[2] := P2;
          end;

          
       End;
       if CutMode >= 1 then
            GetCuttingPoints(RouteBox.ItemIndex-1, InfCut.Checked);

       if CutMode = 2 then
          if CuttingPointUnderMouse(MouseSenseZone) > 0 then
                SubCursor := -6;

       if CutMode >= 3 then
       begin
            CanvMoveOnly := false;
            ShiftMode := true;
            SubCursor := -7;

            CutPoints[CutMode-2].x := CutPoints[CutMode-2].x + ( x - MShift.X ) * Scale *Cos(Fi)
                                   + ( y - MShift.Y ) * Scale *Sin(Fi);
            CutPoints[CutMode-2].y := CutPoints[CutMode-2].y - ( y - MShift.Y ) * Scale *Cos(Fi)
                                   + ( x - MShift.x ) * Scale *Sin(Fi);

            MShift.X := x ;
            MShift.Y := y ;

       end;
     End;

     21: Begin /// ALL FRAME
        if ShiftMode then
        Begin
          SubCursor := -2;
          for I := 0 to FrameCount - 1 do
          Begin
              FramePoints[I,1].x := FramePoints[I,1].x + ( x - MShift.X ) * Scale *Cos(Fi)
                                   + ( y - MShift.Y ) * Scale *Sin(Fi);
              FramePoints[I,1].y := FramePoints[I,1].y - ( y - MShift.Y ) * Scale *Cos(Fi)
                                   + ( x - MShift.x ) * Scale *Sin(Fi);
          End;
          MShift.X := x ;
          MShift.Y := y ;

          FrameToGeo;
        End
         else
          Begin
            if length(SelectedFramePoints) > 0 then
            if (FrameUnderMouse(MouseSenseZone div 2))
               and (SelectedFramePoints[0] = true) then
                 SubCursor := -3;
          End;
     End;

     41: if MultiSelectMode > 0 then
              SubCursor := MultiSelectMode;

      23: Begin /// ROUTES
        if ShiftMode then
        Begin
          SubCursor := -4;
          for I := 0 to RouteCount - 1 do
          for J := 0 to Length(Route[I].WPT) - 1 do
          if length(SelectedRoutePoints) > I then
          if length(SelectedRoutePoints[I]) > J then
            if (SelectedRoutePoints[I][J] = true) then
            Begin
              Route[I].WPT[J].x := Route[I].WPT[J].x + ( x - MShift.X ) * Scale *Cos(Fi)
                                   + ( y - MShift.Y ) * Scale *Sin(Fi);
              Route[I].WPT[J].y := Route[I].WPT[J].y - ( y - MShift.Y ) * Scale *Cos(Fi)
                                   + ( x - MShift.x ) * Scale *Sin(Fi);
            End;
          MShift.X := x ;
          MShift.Y := y ;

          RoutesToGeo;
        End
         else
          Begin

            if MultiSelectMode > 0 then
            Begin
              SubCursor := MultiSelectMode;
            End;

            if SelectedRoutesCount > 0 then
             for I := 0 to RouteCount - 1 do
             try
                if (SelectedRoutePoints[I][0]) and (RouteUnderMouse(I,MouseSenseZone div 2)) then
                begin
                  SubCursor := -5;
                  break;
                end;

             except
             End;



     End;
      End;


     22: Begin     /// Frame points
        if ShiftMode then
        Begin
          for I := 0 to FrameCount - 1 do
          if length(SelectedFramePoints) > 0 then
            if (SelectedFramePoints[I] = true) then
          Begin
              FramePoints[I,1].x := FramePoints[I,1].x + ( x - MShift.X ) * Scale *Cos(Fi)
                                   + ( y - MShift.Y ) * Scale *Sin(Fi);
              FramePoints[I,1].y := FramePoints[I,1].y - ( y - MShift.Y ) * Scale *Cos(Fi)
                                   + ( x - MShift.x ) * Scale *Sin(Fi);
          End;
          MShift.X := x ;
          MShift.Y := y ;
          FrameToGeo;
          SubCursor := -2;
        End
           Else
        if MultiSelectMode > 0 then
        Begin
          SubCursor := MultiSelectMode;
        End;

     End;

     24: Begin     /// Route points
        if ShiftMode then
        Begin
          for I := 0 to RouteCount - 1 do
          for J := 0 to Length(Route[I].WPT) - 1 do
          if length(SelectedRoutePoints) > I then
          if length(SelectedRoutePoints[I]) > J then
            if (SelectedRoutePoints[I][J] = true) then
            Begin
              Route[I].WPT[J].x := Route[I].WPT[J].x + ( x - MShift.X ) * Scale *Cos(Fi)
                                   + ( y - MShift.Y ) * Scale *Sin(Fi);
              Route[I].WPT[J].y := Route[I].WPT[J].y - ( y - MShift.Y ) * Scale *Cos(Fi)
                                   + ( x - MShift.x ) * Scale *Sin(Fi);
            End;
          MShift.X := x ;
          MShift.Y := y ;
          FrameToGeo;
          SubCursor := -4;
        End
           Else
        if MultiSelectMode > 0 then
        Begin
          SubCursor := MultiSelectMode;
        End;


     End;
     25:
     Begin
        PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);
           if SubCursor <> 0 then
           Begin

              if FrameCount > 0 then
               Begin
                   if FrameCount < 1 then
                     FrameCount := 1;

                   FramePoints[FrameCount-1,2].x := CanvCursorBL.lat;
                   FramePoints[FrameCount-1,2].y := CanvCursorBL.long;

                   if (ssCtrl in Shift) or (M4.Flat = false) then
                   begin
                      P2 := BLToMap(CanvCursorBL);
                      P2 := DropPointToPoint(P2, MouseSenseZone*2, clickMode);
                      PointToAdd := P2;
                      FramePoints[FrameCount-1,1].x := P2.x;
                      FramePoints[FrameCount-1,1].y := P2.y;
                      FrameToGeo;
                   end;

                   RecomputeRoutes(WaitForZone);
                   RefreshSelectionArrays;

               End;


               SubCursor := 2;


               if FrameCount > 2 then
               Begin
                  P2 := BLToScreen(FramePoints[0,2].x,FramePoints[0,2].y);
                  if (abs(x - P2.x) < MouseSenseZone ) and (abs(y - P2.y) < MouseSenseZone ) then
                  begin
                    HasDropPoint := true;
                    DropPoint := ScreenToMap(P2.x, P2.Y);
                    PointToAdd := P2;
                    SubCursor := 5;
                  end;
               End;

           End;
     End;
     27:    ///////////////////////////////////////// ADD A FRAME POINT
     Begin
         if SubCursor <> 0 then
         Begin
              SubCursor := 2;
              PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);
              FindPointsForFrame(PointToAdd);

              if (ssCtrl in Shift) or (M4.Flat = false) then
                 PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode)
                  else
                  if (ssShift in Shift)or(M5.Flat = false) then
                  if FrameCount > 0 then
                  Begin
                     FindPointsForFrame(PointToAdd);
                     PointToAdd := DropPointToFrame(PointToAdd);
                  End;
         End;
     End;

     28:    ///////////////////////////////////////// ADD A ROUTE POINT
     Begin
         if SubCursor <> 0 then
         Begin
              SubCursor := 2;
              PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);
              FindPointsForRoutes(PointToAdd, RouteBox.ItemIndex - 1);
              
              if (ssShift in Shift)and(ssCtrl in Shift)or(M5.Flat = false) then
              Begin
                  FindPointsForFrame(PointToAdd);
                  PointToAdd := DropPointToFrame(PointToAdd);
                  FindPointsForRoutes(PointToAdd, RouteBox.ItemIndex - 1);
              End
               else
                if (ssCtrl in Shift) or (M4.Flat = false) then
                  PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode)
                  else
                    if (ssShift in Shift)or(M7.Flat = false) then
                       PointToAdd := DropPointToRoute(PointToAdd);

         End;
     End;

     26:  ///// new route
     Begin
         if SubCursor <> 0 then
         Begin
              SubCursor := 2;

              PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);

              if (ssCtrl in Shift) or (M4.Flat = false) then
                  PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode)
                     { else
                       if (ssShift in Shift)or(M7.Flat = false) then

                        Begin
                           FindPointsForRoutes(PointToAdd, RouteBox.ItemIndex - 1);
                           PointToAdd := DropPointToRoute(PointToAdd);
                        End   }

                          else
                           if (ssShift in Shift)or(M5.Flat = false) then
                           if FrameCount > 0 then
                           Begin
                             FindPointsForFrame(PointToAdd);

                             PointToAdd := DropPointToFrame(PointToAdd);
                           End;

                            

              Route[RouteCount-1].WPT[Length(Route[RouteCount-1].WPT)-1].x := PointToAdd.x;
              Route[RouteCount-1].WPT[Length(Route[RouteCount-1].WPT)-1].y := PointToAdd.y;

              if Length(Route[RouteCount-1].WPT) > 1 then
                if RoutePointUnderMouse(RouteCount-1, Length(Route[RouteCount-1].WPT)-2, MouseSenseZone ) then
                begin
                  HasDropPoint := true;
                  DropPoint := Route[RouteCount-1].WPT[Length(Route[RouteCount-1].WPT)-2];

                  SubCursor := 5;
                end;

         End;
     End;

       50: if (ssLeft in Shift) and (GoogleMultiAdd) then
         Begin
            GoogleMultiAdd := false;

            if (ssCtrl in Shift) or (ssShift in Shift) or( m2.Flat = false ) then
            Begin
              GoogleMultiAdd := true;
              GoogleMultiAddMode := true;
              GoogleMultiAddEnd := CanvCursorBL;
            End
             else
              if (ssAlt in Shift) or ( m3.Flat = false ) then
              Begin
                GoogleMultiAdd := true;
                GoogleMultiAddMode := false;
                GoogleMultiAddEnd := CanvCursorBL;
              End;
         End
           else
            if (ssLeft in Shift)or (ssMiddle in Shift)or(ssRight in Shift) then
            begin
              Center.x := Center.x - ( x - MShift.X ) * Scale *Cos(Fi)
                                   - ( y - MShift.Y ) * Scale *Sin(Fi);
              Center.y := Center.y + ( y - MShift.Y ) * Scale *Cos(Fi)
                                   - ( x - MShift.x ) * Scale *Sin(Fi);
              if (ssLeft in Shift) then
              begin
                if not CanvMoveOnly then
                   CanvMove := CanvMove + abs(x - MShift.X)+abs(y - MShift.Y);
                if CanvMove > CanvMoveMax then
                   CanvMoveOnly := true;
              end;

              MShift.X := x ;
              MShift.Y := y ;
           end;

      51: if (ssLeft in Shift) and (YandexMultiAdd) then
         Begin
            YandexMultiAdd := false;

            if (ssCtrl in Shift) or (ssShift in Shift) or( m2.Flat = false ) then
            Begin
              YandexMultiAdd := true;
              YandexMultiAddMode := true;
              YandexMultiAddEnd := CanvCursorBL;
            End
             else
              if (ssAlt in Shift) or ( m3.Flat = false ) then
              Begin
                YandexMultiAdd := true;
                YandexMultiAddMode := false;
                YandexMultiAddEnd := CanvCursorBL;
              End;
         End
           else
            if (ssLeft in Shift)or (ssMiddle in Shift)or(ssRight in Shift) then
            begin
              Center.x := Center.x - ( x - MShift.X ) * Scale *Cos(Fi)
                                   - ( y - MShift.Y ) * Scale *Sin(Fi);
              Center.y := Center.y + ( y - MShift.Y ) * Scale *Cos(Fi)
                                   - ( x - MShift.x ) * Scale *Sin(Fi);
              if (ssLeft in Shift) then
              begin
                if not CanvMoveOnly then
                   CanvMove := CanvMove + abs(x - MShift.X)+abs(y - MShift.Y);
                if CanvMove > CanvMoveMax then
                   CanvMoveOnly := true;
              end;

              MShift.X := x ;
              MShift.Y := y ;
           end;
      7: /// Ruler
       // if not CanvMoveOnly then
        begin

          PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);

          if (ssShift in Shift)and(ssCtrl in Shift)or(M5.Flat = false) then
          Begin
           FindPointsForFrame(PointToAdd);
           PointToAdd := DropPointToFrame(PointToAdd);
           FindPointsForRoutes(PointToAdd, - 1);
          End
          else
            if (ssCtrl in Shift) or (M4.Flat = false) then
            begin
               PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode);

               if RulerLoops then
                 PointToAdd := DropPointToLoop(PointToAdd, MouseSenseZone*2, ClickMode);
            end
               else
                 if (ssShift in Shift)or(M7.Flat = false) then
                 begin
                     FindPointsForRoutes(PointToAdd, - 1);
                     PointToAdd := DropPointToRoute(PointToAdd);
                 end;
        end;
   end;

   ShowCurPos;

   if RulPan.Visible then
      CurRulStat;
end;

procedure TMapFm.RefreshSt;
var I:integer;
Begin
  GCount.Text := IntToStr(GoogleCount);
  if GoogleCount>30 then
     GCount.Font.Color := clOlive
     else
     if GoogleCount>40 then
       GCount.Font.Color := clRed
        else
          GCount.Font.Color := clWindowText;

   for I := 0 to GZoom.Items.Count - 1 do
     if StrToFloat2(Gzoom.Items[I])= ZoomA then
         Gzoom.ItemIndex := I;

End;

procedure TMapFm.RefreshYSt;
var I:integer;
Begin
  YCount.Text := IntToStr(YandexCount);
  if YandexCount>30 then
     YCount.Font.Color := clOlive
     else
     if YandexCount>40 then
       YCount.Font.Color := clRed
        else
          YCount.Font.Color := clWindowText;

   for I := 0 to YZoom.Items.Count - 1 do
     if StrToFloat2(Yzoom.Items[I]) = YZoomA then
         Yzoom.ItemIndex := I;

End;


procedure TMapFm.PopupMarkerClick(Sender: TObject);
begin
 Timer.Enabled := false;
 try
   with Sender as TMenuItem do
   Begin
     MarkEd.PMode := 0;
     MarkEd.MarkN := SelectedMarkers[tag-1];
     MarkEd.Edit1.Text := Markers[SelectedMarkers[tag-1]].MarkerName;
     MarkEd.Edit2.Text := DegToDMS(Markers[SelectedMarkers[tag-1]].Gx, true, 4);
     MarkEd.Edit3.Text := DegToDMS(Markers[SelectedMarkers[tag-1]].Gy, false, 4);
     MarkEd.ShowModal;
     if MarkerList.Visible then
        MarkerList.RefreshList(false);
   End;
 finally
   SaveCtrlZ;
   Timer.Enabled :=true;
 end;

end;

procedure TMapFm.PopupMenu2Popup(Sender: TObject);
var    P1, P2: TMyPoint;
begin
   P1 := PointXY(CanvCursor.X - MouseSenseZone,CanvCursor.Y - MouseSenseZone);
   P2 := PointXY(CanvCursor.X + MouseSenseZone,CanvCursor.Y + MouseSenseZone);
   MouseMarkers(P1.x, P1.y, P2.x, P2.y, 10, 0);     {06-02-2022}
   MarkerListPopup;
end;

procedure TMapFm.PopupMenuItemsClick(Sender: TObject);
begin
   with Sender as TMenuItem do
    MapChoosed := ChoosedMaps[tag];
  B5d.Enabled := MapChoosed <>-1;
  B5d2.Enabled := MapChoosed <>-1;

end;



procedure TMapFm.B25Click(Sender: TObject);
var x,y : real;
begin
 if FrameCount > 0 then
   if MessageDlg(inf[26], mtConfirmation, [mbYes, mbNo], 0) <> 6 then
    exit;

 
 FrameGeo := true;
 FrameCount := 1;

 FramePoints[FrameCount-1,2].x := CanvCursorBL.Lat;
 FramePoints[FrameCount-1,2].y := CanvCursorBL.Long;


 Frame := true;

 ClickMode := 25;
 ModeButtons;

 RefreshSelectionArrays;

 {if RouteCount > 1 then
 Begin
    FramePoints[0,2].x := Route[0].Gx1;
    FramePoints[0,2].y := Route[0].Gy1;

    FramePoints[1,2].x := Route[0].Gx2;
    FramePoints[1,2].y := Route[0].Gy2;

    FramePoints[2,2].x := Route[RouteCount-1].Gx2;
    FramePoints[2,2].y := Route[RouteCount-1].Gy2;

    FramePoints[3,2].x := Route[RouteCount-1].Gx1;
    FramePoints[3,2].y := Route[RouteCount-1].Gy1;

    FramePoints[4,2] := FramePoints[0,2];
 End
  else
    Begin
      P := MapToBL(Center.x-Scale*100,Center.y-Scale*100);
      FramePoints[0,2].x := P.lat;
      FramePoints[0,2].y := P.long;

      P := MapToBL(Center.x+Scale*100,Center.y-Scale*100);
      FramePoints[1,2].x := P.lat;
      FramePoints[1,2].y := P.long;

      P := MapToBL(Center.x+Scale*100,Center.y+Scale*100);
      FramePoints[2,2].x := P.lat;
      FramePoints[2,2].y := P.long;

      P := MapToBL(Center.x-Scale*100,Center.y+Scale*100);
      FramePoints[3,2].x := P.lat;
      FramePoints[3,2].y := P.long;

      FramePoints[4,2] := FramePoints[0,2];
    End;   }

    

 // B21.Click;
  x := Center.x;
  y := Center.y;
  ReComputeRoutes({WaitForZone}False);
  RefreshSelectionArrays;
  Center.x := x;
  Center.y := y;
  EdWin.ReFreshTree;
  GetEdTools;
end;

procedure TMapFm.B26Click(Sender: TObject);
begin
  Timer.Enabled := false;
  Namer.Edit1.Text := Inf[28];
  Namer.ShowModal;

  if Namer.isOk then
  Begin
    AddRoute(Namer.Edit1.Text);
    ClickMode := 26;
    ModeButtons;
    RefreshRouteBox;
  End;

  Timer.Enabled := true;
end;

procedure TMapFm.AddPopupItems(var PopupMenu: TPopupMenu; ItmName:String);
var
  NewItem: TMenuItem;
begin
  NewItem := TMenuItem.Create(PopupMenu); // create the new item
  PopupMenu.Items.Add(NewItem);           // add it to the Popupmenu
  NewItem.Caption := ItmName;

  NewItem.Tag := PopupMenu.Items.Count-1;

  if PopupMenu = PopupMenu2 then
     NewItem.OnClick := PopupMarkerClick
     else
        NewItem.OnClick := PopupMenuItemsClick;// assign it an event handler}
end;

procedure TMapFm.CanvMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var SysCurPos :TPoint;
    I, j :Integer;
    P1, P2: TMyPoint;
begin
  if (Button = mbRight) and not (ssLeft in Shift) then
  case ClickMode of
    25: begin
           CanvCursor.X  := x;    CanvCursor.Y  := y;
           CanvCursorBL := ScreenToBL(CanvCursor.X,CanvCursor.Y);
           PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);
           if (ssCtrl in Shift) or (M4.Flat = false) then
           begin
                  P2 := ScreenToMap(CanvCursor.X,CanvCursor.Y);
                  P2 := DropPointToPoint(P2, MouseSenseZone*2, ClickMode);
                  PointToAdd := P2;
                  CanvCursorBL := MapToBL(P2.x,P2.y);
           end;
           CreateFramePoint(CanvCursorBL.lat, CanvCursorBL.long);

           MarkEd.PMode := 2;

           MarkEd.Edit2.Text := DegToDMS(CanvCursorBL.lat, true, 4);
           MarkEd.Edit3.Text := DegToDMS(CanvCursorBL.long, false, 4);

           Timer.Enabled := false;
           MarkEd.ShowModal;
           Timer.Enabled := true;
           if MarkEd.isOk then
           begin
             P2.X := StrToLatLon(MarkEd.Edit2.Text,true);
             P2.Y := StrToLatLon(MarkEd.Edit3.Text, false);
             P1 := BLToMap(P2.x, P2.y);

             FramePoints[FrameCount-1,1].x := P1.X;
             FramePoints[FrameCount-1,1].y := P1.Y;
             FramePoints[FrameCount-1,2].x := P2.X;
             FramePoints[FrameCount-1,2].y := P2.Y;

             if FrameCount > 1 then
             begin
               FramePoints[FrameCount-2, 1].x := P1.X;
               FramePoints[FrameCount-2, 1].y := P1.Y;
               FramePoints[FrameCount-2, 2].x := P2.X;
               FramePoints[FrameCount-2, 2].y := P2.Y;
             end;

             WaitForZone := (RouteCount = 0) and (FrameCount < 3);

             RecomputeRoutes(WaitForZone);

             Center.x := FramePoints[FrameCount-1,1].X;
             Center.y := FramePoints[FrameCount-1,1].Y;

             SaveCtrlZ;
           end;

           EdWin.RefreshTree;
           if RulCreatingLines then
               RulStat;
    end;
    26: begin
         PointToAdd := ScreenToMap(CanvCursor.X, CanvCursor.Y);
         PointToAddNum := Length(Route[RouteCount-1].WPT) - 1;
         if (ssCtrl in Shift) or (M4.Flat = false) then
         begin
           PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode);
           CanvCursorBL := MapToBL(PointToAdd.x,PointToAdd.y);
         end
         else
           if (ssShift in Shift)or(M7.Flat = false) then
           if FrameCount > 0 then
           Begin
              FindPointsForFrame(PointToAdd);
              PointToAdd := DropPointToFrame(PointToAdd);
              CanvCursorBL := MapToBL(PointToAdd.x,PointToAdd.y);
           End;

         MarkEd.PMode := 2;
         MarkEd.Edit2.Text := DegToDMS(CanvCursorBL.lat, true, 4);
         MarkEd.Edit3.Text := DegToDMS(CanvCursorBL.long, false, 4);

         Timer.Enabled := false;
         MarkEd.ShowModal;
         Timer.Enabled := true;
         PointToAddNum := Length(Route[RouteCount-1].WPT)-1;
         if MarkEd.isOk then
         begin
           P2.X := StrToLatLon(MarkEd.Edit2.Text, true);
           P2.Y := StrToLatLon(MarkEd.Edit3.Text, false);
           P1 := BLToMap(P2.x, P2.y);

           AddPointToRoute(RouteCount-1);

           Route[RouteCount-1].GWPT[length(Route[RouteCount-1].GWPT)-1].x := P2.x;
           Route[RouteCount-1].GWPT[length(Route[RouteCount-1].GWPT)-1].y := P2.y;
           Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-1].x   := P1.x;
           Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-1].y   := P1.y;

           if length(Route[RouteCount-1].WPT) > 1 then
           begin
             Route[RouteCount-1].GWPT[length(Route[RouteCount-1].GWPT)-2].x := P2.x;
             Route[RouteCount-1].GWPT[length(Route[RouteCount-1].GWPT)-2].y := P2.y;
             Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-2].x  := P1.X;
             Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-2].y  := P1.Y;
           end;

           WaitForZone := (RouteCount = 1) and
                          (length(Route[RouteCount-1].WPT) < 3);

           RecomputeRoutes(WaitForZone);

           Center.x := Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-1].X;
           Center.y := Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-1].Y;
           SaveCtrlZ;
         end;

         EdWin.ReFreshTree;
         if RulCreatingLines then
           RulStat;
    end;
    29: if (not CanvMoveOnly)and (not ShiftMode)  then
        begin
         I := -1;
         if CutMode = 0 then
         begin
            P2 := ScreenToMap(CanvCursor.X, CanvCursor.Y);
            if (ssCtrl in Shift) or (M4.Flat = false) then
            begin
              P2 := DropPointToPoint(P2, MouseSenseZone*2, ClickMode);
              CanvCursorBL := MapToBL(P2.x,P2.y)
            end;
            I := 1;
            CutPoints[1] := P2;
            CutMode := 1;
         end
         else
          if CutMode = 1 then
          begin
            P2 := ScreenToMap(CanvCursor.X, CanvCursor.Y);
            if (ssCtrl in Shift) or (M4.Flat = false) then
            begin
              P2 := DropPointToPoint(P2, MouseSenseZone*2, ClickMode);
              CanvCursorBL := MapToBL(P2.x,P2.y)
            end;
            CutPoints[2] := P2;
            I := 2;
            CutPan.Visible := true;
            CutMode := 2;
            GetCuttingPoints(RouteBox.ItemIndex-1, InfCut.Checked);
          end;

          if I<>-1 then
          Begin
            MarkEd.PMode := 2;
            MarkEd.Edit2.Text := DegToDMS(CanvCursorBL.lat, true, 4);
            MarkEd.Edit3.Text := DegToDMS(CanvCursorBL.long, false, 4);

            Timer.Enabled := false;
            MarkEd.ShowModal;
            Timer.Enabled := true;

            if MarkEd.isOk then
            begin
              P2.X := StrToLatLon(MarkEd.Edit2.Text, true);
              P2.Y := StrToLatLon(MarkEd.Edit3.Text, false);
              P1 := BLToMap(P2.x, P2.y);
              CutPoints[I] := P1;

             // Center.x := Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-1].X;
             // Center.y := Route[RouteCount-1].WPT[length(Route[RouteCount-1].WPT)-1].Y;
            end
            else dec(CutMode)
          End;

    end;
  end;


  if (ssRight in Shift) or (Button = mbRight) then
    exit;

  if Timer.Enabled = false then
      exit;

  {if _Fi<> 0 then
     if (X > Canv.Width-100) and (Y<100) then
     begin
       _Fi := 0;
       exit;
     end;}

  if PC.ActivePageIndex = 1 then
  Begin
    if CanvMoveOnly then
       exit;
    if (ssLeft in Shift)or(Button = mbLeft) then
    Begin
      if FrameCount > 0 then
      Begin
        J := SelectFrameSide(CanvCursor.X, CanvCursor.Y);
        for I := 1 to J - 1 do
          RotateFrameOrder(True);

      End;
    End;
   // GoogleMultiAdd := false;
    RefreshST;  RefreshYST;
  End;


  if ClickMode = 50 then      // GOOOGLE1
  Begin
    if CanvMoveOnly then
       exit;
    if (ssLeft in Shift)or(Button = mbLeft) then
    Begin
      if (ssCtrl in Shift) or (ssShift in Shift) or( m2.Flat = false ) then
      Begin
        GoogleMultiAdd := true;
        GoogleMultiAddMode := true;
        GoogleMultiAddEnd := CanvCursorBL;
        DoMultiAddGoogle;
      End
      else
        if  (ssAlt in Shift) or ( m3.Flat = false ) then
        Begin
          GoogleMultiAdd := true;
          GoogleMultiAddMode := false;
          GoogleMultiAddEnd := CanvCursorBL;
          DoMultiAddGoogle;
        End
         else
          AddGoogle(GoogleCursor.lat, GoogleCursor.long);
    End;
   // GoogleMultiAdd := false;
    RefreshST;   RefreshYST;
  End;

 


  if ClickMode = 51 then      // Yandex
  Begin
    if CanvMoveOnly then
       exit;
    if (ssLeft in Shift)or(Button = mbLeft) then
    Begin
      if (ssCtrl in Shift) or (ssShift in Shift) or( m2.Flat = false ) then
      Begin
        YandexMultiAdd := true;
        YandexMultiAddMode := true;
        YandexMultiAddEnd := CanvCursorBL;
        DoMultiAddYandex;
      End
      else
        if  (ssAlt in Shift) or ( m3.Flat = false ) then
        Begin
          YandexMultiAdd := true;
          YandexMultiAddMode := false;
          YandexMultiAddEnd := CanvCursorBL;
          DoMultiAddYandex;
        End
         else
          AddYandex(YandexCursor.lat, YandexCursor.long);
    End;
   // GoogleMultiAdd := false;
    RefreshST;   RefreshYST;
  End;

    if (ClickMode = 5) or (ClickMode=6) then
    if  not CanvMoveOnly then
    Begin
     if Button = mbLeft then
      GetMapsUnderPoint(CanvCursorBL.lat, CanvCursorBL.long);

     if Length(ChoosedMaps)>1 then
     Begin
       GetCursorPos(SysCurPos);
       PopupMenu3.Items.Clear;
       for I := 0 to Length(ChoosedMaps) - 1 do
         AddPopupItems(PopupMenu3,ChoosedMapsInfo[I]);

       PopupMenu3.Popup(SysCurPos.X, SysCurPos.Y);
     End;

       B5d.Enabled  := Length(ChoosedMaps)=1;
       B5d2.Enabled := Length(ChoosedMaps)=1;
    End;


   case ClickMode of
     29 : /// CUTTER
     Begin
       if CutMode < 2 then
          SubCursor := 4;

       if (not CanvMoveOnly)and (not ShiftMode)  then
       begin
         if CutMode = 0 then
         begin
            P2 := ScreenToMap(CanvCursor.X, CanvCursor.Y);
            if (ssCtrl in Shift) or (M4.Flat = false) then
              P2 := DropPointToPoint(P2, MouseSenseZone*2, ClickMode);

            CutPoints[1] := P2;
            CutMode := 1;
         end
         else
          if CutMode = 1 then
          begin
            P2 := ScreenToMap(CanvCursor.X, CanvCursor.Y);
            if (ssCtrl in Shift) or (M4.Flat = false) then
              P2 := DropPointToPoint(P2, MouseSenseZone*2, ClickMode);
            CutPoints[2] := P2;
            CutPan.Visible := true;
            CutMode := 2;
            GetCuttingPoints(RouteBox.ItemIndex-1, InfCut.Checked);
          end;
       end;
       
       if CutMode >= 3 then
       begin
            CutMode := 2;
            SubCursor := -6;
            MShift.X := x ;
            MShift.Y := y ;
       end;
     End;

     40: /// TRACK VIEW
        if not CanvMoveOnly then
           ChoosedTrackPoint := ViewTrackPoint;
     21: Begin /// ALL FRAME
        if frameCount > 1 then
        SaveCtrlZ;
     End;

     41:

       case MultiSelectMode of
         2: if RouteBox2.ItemIndex > 0 then
              SelectedPointsToRoute(MainTrack,RouteBox2.ItemIndex-1);
         3: if RouteBox2.ItemIndex > 0 then
               SelectedPointsToRoute(MainTrack, -1);
       else
       if not CanvMoveOnly then
           ChoosedTrackPoint := ViewTrackPoint;
       end;


     22: Begin ///  FRAME POINTS
        if MultiSelectMode > 0 then
           SelectFramePoints(CanvCursorBL0, CanvCursorBL, MultiSelectMode = 3)
             else
             if (not CanvMoveOnly)and (not ShiftMode)  then
             begin

                if not( (ssShift in Shift)
                    or (ssCtrl in Shift)
                    or (ssAlt in Shift) )  then

                        RefreshSelectionArrays;
                SelectFramePoints(CanvCursorBL, (MultiSelectMode = 3))
             end;
     End;

     23: Begin ///  ROUTES
        if MultiSelectMode > 0 then
        begin
           SelectRoutes(CanvCursorBL0, CanvCursorBL, MultiSelectMode = 3);
           RefreshRouteBox;
           if SelectedRoutesCount = 1 then
             RouteBox.ItemIndex := SelectedRouteN  + 1
                  else
                    RouteBox.ItemIndex := 0;

        end
             else
             if (not CanvMoveOnly)and (not ShiftMode)  then
             begin
             
                if not( (ssShift in Shift)
                    or (ssCtrl in Shift)
                    or (ssAlt in Shift) )  then
                     
                        RefreshSelectionArrays;
                 SelectRoutes(CanvCursorBL, (MultiSelectMode = 3));
                 RefreshRouteBox;
                 if SelectedRoutesCount = 1 then
                    RouteBox.ItemIndex := SelectedRouteN+1
                      else
                        RouteBox.ItemIndex := 0;
             end;
     End;

     24: Begin ///  Route POINTS
        if RouteCount = 0 then
           exit;
        if MultiSelectMode > 0 then
           SelectRoutesPoints(CanvCursorBL0, CanvCursorBL, MultiSelectMode = 3,
                              RouteBox.ItemIndex - 1)
             else
             if (not CanvMoveOnly)and (not ShiftMode)  then
             begin
             
                if not( (ssShift in Shift)
                    or (ssCtrl in Shift)
                    or (ssAlt in Shift) )  then
                     
                        RefreshSelectionArrays;
                SelectRoutesPoints(CanvCursorBL, (MultiSelectMode = 3), RouteBox.ItemIndex - 1)
             end;
     End;


     25: Begin   ////// CREATE FRAME
        

        if SubCursor = 2 then
        Begin
           CanvCursor.X  := x;
           CanvCursor.Y  := y;
           CanvCursorBL := ScreenToBL(CanvCursor.X,CanvCursor.Y);
           PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);
           if (ssCtrl in Shift) or (M4.Flat = false) then
           begin
                  P2 := ScreenToMap(CanvCursor.X,CanvCursor.Y);
                  P2 := DropPointToPoint(P2, MouseSenseZone*2, ClickMode);
                  PointToAdd := P2;
                  CanvCursorBL := MapToBL(P2.x,P2.y);
           end;
           CreateFramePoint(CanvCursorBL.lat, CanvCursorBL.long);

           SaveCtrlZ;
           EdWin.RefreshTree;
        End
         Else
         if SuBCursor = 5 then
           if FrameCount>2 then
            Begin
             CreateFramePoint(FramePoints[0,2].x, FramePoints[0,2].y);
             Dec(FrameCount);
             RecomputeRoutes(False);
             RefreshSelectionArrays;
             ClickMode := 21;
             ModeButtons;
             EdWin.ReFreshTree;
             SaveCtrlZ;
            End;

         if RulCreatingLines then
             RulStat;
     End;

     26 :      //// create route
     Begin

          PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);

          PointToAddNum := Length(Route[RouteCount-1].WPT)-1;
         // FindPontsForFrame(PointToAdd);

               if (ssCtrl in Shift) or (M4.Flat = false) then
                  PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode)
                     else
                        if (ssShift in Shift)or(M7.Flat = false) then
                        if FrameCount > 0 then
                        Begin
                           FindPointsForFrame(PointToAdd);
                           PointToAdd := DropPointToFrame(PointToAdd);
                        End;
                        { else
                           if (ssAlt in Shift) or (M7.Flat = false) then
                           Begin
                              FindPointsForRoutes(PointToAdd, RouteBox.ItemIndex - 1);
                              PointToAdd := DropPointToRoute(PointToAdd);
                           End;      }

        ///  if (ssShift in Shift)or(M5.Flat = false) then
        //    PointToAdd := DropPointToFrame(PointToAdd);
         PointToAddNum := Length(Route[RouteCount-1].WPT)-1;
         if SubCursor = 2 then
            AddPointToRoute(RouteCount-1)
             else
               if SubCursor = 5 then
                begin
                  DeleteRoutePoint(RouteCount-1,Length(Route[RouteCount-1].WPT)-1);
                  ClickMode := 23;
                  ModeButtons;
                  RefreshRouteBox;
                end;

          SaveCtrlZ;
          EdWin.ReFreshTree;

          if RulCreatingLines then
             RulStat;
     End;

     27 : if SubCursor <> 0 then
     if FrameCount >1 then
     Begin

          PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);
          FindPointsForFrame(PointToAdd);

            if (ssCtrl in Shift) or (M4.Flat = false) then
               PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode)
                  else
                  if (ssShift in Shift)or(M5.Flat = false) then
                     PointToAdd := DropPointToFrame(PointToAdd);

          AddPointToFrame;
          SaveCtrlZ;
          EdWin.ReFreshTree;
     End;

     28:    ///////////////////////////////////////// ADD A ROUTE POINT
     Begin
         if RouteCount = 0 then
           exit;
           
         if SubCursor <> 0 then
         Begin
              SubCursor := 2;
              PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);
              FindPointsForRoutes(PointToAdd, RouteBox.ItemIndex - 1);

              if (ssShift in Shift)and(ssCtrl in Shift)or(M5.Flat = false) then
              Begin
                  FindPointsForFrame(PointToAdd);
                  PointToAdd := DropPointToFrame(PointToAdd);
                  FindPointsForRoutes(PointToAdd, RouteBox.ItemIndex - 1);
              End
               else
                if (ssCtrl in Shift) or (M4.Flat = false) then
                  PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode)
                  else
                    if (ssShift in Shift)or(M7.Flat = false) then
                       PointToAdd := DropPointToRoute(PointToAdd);


              {if (ssCtrl in Shift) or (M4.Flat = false) then
                PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode)
                  else
                  if (ssShift in Shift)or(M7.Flat = false) then
                     PointToAdd := DropPointToRoute(PointToAdd)
                      else
                           if (ssAlt in Shift)or(M5.Flat = false) then
                           Begin
                              FindPointsForFrame(PointToAdd);
                              PointToAdd := DropPointToFrame(PointToAdd);
                           End; }

         AddPointToRoute(PointToAddRouteNum);
         SaveCtrlZ;
         EdWin.ReFreshTree;
         End;
     End;

     7: /// Ruler
        if not CanvMoveOnly then
        begin

        PointToAdd := ScreenToMap(CanvCursor.X,CanvCursor.Y);

        if (ssShift in Shift)and(ssCtrl in Shift)or(M5.Flat = false) then
        Begin
           FindPointsForFrame(PointToAdd);
           PointToAdd := DropPointToFrame(PointToAdd);
           FindPointsForRoutes(PointToAdd, - 1);
        End
          else
            if (ssCtrl in Shift) or (M4.Flat = false) then
            begin
               PointToAdd := DropPointToPoint(PointToAdd, MouseSenseZone*2, ClickMode);
               if RulerLoops then
                 PointToAdd := DropPointToLoop(PointToAdd, MouseSenseZone*2, ClickMode);
            end
               else
                 if (ssShift in Shift)or(M7.Flat = false) then
                 begin
                     FindPointsForRoutes(PointToAdd, - 1);
                     PointToAdd := DropPointToRoute(PointToAdd);
                 end;

        AddRulerPoint(PointToAdd.x, PointToAdd.y);
        RulStat;
     end;

     30:  /// Knots
      if not CanvMoveOnly then
      try
        if MultiSelectMode = 0 then
        begin
          P1 := PointXY(CanvCursor.X - MouseSenseZone/2,CanvCursor.Y - MouseSenseZone/2);
          P2 := PointXY(CanvCursor.X + MouseSenseZone/2,CanvCursor.Y + MouseSenseZone/2);
          MouseKnots(P1.x, P1.y, P2.x, P2.y, MaxInt, 0);
        end
         else
         begin
           P1 := BLToScreen(CanvCursorBL0.lat, CanvCursorBL0.long);
           P2 := BLToScreen(CanvCursorBL.lat, CanvCursorBL.long);
           MouseKnots(P1.x, P1.y, P2.x, P2.y, MaxInt, MultiSelectMode);
         end;

        if FKnotList <> nil then
          FKnotList.ResetKnotList;

        //MouseKnots(P1.x, P1.y, P2.x, P2.y, MaxInt, j);

        for I := 0 to Length(SelectedKnots) - 1 do
          FKnotList.AllKnots.Selected[SelectedKnots[I]] := True;

        if FKnotList <> nil then
        if Length(SelectedKnots) > 0 then
          FKnotList.RefreshKnotList;
       // if  Length(SelectedKnots)= 0 then


        FKnotList.AllKnots.OnClick(nil);

      except
      end;

      31: // Markers
      if not CanvMoveOnly then
      try
         if MultiSelectMode = 0 then
        begin
          P1 := PointXY(CanvCursor.X - MouseSenseZone/2,CanvCursor.Y - MouseSenseZone/2);
          P2 := PointXY(CanvCursor.X + MouseSenseZone/2,CanvCursor.Y + MouseSenseZone/2);
          MouseMarkers(P1.x, P1.y, P2.x, P2.y, MaxInt, 0);     {06-02-2022}
        end
         else
         begin
           P1 := BLToScreen(CanvCursorBL0.lat, CanvCursorBL0.long);
           P2 := BLToScreen(CanvCursorBL.lat, CanvCursorBL.long);
           MouseMarkers(P1.x, P1.y, P2.x, P2.y, MaxInt, MultiSelectMode);   {06-02-2022}
         end;
        //MouseMarkers(P1.x, P1.y, P2.x, P2.y, MaxInt, j);
        MarkerList.AllMarks.ClearSelection;
        for I := 0 to Length(SelectedMarkers) - 1 do
          MarkerList.AllMarks.Selected[SelectedMarkers[I]] := True;
        MarkerList.AllMarks.OnClick(nil);
      except
      end;
  end;

  GetEdTools;

  if EdWin.Showing then
     EdWin.ReFreshTree;

  ResetMs;
  //MShift.X := - 10000;
  if (ShiftMode) and (ClickMode <> 29) then
     SaveCtrlZ;

  ShiftMode := false;
  MultiSelectMode := 0;

end;

procedure TMapFm.CheckKnSaver;
var I:Integer; b:boolean;
begin
  b := false;
  for I := 0 to Length(Markers) - 1 do
    if (Markers[I].MarkerKind > 0) and (Markers[I].MarkerKind < 10) then
    begin
      b := true;
      break;
    end;
  SaveKnotMarkers.Visible := b;
end;

procedure TMapFm.CheckmatesClick(Sender: TObject);
begin
//  Checkmates.Flat := not CheckMates.Flat;
   inc(ChessMode);
   if ChessMode > 2 then
     ChessMode := 0;

   Checkmates.Glyph.Assign(nil);
   RedForm.ImageList1.GetBitmap(16 + ChessMode,Checkmates.Glyph);
   Checkmates.Hint := Inf[209 + ChessMode];

   DoDoKnots;
end;

procedure TMapFm.CheckUndoRedo;
begin
  UndoB.Visible := CtrlZ > 1;
  RedoB.Visible := CtrlShiftZ > 0;
  URPan.Visible := ((PC.ActivePageIndex <4)or(PC.ActivePageIndex = 8))
        and (UndoB.Visible)or(RedoB.Visible);
  if URPan.Visible then
  begin
     URPan.Parent := PC.Pages[PC.ActivePageIndex];

//     URPan.Color :=  Canvas.Pixels[100,100] // GetPixel(GetDC(0), Left+5, Top+35);
//     ReleaseDC;
  end;
end;

procedure TMapFm.CoordForSelected;
var I,J:Integer;
    C: TLatLong;
    bk: boolean;
begin                     {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!WARNING}
  bk := false;
  case ClickMode of
        22: if FrameCount > 1 then
            if SelectedFramePointsCount = 1 then
            Begin
                for I := 0 to Length(SelectedFramePoints) - 1 do
                  if SelectedFramePoints[I] then
                     break;

                c := MapToBL(FramePoints[I,1].x, FramePoints[I,1].y);
            End;

        24: if SelectedRoutePointsCount = 1 then
            Begin
                for I := 0 to Length(SelectedRoutePoints) - 1 do
                begin
                  for J := 0 to Length(SelectedRoutePoints[I]) - 1 do
                    if SelectedRoutePoints[I,J] then
                    Begin
                      try
                        C.lat := Route[I].GWPT[J].x;
                        C.long := Route[I].GWPT[J].y;
                      except
                       exit;
                      end;
                      bk := true;
                      break;
                    End;

                    if bk then
                       break;

                end;


            End;
    else
     exit;
  end;
   


   Timer.Enabled := false;

   MarkEd.PMode := 2;

   MarkEd.Edit2.Text := DegToDMS(c.lat, true, 4);
   MarkEd.Edit3.Text := DegToDMS(c.long, false, 4);
   MarkEd.ShowModal;

   if MarkEd.IsOk then
   begin
      case ClickMode of
        22: if FrameCount > 1 then
            Begin
              if SelectedFramePointsCount = 1 then
              Begin
               FramePoints[I,2].x := StrToLatLon(MarkEd.Edit2.Text, true);
               FramePoints[I,2].y := StrToLatLon(MarkEd.Edit3.Text, false);
              End;
              if I = 0 then
              begin
                FramePoints[FrameCount - 1,1] := FramePoints[0,1];
                FramePoints[FrameCount - 1,2] := FramePoints[0,2];
              end
                else
                if I = FrameCount - 1 then
                begin
                  FramePoints[0,1] := FramePoints[FrameCount - 1,1];
                  FramePoints[0,2] := FramePoints[FrameCount - 1,2];
                end
            End;

        24: if SelectedRoutePointsCount = 1 then
            Begin
               Route[I].GWPT[J].x := StrToLatLon(MarkEd.Edit2.Text, true);
               Route[I].GWPT[J].y := StrToLatLon(MarkEd.Edit3.Text, false);
            End;
      end;
  end;

   RecomputeRoutes(WaitForZone);
   SaveCtrlZ;
   Timer.Enabled := true;

   if MarkerList.Visible then
      MarkerList.RefreshList(false);
end;

procedure TMapFm.FormActivate(Sender: TObject);
var I, j: Integer;
begin
   SetCurrentDir(MyDir);

   DefineCsys;

   if isFistStart then
   begin
    LoadLang(-1, false);
    DefaultCsys;
    e1.Hint := Extra.Caption;  Extra.Hint := Extra.Caption;  Extra.Caption  := '';
    e2.Hint := Extra2.Caption; Extra2.Hint := Extra2.Caption; Extra2.Caption := '';
    e3.Hint := Extra3.Caption; Extra3.Hint := Extra3.Caption; Extra3.Caption := '';
    SetFm.LoadSettings;
   end
      else
        exit;

   if (ParamStr(1)='-mgpx') then
   begin
      Bm1.Click;
      if Length(Markers) > 0 then
        Garmingpx1.Click;
      close;
   end;

   if (ParamStr(1)='-rgpx') then
   begin
      B4.Click;
      if RouteCount > 0 then
        Garmingpx1.Click;
      close;
   end;

   if (ParamStr(1)='-melx') then
   begin
      Melesk := true;
      PC.ActivePageIndex := 2;
      B30.Visible := false;
      MeleskButton.Visible := true;
      Bm1.Click;

      if Length(Markers) > 0 then
      begin
        SetLength(MainTrack, Length(Markers));
        j := 0;

        for I := 0 to Length(MainTrack) - 1 do
        if Pos('pv', AnsiLowerCase(Markers[I].MarkerName)) <> 1 then
        begin
          MainTrack[j].B := Markers[I].Gx;
          MainTrack[j].L := Markers[I].Gy;
          MainTrack[j].x := Markers[I].x;
          MainTrack[j].y := Markers[I].y;
          MainTrack[j].Comment := Markers[I].MarkerName;
          MainTrack[j].HGeo := Markers[I].HGeo;
          MainTrack[j].T := Now;
          inc(j);
        end;
        SetLength(MainTrack, j);
        RecomputeTrack(MainTrack, false);
      end;

      if Length(MainTrack) > 0 then
      begin
        Frops.MainBox.ItemIndex := 1;
        FrOps.Date1.Date := trunc(MainTrack[0].T);
        FrOps.Time1.Time := MainTrack[0].T
                         - trunc(MainTrack[0].T);
        FrOps.Date2.Date := trunc(MainTrack[Length(MainTrack)-1].T);
        FrOps.Time2.Time := MainTrack[Length(MainTrack)-1].T
                         - trunc(MainTrack[Length(MainTrack)-1].T);
        Frops.Show;
        Frops.Button1.Click;
        RecomputeRoutes(false);
      end;

      if MessageDlg(inf[100], mtconfirmation, [mbyes,mbno],0) = 6 then
         Route[0] := RouteSpecialStepBreak(0, 1E+4);
      RecomputeRoutes(false);

      MeleskButton.Click;
   end;

   if (ParamStr(1)='-meangpx') or (ParamStr(1)='-meantxt') then
   begin
      PC.ActivePageIndex := 5;
      if (ParamStr(1)='-meangpx') then
      begin
        OpenNmea.FilterIndex := 2;
        BNMEA.Click
      end
          else
            Btxt.Click;

      Refreshbtn.Click;

      if Length (Maintrack) > 0 then
      Begin
        RTOps.Click;
        if RouteCount > 0 then
          SaveRoutesTXT;
      End;

   //   if MessageDlg(inf[91], mtconfirmation, [mbyes,mbno],0) = 6 then
        close;
   end;

   if (ParamStr(1)='-rtgpx') then
   begin
      OpenRoutes.FilterIndex := 4;
      B4.Click;
      Timer.Enabled := false;

      if RouteCount = 0 then
      if Length(Markers) > 1 then
      Begin
         Namer.Edit1.Text := Inf[28];
         Namer.ShowModal;
         if Namer.isOk then
           RouteFromMarkers(Namer.Edit1.Text);

      End;

      if RouteCount > 0 then
      begin
        B4b.Click;

        {if MessageDlg(inf[98], mtconfirmation, [mbyes,mbno],0) = 6 then
        begin
          for I := 0 to RouteCount - 1 do
            AddRoutePointsToTrack(MainTrack, Route[I], Now);
          Garmingpx1Click(nil);
        end; }

      end;

      Timer.Enabled := true;
   //   if MessageDlg(inf[91], mtconfirmation, [mbyes,mbno],0) = 6 then
        close;
   end;

   if (ParamStr(1)='-prgpx') or (ParamStr(1)='-prtxt') then
   begin
      PC.ActivePageIndex := 5;
      if (ParamStr(1)='-prgpx') then
      begin
        OpenNmea.FilterIndex := 2;
        BNMEA.Click
      end
          else
            Btxt.Click;

      Refreshbtn.Click;
      RouteOps.Edit2.Text := '';
      if Length (Maintrack) > 0 then
      Begin

        if RouteCount = 0 then
           B4.Click;

        Refreshbtn.Click;

        RTOps.Click;
        {if RouteCount > 0 then
          SaveRoutesTXT;}
      End;

      if RouteCount > 1 then
      begin
        Garmingpx1Click(nil);
      end;
     // if MessageDlg(inf[91], mtconfirmation, [mbyes,mbno],0) = 6 then
        close;
   end;

   if ParamStr(1)='' then
   Begin
     //PC.Pages[2].TabVisible := false;
     PC.Pages[4].TabVisible := false;
     PC.ActivePageIndex := 0;
   End
    Else
    if ParamStr(1)='-div' then
    Begin
      PC.Pages[4].TabVisible := false;
      PC.ActivePageIndex := 1;
    End
     Else
      if ParamStr(1)='-emul' then
      Begin
         PC.ActivePageIndex := 4;

        if fileexists('..\Data\Temp.rts') then
          LoadRoutesFromRTS('..\Data\Temp.rts', false, '')
      End;

    B5e.Enabled := Fileexists('Raster.exe');
    Estim.Enabled := Fileexists('EstimHgt.exe');

    if (ParamStr(1) ='-noaa')or(ParamStr(2)='-noaa') then
    Begin
      Smooth := false;
    End;

    if (ParamStr(1) ='-all')or(ParamStr(2)='-all') then
    Begin
     PC.Pages[2].TabVisible := true;
     PC.Pages[4].TabVisible := true;
     PC.Pages[7].TabVisible := true;
    End;

    isFistStart := false;
end;

procedure TMapFm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if EdTools.Showing then
    EdTools.OnShow(nil);
end;

procedure TMapFm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

   if (FrameCount > 0) or (RouteCount > 0) or (Length(Markers) > 0) or
      (Length(MainTrack) > 0) then
     if MessageDlg(inf[91], mtConfirmation,[mbYes, mbNo], 0) = mrNo then
     begin
        Action := caNone;
        exit;
     end;

  ResetSettings;
end;

procedure TMapFm.FormCreate(Sender: TObject);
begin
  Application.OnMessage := AppOnMessage;

  RulPan.Top := CutPan.Top;
  RulPan2.Top := RulPan.Top + RulPan.Height;

  NewKnotPanel.Top := CutPan.Top;
  NewKnotPanel2.Top := NewKnotPanel.Top + NewKnotPanel.Height + 5;
  NewKnotPanel3.Top := NewKnotPanel.Top + NewKnotPanel.Height + 5;
  NewKnotPanel3.Left := NewKnotPanel.Left;
  NewKnotPanel4.Top := NewKnotPanel2.Top;

  KnotSettings.Top := CutPan.Top;

  CoordSysN := -1;
  SubCursor := -1;
  oldIdX :=-1;
  Application.HintPause := 100;
  Application.OnShowHint := OnShowHint;

  MyDir := GetCurrentDir + '\';
  EdPicketsFileName := MyDir + 'Data\Loops.loc';
  MapDataDir := MyDir + 'Data\';
  TmpDir := MyDir + 'Tmp\';
  GoogleTmpDir := TmpDir;
  YandexTmpDir := TmpDir;

  ForceDirectories(TmpDir);
  ForceDirectories(GoogleTmpDir);

  if Fileexists(Mydir+'Data\Ozi.txt') then
   GoogleOziDir := MyDir + 'Ozi\';

  YandexOziDir := GoogleOziDir;

  GeoInit('Data\Sources.loc','','');
  SK := FindDatum('SK42');
  WGS := FindDatum('WGS84') ;


  JustStarted := true;

 // Enable Delphi debugger
 ReportMemoryLeaksOnShutdown:= DebugHook <> 0;

 // Set the display size
 DisplaySize:= Point2px(ClientWidth, ClientHeight);

 // Indicate that we're using DirectX 9
 OpenGL := false;
 if (ParamStr(1)='-gl')or(ParamStr(2)='-gl') then
     OpenGL := true;
     
 if OpenGL then
   Factory.UseProvider(idOpenGL)
     else
      Factory.UseProvider(idDirectX9);

 // Create Asphyre components in run-time.
 AsphDevice:= Factory.CreateDevice();
 AsphCanvas:= Factory.CreateCanvas();
 AsphImages:= TAsphyreImages.Create();
 AsphMapImages:= TAsphyreImages.Create();

 AsphFonts:= TAsphyreFonts.Create();
 AsphFonts.Images:= AsphImages;
 AsphFonts.Canvas:= AsphCanvas;

 MediaASDb:= TASDb.Create();
 MediaASDb.FileName:= ExtractFilePath(PChar(MyDir)) + 'Data\mapper.asdb';
 MediaASDb.OpenMode:= opReadOnly;

 AsphDevice.WindowHandle:= Self.Handle;
 AsphDevice.Size    := DisplaySize;
 AsphDevice.Windowed:= True;
 AsphDevice.VSync   := True;      

 EventDeviceCreate.Subscribe(OnDeviceCreate, 0);

 // Attempt to initialize Asphyre device.
 if (not AsphDevice.Initialize()) then
  begin
   ShowMessage('Failed to initialize Asphyre device.');
   Application.Terminate();
   Exit;
  end;

 // Create rendering timer.
 Timer.OnTimer  := TimerEvent;
// Timer.OnProcess:= ProcessEvent;
 Timer.Speed    := 60.0;
 Timer.MaxFPS   := 4000;
 Timer.Enabled  := False;

 KnotCount := 0;

 ClickMode := 1;
 CoordSysN := -1;
 MShift.X := - 1000;
 MShift.Y := - 1000;
 MouseSenseZone := 10;

 Base[2].x := 0;
 Base[2].y := 0;
 ReComputeBase(true);
 RefreshSelectionArrays;
 Center.X := MapToScreen(Base[1].X,Base[1].Y).x;
 Center.Y := MapToScreen(Base[1].X,Base[1].Y).y;
 ShiftCenter.x := Center.x;
 ShiftCenter.y := Center.y;

 PC.ActivePageIndex := 0;

 FileSetAttr('libeay32.dll', faHidden);
 FileSetAttr('ssleay32.dll', faHidden);
 //FileSetAttr('chsdet.dll', faHidden);

 ModeButtons;

 MakeFloatSpins;
end;

procedure ClearDir(Const Dir:String);

  procedure AddFiles(Dir:string; var FileList:TStringList);
  var
   SearchRec : TSearchrec; //Запись для поиска
  begin
    if FindFirst(Dir + '*.*', faAnyFile, SearchRec) = 0 then
    begin
      if (SearchRec.Name<> '')
        and(SearchRec.Name <> '.')
        and(SearchRec.Name <> '..')
        and not ((SearchRec.Attr and faDirectory) = faDirectory) then
          FileList.Add(SearchRec.Name);
      while FindNext(SearchRec) = 0 do
        if (SearchRec.Name <> '')
          and(SearchRec.Name <> '.')
          and(SearchRec.Name <> '..')
          and not ((SearchRec.Attr and faDirectory) = faDirectory)  then
             FileList.Add(SearchRec.Name);
      FindClose(Searchrec);
    end;
  end;

var
 FileList : TStringList;
 I:Integer;
begin
  FileList := TStringList.Create;
  AddFiles (Dir, FileList);

    for I := 0 to FileList.Count - 1 do
    try
      DeleteFile(PChar(Dir+FileList[i]));
    except
    end;
    FileList.Destroy
end;

procedure TMapFm.FormDestroy(Sender: TObject);
begin
 Timer.Enabled:= False;
 FreeAndNil(AsphFonts);
 FreeAndNil(AsphImages);
 FreeAndNil(AsphMapImages);
 FreeAndNil(MediaASDb);
 FreeAndNil(AsphCanvas);
 FreeAndNil(AsphDevice);


 DestroyFloatSpins;
 ClearDir(TmpDir);
end;

procedure TMapFm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F4 then
    DrawAll := not DrawAll;

  if Key = VK_F5 then
    ShowMessage(inf[170]+ IntToStr(MyZone)+ #13 + inf[171]+ IntToStr(MyZone-30));

  if Key = VK_F2 then
    if Windowstate = wsMaximized then
    begin
      Windowstate := wsNormal;
      BorderStyle := BsSingle;
    end
      else
        Begin
          BorderStyle := BsNone;
          Windowstate := wsMaximized;
        End;

//// + - клавиши

 if (Key = 187) or (Key = 107) then
 Begin
    CanvCursor.x := MapFm.Canv.Width div 2;
    CanvCursor.y := MapFm.Canv.Height div 2;

    Shiftmap(1);
    if (ClickMode = 50) then
      if AZoom.Checked then
        DoAZoom(false);
    if (ClickMode = 51) then
      if YAZoom.Checked then
        DoYAZoom(false);

 End;

 if (Key = 189) or (Key = 109) then
 Begin
    CanvCursor.x := MapFm.Canv.Width div 2;
    CanvCursor.y := MapFm.Canv.Height div 2;

    Shiftmap(0);
    if (ClickMode = 50) then
      if AZoom.Checked then
        DoAZoom(false);
    if (ClickMode = 51) then
      if YAZoom.Checked then
        DoYAZoom(false);
 End;

//// W S A D

 if (Key = 87)  or (Key = vk_Up) then
    Shiftmap(2);

 if (Key = 83) or (Key = vk_Down) then
    Shiftmap(3);

 if (Key = 65) or (Key = vk_Left) then
    Shiftmap(4);

 if (Key = 68) or (Key = vk_Right) then
    Shiftmap(5);


 if Key = vk_return then
 case ClickMode of
   25: begin
            ClickMode := 1;
            if FrameCount>2 then
            Begin
             CreateFramePoint(FramePoints[0,2].x, FramePoints[0,2].y);
             Dec(FrameCount);
             RecomputeRoutes(False);
             RefreshSelectionArrays;
             SaveCtrlZ;
             ClickMode := 21;
             ModeButtons;
             EdWin.ReFreshTree;
            End
             else
             Begin
               FrameCount := 0;
               EdWin.ReFreshTree;
             End;
   end;

   26: begin
      DeleteRoutePoint(RouteCount-1,Length(Route[RouteCount-1].WPT)-1);
      SaveCtrlZ;
      ClickMode := 23;
      ModeButtons;
      EdWin.ReFreshTree;
      RefreshRouteBox;

      if RulCreatingLines then
             RulStat;
   end;

   30: FKnotList.EditKn.Click;
 end;

 if (ssCtrl in Shift) and (Key = Ord('Z')) then
   LoadCtrlZ(ssShift in Shift);

 if (Key = vk_delete)or(Key = vk_back) then
 case ClickMode of
    25: if FrameCount>1 then
            Begin
             Dec(FrameCount);
             RecomputeRoutes(False);
             RefreshSelectionArrays;
             ModeButtons;
             SaveCtrlZ;

             if RulCreatingLines then
                RulStat;
            End
             else
             Begin
               FrameCount := 0;
               SaveCtrlZ;
               EdWin.ReFreshTree;
             End;

    26: if Length(Route[RouteCount-1].WPT)> 2 then
         begin
           DeleteRoutePoint(RouteCount-1,Length(Route[RouteCount-1].WPT)-1);
           EdWin.ReFreshTree;
           RefreshRouteBox;
           SaveCtrlZ;
           RecomputeRuler(ClickMode);
           if RulCreatingLines then
                RulStat;
         end
          else
          Begin
            DelRoute(RouteCount-1);
            EdWin.ReFreshTree;
            RefreshRouteBox;
            ClickMode := 0;
            ModeButtons;
            SaveCtrlZ;
          End;

    21,22,23,24 :
    Begin
      DelSelected;
      SaveCtrlZ;
      if RulCreatingLines then
                RulStat;
    End;
    5,6:
    begin
      B5d.Click;
    end;
    50:
    begin
      if CutMode >=2 then
         Bcut.Click;
    end;
    7: DelLast.Click;

    31: MarkerList.DelBtn.Click;
    30: FKnotList.DelKn.Click;
 end;

 if (Key = vk_F3) then
  Begin
     ScreenShot.Click;
  End;

  if (Key = vk_F5) then
  Begin
     Refreshbtn.Click;
  End;

  if (Key = vk_F6) then
  Begin
    PC.Pages[4].TabVisible := true;
  End;

  if (Key = vk_F7) then
    CustomScale;

  if (Key = vk_F11) then
  Begin
     //Caption := 'DEV '+ IntToStr(trunc(center.x))+'; '+IntToStr(trunc(center.y)) ;
     SaveLngs;
     PC.Pages[2].TabVisible := true;
  End;

{ if Key = vk_Tab then
 if ClickMode=5 then
 Begin
   if MapChoosed<>-1 then
   Begin
     Inc(MapChoosed);
     if MapChoosed >= Length(MapList) then
       MapChoosed := 0;
   End;
 End;

 if Key = vk_Delete then
 if ClickMode=5 then
 Begin
   if MapChoosed<>-1 then
   Begin
     B5d.OnClick(Sender);
   End;
 End;  }


 GetEdTools;

end;

procedure TMapFm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 if  (Blend.Focused)or(RouteBox.Focused)or(RouteBox2.Focused)or(KnotRoutes.Focused)
 or(GZoom.Focused)or(GStyle.Focused)or(YZoom.Focused)or(YStyle.Focused)or(YLang.Focused)or
     (KnotNames.Focused) or (KnotAng.Focused) or (KnotAngRoute.Focused) or
     (KnotAngOwn.Focused)or (KnotSize.Focused)  or (KnotStep.Focused) or (KnotStartL.Focused) or
     (KnotStart.Focused) or (SetKnNameKind.Focused) or
     (KnotAreaStepX.Focused) or ( KnotAreaStepY.Focused) or
     (KnotAreaAngle.Focused) or (KnotAreaRadius.Focused) or
     (KnotAreadX.Focused) or (KnotAreadY.Focused) or (KnotAreaOrder.Focused) or
     (KnotAreaName.Focused) or (OrderW.Showing) then
    exit;

  if (ClickMode = 50) and (ssShift in Shift) then
  begin
    GoogleZoomDown;
    RefreshSt;
  end
  else
  if (ClickMode = 51) and (ssShift in Shift) then
  begin
    YandexZoomDown;
    RefreshYSt;
  end
   ELSE
  if (ssCtrl in Shift) then
    _fi := _fi - pi/20
  else
    ShiftMap(0);

  if AZoom.Checked then
    if (ClickMode = 50) then
      DoAZoom(false);

  if YAZoom.Checked then
    if (ClickMode = 51) then
      DoYAZoom(false);
end;

procedure TMapFm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin                                              

 if  (Blend.Focused)or(RouteBox.Focused)or(RouteBox2.Focused)or(KnotRoutes.Focused)
     or(GZoom.Focused)or(GStyle.Focused)or(YZoom.Focused)or(YStyle.Focused)or(YLang.Focused)or
     (KnotNames.Focused) or (KnotAng.Focused) or (KnotAngRoute.Focused) or
     (KnotAngOwn.Focused) or (KnotSize.Focused)or (KnotStep.Focused)  or (KnotStartL.Focused)or
     (KnotStart.Focused)  or (SetKnNameKind.Focused) or
     (KnotAreaStepX.Focused) or (KnotAreaStepY.Focused) or
     (KnotAreaAngle.Focused) or (KnotAreaRadius.Focused) or
     (KnotAreadX.Focused) or (KnotAreadY.Focused) or (KnotAreaOrder.Focused) or
     (KnotAreaName.Focused) or (OrderW.Showing) then
    exit;

 if (ClickMode = 50) and (ssShift in Shift) then
 begin
   GoogleZoomUp;
   RefreshSt;
 end
 else
 if (ClickMode = 51) and (ssShift in Shift) then
 begin
   YandexZoomUp;
   RefreshYSt;
 end
   ELSE
 if (ssCtrl in Shift) then
    _fi := _fi + pi/20
  else
      ShiftMap(1);

 if AZoom.Checked then
   if (ClickMode = 50) then
      DoAZoom(false);

 if YAZoom.Checked then
    if (ClickMode = 51) then
      DoYAZoom(false);
end;

procedure TMapFm.FormResize(Sender: TObject);
begin
  DisplaySize := Point2px(Canv.ClientWidth, Canv.ClientHeight);
  DispSize := DisplaySize;
  AsphDevice.Size := DisplaySize;
  if EdTools.Showing then
    EdTools.OnShow(nil);

end;

procedure TMapFm.FormShow(Sender: TObject);
begin

  Timer.Enabled  := True;

  DefineCsys;

  PC.Pages[6].TabVisible := GoogleKey <> '';
  // Agoogle2.Enabled := PC.Pages[6].TabVisible;
end;

procedure TMapFm.GetEdTools;
begin

  if (ClickMode>=21) and (ClickMode<=24) then
  begin
    if (ClickMode<23) then
    begin
      if SelectedFramePointsCount > 0 then
         EdTools.Show
           else
             Begin
                EdTools.Hide;
                Movep.Hide;
             End;
       EdTools.BPos.Enabled := SelectedFramePointsCount = 1;
       EdTools.BName.Enabled := False;
       EdTools.Hgt.Enabled := False;
    end
     else
     begin
       if SelectedRoutePointsCount > 0 then
         EdTools.Show
          else
             Begin
                EdTools.Hide;
                Movep.Hide;
             End;

       EdTools.BPos.Enabled := SelectedRoutePointsCount = 1;
       EdTools.BName.Enabled := SelectedRoutesCount = 1;
       EdTools.Hgt.Enabled := SelectedRoutePointsCount > 0;
   //    EdTools.BName.Enabled := SelectedRoutesCount = 1;
     end;

  end
    Else
    Begin
      EdTools.Hide;
      Movep.Hide;
    End;
end;

procedure TMapFm.GoogleMaps1Click(Sender: TObject);
begin
  TabSheet6.OnShow(Sender);
  PC.ActivePageIndex := 6;
  AGoogle.OnClick(nil);
end;

procedure TMapFm.GStyleChange(Sender: TObject);
begin
  GoogleStyle := GoogleMapStyles[GStyle.ItemIndex];
end;

procedure TMapFm.GZoomChange(Sender: TObject);
begin
  ZoomA := Trunc(StrToFloat2(GZoom.Text));
  Azoom.Checked := False;
end;

procedure TMapFm.InfCutClick(Sender: TObject);
begin
  GetCuttingPoints(RouteBox.ItemIndex-1, InfCut.Checked);
end;

procedure TMapFm.InitKnots(Kind: Integer);
begin

  case Kind of
    0: begin
     uKnotPickets.KnotSize.Value := KnotSize.Value;
     uKnotPickets.Lmax.Value := KnotSize.Value;
     uKnotPickets.l1.Value := KnotSize.Value/2;
     uKnotPickets.l2x.Value := KnotSize.Value/2;
     uKnotPickets.l2y.Value := KnotSize.Value/2;
     uKnotPickets.l3.Value := uKnotPickets.l1.Value;
     uKnotPickets.l4x.Value := KnotSize.Value/2;
     uKnotPickets.l4y.Value := KnotSize.Value/2;
     uKnotPickets.l4x.Value  :=  KnotSize.Value/2;
     uKnotPickets.l4y.Value  :=  KnotSize.Value/2;
     FKnotPickets.a4.Value := 2;
     FKnotPickets.pkt_PMethod := 0;
     FKnotPickets.PktApplySet;
    end;
    1: begin
     FKnotPickets.pkt_PMethod := 1;
     FKnotPickets.PktMethod.ItemIndex := 1;
     uKnotPickets.KnotSize.Value := KnotAreaRadius.Value;
     uKnotPickets.Lmax.Value := KnotAreaRadius.Value;
     uKnotPickets.l1.Value := KnotAreaRadius.Value/2;
     uKnotPickets.l2x.Value := KnotAreaRadius.Value/2;
     uKnotPickets.l2y.Value := KnotAreaRadius.Value/2;
     uKnotPickets.l3.Value := uKnotPickets.l1.Value;
     uKnotPickets.l4x.Value := KnotAreaRadius.Value/2;
     uKnotPickets.l4y.Value := KnotAreaRadius.Value/2;
     uKnotPickets.l4x.Value  :=  KnotAreaRadius.Value/2;
     uKnotPickets.l4y.Value  :=  KnotAreaRadius.Value/2;
     FKnotPickets.a4.Value := 2;
     FKnotPickets.PktApplySet;
    end;
    2: begin
     uKnotPickets.KnotSize.Value :=  KnotSize.Value;
     uKnotPickets.KnotAng.Value :=  0;
     FKnotPickets.KnotSz :=  KnotSize.Value;
     FKnotPickets.KnotA  :=  0;
     FKnotPickets.HideRt := True;
     uKnotPickets.Lmax.Value :=  KnotSize.Value;
     uKnotPickets.l1.Value   :=  KnotSize.Value/2;
     uKnotPickets.l2x.Value  :=  KnotSize.Value/2;
     uKnotPickets.l2y.Value  :=  KnotSize.Value/2;
     uKnotPickets.l3.Value   :=  uKnotPickets.l1.Value;
     uKnotPickets.l4x.Value  :=  KnotSize.Value/2;
     uKnotPickets.l4y.Value  :=  KnotSize.Value/2;
     FKnotPickets.a4.Value := 2;  FKnotPickets.pkt_N := 2;
     FKnotPickets.PktMethod.ItemIndex := 1;
     FKnotPickets.pkt_PMethod := 1;
     FKnotPickets.RenewKnotBox;
     FKnotPickets.PktApplySet;
     //FKnotPickets.Inited := true;
    end;
  end;

  FKnotPickets.PktConfirm;
end;

procedure TMapFm.isDAClick(Sender: TObject);
begin
  DegIsDA  := Not DegIsDA;
  ModeButtons;
  MinShift.Enabled := (Deg.Value = 0) and (DegIsDa = false);
end;

procedure TMapFm.LoadCtrlZ(CtrlShift:Boolean);
var S :TStringList;
    i, j, k :integer;
begin
  if not (CtrlShift) then
  Begin
    if (CtrlZ <= 1) then
    begin
       UndoB.Visible := false;
       exit
    end
         else
         Begin
           dec(CtrlZ);
           inc(CtrlShiftZ);
         End;
  End

  Else
  Begin
    if (CtrlShiftZ < 1) then
       exit
         else
         Begin
           dec(CtrlShiftZ);
           inc(CtrlZ);
         End;
  End;

  EdTools.Close;
  Movep.Close;

  if fileexists(TmpDir+'Back'+intToStr(CtrlZ-1)+'.rts') then
     LoadRoutesFromRTS(TmpDir+'Back'+intToStr(CtrlZ-1)+'.rts', false, '')
       else
         begin
              RouteCount := 0;
              FrameCount := 0;
         end;
  RefreshSelectionArrays;

  ResetMarkers;
  if fileexists(TmpDir+'Back'+intToStr(CtrlZ-1)+'.mark') then
     LoadMarkers(TmpDir+'Back'+intToStr(CtrlZ-1)+'.mark');

  if fileexists(TmpDir+'Back'+intToStr(CtrlZ-1)+'.rnk') then
     LoadKnots(TmpDir+'Back'+intToStr(CtrlZ-1)+'.rnk', false);



  K := -1;
  S := TstringList.Create;

  if not (CtrlShift) then
    S.LoadFromFile(TmpDir+'Back'+intToStr(CtrlZ)+'.rt_')
      else
       S.LoadFromFile(TmpDir+'Back'+intToStr(CtrlZ-1)+'.rt_') ;

  if S.Count > 0 then
    if  ClickMode <> StrToInt(S[0]) then
    begin
       ClickMode := StrToInt(S[0]);
       if (ClickMode > 20) and (clickMode < 30) then
         PC.ActivePageIndex := 3;
       if (ClickMode >= 30) and (clickMode <= 31) then
         PC.ActivePageIndex := 2;

       ModeButtons;
    end;

  SetLength(SelectedMarkers, 0);
  SetLength(SelectedKnots, 0);
  for I := 1 to S.Count - 1 do
    case ClickMode of
      30: begin
         SetLength(SelectedKnots, Length(SelectedKnots)+1);
         SelectedKnots[Length(SelectedKnots)-1] := StrToInt(S[I]);
      end;

      31: begin
         SetLength(SelectedMarkers, Length(SelectedMarkers)+1);
         SelectedMarkers[Length(SelectedMarkers) - 1] := StrToInt(S[I])
      end;

      21, 22:
      Begin
         TreeSelectFramePoint(StrToInt(S[I]));
         Inc(SelectedFramePointsCount);
      End;

      23, 24:
      Begin
           J := StrToInt(GetCols(S[I],0,1,' ', true));
           TreeSelectRoutePoint( J, StrToInt(GetCols(S[I],1,1,' ', true)));

           Inc(SelectedRoutePointsCount);
           if K = -1 then
           Begin
              SelectedRouteN := J;
              K := J;
              inc(SelectedRoutesCount);
           End;

           if K <> J then
           Begin
              K:= J;
              Inc(SelectedRoutesCount);
           End;
      End;

    end;

    if ClickMode = 25 then
    Begin
       if FrameCount > 0 then
         Frame := True
           else
           begin
            ClickMode := 1;
            ModeButtons;
           end;
    End;

    UndoB.Visible := CtrlZ > 1;
    RedoB.Visible := CtrlShiftZ > 0;

  EdWin.RefreshTree;
  S.Free;

  if PC.ActivePageIndex = 2 then
     CheckKnSaver;

  case ClickMode of
      30: begin
        FKnotList.RefreshKnotList;
        FKnotList.AllKnots.ClearSelection;
        for I := 0 to Length(SelectedKnots) - 1 do
          FKnotList.AllKnots.Selected[SelectedKnots[I]] := True;
      end;

      31: begin
        if not MarkerList.Showing then
          MarkerList.Show;
        MarkerList.RefreshList(false);
      end;
  end;

  if RulCreatingLines then
     RulStat;

  CheckUndoRedo;
  CheckWFZ;
 // if MarkerList.Visible then
 //       MarkerList.RefreshList(false);
end;

procedure TMapFm.LoadSettings(FileName: String);
  function MyCol(Col: TColor): Cardinal;
  begin
     Result :=  GetBValue(Col) or (GetGValue(Col) shl 8)or (GetRValue(Col) shl 16)
          or (255 shl 24);
  end;

  function MyIntCol(Col: TColor): Cardinal;
  begin
     Result :=  GetBValue(Col) or (GetGValue(Col) shl 8)or (GetRValue(Col) shl 16)
          or (200 shl 24);
  end;
  
var S: TStringList;
begin
  SetCurrentDir(MyDir);
  S := TStringList.Create;

  try
    S.LoadFromFile(MyDir+'Data\GoogleKey.txt');
    GoogleKey := S[0];

    if fileexists(FileName) then
    begin
      S.LoadFromFile(FileName);

      BackGroundColor := MyCol(StringToColor(S[0]));
      LinesColor      := MyCol(StringToColor(S[1]));
      ChoosedColor    := MyCol(StringToColor(S[2]));
      DopObjColor     := MyCol(StringToColor(S[3]));
      ObjColor        := MyCol(StringToColor(S[4]));
      IntColor        := MyIntCol(StringToColor(S[5]));
      InfoColor       := MyCol(StringToColor(S[6]));
      TrackColor      := MyCol(StringToColor(S[7]));
      RedTrackColor   := MyCol(StringToColor(S[8]));
      FntColor        := MyCol(StringToColor(S[9]));

      with SetFm Do
      begin
         BackGroundColor.Brush.Color := StringToColor(S[0]);
         LinesColor.Brush.Color      := StringToColor(S[1]);
         ChoosedColor.Brush.Color    := StringToColor(S[2]);
         DopObjColor.Brush.Color     := StringToColor(S[3]);
         ObjColor.Brush.Color        := StringToColor(S[4]);
         IntColor.Brush.Color        := StringToColor(S[5]);
         InfoColor.Brush.Color       := StringToColor(S[6]);
         TrackColor.Brush.Color      := StringToColor(S[7]);
         RedTrackColor.Brush.Color   := StringToColor(S[8]);
         FntColor.Brush.Color        := StringToColor(S[9]);
      end;

    end;

  except
  end;

  S.Free;
end;


procedure TMapFm.LoopShapeClick(Sender: TObject);
var I:Integer; a: double; s:string;
begin


  if RndLoop < 2 then
  begin
    { if InputQuery(inf[217], inf[218], s) then
     begin
       a := StrToFloat2(s);
       if (a > SetKnSize.Value / 5000) and (a < SetKnSize.Value / 3) then  }
           inc(RndLoop);

           a := KnotPoints[SelectedKnots[0]].ShStep;
           if (a < SetKnSize.Value / 5000) or (a > SetKnSize.Value / 3) then
             a := SetKnSize.Value / 5;

           SetSStep.Value := a;

           if KnotPoints[SelectedKnots[0]].BoxSize2 = 0 then
              KnotPoints[SelectedKnots[0]].BoxSize2 := KnotPoints[SelectedKnots[0]].BoxSize;
               
    { end;}
  end
  else
     RndLoop :=0;

  //if NotChangeKnot then
  //   exit;

  case RndLoop of
    1: SetKnSizeLabel.Caption := inf[221];
    0, 2: SetKnSizeLabel.Caption := inf[220];
  end;

  if RndLoop > 2 then
    exit;

  for I  := 0 to Length(SelectedKnots) - 1 do
  try
     KnotPoints[SelectedKnots[I]].Shp := RndLoop;
     KnotPoints[SelectedKnots[I]].ShStep := a;
     if KnotPoints[SelectedKnots[I]].BoxSize2 = 0 then
       KnotPoints[SelectedKnots[I]].BoxSize2 := KnotPoints[SelectedKnots[0]].BoxSize2;
  except
  end;
  SaveCtrlZ;

  LoopShape.Glyph.Assign(nil);
  RedForm.ImageList1.GetBitmap(19 + Rndloop, LoopShape.Glyph);
  LoopShape.Hint := Inf[213 + RndLoop];
  
  SetSpan.Visible  :=  RndLoop = 1;
  SetS2pan.Visible :=  RndLoop = 2;
  Repaint;
end;

procedure TMapFm.m1Click(Sender: TObject);
begin
  SetM(1);
end;

procedure TMapFm.m2Click(Sender: TObject);
begin
  SetM(2);
end;

procedure TMapFm.m3Click(Sender: TObject);
begin
  SetM(3);
end;

procedure TMapFm.m4Click(Sender: TObject);
begin
  m4.Flat := not m4.Flat;
end;

procedure TMapFm.m5Click(Sender: TObject);
begin
  m5.Flat := not m5.Flat;
end;

procedure TMapFm.m6Click(Sender: TObject);
begin

 case ClickMode of
    25: if FrameCount>1 then
            Begin
             Dec(FrameCount);
             RecomputeRoutes(False);
             RefreshSelectionArrays;
             ModeButtons;
            End
             else
             Begin
               FrameCount := 0;
               EdWin.ReFreshTree;
             End;

    26: if Length(Route[RouteCount-1].WPT)> 2 then
         begin
           DeleteRoutePoint(RouteCount-1,Length(Route[RouteCount-1].WPT)-1);
           EdWin.ReFreshTree;
           RefreshRouteBox;
         end
          else
          Begin
            DelRoute(RouteCount-1);
            EdWin.ReFreshTree;
            RefreshRouteBox;
            ClickMode := 0;
            ModeButtons;
          End;

 end;
end;

procedure TMapFm.m7Click(Sender: TObject);
begin
  m7.Flat := not m7.Flat;
end;

procedure TMapFm.MakeFloatSpins;

 procedure ChangeToSpin(FormI, ObjI: Integer);
 var SPF :TFloatSpinEdit; s, s2:string; o:TWinControl; i:integer;
     e1, e2 : TNotifyEvent;
 begin
    if Application.Components[FormI] is TForm then
    with Application.Components[FormI] as TForm Do
    Try
      for I := 0 to ComponentCount - 1 do
      if Components[I] is TFloatSpinEdit then
      BEGIN
          s  := TSpinEdit(Components[ObjI]).Name;
          s2 := TFloatSpinEdit(Components[I]).Name;

          //showmessage(AnsiLowerCase(s2)+'//'+AnsiLowerCase(Copy(s, 1, length(s)-1)));
          if AnsiLowerCase(s2) = AnsiLowerCase(Copy(s, 1, length(s)-1)) then
          begin
             o := TSpinEdit(Components[ObjI]).Parent;
             e1 := TSpinEdit(Components[ObjI]).OnClick;
             e2 := TSpinEdit(Components[ObjI]).OnChange;
             TFloatSpinEdit(Components[I]).Left := TSpinEdit(Components[ObjI]).Left;
             TFloatSpinEdit(Components[I]).Top := TSpinEdit(Components[ObjI]).Top;
             TFloatSpinEdit(Components[I]).Width := TSpinEdit(Components[ObjI]).Width;
             TFloatSpinEdit(Components[I]).Height := TSpinEdit(Components[ObjI]).Height;
             TFloatSpinEdit(Components[I]).Value := TSpinEdit(Components[ObjI]).Value;
             TFloatSpinEdit(Components[I]).MinValue := TSpinEdit(Components[ObjI]).MinValue;
             TFloatSpinEdit(Components[I]).MaxValue := TSpinEdit(Components[ObjI]).MaxValue;
             TFloatSpinEdit(Components[I]).Increment := TSpinEdit(Components[ObjI]).Increment;
             if o <> nil then
               TFloatSpinEdit(Components[I]).Parent := o;

             TFloatSpinEdit(Components[I]).OnClick := e1;
             TFloatSpinEdit(Components[I]).OnChange := e2;
            TSpinEdit(Components[ObjI]).Hide;
            Break;
          end;
       END;

    Except
      Showmessage('Extended spin error');
    End;
 end;



const A :Array [0..17] of String = ('Step_', 'MinShift_', 'MinL_',
                                   'Deg_',   'KnotStartL_', 'KnotAng_',
                                   'KnotSize_', 'KnotStep_', 'SetKnAng_',
                                   'SetKnSize_', 'KnotAreaStepX_',
                                   'KnotAreaStepY_', 'KnotAreaAngle_',
                                   'KnotAreaRadius_', 'KnotAreadX_',
                                   'KnotAreadY_', 'SetSStep_', 'SetKnSize2_'

                                   );
var I, j, k :Integer;
begin

   


   for i := 0 to Application.ComponentCount - 1 do
     if Application.Components[I] is TForm then
     begin
        if Application.Components[I].Name <> Name then
          continue
        else
        begin
          with Application.Components[I] as TForm Do
          Begin
            Step := TFloatSpinEdit.Create(self);     Step.Name      := 'Step';
            MinShift:= TFloatSpinEdit.Create(self);  MinShift.Name  := 'MinShift';
            MinL := TFloatSpinEdit.Create(self);     MinL.Name      := 'MinL';
            Deg:= TFloatSpinEdit.Create(self);       Deg.Name       := 'Deg';

            KnotStartL := TFloatSpinEdit.Create(self); KnotStartL.Name := 'KnotStartL';
            KnotAng := TFloatSpinEdit.Create(self);    KnotAng.Name := 'KnotAng';
            KnotSize := TFloatSpinEdit.Create(self);   KnotSize.Name := 'KnotSize';
            KnotStep := TFloatSpinEdit.Create(self);   KnotStep.Name := 'KnotStep';
            SetKnAng := TFloatSpinEdit.Create(self);   SetKnAng.Name := 'SetKnAng';
            SetKnSize := TFloatSpinEdit.Create(self);  SetKnSize.Name := 'SetKnSize';
            KnotAreaStepX := TFloatSpinEdit.Create(self);  KnotAreaStepX.Name := 'KnotAreaStepX';
            KnotAreaStepY := TFloatSpinEdit.Create(self);  KnotAreaStepY.Name := 'KnotAreaStepY';
            KnotAreaAngle := TFloatSpinEdit.Create(self);  KnotAreaAngle.Name := 'KnotAreaAngle';
            KnotAreaRadius := TFloatSpinEdit.Create(self);  KnotAreaRadius.Name := 'KnotAreaRadius';
            KnotAreadX := TFloatSpinEdit.Create(self);  KnotAreadX.Name := 'KnotAreadX';
            KnotAreadY := TFloatSpinEdit.Create(self);  KnotAreadY.Name := 'KnotAreadY';
            SetSStep := TFloatSpinEdit.Create(self);  SetSStep.Name := 'SetSStep';
            SetKnSize2 := TFloatSpinEdit.Create(self);  SetKnSize2.Name := 'SetKnSize2';

            for k := 0 to Length(A)-1 do
            for j := 0 to ComponentCount - 1 do
            begin
              if Components[J] is TSpinEdit then
                if AnsiLowerCase(Components[J].Name) = AnsiLowerCase(A[k]) then
                begin
                   ChangeToSpin(I, J);
                   refresh;
                   break;
                end;
            end;
            break;
          end;
        end;
     end;

end;

procedure TMapFm.MapCombos;
var I, J:Integer;
begin

  J := GStyle.ItemIndex;
  GStyle.Items.Clear;
  for I := 0 to 3 do
      GStyle.Items.Add(Inf[68+I]);

  GStyle.ItemIndex := J ;

  J := GZoom.ItemIndex;
  GZoom.Items.Clear;
  for I := 0 to 4 do
      GZoom.Items.Add(Inf[72+I]);

  GZoom.ItemIndex := J ;

  J := YZoom.ItemIndex;
  YZoom.Items.Clear;
  for I := 0 to 4 do
      YZoom.Items.Add(Inf[72+I]);

  YZoom.ItemIndex := J;

  J := YStyle.ItemIndex;
  YStyle.Items.Clear;
  for I := 0 to GStyle.Items.Count - 2 do
    YStyle.Items.Add(GStyle.Items[I]);

  YStyle.ItemIndex := J ;

  J := YLang.ItemIndex;
  YLang.Items.Clear;
  for I := 0 to length(YandexLangNames) - 1 do
    YLang.Items.Add(YandexLangNames[I]);

  YLang.ItemIndex := J ;
end;

procedure TMapFm.MarkerListPopup;
var i, j : integer;
begin

  //  J := Length(SelectedMarkers);

  for I := PopupMenu2.Items.Count-1 DownTo 0 do
      if PopupMenu2.Items[I].Tag > 0 then
        PopupMenu2.Items.Delete(I);

  for I := 0 to Length(SelectedMarkers) - 1 do
      AddPopupItems(PopupMenu2,  Inf[21]+' "'+ Markers[SelectedMarkers[I]].MarkerName +'"');
end;

procedure TMapFm.MarkRouteClick(Sender: TObject);
begin
  if Length(Markers) < 1 then
     exit;

  Timer.Enabled := false;

  MarkerOps.isFrame := false;
  MarkerOps.ShowModal;

  SaveCtrlZ;
  Timer.Enabled := true;
end;

procedure TMapFm.MenuItem2Click(Sender: TObject);
var L:TLatLong;
begin
  Timer.Enabled := false;
  try
    MarkEd.PMode := 0;
    MarkEd.MarkN := -1;
    MarkEd.Edit1.Text := inf[20];
    if HasDropPoint then
    begin
      L := MapToBL(PointToAdd.x, PointToAdd.y);
      MarkEd.Edit2.Text := DegToDMS(L.Lat, true, 4);
      MarkEd.Edit3.Text := DegToDMS(L.Long, false, 4);
    end
    else
      begin
        MarkEd.Edit2.Text := DegToDMS(CanvCursorBL.Lat, true, 4);
        MarkEd.Edit3.Text := DegToDMS(CanvCursorBL.Long, false, 4);
      end;
    MarkEd.ShowModal;

    if MarkerList.Visible then
       MarkerList.RefreshList(true);
       
   finally
    SaveCtrlZ;
    Timer.Enabled := true;
  end;
end;

procedure TMapFm.MenuItem3Click(Sender: TObject);
var I, j, n:Integer;
    P:TMyPoint;
begin
   SaveCtrlZ;

   KillNewKnots;
   I := Length(KnotPoints);
   SetLength(KnotPoints, I+1);
   inc(KnotCount);

   P := BLToMap(CanvCursorBL);

   KnotPoints[I].Cx := P.x;
   KnotPoints[I].Cy := P.y;


   N := 1;
   for j := 0 to I - 1 do
   begin
     if KnotPoints[j].Name = 'New' then
       if KnotPoints[j].L >= N  then
          N := KnotPoints[j].L + 1;
   end;

   KnotPoints[I].Name := 'New';
   KnotPoints[I].L := N;
   KnotPoints[I].NameKind := 0;

   if not FKnotPickets.Inited then
      InitKnots(2);

   KnotPoints[I].BoxSize  := FKnotPickets.KnotSz;
   KnotPoints[I].BoxSize2  := FKnotPickets.KnotSz;
   KnotPoints[I].BoxAngle := FKnotPickets.KnotA;

   KnotPoints[I].RouteN := -1;
   KnotPoints[I].DropToRoute := false;
   KnotPoints[I].PMethod  := FKnotPickets.PktMethod.ItemIndex;
   KnotPoints[I].NameKind := FKnotPickets.pkt_NameKind1;
   KnotPoints[I].Lx   := FKnotPickets.pkt_Lx;
   KnotPoints[I].Ly   := FKnotPickets.pkt_Ly;
   KnotPoints[I].Lmax := FKnotPickets.pkt_Lmax;
   KnotPoints[I].NameKind2 := FKnotPickets.pkt_NameKind2;
   KnotPoints[I].DropToRoute := false;
   KnotPoints[I].StepOut :=  FKnotPickets.pkt_N;

   FKnotList.RefreshKnotList;
   FKnotList.AllKnots.ClearSelection;
   FKnotList.AllKnots.Selected[FKnotList.AllKnots.Items.Count-1] := true;
   FKnotList.AllKnots.OnClick(nil);
   FKnotList.EditKn.Click;
   NoNewKnots.Click;

 //  KnotPoints[I].RouteAngle := pi/2;


   if not FKnotPickets.Inited then
   begin
     FKnotPickets.Inited := true;
     SetKnPts.Click;
   end;

     
   SaveCtrlZ;
end;

procedure TMapFm.MenuItem4Click(Sender: TObject);
begin
  Timer.Enabled := False;

  if OpenerKnots.Execute then
  Begin
    LoadKnots(OpenerKnots.FileName, false);
    if fileexists(OpenerKnots.FileName+'.rts') then
       LoadRoutesfromRTS(OpenerKnots.FileName+'.rts', false, inf[102]);
    SaveCtrlZ;
  End;

 Timer.Enabled := True;
 NoNewKnots.Click;
 FKnotList.RefreshKnotList;
end;

procedure TMapFm.MenuItem5Click(Sender: TObject);
begin
  Timer.Enabled := False;

  if OpenerKnots.Execute then
  Begin
    LoadKnots(OpenerKnots.FileName, true);
    SaveCtrlZ;
  End;

 Timer.Enabled := True;
 NoNewKnots.Click;
 FKnotList.RefreshKnotList;
end;

procedure TMapFm.DoReload4Click(Sender: TObject);
begin
  AddRoutes := false;
  Bm1.Click;
end;

procedure TMapFm.MinShift_Change(Sender: TObject);
begin
 if MinShift.Value > Step.Value then
    MinShift.Value := trunc(Step.Value);
end;

procedure TMapFm.B31Click(Sender: TObject);
begin
  if Length(Markers) > 0 then
  if Not MarkerList.Showing then
  begin
     MarkerList.Show;
     MarkerList.Left := Left + Width  - MarkerList.Width;
     MarkerList.Top  := Top  + ClientHeight - Stats.Height - MarkerList.Height;
  end
    else
      MarkerList.Hide;

  B31.Flat := not MarkerList.Showing;

  if MarkerList.Showing then
    if FKnotList.Showing then
       FKnotList.Close;

  if MarkerList.Showing then
    ClickMode := 31
  else
    ClickMode := 1;
  ModeButtons;
end;

procedure TMapFm.ModeButtons;
var
  i, j:Integer;
begin
  {if ClickMode = 30 then
    if RouteCount < 1 then
       ClickMode := 1;}
       
  for i := 0 to ComponentCount-1  do
   if Components[i] is TSpeedButton  then
      if (TSpeedButton(Components[i]).Name <> 'B' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B0' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B00' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B000' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B0000' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B00000' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B000000' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B0000000' + IntToStr(ClickMode)) and
         (TSpeedButton(Components[i]).Name <> 'B00000000' + IntToStr(ClickMode))
         then
         TSpeedButton(Components[i]).Flat := True
           else
              TSpeedButton(Components[i]).Flat := False;

   if EdWin <> nil then
     EdW.Flat := not EdWin.Showing;



   DopPan4.Visible := false;
   DopPan.Visible :=  (ClickMode=22) or (ClickMode=23) or (ClickMode=24) or
                      (ClickMode = 50)or (ClickMode = 51) or (ClickMode = 30) or
                      (ClickMode = 31);

   DopPan3.Visible := ((ClickMode=27) or (ClickMode=28) or (ClickMode=26) or
                      (ClickMode = 7)) and (FrameCount > 0);
   DopPan2.Visible :=    (ClickMode=25) or (ClickMode=26)
                      or (ClickMode=27) or (ClickMode=28) or (ClickMode=29)
                      or (ClickMode = 7);
                     // or (ClickMode=22) or (ClickMode=24);
   DopPan4.Visible := (ClickMode=25) or (ClickMode=26);
   DopPan5.Visible := (ClickMode=28) or (ClickMode = 7);{or (ClickMode=26)};

   m1.Enabled := not((ClickMode = 50)or(ClickMode = 51));

   DopPan6.Visible := (PC.ActivePageIndex = 5) and (Length(MainTrack) > 0);

   GPan.Visible := ClickMode = 50;
   YPan.Visible := ClickMode = 51;

   KnotPanel.Visible := True;
   KnotPanel.Visible := ClickMode = 30;

   if ClickMode = 30 then
     Canv.PopupMenu := PopupMenu9
   else
   if (ClickMode >= 25) and ( ClickMode <= 29) then
     Canv.PopupMenu := nil
   else
     Canv.PopupMenu := PopupMenu2;

   RouteBoxPan.Visible := true;
   RouteBoxPan.Visible := (ClickMode=24) or (ClickMode=28) or (ClickMode=29);
   RouteBoxPan.Enabled := (ClickMode=24) or (ClickMode=28) or (ClickMode=29);

   RouteBoxPan2.Visible := true;
   RouteBoxPan2.Visible := ClickMode = 41;
   if RouteBoxPan2.Visible then
   begin
     i := RouteBox2.ItemIndex;
     RefreshRouteBox;
     RouteBox2.Items := RouteBox.Items;
     RouteBox2.ItemIndex := i;
   end;

   if KnotPanel.Visible then
   begin
     i := KnotRoutes.ItemIndex;
     RefreshRouteBox;
     KnotRoutes.Items := RouteBox.Items;
     KnotRoutes.ItemIndex := i;

//     DoDoKnots;

     MarkerList.Hide;
     B31.Flat := not MarkerList.Showing;

     if Not FKnotList.Showing then
     if KnotCount > 0 then
     begin
       FKnotList.Show;
       FKnotList.Left := Left + Width - FKnotList.Width;
       FKnotList.Top  := Top  + ClientHeight - Stats.Height - FKnotList.Height;
     end
      else
      begin
        if RouteCount > 0 then
          KnotsNew.Click
        else
        if FrameCount > 0 then
          KnotsNew2.Click
      end;

   end
    else
    begin
      if FKnotList <> nil then
      if FKnotList.Showing then
         FKnotList.Hide;
      NewKnotPanel.Hide;
      NewKnotPanel2.Hide;
      NewKnotPanel3.Hide;
      NewKnotPanel4.Hide;
      if ClickMode <> 7 then
        SetLength(SelectedKnots, 0);
      KnotSettings.Hide;
      if not NewKnotPanel.Visible then
         KillNewKnots;
    end;

   CutPan.Visible := false;

   CutMode := -1;
   SetLength(RouteCutPoints, 0);

   Ruler.Flat := not (ClickMode = 7);
   RulPan.Visible  := (ClickMode = 7) or
                      (((ClickMode=25)or(ClickMode=26))and(RulCreatingLines) );
   RulPan2.Visible :=  RulPan.Visible and not DopRul.Flat;
   ResetRuler;  RulStat;   DoneLine.Visible := (ClickMode=25)or(ClickMode=26);


   if (ClickMode=24) or (ClickMode=28) then
      RouteBoxChange(nil);

   if ClickMode <> 31 then
     if MarkerList<> nil then
       if MarkerList.Showing then
          MarkerList.Close;

   if ClickMode = 41 then
   begin
     DopPan.Visible := RouteBox2.ItemIndex > 0;
     m1.Enabled := false;
   end;

   {if ClickMode = 40 then
   if Length(MainTrack) > 0 then
   begin
        GetCursorPos(SysCurPos);
        PopupMenu12.Popup(SysCurPos.X, SysCurPos.Y);

        //TestColSchm;
   end;  }

   case DegIsDa of
     true: IsDa.Caption := inf[65];
     false: IsDa.Caption := inf[66];
   end;

  KnotsNew.Flat  := not ((NewKnotPanel.Visible) and (NCPC.ActivePageIndex = 0));
  KnotsNew2.Flat := not ((NewKnotPanel.Visible) and (NCPC.ActivePageIndex = 1));

  CheckUndoRedo;
end;

procedure TMapFm.MrkRoutesClick(Sender: TObject);
var I1, I2, I:Integer;
    R :TRoute;  B:boolean;
begin
  if RouteCount < 1 then
     exit;

  Timer.Enabled := False;
  RouteOps.Caption := MrkRoutes.Hint;
  RouteOps.isShowSpin := 0;
  RouteOps.ShowModal;

  if RouteOps.isROk then
  begin

        if RouteOps.RouteBox.ItemIndex > 0 then
        begin
          I1 := RouteOps.RouteBox.ItemIndex - 1;
          I2 := I1;
        end
         else
         begin
           I1 := 0;
           I2 := RouteCount-1;
         end;

        B := RouteOps.CheckBox2.Visible and RouteOps.CheckBox2.Checked;

        for I := I1 to I2 do
           case (RouteOps.CheckBox1.Checked)and(RouteOps.CheckBox1.Enabled) of
              true:  MarksFromRoute(Route[I], RouteOps.Edit1.Text, RouteOps.Edit2.Text, B and (I = RouteCount-1));
              false: MarksFromRoute(Route[I],'', RouteOps.Edit2.Text, B and (I = RouteCount-1));
           end;

     SaveCtrlZ;
  end;

  if MarkerList.Showing then
     MarkerList.RefreshList(true);

  SaveCtrlZ;
  Timer.Enabled := True;
end;

procedure TMapFm.N101Click(Sender: TObject);
begin
 // GoogleZoomDown;
 // StaticText3.Caption := IntToStr(Zooma);
end;

procedure TMapFm.N1Click(Sender: TObject);
begin
  TrackCols := -2;
end;

procedure TMapFm.DopAdd4Click(Sender: TObject);
var I:Integer; B:Boolean;
begin
  AddRoutes := true;

  case TrackMenuKind of
    1:
       if OpenNmea.Execute then
       Begin
          for I := 0 to OpenNmea.Files.Count - 1 do
          begin

          if AddRoutes then
            b := true
            else
              b := i > 0;

            LoadTrackFromNmea(ReductedMainTrack, OpenNmea.Files[I], b);

           end;
       End;


    2:  if OpenTXT.Execute then
      begin
        Timer.Enabled := False;
        SetCurrentDir(MyDir);
        LoadT.FName := OpenTXT.FileName;
        LoadT.FKind := 1;
        LoadT.ShowModal;
        TrackFastFilter(ReductedMainTrack, inf[103]);
        Timer.Enabled := True;
     end;
    3: if OpenRTT.Execute then
     Begin
       if AnsiLowerCase(Copy(OpenRTT.FileName, Length(OpenRTT.FileName)-3,4)) = '.rta' then
         LoadTrackFromRTA(ReductedMainTrack, OpenRTT.FileName, AddRoutes, Inf[123])
       else
        LoadTrackFromRTT(ReductedMainTrack, OpenRTT.FileName, AddRoutes,0, Inf[123]);

     End;

  end;

  TrackFastFilter(ReductedMainTrack, inf[103]);
  SetLength(RedTrack, 0);
  if Length(ReductedMainTrack) > 0 then
     // CompareTracks(MainTrack, ReductedMainTrack);

  DopPan6.Visible := (PC.ActivePageIndex = 5) and (Length(MainTrack) > 0);
  FocusOnTrack(ReductedMainTrack);
  ChoosedTrackPoint := -1;
  AddRoutes := false;

end;

procedure TMapFm.N2Click(Sender: TObject);
begin       
  TrackCols := -1;
  B41.Click;
// GoogleStyle := GoogleMapStyles[1];
// MapFm.StaticText2.Caption := N2.Caption;
end;

procedure TMapFm.N3Click(Sender: TObject);
begin
  TrackCols := -3;
  SetCurrentDir(MyDir);
  FTrackCS.ShowModal;
// GoogleStyle := GoogleMapStyles[2];
// MapFm.StaticText2.Caption := N3.Caption;
end;

procedure TMapFm.N4Click(Sender: TObject);
begin
 // GoogleStyle := GoogleMapStyles[3];
 // MapFm.StaticText2.Caption := N4.Caption;
end;

procedure TMapFm.N81Click(Sender: TObject);
begin
 // GoogleZoomUp;
 // StaticText3.Caption := IntToStr(Zooma);
end;

procedure TMapFm.NavisGalsListlstWGS841Click(Sender: TObject);
begin
  if SaveLst.Execute then
  Begin
    {if fileexists(SaveLst.FileName) then
        if MessageDLG(inf[22] +#13 + SaveLst.FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;}
    SaveLstFile(SaveLst.FileName, True);
  End;
end;

procedure TMapFm.NewKnShiftClick(Sender: TObject);
begin
  NewKnShift.Flat := not NewKnShift.Flat;
  NewKnotPanel3.Visible := not NewKnShift.Flat;
end;

procedure TMapFm.NextSClick(Sender: TObject);
begin
  RotateFrameOrder(True);
end;

procedure TMapFm.OnDeviceCreate(Sender: TObject; Param: Pointer;
  var Handled: Boolean);
var
 Success :Boolean;
begin
 // This variable returns "Success" to Device initialization, so if you
 // set it to False, device creation will fail.
 Success := PBoolean(Param)^;

 Success := InitFontsAndImages;

 PBoolean(Param)^:= Success;
end;

procedure TMapFm.OnShowHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
  if (HintInfo.HintControl is TListBox) then
  Begin
    with HintInfo.HintControl as TListBox do
    begin
      HintInfo.HintPos := HintInfo.HintControl.ClientToScreen(Point(HintX,HintY));
      HintStr := HintStr;
    end;
  End;
  inherited;
end;

procedure TMapFm.OrdWClick(Sender: TObject);
begin
 if RouteCount > 0 then
 begin
  // Timer.Enabled := False;
   OrderW.ShowModal;
   RefreshSelectionArrays;
   ModeButtons;
   Timer.Enabled := True;
 end;
end;

procedure TMapFm.PCChange(Sender: TObject);
begin
   ClickMode := 1;
   MapChoosed := -1;
   RouteAsk :=-1;

   SetLength(SelectedMarkers,0);
   SetLength(SelectedKnots,0);

   ReSize;

   DelAngMarkers;

   Canv.PopupMenu := PopupMenu2;

   GetEdTools;

   if PC.ActivePageIndex = 3 then
   Begin
      if not Edw.Flat then
        EdWin.Show;
   End
    Else
     if EdWin.Showing then
        EdWin.Hide;

   if PC.ActivePageIndex = 2 then
   Begin
      if not B31.Flat then
        MarkerList.Show;
   End
    Else
     if MarkerList.Showing then
        MarkerList.Close;

   if Movep.Showing then
     Movep.Close;

   ModeButtons;
end;


procedure TMapFm.PointPos(_B, _L, _H: Double; var _EX, _EY, _EZ: String);
var cX, cY, cZ, B, L, H :Double;
begin

   if CoordSysN < 0 then
   Begin
     _EX :=  DegToDMS(_B,true,5);
     _EY :=  DegToDMS(_L,false,5);
     _EZ := Format('%.3f',[_H]);
   End
    else
     Begin
       Geo1ForceToGeo2(_B,_L, _H, WGS,
                       CoordinateSystemList[CoordSysN].DatumN, B, L, H);

       DatumToCoordinateSystem(CoordSysN,B,L,H,cX,cY,cZ);

       _EZ := Format('%.3f',[_H]);

       case CoordinateSystemList[CoordsysN].ProjectionType of
          0:begin
             _EX := DegToDMS(cX,true, 5, false);
             _EY := DegToDMS(cY,false,5, false);
          end;
          1:begin
            _EX := Format('%.3f',[cX]);
            _EY := Format('%.3f',[cY]);
            _EZ := Format('%.3f',[cZ]);
          end;
          2..4:begin
            _EX := Format('%n',[cX]);
            _EY := Format('%n',[cY]);
          end;
       end;
     End;

end;

procedure TMapFm.POptionsShow(Sender: TObject);
begin
  Label9.Visible := Length(MapList) > 0;
  Blend.Visible := Label9.Visible;
end;

procedure TMapFm.PrevSClick(Sender: TObject);
begin
  RotateFrameOrder(False);
end;

const SmoothScale = true;

procedure TMapFm.RedoBClick(Sender: TObject);
begin
  LoadCtrlZ(true);

  UndoB.Visible := CtrlZ > 1;
  RedoB.Visible := CtrlShiftZ > 0;
end;

procedure TMapFm.RefreshbtnClick(Sender: TObject);
begin
  GoogleCount :=  0;
  YandexCount :=  0;

  //WaitForZone := true;
  MeanUTMZone;

  //WaitForCenter := true;


  if Length(MainTrack)>0 then
     RecomputeTrack(MainTrack,WaitForZone);

  RecomputeBaseObjects(WaitForZone);

  BasicObjectsScale;
  MeanCenter;

  CheckWFZ;
end;

procedure TMapFm.RefreshKnExamples;
begin
case SetKnNameKind.ItemIndex of
     0: begin
       SetKnTest1.Caption := SetKnName.Text + '_L001_Pkt01';
       SetKnTest2.Caption := SetKnName.Text + '_L001_K1';
     end;
     1: begin
       SetKnTest1.Caption := 'L001_Pkt01';
       SetKnTest2.Caption := 'L001_K1';
     end;
     2: begin
       SetKnTest1.Caption := '001_P01';
       SetKnTest2.Caption := '001_K1';
     end;
     3: begin
       SetKnTest1.Caption := '001_01';
       SetKnTest2.Caption := '001_K1';
     end;
  end;
end;

procedure TMapFm.MeanCenter;
  var C1, C2: TlatLong;
      P, P2 : TMyPoint;
begin
  C1 := TrackMeanBL(MainTrack);
  C2 := BasicObjectsMeanBL;

  if (C1.long = -360)and(C2.Long = -360) then
     exit
       else
         if (C1.long = -360) then
            P := BLToMap(C2)
             else
         if (C2.long = -360) then
            P := BLToMap(C1)
             else
             begin
                P := BLToMap(C1);
                P2 := BLToMap(C1);
                P.x :=  (P.x + P2.x) / 2;
                P.y :=  (P.y + P2.y) / 2;
             end;

  Center := P;
  ShiftCenter.x := Center.x;
  ShiftCenter.y := Center.y;
end;


procedure TMapFm.MeanUTMZone;
  var Z1, Z2:integer;
begin
   Z1 := TrackMeanUTMZone(MainTrack);
   Z2 := BasicObjectsMeanUTMZone;
   if (Z1 = -1) and (Z2 = -1) then
     WaitForZone := true
       else
       Begin
         WaitForZone := false;
         if (Z1 = -1)  then
           MyZone := Z2
            else
              if (Z2 = -1)  then
                MyZone := Z1
                  else
                    MyZone := (Z1+Z2) div 2;
       End;
end;


procedure TMapFm.MeleskButtonClick(Sender: TObject);
var I, j, OldN :Integer;
    L :Double; BL:TlatLong;
    PD :TRoutePosAndDist;
    S :TStringList;
    s1, s2, s3, fn: string;
begin

  if (Length(Markers) = 0) or (RouteCount = 0) then
    exit;

  S := TStringList.Create;

  OldN := Length(Markers);

  for I := 0 to OldN - 1 do
  begin
    PD := PosAndDistToRoute(Markers[I].x,  Markers[I].y, 0);
          // GetPosAndDist(Route[0].x1, Route[0].y1, Route[0].x2, Route[0].y2,
          //              Markers[I].x,  Markers[I].y);     xvxv
    L := PD.DistToV0;
    s3 := 'Track';
    if Pos('pv', AnsiLowerCase(Markers[I].MarkerName)) = 1 then
        s3 := '#Comments';
    S.Add(s3 + #$9 + FormatFloat('0.000', Markers[I].HGeo)
                                + #$9 + FormatFloat('0.000', L/1000)+ #$9 + Markers[I].MarkerName);

    BL := MapToBL(PD.x, PD.y);
    AddMarker(Markers[I].MarkerName, BL.lat, BL.long, 0, Markers[I].HGeo, 0);
  end;

  if SaveGPX.Execute() then
     SaveGPXFile(SaveGpx.FileName, OldN, true);
  SetLength(Markers, OldN);


  SetCurrentDir(MyDir);
  s1 := 'Tmp\Prof.txt';
  s2 := 'Data\Graph\'+Lang+'\Prof.chs';
  s3 := ' -l_Data\Graph\'+Lang+'.txt -thick -menu -rnav -comments -cg -readonlyplus -n -gray -flat';

  S.SaveToFile(s1);
  {if SaverTXT.Execute() then
  Begin
    fn := SaverTXT.FileName;
    if Ansilowercase(Copy(fn, Length(fn)-3,4)) <> '.txt' then
      fn := fn + '.txt';
    if not fileexists(fn) then
      S.SaveToFile(fn)
    else
    if MessageDLG(inf[22] +#13 + fn, MtConfirmation, mbYesNo, 0) = 6 then
      S.SaveToFile(fn);
  End;  }
  

  winexec(PChar('Graph.exe '+s1+' '+s2+ ' ' +s3),sw_restore);

  S.Destroy;

/////
end;

procedure TMapFm.RefreshRouteBox;
var I: integer;
begin
    RouteBox.Items.Clear;
    RouteBox.Items.Add(inf[27]);
    for I := 0 to RouteCount - 1 do
      RouteBox.Items.Add(Route[I].Name);

    RouteBox.ItemIndex := 0;

    RouteBoxPan.Visible := (ClickMode=24) or (ClickMode=28);
    RouteBoxPan.Enabled := (ClickMode=24) or (ClickMode=28);

  //  EditRouteN :=  -1;
end;                                       

procedure TMapFm.RenameRoute;
var I: integer;
begin
  if (SelectedRouteN < 0) or (SelectedRouteN > RouteCount-1) then
     exit;

  Timer.Enabled := false;
  Namer.Edit1.Text := Route[SelectedRouteN].Name;
  Namer.ShowModal;
  if Namer.isOk then
  Begin
    Route[SelectedRouteN].Name := Namer.Edit1.Text;
    I := RouteBox.ItemIndex;
    RefreshRouteBox;
    RouteBox.ItemIndex :=  I;
    if Edwin.Showing then
       Edwin.ReFreshTree;
    SaveCtrlZ;
  End;

  //if not(OrderW.Showing) then
    Timer.Enabled := true;

end;

procedure TMapFm.RenderEvent(Sender: TObject);
var I:integer;
    NativeLabels:Boolean;
begin
  if not SmoothScale then
  Begin
     Scale  := TMashtab[Mashtab]/100;
     _Scale := Scale;

     Center.y := Center.y + MKeyShift.Y*Scale;
     Center.x := Center.x + MKeyShift.x*Scale;
     MKeyShift.Y := 0;
     MKeyShift.X := 0;

     fi := _fi;
  End
     else
        AxcelScale(Timer.Delta);



  NativeLabels :=  not ( (PC.ActivePageIndex = 1) or
                    ((ClickMode >= 21)and(ClickMode <= 30)or(ClickMode = 31)) or
                    ((PC.ActivePageIndex = 5)and(ClickMode = 41)) );


  if ShowMaps then
     DrawMaps(AsphCanvas,AsphMapImages, Timer.Delta);

  if DoDrawLines then
     DrawLines(AsphCanvas, LinesColor, Smooth);

  if PC.ActivePageIndex = 1 then
     FrameLeadSide(ChoosedColor);

  DrawBase(AsphCanvas, AsphImages, DopObjColor);

  if PC.ActivePageIndex = 3 then
     DrawRoutesEd(AsphCanvas, ClickMode, ChoosedColor, ObjColor, ObjColor,
                  DopObjColor, FntColor, IntColor, LinesColor,
                  Smooth, RouteBox.ItemIndex-1, DrawAll, Lstyle)
     Else
     if (PC.ActivePageIndex = 5)and(ClickMode = 41) then
     Begin
        DrawRoutesEd(AsphCanvas, ClickMode, ChoosedColor, ObjColor, ObjColor,
                  DopObjColor, FntColor, IntColor, LinesColor,
                  Smooth, RouteBox2.ItemIndex-1,
                  DrawAll, Lstyle)
     End
       Else
        DrawRoutes(AsphCanvas, ChoosedColor, ObjColor, ObjColor, DopObjColor,
            FntColor, IntColor, LinesColor, Smooth, DrawAll, Lstyle, NativeLabels);
                                {ChoosedColor, RoutesColor, DoneColor, FrameColor}

  if (PC.ActivePageIndex <> 5)  then
    DrawMarkers(AsphCanvas, AsphImages, DopObjColor, FntColor, IntColor, ObjColor, RedTrackColor,
                DrawAll, Lstyle, NativeLabels, PC.ActivePageIndex = 2, Smooth);
                                                                         
  if (PC.ActivePageIndex = 1)or(ClickMode = 23) or(ClickMode = 29) or(ClickMode = 31) then
     DrawAllLabels(false, false, FntColor,  IntColor, ChoosedColor, DrawAll,
        LStyle, ClickMode);

  if (ClickMode = 24)or(ClickMode = 28)or(ClickMode = 26) then
     DrawAllLabels(true, false, FntColor,  IntColor, ChoosedColor, DrawAll,
       LStyle, ClickMode);

  if (ClickMode = 22)or(ClickMode = 27)or(ClickMode = 21)or(ClickMode = 25)then
     DrawAllLabels(true, true, FntColor,  IntColor, ChoosedColor, DrawAll,
        LStyle, ClickMode);
  //   DrawFrameLabels(FntColor,IntColor, DrawAll, LStyle);

  if ClickMode = 50 then
  Begin
    DrawGoogle(AsphCanvas,AsphImages);

    if GetGoogleCursor(CanvCursorBL.Lat, CanvCursorBL.Long) then
      DrawGoogleCursor(AsphCanvas, AsphImages);
  End;

  if ClickMode = 51 then
  Begin
    DrawYandex(AsphCanvas,AsphImages);

    if GetYandexCursor(CanvCursorBL.Lat, CanvCursorBL.Long) then
      DrawYandexCursor(AsphCanvas, AsphImages);
  End;

  if ClickMode = 29 then
    DrawCuttingPlane(FntColor, Smooth, InfCut.Checked);

  if (ClickMode = 30) or (RulerLoops and (ClickMode = 7)) then       
  begin
    if MultiSelectMode > 0 then
      DrawKnots(RedTrackColor, ChoosedColor, ChoosedColor, IntColor, FntColor,
        LStyle, Smooth, CanvCursorBL0, CanvCursorBL, DrawAll, not ShowPkts.Flat)
    else
      DrawKnots(RedTrackColor, ChoosedColor, ChoosedColor, IntColor, FntColor,
        LStyle, Smooth, CanvCursorBL, CanvCursorBL, DrawAll, not ShowPkts.Flat);
  end;

  if ClickMode = 31 then
  begin
    DrawChoosedMarker(ChoosedColor, PC.ActivePageIndex = 2);
    if MultiSelectMode > 0 then
      DrawMarkersToChoose(CanvCursorBL0, CanvCursorBL)
    else
      DrawMarkersToChoose(CanvCursorBL, CanvCursorBL)
  end;

  if PC.ActivePageIndex = 4 then
  Begin
     if imiAnim.Checked then
       DrawImitGPS(AsphCanvas, ChoosedColor, DopObjColor, Smooth, Ticks, TrackArrowsEnabled)
         else
           DrawImitGPS(AsphCanvas, ChoosedColor, ChoosedColor, Smooth, -1, TrackArrowsEnabled);
  End;

 if PC.ActivePageIndex = 5 then
 Begin

    if ClickMode = 41 then
      I:= RouteBox2.ItemIndex-1
    else
      if ClickMode = 40 then
        I :=  TrackCols
      else
          I := -2;

    DrawTrack(MainTrack, AsphCanvas, AsphImages, TrackColor, RedTrackColor,
                LinesColor, false, True, 5, Smooth, I);

    DrawMarkers(AsphCanvas, AsphImages, DopObjColor, FntColor, IntColor,
        ObjColor, RedTrackColor, DrawAll, Lstyle, True, PC.ActivePageIndex = 2,  Smooth);

    if (ClickMode >= 40) and (ClickMode < 50) then
    DrawTrackInfo(MainTrack, AsphCanvas, AsphImages, AsphFonts, TrackColor,
                  IntColor, InfoColor, RedTrackColor, FntColor, LinesColor, ObjColor,
                  CanvCursor.X, CanvCursor.Y, I, MultiSelectMode, Smooth);
 End;

 if (ClickMode = 7) or (RulPan.Visible) then
    DrawRuler(BLToScreen(CanvCursorBL.Lat, CanvCursorBL.Long),ChoosedColor,
                          FntColor, IntColor, Ticks, Smooth, DrawAll, ClickMode<>7,
                          (ShowAzmt.Checked or ShowDA.Checked), ShowAzmt.Checked,
                          ShowLength.Checked);



 ScaleLine(AsphCanvas,  inf[40], inf[41], 0, IntColor, FntColor);
 NordDirection(AsphCanvas, false, true, inf[40], inf[41], 0, IntColor, FntColor,
           ArKind, AlwaysN);

 if ClickMode = 40 then
   if TrackCols = -3 then
     TrackScale(AsphCanvas, 0, IntColor, FntColor);

 DrawSubCursor(ObjColor, DopObjColor, ChoosedColor, Ticks);
 
end;

procedure TMapFm.ResetMs;
var i,j :integer;
begin
 for j := 1 to 5  do
 for i := 0 to ComponentCount-1  do
   if Components[i] is TSpeedButton  then
      if (TSpeedButton(Components[i]).Name = 'm' + IntToStr(j))
         then
           TSpeedButton(Components[i]).Flat := true;
end;

procedure TMapFm.RtopsClick(Sender: TObject);
begin
  if Length(MainTrack)>1 then
  begin
    Timer.Enabled := False;
    FrOps.Date1.Date := trunc(MainTrack[0].T);
    FrOps.Time1.Time := MainTrack[0].T
                         - trunc(MainTrack[0].T);
    FrOps.Date2.Date := trunc(MainTrack[Length(MainTrack)-1].T);
    FrOps.Time2.Time := MainTrack[Length(MainTrack)-1].T
                         - trunc(MainTrack[Length(MainTrack)-1].T);
    FROps.ShowModal;
    Timer.Enabled := True;
  end;
end;

procedure TMapFm.RttClick(Sender: TObject);

begin
  if OpenRTT.Execute then
  Begin
    if AnsiLowerCase(Copy(OpenRTT.FileName, Length(OpenRTT.FileName)-3,4)) = '.rta' then
    LoadTrackFromRTA(MainTrack, OpenRTT.FileName, AddRoutes, Inf[123])
    else
      LoadTrackFromRTT(MainTrack, OpenRTT.FileName, AddRoutes,0, Inf[123]);
    TrackFastFilter(MainTrack, inf[103]);
    SetLength(RedTrack, 0);
    SetLength(ReductedMainTrack, 0);

    if Length(MainTrack) > AskTrackTreshold then
      if MessageDlg(inf[122], mtConfirmation, mbYesNo, 0) = 6 then
      begin
         Timer.Enabled := false;
         FReduceTrack.ShowModal;
         Timer.Enabled := true;
      end;

    FocusOnTrack(MainTrack);
    ChoosedTrackPoint := -1;
    B41.Click;
    AddRoutes := false;
  End;

//  DopPan6.Visible := (PC.ActivePageIndex = 5) and (Length(MainTrack) > 0);
 // DopPan7.Visible := not WaitForZone;

end;

procedure TMapFm.RttMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var CP:TPoint;
begin
  AddRoutes := false;
  TrackMenuKind := 3;
  GetCursorPos(CP);
  if Button = mbRight then
     Popupmenu8.Popup(CP.X, CP.Y);
end;

procedure TMapFm.RttSaveClick(Sender: TObject);
var FileName :string;
    ext:  string;
begin
 if SaveRTT.Execute then
 begin
    FileName := SaveRTT.FileName;
    ext := '.rtt';
    if (RouteCount > 0) or (FrameCount > 0) then
      if MessageDLG(inf[84], MtConfirmation, mbYesNo, 0) = 6 then
        ext := '.rta';

    if AnsiLowerCase(Copy(FileName, Length(FileName)-3,4)) <> ext then
       FileName := FileName + ext;
    if fileexists(FileName) then
        if MessageDLG(inf[22] +#13 + FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;

    SaveRTTFile(MainTrack, FileName, ext = '.rta')


 end;
end;

procedure TMapFm.RouteBoxChange(Sender: TObject);
begin
  if RouteCount <= 0 then
    exit;

  if Edwin.Showing then
     Edwin.ReFreshTree;

  if ClickMode = 29 then
     GetCuttingPoints(RouteBox.ItemIndex-1, InfCut.Checked);

  RefreshSelectionArrays;

  if ClickMode = 41 then
  begin
    DopPan.Visible := RouteBox2.ItemIndex > 0;
    m1.Enabled := false;

    MultiSelectMode := 0;
    m2.Flat := true;
    m3.Flat := true;
  end;
end;

procedure TMapFm.RTableClick(Sender: TObject);
begin
 if Length(MainTrack) < 1 then
      exit;
  Timer.Enabled := False;
  FRList.RefreshList;
  FRList.ShowModal;
  Timer.Enabled := True;
end;

procedure TMapFm.RulerClick(Sender: TObject);
begin
  if ClickMode <> 7 then
     ResetRuler;
  RulStat;

  RulerLoops := ClickMode = 30;
 // if RulerLoops then
 //   SetLength(SelectedKnots, 0); 
  ClickMode := 7;
  ModeButtons;
end;

procedure TMapFm.RulResetClick(Sender: TObject);
begin
  ResetRuler;
  case ClickMode of
    25: FrameCount :=0;
    26: Dec(RouteCount);
    7: if RulerLoops then
       begin
          ClickMode :=30;
          if FKnotList <> nil then
              FKnotList.RefreshKnotList;
       end;
  end;

  if ClickMode <> 30 then
    ClickMode := 1;

  ModeButtons;
end;

procedure TMapFm.RulStat;
begin
   RecomputeRuler(ClickMode);

   if Rulcount > 0 then
   begin
        Rlength.Caption := Format('%.3n',[RulFullLength]);
        RElllength.Caption := Format('%.3n',[RulFullElLength]);
   end
     else
        begin
          Rlength.Caption := '-';
          RElllength.Caption := '-';
        end;
        
       RCount.Caption := IntToStr(RulCount);

end;

procedure TMapFm.SaveCtrlZ;
var S :TStringList;
    i, j :integer;
begin
   if (FrameCount <= 1) and (RouteCount <= 0) and(Length(Markers)=0)and(KnotCount = 0) then
       exit;

   FrameToGeo;
   RoutesToGeo;
   RecomputeRoutes(WaitForZone);

   S := TStringList.Create;

   SetCurrentDir(MyDir);
   S.SaveToFile(TmpDir+'Back'+intToStr(CtrlZ));
   S.SaveToFile(TmpDir+'Back'+intToStr(CtrlZ)+'.mark');
   S.SaveToFile(TmpDir+'Back'+intToStr(CtrlZ)+'.rnk');

   SaveRTSFile(TmpDir+'Back'+intToStr(CtrlZ), false);
   SaveMarkers(TmpDir+'Back'+intToStr(CtrlZ)+'.mark', false);
   SaveKnots(TmpDir+'Back'+intToStr(CtrlZ)+'.rnk', false);
   S.Add(IntToStr(ClickMode));
   case ClickMode of
      21, 22:
         for I := 0 to Length(SelectedFramePoints) - 1 do
           if SelectedFramePoints[I] then
              S.Add(IntToStr(I));
      23, 24:
         for I := 0 to Length(SelectedRoutePoints) - 1 do
         for J := 0 to Length(SelectedRoutePoints[I]) - 1 do
           if SelectedRoutePoints[I][J] then
              S.Add(IntToStr(I)+' '+IntToStr(J));
     30: for I := 0 to Length(SelectedKnots) - 1 do
             S.Add(IntToStr(SelectedKnots[I]));
     31: for I := 0 to Length(SelectedMarkers) - 1 do
             S.Add(IntToStr(SelectedMarkers[I]));

   end;

   S.SaveToFile(TmpDir+'Back'+intToStr(CtrlZ)+'.rt_');

   inc(CtrlZ);
   CtrlShiftZ := 0;

   CheckUndoRedo;

  // DopPan7.Visible := not WaitForZone;
   
   S.Free;
end;

procedure TMapFm.SaveRoutesTXT;
begin
  if SaverTXT.Execute then
  Begin
    Timer.Enabled  := False;
    SaveTXTFm.SaveTXTName := SaveRTXT.FileName;
    SaveTXTFm.SaveKind := 0;

    SaveTXTFm.ShowModal;
    Timer.Enabled  := True;
  End;
end;

procedure TMapFm.SaveScreen(FN: string);
var B: TBitMap;
    J: TJpegImage;
begin
 if AnsiLowerCase(Copy(FN, Length(FN)-3,4))<>'.jpg' then
       FN := FN +'.jpg';

  B := TBitMap.Create;
  B.Width := Canv.Width;
  B.Height := Canv.Height;
  B.Canvas.CopyRect(Rect(0,0,B.Width,B.Height), Canvas,
                    Rect(Canv.Left, Canv.Top, Canv.Left + B.Width, Canv.Top + B.Height));

  J:= TJpegImage.Create;
  J.Assign(B);
  J.CompressionQuality := 100;
  J.Compress;
  J.SaveToFile(FN);
  J.Free;
  B.SaveToFile(TmpDir+'screen.bmp');
  B.Free;
end;

procedure TMapFm.SaveSettings(FileName: String);
var S: TStringList;
begin
  SetCurrentDir(MyDir);
  S := TStringList.Create;

  try
    S.Add(GoogleKey);
    S.SaveToFile('Data\GoogleKey.txt');

    S.Clear;
    if fileexists(FileName) then
    begin
      with SetFm Do
      begin
         S.Add(ColorToString(BackGroundColor.Brush.Color));
         S.Add(ColorToString(LinesColor.Brush.Color));
         S.Add(ColorToString(ChoosedColor.Brush.Color));
         S.Add(ColorToString(DopObjColor.Brush.Color));
         S.Add(ColorToString(ObjColor.Brush.Color));
         S.Add(ColorToString(IntColor.Brush.Color));
         S.Add(ColorToString(InfoColor.Brush.Color));
         S.Add(ColorToString(TrackColor.Brush.Color));
         S.Add(ColorToString(RedTrackColor.Brush.Color));
         S.Add(ColorToString(FntColor.Brush.Color));
      end;

      S.SaveToFile(FileName);
    end;

  except
  end;
 S.Free; 
end;

procedure TMapFm.ScreenShotClick(Sender: TObject);
begin
  if SaveJPG.Execute then
    SaveScreen(SaveJPG.FileName);
end;

procedure TMapFm.SetM(N: Integer);
var i,j :integer;
begin
 for j := 1 to 4  do
 for i := 0 to ComponentCount-1  do
   if Components[i] is TSpeedButton  then
      if (TSpeedButton(Components[i]).Name = 'm' + IntToStr(j))
         then
         begin
           if J=N then
             TSpeedButton(Components[i]).Flat := false
           else
             TSpeedButton(Components[i]).Flat := true;
         end;
           
end;

procedure TMapFm.SetRtH;
var RtH: Double; S:String; I,j:Integer;
begin


  if length(SelectedRoutePoints) > 0 then
    for I := RouteCount-1 DownTo 0 do
    for J := Length(Route[I].WPT)-1 DownTo 0 do
    try
      if i < length(SelectedRoutePoints) then
         if j < length(SelectedRoutePoints[I]) then
              if SelectedRoutePoints[I][J] then
               begin
                   RtH := GetRoutePointA(I,J);
                   break;
                 // Route[I].WPT[J].x := Route[I].WPT[J].x + E;
                 // Route[I].WPT[J].y := Route[I].WPT[J].y + N;
               end;

    except
      RtH := 0;
    end;


     if length(SelectedRoutePoints) > 0 then
    for I := RouteCount-1 DownTo 0 do
    for J := Length(Route[I].WPT)-1 DownTo 0 do
    try
      if i < length(SelectedRoutePoints) then
         if j < length(SelectedRoutePoints[I]) then
              if SelectedRoutePoints[I][J] then
               begin
                   RtH := GetRoutePointA(I,J);
                   break;
               end;

    except
    end;


    s := Format('%.3f', [RtH]);
    if InputQuery(inf[254], inf[254], s) then

    if length(SelectedRoutePoints) > 0 then
    for I := RouteCount-1 DownTo 0 do
    for J := Length(Route[I].WPT)-1 DownTo 0 do
    try
      if i < length(SelectedRoutePoints) then
         if j < length(SelectedRoutePoints[I]) then
              if SelectedRoutePoints[I][J] then
                 SetRoutePointA(I,J, StrToFloat2(s));

    except
    end;

    SaveCtrlZ;
end;

procedure TMapFm.SetSStep_Change(Sender: TObject);
var I:Integer;
begin
 if NotChangeKnot then
     exit;

  for I  := 0 to Length(SelectedKnots) - 1 do
  try
     KnotPoints[SelectedKnots[I]].ShStep := SetSStep.Value;
  except
  end;

  SaveCtrlZ;
  SetSStep.Font.Color := clWindowText;
end;

procedure TMapFm.SetSStep_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
    SetSStep_.OnChange(nil);
end;

procedure TMapFm.ShiftSelected(N, E: Real);
begin
  case ClickMode of
        21,22: if FrameCount > 1 then
            if SelectedFramePointsCount > 0 then
                ShiftSelectedFramePoints(N, E);

        23,24: if SelectedRoutePointsCount > 0 then
                   ShiftSelectedRoutePoints(N, E);

        30: ShiftSelectedKnot(N, E);

        31: ShiftSelectedMarker(N, E);
  end;

  SaveCtrlZ;
end;

procedure TMapFm.ShowAzmtClick(Sender: TObject);
begin
  if ShowAzmt.Checked then
     ShowDA.Checked := false;
end;

procedure TMapFm.ShowCurPos;
var cX, cY, cZ, B, L, H :Double;
begin

   if CoordSysN < 0 then
   Begin
     EX.Caption :=  DegToDMS(CanvCursorBL.Lat,true,5);
     EY.Caption :=  DegToDMS(CanvCursorBL.Long,false,5);
   End
    else
     Begin
       Geo1ForceToGeo2(CanvCursorBL.Lat,CanvCursorBL.Long,0, WGS,
                       CoordinateSystemList[CoordSysN].DatumN, B, L, H);

       DatumToCoordinateSystem(CoordSysN,B,L,H,cX,cY,cZ);

       if EZ.Visible then
       if CoordinateSystemList[CoordsysN].ProjectionType <> 1 then       
       Begin
         EZ.Hide;
         CSys.Left := EY.Left + EY.Width + 5;
       End;


       case CoordinateSystemList[CoordsysN].ProjectionType of
          0:begin
             EX.Caption := DegToDMS(cX,true, 5, false);
             EY.Caption := DegToDMS(cY,false,5, false);
          end;
          1:begin
            EX.Caption := Format('%.3f',[cX]);
            EY.Caption := Format('%.3f',[cY]);
            EZ.Caption := Format('%.3f',[cZ]);
            EZ.Show;
            CSys.Left := EZ.Left + EZ.Width + 5;
          end;
          2..4:begin
            EX.Caption := Format('%n',[cX]);
            EY.Caption := Format('%n',[cY]);
          end;
       end;
     End;

end;

procedure TMapFm.ShowDAClick(Sender: TObject);
begin
   if ShowDA.Checked then
     ShowAzmt.Checked := false;
end;

procedure TMapFm.ShowNewAreaKnotsClick(Sender: TObject);
begin
  JumpToRoutesMap(-3);
end;

procedure TMapFm.ShowNewKnotsClick(Sender: TObject);
begin
  JumpToRoutesMap(KnotRoutes.ItemIndex-1);
end;

procedure TMapFm.ShowPktsClick(Sender: TObject);
begin
  ShowPkts.Flat := not ShowPkts.Flat;
  if FKnotPickets.Inited = false then
  begin
    InitKnots(NCPC.ActivePageIndex);
    KnotSize_Change(nil);
  end;
  FKnotPickets.Inited := true;
end;

procedure TMapFm.SpeedButton10Click(Sender: TObject);
var B:Boolean;
begin
  if Length(Markers) < 1 then
     exit;
  
  b := true;
  if (MarkersAreLoops) and (Melesk = false) then
    if MessageDLG(inf[121], MtConfirmation, mbYesNo, 0) = 6 then
    begin
      b := false;
      SaveKnotMarkers.Click;
    end;

  if b then
  if SaverMarks.Execute then
  Begin
    Timer.Enabled  := False;


      if {AnsiLowerCase(Copy(SaveR2.FileName, Length(SaveR2.FileName)-4,5))='.mark'}
         MarkFmt <= 1 then
       SaveMarkers(SaverMarks.FileName, true)
         else
         if MarkFmt = 2 then
         begin
         //  if MessageDLG(inf[18], MtConfirmation, mbYesNo, 0) = 6 then
         //  begin
             SaveTXTFm.SaveTXTName := SaverMarks.FileName;
             SaveTXTFm.SaveKind := 1;
             SaveTXTFm.ShowModal;
         //  end
         //    else
         //       SaveMarkers(SaverMarks.FileName, true);
         end
         else
           SaveGPXFile(SaverMarks.FileName, true);

    Timer.Enabled  := True;
  End;
end;

procedure TMapFm.SMoveKnClick(Sender: TObject);
begin
  Movep.Show;
  Movep.Top   := Top - (ClientHeight - Height) + Tools.Height - 5;
  Movep.Left  := Left - (ClientWidth - Width) div 2 + 3;
  Movep.Top   := Movep.Top + KnotSettings.Height + 10;
end;

procedure TMapFm.SOkKnClick(Sender: TObject);
begin
  SaveCtrlZ;
  NotChangeKnot := false;
  SetKnL.OnChange(nil);
  if SetKnName.Font.Color = clWindowText then
     SetKnName.OnChange(nil);
  if SetKnNameKind.Font.Color = clWindowText then
     SetKnNameKind.OnChange(nil);
  if SetKnSize.Font.Color = clWindowText then
     SetKnSize.OnChange(nil);
  if SetKnSize2.Font.Color = clWindowText then
     SetKnSize2.OnChange(nil);
  if SetKnAng.Font.Color = clWindowText then
     SetKnAng.OnChange(nil);
  if SetSStep.Font.Color = clWindowText then
     SetSStep.OnChange(nil);
  KnotSettings.Hide;
  if FKnotList <> nil then
    FKnotList.RefreshKnotList;
end;

procedure TMapFm.SpeedButton12Click(Sender: TObject);
begin
  Imitate(imiStep.Value,imiRad.Value,imiRandom.Value,imiSwicth.Checked);
end;

procedure TMapFm.SpeedButton13Click(Sender: TObject);
var S: String;
begin
  if SaveGPS.Execute then
  Begin
    S := SaveGps.FileName;
    if AnsiLowerCase(Copy(S, Length(S)-3,4))<>'.gps' then
       S := S +'.gps';
    if fileexists(S) then
    Begin
       if MessageDLG(inf[22] +#13 + S, MtConfirmation, mbYesNo, 0) = 6 then
          SaveImitGPS(S);
    End
      Else
        SaveImitGPS(S);

  End;
end;

procedure TMapFm.SaveKnotMarkersClick(Sender: TObject);
begin
//  FSaveKnots.doP.Enabled := False;
  if Length(Markers) > 0 then
     FSaveKnots.Exp.Click;
end;

procedure TMapFm.SaverMarksTypeChange(Sender: TObject);
begin
  MarkFmt := SaverMarks.FilterIndex;
//  showmessage(inttostr(MarkFmt));
end;

procedure TMapFm.SetKnPtsClick(Sender: TObject);
begin
  uKnotPickets.KnotSize.Value := SetKnSize.Value;
  uKnotPickets.KnotSize2.Value := SetKnSize2.Value;
  uKnotPickets.SetKnAng.Value := SetKnAng.Value;
  FKnotPickets.KnotN := SelectedKnots[0];
  uKnotPickets.Lmax.Value := KnotPoints[SelectedKnots[0]].Lmax;
  //FKnotPickets.KnotAngRoute.Checked := KnotAngRoute.Checked;
 // FKnotPickets.KnotAngAdd.Checked := KnotAngAdd.Checked;
  FKnotPickets.KnotShape := KnotPoints[SelectedKnots[0]].Shp;
  FKnotPickets.Knk.ItemIndex := SetKnNameKind.ItemIndex;
  FKnotPickets.TestName := SetKnName.Text;
  FKnotPickets.TestL := SetKnL.Value;
  FKnotPickets.HideRt := true;
  FKnotPickets.pkt_cx := KnotPoints[SelectedKnots[0]].cx;
  FKnotPickets.pkt_cy := KnotPoints[SelectedKnots[0]].cy;
  FKnotPickets.RenewKnotBox;
  FKnotPickets.Drop2.Checked := not KnotPoints[SelectedKnots[0]].DropToRoute;
  FKnotPickets.RefreshTmps;

  if KnotPoints[SelectedKnots[0]].RouteAngle < 0 then
     KnotPoints[SelectedKnots[0]].RouteAngle := 2*pi + KnotPoints[SelectedKnots[0]].RouteAngle;

  uKnotPickets.SetRtAng.Value := round(1000*KnotPoints[SelectedKnots[0]].RouteAngle*180/pi)/1000;
  FKnotPickets.a4.Value := KnotPoints[SelectedKnots[0]].StepOut;

  FKnotPickets.pkt_RouteA := KnotPoints[SelectedKnots[0]].RouteAngle;
  FKnotPickets.PktMethod.ItemIndex := KnotPoints[SelectedKnots[0]].PMethod;
  case KnotPoints[SelectedKnots[0]].PMethod of
     0: begin
       FKnotPickets.Rdrop.Checked := KnotPoints[SelectedKnots[0]].DropToRoute;
       if KnotPoints[SelectedKnots[0]].RouteN = -1 then
       begin
         FKnotPickets.RouteBox.ItemIndex := 0;
         FKnotPickets.Rdrop.Checked := false;
       end
       else
         FKnotPickets.RouteBox.ItemIndex := KnotPoints[SelectedKnots[0]].RouteN;
       uKnotPickets.l1.Value :=  (KnotPoints[SelectedKnots[0]].Lx);
       FKnotPickets.iHalf.Checked := (KnotPoints[SelectedKnots[0]].Ly <> 0);
       
     end;
     1: begin
       uKnotPickets.l2x.Value :=  (KnotPoints[SelectedKnots[0]].Lx);
       uKnotPickets.l2y.Value :=  (KnotPoints[SelectedKnots[0]].Ly);
     end;
     2: begin
        uKnotPickets.l3.Value := (KnotPoints[SelectedKnots[0]].Lx);
        uKnotPickets.a3.Value := (KnotPoints[SelectedKnots[0]].Ly);
        FKnotPickets.DoRang.Checked  := KnotPoints[SelectedKnots[0]].DropToRoute;
        FKnotPickets.DontRang.Checked  := not KnotPoints[SelectedKnots[0]].DropToRoute;
     end;
     3: begin
        uKnotPickets.l4x.Value :=  (KnotPoints[SelectedKnots[0]].Lx);
        uKnotPickets.l4y.Value :=  (KnotPoints[SelectedKnots[0]].Ly);
     end;
     4: begin
        uKnotPickets.Scale5.Value :=  (KnotPoints[SelectedKnots[0]].Lx);
        uKnotPickets.a5.Value := (KnotPoints[SelectedKnots[0]].Ly);
        FKnotPickets.PktTemplates.ItemIndex := KnotPoints[SelectedKnots[0]].StepOut;
        FKnotPickets.Drop5.Checked := KnotPoints[SelectedKnots[0]].DropToRoute;
     end;
  end;
  FKnotPickets.MainPC.ActivePageIndex := 0;
  FKnotPickets.ShowModal;
end;

procedure TMapFm.SCancelKnClick(Sender: TObject);
begin
  KnotSettings.Hide;
  LoadKnots(TmpDir+'TmpKnots.rnk', false);
  if FKnotList <> nil then
    FKnotList.RefreshKnotList;
end;

procedure TMapFm.SViewKnClick(Sender: TObject);
begin
  FKnotList.ViewKn.Click;
end;

procedure TMapFm.NoNewKnotsClick(Sender: TObject);
begin
//  ClickMode := 0;
  NewKnotPanel.Visible := False;
  NewKnotPanel2.Visible := False;
  NewKnotPanel3.Visible := False;
  NewKnotPanel4.Visible := False;
  ModeButtons;
  KillNewKnots;

  if KnotCount > 0  then
    FKnotList.Show
  else
     begin
      ClickMode := 1;
      ModeButtons;
     end;
end;

procedure TMapFm.MarkFrameClick(Sender: TObject);
begin

  if Length(Markers) < 1 then
     exit;

  if FrameCount > 0 then
   if MessageDlg(inf[26], mtConfirmation, [mbYes, mbNo], 0) <> 6 then
    exit;

  Timer.Enabled := false;
  MarkerOps.isFrame := true;
  MarkerOps.ShowModal;

  SaveCtrlZ;
  Timer.Enabled := true;
end;

procedure TMapFm.DoneLineClick(Sender: TObject);
begin

  case ClickMode of
     25: begin
            ClickMode := 1;
            if FrameCount>2 then
            Begin
             CreateFramePoint(FramePoints[0,2].x, FramePoints[0,2].y);
             Dec(FrameCount);
             RecomputeRoutes(False);
             RefreshSelectionArrays;
             SaveCtrlZ;
             ClickMode := 21;
             ModeButtons;
             EdWin.ReFreshTree;
            End
             else
             Begin
               FrameCount := 0;
               EdWin.ReFreshTree;
             End;
   end;

   26: begin
      DeleteRoutePoint(RouteCount-1,Length(Route[RouteCount-1].WPT)-1);
      SaveCtrlZ;
      ClickMode := 23;
      ModeButtons;
      EdWin.ReFreshTree;
      RefreshRouteBox;
   end;
  end;

  ModeButtons;

  RefreshSelectionArrays;
  ResetMs;
  GetEdTools;
end;

procedure TMapFm.DopRulClick(Sender: TObject);
begin
  DopRul.Flat := not DopRul.Flat;
  RulPan2.Visible := not DopRul.Flat;
end;

procedure TMapFm.DoReaload3Click(Sender: TObject);
begin
  AddRoutes := false;
  
  case TrackMenuKind of
    1: Bnmea.Click;
    2: Btxt.Click;
    3: Rtt.Click;
  end;
end;

procedure TMapFm.Doreload1Click(Sender: TObject);
begin
  AddRoutes := False;
  B4.Click;
end;

procedure TMapFm.DoReload2Click(Sender: TObject);
begin
  AddRoutes := false;
  B6b.Click;
end;

procedure TMapFm.RinfClick(Sender: TObject);
var TrS: TTrackStat;
begin
  if Length(MainTrack) < 1 then
      exit;

  TRs := GetTrackStat(MainTrack);

  Showmessage(inf[77] + Format('%.n',[Trs.TrackL]) + inf[40]
               + #13 + inf[78] + IntToStr(Trs.EpCount)
               + #13 + inf[79] + DateTimeToStr(Trs.MinT)
               + #13 + inf[80] + DateTimeToStr(Trs.MaxT)
               + #13 + inf[81] + IntToStr(Trs.SlipCount)
               + #13 + inf[82] + IntToStr(Trs.EpOnRoutes) + ' ('+IntToStr(Trs.PrOnRoutes)+'%)') ;

end;

procedure TMapFm.AYandexClick(Sender: TObject);
begin
 ResetYandex;
 if YandexCount = 0 then
    begin
      InitYandex(CanvCursorBL.lat, CanvCursorBL.long);
    end;

 DoYAZoom(True);

 YandexMultiAdd := true;
 YandexMultiAddMode := true;
 YandexMultiAddBegin := ScreenToBL(0,0);
 YandexMultiAddEnd :=  ScreenToBL(Canv.Width,Canv.Height);
 DoMultiAddYandex;

 YDownload.Click;
 B6.Click;
end;

procedure TMapFm.Garmingpx1Click(Sender: TObject);
begin
  if SaveGPX.Execute then
  Begin
    {if fileexists(SaveGPX.FileName) then
      if MessageDLG(inf[22] +#13 + SaveGPX.FileName, MtConfirmation, mbYesNo, 0) <> 6 then
         exit; }
    if length(MainTrack)<2 then
      SaveGPXFile(SaveGpx.FileName, true)
       else
         SaveGPXFileWithTrack(SaveGpx.FileName, true);
  End;
end;

procedure TMapFm.GDownLoadClick(Sender: TObject);
begin
  if GoogleCount = 0 then
     exit;
     
  DownloadSelected;
  RefreshST;
  B5.Click;
end;

procedure TMapFm.AGoogleClick(Sender: TObject);
begin
 ResetGoogle;
 if GoogleCount = 0 then
    begin
      InitGoogle(CanvCursorBL.lat, CanvCursorBL.long);
    end;

 DoAZoom(True);
// if (ZoomA > 8)and (ZoomA<>18) then
//  ZoomA := ZoomA -2;
 GoogleMultiAdd := true;
 GoogleMultiAddMode := true;
 GoogleMultiAddBegin := ScreenToBL(0,0);
 GoogleMultiAddEnd :=  ScreenToBL(Canv.Width,Canv.Height);
 DoMultiAddGoogle;

 {
 RefreshST;
 B50.Click;  }
  GDownload.Click;
  B5.Click;
end;

procedure TMapFm.GResetClick(Sender: TObject);
begin
 ResetGoogle;
 RefreshST;
end;

procedure TMapFm.GroupNumClick(Sender: TObject);
begin
  FKnotGroupRenum.ShowModal;
  if FKnotList <> nil then
    FKnotList.RefreshKnotList;
  FKnotList.EditKn.Click;
end;

procedure TMapFm.JumpXYClick(Sender: TObject);
var c : TLatLong;
begin
   Timer.Enabled := false;

   MarkEd.PMode := 1;
    // MarkEd.MarkN := 0;
    // MarkEd.Edit1.Text := Markers[SelectedMarkers[tag-1]].MarkerName;
   c := MapToBL(Center.x, Center.y);
   MarkEd.Edit2.Text := DegToDMS(c.lat, true, 4);
   MarkEd.Edit3.Text := DegToDMS(c.long, false, 4);
   MarkEd.ShowModal;

   SaveCtrlZ;
   Timer.Enabled := true;

   if MarkerList.Visible then
        MarkerList.RefreshList(true);
end;

procedure TMapFm.KeyholeMarkupLanguagekml1Click(Sender: TObject);
var HM: String;  HList:TStringList;
begin
 if (RouteCount = 0) and (Length(Markers) = 0) and (Frame = False) then
   exit;

  HList := TStringList.Create;
  try
    SetCurrentDir(MyDir);
    HList.LoadFromFile('Data\Kml_HeightModes.loc');
    HM := InputCombo(inf[275], inf[276], HList);
  except
    HM := 'absolute';
  end;
  HList.Destroy;

  SetCurrentDir(MyDir);
  if SaveKML.Execute then
     SaveKMLFile(SaveKML.FileName, HM, true);
end;

procedure TMapFm.KnotPtsClick(Sender: TObject);
begin
  if Length(KnotPoints)-1 <= KnotCount then
     exit;

  FKnotPickets.KnotN := KnotCount;
  FKnotPickets.KnotShape := 0; 
  FKnotPickets.pkt_cx :=  KnotPoints[Length(KnotPoints)-1].Cx;
  FKnotPickets.pkt_cy :=  KnotPoints[Length(KnotPoints)-1].Cy;
  if NCPC.ActivePageIndex = 0 then
    uKnotPickets.KnotSize.Value := KnotSize.Value
  else
    uKnotPickets.KnotSize.Value := KnotAreaRadius.Value;
  uKnotPickets.KnotAng.Value := KnotAng.Value;
  FKnotPickets.KnotAngRoute.Checked := KnotAngRoute.Checked;
  FKnotPickets.KnotAngOwn.Checked := KnotAngOwn.Checked;
  FKnotPickets.KnotAngAdd.Checked := KnotAngAdd.Checked;

  FKnotPickets.Knk.ItemIndex := KnotNames.ItemIndex;
  FKnotPickets.HideRt := false;

  FKnotPickets.RenewKnotBox;
  FKnotPickets.Rdrop.Checked := true;

  if (KnotRoutes.ItemIndex > 0) and (NCPC.ActivePageIndex = 0) then
  FKnotPickets.RouteBox.ItemIndex := KnotRoutes.ItemIndex - 1
    else
      FKnotPickets.RouteBox.ItemIndex := 0;

  case KnotNames.ItemIndex of
     0,2,3:
       if (KnotRoutes.ItemIndex = 0) and (RouteCount > 0) then
         FKnotPickets.TestName := Route[0].Name
       else
       if (KnotRoutes.ItemIndex > 0)  then
          if RouteCount > KnotRoutes.ItemIndex-1 then
             FKnotPickets.TestName  := Route[KnotRoutes.ItemIndex-1].Name;
     1: FKnotPickets.TestName := 'Pr'+FormatFloat('000', KnotStart.Value);
  end;

  FKnotPickets.TestL := 1;

  if FKnotPickets.Inited = false then
    InitKnots(NCPC.ActivePageIndex);

  FKnotPickets.MainPC.ActivePageIndex := 0;
  FKnotPickets.Inited := true;
  FKnotPickets.ShowModal;
end;

procedure TMapFm.KnotRoutesChange(Sender: TObject);
var str:string;
begin
  DoDoKnots;
  case KnotNames.ItemIndex of
     0: begin
       str := 'name';

       if NCPC.ActivePageIndex = 0 then
       Begin
        if (KnotRoutes.ItemIndex = 0) and (RouteCount > 0) then
           str := Route[0].Name
        else
        if (KnotRoutes.ItemIndex > 0)  then
          if RouteCount > KnotRoutes.ItemIndex-1 then
             str := Route[KnotRoutes.ItemIndex-1].Name;
       End
         else
           str := KnotAreaName.Text;

       if length(str)> 9 then
         str := copy(str, 1, 9);

       if NCPC.ActivePageIndex = 1 then
         str :=  str + FormatFloat('000', 1);

       KnEx1.Caption := str + '_L001_Pkt01';
       KnEx2.Caption := str + '_L001_K1';

       NewKnotPanel2.Visible := false;    NewKnotPanel4.Visible := false;
     end;
     1: begin
       NewKnotPanel2.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex = 1);
       NewKnotPanel4.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex > 1);
       KnEx1.Caption := 'Pr'+FormatFloat('000', KnotStart.Value)+'_L001_Pkt01';
       KnEx2.Caption := 'Pr'+FormatFloat('000', KnotStart.Value)+'_L001_K1';
     end;
     2: begin
       NewKnotPanel4.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex > 1);

       if KnotsLTogether.Checked then
         KnEx1.Caption := 'L'+FormatFloat('000', KnotsLFrom.value) +'_Pkt01'
       else
         KnEx1.Caption := 'L001_Pkt01';

       KnEx2.Caption := 'L001_K1';

        NewKnotPanel2.Visible := false;
     end;
     3: begin
       NewKnotPanel4.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex > 1);
       if KnotsLTogether.Checked then
         KnEx1.Caption := FormatFloat('000', KnotsLFrom.value) +'_P001'
       else
         KnEx1.Caption := '001_P01';

       KnEx2.Caption := '001_K1';
        NewKnotPanel2.Visible := false;
     end;
     4: begin
       NewKnotPanel4.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex > 1);
       if KnotsLTogether.Checked then
         KnEx1.Caption := FormatFloat('000', KnotsLFrom.value) +'_001'
       else
         KnEx1.Caption := '001_01';

       KnEx2.Caption := '001_K1';
        NewKnotPanel2.Visible := false;
     end;

  end;

  if NewKnotPanel.Visible = false then
    KillNewKnots;

  Checkmates.Visible := (RouteCount > 1) and (KnotRoutes.ItemIndex = 0);
  Checkmates.Glyph.Assign(nil);
  RedForm.ImageList1.GetBitmap(16 + ChessMode,Checkmates.Glyph);
  Checkmates.Hint := Inf[209 + ChessMode];

 // if KSfocus then
 //   KnotStart.SetFocus);
end;

procedure TMapFm.KnotsDestroyClick(Sender: TObject);
begin
  KnotCount := 0;
  SetLength(KnotPoints, 0);
  SetLength(SelectedKnots, 0);
  if NewKnotPanel.Visible then
     DoDoKnots;
  FKnotList.RefreshKnotList;
  SaveCtrlZ;
end;

procedure TMapFm.KnotSize_Change(Sender: TObject);
begin
  DoDoKnots;
  KnotAng.Visible := True;
  Label20.Visible := True;
  KnotAng.Visible := KnotAngOwn.Checked;
  Label20.Visible := KnotAngOwn.Checked;
  KnotAngAdd.Enabled := KnotAngOwn.Checked;

  if NewKnotPanel.Visible = false then
    KillNewKnots;
end;

procedure TMapFm.KnotsLTogetherClick(Sender: TObject);
begin
  Label38.Enabled := KnotsLTogether.Checked;
  KnotsLFrom.Enabled := KnotsLTogether.Checked;
  KnotRoutes.OnChange(nil);
end;

procedure TMapFm.KnotsNew2Click(Sender: TObject);
begin
  NewKnotPanel2.Visible := false;
  NewKnotPanel3.Visible := false;
  NewKnotPanel4.Visible := false;
  if FrameCount > 0 then
  begin
    case NCPC.ActivePageIndex of
       1:  NewKnotPanel.Visible := not NewKnotPanel.Visible;
       0:  NewKnotPanel.Visible := true;
    end;
  end
  else
    NewKnotPanel.Visible := false;

  NCPC.ActivePageIndex := 1;

  NewKnotPanel2.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex = 1);
  NewKnotPanel4.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex > 1);
  NewKnotPanel3.Visible := false;
//  KnotsNew.Flat := not NewKnotPanel.Visible;
  KnotsNew.Flat  := not ((NewKnotPanel.Visible) and (NCPC.ActivePageIndex = 0));
  KnotsNew2.Flat := not ((NewKnotPanel.Visible) and (NCPC.ActivePageIndex = 1));

  if NewKnotPanel.Visible then
    DoDoKnots
  else
    KillNewKnots;

  KnotSize_Change(nil);
  KnotRoutesChange(nil);
end;

procedure TMapFm.KnotsNewClick(Sender: TObject);
begin
  NewKnotPanel2.Visible := false;
  NewKnotPanel3.Visible := false;
  NewKnotPanel4.Visible := false;
  if RouteCount > 0 then
  begin
    case NCPC.ActivePageIndex of
       0:  NewKnotPanel.Visible := not NewKnotPanel.Visible;
       1:  NewKnotPanel.Visible := true;
    end;
  end
  else
    NewKnotPanel.Visible := false;

  NCPC.ActivePageIndex := 0;  NewKnotPanel3.Visible := false;
  NewKnotPanel2.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex = 1);
  NewKnotPanel4.Visible := (NewKnotPanel.Visible) and (KnotNames.ItemIndex > 1);
//  KnotsNew.Flat := not NewKnotPanel.Visible;
  KnotsNew.Flat  := not ((NewKnotPanel.Visible) and (NCPC.ActivePageIndex = 0));
  KnotsNew2.Flat := not ((NewKnotPanel.Visible) and (NCPC.ActivePageIndex = 1));
  
  if NewKnotPanel.Visible then
    DoDoKnots
  else
    KillNewKnots;

  KnotSize_Change(nil);
  KnotRoutesChange(nil);
end;

procedure TMapFm.KnotsSaveClick(Sender: TObject);
var FN:string;
begin
  if KnotCount = 0 then
    exit;
  if SaverKnots.Execute then
  Begin
    Timer.Enabled  := False;
    if SaveKnots(SaverKnots.FileName, true) then
    begin
       FN := SaverKnots.FileName;

       if  Length(FN)< 4 then
         FN  := FN +  '.rnk'
       else
       if AnsiLowerCase(Copy(FN, Length(FN)-3,4))<> '.rnk'  then
         FN  := FN +  '.rnk';

       SaveRTSFile(FN + '.rts', true);
    end;
    Timer.Enabled  := True;
  End;
end;

procedure TMapFm.KnotsToMarkersClick(Sender: TObject);
begin
  FSaveKnots.doP.Enabled := True;
  if KnotCount > 0 then
    FSaveKnots.ShowModal;
end;

procedure TMapFm.JumpRoutesClick(Sender: TObject);
begin
  JumpToRoutesMap(-2);
end;

procedure TMapFm.JumpTrackClick(Sender: TObject);
begin
  
  FocusOnTrack(MainTrack);
end;

procedure TMapFm.JumpBaseClick(Sender: TObject);
begin
 Center.x := Base[1].x;
 Center.y := Base[1].y;

 ShiftCenter.x := Center.x;
 ShiftCenter.y := Center.y;
end;

procedure TMapFm.EdWClick(Sender: TObject);
begin
  EdW.Flat := not Edw.Flat;
  if EdW.Flat = false then
  Begin
     if (RouteCount > 0)or (FrameCount > 0) then
       EdWin.Show
     else
       EdW.Flat := true;
  End
       else
         EdWin.Close;
end;

procedure TMapFm.EstimClick(Sender: TObject);
begin
  Timer.Enabled := false;
  SetCurrentDir(MyDir);
  EOpen.Showmodal;
  Timer.Enabled := true;
end;

procedure TMapFm.extfiles1Click(Sender: TObject);
begin
  SaveRoutesTXT;
end;

procedure TMapFm.Bm1Click(Sender: TObject);
var S: String;
    J: integer;
    AskEM: Boolean;
begin
  Timer.Enabled := False;
  AskEM := true;
  if Melesk then
     OpenMarkers.FilterIndex := 5;

  if OpenMarkers.Execute then
  BEGIN

    if not AddRoutes then
       SetLength(Markers, 0);

    for J := 0 to OpenMarkers.Files.Count - 1 do
    Begin
      S := OpenMarkers.Files[J];
      if AnsiLowerCase(Copy(S, Length(S)-4,5))='.mark' then
      begin
        LoadMarkers(S);
        if MarkersAreLoops then
          PC.ActivePageIndex := 2;
      end
      else
      if AnsiLowerCase(Copy(S, Length(S)-3,4))='.gpx' then
        LoadGPXFile(S, AddRoutes)
      else
        if AnsiLowerCase(Copy(S, Length(S)-3,4))='.udf' then
        Begin
           FOpenUdf.ToAll.Visible := true;
           FOpenUdf.ToAll.Visible := OpenMarkers.Files.Count > 1;
           FOpenUdf.ToAll.Enabled := OpenMarkers.Files.Count > 1;
           FOpenUdf.UdfName := S;
           if AskEM then
           begin
             FOpenUdf.ToAll.Checked := false;
             FOpenUdf.ShowModal
           end
           else
           begin

             FOpenUdf.Button1.Click;    /// OPEN WITH THE LAST SETTINGS!
             FLoadGPS.Show;
             FLoadGPS.LCount.Visible  := true;
             FLoadGPS.ProgressBar1.Position := round(100*(j+1)/
                                             OpenMarkers.Files.Count);
             FLoadGPS.LCount.Caption  := IntToStr(j+1) + ' / '
                                       + IntToStr(OpenMarkers.Files.Count);
           end;

           AskEM := not FOpenUdf.ToAll.Checked;
           if FOpenUdf.DeclineAll then
             break;

        End
        else
          Begin
             SetCurrentDir(MyDir);
             CheckCharset(S);

             LoadRData.OpenFile(S);
             LoadRData.OpenKind := 2;

             LoadRData.PC2.ActivePageIndex := 1;
             LoadRData.RoutesBE.ItemIndex := 2;
             LoadRData.RoutesBE.OnClick(nil);
             LoadRData.RoutesBE.Enabled := false;
             LoadRData.ValueList2.Enabled := false;

             LoadRData.ShowModal;
          End;

    End;

    SaveCtrlZ;
 END;
// DopPan7.Visible := not WaitForZone;
 if FLoadGPS.Visible then
   FLoadGPS.Close;
 Timer.Enabled := True;
 Refreshbtn.Click;
 if  MarkerList.Showing then
    MarkerList.RefreshList(false);
end;

procedure TMapFm.SetBClick(Sender: TObject);
begin
  Timer.Enabled := false;
  SetCurrentDir(MyDir);
  SetFm.Showmodal;
  Timer.Enabled := true;
  if CoordSysN <> -1 then
     Csys.Caption := CoordinateSystemList[CoordSysN].Caption;
end;

procedure TMapFm.SetKnAng_Change(Sender: TObject);
var I :Integer;
begin
  if NotChangeKnot then
     exit;

  for I  := 0 to Length(SelectedKnots) - 1 do
  try
     KnotPoints[SelectedKnots[I]].BoxAngle := SetKnAng.Value*pi/180;
  except
  end;
  SaveCtrlZ;
  SetKnAng.Font.Color := clWindowText;
end;

procedure TMapFm.SetKnAng_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = vk_Return then
    SetKnAng.OnChange(nil);
end;

procedure TMapFm.SetKnLChange(Sender: TObject);
begin
  if NotChangeKnot then
     exit;

  if SetKnL.Enabled then
  try
    KnotPoints[SelectedKnots[0]].L := SetKnL.Value;
  except
  end;
  SaveCtrlZ;
end;

procedure TMapFm.SetKnNameChange(Sender: TObject);
var I:Integer;
begin
  if NotChangeKnot then
     exit;

  for I  := 0 to Length(SelectedKnots) - 1 do
  try
      KnotPoints[SelectedKnots[I]].Name := SetKnName.Text;
  except
  end;
  RefreshKnExamples;
  SetKnName.Font.Color := clWindowText;
  SaveCtrlZ;

end;

procedure TMapFm.SetKnNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = vk_Return then
    SetKnName.OnChange(nil);
end;

procedure TMapFm.SetKnNameKindChange(Sender: TObject);
var I :Integer;
begin
  if NotChangeKnot then
     exit;

  for I  := 0 to Length(SelectedKnots) - 1 do
  try
     if SetKnNameKind.ItemIndex = 0 then
       KnotPoints[SelectedKnots[I]].NameKind := 0
     else
       KnotPoints[SelectedKnots[I]].NameKind := SetKnNameKind.ItemIndex + 1;
  except
  end;
  RefreshKnExamples;
  SetKnNameKind.Font.Color := clWindowText;
  SaveCtrlZ;
end;

procedure TMapFm.SetKnSize2_Change(Sender: TObject);
var I:Integer;
begin
  if NotChangeKnot then
     exit;

  for I  := 0 to Length(SelectedKnots) - 1 do
  try
     KnotPoints[SelectedKnots[I]].BoxSize2 := SetKnSize2.Value;
  except
  end;

  SaveCtrlZ;
  SetKnSize2.Font.Color := clWindowText;
end;

procedure TMapFm.SetKnSize2_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = vk_Return then
    SetKnSize2.OnChange(nil);
end;

procedure TMapFm.SetKnSize_Change(Sender: TObject);
var I :Integer;
begin
  if NotChangeKnot then
     exit;

  for I  := 0 to Length(SelectedKnots) - 1 do
  try
     KnotPoints[SelectedKnots[I]].BoxSize := SetKnSize.Value;
  except
  end;

  SaveCtrlZ;
  SetKnSize.Font.Color := clWindowText;
end;

procedure TMapFm.SetKnSize_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = vk_Return then
    SetKnSize.OnChange(nil);
end;

procedure TMapFm.SetKnXYClick(Sender: TObject);
var c : TLatLong;
begin
   Timer.Enabled := false;

   if Length(SelectedKnots) < 1 then
     exit;

   MarkEd.PMode := 4;
   c := MapToBL(KnotPoints[SelectedKnots[0]].Cx,
                KnotPoints[SelectedKnots[0]].Cy);
   MarkEd.Edit2.Text := DegToDMS(c.lat, true, 4);
   MarkEd.Edit3.Text := DegToDMS(c.long, false, 4);
   MarkEd.ShowModal;

   SaveCtrlZ;
   Timer.Enabled := true;

end;

procedure TMapFm.AGoogle2Click(Sender: TObject);
var P:Tpoint;
begin
  GetCursorPos(P);
  PopupMenu5.Items[0].Enabled := PC.Pages[6].TabVisible;
  PopupMenu5.Popup(P.x, P.y);
end;

procedure TMapFm.Bm3Click(Sender: TObject);
begin
   ResetMarkers;
   SaveKnotMarkers.Visible := false;
   SaveCtrlZ;
   if  MarkerList.Showing then
     MarkerList.RefreshList(false);

   CheckWFZ;   
end;


procedure TMapFm.B1Click(Sender: TObject);
var s: string;
begin
   s := TSpeedButton(Sender).Name;
   s := Copy(s, 2, length(s)-1);
   ClickMode := StrToInt(s);
   ModeButtons;

   RefreshSelectionArrays;
   ResetMs;
   GetEdTools;

end;

procedure TMapFm.B2aClick(Sender: TObject);
begin
 Timer.Enabled := false;
 try
   GeoCalcFm.PointB := Base[2].x;
   GeoCalcFm.PointL := Base[2].y;
   GeoCalcFm.ShowModal;
   ClickMode := 1;
 finally
   Timer.Enabled := true;
   ModeButtons;
   SetBaseBL(GeoCalcFm.PointB,GeoCalcFm.PointL);
 end;
end;

procedure TMapFm.B40Click(Sender: TObject);
var  SysCurPos:TPoint;
begin
   ClickMode := 40;
   ModeButtons;
   if Length(MainTrack) > 0 then
   begin
      GetCursorPos(SysCurPos);
      PopupMenu12.Popup(SysCurPos.X, SysCurPos.Y);
   end;
   RefreshSelectionArrays;
   ResetMs;
   GetEdTools;
end;

procedure TMapFm.B4aClick(Sender: TObject);
begin
  ResetRoutes;
  SaveCtrlZ;
  CheckWFZ;
end;

procedure TMapFm.B4cClick(Sender: TObject);
begin
  if (FrameCount=0)and(RouteCount = 0) then
      exit;

  Showmessage(inf[53] + Format('%.n',[FrameArea]) + inf[58]
               + #13 + inf[59] + Format('%.n',[FramePerimeter]) + inf[40]
               + #13 + inf[54] + IntToStr(RouteCount)
               + #13 + inf[55] + IntToStr(GalsCount)
               + #13 + inf[56] + Format('%.n',[RoutesAllSize])  + inf[40]
               + #13 + inf[57] + Format('%.n',[RoutesMeanSize]) + inf[40]) ;
end;

procedure TMapFm.B4Click(Sender: TObject);
var S: String;
    J: integer;
begin
 Timer.Enabled := False;
 if OpenRoutes.Execute then
  Begin
    S := OpenRoutes.FileName;

    SetCurrentDir(MyDir);


    WaitForZone := true;
    WaitForCenter := true;

    LoadRData.RoutesBE.Enabled := true;
    LoadRData.ValueList2.Enabled := true;
    LoadRData.RoutesBE.OnClick(nil);

    LoadRData.FName := S;

    if AnsiLowerCase(Copy(S, Length(S)-3,4))='.rts' then
       LoadRoutesFromRTS(S, AddRoutes, inf[102])
       else
         if AnsiLowerCase(Copy(S, Length(S)-3,4))='.rta' then
         begin
           LoadTrackFromRTA(MainTrack, S, AddRoutes, inf[123]);
           PC.ActivePageIndex := 5;
           B41.Click;
         end
         else
           if AnsiLowerCase(Copy(S, Length(S)-3,4))='.gpx' then
             LoadGPXFile(S, AddRoutes)
           else
            if AnsiLowerCase(Copy(S, Length(S)-3,4))='.bln' then
               LoadBLNData.ShowModal
           else
             if AnsiLowerCase(Copy(S, Length(S)-3,4))='.kml' then
               KmlOpn.Showmodal          
           else
             if AnsiLowerCase(Copy(S, Length(S)-7,8))='.mission' then
                LoadRoutesMission(S, AddRoutes)
           else
           begin
               CheckCharset(S);

              LoadRData.OpenFile(S);
              LoadRData.OpenKind := 0;
              LoadRData.PC2.ActivePageIndex := 0;

              LoadRData.ShowModal;
           end;
  End;
  CtrlZ := 0;
  CtrlShiftZ := 0;
  SaveCtrlZ;
  Timer.Enabled := True;

  JumpRoutes.Click;
 // DopPan7.Visible := not WaitForZone;
  AddRoutes := False;
end;

procedure TMapFm.B4dClickNew(Sender: TObject);
begin
  if SaverTXT.Execute then
  Begin
    Timer.Enabled  := False;
    SaveTXTFm.SaveTXTName := SaveRTXT.FileName;
    SaveTXTFm.SaveKind := 0;

    SaveTXTFm.ShowModal;
    Timer.Enabled  := True;
  End;
end;

procedure TMapFm.B4dClick(Sender: TObject);
var SysCurPos :TPoint;
begin
  GetCursorPos(SysCurPos);
  Popupmenu4.Popup(SysCurPos.X, SysCurPos.Y);
end;

procedure TMapFm.B50Click(Sender: TObject);
begin
  if (ClickMode <> 50) and (ClickMode <> 51) then
  begin
    if GoogleCount = 0 then
    begin
      DoAZoom(False);
      ResetGoogle;
      InitGoogle(CanvCursorBL.lat, CanvCursorBL.long);
    end;

    if YandexCount = 0 then
    begin
      DoYAZoom(False);
      ResetYandex;
      InitYandex(CanvCursorBL.lat, CanvCursorBL.long);
    end;
    
    B1.OnClick(Sender);
  end;
end;

procedure TMapFm.B5aClick(Sender: TObject);
var I:Integer;
begin
 if OpenMaps.Execute then
 Begin
   if RouteCount = 0 then
     WaitForCenter := true;

   for I := 0 to OpenMaps.Files.Count - 1 do
    LoadMaps(OpenMaps.Files[I], TmpDir,
         AsphMapImages, I+1,  OpenMaps.Files.count);
 End;
// DopPan7.Visible := not WaitForZone;
 Label9.Visible := Length(MapList) > 0;
 Blend.Visible := Label9.Visible;

 BasicObjectsScale;
 MeanCenter;
end;

procedure TMapFm.B5bClick(Sender: TObject);
var I, J :Integer;
    S :String;
begin
   for I := 0 to Length(MapAsdbList) - 1 do
   Begin
     S := MapAsdbList[I];

     J := Pos('\', S);
     while J > 1 do
     Begin
       S := Copy(S, J+1, Length(S)-J);
       J := Pos('\', S);
     End;

     if MessageDLG(inf[16]+ S +' ?', MtConfirmation, mbYesNo, 0) = 6 then
     begin
        if SaveM.Execute() then
          SaveToAsdb(MapAsdbList[I], SaveM.FileName);
     end
       else
         continue;

   End;
end;

procedure TMapFm.B5cClick(Sender: TObject);
begin
  ResetMaps(AsphMapImages);

  Label9.Visible := Length(MapList) > 0;
  Blend.Visible := Label9.Visible;

  CheckWFZ;
end;

procedure TMapFm.B5dClick(Sender: TObject);
begin
  if  MapChoosed <>-1 then
      DeleteMap(MapChoosed);
  MapChoosed := -1;
  B5d.Enabled := false;
end;

procedure TMapFm.B5eClick(Sender: TObject);
begin
  if Lang = 'Russian' then
     winexec('Raster.exe', sw_restore)
        else
          winexec('Raster_E.exe', sw_restore);
end;

procedure TMapFm.B6aClick(Sender: TObject);
var s: string;
    j : integer;
begin
 if OpenRoutes.Execute then
  Begin
    S := OpenRoutes.FileName;
    LoadRData.OpenFile(S);
    LoadRData.OpenKind := 1;

 {   J := Pos('\', S);
    while J > 1 do
    Begin
       S := Copy(S, J+1, Length(S)-J);
       J := Pos('\', S);
    End;   }

    WaitForZone := true;
    WaitForCenter := true;

    LoadRData.RoutesBE.ItemIndex := 2;
    LoadRData.RoutesBE.OnClick(nil);
    LoadRData.RoutesBE.Enabled := false;
    LoadRData.ValueList2.Enabled := false;
    LoadRData.PC2.ActivePageIndex := 0;
    
    if AnsiLowerCase(Copy(S, Length(S)-3,4))='.rts' then
    Begin
       LoadRoutesFromRTS(S, False, '');
       RouteCount := 0;
    End
    else
    if AnsiLowerCase(Copy(S, Length(S)-3,4))='.bln' then
    Begin
      LoadBLNData.BlnDataKind.ItemIndex := 0;
      LoadBLNData.ShowModal
    End
      else
      begin
        Timer.Enabled := false;
        LoadRData.ShowModal;
        Timer.Enabled := true;
      end;

    if FrameCount >= 3 then
     if isFrameClockWise then
      if MessageDlg(inf[17],MtConfirmation,[mbYes, mbNo],0)=6 then
         ReverseFrame;

  End;
  SaveCtrlZ;
  JumpRoutes.Click;
end;

procedure TMapFm.B6bClick(Sender: TObject);
var I, I0 :Integer;
begin

//    Showmessage(FloatToStr(TFloatSpinEdit(step).Value));
    I0 := RouteCount;
    if not AddRoutes then
      I0 := 0;
    SplitFrame(step.Value, -Deg.Value, Num0.Value, MinShift.Value, Extra.Checked,
               DegIsDA, AddRoutes, Extra3.Checked);
    ReComputeRoutes(WaitForZone);

    if Extra2.Checked or Extra3.Checked then
    for I := I0 to RouteCount - 1 do
    begin
      if (Extra2.Checked) then
        Route[I].Fixed := true;
      {if Extra3.Checked then
        if (I-I0) mod 2 = 0 then
          RewerseRoute(I);}
    end;


    RefreshSelectionArrays;
    SaveCtrlZ;

    if isMinL.Checked then
       ExpandShortRoutes(MinL.Value, -1);
//  end;

  AddRoutes := false;
end;

procedure TMapFm.B6cClick(Sender: TObject);
begin
  if SaveR.Execute then
  Begin
    if SaveR.FilterIndex = 1 then
    begin
       SaveRTSFile(SaveR.FileName, true);
    end;
  End;
end;

procedure TMapFm.BcutClick(Sender: TObject);
begin
  SaveCtrlZ;
  CutMode := -1;
  CutRoutes;
  SetLength(RouteCutPoints, 0);
  CutPan.Hide;
  Edwin.ReFreshTree;
  RefreshRouteBox;
  B23.Click;
end;

procedure TMapFm.BDelTrackClick(Sender: TObject);
begin
 SetLength(MainTrack,0);
 SetLength(ReductedMainTrack,0);
 CheckWFZ;
end;

procedure TMapFm.BlendChange(Sender: TObject);
begin
  MapAlpha:= Blend.Position *10+5;
end;

procedure TMapFm.BNmeaClick(Sender: TObject);
var I :integer;
    b :boolean;
begin

  if OpenNmea.Execute then
  Begin

    for I := 0 to OpenNmea.Files.Count - 1 do begin

     if AddRoutes then
        b := true
        else
          b := i > 0;
      LoadTrackFromNmea(MainTrack, OpenNmea.Files[I], b);

    end;
    TrackFastFilter(MainTrack, inf[103]);

    SetLength(RedTrack, 0);
    SetLength(ReductedMainTrack, 0);

    if Length(MainTrack) > AskTrackTreshold then
      if MessageDlg(inf[122], mtConfirmation, mbYesNo, 0) = 6 then
      begin
         Timer.Enabled := false;
         FReduceTrack.ShowModal;
         Timer.Enabled := true;
      end;


    DopPan6.Visible := (PC.ActivePageIndex = 5) and (Length(MainTrack) > 0);
    // DopPan7.Visible := not WaitForZone;
    FocusOnTrack(MainTrack);
    ChoosedTrackPoint := -1;
    AddRoutes := false;
    ClickMode := 40;

    ModeButtons;

    RefreshSelectionArrays;
    ResetMs;
    GetEdTools;
    //B40.Click;
  End;


end;

procedure TMapFm.BNmeaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var CP :TPoint;
begin
  AddRoutes := false;
  TrackMenuKind := 1;
  GetCursorPos(CP);
  if Button = mbRight then
     Popupmenu8.Popup(CP.X, CP.Y);
end;

procedure TMapFm.BredClick(Sender: TObject);
begin
  if Length(MainTrack)>1 then
  begin
    Timer.Enabled := False;
    RedForm.ShowModal;
    Timer.Enabled := True;
  end;
  
end;

procedure TMapFm.BresClick(Sender: TObject);
begin
  CutMode := -1;
  SetLength(RouteCutPoints, 0);
  CutPan.Hide;
end;

procedure TMapFm.BrkRoutesClick(Sender: TObject);
var I1, I2, I:Integer;
    R :TRoute;
begin
  if RouteCount = 0 then
     exit;

  Timer.Enabled := False;
  RouteOps.Caption := BrkRoutes.Hint;
  RouteOps.isShowSpin := 1;
  RouteOps.RouteBox.ItemIndex := RouteBox.ItemIndex;
  RouteOps.ShowModal;
  
  if RouteOps.isROk then
  begin

        if RouteOps.RouteBox.ItemIndex > 0 then
        begin
          I1 := RouteOps.RouteBox.ItemIndex - 1;
          I2 := I1;
        end
         else
         begin
           I1 := 0;
           I2 := RouteCount-1;
         end;

        if (RouteOps.DoM.Checked) and (RouteOps.DelM.Checked) then Bm3.Click;

        for I := I1 to I2 do
        begin
           R := RouteStepBreak( I, URNewOps.BrkStep.Value,
                 RouteOps.DoM.Checked, RouteOps.MNames.ItemIndex,
                 RouteOps.Mfr, RouteOps.Mst, RouteOps.MSep.Text,
                 RouteOps.EndM.Checked);
           Route[I] := R;
        end;

        RoutesToGeo;
        ReComputeRoutes(False);
        FilterRoutePoints(0);
        RefreshSelectionArrays;
        EdWin.ReFreshTree;
        SaveCtrlZ;

    if (RouteOps.DoM.Checked) then B1.Click;
  end;
   Timer.Enabled := True;
   
end;

procedure TMapFm.BtxtClick(Sender: TObject);
var FN:string;
begin
  if OpenTXT.Execute then
  begin
     Timer.Enabled := False;
     SetCurrentDir(MyDir);

     FN := OpenTXT.FileName;

     SetCurrentDir(MyDir);
     CheckCharset(FN);
     
     LoadT.FName := FN;
     LoadT.FKind := 0;
     LoadT.ShowModal;
     TrackFastFilter(MainTrack, inf[103]);
     SetLength(RedTrack, 0);
     SetLength(ReductedMainTrack, 0);
     Timer.Enabled := True;

     if Length(MainTrack) > AskTrackTreshold then
      if MessageDlg(inf[122], mtConfirmation, mbYesNo, 0) = 6 then
      begin
         Timer.Enabled := false;
         FReduceTrack.ShowModal;
         Timer.Enabled := true;
      end;
      
     DopPan6.Visible := (PC.ActivePageIndex = 5) and (Length(MainTrack) > 0);
     // DopPan7.Visible := not WaitForZone;
     FocusOnTrack(MainTrack);
     if LoadT.C17.Checked then
       B41.Click
     else
     begin
      // B40.Click;
        ClickMode := 40;

        ModeButtons;

        RefreshSelectionArrays;
        ResetMs;
        GetEdTools;
     end;
     ChoosedTrackPoint := -1;
     AddRoutes := false;
  end;

end;

procedure TMapFm.BtxtMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var CP:TPoint;
begin
  AddRoutes := false;
  TrackMenuKind := 2;
  GetCursorPos(CP);
  if Button = mbRight then
     Popupmenu8.Popup(CP.X, CP.Y);
end;

procedure TMapFm.Button1Click(Sender: TObject);
begin
  SaveLngs;
end;

procedure TMapFm.Button2Click(Sender: TObject);
var I: integer;
    S: TStringList;
    DT: TformatSettings;
const
    sep :char = #$9;
begin
  S := TStringList.Create;

  InitDTFormat(DT);

  for i := 0 to Length(Maintrack)-1 do
  begin
    S.Add(MainTrack[I]._T+sep+ format('%.3f',[MainTrack[I].x]) +sep+
                               format('%.3f',[MainTrack[I].y]) +sep+
                               format('%.3f',[MainTrack[I].h]))
  end;
  S.SaveToFile(TmpDir+'Track.txt');
  S.Clear;

  for i := 0 to Length(ReductedMaintrack)-1 do
  begin
    S.Add(ReductedMainTrack[I]._T+sep+ format('%.3f',[ReductedMainTrack[I].x]) +sep+
                               format('%.3f',[ReductedMainTrack[I].y]) +sep+
                               format('%.3f',[ReductedMainTrack[I].h]))
  end;
  S.SaveToFile(TmpDir+'RedTrack.txt');
  S.Clear;

  for i := 0 to Length(RedTrack)-1 do
  begin
    S.Add(INtToSTr(I)+sep+ format('%.3f',[RedTrack[I].dx])
                       +sep+ format('%.3f',[RedTrack[I].dy])
                       +sep+ format('%.3f',[RedTrack[I].dz]))
  end;
  S.SaveToFile(TmpDir+'RTrack.txt');
  S.Clear;
  for i := 0 to Length(RedAngles)-1 do
  begin
    S.Add(INtToSTr(RedAngles[I].N)
          + sep +  DateTimeToStr2(RedAngles[I].T, DT)
          + sep + format('%.3f',[RedAngles[I].Yaw/pi*180])
          + sep + format('%.3f',[RedAngles[I].Pitch/pi*180])
          + sep + format('%.3f',[RedAngles[I].Roll/pi*180]))
  end;
  S.SaveToFile(TmpDir+'RedAngles.txt');


  S.Free;
end;

procedure TMapFm.CsysClick(Sender: TObject);
begin
  Timer.Enabled  := False;
  CSForm.ShowModal;
  if CoordSysN <> -1 then
     Csys.Caption := CoordinateSystemList[CoordSysN].Caption;
  SaveTXTFm.Csys.Caption := Csys.Caption;
  Timer.Enabled  := Showing;
end;

procedure TMapFm.CsysMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Csys.Hint := Csys.Caption;
  Canvas.Font := Csys.Font;
  Csys.ShowHint := Canvas.TextWidth(Csys.Caption) > Csys.Width; 
end;

procedure TMapFm.CurRulStat;
var P:TMyPoint;
begin
   if Rulcount > 0 then
   begin
        if HasDropPoint then
          P := PointToAdd //ScreenToMap(PointToAdd.X, PointToAdd.Y)
        else
          P := ScreenToMap(CanvCursor.X, CanvCursor.Y);
        RulCurrent(P.X, P.Y);
        RCL.Caption := Format('%.3n',[RulCurrL]);
        RCAz.Caption := Format('%.1n',[RulAzmt*180/pi]);
        RCDA.Caption := Format('%.1n',[RulDA*180/pi]);
   end
     else
        begin
           RCL.Caption := '-';
           RCAz.Caption := '-';
           RCDA.Caption := '-';
        end;
end;

procedure TMapFm.CustomFi;
var I:Integer; St :String;
begin
    st := IntToStr(round(Fi*180/pi));
    InputQuery(inf[252], inf[253], st);
    if (StrToFloat2(st) > 360) or (StrToFloat2(st) < -360) then
       exit;
    Fi := StrToFloat2(st)*pi/180;
    _Fi := Fi;
end;

procedure TMapFm.CustomScale;
var I:Integer; St :String;
begin
    SpecialScale := true;
    st := IntToStr(round(Scale*100));
    InputQuery(inf[250], inf[251], st);

    if (StrToFloat2(st) < 0.01) or
       (StrToFloat2(st) > 500000) then
    exit;

    Scale := StrToFloat2(st) / 100;
    _Scale := Scale;

    Mashtab := 0;
    for I := 0 to  MaxMashtab-1 do
    if _Scale*100 >= TMashtab[I] then
      Mashtab := I;
end;

procedure TMapFm.DefaultCsys;
var S :TStringList;
begin
  S := TStringList.Create;
  if Fileexists('Data\CSDefault.loc') then
  S.LoadFromFile('Data\CSDefault.loc');
  if S.Count > 0 then
    CoordSysN := FindCoordinateSystem(S[0]);
  DefineCsys;

  LoadRData.FindWGS;
  S.Free;
end;

procedure TMapFm.DefineCsys;
begin
   if CoordSysN<>-1 then
     Csys.Caption := CoordinateSystemList[CoordSysN].Caption
     else       
        Csys.Caption := inf[14];
end;

procedure TMapFm.Deg_Change(Sender: TObject);
begin
 MinShift.Enabled := (Deg.Value = 0) and (DegIsDa = false);
 Label8.Enabled := MinShift.Enabled; 

end;

procedure TMapFm.SDelKnClick(Sender: TObject);
begin
  FKnotList.DelKn.Click;
  KnotSettings.Hide;
  if FKnotList <> nil then
    FKnotList.RefreshKnotList;
end;

procedure TMapFm.DelLastClick(Sender: TObject);
begin
  case ClickMode of
    
    7:
    if RulCount > 0 then
       Dec(RulCount);

    25: if FrameCount>1 then
            Begin
             Dec(FrameCount);
             RecomputeRoutes(False);
             FramePoints[FrameCount-1,1].x := FramePoints[FrameCount-2,1].x;
             FramePoints[FrameCount-1,1].y := FramePoints[FrameCount-2,1].y;
             RefreshSelectionArrays;
             ModeButtons;
             SaveCtrlZ;
            End
             else
             Begin
               FrameCount := 0;
               SaveCtrlZ;
               EdWin.ReFreshTree;
             End;

    26: if Length(Route[RouteCount-1].WPT)> 2 then
         begin
           DeleteRoutePoint(RouteCount-1,Length(Route[RouteCount-1].WPT)-1);
           EdWin.ReFreshTree;
           RefreshRouteBox;
           SaveCtrlZ;
         end
          else
          Begin
            DelRoute(RouteCount-1);
            EdWin.ReFreshTree;
            RefreshRouteBox;
            ClickMode := 0;
            ModeButtons;
            SaveCtrlZ;
          End;
   end;

   RecomputeRuler(ClickMode);
   RulStat;
end;

procedure TMapFm.DelSelected;
begin
  case ClickMode of
        21: if FrameCount > 1 then
            if SelectedFramePointsCount > 0 then
             FrameCount := 0;

        22: if SelectedFramePointsCount > 0 then
             DeleteSelectedFramePoints;

        23, 24 : if SelectedRoutePointsCount > 0 then
                    DeleteSelectedRoutePoints;
  end;

  if FrameCount <= 2 then
     FrameCount := 0;
  RefreshSelectionArrays;
  EdWin.ReFreshTree;
  SaveCtrlZ;
end;

procedure TMapFm.DestroyFloatSpins;
begin
 Step.Destroy;  MinShift.Destroy;
 MinL.Destroy;  Deg.Destroy;

 KnotStartL.Destroy;
 KnotAng.Destroy;
 KnotSize.Destroy;
 KnotStep.Destroy;
 SetKnAng.Destroy;
 SetKnSize.Destroy;
 SetSStep.Destroy;
end;

procedure TMapFm.DevStarClick(Sender: TObject);
begin
 DevStarFm.ShowModal
end;

procedure TMapFm.DoAdd1Click(Sender: TObject);
begin
  AddRoutes := True;
  B4.Click;
end;

procedure TMapFm.DoAdd2Click(Sender: TObject);
begin
  AddRoutes := True;
  B6b.Click;
end;

procedure TMapFm.DoAdd3Click(Sender: TObject);
begin
  AddRoutes := true;
  case TrackMenuKind of
    1: Bnmea.Click;
    2: Btxt.Click;
    3: Rtt.Click;
  end;
end;

procedure TMapFm.DoAdd4Click(Sender: TObject);
begin
  AddRoutes := true;
  Bm1.Click;
end;

procedure TMapFm.DoAZoom(isAuto:Boolean);
begin
 { P := ScreenToMap(0,0);
  y1 := P.y;
  P := ScreenToMap(Canv.Width,Canv.Height);
  Dy := abs(y1 - P.y);

  GoogleAutoZoom(Dy);  }
  if isAuto then
    GoogleAutoZoom(Canv.Height*TMashtab[Mashtab]/120)
     else
        GoogleAutoZoom(Canv.Height*TMashtab[Mashtab]/170);
  GoogleCursor := GoogleInitBL;
  GetGoogleCursor(CanvCursorBL.lat,CanvCursorBL.long);
  RefreshSt;
end;

procedure TMapFm.DoYAZoom(isAuto:Boolean);
begin

  if isAuto then
    YandexAutoZoom(Canv.Height*TMashtab[Mashtab]/120)
     else
        YandexAutoZoom(Canv.Height*TMashtab[Mashtab]/170);

  YandexCursor := YandexInitBL;
  GetYandexCursor(CanvCursorBL.lat,CanvCursorBL.long);
  RefreshYSt;
end;

procedure TMapFm.e1Click(Sender: TObject);
begin
 Extra.Checked := not Extra.Checked;
end;

procedure TMapFm.e2Click(Sender: TObject);
begin
  Extra2.Checked := not Extra2.Checked;
end;

procedure TMapFm.e3Click(Sender: TObject);
begin
  Extra3.Checked := not Extra3.Checked;
end;

procedure TMapFm.StatBtnClick(Sender: TObject);
begin
{  case PC.ActivePageIndex of
    5 : RinfClick(nil);
    else  B4cClick (nil);
  end;}


  if (FrameCount=0) and (RouteCount = 0) and (Length(MainTrack) = 0)and
     (MarkersAreLoops = false) and (KnotCount = 0) then
       exit;

  MarkersToGeo;

  if MarkersUDFCount > 0 then
  begin
    FLoadGPS.LCount.Caption := '';
    FLoadGPS.Show;
    StatBox.GetUDFEstims(FLoadGPS.ProgressBar1);
    FLoadGPS.Close;
  end;

  StatBox.StatDir := MyDir;
  Timer.Enabled := false;
  StatBox.ShowModal;
  Timer.Enabled := true;
end;

procedure TMapFm.StaticText2Click(Sender: TObject);
var P: TPoint;
begin
//  P := ClientToscreen(Point( 5 + StaticText2.Left, 25 + StaticText2.Top));
//  PopupMenu2.Popup(P.X, P.Y);
end;

procedure TMapFm.StaticText3Click(Sender: TObject);
var P:TPoint;
begin
//  P := ClientToscreen(Point(StaticText3.Left + 5, StaticText3.Top + 25));
//  PopupMenu1.Popup(P.X, P.Y);
end;

procedure TMapFm.SurferBlnCS42GaussKruger1Click(Sender: TObject);
begin
  if SaveBln.Execute then
  Begin
     {if fileexists(SaveBln.FileName) then
        if MessageDLG(inf[22] +#13 + SaveBln.FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;}
     SaveBLNFile(SaveBln.FileName, false, true);
  End;
end;

procedure TMapFm.SurferBlnusingPulkovo19421Click(Sender: TObject);
begin
  if SaveBln.Execute then
  Begin
     {if fileexists(SaveBln.FileName) then
        if MessageDLG(inf[22] +#13 + SaveBln.FileName, MtConfirmation, mbYesNo, 0) <> 6 then
           exit;}
     SaveBLNFile(SaveBln.FileName, true, true);
  End;
end;

procedure TMapFm.TabSheet2Show(Sender: TObject);
begin
 if not Edw.Flat then
    EdWin.Show;

  RefreshRouteBox;

  RouteBoxPan.Visible := true;
  RouteBoxPan.Visible := (ClickMode=24) or (ClickMode=28);
  RouteBoxPan.Enabled := (ClickMode=24) or (ClickMode=28);
end;

procedure TMapFm.TabSheet3Show(Sender: TObject);
begin
//  MapFm.MList.Flat := True;
  KnotPanel.Visible := true;
  KnotPanel.Visible := false;

  CheckKnSaver;
end;

procedure TMapFm.TabSheet5Show(Sender: TObject);
begin
  RouteBoxPan2.Visible := true;
  RouteBoxPan2.Visible := false;
end;

procedure TMapFm.TabSheet6Show(Sender: TObject);
begin
  GPan.Visible := true;
  MapCombos;
  ModeButtons;
  
 // GoogleKey := 'AIzaSyA8km15HxW0At7gMNjtj3dXqgoIvUohQRM';  
end;

procedure TMapFm.TabSheet7Show(Sender: TObject);
begin
  yPan.Visible := true;
  MapCombos;
  ModeButtons;
end;

procedure TMapFm.TabSheet8Show(Sender: TObject);
begin
  if FKnotPickets.Inited = false then
  begin
    InitKnots(NCPC.ActivePageIndex);
    KnotSize_Change(nil);
  end;
end;

procedure TMapFm.TabSheet9Show(Sender: TObject);
var I:integer;
begin
  NewKnShift.Flat := true;
  if FKnotPickets.Inited = false then
  begin
    InitKnots(NCPC.ActivePageIndex);
    KnotSize_Change(nil);
  end;

  I := KnotAreaOrder.ItemIndex;
  KnotAreaOrder.Items[0] := inf[158];    KnotAreaOrder.Items[1] := inf[159];
  KnotAreaOrder.ItemIndex := I;
end;

procedure TMapFm.TimerEvent(Sender: TObject);
begin

  AsphDevice.Render(Canv.Handle, RenderEvent, BackGroundColor);
  Timer.Process();

  Ticks := Ticks + 2*Timer.Delta;
  if Ticks > 100 then
     Ticks := Ticks - 100;

  if not AskNoSmooth then
  if Smooth then
   if Timer.Delta > 3 then
   begin
      AskNoSmoothN :=AskNoSmoothN + 2*Timer.Delta;
   end
    else
       AskNoSmoothN := 0;

  if AskNoSmoothN > 150 then
  Begin
    AskNoSmooth := true;
    AskNoSmoothN := 0;
    if MessageDlg(inf[29], mtConfirmation, [mbYes, mbNo], 0) = 6 then
      Smooth := false;
  End;

end;

procedure TMapFm.TreeSelectFramePoint(N: Integer);
begin
 if ClickMode <> 22 then
 Begin
   ClickMode := 22;
   ModeButtons;
 End;

 try
   SelectedFramePoints[N] := True;

   if N = 0 then
      SelectedFramePoints[Length(SelectedFramePoints)-1] := True
        else
           if N = Length(SelectedFramePoints)-1 then
              SelectedFramePoints[0] := True;
 except

 end;
end;

procedure TMapFm.TreeSelectRoutePoint(RouteN, N: Integer);
var i, j : integer;
begin
  if ClickMode <> 24 then
 Begin
   ClickMode := 24;
   ModeButtons;
 End;

 try
   SelectedRoutePoints[RouteN][N] := True;

   if RouteN <> RouteBox.ItemIndex+1 then
      RouteBox.ItemIndex := 0;

 except

 end;
end;


procedure TMapFm.UAVMissionmission1Click(Sender: TObject);
begin
//
end;

procedure TMapFm.UAVMissionmission2Click(Sender: TObject);
var A:array of Integer; I:Integer;
begin
 if RouteCount = 0 then
   exit;
 if RouteCount > 1 then
    if MessageDLG(inf[255], MtConfirmation, mbYesNo, 0)  = 6 then
    begin
      MapFm.SaveCtrlZ;
      SetLength(A, RouteCount);
      for I := 0 to RouteCount - 1 do A[I] := I;
      CollapseFm.Init(A);
      CollapseFm.ShowModal;
    end;

 if RouteCount > 1 then
    if MessageDLG(inf[256], MtConfirmation, mbYesNo, 0) <> 6 then
        exit;

    
 if SaveMis.Execute then
   SaveMission( SaveMis.FileName, true);
end;

procedure TMapFm.UndoBClick(Sender: TObject);
begin
  LoadCtrlZ(false);

  UndoB.Visible := CtrlZ > 1;
  RedoB.Visible := CtrlShiftZ > 0;
end;

procedure TMapFm.YandexMaps1Click(Sender: TObject);
begin
  TabSheet7.OnShow(Sender);
  PC.ActivePageIndex := 7;
  AYandex.OnClick(nil);
end;

procedure TMapFm.YDownloadClick(Sender: TObject);
begin
  if YandexCount = 0 then
     exit;
     
  DownloadSelectedYandex;
  RefreshYST;
  B6.Click;
end;

procedure TMapFm.YlangChange(Sender: TObject);
begin
 YandexLang := Ylang.ItemIndex;
end;

procedure TMapFm.YResetClick(Sender: TObject);
begin
 ResetYandex;
 RefreshYST;
end;

procedure TMapFm.YstyleChange(Sender: TObject);
begin
  YandexStyle := YandexMapStyles[YStyle.ItemIndex];
end;

procedure TMapFm.YZoomChange(Sender: TObject);
begin
  YZoomA := Trunc(StrToFloat2(YZoom.Text));
  YAzoom.Checked := False;
end;



end.

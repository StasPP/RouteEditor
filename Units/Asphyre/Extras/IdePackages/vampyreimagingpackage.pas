{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit VampyreImagingPackage; 

interface

uses
    Imaging, ImagingBitmap, ImagingCanvases, ImagingClasses, 
  ImagingComponents, ImagingDds, ImagingFormats, ImagingIO, ImagingJpeg, 
  ImagingNetworkGraphics, ImagingTarga, ImagingTypes, ImagingUtility, 
  ImagingPortableMaps, ImagingExtras, ImagingGif, ImagingColors, 
  ImagingRadiance, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('VampyreImagingPackage', @Register); 
end.

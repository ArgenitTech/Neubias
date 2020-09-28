unit UMergeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.AppEvnts, JvBaseDlg,
  JvBrowseFolder, ieopensavedlg, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ComCtrls, ieview, imageenview, ievect, Vcl.ExtCtrls;

type
  TFormMerge = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    AdvPanel4: TPanel;
    BtnOpen1: TButton;
    ChkActive1: TCheckBox;
    Panel4: TPanel;
    BtnOpen2: TButton;
    ChkActive2: TCheckBox;
    Panel5: TPanel;
    BtnOpen3: TButton;
    ChkActive3: TCheckBox;
    ImageEnVectMain: TImageEnVect;
    ImageEnVect1: TImageEnVect;
    ImageEnVect2: TImageEnVect;
    ImageEnVect3: TImageEnVect;
    Panel2: TPanel;
    Panel7: TPanel;
    LabelZLayerIndex: TLabel;
    BtnUp: TButton;
    BtnDown: TButton;
    BtnHelp: TButton;
    Panel8: TPanel;
    BtnSaveProject: TSpeedButton;
    BtnLoadProject: TSpeedButton;
    Label1: TLabel;
    BtnSaveMiyelinImage: TSpeedButton;
    CmbLineThickness: TComboBox;
    StatusBar2: TStatusBar;
    Panel6: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    StringGrid1: TStringGrid;
    OpenImageEnDialog1: TOpenImageEnDialog;
    OpenImageEnDialog2: TOpenImageEnDialog;
    OpenImageEnDialog3: TOpenImageEnDialog;
    SavePictureDialog1: TSavePictureDialog;
    ImageEnVectTmp: TImageEnVect;
    GroupBox1: TGroupBox;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    GroupBox2: TGroupBox;
    BtnMiyelinDraw: TSpeedButton;
    BtnMiyelinSelect: TSpeedButton;
    BtnMiyelinDelete: TSpeedButton;
    BtnHist1: TButton;
    BtnHist2: TButton;
    BtnHist3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure BtnOpen1Click(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnLoadProjectClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure BtnMiyelinSelectClick(Sender: TObject);
    procedure BtnMiyelinDrawClick(Sender: TObject);
    procedure BtnMiyelinDeleteClick(Sender: TObject);
    procedure ImageEnVectMainNewObject(Sender: TObject; hobj: Integer);
    procedure ImageEnVectMainSelectObject(Sender: TObject);
    procedure SpeedButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CmbLineThicknessChange(Sender: TObject);
    procedure BtnSaveProjectClick(Sender: TObject);
    procedure BtnSaveMiyelinImageClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure ChkActive1Click(Sender: TObject);
    procedure BtnHist1Click(Sender: TObject);
  private
    { Private declarations }
    CurrObjID: Integer;
    ZLayerCount: Integer;
    procedure ColorFusion(ZIndex: Integer);
    procedure UpdateImageEnVectMainObjects(BoolShowNeighbours: Boolean);
    procedure CenterObjectOnImageView(hobj: Integer);
    procedure UpdateStringGrid;
    function GetGridRowFromObjID(ObjectID: Integer): Integer;
    function LoadedImageCount: Integer;

  public
    { Public declarations }
    ZLayerIndex: Integer;
  end;

var
  FormMerge: TFormMerge;

implementation

uses
  Math, hyiedefs, hyieutils, ioutils, inifiles, imageenproc;

{$R *.dfm}

procedure TFormMerge.BtnHelpClick(Sender: TObject);
begin
  MessageDlg('IEV1 ->  Yellow   IEV2 -> Gray ' + sLineBreak +
             'Press Space to hide drawings' + sLineBreak +
             'Press Ctrl+Space to hide selected drawing' + sLineBreak +
             'Press Ctrl+N to show Z+1, Z-1 drawings' + sLineBreak +
             'Press Show button to see end points of the drawings for shortenning' + sLineBreak +
             sLineBreak + 'Developed by ARGENIT 2019' + sLineBreak,
             mtInformation, [mbOK], 0);
end;

procedure TFormMerge.BtnHist1Click(Sender: TObject);
var
  IEVect: TImageEnVect;
  ChannelID: Integer;
begin
  ChannelID:= (Sender as TButton).Tag;
  IEVect:= TImageEnVect(FindComponent(Format('ImageEnVect%d', [ChannelID])));
  IEVect.Proc.DoPreviews([peEqualize]);

  ColorFusion(ZLayerIndex);
end;

procedure TFormMerge.BtnLoadProjectClick(Sender: TObject);
var
  i, hobj: Integer;
  IniFileName, FolderName, IevFileName1, IevFileName2: String;
begin
  if OpenDialog1.Execute then
  begin
    with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    begin
      WriteString('main', 'ProjectFile', OpenDialog1.FileName);
      Free;
    end;

    //IniFileName:= JvBrowseForFolderDialog1.Directory + '\Miyelin.ini';
    IniFileName:= OpenDialog1.FileName;

    if not FileExists(IniFileName) then
    begin
      MessageDlg('Can not find miyelin project', mtWarning, [mbOK], 0);
      Exit;
    end;

    FolderName:= IncludeTrailingPathDelimiter(ExtractFilePath(OpenDialog1.FileName));

    with TIniFile.Create(IniFileName) do
    begin
      OpenImageEnDialog1.FileName:= FolderName + ExtractFileName(ReadString('main', 'RedFileName', ''));
      OpenImageEnDialog2.FileName:= FolderName + ExtractFileName(ReadString('main', 'GreenFileName', ''));
      OpenImageEnDialog3.FileName:= FolderName + ExtractFileName(ReadString('main', 'BlueFileName', ''));
      IevFileName1:= FolderName + ExtractFileName(ReadString('main', 'IEV1', ''));
      IevFileName2:= FolderName + ExtractFileName(ReadString('main', 'IEV2', ''));
      Free;
    end;


    ImageEnVect1.IO.LoadFromFileTIFF(OpenImageEnDialog1.FileName);
    ChkActive1.Enabled:= True;
    ChkActive1.Checked:= True;

    ImageEnVect2.IO.LoadFromFileTIFF(OpenImageEnDialog2.FileName);
    ChkActive2.Enabled:= True;
    ChkActive2.Checked:= True;

    ImageEnVect3.IO.LoadFromFileTIFF(OpenImageEnDialog3.FileName);
    ChkActive3.Enabled:= True;
    ChkActive3.Checked:= True;


    ImageEnVectMain.RemoveAllObjects;
    CurrObjID:= 0;

    if FileExists(IevFileName1) then
    begin
      ImageEnVectTmp.RemoveAllObjects;
      ImageEnVectTmp.LoadFromFileIEV(IevFileName1);
      for i := 0 to ImageEnVectTmp.ObjectsCount-1 do
      begin
        hobj:= ImageEnVectTmp.GetObjFromIndex(i);
        ImageEnVectTmp.ObjID[hobj]:= CurrObjID; Inc(CurrObjID);
        ImageEnVectTmp.ObjPenColor[hobj]:= clYellow;
        ImageEnVectTmp.ObjBrushColor[hobj]:= clYellow;
        ImageEnVectTmp.CopyObjectTo(hobj, ImageEnVectMain);
      end;
    end;

    if FileExists(IevFileName2) then
    begin
      ImageEnVectTmp.RemoveAllObjects;
      ImageEnVectTmp.LoadFromFileIEV(IevFileName2);
      for i := 0 to ImageEnVectTmp.ObjectsCount-1 do
      begin
        hobj:= ImageEnVectTmp.GetObjFromIndex(i);
        ImageEnVectTmp.ObjID[hobj]:= CurrObjID; Inc(CurrObjID);
        ImageEnVectTmp.ObjPenColor[hobj]:= clGray;
        ImageEnVectTmp.ObjBrushColor[hobj]:= clGray;
        ImageEnVectTmp.CopyObjectTo(hobj, ImageEnVectMain);
      end;
    end;


    CurrObjID:= ImageEnVectMain.ObjID[ImageEnVectMain.ObjectsCount-1] + 1;

    ZLayerCount:= ImageEnVect1.IO.Params.TIFF_ImageCount;
    ZLayerIndex:= ZLayerCount div 2;
    LabelZLayerIndex.Caption:= ZLayerIndex.ToString;
    ColorFusion(ZLayerIndex);
    ImageEnVectMain.Fit;

    UpdateStringGrid;

  end;
end;


procedure TFormMerge.BtnMiyelinDeleteClick(Sender: TObject);
var
  i,  hobj: Integer;
begin
  for i := ImageEnVectMain.SelObjectsCount-1 downto 0 do
  begin
    hobj:= ImageEnVectMain.SelObjects[i];
    ImageEnVectMain.RemoveObject(hobj);
  end;

  UpdateStringGrid;
end;

procedure TFormMerge.BtnMiyelinDrawClick(Sender: TObject);
begin
  ImageEnVectMain.MouseInteractVt:= [miPutPolyLine, miUnStampMode];
  ImageEnVectMain.PolylineEndingMode:= ieemMouseUp;
  ImageEnVectMain.ObjPenColor[-1]:= clWhite;
  ImageEnVectMain.ObjPenWidth[-1]:= CmbLineThickness.ItemIndex+1;

  ImageEnVectMain.UnSelAllObjects;
end;

procedure TFormMerge.BtnMiyelinSelectClick(Sender: TObject);
begin
  ImageEnVectMain.MouseInteractVt:= [miObjectSelect];
end;

procedure TFormMerge.BtnOpen1Click(Sender: TObject);
var
  IEVect: TImageEnVect;
  ChannelID: Integer;
  OpenDialog: TOpenImageEnDialog;
  CheckBox: TCheckBox;
begin
  ImageEnVectMain.RemoveAllObjects;

  ChannelID:= (Sender as TButton).Tag;
  IEVect:= TImageEnVect(FindComponent(Format('ImageEnVect%d', [ChannelID])));
  OpenDialog:= TOpenImageEnDialog(FindComponent(Format('OpenImageEnDialog%d', [ChannelID])));
  CheckBox:= TCheckBox(FindComponent(Format('ChkActive%d', [ChannelID])));

  if OpenDialog.Execute then
  begin
    IEVect.IO.LoadFromFileTIFF(OpenDialog.FileName);

    CheckBox.Enabled:= True;
    CheckBox.Checked:= True;

    ZLayerCount:= IEVect.IO.Params.TIFF_ImageCount;
    ZLayerIndex:= ZLayerCount div 2;
    LabelZLayerIndex.Caption:= ZLayerIndex.ToString;

    if ChannelID = 3 then
    begin
      ColorFusion(ZLayerIndex);
      ImageEnVectMain.Fit;
    end;

    StringGrid1.RowCount:= 1;
  end;
end;

procedure TFormMerge.BtnSaveMiyelinImageClick(Sender: TObject);
var
  i, ImageCount: Integer;
  Temp: TImageEnVect;
  FName: String;
  TIFFHandler: TIETIFFHandler;

  procedure CopyAndBurnZObjects(AZIndex: Integer);
  var
    i, hobj, hobj2, ObjZ: Integer;
  begin
    Temp.RemoveAllObjects;
    Temp.Proc.Fill(clBlack);
    for i := 0 to ImageEnVectMain.ObjectsCount-1 do
    begin
      hobj:= ImageEnVectMain.GetObjFromIndex(i);
      ObjZ:= StrToIntDef(ImageEnVectMain.ObjName[hobj], 0);
      if ObjZ = AZIndex then
      begin
        hobj2:= ImageEnVectMain.CopyObjectTo(hobj, Temp);
        Temp.ObjStyle[hobj2]:= [ievsVisible];
        Temp.ObjPenColor[hobj2]:= clWhite;
        Temp.ObjSoftShadow[hobj2].Enabled:= False;
      end;
    end;
    Temp.CopyObjectsToBack(False, False, FAlse);
  end;
begin

  if SavePictureDialog1.Execute then
  begin
    SavePictureDialog1.FileName:= ChangeFileExt(SavePictureDialog1.FileName, '.tif');
    if FileExists(SavePictureDialog1.FileName) then DeleteFile(SavePictureDialog1.FileName);

    TIFFHandler:= TIETIFFHandler.Create;


    Temp:= TImageEnVect.Create(Nil);
    Temp.ObjAntialias:= False;
    Temp.IEBitmap.Width:= ImageEnVectMain.IEBitmap.Width;
    Temp.IEBitmap.Height:= ImageEnVectMain.IEBitmap.Height;

    CopyAndBurnZObjects(0);
    TIFFHandler.InsertPageAsImage(Temp, 0);

    for i := 1 to ZLayerCount-1 do
    begin
      CopyAndBurnZObjects(i);
      TIFFHandler.InsertPageAsImage(Temp, i);
    end;

    TIFFHandler.WriteFile(SavePictureDialog1.FileName);


    TIFFHandler.Free;
    Temp.Free;
  end;
end;


procedure TFormMerge.BtnSaveProjectClick(Sender: TObject);
var
  i, hobj: Integer;
  IniFileName, IevFileName, FolderPath: String;
begin
  if SaveDialog1.Execute then
  begin
    IniFileName:= SaveDialog1.FileName;
    IevFileName:= ChangeFileExt(SaveDialog1.FileName, '.iev');
    FolderPath:= IncludeTrailingPathDelimiter(ExtractFilePath(SaveDialog1.FileName));

    if FileExists(IevFileName) then
    begin
      if MessageDlg('File Exists, Overwrite?', mtWarning, [mbOK, mbCancel], 0) = mrCancel then
        Exit;
    end;

    for i := 0 to ImageEnVectMain.ObjectsCount-1 do
    begin
      hobj:= ImageEnVectMain.GetObjFromIndex(i);
      ImageEnVectMain.ObjPenColor[hobj]:= clWhite;
      ImageEnVectMain.ObjBrushColor[hobj]:= clWhite;
      ImageEnVectMain.ObjTransparency[hobj]:= 255;
      ImageEnVectMain.ObjStyle[hobj]:= [ievsVisible, ievsSelectable];
    end;

    ImageEnVectMain.SaveToFileIEV(IevFileName);

    with TIniFile.Create(IniFileName) do
    begin
      WriteString('main', 'RedFileName', ExtractFileName(OpenImageEnDialog1.FileName));
      WriteString('main', 'GreenFileName', ExtractFileName(OpenImageEnDialog2.FileName));
      WriteString('main', 'BlueFileName', ExtractFileName(OpenImageEnDialog3.FileName));
      WriteString('main', 'IEV1', IevFileName);
      Free;
    end;
  end;
end;

procedure TFormMerge.BtnUpClick(Sender: TObject);
begin
  ZLayerIndex:= Max(0, Min(ZLayerCount, ZLayerIndex + (Sender as TButton).Tag));
  ColorFusion(ZLayerIndex);

  LabelZLayerIndex.Caption:= ZLayerIndex.ToString;
end;

procedure TFormMerge.ColorFusion(ZIndex: Integer);
var
  i, j: Integer;
  Row1, Row2, Row3, Row4:  PRGBTriple;
begin
  ImageEnVect1.IO.Params.TIFF_ImageIndex:= ZIndex;
  ImageEnVect1.IO.LoadFromFileTIFF(OpenImageEnDialog1.FileName);
  ImageEnVect2.IO.Params.TIFF_ImageIndex:= ZIndex;
  ImageEnVect2.IO.LoadFromFileTIFF(OpenImageEnDialog2.FileName);
  ImageEnVect3.IO.Params.TIFF_ImageIndex:= ZIndex;
  ImageEnVect3.IO.LoadFromFileTIFF(OpenImageEnDialog3.FileName);

  ImageEnVectMain.IEBitmap.Width:= ImageEnVect1.IEBitmap.Width;
  ImageEnVectMain.IEBitmap.Height:= ImageEnVect1.IEBitmap.Height;
  ImageEnVectMain.IEBitmap.PixelFormat:= ie24RGB;

  ImageEnVect1.Proc.HistEqualize(ImageEnVect1.Proc.IPDialogParams.EQUALIZATION_EqDown, ImageEnVect1.Proc.IPDialogParams.EQUALIZATION_EqUp);
  ImageEnVect2.Proc.HistEqualize(ImageEnVect2.Proc.IPDialogParams.EQUALIZATION_EqDown, ImageEnVect2.Proc.IPDialogParams.EQUALIZATION_EqUp);
  ImageEnVect3.Proc.HistEqualize(ImageEnVect3.Proc.IPDialogParams.EQUALIZATION_EqDown, ImageEnVect3.Proc.IPDialogParams.EQUALIZATION_EqUp);


  for i := 0 to ImageEnVectMain.IEBitmap.Height-1 do
  begin
    Row1:= ImageEnVect1.IEBitmap.ScanLine[I];
    Row2:= ImageEnVect2.IEBitmap.ScanLine[I];
    Row3:= ImageEnVect3.IEBitmap.ScanLine[I];
    Row4:= ImageEnVectMain.IEBitmap.ScanLine[I];

    for j := 0 to ImageEnVectMain.IEBitmap.Width-1 do
    begin
      Row4.rgbtRed:= IfThen(ChkActive1.Checked, max(Row1.rgbtBlue, max(Row1.rgbtGreen, Row1.rgbtRed)), 0);
      Row4.rgbtGreen:= IfThen(ChkActive2.Checked, max(Row2.rgbtBlue, max(Row2.rgbtGreen, Row2.rgbtRed)), 0);
      Row4.rgbtBlue:= IfThen(ChkActive3.Checked, max(Row3.rgbtBlue, max(Row3.rgbtGreen, Row3.rgbtRed)), 0);

      Inc(Row1);
      Inc(Row2);
      Inc(Row3);
      Inc(Row4);
    end;

  end;

  ImageEnVectMain.Update;
  UpdateImageEnVectMainObjects(False);
end;

procedure TFormMerge.FormShow(Sender: TObject);
begin
  StringGrid1.Tag:= 1;
  StringGrid1.RowCount:= 1;
  StringGrid1.Cells[0, 0]:= 'Index';
  StringGrid1.Cells[1, 0]:= 'ID';
  StringGrid1.Cells[2, 0]:= 'ZLevel';
  StringGrid1.Tag:= 0;
  CurrObjID:= 0;

  ImageEnVectMain.MouseWheelParams.ZoomPosition:= iemwMouse;
  ImageEnVectMain.MouseInteractVt:= [miObjectSelect];
  CmbLineThickness.ItemIndex:= 2;

  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  begin
    OpenDialog1.FileName:= ReadString('main', 'ProjectFile', '');
    Free;
  end;

  ImageEnVect1.Proc.PreviewsParams:= [prppDefaultLockPreview];
end;

procedure TFormMerge.ImageEnVectMainNewObject(Sender: TObject; hobj: Integer);
begin
  ImageEnVectMain.ObjID[hobj]:= CurrObjID;
  Inc(CurrObjID);
  ImageEnVectMain.ObjName[hobj]:= IntToStr(ZLayerIndex);

  UpdateStringGrid;
end;

procedure TFormMerge.ImageEnVectMainSelectObject(Sender: TObject);
var
  GridRow, hobj: Integer;
begin
  if (ImageEnVectMain.SelObjectsCount = 0) or (ImageEnVectMain.Tag = 1) then
    Exit;

  hobj:= ImageEnVectMain.SelObjects[0];
  GridRow:= GetGridRowFromObjID(ImageEnVectMain.ObjID[hobj]);
  StringGrid1.Tag:= 1;
  StringGrid1.Row:= GridRow;
  StringGrid1.Tag:= 0;

  CmbLineThickness.ItemIndex:= ImageEnVectMain.ObjPenWidth[hobj]-1;
end;

function TFormMerge.LoadedImageCount: Integer;
begin
  Result:= 0;
  if OpenImageEnDialog1.FileName <> '' then Inc(Result);
  if OpenImageEnDialog2.FileName <> '' then Inc(Result);
  if OpenImageEnDialog3.FileName <> '' then Inc(Result);
end;

procedure TFormMerge.SpeedButton1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  hobj, SelHobj: Integer;
  P1, P2: TPoint;
begin
  if ImageEnVectMain.SelObjectsCount <> 1 then Exit;
  SelHobj:= ImageEnVectMain.SelObjects[0];

  P1:= ImageEnVectMain.ObjPolylinePoints[SelHobj, 0];
  P2:= ImageEnVectMain.ObjPolylinePoints[SelHobj, ImageEnVectMain.ObjPolylinePointsCount[SelHobj]-1];

  hobj:= ImageEnVectMain.AddNewObject(iekELLIPSE, Rect(P1.X-5, P1.Y-5, P1.X+5, P1.Y+5), clRed);
  ImageEnVectMain.ObjName[hobj]:= 'ENPOINT1';
  hobj:= ImageEnVectMain.AddNewObject(iekELLIPSE, Rect(P2.X-5, P2.Y-5, P2.X+5, P2.Y+5), clBlue);
  ImageEnVectMain.ObjName[hobj]:= 'ENPOINT2';
end;

procedure TFormMerge.SpeedButton1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  hobj: Integer;
begin
  hobj:= ImageEnVectMain.GetObjFromName('ENPOINT1');
  if hobj >= 0 then
    ImageEnVectMain.RemoveObject(hobj);

  hobj:= ImageEnVectMain.GetObjFromName('ENPOINT2');
  if hobj >= 0 then
    ImageEnVectMain.RemoveObject(hobj);
end;

procedure TFormMerge.SpeedButton2Click(Sender: TObject);
var
  i, SelHobj: Integer;
  PArray: array of TPoint;
begin
  if ImageEnVectMain.SelObjectsCount <> 1 then Exit;
  SelHobj:= ImageEnVectMain.SelObjects[0];

  SetLength(PArray, ImageEnVectMain.ObjPolylinePointsCount[SelHobj]-1);
  for i := 0 to Length(PArray)-1 do
    PArray[i]:= ImageEnVectMain.ObjPolylinePoints[SelHobj, i+1];

  ImageEnVectMain.SetObjPolylinePoints(SelHobj, PArray);
  ImageEnVectMain.Update;
end;

procedure TFormMerge.SpeedButton3Click(Sender: TObject);
var
  i, SelHobj: Integer;
  PArray: array of TPoint;
begin
  if ImageEnVectMain.SelObjectsCount <> 1 then Exit;
  SelHobj:= ImageEnVectMain.SelObjects[0];

  SetLength(PArray, ImageEnVectMain.ObjPolylinePointsCount[SelHobj]-1);
  for i := 0 to Length(PArray)-1 do
    PArray[i]:= ImageEnVectMain.ObjPolylinePoints[SelHobj, i];

  ImageEnVectMain.SetObjPolylinePoints(SelHobj, PArray);
  ImageEnVectMain.Update;
end;

procedure TFormMerge.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  hobj, ZIndex: Integer;
begin
  if (StringGrid1.Tag = 1) or (ARow < 1) then
    Exit;

  hobj:= ImageEnVectMain.GetObjFromID(StringGrid1.Cells[1, ARow].ToInteger);
  if hobj < 0 then
    Exit;
  ZIndex:= StrToIntDef(StringGrid1.Cells[2, ARow], -1);
  if ZIndex < 0 then
    Exit;

  ZLayerIndex:= Max(0, Min(ZLayerCount, ZIndex));
  ColorFusion(ZLayerIndex);

  LabelZLayerIndex.Caption:= ZLayerIndex.ToString;

  ImageEnVectMain.Tag:= 1;
  ImageEnVectMain.UnSelAllObjects;
  ImageEnVectMain.AddSelObject(hobj);
  CenterObjectOnImageView(hobj);
  ImageEnVectMain.Tag:= 0;

  ImageEnVectMain.SetFocus;
end;

procedure TFormMerge.UpdateImageEnVectMainObjects(BoolShowNeighbours: Boolean);
var
  i, hobj, ObjZ: Integer;
begin
  for i := 0 to ImageEnVectMain.ObjectsCount-1 do
  begin
    hobj:= ImageEnVectMain.GetObjFromIndex(i);
    ObjZ:= StrToIntDef(ImageEnVectMain.ObjName[hobj], 0);
    if ObjZ = ZLayerIndex then
    begin
      ImageEnVectMain.ObjStyle[hobj]:= [ievsVisible, ievsSelectable];
      ImageEnVectMain.ObjTransparency[hobj]:= 255;
//      ImageEnVectMain.ObjPenColor[hobj]:= clWhite;
    end
    else if (BoolShowNeighbours = True) and (Abs(ObjZ - ZLayerIndex) = 1) then
    begin
      ImageEnVectMain.ObjStyle[hobj]:= [ievsVisible];
      ImageEnVectMain.ObjTransparency[hobj]:= 128;
      ImageEnVectMain.ObjPenColor[hobj]:= clFuchsia;
    end
    else
    begin
      ImageEnVectMain.ObjStyle[hobj]:= [];
      ImageEnVectMain.ObjTransparency[hobj]:= 255;
//      ImageEnVectMain.ObjPenColor[hobj]:= clWhite;
    end;

  end;
end;

procedure TFormMerge.CenterObjectOnImageView(hobj: Integer);
var
  CenterP, TopLeftP: TPoint;
  ObjRect: TRect;
begin
  // obje resmin disina tasmiyorsa ortalama
  ImageEnVectMain.GetObjRect(hobj, ObjRect);
  ObjRect.Left:= Round(ObjRect.Left * (ImageEnVectMain.ZoomX / 100));
  ObjRect.Right:= Round(ObjRect.Right * (ImageEnVectMain.ZoomX / 100));
  ObjRect.Top:= Round(ObjRect.Top * (ImageEnVectMain.ZoomY / 100));
  ObjRect.Bottom:= Round(ObjRect.Bottom * (ImageEnVectMain.ZoomY / 100));

  if (ObjRect.Left >= ImageEnVectMain.ViewX) and (ObjRect.Top >= ImageEnVectMain.ViewY) and
     (ObjRect.Right <= ImageEnVectMain.ViewX + ImageEnVectMain.ExtentX) and
     (ObjRect.Bottom <= ImageEnVectMain.ViewY + ImageEnVectMain.ExtentY) then
  Exit;


  CenterP.X:= ImageEnVectMain.ObjLeft[hobj] + (ImageEnVectMain.ObjWidth[hobj] div 2);
  CenterP.Y:= ImageEnVectMain.ObjTop[hobj] + (ImageEnVectMain.ObjHeight[hobj] div 2);

  CenterP.X:= Round(CenterP.X * (ImageEnVectMain.ZoomX / 100));
  CenterP.Y:= Round(CenterP.Y * (ImageEnVectMain.ZoomY / 100));

  TopLeftP.X:= max(0, CenterP.X - (ImageEnVectMain.ExtentX div 2));
  TopLeftP.Y:= max(0, CenterP.Y - (ImageEnVectMain.ExtentY div 2));

  ImageEnVectMain.SetViewXY(TopLeftP.X, TopLeftP.Y);
end;

procedure TFormMerge.ChkActive1Click(Sender: TObject);
begin
  if LoadedImageCount = 3 then
    ColorFusion(ZLayerIndex);
end;

procedure TFormMerge.CmbLineThicknessChange(Sender: TObject);
var
  i,  hobj: Integer;
begin
  for i := ImageEnVectMain.SelObjectsCount-1 downto 0 do
  begin
    hobj:= ImageEnVectMain.SelObjects[i];
    ImageEnVectMain.ObjPenWidth[hobj]:= CmbLineThickness.ItemIndex+1;
  end;

  ImageEnVectMain.ObjPenWidth[-1]:= CmbLineThickness.ItemIndex+1;
end;

procedure TFormMerge.UpdateStringGrid;
var
  i, hobj, SelHobj: Integer;
begin
  StringGrid1.Tag:= 1;

  if StringGrid1.RowCount > 1 then
  begin
    SelHobj:= ImageEnVectMain.GetObjFromID(StringGrid1.Cells[1, StringGrid1.Row].ToInteger);
  end
  else
    SelHobj:= -1;

  StringGrid1.RowCount:= ImageEnVectMain.ObjectsCount + 1;
  for i := 0 to ImageEnVectMain.ObjectsCount-1 do
  begin
    hobj:= ImageEnVectMain.GetObjFromIndex(i);
    StringGrid1.Cells[0, i+1]:= IntToStr(i+1);
    StringGrid1.Cells[1, i+1]:= IntToStr(ImageEnVectMain.ObjID[hobj]);
    StringGrid1.Cells[2, i+1]:= ImageEnVectMain.ObjName[hobj];
  end;

  StringGrid1.Tag:= 0;

  if SelHobj > -1 then
  begin

  ImageEnVectMain.AddSelObject(SelHobj);
  ImageEnVectMainSelectObject(Nil);
  end;

end;

function TFormMerge.GetGridRowFromObjID(ObjectID: Integer): Integer;
var
  i: Integer;
begin
  Result:= -1;
  for i := 1 to StringGrid1.RowCount-1 do
  if ObjectID.ToString = StringGrid1.Cells[1, i] then
  begin
    Result:= i;
    Exit;
  end;
end;

end.

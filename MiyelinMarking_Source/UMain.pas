{
  2.0.0.0: "Merge Edit" butonu ile iki iþaretlemenin ayný alanda gösterilmesi özelliði eklendi
  3.0.0.0: "Convert Binary Image To Vector" butonu ile binary miyelin maskesinden vektör oluþturma eklendi (CEM sonuçlarýný eklemek için)
  3.1.0.0: "Save Project" butonuna basýldýðýnda ilgili klasördeki herþeyi temizlemesi engellendi

}


unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, ieview, imageenview, ievect, ieopensavedlg, Vcl.Buttons,
  Vcl.Grids, JvBaseDlg, JvBrowseFolder, Vcl.AppEvnts, Vcl.ExtDlgs;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ImageEnVectMain: TImageEnVect;
    AdvPanel4: TPanel;
    BtnOpen1: TButton;
    ChkActive1: TCheckBox;
    Panel4: TPanel;
    BtnOpen2: TButton;
    ChkActive2: TCheckBox;
    Panel5: TPanel;
    BtnOpen3: TButton;
    ChkActive3: TCheckBox;
    ImageEnVect1: TImageEnVect;
    ImageEnVect2: TImageEnVect;
    ImageEnVect3: TImageEnVect;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    Panel7: TPanel;
    Panel8: TPanel;
    BtnUp: TButton;
    BtnDown: TButton;
    OpenImageEnDialog1: TOpenImageEnDialog;
    OpenImageEnDialog2: TOpenImageEnDialog;
    OpenImageEnDialog3: TOpenImageEnDialog;
    BtnMiyelinDelete: TSpeedButton;
    BtnMiyelinDraw: TSpeedButton;
    BtnMiyelinSelect: TSpeedButton;
    Panel6: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    StringGrid1: TStringGrid;
    LabelZLayerIndex: TLabel;
    BtnSaveProject: TSpeedButton;
    BtnLoadProject: TSpeedButton;
    JvBrowseForFolderDialog1: TJvBrowseForFolderDialog;
    CmbLineThickness: TComboBox;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    BtnHelp: TButton;
    BtnSaveMiyelinImage: TSpeedButton;
    SavePictureDialog1: TSavePictureDialog;
    SpeedButton1: TSpeedButton;
    ImageEnVectTemp: TImageEnVect;
    BtnConvertBinaryImageToVector: TSpeedButton;
    OpenImageEnDialogTemp: TOpenImageEnDialog;
    procedure BtnOpen1Click(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure ChkActive1Click(Sender: TObject);
    procedure BtnMiyelinDrawClick(Sender: TObject);
    procedure BtnMiyelinSelectClick(Sender: TObject);
    procedure BtnMiyelinDeleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImageEnVectMainNewObject(Sender: TObject; hobj: Integer);
    procedure ImageEnVectMainSelectObject(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnSaveProjectClick(Sender: TObject);
    procedure BtnLoadProjectClick(Sender: TObject);
    procedure CmbLineThicknessChange(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure BtnHelpClick(Sender: TObject);
    procedure BtnSaveMiyelinImageClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnConvertBinaryImageToVectorClick(Sender: TObject);
  private
    { Private declarations }
    CurrObjID: Integer;
    ZLayerCount: Integer;
    procedure ColorFusion(ZIndex: Integer);
    function LoadedImageCount: Integer;
    procedure UpdateStringGrid;
    function GetGridRowFromObjID(ObjectID: Integer): Integer;
    procedure CenterObjectOnImageView(hobj: Integer);
  public
    { Public declarations }
    ZLayerIndex: Integer;
  end;

var
  FormMain: TFormMain;

implementation

uses
  Math, hyiedefs, hyieutils, ioutils, inifiles, imageenproc, UMergeForm,
  UBlobColoring, UGrayImage, UThresholding;

{$R *.dfm}

procedure UpdateImageEnVectMainObjects(IEVect: TImageEnVect; BoolShowNeighbours: Boolean; ZIndex: Integer);
var
  i, hobj, ObjZ: Integer;
begin
  for i := 0 to IEVect.ObjectsCount-1 do
  begin
    hobj:= IEVect.GetObjFromIndex(i);
    ObjZ:= StrToIntDef(IEVect.ObjName[hobj], 0);
    if ObjZ = ZIndex then
    begin
      IEVect.ObjStyle[hobj]:= [ievsVisible, ievsSelectable];
      IEVect.ObjTransparency[hobj]:= 255;
      //IEVect.ObjPenColor[hobj]:= clWhite;
    end
    else if (BoolShowNeighbours = True) and (Abs(ObjZ - ZIndex) = 1) then
    begin
      IEVect.ObjStyle[hobj]:= [ievsVisible];
      IEVect.ObjTransparency[hobj]:= 128;
      //IEVect.ObjPenColor[hobj]:= clFuchsia;
    end
    else
    begin
      IEVect.ObjStyle[hobj]:= [];
      IEVect.ObjTransparency[hobj]:= 255;
      //IEVect.ObjPenColor[hobj]:= clWhite;
    end;

  end;
end;

procedure SelectBlobRegion(IEVect: TImageEnVect; ABlob: TGrayImage; BlobObjPix: Byte = 255; BoolReset: Boolean = True);
var
  i,j: Integer;
begin
  if BoolReset = True then
    IEVect.DeSelect;

  for i := ABlob.BoundingBox.Top to ABlob.BoundingBox.Bottom do
  begin
    for j := ABlob.BoundingBox.Left to ABlob.BoundingBox.Right do
    begin
      if ABlob.PixelData[i-ABlob.BoundingBox.Top,j-ABlob.BoundingBox.Left] = BlobObjPix then
      begin
        IEVect.SelectionMask.SetPixel(j,i,1);
      end;
    end;
  end;

  IEVect.SelectCustom;
end;



procedure TFormMain.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
var
  IMG: TImageEnVect;
  hobj, ZIndex: Integer;
begin
  if FormMerge.Showing then
  begin
    IMG:= FormMerge.ImageEnVectMain;
    ZIndex:= FormMerge.ZLayerIndex;
  end
  else
  begin
    IMG:= FormMain.ImageEnVectMain;
    ZIndex:= FormMain.ZLayerIndex;
  end;


  if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_SPACE) then
  begin
    if (GetKeyState(VK_CONTROL) < 0) and (IMG.SelObjectsCount = 1) then
    begin
      hobj:= IMG.SelObjects[0];
      IMG.ObjStyle[hobj]:= [ievsSelectable]
    end
    else
      IMG.AllObjectsHidden:= True;
    Handled := True;
  end
  else if (Msg.message = WM_KEYUP) and (Msg.wParam = VK_SPACE) then
  begin
    if (GetKeyState(VK_CONTROL) < 0) and (IMG.SelObjectsCount = 1) then
      IMG.ObjStyle[IMG.SelObjects[0]]:= [ievsSelectable, ievsVisible];

    IMG.AllObjectsHidden:= False;

    Handled := True;
  end
  else if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_ESCAPE) then
  begin
    IMG.UnSelAllObjects;


    Handled := True;
  end
  else if (Msg.message = WM_KEYDOWN) and (Msg.wParam in [Ord(Char('N')), Ord(Char('n'))]) and (GetKeyState(VK_CONTROL) < 0) then
  begin
     UpdateImageEnVectMainObjects(IMG, True, ZIndex);
  end
  else if (Msg.message = WM_KEYUP) and (Msg.wParam in [Ord(Char('N')), Ord(Char('n'))]) and (GetKeyState(VK_CONTROL) < 0) then
  begin
     UpdateImageEnVectMainObjects(IMG, False, ZIndex);
  end

end;

procedure TFormMain.BtnConvertBinaryImageToVectorClick(Sender: TObject);
var
  i,j,k, hobj: Integer;
  GrayImage: TGrayImage;
begin
  if MessageDlg('Is the binary miyelin mask image in the project folder?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    MessageDlg('Please copy the binary miyelin mask image into project folder', mtWarning, [mbOK], 0);
    Exit;
  end;

  if OpenImageEnDialogTemp.Execute then
  begin
    ImageEnVectTemp.IO.LoadFromFileTIFF(OpenImageEnDialogTemp.FileName);
    ImageEnVectTemp.RemoveAllObjects;

    for k := 0 to ImageEnVectTemp.IO.Params.TIFF_ImageCount-1 do
    begin
      ImageEnVectTemp.IO.Params.TIFF_ImageIndex:= k;
      ImageEnVectTemp.IO.LoadFromFileTIFF(OpenImageEnDialogTemp.FileName);
      //      ImageEnVectTemp.IO.SaveToFile('c:\temp\' + k.ToString + '.bmp');

      //blob coloring ile miyelin parçalarýný bul
      //her parçadan poligon yarat ve iev olarak kaydet

      GrayImage:= TGrayImage.Create(ImageEnVectTemp.IEBitmap);
      //GrayImage.SaveGrayBitmapToFile('c:\temp\' + k.ToString + '.bmp');


      ImageEnVectTemp.DeSelect;

      for i := 0 to GrayImage.Height - 1 do
      begin
        for j := 0 to GrayImage.Width - 1 do
        begin
          if GrayImage.PixelData[i,j] > 128 then
          begin
            ImageEnVectTemp.SelectionMask.SetPixel(j,i,1);
          end;
        end;
      end;

      ImageEnVectTemp.SelectCustom;

      ImageEnVectTemp.ObjName[-1]:= k.ToString;
      ImageEnVectTemp.ObjPenColor[-1]:= clWhite;
      ImageEnVectTemp.ObjBrushColor[-1]:= clWhite;
      ImageEnVectTemp.ObjBrushStyle[-1]:= bsSolid;
      ImageEnVectTemp.ObjPolylineClosed[-1]:= True;
      ImageEnVectTemp.CreatePolygonsFromSelection;
      ImageEnVectTemp.DeSelect;
      ImageEnVectTemp.Refresh;



      GrayImage.Free;
    end;

    for i := 0 to ImageEnVectTemp.ObjectsCount - 1 do
    begin
      hobj:= ImageEnVectTemp.GetObjFromIndex(i);
      ImageEnVectTemp.ObjID[hobj]:= i;
    end;


    ImageEnVectTemp.SaveToFileIEV(ExtractFilePath(OpenImageEnDialogTemp.FileName) +  '\Miyelin.iev');

    ImageEnVectMain.LoadFromFileIEV(ExtractFilePath(OpenImageEnDialogTemp.FileName) +  '\Miyelin.iev');
    CurrObjID:= ImageEnVectMain.ObjID[ImageEnVectMain.ObjectsCount-1] + 1;
    UpdateStringGrid;


  end;
end;

procedure TFormMain.BtnHelpClick(Sender: TObject);
begin
  MessageDlg('Press Space to hide drawings' + sLineBreak + 'Press Ctrl+N to show Z+1, Z-1 drawings', mtInformation, [mbOK], 0);
end;

procedure TFormMain.BtnLoadProjectClick(Sender: TObject);
var
  IevFileName, FolderName: String;
begin
  if JvBrowseForFolderDialog1.Execute then
  begin
    IevFileName:= JvBrowseForFolderDialog1.Directory + '\Miyelin.iev';
    if not FileExists(IevFileName) then
    begin
      MessageDlg('Can not find Miyelin.iev', mtWarning, [mbOK], 0);
      Exit;
    end;

    with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    begin
      WriteString('main', 'ProjectFolder', JvBrowseForFolderDialog1.Directory);
      Free;
    end;

    with TIniFile.Create(JvBrowseForFolderDialog1.Directory + '\Miyelin.ini') do
    begin
      OpenImageEnDialog1.FileName:= IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory) + ExtractFileName(ReadString('main', 'RedFileName', ''));
      OpenImageEnDialog2.FileName:= IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory) + ExtractFileName(ReadString('main', 'GreenFileName', ''));
      OpenImageEnDialog3.FileName:= IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory) + ExtractFileName(ReadString('main', 'BlueFileName', ''));
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

    ImageEnVectMain.LoadFromFileIEV(IevFileName);
    CurrObjID:= ImageEnVectMain.ObjID[ImageEnVectMain.ObjectsCount-1] + 1;

    ZLayerCount:= ImageEnVect1.IO.Params.TIFF_ImageCount;
    ZLayerIndex:= ZLayerCount div 2;
    LabelZLayerIndex.Caption:= ZLayerIndex.ToString;
    ColorFusion(ZLayerIndex);
    ImageEnVectMain.Fit;

    UpdateStringGrid;

  end;
end;

procedure TFormMain.BtnMiyelinDeleteClick(Sender: TObject);
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

procedure TFormMain.BtnMiyelinDrawClick(Sender: TObject);
begin
  ImageEnVectMain.MouseInteractVt:= [miPutPolyLine, miUnStampMode];
  ImageEnVectMain.PolylineEndingMode:= ieemMouseUp;
  ImageEnVectMain.ObjPenColor[-1]:= clWhite;
  ImageEnVectMain.ObjPenWidth[-1]:= CmbLineThickness.ItemIndex+1;

  ImageEnVectMain.UnSelAllObjects;
end;

procedure TFormMain.BtnMiyelinSelectClick(Sender: TObject);
begin
  ImageEnVectMain.MouseInteractVt:= [miObjectSelect];
end;

procedure TFormMain.BtnOpen1Click(Sender: TObject);
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

procedure TFormMain.BtnSaveMiyelinImageClick(Sender: TObject);
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

procedure TFormMain.BtnSaveProjectClick(Sender: TObject);
var
  IevFileName: String;
begin
  if JvBrowseForFolderDialog1.Execute then
  begin
    IevFileName:= JvBrowseForFolderDialog1.Directory + '\Miyelin.iev';

    if FileExists(IevFileName) then
    begin
      if MessageDlg('Folder is not empty. Overwrite?', mtWarning, [mbOK, mbCancel], 0) = mrCancel then
        Exit;
    end;

    ImageEnVectMain.SaveToFileIEV(IevFileName);

    with TIniFile.Create(JvBrowseForFolderDialog1.Directory + '\Miyelin.ini') do
    begin
      WriteString('main', 'RedFileName', ExtractFileName(OpenImageEnDialog1.FileName));
      WriteString('main', 'GreenFileName', ExtractFileName(OpenImageEnDialog2.FileName));
      WriteString('main', 'BlueFileName', ExtractFileName(OpenImageEnDialog3.FileName));
      Free;
    end;
  end;
end;

procedure TFormMain.BtnUpClick(Sender: TObject);
begin
  ZLayerIndex:= Max(0, Min(ZLayerCount, ZLayerIndex + (Sender as TButton).Tag));
  ColorFusion(ZLayerIndex);

  LabelZLayerIndex.Caption:= ZLayerIndex.ToString;
end;

procedure TFormMain.ChkActive1Click(Sender: TObject);
begin
  if LoadedImageCount = 3 then
    ColorFusion(ZLayerIndex);
end;

procedure TFormMain.CmbLineThicknessChange(Sender: TObject);
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

procedure TFormMain.ColorFusion(ZIndex: Integer);
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
  UpdateImageEnVectMainObjects(ImageEnVectMain, False, ZLayerIndex);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  StringGrid1.Cells[0, 0]:= 'Index';
  StringGrid1.Cells[1, 0]:= 'ID';
  StringGrid1.Cells[2, 0]:= 'ZLevel';
  CurrObjID:= 0;

  ImageEnVectMain.MouseWheelParams.ZoomPosition:= iemwMouse;
  CmbLineThickness.ItemIndex:= 2;

  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  begin
    JvBrowseForFolderDialog1.Directory:= ReadString('main', 'ProjectFolder', '');
    Free;
  end;

  //FormMerge.Show;
end;

function TFormMain.GetGridRowFromObjID(ObjectID: Integer): Integer;
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

procedure TFormMain.ImageEnVectMainNewObject(Sender: TObject; hobj: Integer);
begin
  ImageEnVectMain.ObjID[hobj]:= CurrObjID;
  Inc(CurrObjID);
  ImageEnVectMain.ObjName[hobj]:= IntToStr(ZLayerIndex);

  UpdateStringGrid;
end;

procedure TFormMain.ImageEnVectMainSelectObject(Sender: TObject);
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

function TFormMain.LoadedImageCount: Integer;
begin
  Result:= 0;
  if OpenImageEnDialog1.FileName <> '' then Inc(Result);
  if OpenImageEnDialog2.FileName <> '' then Inc(Result);
  if OpenImageEnDialog3.FileName <> '' then Inc(Result);
end;

procedure TFormMain.SpeedButton1Click(Sender: TObject);
begin
  FormMerge.ShowModal;
end;

procedure TFormMain.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  hobj, ZIndex: Integer;
begin
  if StringGrid1.Tag = 1 then
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
end;


procedure TFormMain.UpdateStringGrid;
var
  i, hobj: Integer;
begin
  StringGrid1.Tag:= 1;
  StringGrid1.RowCount:= ImageEnVectMain.ObjectsCount + 1;

  for i := 0 to ImageEnVectMain.ObjectsCount-1 do
  begin
    hobj:= ImageEnVectMain.GetObjFromIndex(i);
    StringGrid1.Cells[0, i+1]:= IntToStr(i+1);
    StringGrid1.Cells[1, i+1]:= IntToStr(ImageEnVectMain.ObjID[hobj]);
    StringGrid1.Cells[2, i+1]:= ImageEnVectMain.ObjName[hobj];
  end;
  StringGrid1.Tag:= 0;
end;

procedure TFormMain.CenterObjectOnImageView(hobj: Integer);
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


end.

unit SearchFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, DB, DBClient, Provider, jvuibdataset, jvuib, ComCtrls,
  RzButton, StdCtrls, Mask, RzEdit, RzCmboBx, RzPanel, ExtCtrls,CommonLIB;

type
  TfrmSearch = class(TForm)
    pnClientContainer: TPanel;
    pnTop: TRzPanel;
    Label7: TLabel;
    Label1: TLabel;
    cmbSearchType: TRzComboBox;
    edSearchText: TRzEdit;
    btnSearch: TRzBitBtn;
    ListView: TListView;
    cdsSearch: TClientDataSet;
    dscSearch: TDataSource;
    ImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
  private
    FSQL: string;
    FSearchType: TList;
    FColsWidth: TList;
    FCols: Tlist;
    FSelectName: string;
    FSelectCode: string;
    FDLLParameter: TDLLParameter;
    FSelectField: string;
    FSearchTitle: string;


    procedure SetSQL(const Value: string);
    procedure SetSearchType(const Value: TList);
    procedure SetCols(const Value: Tlist);
    procedure SetColsWidth(const Value: TList);
    procedure SetSelectCode(const Value: string);
    procedure SetSelectName(const Value: string);
    procedure SetDLLParameter(const Value: TDLLParameter);
    procedure fillListview();
    procedure SetSelectField(const Value: string);
    procedure SetSearchTitle(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property SQL : string  read FSQL write SetSQL;
    property SearchType : TList read FSearchType write SetSearchType;
    property Cols : Tlist  read FCols write SetCols;
    property ColsWidth : TList read FColsWidth write SetColsWidth;
    property SelectCode : string read FSelectCode write SetSelectCode;
    property SelectName : string read FSelectName write SetSelectName;
    property SelectField : string  read FSelectField write SetSelectField;
    property DLLParameter : TDLLParameter read FDLLParameter write SetDLLParameter;
    property SearchTitle : string read FSearchTitle write SetSearchTitle;

  end;

var
  frmSearch: TfrmSearch;

implementation

uses STDLIB;

{$R *.dfm}

{ TfrmSearch }

procedure TfrmSearch.SetCols(const Value: Tlist);
begin
  FCols := Value;
end;

procedure TfrmSearch.SetColsWidth(const Value: TList);
begin
  FColsWidth := Value;
end;

procedure TfrmSearch.SetDLLParameter(const Value: TDLLParameter);
begin
  FDLLParameter := Value;
end;

procedure TfrmSearch.SetSearchType(const Value: TList);
begin
  FSearchType := Value;
end;



procedure TfrmSearch.SetSelectCode(const Value: string);
begin
  FSelectCode := Value;
end;

procedure TfrmSearch.SetSelectName(const Value: string);
begin
  FSelectName := Value;
end;

procedure TfrmSearch.SetSQL(const Value: string);
begin
  FSQL := Value;
end;

procedure TfrmSearch.FormShow(Sender: TObject);
var i:integer;
    col : TListColumn;
begin

  // load search type
  if (SearchType<>nil) then
  begin
    cmbSearchType.Items.Clear;
    for i:=0 to SearchType.Count-1 do
      cmbSearchType.Items.AddObject(TStringValue(SearchType[i]).Value,TString.Create(TStringValue(SearchType[i]).Code));

    cmbSearchType.ItemIndex:=0;      
  end;


  // load cols
  if ((Cols<>nil) and (ColsWidth<>nil )) then
  begin
    ListView.Columns.Clear;

    for i:=0 to Cols.Count-1 do
    begin
      col := ListView.Columns.Add;
      col.Caption := TStringValue(Cols[i]).Value;
      col.Width := strtoint(TStringValue(ColsWidth[i]).Value);
    end;

  end;

  cdsSearch.Data := GetDataSet(SQL);

  if cdsSearch.Active then fillListview;
  
end;

procedure TfrmSearch.fillListview;
var
  item : TListItem;
  i:integer;
begin
 if cdsSearch.Active then
   with  cdsSearch do
   begin
      self.Caption:=DLLParameter.SearchTitle+' ( จำนวน '+inttostr(recordcount)+' รายการ )';
      ListView.Items.Clear;
      first;
      while not cdsSearch.Eof do
      begin
        if cols<>nil then
          begin
             item := ListView.Items.Add;

             for i := 0 to cols.Count-1 do
              if i=0 then
                item.Caption:=fieldbyname(TStringValue(Cols[i]).code).AsString
              else
              item.SubItems.Add(fieldbyname(TStringValue(Cols[i]).code).AsString);

             item.Data := TString.Create(fieldbyname(SelectField).AsString);
          end;

         {
         item := ListView.Items.Add;
         item.Caption:= fieldbyname('CIFCODE').AsString;
         item.SubItems.Add(fieldbyname('FNAME').AsString) ;
         item.SubItems.Add(fieldbyname('LNAME').AsString) ;
         item.SubItems.Add(fieldbyname('IDCARD').AsString) ;
         item.Data := TString.Create(fieldbyname('CIFCODE').AsString);
         }
        if not cdsSearch.Eof then next;
      end;
   end;
end;


procedure TfrmSearch.SetSelectField(const Value: string);
begin
  FSelectField := Value;
end;

procedure TfrmSearch.btnSearchClick(Sender: TObject);
var strSQL:string;
begin

  cdsSearch.Data :=GetDataSet(SQL+ ' and '+TString(cmbSearchType.Items.Objects[cmbSearchType.ItemIndex]).Str+' like '''+edSearchText.Text+'%'' ');

  if cdsSearch.Active then fillListview;
end;

procedure TfrmSearch.ListViewDblClick(Sender: TObject);
begin
    FSelectCode:=TString(ListView.Selected.Data).Str;
    close;
end;

procedure TfrmSearch.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then close;
  if key = vk_return then
  begin
      if ListView.Selected<> nil then
       if ListView.Focused then
        begin
          ListViewDblClick(sender);
        end;

      if edSearchText.Focused then
        begin
          btnSearchClick(nil);
        end;
  end;


  if key = vk_down then
    if (( not ListView.Focused) and (not cmbSearchType.Focused)) then
    begin
        ListView.SetFocus;
    end;
end;

procedure TfrmSearch.ListViewCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  recTemp   : TRect;
  iWidth    : integer;
  i         : integer;
  bmpImage  : TBitmap;
begin
  if (Item.Selected) then
    Sender.Canvas.Brush.Color := $00FF8080// $02D6E9D6//$02D6E9D6 // $00FFDFBF
//    Sender.Canvas.Brush.Color := $00FFDFBF//$02D6E9D6 // $00FFDFBF
  else
  begin
    Sender.Canvas.Brush.Color := clWhite;
    sender.canvas.pen.Color := clblack;
  end;
  iWidth := 0;
  for i := 0 to SubItem-1 do
    iWidth := iWidth + ListView.Columns[i].Width;

  recTemp := Item.DisplayRect(drBounds);

  if (SubItem = 1) then
  begin
    Sender.Canvas.TextRect(recTemp,recTemp.left+5,recTemp.top,Item.Caption);
  end;
 // if (SubItem < 4) then
    Sender.Canvas.TextOut(recTemp.Left+iWidth, recTemp.Top, Item.SubItems[SubItem-1]) ;
 // else
  //begin
  {
    bmpImage := TBitmap.Create();
    i := Item.SubItemImages[SubItem-1];
    ImageList.GetBitmap(0, bmpImage);
    Sender.Canvas.Draw(recTemp.Left+iWidth+5, recTemp.Top+1, bmpImage);
    bmpImage.Free();
    }

  //end;
  DefaultDraw := false;
end;


procedure TfrmSearch.SetSearchTitle(const Value: string);
begin
  FSearchTitle := Value;
end;

end.



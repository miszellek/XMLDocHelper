unit Song_GeneratedByXMLDataBinding;

interface

uses xmldom, XMLDoc, XMLIntf;

type

  { Forward Decls }

  IXMLArtists = interface;
  IXMLArtist_art = interface;
  IXMLName_art = interface;
  IXMLSong = interface;

  { IXMLArtists }

  IXMLArtists = interface(IXMLNodeCollection)
    ['{F208170C-788F-4E50-94CD-F596B8CDA45D}']
    { Property Accessors }
    function Get_Artist(Index: Integer): IXMLArtist_art;
    { Methods & Properties }
    function Add: IXMLArtist_art;
    function Insert(const Index: Integer): IXMLArtist_art;
    property Artist[Index: Integer]: IXMLArtist_art read Get_Artist; default;
  end;

  { IXMLArtist_art }

  IXMLArtist_art = interface(IXMLNode)
    ['{B1694B01-C974-4E0E-9CC8-8B0CFBB2FDC5}']
    { Property Accessors }
    function Get_BirthYear: UnicodeString;
    function Get_Name: IXMLName_art;
    procedure Set_BirthYear(Value: UnicodeString);
    { Methods & Properties }
    property BirthYear: UnicodeString read Get_BirthYear write Set_BirthYear;
    property Name: IXMLName_art read Get_Name;
  end;

  { IXMLName_art }

  IXMLName_art = interface(IXMLNode)
    ['{59B4A667-561F-4C38-A11E-69DB14BD398D}']
    { Property Accessors }
    function Get_Title: UnicodeString;
    function Get_FirstName: UnicodeString;
    function Get_LastName: UnicodeString;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_FirstName(Value: UnicodeString);
    procedure Set_LastName(Value: UnicodeString);
    { Methods & Properties }
    property Title: UnicodeString read Get_Title write Set_Title;
    property FirstName: UnicodeString read Get_FirstName write Set_FirstName;
    property LastName: UnicodeString read Get_LastName write Set_LastName;
  end;

  { IXMLSong }

  IXMLSong = interface(IXMLNode)
    ['{E5BCDD2D-73DD-44A9-9562-CE39B39EBFF0}']
    { Property Accessors }
    function Get_Title: UnicodeString;
    function Get_Year: UnicodeString;
    function Get_Artists: IXMLArtists;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Year(Value: UnicodeString);
    { Methods & Properties }
    property Title: UnicodeString read Get_Title write Set_Title;
    property Year: UnicodeString read Get_Year write Set_Year;
    property Artists: IXMLArtists read Get_Artists;
  end;

  { Forward Decls }

  TXMLArtists = class;
  TXMLArtist_art = class;
  TXMLName_art = class;
  TXMLSong = class;

  { TXMLArtists }

  TXMLArtists = class(TXMLNodeCollection, IXMLArtists)
  protected
    { IXMLArtists }
    function Get_Artist(Index: Integer): IXMLArtist_art;
    function Add: IXMLArtist_art;
    function Insert(const Index: Integer): IXMLArtist_art;
  public
    procedure AfterConstruction; override;
  end;

  { TXMLArtist_art }

  TXMLArtist_art = class(TXMLNode, IXMLArtist_art)
  protected
    { IXMLArtist_art }
    function Get_BirthYear: UnicodeString;
    function Get_Name: IXMLName_art;
    procedure Set_BirthYear(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

  { TXMLName_art }

  TXMLName_art = class(TXMLNode, IXMLName_art)
  protected
    { IXMLName_art }
    function Get_Title: UnicodeString;
    function Get_FirstName: UnicodeString;
    function Get_LastName: UnicodeString;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_FirstName(Value: UnicodeString);
    procedure Set_LastName(Value: UnicodeString);
  end;

  { TXMLSong }

  TXMLSong = class(TXMLNode, IXMLSong)
  protected
    { IXMLSong }
    function Get_Title: UnicodeString;
    function Get_Year: UnicodeString;
    function Get_Artists: IXMLArtists;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Year(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

  { Global Functions }

function GetSong(Doc: IXMLDocument): IXMLSong;
function LoadSong(const FileName: string): IXMLSong;
function NewSong: IXMLSong;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetSong(Doc: IXMLDocument): IXMLSong;
begin
  Result := Doc.GetDocBinding('Song', TXMLSong, TargetNamespace) as IXMLSong;
end;

function LoadSong(const FileName: string): IXMLSong;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Song', TXMLSong, TargetNamespace) as IXMLSong;
end;

function NewSong: IXMLSong;
begin
  Result := NewXMLDocument.GetDocBinding('Song', TXMLSong, TargetNamespace) as IXMLSong;
end;

{ TXMLArtists }

procedure TXMLArtists.AfterConstruction;
begin
  RegisterChildNode('Artist', TXMLArtist_art);
  ItemTag := 'Artist';
  ItemInterface := IXMLArtist_art;
  inherited;
end;

function TXMLArtists.Get_Artist(Index: Integer): IXMLArtist_art;
begin
  Result := List[Index] as IXMLArtist_art;
end;

function TXMLArtists.Add: IXMLArtist_art;
begin
  Result := AddItem(-1) as IXMLArtist_art;
end;

function TXMLArtists.Insert(const Index: Integer): IXMLArtist_art;
begin
  Result := AddItem(Index) as IXMLArtist_art;
end;

{ TXMLArtist_art }

procedure TXMLArtist_art.AfterConstruction;
begin
  RegisterChildNode('Name', TXMLName_art);
  inherited;
end;

function TXMLArtist_art.Get_BirthYear: UnicodeString;
begin
  Result := AttributeNodes['BirthYear'].Text;
end;

procedure TXMLArtist_art.Set_BirthYear(Value: UnicodeString);
begin
  SetAttribute('BirthYear', Value);
end;

function TXMLArtist_art.Get_Name: IXMLName_art;
begin
  Result := ChildNodes['Name'] as IXMLName_art;
end;

{ TXMLName_art }

function TXMLName_art.Get_Title: UnicodeString;
begin
  Result := ChildNodes['Title'].Text;
end;

procedure TXMLName_art.Set_Title(Value: UnicodeString);
begin
  ChildNodes['Title'].NodeValue := Value;
end;

function TXMLName_art.Get_FirstName: UnicodeString;
begin
  Result := ChildNodes['FirstName'].Text;
end;

procedure TXMLName_art.Set_FirstName(Value: UnicodeString);
begin
  ChildNodes['FirstName'].NodeValue := Value;
end;

function TXMLName_art.Get_LastName: UnicodeString;
begin
  Result := ChildNodes['LastName'].Text;
end;

procedure TXMLName_art.Set_LastName(Value: UnicodeString);
begin
  ChildNodes['LastName'].NodeValue := Value;
end;

{ TXMLSong }

procedure TXMLSong.AfterConstruction;
begin
  RegisterChildNode('Artists', TXMLArtists);
  inherited;
end;

function TXMLSong.Get_Title: UnicodeString;
begin
  Result := ChildNodes['Title'].Text;
end;

procedure TXMLSong.Set_Title(Value: UnicodeString);
begin
  ChildNodes['Title'].NodeValue := Value;
end;

function TXMLSong.Get_Year: UnicodeString;
begin
  Result := ChildNodes['Year'].Text;
end;

procedure TXMLSong.Set_Year(Value: UnicodeString);
begin
  ChildNodes['Year'].NodeValue := Value;
end;

function TXMLSong.Get_Artists: IXMLArtists;
begin
  Result := ChildNodes['Artists'] as IXMLArtists;
end;

end.

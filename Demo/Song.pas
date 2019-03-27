unit Song;

// example from https://www.webucator.com/

interface

uses xmldom, XMLDoc, XMLIntf, XMLDocHelper, Artist;

type

  { Forward Decls }

  IXMLArtists = interface;
  IXMLSong = interface;

  { IXMLArtists }

  IXMLArtists = interface(IXMLNodeCollection)
    ['{F208170C-788F-4E50-94CD-F596B8CDA45D}']
    { Property Accessors }
    function Get_Artist(Index: Integer): IXMLArtist;
    { Methods & Properties }
    function Add: IXMLArtist;
    function Insert(const Index: Integer): IXMLArtist;
    property Artist[Index: Integer]: IXMLArtist read Get_Artist; default;
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
  TXMLSong = class;

  { TXMLArtists }

  TXMLArtists = class(TXMLNodeCollection, IXMLArtists)
  protected
    { IXMLArtists }
    function Get_Artist(Index: Integer): IXMLArtist;
    function Add: IXMLArtist;
    function Insert(const Index: Integer): IXMLArtist;
  public
    procedure AfterConstruction; override;
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
  TargetNamespace = 'http://www.webucator.com/Song';

implementation

{ Global Functions }

function GetSong(Doc: IXMLDocument): IXMLSong;
begin
  Result := Doc.GetDocBinding('tns:Song', TXMLSong, TargetNamespace) as IXMLSong;
  Result.DeclareNamespace('art', artNamespace);
end;

function LoadSong(const FileName: string): IXMLSong;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('tns:Song', TXMLSong, TargetNamespace) as IXMLSong;
  Result.DeclareNamespace('art', artNamespace);
end;

function NewSong: IXMLSong;
begin
  Result := NewXMLDocument.GetDocBinding('tns:Song', TXMLSong, TargetNamespace) as IXMLSong;
  Result.DeclareNamespace('art', artNamespace);
end;

{ TXMLArtists }

procedure TXMLArtists.AfterConstruction;
begin
  RegisterChildNode('tns:Artist', TXMLArtist);
  ItemTag := 'tns:Artist';
  ItemInterface := IXMLArtist;
  inherited;
end;

function TXMLArtists.Get_Artist(Index: Integer): IXMLArtist;
begin
  Result := List[Index] as IXMLArtist;
end;

function TXMLArtists.Add: IXMLArtist;
begin
  Result := AddItem(-1) as IXMLArtist;
end;

function TXMLArtists.Insert(const Index: Integer): IXMLArtist;
begin
  Result := AddItem(Index) as IXMLArtist;
end;

{ TXMLSong }

procedure TXMLSong.AfterConstruction;
begin
  RegisterChildNode('tns:Artists', TXMLArtists);
  inherited;
end;

function TXMLSong.Get_Title: UnicodeString;
begin
  Result := ChildNodes['tns:Title'].Text;
end;

procedure TXMLSong.Set_Title(Value: UnicodeString);
begin
  ChildNodes['tns:Title'].NodeValue := Value;
end;

function TXMLSong.Get_Year: UnicodeString;
begin
  Result := ChildNodes['tns:Year'].Text;
end;

procedure TXMLSong.Set_Year(Value: UnicodeString);
begin
  ChildNodes['tns:Year'].NodeValue := Value;
end;

function TXMLSong.Get_Artists: IXMLArtists;
begin
  Result := ChildNodes['tns:Artists'] as IXMLArtists;
end;

end.

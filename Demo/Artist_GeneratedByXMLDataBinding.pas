unit Artist_GeneratedByXMLDataBinding;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLName = interface;
  IXMLArtist = interface;

{ IXMLName }

  IXMLName = interface(IXMLNode)
    ['{DAE74CB2-3673-4608-9F0B-23F72D66951E}']
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

{ IXMLArtist }

  IXMLArtist = interface(IXMLNode)
    ['{78E35C54-4A48-45A9-B71A-15D2E109A1B7}']
    { Property Accessors }
    function Get_BirthYear: UnicodeString;
    function Get_Name: IXMLName;
    procedure Set_BirthYear(Value: UnicodeString);
    { Methods & Properties }
    property BirthYear: UnicodeString read Get_BirthYear write Set_BirthYear;
    property Name: IXMLName read Get_Name;
  end;

{ Forward Decls }

  TXMLName = class;
  TXMLArtist = class;

{ TXMLName }

  TXMLName = class(TXMLNode, IXMLName)
  protected
    { IXMLName }
    function Get_Title: UnicodeString;
    function Get_FirstName: UnicodeString;
    function Get_LastName: UnicodeString;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_FirstName(Value: UnicodeString);
    procedure Set_LastName(Value: UnicodeString);
  end;

{ TXMLArtist }

  TXMLArtist = class(TXMLNode, IXMLArtist)
  protected
    { IXMLArtist }
    function Get_BirthYear: UnicodeString;
    function Get_Name: IXMLName;
    procedure Set_BirthYear(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

implementation

{ TXMLName }

function TXMLName.Get_Title: UnicodeString;
begin
  Result := ChildNodes['Title'].Text;
end;

procedure TXMLName.Set_Title(Value: UnicodeString);
begin
  ChildNodes['Title'].NodeValue := Value;
end;

function TXMLName.Get_FirstName: UnicodeString;
begin
  Result := ChildNodes['FirstName'].Text;
end;

procedure TXMLName.Set_FirstName(Value: UnicodeString);
begin
  ChildNodes['FirstName'].NodeValue := Value;
end;

function TXMLName.Get_LastName: UnicodeString;
begin
  Result := ChildNodes['LastName'].Text;
end;

procedure TXMLName.Set_LastName(Value: UnicodeString);
begin
  ChildNodes['LastName'].NodeValue := Value;
end;

{ TXMLArtist }

procedure TXMLArtist.AfterConstruction;
begin
  RegisterChildNode('Name', TXMLName);
  inherited;
end;

function TXMLArtist.Get_BirthYear: UnicodeString;
begin
  Result := AttributeNodes['BirthYear'].Text;
end;

procedure TXMLArtist.Set_BirthYear(Value: UnicodeString);
begin
  SetAttribute('BirthYear', Value);
end;

function TXMLArtist.Get_Name: IXMLName;
begin
  Result := ChildNodes['Name'] as IXMLName;
end;

end.
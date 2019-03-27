unit XMLDocHelper;

(*

  (CreateCollection\(.+?,.+?, ')(.+?)\)
  \1tns:\2\)


  RegisterChildNode('
  RegisterChildNode('tns:


  ChildNodes['
  ChildNodes['tns:

  ItemTag := '
  ItemTag := 'tns:

*)

interface

uses DDetours, System.Variants, System.Generics.Collections, System.SysUtils, Xml.XMLDoc, Xml.XMLIntf, Xml.xmldom;

type
  TXMLNodeHelp = class(TXMLNode);
  TXMLNodeListHelp = class(TXMLNodeList);
  TXMLNodeCollectionHelp = class(TXMLNodeCollection);

type
  TXMLNodeHelper = class helper for TXMLNode
  public
    function _FindNamespaceURI(const TagOrPrefix: DOMString): DOMString;
  end;

var
  TrampolineXMLNode_RegisterChildNode: procedure(const aSelf: TXMLNodeHelp; const TagName: DOMString; ChildNodeClass: TXMLNodeClass; NamespaceURI: DOMString = '') = nil;
  TrampolineXMLNode_CreateCollection: function(const aSelf: TXMLNodeHelp; const CollectionClass: TXMLNodeCollectionClass; const ItemInterface: TGuid; const ItemTag: DOMString; ItemNS: DOMString = ''): TXMLNodeCollection = nil;
  TrampolineXMLNode_InternalAddChild: function(const aSelf: TXMLNodeHelp; NodeClass: TXMLNodeClass; const NodeName, NamespaceURI: DOMString; Index: Integer): IXMLNode;
  TrampolineXMLNodeList_GetNode: function(const aSelf: TXMLNodeListHelp; const aIndexOrName: OleVariant): IXMLNode = nil;
  TrampolineXMLNodeCollection_IsCollectionItem: function(const aSelf: TXMLNodeCollectionHelp; const Node: IXMLNode): Boolean;

implementation

procedure XMLNode_RegisterChildNodeHooked(const aSelf: TXMLNodeHelp; const TagName: DOMString; ChildNodeClass: TXMLNodeClass; NamespaceURI: DOMString = '');
begin
  if IsPrefixed(TagName) and (NamespaceURI = '') then
    TrampolineXMLNode_RegisterChildNode(aSelf, TagName, ChildNodeClass, aSelf._FindNamespaceURI(TagName))
  else
    TrampolineXMLNode_RegisterChildNode(aSelf, TagName, ChildNodeClass, NamespaceURI);
end;

function XMLNode_CreateCollectionHooked(const aSelf: TXMLNodeHelp; const CollectionClass: TXMLNodeCollectionClass; const ItemInterface: TGuid; const ItemTag: DOMString; ItemNS: DOMString = ''): TXMLNodeCollection;
begin
  Result := nil;
  if IsPrefixed(ItemTag) and (ItemNS = '') then
    Result := TrampolineXMLNode_CreateCollection(aSelf, CollectionClass, ItemInterface, ItemTag, aSelf._FindNamespaceURI(ItemTag));
  if Result = nil then
    Result := TrampolineXMLNode_CreateCollection(aSelf, CollectionClass, ItemInterface, ItemTag, ItemNS);
end;

function XMLNode_InternalAddChildHooked(const aSelf: TXMLNodeHelp; NodeClass: TXMLNodeClass; const NodeName, NamespaceURI: DOMString; Index: Integer): IXMLNode;
var
  NS: string;
begin
  NS := aSelf._FindNamespaceURI(NodeName);
  if NS = '' then
    NS := NamespaceURI;
  Result := TrampolineXMLNode_InternalAddChild(aSelf, NodeClass, NodeName, NS, Index)
end;

function XMLNodeList_GetNodeHooked(const aSelf: TXMLNodeListHelp; const aIndexOrName: OleVariant): IXMLNode;
begin
  if VarIsOrdinal(aIndexOrName) then
    Result := TrampolineXMLNodeList_GetNode(aSelf, aIndexOrName)
  else
  begin
    if IsPrefixed(aIndexOrName) then
      Result := aSelf.FindNode(ExtractLocalName(aIndexOrName), aSelf.Owner._FindNamespaceURI(aIndexOrName));
    if Result = nil then
      Result := TrampolineXMLNodeList_GetNode(aSelf, aIndexOrName);
  end;
end;

function XMLNodeCollection_IsCollectionItem(const aSelf: TXMLNodeCollectionHelp; const Node: IXMLNode): Boolean;

const
  AdjustIndex = 1 - Low(string);

type
  TStringSplitOption = (ssNone, ssRemoveEmptyEntries);
  TStringSplitOptions = set of TStringSplitOption;
  TDOMStringDynArray = array of DOMString;

  function SplitString(const S: DOMString; Delimiter: WideChar; const StringSplitOptions: TStringSplitOptions = []): TDOMStringDynArray;
  var
    LInputLength, LResultCapacity, LResultCount, LCurPos, LSplitStartPos: Integer;
  begin
    { Get the current capacity of the result array }
    LResultCapacity := Length(Result);
    { Reset the number of results already set }
    LResultCount := 0;
    { Start at the first character }
    LSplitStartPos := 1;
    { Save the length of the input }
    LInputLength := Length(S);
    { Step through the entire string }
    for LCurPos := 1 to LInputLength do
    begin
      { Find a delimiter }
      if S[LCurPos - AdjustIndex] = Delimiter then
      begin
        { Is the split non-empty, or are empty strings allowed? }
        if (LSplitStartPos < LCurPos) or not(ssRemoveEmptyEntries in StringSplitOptions) then
        begin
          { Split must be added - is there enough capacity in the result array? }
          if LResultCount = LResultCapacity then
          begin
            { Grow the result array - make it slightly more than double the
              current size }
            LResultCapacity := LResultCapacity * 2 + 8;
            SetLength(Result, LResultCapacity);
          end;
          { Set the string }
          SetString(Result[LResultCount], PWideChar(@S[LSplitStartPos - AdjustIndex]), LCurPos - LSplitStartPos);
          { Increment the result count }
          Inc(LResultCount);
        end;
        { Set the next split start position }
        LSplitStartPos := LCurPos + 1;
      end;
    end;
    { Add the final split }
    if (LSplitStartPos <= LInputLength) or not(ssRemoveEmptyEntries in StringSplitOptions) then
    begin
      { Correct the output length }
      if LResultCount + 1 <> LResultCapacity then
        SetLength(Result, LResultCount + 1);
      { Set the string }
      SetString(Result[LResultCount], PWideChar(@S[LSplitStartPos - AdjustIndex]), LInputLength - LSplitStartPos + 1);
    end
    else
    begin
      { No final split - correct the output length }
      if LResultCount <> LResultCapacity then
        SetLength(Result, LResultCount);
    end;
  end;

var
  I: Integer;
  LocalName: DOMString;
  FItemTags: TDOMStringDynArray;
begin
  Result := False;
  if Supports(Node, aSelf.ItemInterface) then
  begin
    LocalName := ExtractLocalName(Node.NodeName);
    Result := (LocalName = ExtractLocalName(aSelf.ItemTag)); // here is the Bug
    // If FItemTag has semicolons in it, then there are multiple valid names and we must check each one
    if not Result and (Pos(';', aSelf.ItemTag) > 0) then
    begin
      FItemTags := SplitString(aSelf.ItemTag, ';', [ssRemoveEmptyEntries]);
      for I := Low(FItemTags) to High(FItemTags) do
        if LocalName = ExtractLocalName(FItemTags[I]) then // and here is the Bug
        begin
          Result := True;
          Break;
        end;
    end;
  end;
end;

function TXMLNodeHelper._FindNamespaceURI(const TagOrPrefix: DOMString): DOMString;
begin
  Result := FindNamespaceURI(TagOrPrefix);
end;

initialization

@TrampolineXMLNode_RegisterChildNode := InterceptCreate(@TXMLNodeHelp.RegisterChildNode, @XMLNode_RegisterChildNodeHooked);
@TrampolineXMLNode_CreateCollection := InterceptCreate(@TXMLNodeHelp.CreateCollection, @XMLNode_CreateCollectionHooked);
@TrampolineXMLNode_InternalAddChild := InterceptCreate(@TXMLNodeHelp.InternalAddChild, @XMLNode_InternalAddChildHooked);
@TrampolineXMLNodeList_GetNode := InterceptCreate(@TXMLNodeListHelp.GetNode, @XMLNodeList_GetNodeHooked);
@TrampolineXMLNodeCollection_IsCollectionItem := InterceptCreate(@TXMLNodeCollectionHelp.IsCollectionItem, @XMLNodeCollection_IsCollectionItem);

finalization

if Assigned(TrampolineXMLNode_RegisterChildNode) then
begin
  InterceptRemove(@TrampolineXMLNode_RegisterChildNode);
  TrampolineXMLNode_RegisterChildNode := nil;
end;

if Assigned(TrampolineXMLNode_CreateCollection) then
begin
  InterceptRemove(@TrampolineXMLNode_CreateCollection);
  TrampolineXMLNode_CreateCollection := nil;
end;

if Assigned(TrampolineXMLNode_InternalAddChild) then
begin
  InterceptRemove(@TrampolineXMLNode_InternalAddChild);
  TrampolineXMLNode_InternalAddChild := nil;
end;

if Assigned(TrampolineXMLNodeList_GetNode) then
begin
  InterceptRemove(@TrampolineXMLNodeList_GetNode);
  TrampolineXMLNodeList_GetNode := nil;
end;

if Assigned(TrampolineXMLNodeCollection_IsCollectionItem) then
begin
  InterceptRemove(@TrampolineXMLNodeCollection_IsCollectionItem);
  TrampolineXMLNodeCollection_IsCollectionItem := nil;
end;

end.

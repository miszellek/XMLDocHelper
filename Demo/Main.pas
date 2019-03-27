unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  XMLDoc;

type
  TFm_Main = class(TForm)
    MemoXML: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fm_Main: TFm_Main;

implementation

{$R *.dfm}

uses Song;

procedure TFm_Main.FormShow(Sender: TObject);
var
  XMLSong: IXMLSong;
begin
  XMLSong := NewSong;

  XMLSong.Title := 'Title';
  XMLSong.Year := 'Year';
  with XMLSong.Artists.Add do
  begin
    BirthYear := 'ArtistsBirthYear';
    Name.Title := 'Artists';
    Name.FirstName := 'Artists';
    Name.LastName := 'Artists';
  end;

  MemoXML.Lines.Append(XMLDoc.FormatXMLData(XMLSong.OwnerDocument.XML.Text));
end;

end.

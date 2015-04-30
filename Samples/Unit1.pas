unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Collections, frxClass,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    frxReport1: TfrxReport;
    Button2: TButton;
    frxReport2: TfrxReport;
    Button3: TButton;
    frxReport3: TfrxReport;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TPerson = class;
  THobby = class;
  TAlias = class;

  TPerson = class
  private
    fChildren: TList<TPerson>;
    fAliases: TList<TAlias>;
    fHobbies: TList<THobby>;
    FName: string;
    procedure SetName(const Value: string);
  public
    property Hobbies: TList<THobby> read fHobbies write fHobbies;
    property Children: TList<TPerson> read fChildren write fChildren;
    property Aliases: TList<TAlias> read fAliases write fAliases;
    property Name: string read FName write SetName;
    constructor Create;
    destructor Destroy; override;
  end;

  THobby = class
  private
    FDescription: string;
    procedure SetDescription(const Value: string);
  public
    property Description: string read FDescription write SetDescription;
  end;

  TAlias = class
  private
    fAliasName: string;
  public
    property AliasName: string read fAliasName write fAliasName;
  end;

var
  Form1: TForm1;
  People: TList<TPerson>;

implementation

{$R *.dfm}

uses Yeahbah.FastReportObjects;

procedure CreateObjects;
var
  h: THobby;
  a: TAlias;
  p, c: TPerson;
begin
  p := TPerson.Create;
  with p do
  begin
    Name := 'Tirso Cruz';
    h := THobby.Create;
    h.Description := 'Collecting Stamps';
    Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Building Lego';
    Hobbies.Add(h);

    c := TPerson.Create;
    c.Name := 'Apple Cruz';

    h := THobby.Create;
    h.Description := 'Barbie Dolls';
    c.Hobbies.Add(h);

    a := TAlias.Create;
    a.AliasName := 'Pip';
    Aliases.Add(a);

    a := TAlias.Create;
    a.AliasName := 'Boy';
    Aliases.Add(a);

    Children.Add(c);
  end;
  People.Add(p);

  p := TPerson.Create;
  with p do
  begin
    Name := 'Batman';
    h := THobby.Create;
    h.Description := 'Fighting Crime';
    Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Detailing the bat mobile';
    Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Chicas';
    Hobbies.Add(h);

    a := TAlias.Create;
    a.AliasName := 'Bruce Wayne';
    Aliases.Add(a);

    a := TAlias.Create;
    a.AliasName := 'Dark Knight';
    Aliases.Add(a);
  end;
  People.Add(p);

  p := TPerson.Create;
  with p do
  begin
    Name := 'Norah Jose';
    h := THobby.Create;
    h.Description := 'Singing';
    Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Dancing';
    Hobbies.Add(h);

    c := TPerson.Create;
    c.Name := 'Jolina';
    h := THobby.Create;
    h.Description := 'Fishing';
    c.Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Sewing';
    c.Hobbies.Add(h);

    Children.Add(c);

    c := TPerson.Create;
    c.Name := 'Kulafu';
    h := THobby.Create;
    h.Description := 'Clubbing';
    c.Hobbies.Add(h);

    Children.Add(c);
  end;
  People.Add(p);

  p := TPerson.Create;
  with p do
  begin
    Name := 'Mario Cart';
    h := THobby.Create;
    h.Description := 'Collecting Stamps';
    Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Building Lego';
    Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Collecting Comics';
    Hobbies.Add(h);

    c := TPerson.Create;
    c.Name := 'McLovin';
    h := THobby.Create;
    h.Description := 'Drinking';
    c.Hobbies.Add(h);

    h := THobby.Create;
    h.Description := 'Gunz';
    c.Hobbies.Add(h);

    Children.Add(c);
  end;
  People.Add(p);
end;

{ TPerson }

constructor TPerson.Create;
begin
  fChildren := TList<TPerson>.Create;
  fHobbies := TList<THobby>.Create;
  fAliases := TList<TAlias>.Create;
end;

destructor TPerson.Destroy;
begin
  fChildren.Free;
  fHobbies.Free;
  fAliases.Free;
  inherited;
end;

procedure TPerson.SetName(const Value: string);
begin
  FName := Value;
end;

{ THobby }

procedure THobby.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  peopleDataset: TFastReportObjects<TPerson>;
begin
  peopleDataset := TFastReportObjects<TPerson>.Create(self, 'PersonDataset', people);
  try
    // you have to set the band dataset
    TfrxMasterData(frxReport1.FindObject('MasterData1')).DataSet := peopleDataset;

    // you have to add the dataset to the report
    frxReport1.DataSets.Add(peopleDataset);

    frxReport1.ShowReport;
  finally
    peopleDataset.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  personDataset: TFastReportObjects<TPerson>;
  hobbyDataset: TFastReportObjects<THobby>;
begin
  personDataset := TFastReportObjects<TPerson>.Create(self, 'PersonDataset', people);
  hobbyDataset := TFastReportObjects<THobby>.Create(self, 'HobbyDataset');
  try
    // attach the detail dataset (hobbyDataset) to the master dataset (personDataset)
    // the second parameter is of TProc<T> where T is the type of the master
    // This proc is needed to tell the engine the size of the detail dataset
    // and what data to render
    personDataset.AttachDetailDataset(hobbyDataset,
      procedure (p: TPerson)
      begin
        hobbyDataset.RangeEndCount := p.Hobbies.Count;
        hobbyDataset.Data := p.Hobbies;
      end);

    TfrxMasterData(frxReport2.FindObject('MasterData1')).DataSet := personDataset;
    TfrxDetailData(frxReport2.FindObject('DetailData1')).DataSet := hobbyDataset;

    frxReport2.DataSets.Add(personDataset);
    frxReport2.DataSets.Add(hobbyDataset);
    frxReport2.ShowReport;
  finally
    personDataset.Free;
    hobbyDataset.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CreateObjects;
end;

initialization
  People := TList<TPerson>.Create;

finalization
  People.Free;

end.

unit FHIR.Toolkit.JsonEditor;

{$i fhir.inc}

interface

uses
  Classes, SysUtils, SynEditHighlighter, SynHighlighterJson,
  FHIR.Support.Base, FHIR.Support.Json, FHIR.Support.Logging, FHIR.Support.Stream,
  FHIR.Toolkit.Context, FHIR.Toolkit.Store,
  FHIR.Toolkit.BaseEditor;

type

  { TJsonEditor }

  TJsonEditor = class (TBaseEditor)
  private
    FParser : TJsonParser;
    FJson : TJsonNode;
  protected
    function makeHighlighter : TSynCustomHighlighter; override;
    procedure getNavigationList(navpoints : TStringList); override;
    procedure ContentChanged; override;
  public
    constructor Create(context : TToolkitContext; session : TToolkitEditSession; store : TStorageService); override;
    destructor Destroy; override;

    procedure newContent(); override;
    function FileExtension : String; override;
    procedure validate(validate : boolean; inspect : boolean; cursor : TSourceLocation; inspection : TStringList); override;
  end;


implementation

constructor TJsonEditor.Create(context: TToolkitContext; session: TToolkitEditSession; store: TStorageService);
begin
  inherited Create(context, session, store);
  FParser := TJsonParser.create;
end;

destructor TJsonEditor.Destroy;
begin
  FParser.free;
  FJson.free;
  inherited Destroy;
end;

function TJsonEditor.makeHighlighter: TSynCustomHighlighter;
begin
  Result := TSynJSonSyn.create(nil);
end;

procedure TJsonEditor.getNavigationList(navpoints: TStringList);
var
  c : integer;
  arr : TJsonArray;
  obj : TJsonObject;
  n : TJsonNode;
  s : String;
begin
  if (FJson = nil) then
  try
    FJson := FParser.parse(FContent.text);
  except
  end;
  if (FJson <> nil) then
  begin
    if (FJson is TJsonArray) then
    begin
      arr := FJson as TJsonArray;
      if arr.Count < 20 then
      begin
        c := 0;
        for n in arr do
        begin
          navpoints.AddObject('Item '+inttostr(c), TObject(n.LocationStart.line));
          inc(c);
        end;
      end;
    end
    else
    begin
      obj := FJson as TJsonObject;
      if obj.properties.count > 0 then
      begin
        for s in obj.properties.SortedKeys do
        begin
          navpoints.AddObject(s, TObject(obj.properties[s].LocationStart.line));
        end;
      end;
    end;
  end;
end;

procedure TJsonEditor.newContent();
begin
  Session.HasBOM := false;
  Session.EndOfLines := PLATFORM_DEFAULT_EOLN;
  Session.Encoding := senUTF8;

  TextEditor.Text := '{'+#13#10+'  "name": "value'+#13#10+'}'+#13#10;
  updateToolbarButtons;
end;

function TJsonEditor.FileExtension: String;
begin
  result := 'json';
end;

procedure TJsonEditor.validate(validate : boolean; inspect : boolean; cursor : TSourceLocation; inspection : TStringList);
var
  i : integer;
  s : String;
  t : QWord;
  path : TFslList<TJsonPointerMatch>;
begin
  updateToContent;
  t := StartValidating;
  try
    if (validate) then
    begin
      for i := 0 to FContent.count - 1 do
      begin
        s := TextEditor.lines[i];
        checkForEncoding(s, i);
      end;
    end;
    FJson.Free;
    FJson := nil;
    try
      FJson := FParser.parseNode(FContent.text);
      path := FJson.findLocation(cursor);
      try
        inspection.AddPair('Path', FJson.describePath(path));
      finally
        path.free;
      end;
    except
      on e : EParserException do
      begin
        validationError(e.Location, e.message);
      end;
      on e : Exception do
      begin
        validationError(TSourceLocation.CreateNull, 'Error Parsing Json: '+e.message);
      end;
    end;
  finally
    finishValidating(validate, t);
  end;
end;

procedure TJsonEditor.ContentChanged;
begin
  FJson.Free;
  FJson := nil;
end;

end.


unit TerminologyServerStore;

interface

uses
  SysUtils, Classes, kCritSct,
  StringSupport,
  AdvObjects, AdvStringObjectMatches, AdvStringLists, AdvStringMatches,
  FHIRTypes, FHIRComponents, FHIRResources, FHIRUtilities,
  TerminologyServices, LoincServices, UCUMServices, SnomedServices, RxNormServices,
  YuStemmer;

Type
  {$IFNDEF FHIR-DSTU}
  TFhirConceptMapConceptList = TFhirConceptMapElementList;
  TFhirConceptMapConceptMapList = TFhirConceptMapElementMapList;
  TFhirConceptMapConcept = TFhirConceptMapElement;
  TFhirConceptMapConceptMap = TFhirConceptMapElementMap;
  {$ENDIF}


  TLoadedConceptMap = class (TAdvObject)
  private
    FSource: TFhirValueSet;
    FResource: TFhirConceptMap;
    FTarget: TFhirValueSet;
    procedure SetResource(const Value: TFhirConceptMap);
    procedure SetSource(const Value: TFhirValueSet);
    procedure SetTarget(const Value: TFhirValueSet);

    function HasTranslation(list : TFhirConceptMapConceptList; system, code : String; out maps : TFhirConceptMapConceptMapList) : boolean; overload;
  public
    Destructor Destroy; override;
    Property Source : TFhirValueSet read FSource write SetSource;
    Property Resource : TFhirConceptMap read FResource write SetResource;
    Property Target : TFhirValueSet read FTarget write SetTarget;

    function HasTranslation(system, code : String; out maps : TFhirConceptMapConceptMapList) : boolean; overload;
  end;

  TValueSetProviderContext = class (TCodeSystemProviderContext)
  private
    context : TFhirValueSetDefineConcept;
  public
    constructor Create(context : TFhirValueSetDefineConcept); overload;
    destructor Destroy; override;
  end;

  TValueSetProviderFilterContext = class (TCodeSystemProviderFilterContext)
  private
    ndx : integer;
    total : Integer;
    concepts : TFhirValueSetDefineConceptList;
  public
    constructor Create(concepts : TFhirValueSetDefineConceptList); overload;
    destructor Destroy; override;
  end;

  TValueSetProvider = class (TCodeSystemProvider)
  private
    FVs : TFhirValueSet;
    function doLocate(list : TFhirValueSetDefineConceptList; code : String) : TValueSetProviderContext;
    procedure FilterCodes(dest, source : TFhirValueSetDefineConceptList; filter : TSearchFilterText);
    function FilterCount(ctxt: TFhirValueSetDefineConcept): integer;
  public
    constructor Create(vs : TFHIRValueSet); overload;
    destructor Destroy; override;
    function TotalCount : integer; override;
    function ChildCount(context : TCodeSystemProviderContext) : integer; override;
    function getcontext(context : TCodeSystemProviderContext; ndx : integer) : TCodeSystemProviderContext; override;
    function system : String; override;
    function getDisplay(code : String):String; override;
    function locate(code : String) : TCodeSystemProviderContext; overload; override;
    function IsAbstract(context : TCodeSystemProviderContext) : boolean; override;
    function Code(context : TCodeSystemProviderContext) : string; override;
    function Display(context : TCodeSystemProviderContext) : string; override;
    procedure Displays(code : String; list : TStringList); override;
    procedure Displays(context : TCodeSystemProviderContext; list : TStringList); override;
    function getDefinition(code : String):String; override;
    function Definition(context : TCodeSystemProviderContext) : string; override;

    function filter(prop : String; op : TFhirFilterOperator; value : String; prep : TCodeSystemProviderFilterPreparationContext) : TCodeSystemProviderFilterContext; override;
    function FilterMore(ctxt : TCodeSystemProviderFilterContext) : boolean; override;
    function FilterConcept(ctxt : TCodeSystemProviderFilterContext): TCodeSystemProviderContext; override;
    function InFilter(ctxt : TCodeSystemProviderFilterContext; concept : TCodeSystemProviderContext) : Boolean; override;
    procedure Close(ctxt : TCodeSystemProviderFilterContext); override;
    procedure Close(ctxt : TCodeSystemProviderContext); override;
    function locateIsA(code, parent : String) : TCodeSystemProviderContext; override;
    function filterLocate(ctxt : TCodeSystemProviderFilterContext; code : String) : TCodeSystemProviderContext; override;
    function searchFilter(filter : TSearchFilterText; prep : TCodeSystemProviderFilterPreparationContext) : TCodeSystemProviderFilterContext; overload; override;
    function isNotClosed(textFilter : TSearchFilterText; propFilter : TCodeSystemProviderFilterContext = nil) : boolean; override;
  end;


  // the terminology server maintains a cache of terminology related resources
  // the rest server notifies terminology server whenever this list changes
  // (and at start up)
  TTerminologyServerStore = class (TAdvObject)
  private
    FLoinc : TLOINCServices;
    FSnomed : TSnomedServices;
    FUcum : TUcumServices;
    FRxNorm : TRxNormServices;
    FStem : TYuStemmer_8;

    FBaseValueSets : TAdvStringObjectMatch; // value sets out of the specification - these can be overriden, but they never go away
    FValueSetsByIdentifier : TAdvStringObjectMatch; // all current value sets by identifier (ValueSet.identifier)
    FCodeSystems : TAdvStringObjectMatch; // all current value sets that define systems, by their identifier
    FValueSetsByURL : TAdvStringObjectMatch; // all current value sets by their URL
    FValueSetsByKey : TAdvStringObjectMatch; // all value sets by the key they are known from (mainly to support drop)

    FBaseConceptMaps : TAdvStringObjectMatch; // value sets out of the specification - these can be overriden, but they never go away
    FConceptMapsByKey : TAdvStringObjectMatch;

    procedure SetLoinc(const Value: TLOINCServices);
    procedure SetSnomed(const Value: TSnomedServices);
    procedure SetUcum(const Value: TUcumServices);
    procedure UpdateConceptMaps;
    procedure BuildStems(list : TFhirValueSetDefineConceptList);
    procedure SetRxNorm(const Value: TRxNormServices);
  protected
    FLock : TCriticalSection;  // it would be possible to use a read/write lock, but the complexity doesn't seem to be justified by the short amount of time in the lock anyway
    FConceptMaps : TAdvStringObjectMatch;
    procedure invalidateVS(id : String); virtual;
  public
    Constructor Create; Override;
    Destructor Destroy; Override;
    Function Link : TTerminologyServerStore; overload;

    Property Loinc : TLOINCServices read FLoinc write SetLoinc;
    Property Snomed : TSnomedServices read FSnomed write SetSnomed;
    Property Ucum : TUcumServices read FUcum write SetUcum;
    Property RxNorm : TRxNormServices read FRxNorm write SetRxNorm;

    // maintenance procedures
    procedure SeeSpecificationResource(url : String; resource : TFHIRResource);
    procedure SeeTerminologyResource(url : String; key : Integer; resource : TFHIRResource);
    procedure DropTerminologyResource(key : Integer; url : String; aType : TFhirResourceType);

    // access procedures. All return values are owned, and must be freed
    Function getProvider(system : String; noException : boolean = false) : TCodeSystemProvider;
    function getValueSetByUrl(url : String) : TFHIRValueSet;
    function getCodeSystem(url : String) : TFHIRValueSet;
    function hasCodeSystem(url : String) : Boolean;
    function getValueSetByIdentifier(url : String) : TFHIRValueSet;

    // publishing access
    function GetCodeSystemList : TAdvStringMatch;
    function GetValueSetList : TAdvStringMatch;
  end;

implementation

{ TTerminologyServerStore }

procedure TTerminologyServerStore.BuildStems(list: TFhirValueSetDefineConceptList);
var
  i : integer;
  ts : TAdvStringList;
  c : TFhirValueSetDefineConcept;
  s, t : String;
begin
  for i := 0 to list.Count - 1 do
  begin
    c := list[i];
    ts := TAdvStringList.Create;
    try
      t := c.displayST;
      while (t <> '') Do
      begin
        StringSplit(t, [',', ' ', ':', '.', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '{', '}', '[', ']', '|', '\', ';', '"', '<', '>', '?', '/', '~', '`', '-', '_', '+', '='], s, t);
        if (s <> '') Then
          ts.Add(lowercase(FStem.stem(s)));
      end;
      ts.SortAscending;
      c.Tag := ts.Link;
    finally
      ts.Free;
    end;
    BuildStems(c.conceptList);
  end;
end;

constructor TTerminologyServerStore.Create;
begin
  inherited;
  FLock := TCriticalSection.Create('Terminology Server Store');

  FBaseValueSets := TAdvStringObjectMatch.Create;
  FValueSetsByIdentifier := TAdvStringObjectMatch.Create;
  FValueSetsByURL := TAdvStringObjectMatch.Create;
  FValueSetsByKey := TAdvStringObjectMatch.Create;
  FCodeSystems := TAdvStringObjectMatch.Create;
  FConceptMaps := TAdvStringObjectMatch.create;
  FBaseConceptMaps := TAdvStringObjectMatch.create;
  FConceptMapsByKey := TAdvStringObjectMatch.create;

  FBaseValueSets.PreventDuplicates;
  FValueSetsByIdentifier.PreventDuplicates;
  FValueSetsByURL.PreventDuplicates;
  FValueSetsByKey.PreventDuplicates;
  FCodeSystems.PreventDuplicates;
  FConceptMaps.PreventDuplicates;
  FBaseConceptMaps.PreventDuplicates;
  FConceptMapsByKey.PreventDuplicates;

  FBaseValueSets.Forced := true;
  FValueSetsByIdentifier.Forced := true;
  FValueSetsByURL.Forced := true;
  FValueSetsByKey.Forced := true;
  FCodeSystems.Forced := true;
  FConceptMaps.Forced := true;
  FBaseConceptMaps.Forced := true;
  FConceptMapsByKey.Forced := true;

  FStem := GetStemmer_8('english');
end;

destructor TTerminologyServerStore.Destroy;
begin
  FStem.Free;
  FConceptMapsByKey.Free;
  FBaseConceptMaps.Free;
  FConceptMaps.Free;
  FCodeSystems.Free;
  FBaseValueSets.Free;
  FValueSetsByIdentifier.free;
  FValueSetsByURL.free;
  FValueSetsByKey.free;

  FLoinc.free;
  FSnomed.free;
  FUcum.free;
  FLock.Free;
  FRxNorm.Free;
  inherited;
end;

procedure TTerminologyServerStore.SetLoinc(const Value: TLOINCServices);
begin
  FLoinc.Free;
  FLoinc := Value;
end;

procedure TTerminologyServerStore.SetRxNorm(const Value: TRxNormServices);
begin
  FRxNorm.Free;
  FRxNorm := Value;
end;

procedure TTerminologyServerStore.SetSnomed(const Value: TSnomedServices);
begin
  FSnomed.Free;
  FSnomed := Value;
end;

procedure TTerminologyServerStore.SetUcum(const Value: TUcumServices);
begin
  FUcum.Free;
  FUcum := Value;
end;


// ----  maintenance procedures ------------------------------------------------

procedure TTerminologyServerStore.SeeSpecificationResource(url : String; resource : TFHIRResource);
var
  vs : TFhirValueSet;
  cm : TLoadedConceptMap;
begin
  FLock.Lock('SeeSpecificationResource');
  try
    if (resource.ResourceType = frtValueSet) then
    begin
      vs := TFhirValueSet(resource);
      if (vs.identifierST = 'http://hl7.org/fhir/ValueSet/ucum-common') then
        FUcum.SetCommonUnits(vs.Link);

      FBaseValueSets.Matches[vs.identifierST] := vs.Link;
      FValueSetsByIdentifier.Matches[vs.identifierST] := vs.Link;
      FValueSetsByURL.Matches[url] := vs.Link;
      if (vs.define <> nil) then
      begin
        FCodeSystems.Matches[vs.define.systemST] := vs.Link;
        BuildStems(vs.define.conceptList);
      end;
      UpdateConceptMaps;
    end
    else if (resource.ResourceType = frtConceptMap) then
    begin
      cm := TLoadedConceptMap.Create;
      try
        cm.Resource := TFhirConceptMap(resource).Link;
        cm.Source := getValueSetByUrl(TFhirResourceReference(cm.Resource.source).referenceST);
        cm.Target := getValueSetByUrl(TFhirResourceReference(cm.Resource.target).referenceST);
        FConceptMaps.Matches[cm.Resource.identifierST] := cm.Link;
        FBaseConceptMaps.Matches[cm.Resource.identifierST] := cm.Link;
      finally
        cm.Free;
      end;
    end
  finally
    FLock.Unlock;
  end;
end;

procedure TTerminologyServerStore.SeeTerminologyResource(url : String; key : Integer; resource : TFHIRResource);
var
  vs : TFhirValueSet;
  cm : TLoadedConceptMap;
begin
  FLock.Lock('SeeTerminologyResource');
  try
    if (resource.ResourceType = frtValueSet) then
    begin
      vs := TFhirValueSet(resource);
      FValueSetsByIdentifier.Matches[vs.identifierST] := vs.Link;
      FValueSetsByURL.Matches[url] := vs.Link;
      FValueSetsByKey.Matches[inttostr(key)] := vs.Link;
      invalidateVS(vs.identifierST);
      if (vs.define <> nil) then
      begin
        FCodeSystems.Matches[vs.define.systemST] := vs.Link;
        BuildStems(vs.define.conceptList);
      end;
      UpdateConceptMaps;
    end
    else if (resource.ResourceType = frtConceptMap) then
    begin
      cm := TLoadedConceptMap.Create;
      try
        cm.Resource := TFhirConceptMap(resource).Link;
        cm.Source := getValueSetByUrl(TFhirResourceReference(cm.Resource.source).referenceST);
        cm.Target := getValueSetByUrl(TFhirResourceReference(cm.Resource.target).referenceST);
        FConceptMaps.Matches[cm.Resource.identifierST] := cm.Link;
        FConceptMapsByKey.Matches[inttostr(key)] := cm.Link;
      finally
        cm.Free;
      end;
    end;
  finally
    FLock.Unlock;
  end;
end;

procedure TTerminologyServerStore.DropTerminologyResource(key : Integer; url : String; aType : TFhirResourceType);
var
  vs, vs1 : TFhirValueSet;
  cm, cm1 : TLoadedConceptMap;
begin
  FLock.Lock('DropTerminologyResource');
  try
    if (aType = frtValueSet) then
    begin
      vs := TFhirValueSet(FValueSetsByKey.GetValueByKey(inttostr(key)));
      if vs <> nil then
      begin
        FValueSetsByURL.DeleteByKey(url);
        FValueSetsByIdentifier.DeleteByKey(vs.identifierST);
        if (vs.define <> nil) then
          FCodeSystems.DeleteByKey(vs.define.systemST);

        // add the base one back if we are dropping a value set that overrides it
        // current logical flaw: what if there's another one that overrides this? how do we prevent or deal with this?
        vs1 := FBaseValueSets.GetValueByKey(vs.identifierST) as TFhirValueSet;
        if vs1 <> nil then
        begin
          FValueSetsByIdentifier.Matches[vs.identifierST] := vs1.Link;
          if (vs1.define <> nil) then
            FCodeSystems.Matches[vs1.define.systemST] := vs.Link;
        end;
        // last - after this vs is no longer valid
        FValueSetsByKey.DeleteByKey(inttostr(key));
        UpdateConceptMaps;
      end;
    end
    else if (aType = frtConceptMap) then
    begin
      cm := TLoadedConceptMap(FConceptMapsByKey.GetValueByKey(inttostr(key)));
      if vs <> nil then
      begin
        FConceptMaps.DeleteByKey(cm.Resource.identifierST);

        // add the base one back if we are dropping a concept map that overrides it
        // current logical flaw: what if there's another one that overrides this? how do we prevent or deal with this?
        cm1 := FBaseConceptMaps.GetValueByKey(cm.Resource.identifierST) as TLoadedConceptMap;
        if cm1 <> nil then
          FConceptMaps.Matches[cm1.Resource.identifierST] := cm1.Link;
        // last - after this vs is no longer valid
        FConceptMapsByKey.DeleteByKey(inttostr(key));
      end;
    end;
  finally
    FLock.Unlock;
  end;
end;

procedure TTerminologyServerStore.UpdateConceptMaps;
var
  cm : TLoadedConceptMap;
  i : integer;
begin
  assert(FLock.LockedToMe);
  for i := 0 to FConceptMaps.Count - 1 do
  begin
    cm := TLoadedConceptMap(FConceptMaps.Values[i]);
    cm.Source := getValueSetByUrl(TFhirResourceReference(cm.Resource.source).referenceST);
    if (cm.Source = nil) then
      cm.Source := getValueSetByIdentifier(TFhirResourceReference(cm.Resource.source).referenceST);
    cm.Target := getValueSetByUrl(TFhirResourceReference(cm.Resource.target).referenceST);
    if (cm.Target = nil) then
      cm.Target := getValueSetByIdentifier(TFhirResourceReference(cm.Resource.target).referenceST);
  end;
end;

//---- access procedures. All return values are owned, and must be freed -------

function TTerminologyServerStore.getCodeSystem(url: String): TFHIRValueSet;
begin
  FLock.Lock('getValueSetByUrl');
  try
    result := FCodeSystems.GetValueByKey(url).Link as TFhirValueSet;
  finally
    FLock.Unlock;
  end;
end;

function TTerminologyServerStore.GetCodeSystemList: TAdvStringMatch;
var
  i: Integer;
  vs : TFhirValueSet;
begin
  result := TAdvStringMatch.Create;
  try
    result.PreventDuplicates;
    result.Forced := true;
    FLock.Lock('GetCodeSystemList');
    try
      for i := 0 to FCodeSystems.Count - 1 do
      begin
        vs := TFhirValueSet(FCodeSystems.ValueByIndex[i]);
        result.Matches[vs.define.systemST] := vs.nameST;
      end;
    finally
      FLock.Unlock;
    end;
    result.Link;
  finally
    result.Free;
  end;
end;


function TTerminologyServerStore.GetValueSetList: TAdvStringMatch;
var
  i: Integer;
  vs : TFhirValueSet;
begin
  result := TAdvStringMatch.Create;
  try
    result.PreventDuplicates;
    result.Forced := true;
    FLock.Lock('GetValueSetList');
    try
      for i := 0 to FValueSetsByURL.Count - 1 do
      begin
        vs := TFhirValueSet(FValueSetsByURL.ValueByIndex[i]);
        result.Matches[vs.IdentifierST] := vs.nameST;
      end;
    finally
      FLock.Unlock;
    end;
    result.Link;
  finally
    result.Free;
  end;
end;


Function TTerminologyServerStore.getProvider(system : String; noException : boolean = false) : TCodeSystemProvider;
begin
  result := nil;
  if (system = 'http://loinc.org') then
    result := FLoinc.Link
  else if system = 'http://snomed.info/sct' then
    result := FSnomed.Link
  else if system = 'http://www.nlm.nih.gov/research/umls/rxnorm' then
    result := FRxNorm.Link
  else if system = 'http://unitsofmeasure.org' then
    result := FUcum.Link
  else
  begin
    FLock.Lock('getProvider');
    try
      if FCodeSystems.ExistsByKey(system) then
        result := TValueSetProvider.create((FCodeSystems.matches[system] as TFHIRValueSet).link);
    finally
      FLock.Unlock;
    end;
  end;

  if (result = nil) and not noException then
    raise Exception.create('unable to provide support for code system '+system);
end;


function TTerminologyServerStore.getValueSetByIdentifier(url: String): TFHIRValueSet;
begin
  FLock.Lock('getValueSetByIdentifier');
  try
    if FValueSetsByIdentifier.ExistsByKey(url) then
      result := FValueSetsByIdentifier.GetValueByKey(url).Link as TFhirValueSet
    else
      result := nil;
  finally
    FLock.Unlock;
  end;
end;

function TTerminologyServerStore.getValueSetByUrl(url : String) : TFHIRValueSet;
var
  i : integer;
begin
  FLock.Lock('getValueSetByUrl');
  try
    if FValueSetsByUrl.ExistsByKey(url) then
      result := FValueSetsByUrl.GetValueByKey(url).Link as TFhirValueSet
    else
    begin
      result := nil;
      for i := 0 to FValueSetsByUrl.Count - 1 do
        if (result = nil) and (TFHirValueSet(FValueSetsByUrl.ValueByIndex[i]).identifierST = url) then
          result := FValueSetsByUrl.ValueByIndex[i].Link as TFhirValueSet;
    end;
  finally
    FLock.Unlock;
  end;
end;

function TTerminologyServerStore.hasCodeSystem(url: String): Boolean;
begin
  FLock.Lock('getValueSetByUrl');
  try
    result := FCodeSystems.ExistsByKey(url);
  finally
    FLock.Unlock;
  end;
end;

procedure TTerminologyServerStore.invalidateVS(id: String);
begin
end;

function TTerminologyServerStore.Link: TTerminologyServerStore;
begin
  result := TTerminologyServerStore(inherited Link);
end;

{ TValueSetProvider }

constructor TValueSetProvider.create(vs: TFHIRValueSet);
begin
  Create;
  FVs := vs
end;

function TValueSetProvider.Definition(context: TCodeSystemProviderContext): string;
begin
  result := TValueSetProviderContext(context).context.definitionST;
end;

destructor TValueSetProvider.destroy;
begin
  FVs.free;
  inherited;
end;

function TValueSetProvider.ChildCount(context: TCodeSystemProviderContext): integer;
begin
  if context = nil then
    result := FVs.define.conceptList.count
  else
    result := TValueSetProviderContext(context).context.conceptList.count;
end;

procedure TValueSetProvider.Close(ctxt: TCodeSystemProviderContext);
begin
  ctxt.Free;
end;

function TValueSetProvider.Code(context: TCodeSystemProviderContext): string;
begin
  result := TValueSetProviderContext(context).context.codeST;
end;

function TValueSetProvider.getcontext(context: TCodeSystemProviderContext; ndx: integer): TCodeSystemProviderContext;
begin
  if context = nil then
    result := TValueSetProviderContext.create(FVs.define.conceptList[ndx])
  else
    result := TValueSetProviderContext.create(TValueSetProviderContext(context).context.conceptList[ndx]);
end;

function TValueSetProvider.Display(context: TCodeSystemProviderContext): string;
begin
  result := TValueSetProviderContext(context).context.displayST;
end;

procedure TValueSetProvider.Displays(context: TCodeSystemProviderContext; list: TStringList);
begin
  list.Add(Display(context));
end;

procedure TValueSetProvider.Displays(code: String; list: TStringList);
begin
  list.Add(getDisplay(code));
end;

function TValueSetProvider.InFilter(ctxt: TCodeSystemProviderFilterContext; concept : TCodeSystemProviderContext): Boolean;
var
  cl : TFhirValueSetDefineConceptList;
  c : TFhirValueSetDefineConcept;
begin
  cl := TValueSetProviderFilterContext(ctxt).concepts;
  c := TValueSetProviderContext(concept).context;
  result := cl.IndexByReference(c) > -1;
end;

function TValueSetProvider.IsAbstract(context: TCodeSystemProviderContext): boolean;
begin
  result := (TValueSetProviderContext(context).context.abstract <> nil) and TValueSetProviderContext(context).context.abstractST;
end;

function TValueSetProvider.isNotClosed(textFilter: TSearchFilterText; propFilter: TCodeSystemProviderFilterContext): boolean;
begin
  result := false;
end;

function TValueSetProvider.getDefinition(code: String): String;
var
  ctxt : TCodeSystemProviderContext;
begin
  ctxt := locate(code);
  try
    if (ctxt = nil) then
      raise Exception.create('Unable to find '+code+' in '+system)
    else
      result := Definition(ctxt);
  finally
    Close(ctxt);
  end;
end;

function TValueSetProvider.getDisplay(code: String): String;
var
  ctxt : TCodeSystemProviderContext;
begin
  ctxt := locate(code);
  try
    if (ctxt = nil) then
      raise Exception.create('Unable to find '+code+' in '+system)
    else
      result := Display(ctxt);
  finally
    Close(ctxt);
  end;
end;

function TValueSetProvider.doLocate(list : TFhirValueSetDefineConceptList; code : String) : TValueSetProviderContext;
var
  i : integer;
  c : TFhirValueSetDefineConcept;
begin
  result := nil;
  for i := 0 to list.count - 1 do
  begin
    c := list[i];
    if (c.codeST = code) then
    begin
      result := TValueSetProviderContext.Create(c.Link);
      exit;
    end;
    result := doLocate(c.conceptList, code);
    if result <> nil then
      exit;
  end;
end;

function TValueSetProvider.locate(code: String): TCodeSystemProviderContext;
begin
  result := DoLocate(FVS.define.conceptList, code);
end;

function TValueSetProvider.searchFilter(filter : TSearchFilterText; prep : TCodeSystemProviderFilterPreparationContext): TCodeSystemProviderFilterContext;
var
  res : TValueSetProviderFilterContext;
begin
  res := TValueSetProviderFilterContext.Create(TFhirValueSetDefineConceptList.Create);
  try
    FilterCodes(res.concepts, Fvs.define.conceptList, filter);
    res.total := res.concepts.Count;
    result := res.Link;
  finally
    res.Free;
  end;
end;

function TValueSetProvider.system: String;
begin
  result := Fvs.define.systemST;
end;

function TValueSetProvider.TotalCount: integer;
function count(item : TFhirValueSetDefineConcept) : integer;
var
  i : integer;
begin
  result := 1;
  for i := 0 to item.conceptList.count - 1 do
    inc(result, count(item.conceptList[i]));
end;
var
  i : integer;
begin
  result := 0;
  for i := 0 to FVs.define.conceptList.count - 1 do
    inc(result, count(FVs.define.conceptList[i]));
end;

procedure TValueSetProvider.Close(ctxt: TCodeSystemProviderFilterContext);
begin
  ctxt.Free;
end;

procedure iterateCodes(base : TFhirValueSetDefineConcept; list : TFhirValueSetDefineConceptList);
var
  i : integer;
begin
  if not base.abstractST then
    list.Add(base.Link);
  for i := 0 to base.conceptList.count - 1 do
    iterateCodes(base.conceptList[i], list);
end;

function TValueSetProvider.filter(prop: String; op: TFhirFilterOperator; value: String; prep : TCodeSystemProviderFilterPreparationContext): TCodeSystemProviderFilterContext;
var
  code : TValueSetProviderContext;
  cl : TFhirValueSetDefineConceptList;
begin
  if (op = FilterOperatorIsA) and (prop = 'concept') then
  begin
    code := doLocate(FVs.define.conceptList, value);
    try
      if code = nil then
        raise Exception.Create('Unable to locate code '+value)
      else
      begin
        cl := TFhirValueSetDefineConceptList.Create;
        try
          iterateCodes(code.context, cl);
          result := TValueSetProviderFilterContext.create(cl.link);
        finally
          cl.Free;
        end;
      end;
    finally
      Close(code)
    end;
  end
  else
    result := nil;
end;

procedure TValueSetProvider.FilterCodes(dest, source: TFhirValueSetDefineConceptList; filter : TSearchFilterText);
var
  i : integer;
  code : TFhirValueSetDefineConcept;
begin
  for i := 0 to source.Count - 1 do
  begin
    code := source[i];
    if filter.passes(code.tag as TAdvStringList) then
      dest.Add(code.Link);
    filterCodes(dest, code.conceptList, filter);
  end;
end;

function TValueSetProvider.FilterMore(ctxt: TCodeSystemProviderFilterContext): boolean;
begin
  inc(TValueSetProviderFilterContext(ctxt).ndx);
  result := TValueSetProviderFilterContext(ctxt).ndx < TValueSetProviderFilterContext(ctxt).total;
end;

function TValueSetProvider.FilterConcept(ctxt: TCodeSystemProviderFilterContext): TCodeSystemProviderContext;
var
  context : TValueSetProviderFilterContext;
begin
  context := TValueSetProviderFilterContext(ctxt);
  result := TValueSetProviderContext.Create(context.concepts[context.ndx].Link)
end;

function TValueSetProvider.FilterCount(ctxt: TFhirValueSetDefineConcept): integer;
var
  context : TValueSetProviderFilterContext;
begin
  context := TValueSetProviderFilterContext(ctxt);
  result := context.total;
end;

function TValueSetProvider.filterLocate(ctxt: TCodeSystemProviderFilterContext; code: String): TCodeSystemProviderContext;
var
  context : TValueSetProviderFilterContext;
  i : integer;
begin
  result := nil;
  context := TValueSetProviderFilterContext(ctxt);
  for i := 0 to context.concepts.Count - 1 do
    if context.concepts[i].codeST = code  then
    begin
      result := TValueSetProviderContext.Create( context.concepts[i].Link);
      break;
    end;
end;


function TValueSetProvider.locateIsA(code, parent: String): TCodeSystemProviderContext;
var
  p : TValueSetProviderContext;
begin
  result := nil;
  p := Locate(parent) as TValueSetProviderContext;
  if (p <> nil) then
    if (p.context.codeST = code) then
      result := p
    else
      result := doLocate(p.context.conceptList, code);
end;

{ TLoadedConceptMap }

destructor TLoadedConceptMap.Destroy;
begin
  FResource.Free;
  FSource.Free;
  FTarget.Free;
  inherited;
end;

function TLoadedConceptMap.HasTranslation(system, code : String; out maps : TFhirConceptMapConceptMapList): boolean;
begin
  result := HasTranslation(Resource.conceptList, system, code, maps);
end;

function TLoadedConceptMap.HasTranslation(list : TFhirConceptMapConceptList; system, code : String; out maps : TFhirConceptMapConceptMapList): boolean;
var
  i : integer;
  c : TFhirConceptMapConcept;
begin
  result := false;
  for i := 0 to list.Count - 1 do
  begin
    c := list[i];
    if (c.{$IFDEF FHIR-DSTU}systemST{$ELSE}codeSystemST{$ENDIF} = system) and (c.codeST = code) then
    begin
      maps := c.mapList.Link;
      result := true;
      exit;
    end;
  end;
end;

procedure TLoadedConceptMap.SetResource(const Value: TFhirConceptMap);
begin
  FResource.Free;
  FResource := Value;
end;

procedure TLoadedConceptMap.SetSource(const Value: TFhirValueSet);
begin
  FSource.Free;
  FSource := Value;
end;

procedure TLoadedConceptMap.SetTarget(const Value: TFhirValueSet);
begin
  FTarget.Free;
  FTarget := Value;
end;

{ TValueSetProviderFilterContext }

constructor TValueSetProviderFilterContext.Create(concepts: TFhirValueSetDefineConceptList);
begin
  inherited Create;
  self.concepts := concepts;
  total := self.concepts.Count;
end;

destructor TValueSetProviderFilterContext.Destroy;
begin
  concepts.Free;
  inherited;
end;

{ TValueSetProviderContext }

constructor TValueSetProviderContext.Create(context: TFhirValueSetDefineConcept);
begin
  inherited create;
  self.context := context;
end;

destructor TValueSetProviderContext.Destroy;
begin
  context.Free;
  inherited;
end;

end.

end.

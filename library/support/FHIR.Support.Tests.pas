﻿unit FHIR.Support.Tests;

{
Copyright (c) 2011+, HL7 and Health Intersections Pty Ltd (http://www.healthintersections.com.au)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of HL7 nor the names of its contributors may be used to
   endorse or promote products derived from this software without specific
   prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
}

{$I fhir.inc}

interface

Uses
  {$IFDEF WINDOWS} Windows, {$ENDIF} SysUtils, Classes, {$IFNDEF FPC}Soap.EncdDecd, System.NetEncoding, {$ENDIF} SyncObjs,
  {$IFDEF FPC} FPCUnit, TestRegistry, RegExpr, {$ELSE} DUnitX.TestFramework, {$ENDIF}
  IdGlobalProtocols, IdSSLOpenSSLHeaders,
  FHIR.Support.Base, FHIR.Support.Utilities, FHIR.Support.Stream, FHIR.Support.Threads, FHIR.Support.Collections, FHIR.Support.Fpc,
  FHIR.Support.Xml, FHIR.Support.MXml,
  {$IFNDEF FPC}
  FHIR.Support.MsXml,
  {$ENDIF}
  FHIR.Support.Json, FHIR.Support.Turtle,
  FHIR.Support.Certs, FHIR.Support.Comparisons, FHIR.Web.Parsers;

// *** General Testing Infrastructure ******************************************

type
  {$IFNDEF FPC}
  TRunMethod = TTestMethod;
  {$ENDIF}
  TFslTestThread = class;

  {
    TFslTestCase

    Base test case for all tests.

    For DUnitX, this doesn't do much directly, but it does define common assertions mechanism for FPCUnit and DUnitX.

    For FPC, it also makes it easy to register tests with alternative names

  }
  {$M+}
  TFslTestCase = class {$IFDEF FPC} (TTestCase) {$ENDIF}
  protected
    procedure assertPass;
    procedure assertFail(message : String);
    procedure assertTrue(test : boolean; message : String); overload;
    procedure assertTrue(test : boolean); overload;
    procedure assertFalse(test : boolean; message : String); overload;
    procedure assertFalse(test : boolean); overload;
    procedure assertEqual(left, right : String; message : String); overload;
    procedure assertEqual(left, right : String); overload;
    procedure assertWillRaise(AMethod: TRunMethod; AExceptionClass: ExceptClass; AExceptionMessage : String);
    procedure thread(proc : TRunMethod);
  public
    {$IFNDEF FPC}
    procedure setup; virtual;
    procedure tearDown; virtual;
    {$ENDIF}
  end;

  TFslTestSuite = class (TFslTestCase)
  protected
    {$IFDEF FPC}
    FName : String;
    function GetTestName: string; override;
    {$ENDIF}
  public
    {$IFDEF FPC}
    constructor Create(name : String);
    {$ENDIF}
    procedure TestCase(name : String); virtual;
  published
    {$IFDEF FPC}
    procedure Test;
    {$ENDIF}
  end;

  TFslTestThread = class (TThread)
  private
    FProc : TRunMethod;
  protected
    procedure Execute; override;
  public
    constructor Create(proc : TRunMethod);
  end;


function ownTestFile(parts : array of String) : String;
function fhirTestFile(parts : array of String) : String;

//    FHIR_TEST_CASE_ROOT : String = 'C:\work\org.hl7.fhir\fhir-test-cases';  // lots of the tests depend on content found in the FHIR publication
//function FHIR_TESTING_FILE(ver : integer; folder, filename : String) : String; overload;
//function FHIR_TESTING_FILE(folder, filename : String) : String; overload;

Type
  TFslTestString = class (TFslObject)
  private
    FString : String;
  public
    constructor Create(value : String);
    function Link :  TFslTestString; overload;
  end;

  TFslTestObject = class (TFslObject)
  private
    FValue: String;
  public
    constructor create(value : String); overload;
    property value : String read FValue write FValue;
  end;

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TFslGenericsTests = class (TFslTestCase)
  private
    function doSort(sender : TObject; const left, right : TFslTestObject) : integer;
  published
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure testSimple; //(obj : TFslObject);
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure testiterate;
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure testRemove;
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure testAddAll;
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure testReplace;
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure testMap;
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure testSort;
  end;

  TFslTestObjectList = class (TFslObjectList)
  private
  protected
    function ItemClass : TFslObjectClass; override;
  public
  end;

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TFslCollectionsTests = class (TFslTestCase)
  private
    list : TFslTestObjectList;
    procedure executeFail();
  published
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure testAdd;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure testAddFail;
  end;

  {$IFNDEF FPC}[TextFixture]{$ENDIF}

  {$IFDEF FPC}
  TFslRegexTests = class (TFslTestCase)
  private
  published
    procedure testRegex;
  end;
  {$ENDIF}

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TOSXTests = class (TFslTestCase)
  private
    procedure test60sec;
  published
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestAdvObject;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestCriticalSectionSimple;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestCriticalSectionThreaded;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestKCriticalSectionThreaded;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestKCriticalSectionSimple;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestSemaphore;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestTemp;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestFslDateTime;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestFslFile;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestRemoveAccents;
  end;

Type
  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TDecimalTests = Class (TFslTestCase)
  Private
    procedure testString(s, st, std : String);
    procedure TestAdd(s1,s2,s3:String);
    procedure TestMultiply(s1,s2,s3:String);
    procedure TestSubtract(s1,s2,s3:String);
    procedure TestDivide(s1,s2,s3:String);
    procedure TestDivInt(s1,s2,s3:String);
    procedure TestModulo(s1,s2,s3:String);
    procedure TestInteger(i : integer);
    procedure TestCardinal(i : cardinal);
    procedure TestInt64(i : int64);
    procedure TestRoundTrip(n1, n2, n3, t : String);
    procedure TestBoundsCase(v, low, high, ilow, ihigh : String);
    procedure TestTruncation(value : String; digits : integer; outcome : String; round : boolean);
  Published
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestIsDecimal;

    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestAsInteger;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestStringSupport;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestAddition;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestMultiplication;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestBounds;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestNormalisedDecimal;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestInfinity;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestOverloading;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure TestTrunc;
  End;

Type
  {$IFDEF FPC}
  TXmlParserTests = class(TTestSuite)
  private
  public
    constructor Create; override;
  end;
  {$ELSE}
  XmlParserTestCaseAttribute = class (CustomTestCaseSourceAttribute)
  protected
    function GetCaseInfoArray : TestCaseInfoArray; override;
  end;
  [TextFixture]
  {$ENDIF}
  TXmlParserTest = Class (TFslTestSuite)
  Published
    {$IFNDEF FPC}[XmlParserTestCase]{$ENDIF}
    procedure ParserTest(Name : String);
  End;

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TXmlUtilsTest = Class (TFslTestCase)
  Published
    {$IFNDEF FPC}[TestCase]{$ENDIF}
    procedure TestUnPretty;
    procedure TestPretty;
    procedure TestNoPretty;
    procedure TestNoDense;
  End;

  {$IFDEF FPC}
  TXPathParserTests = class(TTestSuite)
  private
  public
    constructor Create; override;
  end;
  {$ELSE}
  XPathParserTestCaseAttribute = class (CustomTestCaseSourceAttribute)
  protected
    function GetCaseInfoArray : TestCaseInfoArray; override;
  end;


  [TextFixture]
  {$ENDIF}
  TXPathParserTest = Class (TFslTestSuite)
  Private
    tests : TMXmlDocument;
    functionNames : TStringList;
    procedure collectFunctionNames(xp : TMXPathExpressionNode);
  public
    {$IFNDEF FPC}[SetupFixture]{$ENDIF} procedure setup; override;
    {$IFNDEF FPC}[TearDownFixture]{$ENDIF} procedure teardown; override;
  Published
    {$IFNDEF FPC}[XPathParserTestCase]{$ENDIF}
    procedure PathTest(Name : String);
  End;

  {$IFDEF FPC}
  TXPathEngineTests = class(TTestSuite)
  private
  public
    constructor Create; override;
  end;
  {$ELSE}
  XPathEngineTestCaseAttribute = class (CustomTestCaseSourceAttribute)
  protected
    function GetCaseInfoArray : TestCaseInfoArray; override;
  end;
  {$ENDIF}

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TXPathEngineTest = Class (TFslTestSuite)
  Private
    tests : TMXmlDocument;
    {$IFNDEF FPC}
    mstests : IXMLDOMDocument2;
    function findSampleMs(id : String) : IXMLDOMElement;
    procedure runMsTest(test : TMXmlElement; outcomes : TFslList<TMXmlElement>);
    {$ENDIF}
    function findTestCase(name : String) : TMXmlElement;
    function findSample(id : String) : TMXmlElement;
    procedure runTest(test : TMXmlElement; outcomes : TFslList<TMXmlElement>);
  public
    {$IFNDEF FPC}[SetupFixture]{$ENDIF} procedure setup; override;
    {$IFNDEF FPC}[TearDownFixture]{$ENDIF} procedure teardown; override;
  Published

    {$IFNDEF FPC}[XPathEngineTestCase]{$ENDIF}
    procedure PathTest(Name : String);
  End;

  {$IFDEF FPC}
  TXmlPatchTests = class(TTestSuite)
  private
  public
    constructor Create; override;
  end;
  {$ELSE}
  XmlPatchTestCaseAttribute = class (CustomTestCaseSourceAttribute)
  protected
    function GetCaseInfoArray : TestCaseInfoArray; override;
  end;
  {$ENDIF}

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TXmlPatchTest = Class (TFslTestSuite)
  Private
    tests : TMXmlDocument;
    engine : TXmlPatchEngine;
    // here for FPC to make the exception procedure event.
    test, target, patch, error, patched : TMXmlElement;
    procedure doExecute;
  public
    {$IFNDEF FPC}[SetupFixture]{$ENDIF} procedure setup; override;
    {$IFNDEF FPC}[TearDownFixture]{$ENDIF} procedure teardown; override;
  Published

    {$IFNDEF FPC}[XmlPatchTestCase]{$ENDIF}
    procedure PatchTest(Name : String);
  End;

Type
  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TJsonTests = Class (TFslTestCase)
  Private
  Published
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestResource;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestCustomDoc2;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestCustomDoc2Loose;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestCustomDecimal;
  End;

  {$IFDEF FPC}
  TJsonPatchTests = class(TTestSuite)
  private
  public
    constructor Create; override;
  end;
  {$ELSE}
  JsonPatchTestCaseAttribute = class (CustomTestCaseSourceAttribute)
  protected
    function GetCaseInfoArray : TestCaseInfoArray; override;
  end;
  {$ENDIF}

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TJsonPatchTest = Class (TFslTestSuite)
  Private
    tests : TJsonArray;
    test : TJsonObject;
    engine : TJsonPatchEngine;
    procedure execute;
  public
    {$IFNDEF FPC}[SetupFixture]{$ENDIF} procedure setup; override;
    {$IFNDEF FPC}[TearDownFixture]{$ENDIF} procedure teardown; override;
  Published

    {$IFNDEF FPC}[JsonPatchTestCase]{$ENDIF}
    procedure PatchTest(Name : String);
  End;

Type
  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TJWTTests = Class (TFslTestCase)
  public
    {$IFNDEF FPC}[SetUp]{$ENDIF} procedure Setup; override;
  Published
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestPacking;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestUnpacking;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure TestCert;
  End;

Type
  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TTurtleTests = Class (TFslTestCase)
  Private
    procedure parseTTl(filename : String; ok : boolean);
  Published
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_double_lower_case_e1;
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_double_lower_case_e2();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_empty_collection1();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_empty_collection2();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_first1();
//    procedure test_first2();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_HYPHEN_MINUS_in_localNameNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_HYPHEN_MINUS_in_localName();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRI_spoNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRI_subject();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRI_with_all_punctuationNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRI_with_all_punctuation();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRI_with_eight_digit_numeric_escape();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRI_with_four_digit_numeric_escape();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRIREF_datatypeNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_IRIREF_datatype();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_objectNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_object();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_subjectNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_subject();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_with_leading_digit();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_with_leading_underscore();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_with_non_leading_extras();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_labeled_blank_node_with_PN_CHARS_BASE_character_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_langtagged_LONG();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_langtagged_LONG_with_subtagNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_langtagged_LONG_with_subtag();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_langtagged_non_LONGNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_langtagged_non_LONG();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_lantag_with_subtagNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_lantag_with_subtag();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_lastNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_last();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_falseNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_false();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1_ascii_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1_ascii_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1_with_1_squoteNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1_with_1_squote();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1_with_2_squotesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1_with_2_squotes();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG1_with_UTF8_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_ascii_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_ascii_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_with_1_squoteNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_with_1_squote();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_with_2_squotesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_with_2_squotes();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_with_REVERSE_SOLIDUSNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_with_REVERSE_SOLIDUS();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_LONG2_with_UTF8_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_trueNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_true();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_BACKSPACENT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_BACKSPACE();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_CARRIAGE_RETURNNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_CARRIAGE_RETURN();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_CHARACTER_TABULATIONNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_CHARACTER_TABULATION();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_escaped_BACKSPACE();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_escaped_CARRIAGE_RETURN();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_escaped_CHARACTER_TABULATION();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_escaped_FORM_FEED();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_escaped_LINE_FEED();
//    procedure test_literal_with_FORM_FEEDNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_FORM_FEED();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_LINE_FEEDNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_LINE_FEED();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_numeric_escape4NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_numeric_escape4();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_numeric_escape8();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_REVERSE_SOLIDUSNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_literal_with_REVERSE_SOLIDUS();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL_with_UTF8_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1_all_controlsNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1_all_controls();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1_all_punctuationNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1_all_punctuation();
//    procedure test_LITERAL1_ascii_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1_ascii_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL1_with_UTF8_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL2();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL2_ascii_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL2_ascii_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_LITERAL2_with_UTF8_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_assigned_nfc_bmp_PN_CHARS_BASE_character_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_assigned_nfc_bmp_PN_CHARS_BASE_character_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_assigned_nfc_PN_CHARS_BASE_character_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_assigned_nfc_PN_CHARS_BASE_character_boundaries();
//    procedure test_localname_with_COLONNT();
//    procedure test_localname_with_COLON();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_leading_digitNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_leading_digit();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_leading_underscoreNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_leading_underscore();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_nfc_PN_CHARS_BASE_character_boundariesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_nfc_PN_CHARS_BASE_character_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_non_leading_extrasNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_localName_with_non_leading_extras();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_negative_numericNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_negative_numeric();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_nested_blankNodePropertyListsNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_nested_blankNodePropertyLists();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_nested_collectionNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_nested_collection();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_number_sign_following_localNameNT();
//    procedure test_number_sign_following_localName();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_number_sign_following_PNAME_NSNT();
//    procedure test_number_sign_following_PNAME_NS();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_numeric_with_leading_0NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_numeric_with_leading_0();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_objectList_with_two_objectsNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_objectList_with_two_objects();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_old_style_base();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_old_style_prefix();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_percent_escaped_localNameNT();
//    procedure test_percent_escaped_localName();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_positive_numericNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_positive_numeric();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_predicateObjectList_with_two_objectListsNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_predicateObjectList_with_two_objectLists();
//    procedure test_prefix_only_IRI();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_prefix_reassigned_and_usedNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_prefix_reassigned_and_used();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_prefix_with_non_leading_extras();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_prefix_with_PN_CHARS_BASE_character_boundaries();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_prefixed_IRI_object();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_prefixed_IRI_predicate();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_prefixed_name_datatype();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_repeated_semis_at_end();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_repeated_semis_not_at_endNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_repeated_semis_not_at_end();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_reserved_escaped_localNameNT();
//    procedure test_reserved_escaped_localName();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_sole_blankNodePropertyList();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_SPARQL_style_base();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_SPARQL_style_prefix();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_eval_bad_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_eval_bad_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_eval_bad_03();
//    procedure test_turtle_eval_bad_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_eval_struct_01NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_eval_struct_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_eval_struct_02NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_eval_struct_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_01NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_02NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_03NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_04NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_05NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_06NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_06();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_07NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_08();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_09NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_09();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_10NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_10();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_11NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_11();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_12NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_12();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_13NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_13();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_14NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_14();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_15NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_15();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_16NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_16();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_17NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_17();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_18NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_18();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_19NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_19();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_20NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_20();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_21NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_21();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_22NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_22();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_23NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_23();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_24NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_24();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_25NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_25();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_26NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_26();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_27NT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_subm_27();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_base_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_base_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_base_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_esc_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_esc_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_esc_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_esc_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_kw_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_kw_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_kw_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_kw_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_kw_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_lang_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_LITERAL2_with_langtag_and_datatype();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_ln_dash_start();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_ln_escape();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_ln_escape_start();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_missing_ns_dot_end();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_missing_ns_dot_start();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_08();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_09();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_10();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_11();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_12();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_n3_extras_13();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_ns_dot_end();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_ns_dot_start();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_num_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_num_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_num_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_num_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_num_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_number_dot_in_anon();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_pname_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_pname_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_prefix_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_prefix_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_prefix_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_prefix_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_prefix_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_string_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_string_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_string_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_string_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_string_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_string_06();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_string_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_06();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_08();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_09();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_10();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_11();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_12();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_13();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_14();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_15();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_16();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_struct_17();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_uri_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bad_uri_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_base_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_base_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_base_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_base_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_blank_label();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_06();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_08();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_09();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_bnode_10();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_datatypes_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_datatypes_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_file_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_file_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_file_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_kw_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_kw_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_kw_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_lists_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_lists_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_ln_dots();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_ns_dots();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_06();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_09();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_10();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_number_11();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_pname_esc_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_pname_esc_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_pname_esc_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_prefix_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_prefix_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_prefix_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_prefix_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_prefix_08();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_prefix_09();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_str_esc_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_str_esc_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_str_esc_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_06();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_07();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_08();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_09();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_10();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_string_11();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_struct_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_struct_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_struct_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_struct_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_struct_05();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_uri_01();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_uri_02();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_uri_03();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_turtle_syntax_uri_04();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_two_LITERAL_LONG2sNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_two_LITERAL_LONG2s();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_underscore_in_localNameNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_underscore_in_localName();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_anonymous_blank_node_object();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_anonymous_blank_node_subject();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_bareword_a_predicateNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_bareword_a_predicate();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_bareword_decimalNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_bareword_decimal();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_bareword_doubleNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_bareword_double();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_bareword_integer();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_blankNodePropertyList_as_objectNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_blankNodePropertyList_as_object();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_blankNodePropertyList_as_subjectNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_blankNodePropertyList_containing_collectionNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_blankNodePropertyList_containing_collection();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_blankNodePropertyList_with_multiple_triplesNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_blankNodePropertyList_with_multiple_triples();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_collection_objectNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_collection_object();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_collection_subjectNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_collection_subject();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_comment_following_localName();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_comment_following_PNAME_NSNT();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test_comment_following_PNAME_NS();
    {$IFNDEF FPC}[TestCase]{$ENDIF} procedure test__default_namespace_IRI();
  End;
   (*
Type
  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TDigitalSignatureTests = Class (TObject)
  private
    procedure testFile(filename : String);
  Published
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testFileRSA;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testFileDSA;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testFileJames;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testGenRSA_1;
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testGenRSA_256;
//    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testGenDSA_1;
//    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testGenDSA_256;
  End;
     *)

  {$IFNDEF FPC}[TextFixture]{$ENDIF}
  TLangParserTests = Class (TFslTestCase)
  Published
    {$IFNDEF FPC}[TestCase]{$ENDIF} Procedure testBase;
  End;

implementation

const psc = {$IFDEF WINDOWS} '\' {$ELSE} '/' {$ENDIF};

function testFile(root : String; parts : array of String) : String;
var
  part : String;
  s : String;
begin
  result := root;
  for part in parts do
  begin
    s := part.Replace('/', psc).Replace('\', psc);
    if result = '' then
      result := s
    else if not result.EndsWith(psc) and not s.startsWith(psc) then
      result := result + psc + s
    else if not result.EndsWith(psc) or not s.startsWith(psc) then
      result := result + s
    else
      result := result + s.substring(1);
  end;
end;

function ownTestFile(parts : array of String) : String;
begin
  result := testFile('c:/work/fhirserver', parts);
end;

function fhirTestFile(parts : array of String) : String;
begin
  result := testFile('c:/work/org.hl7.fhir/fhir-test-cases', parts);
end;

{$IFDEF FPC}
{ TFslRegexTests }

procedure TFslRegexTests.testRegex;
var
  this : TRegExpr;
begin
  this := TRegExpr.create('(([a-z])+:)*((%[0-9a-fA-F]{2})|[&''\\(\\)*+,;:@_~?!$\\/\\-\\#.\\=a-zA-Z0-9])+');
  try
    assertTrue(this.Exec('http://a.example/p'));
  finally
    this.free;
  end;
end;
{$ENDIF}

{ TFslGenericsTests }

{$HINTS OFF}
procedure TFslGenericsTests.testSimple;
var
  l : TFslList<TFslObject>;
  x : TFslObject;
begin
  // you should get one leak when you execute these tests. this exists to make sure that the leak tracking system is working
  x := TFslObject.Create;
  l := TFslList<TFslObject>.create;
  try
    l.Add(TFslObject.Create);
    assertTrue(l.Count = 1, 'Count should be 1');
  finally
    l.Free;
  end;
end;
{$HINTS ON}

function TFslGenericsTests.doSort(sender : TObject; const left, right : TFslTestObject) : integer;
begin
  result := CompareStr(left.value, right.value);
end;

procedure TFslGenericsTests.testSort;
var
  list : TFslList<TFslTestObject>;
begin
  list := TFslList<TFslTestObject>.Create;
  try
    list.Add(TFslTestObject.Create('a'));
    list.SortE(doSort);
    assertTrue(list.Count = 1);
    assertTrue(list[0].value = 'a');
    list.Insert(0, TFslTestObject.Create('b'));
    assertTrue(list.Count = 2);
    assertTrue(list[0].value = 'b');
    assertTrue(list[1].value = 'a');
    list.SortE(doSort);
    assertTrue(list.Count = 2);
    assertTrue(list[0].value = 'a');
    assertTrue(list[1].value = 'b');
    list.Insert(1, TFslTestObject.Create('c'));
    assertTrue(list.Count = 3);
    assertTrue(list[0].value = 'a');
    assertTrue(list[1].value = 'c');
    assertTrue(list[2].value = 'b');
    list.SortE(doSort);
    assertTrue(list.Count = 3);
    assertTrue(list[0].value = 'a');
    assertTrue(list[1].value = 'b');
    assertTrue(list[2].value = 'c');
  finally
    list.Free;
  end;
end;

procedure TFslGenericsTests.testAddAll;
var
  l : TFslList<TFslObject>;
  l2 : TFslList<TFslTestString>;
  o : TFslTestString;
begin
  l := TFslList<TFslObject>.create;
  l2 := TFslList<TFslTestString>.create;
  try
    l.Add(TFslObject.Create);
    l2.Add(TFslTestString.create('test'));
    for o in l2 do
      l.add(o.Link);
    assertTrue(l.Count = 2);
  finally
    l.Free;
    l2.Free;
  end;
end;

procedure TFslGenericsTests.testRemove;
var
  l : TFslList<TFslObject>;
begin
  l := TFslList<TFslObject>.create;
  try
    l.Add(TFslObject.Create);
    assertTrue(l.Count = 1);
    l.Delete(0);
    assertTrue(l.Count = 0);
    l.Add(TFslObject.Create);
    assertTrue(l.Count = 1);
  finally
    l.Free;
  end;
end;

procedure TFslGenericsTests.testReplace;
var
  l : TFslList<TFslObject>;
begin
  l := TFslList<TFslObject>.create;
  try
    l.Add(TFslObject.Create);
    l[0] := TFslObject.Create;
    assertTrue(l.Count = 1);
  finally
    l.Free;
  end;
end;

procedure TFslGenericsTests.testIterate;
var
  l : TFslList<TFslObject>;
  c : integer;
  o : TFslObject;
begin
  l := TFslList<TFslObject>.create;
  try
    l.Add(TFslObject.Create);
    l.Add(TFslObject.Create);
    l.Add(TFslObject.Create);
    c := 0;
    for o in l do
      if (o = l[c]) then
        inc(c);
    if c <> 3 then
      raise ETestCase.create('Wrong Count');
    assertTrue(l.Count = 3);
  finally
    l.Free;
  end;
end;

procedure TFslGenericsTests.testMap;
var
  map : TFslMap<TFslTestString>;
begin
  map := TFslMap<TFslTestString>.create('tests');
  try
    map.Add('test1', TFslTestString.create('test1'));
    map.Add('test2', TFslTestString.create('test2'));
    map.AddOrSetValue('test2', TFslTestString.create('test3'));
    if map['test1'].FString <> 'test1' then
      raise ETestCase.create('Mismatch');
    if map['test2'].FString <> 'test3' then
      raise ETestCase.create('Mismatch');
    map.Remove('1est1');
    assertTrue(map.Count = 2);
  finally
    map.Free;
  end;
end;

{ TFslTestString }

constructor TFslTestString.create(value: String);
begin
  inherited Create;
  FString := value;
end;

function TFslTestString.Link: TFslTestString;
begin
 result := TFslTestString(inherited link);
end;

{ TXmlTests }

{$IFDEF FPC}
constructor TXmlPatchTests.Create;
var
  tests : TMXmlDocument;
  test : TMXmlElement;
begin
  inherited create;
  tests := TMXmlParser.ParseFile(fhirTestFile(['r4', 'patch', 'xml-patch-tests.xml']), [xpResolveNamespaces]);
  try
    test := tests.document.first;
    while test <> nil do
    begin
      if test.Name = 'case' then
        AddTest(TXmlPatchTest.create(test.attribute['name']));
      test := test.Next;
    end;
  finally
    tests.Free;
  end;
end;
{$ELSE}

{ XmlPatchTestCaseAttribute }

function XmlPatchTestCaseAttribute.GetCaseInfoArray: TestCaseInfoArray;
var
  tests : TMXmlDocument;
  test : TMXmlElement;
  i : integer;
  s : String;
begin
  tests := TMXmlParser.ParseFile(fhirTestFile(['r4', 'patch', 'xml-patch-tests.xml']), [xpResolveNamespaces]);
  try
    test := tests.document.first;
    i := 0;
    while test <> nil do
    begin
      if test.Name = 'case' then
      begin
        s := test.attribute['name'];
        SetLength(result, i+1);
        result[i].Name := s;
        SetLength(result[i].Values, 1);
        result[i].Values[0] := s;
        inc(i);
      end;
      test := test.Next;
    end;
  finally
    tests.Free;
  end;
end;

{$ENDIF}

{ TXmlPatchTest }

procedure TXmlPatchTest.doExecute();
begin
  engine.execute(tests, target, patch);
end;

procedure TXmlPatchTest.PatchTest(Name: String);
var
  s : String;
  ok : boolean;
begin
  test := tests.document.first;
  while test <> nil do
  begin
    if (test.Name = 'case') and (name = test.attribute['name']) then
    begin
      target := test.element('target');
      patch := test.element('patch');
      error := test.element('error');
      patched := test.element('patched');

      if (error <> nil) then
        {$IFDEF FPC}
        assertWillRaise(doExecute, EXmlException, error.text)
        {$ELSE}
        Assert.WillRaiseWithMessage(
          procedure begin
            engine.execute(tests, target, patch);
          end, EXmlException, error.text)
        {$ENDIF}
      else
      begin
        engine.execute(tests, target, patch);
        StringToFile(target.first.ToXml(true), 'c:\temp\outcome.xml', TEncoding.UTF8);
        StringToFile(patched.first.ToXml(true), 'c:\temp\patched.xml', TEncoding.UTF8);
        ok := CheckXMLIsSame('c:\temp\patched.xml', 'c:\temp\outcome.xml', s);
        assertTrue(ok, s);
      end;
    end;
    test := test.Next;
  end;
end;

procedure TXmlPatchTest.setup;
begin
  tests := TMXmlParser.ParseFile(fhirTestFile(['r4', 'patch', 'xml-patch-tests.xml']), [xpResolveNamespaces, xpDropWhitespace]);
  engine := TXmlPatchEngine.Create;
end;

procedure TXmlPatchTest.teardown;
begin
  engine.Free;
  tests.Free;
end;

{ TXmlParserTest }

procedure TXmlParserTest.ParserTest(Name: String);
var
  xml : TMXmlElement;
begin
  xml := TMXmlParser.parseFile(name, []);
  try
    assertPass();
  finally
    xml.Free;
  end;
end;

{$IFDEF FPC}
{ TXmlParserTests }

constructor TXmlParserTests.Create;
var
  sl : TStringlist;
  sr : TSearchRec;
  s : String;
  i : integer;
begin
  inherited Create;
  if FindFirst(ownTestFile(['resources', 'testcases', 'xml', '*.xml']), faAnyFile, SR) = 0 then
  repeat
    AddTest(TXmlParserTest.Create(sr.Name));
  until FindNext(SR) <> 0;
end;

{$ELSE}

{ XmlParserTestCaseAttribute }

function XmlParserTestCaseAttribute.GetCaseInfoArray: TestCaseInfoArray;
var
  sl : TStringlist;
  sr : TSearchRec;
  s : String;
  i : integer;
begin
  sl := TStringList.create;
  try
    if FindFirst('C:\work\fhirserver\reference-platform\support\Tests\*.xml', faAnyFile, SR) = 0 then
    repeat
      s := sr.Name;
      sl.Add(sr.Name);
    until FindNext(SR) <> 0;
    setLength(result, sl.Count);
    for i := 0 to sl.Count - 1 do
    begin
      result[i].Name := sl[i];
      SetLength(result[i].Values, 1);
      result[i].Values[0] := 'C:\work\fhirserver\reference-platform\support\Tests\' + sl[i];
    end;
  finally
    sl.Free;
  end;
end;
{$ENDIF}

{$IFDEF FPC}
{ TXPathParserTests }

constructor TXPathParserTests.Create;
var
  tests : TMXmlDocument;
  path : TMXmlElement;
  i : integer;
begin
  inherited Create;
  tests := TMXmlParser.ParseFile(ownTestFile(['resources', 'testcases', 'xml', 'xpath-parser-tests.xml']), [xpDropWhitespace, xpDropComments]);
  try
    i := 0;
    path := tests.document.first;
    while path <> nil do
    begin
      AddTest(TXPathParserTest.create(inttostr(i)));
      inc(i);
      path := path.next;
    end;
  finally
    tests.Free;
  end;
end;

{$ELSE}
{ XPathParserTestCaseAttribute }

function XPathParserTestCaseAttribute.GetCaseInfoArray: TestCaseInfoArray;
var
  tests : TMXmlDocument;
  path : TMXmlElement;
  i : integer;
begin
  tests := TMXmlParser.ParseFile('C:\work\fhirserver\utilities\tests\xml\xpath-parser-tests.xml', [xpDropWhitespace, xpDropComments]);
  try
    i := 0;
    path := tests.document.first;
    while path <> nil do
    begin
      SetLength(result, i+1);
      result[i].Name := inttostr(i);
      SetLength(result[i].Values, 1);
      result[i].Values[0] := inttostr(i);
      inc(i);
      path := path.next;
    end;
  finally
    tests.Free;
  end;
end;
{$ENDIF}

{ TXPathTests }

{
function TXPathTests.findTest(name: String): TMXmlElement;
var
  res, path : TMXmlElement;
begin
  result := nil;
  res := tests.document.first;
  while res <> nil do
  begin
    path := res.first;
    while path <> nil do
    begin
      if (path.attribute['path'] = name) then
        exit(path);
      path := path.Next;
    end;
    res := res.Next;
  end;
end;

function XpathForPath(path : string):string;
var
  p : TArray<String>;
  b : TStringBuilder;
  s : String;
begin
  p := path.Split(['.']);
  b := TStringBuilder.Create;
  try
    for s in p do
    begin
      if b.Length > 0 then
        b.Append('/');
      b.Append('f:');
      b.Append(s);
    end;
    result := b.ToString;
  finally
    b.Free;
  end;
end;
}

procedure TXPathParserTest.collectFunctionNames(xp: TMXPathExpressionNode);
var
  node : TMXPathExpressionNode;
begin
  if xp = nil then
    exit;
  if xp.NodeType = xentFunction then
  begin
    if functionNames.IndexOf(xp.value) = -1 then
      functionNames.Add(xp.value);
  end;
  for node in xp.filters do
    collectFunctionNames(node);
  for node in xp.Params do
    collectFunctionNames(node);
  collectFunctionNames(xp.next);
  collectFunctionNames(xp.Group);
  collectFunctionNames(xp.NextOp);
end;

procedure TXPathParserTest.PathTest(Name: String);
var
  test : TMXmlElement;
  xp : TMXPathExpressionNode;
begin
  test := tests.document.children[StrToInt(name)];
  xp := TMXmlParser.parseXPath(test.attribute['value']);
  try
    collectFunctionNames(xp);
    assertPass();
  finally
    xp.Free
  end;
end;

procedure TXPathParserTest.setup;
begin
  tests := TMXmlParser.ParseFile('C:\work\fhirserver\utilities\tests\xml\xpath-parser-tests.xml', [xpDropWhitespace, xpDropComments]);
  functionNames := TStringList.Create;
end;

procedure TXPathParserTest.teardown;
begin
  functionNames.Free;
  tests.Free;
end;

{$IFDEF FPC}

constructor TXPathEngineTests.Create;
var
  tests : TMXmlDocument;
  tcase : TMXmlElement;
  i : integer;
begin
  inherited create;
  tests := TMXmlParser.ParseFile(ownTestFile(['resources', 'testcases', 'xml', 'xpath-tests.xml']), [xpResolveNamespaces]);
  try
    i := 0;
    tcase := tests.document.firstElement;
    while tcase <> nil do
    begin
      if tcase.Name = 'case' then
        addTest(TXPathEngineTest.create(tcase.attribute['name']));
      tcase := tcase.nextElement;
    end;
  finally
    tests.Free;
  end;
end;

{$ELSE}

{ XPathEngineTestCaseAttribute }

function XPathEngineTestCaseAttribute.GetCaseInfoArray: TestCaseInfoArray;
var
  tests : TMXmlDocument;
  tcase : TMXmlElement;
  i : integer;
begin
  tests := TMXmlParser.ParseFile(ownTestFile(['resources', 'testcases', 'xml', 'xpath-tests.xml']), [xpResolveNamespaces]);
  try
    i := 0;
    tcase := tests.document.firstElement;
    while tcase <> nil do
    begin
      if tcase.Name = 'case' then
      begin
        SetLength(result, i+1);
        result[i].Name := tcase.attribute['name'];
        SetLength(result[i].Values, 1);
        result[i].Values[0] := inttostr(i);
        inc(i);
      end;
      tcase := tcase.nextElement;
    end;
  finally
    tests.Free;
  end;
end;

{$ENDIF}

{ TXPathEngineTest }

function TXPathEngineTest.findSample(id: String): TMXmlElement;
var
  sample : TMXmlElement;
begin
  sample := tests.document.firstElement;
  while sample <> nil do
  begin
    if sample.Name = 'sample' then
    begin
      if (sample.attribute['id'] = id) then
        exit(sample);
    end;
    sample := sample.next;
  end;
  result := nil;
end;

{$IFNDEF FPC}
function TXPathEngineTest.findSampleMs(id: String): IXMLDOMElement;
var
  sample : IXMLDOMElement;
begin
  sample := TMsXmlParser.FirstChild(mstests.documentElement);
  while sample <> nil do
  begin
    if sample.nodeName = 'sample' then
    begin
      if (sample.getAttribute('id') = id) then
        exit(sample);
    end;
    sample := TMsXmlParser.NextSibling(sample);
  end;
  result := nil;
end;

procedure TXPathEngineTest.runMsTest(test : TMXmlElement; outcomes : TFslList<TMXmlElement>);
var
  focus : IXMLDOMElement;
  outcome: TMXmlElement;
  nodes : IXMLDOMNodeList;
  node : IXMLDOMNode;
  i : integer;
begin
  if (test.attribute['ms'] = 'no') then
    exit;
  for outcome in outcomes do
    if not StringArrayExistsSensitive(['text', 'attribute', 'element', 'comment'], outcome.attribute['type']) then
      exit;

  focus := TMsXmlParser.FirstChild(findSampleMs(test.attribute['id']));
  nodes := focus.selectNodes(test.element('xpath').attribute['value']);
  if test.element('outcomes').HasAttribute['count'] then
    assertTrue(StrToInt(test.element('outcomes').attribute['count']) = nodes.length, 'MS: Wrong number of nodes returned - expected '+test.element('outcomes').attribute['count']+', found '+inttostr(nodes.length))
  else
  begin
    assertTrue(outcomes.Count = nodes.length, 'MS: Wrong number of nodes returned - expected '+inttostr(outcomes.Count)+', found '+inttostr(nodes.length));
    for i := 0 to outcomes.Count - 1 do
    begin
      node := nodes.item[i];
      outcome := outcomes[i];
      if outcome.attribute['type'] = 'string' then
      begin
        raise ETestCase.create('not done yet');
  //      assertTrue(node is TMXmlString, 'MS: Node '+inttostr(i)+' has the wrong type (expected string, found '+node.ClassName.substring(5));
  //      assertTrue(TMXmlString(node).value = outcome.attribute['value'], 'MS: Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+TMXmlString(node).value);
      end
      else if outcome.attribute['type'] = 'number' then
      begin
        raise ETestCase.create('not done yet');
  //      assertTrue(node is TMXmlNumber, 'MS: Node '+inttostr(i)+' has the wrong type (expected number, found '+node.ClassName.substring(5));
  //      assertTrue(TMXmlNumber(node).value = StrToInt(outcome.attribute['value']), 'MS: Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+inttostr(TMXmlNumber(node).value));
      end
      else if outcome.attribute['type'] = 'boolean' then
      begin
        raise ETestCase.create('not done yet');
  //      assertTrue(node is TMXmlBoolean, 'MS: Node '+inttostr(i)+' has the wrong type (expected boolean, found '+node.ClassName.substring(5));
  //      assertTrue(TMXmlBoolean(node).value = StringToBoolean(outcome.attribute['value']), 'MS: Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+BooleanToString(TMXmlBoolean(node).value));
      end
      else if outcome.attribute['type'] = 'attribute' then
      begin
        assertTrue(node.nodeType = NODE_ATTRIBUTE, 'MS: Node '+inttostr(i)+' has the wrong type (expected Attribute, found '+inttostr(node.nodeType));
        assertTrue(node.text = outcome.attribute['value'], 'MS: Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+node.text);
      end
      else if outcome.attribute['type'] = 'element' then
      begin
        assertTrue(node.nodeType = NODE_ELEMENT, 'MS: Node '+inttostr(i)+' has the wrong type (expected element, found '+inttostr(node.nodeType));
        assertTrue(node.baseName = outcome.attribute['name'], 'MS: Node '+inttostr(i)+' has the wrong name (expected '+outcome.attribute['name']+', found '+node.baseName);
        assertTrue(node.namespaceURI = outcome.attribute['namespace'], 'MS: Node '+inttostr(i)+' has the wrong namespace (expected '+outcome.attribute['namespace']+', found '+node.NamespaceURI);
      end
      else if outcome.attribute['type'] = 'text' then
      begin
        assertTrue(node.nodeType = NODE_TEXT, 'MS: Node '+inttostr(i)+' has the wrong type (expected text, found '+inttostr(node.nodeType));
        if outcome.HasAttribute['value'] then
          assertTrue(node.text = outcome.Attribute['value'], 'MS: Node '+inttostr(i)+' has the wrong type (expected text "'+outcome.Attribute['value']+'", found '+node.text);
      end
      else if outcome.attribute['type'] = 'comment' then
      begin
        raise ETestCase.create('not done yet');
  //      assertTrue((node is TMXmlElement) and (TMXmlElement(node).nodeType = ntComment), 'Node '+inttostr(i)+' has the wrong type (expected comment, found '+node.ClassName.substring(5));
  //
      end
      else
        raise ETestCase.create('Error Message');
    end;
  end;
end;

{$ENDIF}

function TXPathEngineTest.findTestCase(name: String): TMXmlElement;
var
  tcase : TMXmlElement;
  i : integer;
begin
  i := 0;
  tcase := tests.document.firstElement;
  while tcase <> nil do
  begin
    if tcase.Name = 'case' then
    begin
      if (inttostr(i) = Name) then
        exit(tcase);
      inc(i);
    end;
    tcase := tcase.next;
  end;
  result := nil;
end;

procedure TXPathEngineTest.runTest(test : TMXmlElement; outcomes : TFslList<TMXmlElement>);
var
  focus, outcome : TMXmlElement;
  nodes : TFslList<TMXmlNode>;
  node : TMXmlNode;
  i : integer;
begin
  focus := findSample(test.attribute['id']).firstElement;
  nodes := tests.select(test.element('xpath').attribute['value'], focus);
  try
  if test.element('outcomes').hasAttribute['count'] then
    assertTrue(StrToInt(test.element('outcomes').attribute['count']) = nodes.Count, 'Wrong number of nodes returned - expected '+test.element('outcomes').attribute['count']+', found '+inttostr(nodes.Count))
  else
  begin
    assertTrue(outcomes.Count = nodes.Count, 'Wrong number of nodes returned - expected '+inttostr(outcomes.Count)+', found '+inttostr(nodes.Count));
    for i := 0 to outcomes.Count - 1 do
    begin
      node := nodes[i];
      outcome := outcomes[i];
      if outcome.attribute['type'] = 'string' then
      begin
        assertTrue(node is TMXmlString, 'Node '+inttostr(i)+' has the wrong type (expected string, found '+node.ClassName.substring(5));
        assertTrue(TMXmlString(node).value = outcome.attribute['value'], 'Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+TMXmlString(node).value);
      end
      else if outcome.attribute['type'] = 'number' then
      begin
        assertTrue(node is TMXmlNumber, 'Node '+inttostr(i)+' has the wrong type (expected number, found '+node.ClassName.substring(5));
        assertTrue(TMXmlNumber(node).value = StrToInt(outcome.attribute['value']), 'Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+inttostr(TMXmlNumber(node).value));
      end
      else if outcome.attribute['type'] = 'boolean' then
      begin
        assertTrue(node is TMXmlBoolean, 'Node '+inttostr(i)+' has the wrong type (expected boolean, found '+node.ClassName.substring(5));
        assertTrue(TMXmlBoolean(node).value = StringToBoolean(outcome.attribute['value']), 'Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+BooleanToString(TMXmlBoolean(node).value));
      end
      else if outcome.attribute['type'] = 'attribute' then
      begin
        assertTrue(node is TMXmlAttribute, 'Node '+inttostr(i)+' has the wrong type (expected Attribute, found '+node.ClassName.substring(5));
        assertTrue(TMXmlAttribute(node).LocalName = outcome.attribute['name'], 'Node '+inttostr(i)+' has the wrong name (expected '+outcome.attribute['name']+', found '+TMXmlAttribute(node).LocalName);
        assertTrue(TMXmlAttribute(node).value = outcome.attribute['value'], 'Node '+inttostr(i)+' has the wrong value (expected '+outcome.attribute['value']+', found '+TMXmlAttribute(node).value);
      end
      else if outcome.attribute['type'] = 'element' then
      begin
        assertTrue((node is TMXmlElement) and (TMXmlElement(node).nodeType = ntElement), 'Node '+inttostr(i)+' has the wrong type (expected element, found '+node.ClassName.substring(5));
        assertTrue(TMXmlElement(node).LocalName = outcome.attribute['name'], 'Node '+inttostr(i)+' has the wrong name (expected '+outcome.attribute['name']+', found '+TMXmlElement(node).LocalName);
        assertTrue(TMXmlElement(node).NamespaceURI = outcome.attribute['namespace'], 'Node '+inttostr(i)+' has the wrong namespace (expected '+outcome.attribute['namespace']+', found '+TMXmlElement(node).NamespaceURI);
      end
      else if outcome.attribute['type'] = 'text' then
      begin
        assertTrue((node is TMXmlElement) and (TMXmlElement(node).nodeType = ntText), 'Node '+inttostr(i)+' has the wrong type (expected text, found '+node.ClassName.substring(5));

      end
      else if outcome.attribute['type'] = 'comment' then
      begin
        assertTrue((node is TMXmlElement) and (TMXmlElement(node).nodeType = ntComment), 'Node '+inttostr(i)+' has the wrong type (expected comment, found '+node.ClassName.substring(5));

      end
      else
        raise ETestCase.create('Error Message');
    end;
  end;
  finally
    nodes.Free;
  end;
end;

procedure TXPathEngineTest.PathTest(Name: String);
var
  test : TMXmlElement;
  outcomes : TFslList<TMXmlElement>;
begin
  test := findTestCase(name);
  outcomes := tests.selectElements('node', test.element('outcomes'));
  try
    {$IFNDEF FPC}
    runMsTest(test, outcomes);
    {$ENDIF}
    runTest(test, outcomes);
  finally
    outcomes.Free;
  end;
end;

procedure TXPathEngineTest.setup;
begin
  tests := TMXmlParser.ParseFile('C:\work\fhirserver\utilities\tests\xml\xpath-tests.xml', [xpResolveNamespaces]);
  tests.NamespaceAbbreviations.AddOrSetValue('f', 'http://hl7.org/fhir');
  tests.NamespaceAbbreviations.AddOrSetValue('h', 'http://www.w3.org/1999/xhtml');
  {$IFNDEF FPC}
  mstests := TMsXmlParser.Parse('C:\work\fhirserver\utilities\tests\xml\xpath-tests.xml');
  mstests.setProperty('SelectionNamespaces','xmlns:f=''http://hl7.org/fhir'' xmlns:h=''http://www.w3.org/1999/xhtml''');
  {$ENDIF}
end;

procedure TXPathEngineTest.teardown;
begin
  tests.Free;
end;

{ TDecimalTests }

procedure TDecimalTests.testString(s, st, std: String);
var
  dec : TFslDecimal;
  s1, s2 : String;
begin
  dec := TFslDecimal.valueOf(s);
  s1 := dec.AsString;
  s2 := dec.AsScientific;
  assertTrue(s1 = st);
  assertTrue(s2 = std);
  dec := TFslDecimal.valueOf(std);
  s1 := dec.AsDecimal;
  assertTrue(s1 = st);
end;

procedure TDecimalTests.TestStringSupport;
begin
  testString('1', '1', '1e0');
  testString('0', '0', '0e0');
  testString('10', '10', '1.0e1');
  testString('99', '99', '9.9e1');
  testString('-1', '-1', '-1e0');
  testString('-0', '0', '0e0');
  testString('-10', '-10', '-1.0e1');
  testString('-99', '-99', '-9.9e1');

  testString('1.1', '1.1', '1.1e0');
  testString('-1.1', '-1.1', '-1.1e0');
  testString('11.1', '11.1', '1.11e1');
  testString('1.11', '1.11', '1.11e0');
  testString('1.111', '1.111', '1.111e0');
  testString('0.1', '0.1', '1e-1');
  testString('00.1', '0.1', '1e-1');
  testString('.1', '0.1', '1e-1');
  testString('1.0', '1.0', '1.0e0');
  testString('1.00', '1.00', '1.00e0');
  testString('1.000000000000000000000000000000000000000', '1.000000000000000000000000000000000000000', '1.000000000000000000000000000000000000000e0');

  testString('-11.1', '-11.1', '-1.11e1');
  testString('-1.11', '-1.11', '-1.11e0');
  testString('-1.111', '-1.111', '-1.111e0');
  testString('-0.1', '-0.1', '-1e-1');
  testString('-00.1', '-0.1', '-1e-1');
  testString('-.1', '-0.1', '-1e-1');
  testString('-1.0', '-1.0', '-1.0e0');
  testString('-1.00', '-1.00', '-1.00e0');
  testString('-1.000000000000000000000000000000000000000', '-1.000000000000000000000000000000000000000', '-1.000000000000000000000000000000000000000e0');

  testString('0.0', '0.0', '0.0e0');
  testString('0.0000', '0.0000', '0.0000e0');
  testString('0.1', '0.1', '1e-1');
  testString('00.1', '0.1', '1e-1');
  testString('0.100', '0.100', '1.00e-1');
  testString('100', '100', '1.00e2');
  testString('1.0', '1.0', '1.0e0');
  testString('1.1', '1.1', '1.1e0');
  testString('-0.1', '-0.1', '-1e-1');
  testString('0.01', '0.01', '1e-2');
  testString('0.001', '0.001', '1e-3');
  testString('0.0001', '0.0001', '1e-4');
  testString('00.0001', '0.0001', '1e-4');
  testString('000.0001', '0.0001', '1e-4');
  testString('-0.01', '-0.01', '-1e-2');
  testString('10.01', '10.01', '1.001e1');
  testString('0.0001', '0.0001', '1e-4');
  testString('0.00001', '0.00001', '1e-5');
  testString('0.000001', '0.000001', '1e-6');
  testString('0.0000001', '0.0000001', '1e-7');
  testString('0.000000001', '0.000000001', '1e-9');
  testString('0.00000000001', '0.00000000001', '1e-11');
  testString('0.0000000000001', '0.0000000000001', '1e-13');
  testString('0.000000000000001', '0.000000000000001', '1e-15');
  testString('0.00000000000000001', '0.00000000000000001', '1e-17');
  testString('10.1', '10.1', '1.01e1');
  testString('100.1', '100.1', '1.001e2');
  testString('1000.1', '1000.1', '1.0001e3');
  testString('10000.1', '10000.1', '1.00001e4');
  testString('100000.1', '100000.1', '1.000001e5');
  testString('1000000.1', '1000000.1', '1.0000001e6');
  testString('10000000.1', '10000000.1', '1.00000001e7');
  testString('100000000.1', '100000000.1', '1.000000001e8');
  testString('1000000000.1', '1000000000.1', '1.0000000001e9');
  testString('10000000000.1', '10000000000.1', '1.00000000001e10');
  testString('100000000000.1', '100000000000.1', '1.000000000001e11');
  testString('1000000000000.1', '1000000000000.1', '1.0000000000001e12');
  testString('10000000000000.1', '10000000000000.1', '1.00000000000001e13');
  testString('100000000000000.1', '100000000000000.1', '1.000000000000001e14');
//  testString('1e-3', '1e-3');   , '1e-3');  e0  }
end;

procedure TDecimalTests.TestAddition;
begin
  TestAdd('1', '1', '2');
  TestAdd('0', '1', '1');
  TestAdd('0', '0', '0');
  TestAdd('5', '5', '10');
  TestAdd('10', '1', '11');
  TestAdd('11', '12', '23');
  TestAdd('15', '16', '31');
  TestAdd('150', '160', '310');
  TestAdd('153', '168', '321');
  TestAdd('15300000000000000000000000000000000001', '1680', '15300000000000000000000000000000001681');
  TestAdd('1', '.1', '1.1');
  TestAdd('1', '.001', '1.001');
  TestAdd('.1', '.1', '0.2');
  TestAdd('.1', '.01', '0.11');

  TestSubtract('2', '1', '1');
  TestSubtract('2', '0', '2');
  TestSubtract('0', '0', '0');
  TestSubtract('0', '2', '-2');
  TestSubtract('2', '2', '0');
  TestSubtract('1', '2', '-1');
  TestSubtract('20', '1', '19');
  TestSubtract('2', '.1', '1.9');
  TestSubtract('2', '.000001', '1.999999');
  TestSubtract('2', '2.000001', '-0.000001');
  TestSubtract('3.5', '35.5', '-32.0');

  TestAdd('5', '6', '11');
  TestAdd('5', '-6', '-1');
  TestAdd('-5', '6', '1');
  TestAdd('-5', '-6', '-11');

  TestSubtract('5', '6', '-1');
  TestSubtract('6', '5', '1');
  TestSubtract('5', '-6', '11');
  TestSubtract('6', '-5', '11');
  TestSubtract('-5', '6', '-11');
  TestSubtract('-6', '5', '-11');
  TestSubtract('-5', '-6', '1');
  TestSubtract('-6', '-5', '-1');

  TestAdd('2', '0.001', '2.001');
  TestAdd('2.0', '0.001', '2.001');
end;

procedure TDecimalTests.TestAdd(s1, s2, s3: String);
var
  o1, o2, o3: TFslDecimal;
begin
    o1 := TFslDecimal.valueOf(s1);
    o2 := TFslDecimal.valueOf(s2);
    o3 := o1.add(o2);
    assertTrue(o3.AsDecimal = s3);
end;

procedure TDecimalTests.TestSubtract(s1, s2, s3: String);
var
  o1, o2, o3: TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(s1);
  o2 := TFslDecimal.valueOf(s2);
  o3 := o1.Subtract(o2);
  assertTrue(o3.AsDecimal = s3);
end;

procedure TDecimalTests.testTrunc;
begin
  testTruncation('1', 0, '1', false);
  testTruncation('1.01', 0, '1', false);
  testTruncation('-1.01', 0, '-1', false);
  testTruncation('0.01', 0, '0', false);
  testTruncation('-0.01', 0, '0', false);
  testTruncation('0.1', 0, '0', false);
  testTruncation('0.0001', 0, '0', false);
  testTruncation('100.000000000000000000000000000000000000000001', 0, '100', false);

  TestTruncation('1.2345678', 0, '1', true);
  TestTruncation('1.2345678', 1, '1.2', true);
  TestTruncation('1.2345678', 2, '1.23', true);
  TestTruncation('1.2345678', 3, '1.234', true);
  TestTruncation('1.2345678', 6, '1.234567', true);
  TestTruncation('1.2345678', 10, '1.2345678', true);
//  TestTruncation('1.2345678', 0, '1', false);
//  TestTruncation('1.2345678', 1, '1.2', false);
//  TestTruncation('1.2345678', 2, '1.23', false);
//  TestTruncation('1.2345678', 3, '1.234', false);
//  TestTruncation('1.2345678', 6, '1.234568', false);
//  TestTruncation('1.2345678', 10, '1.2345678', false);
end;

procedure TDecimalTests.TestTruncation(value: String; digits: integer; outcome: String; round: boolean);
var
  o1, o2 : TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(value);
  o2 := o1.Trunc(digits);
  assertTrue(o2.AsDecimal = outcome);
end;

procedure TDecimalTests.TestMultiplication;
begin
  TestMultiply('2', '2', '4');
  TestMultiply('2', '0.5', '1');
  TestMultiply('0', '0', '0');
  TestMultiply('0', '1', '0');
  TestMultiply('4', '4', '16');
  TestMultiply('20', '20', '400');
  TestMultiply('200', '20', '4000');
  TestMultiply('400', '400', '160000');
  TestMultiply('2.0', '2.0', '4.0');
  TestMultiply('2.00', '2.0', '4.0');
  TestMultiply('2.0', '0.2', '0.4');
  TestMultiply('2.0', '0.20', '0.40');
  TestMultiply('13', '13', '169');
  TestMultiply('12', '89', '1068');
  TestMultiply('1234', '6789', '8377626');

  TestMultiply('10000', '0.0001', '1');
  TestMultiply('10000', '0.00010', '1.0');
  TestMultiply('10000', '0.000100', '1.00');
  TestMultiply('10000', '0.0001000', '1.000');
  TestMultiply('10000', '0.00010000', '1.0000');
  TestMultiply('10000', '0.000100000', '1.00000');
  TestMultiply('10000.0', '0.000100000', '1.00000');
  TestMultiply('10000.0', '0.0001000000', '1.00000');
  TestMultiply('10000.0', '0.00010000000', '1.00000');

  TestMultiply('2', '-2', '-4');
  TestMultiply('-2', '2', '-4');
  TestMultiply('-2', '-2', '4');

  TestMultiply('35328734682734', '2349834295876423', '83016672387407213199375780482');
  TestMultiply('35328734682734000000000', '2349834295876423000000000', '83016672387407213199375780482000000000000000000');
  TestMultiply('3532873468.2734', '23498342958.76423', '83016672387407213199.375780482');

  TestDivide('500', '4', '125');
  TestDivide('1260257', '37', '34061');

  TestDivide('127', '4', '31.75');
  TestDivide('10', '10', '1');
  TestDivide('1', '1', '1');
  TestDivide('1', '3', '0.333333333333333333333333');
  TestDivide('1.0', '3', '0.33');
  TestDivide('10', '3', '3.33333333333333333333333');
  TestDivide('10.0', '3', '3.33');
  TestDivide('10.00', '3', '3.333');
  TestDivide('10.00', '3.0', '3.3');
  TestDivide('100', '1', '100');
  TestDivide('1000', '10', '100');
  TestDivide('100001', '10', '10000.1');
  TestDivide('100', '10', '10');
  TestDivide('1', '10', '0.1');
  TestDivide('1', '15', '0.0666666666666666666666667');
  TestDivide('1.0', '15', '0.067');
  TestDivide('1.00', '15.0', '0.0667');
  TestDivide('1', '0.1', '10');
  TestDivide('1', '0.10', '10');
  TestDivide('1', '0.010', '100');
  TestDivide('1', '1.5', '0.67');
  TestDivide('1.0', '1.5', '0.67');
  TestDivide('10', '1.5', '6.7');

  TestDivide('-1', '1', '-1');
  TestDivide('1', '-1', '-1');
  TestDivide('-1', '-1', '1');

  TestDivide('2', '2', '1');
  TestDivide('20', '2', '10');
  TestDivide('22', '2', '11');

  TestDivide('83016672387407213199375780482', '2349834295876423', '35328734682734');
  TestDivide('83016672387407213199375780482000000000000000000', '2349834295876423000000000', '35328734682734000000000');
  TestDivide('83016672387407213199.375780482', '23498342958.76423', '3532873468.2734');

  TestDivInt('500', '4', '125');
  TestDivInt('1260257', '37', '34061');
  TestDivInt('127', '4', '31');
  TestDivInt('10', '10', '1');
  TestDivInt('1', '1', '1');
  TestDivInt('100', '1', '100');
  TestDivInt('1000', '10', '100');
  TestDivInt('100001', '10', '10000');
  TestDivInt('1', '1.5', '0');
  TestDivInt('10', '1.5', '6');

  TestModulo('10', '1', '0');
  TestModulo('7', '4', '3');

  TestMultiply('2', '2', '4');
  TestMultiply('2.0', '2.0', '4.0');
  TestMultiply('2.00', '2.0', '4.0');

  TestDivide('10.0',  '3', '3.33');
  TestDivide('10.00',  '3', '3.333');
  TestDivide('10.00',  '3.0', '3.3');
  TestDivide('10',  '3.0', '3.3');

  TestRoundTrip('1','60', '60', '1');
end;

procedure TDecimalTests.TestMultiply(s1, s2, s3: String);
var
  o1, o2, o3: TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(s1);
  o2 := TFslDecimal.valueOf(s2);
  o3 := o1.Multiply(o2);
  assertTrue(o3.AsDecimal = s3);
end;

procedure TDecimalTests.TestRoundTrip(n1, n2, n3, t: String);
var
  o1, o2, o3, o4: TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(n1);
  o2 := TFslDecimal.valueOf(n2);
  o3 := o1.Divide(o2);
  o4 := o3.Multiply(TFslDecimal.valueOf(n3));
  assertTrue(o4.AsDecimal = t);
end;

procedure TDecimalTests.TestDivide(s1, s2, s3: String);
var
  o1, o2, o3: TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(s1);
  o2 := TFslDecimal.valueOf(s2);
  o3 := o1.Divide(o2);
  assertTrue(o3.AsDecimal = s3);
end;

procedure TDecimalTests.TestDivInt(s1, s2, s3: String);
var
  o1, o2, o3: TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(s1);
  o2 := TFslDecimal.valueOf(s2);
  o3 := o1.DivInt(o2);
  assertTrue(o3.AsDecimal = s3);
end;

procedure TDecimalTests.TestModulo(s1, s2, s3: String);
var
  o1, o2, o3: TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(s1);
  o2 := TFslDecimal.valueOf(s2);
  o3 := o1.Modulo(o2);
  assertTrue(o3.AsDecimal = s3);
end;

procedure TDecimalTests.TestAsInteger;
begin
  TestInteger(0);
  TestInteger(1);
  TestInteger(2);
  TestInteger(64);
  TestInteger(High(Integer));
  TestInteger(-1);
  TestInteger(-2);
  TestInteger(-64);
  TestInteger(Low(Integer));

  TestCardinal(0);
  TestCardinal(2);
  TestCardinal(High(Cardinal));

  TestInt64(0);
  TestInt64(1);
  testInt64(-1);
  TestInt64(High(integer));
  TestInt64(Low(integer));
  TestInt64(High(Cardinal));
  TestInt64(High(int64));
  TestInt64(Low(int64));
end;

procedure TDecimalTests.TestBounds;
begin
  TestBoundsCase('1',      '0.5',   '1.5',  '0.999999999999999999999999',   '1.00000000000000000000001');
  TestBoundsCase('1.0',   '0.95',  '1.05',  '0.999999999999999999999999',   '1.00000000000000000000001');
  TestBoundsCase('1.00', '0.995', '1.005',  '0.999999999999999999999999',   '1.00000000000000000000001');
  TestBoundsCase('0',     '-0.5',   '0.5', '-0.000000000000000000000001',   '0.000000000000000000000001');
  TestBoundsCase('0.0',  '-0.05',  '0.05', '-0.000000000000000000000001',   '0.000000000000000000000001');
  TestBoundsCase('-1',    '-1.5',  '-0.5', '-1.000000000000000000000001',  '-0.99999999999999999999999');
end;

procedure TDecimalTests.TestBoundsCase(v, low, high, ilow, ihigh : String);
var
  o1: TFslDecimal;
begin
  o1 := TFslDecimal.valueOf(v);
  assertTrue(o1.upperBound.AsDecimal = high);
  assertTrue(o1.lowerBound.AsDecimal = low);
//    check(o1.immediateUpperBound.AsDecimal = ihigh);
//    check(o1.immediateLowerBound.AsDecimal = ilow);
end;

function n(s : String; defUp : boolean) : String;
begin
  result := TFslDecimal.valueOf(s).normaliseDecimal(5, 5, defUp);
end;
const up = true; dn = false;

procedure TDecimalTests.TestNormalisedDecimal;
begin
  // simple numbers
  assertTrue(n('0',         up) = '000000.00000');
  assertTrue(n('0',         dn) = '000000.00000');
  assertTrue(n('-0',        up) = '000000.00000');
  assertTrue(n('-0',        dn) = '000000.00000');
  assertTrue(n('1',         up) = '000001.00000');
  assertTrue(n('1',         dn) = '000001.00000');
  assertTrue(n('0.1',       up) = '000000.10000');
  assertTrue(n('0.1',       dn) = '000000.10000');
  assertTrue(n('-1',        up) = '!99999.00000');
  assertTrue(n('-1',        dn) = '!99999.00000');
  assertTrue(n('-0.1',      up) = '!99999.90000');
  assertTrue(n('-0.1',      dn) = '!99999.90000');

  // limits
  assertTrue(n('99999',     up) = '099999.00000');
  assertTrue(n('99999',     dn) = '099999.00000');
  assertTrue(n('-99999',    up) = '!00001.00000');
  assertTrue(n('-99999',    dn) = '!00001.00000');
  assertTrue(n('0.00001',   up) = '000000.00001');
  assertTrue(n('0.00001',   dn) = '000000.00001');
  assertTrue(n('-0.00001',  up) = '!99999.99999');
  assertTrue(n('-0.00001',  dn) = '!99999.99999');

  // past the limit +large
  assertTrue(n('100000',    up) = '0XXXXX.XXXXX');
  assertTrue(n('100000',    dn) = '099999.99999');

  // past the limit -large
  assertTrue(n('-100001',   up) = '!00000.00000');
  assertTrue(n('-100001',   dn) = '!#####.#####');

  // past the limit +small
  assertTrue(n('0.000001',  up) = '000000.00001');
  assertTrue(n('0.000001',  dn) = '000000.00000');

  // past the limit -small
  assertTrue(n('-0.000001', up) = '000000.00000');
  assertTrue(n('-0.000001', dn) = '!99999.99999');

  // now, check order:
  assertTrue(n('1000000', true) > n('1000', true));
  assertTrue(n('10000', true) > n('1', true));
  assertTrue(n('1', true) > n('0.1', true));
  assertTrue(n('1', true) > n('-1', true));
  assertTrue(n('-1', true) > n('-10000', true));
  assertTrue(n('-10000', true) > n('-1000000', true));
end;

procedure TDecimalTests.TestOverloading;
begin
  assertTrue(TFslDecimal('1') + TFslDecimal(2) = TFslDecimal('3'));
end;

procedure TDecimalTests.TestInteger(i: integer);
var
  d : TFslDecimal;
begin
  d := TFslDecimal.valueOf(i);
  assertTrue(d.AsInteger = i);
end;

procedure TDecimalTests.TestIsDecimal;
begin
  assertTrue(StringIsDecimal('0'), '"0" is a decimal');
  assertTrue(StringIsDecimal('+0'), '"+0" is a decimal');
  assertFalse(StringIsDecimal('0+'), '"0+" is not a decimal');
  assertFalse(StringIsDecimal('+'), '"+" is not a decimal');
  assertTrue(StringIsDecimal('-0'), '"-0" is a decimal');
  assertFalse(StringIsDecimal('0-'), '"0-" is not a decimal');
  assertFalse(StringIsDecimal('-'), '"-" is not a decimal');
  assertTrue(StringIsDecimal('0e0'), '"0e0" is a decimal');
  assertTrue(StringIsDecimal('+0e+0'), '"+0e+0" is a decimal');
  assertTrue(StringIsDecimal('-0e-0'), '"-0e-0" is a decimal');
  assertFalse(StringIsDecimal('0e'), '"0e" is not a decimal');
  assertFalse(StringIsDecimal('e0'), '"e0" is not a decimal');
  assertTrue(StringIsDecimal('1.2'), '"1.2" is a decimal');
  assertTrue(StringIsDecimal('-1.2'), '"-1.2" is a decimal');
  assertTrue(StringIsDecimal('+1.2'), '"+1.2" is a decimal');
  assertFalse(StringIsDecimal('1. 2'), '"1. 2" is not a decimal');
  assertFalse(StringIsDecimal('1 .2'), '"1 .2" is not a decimal');
  assertFalse(StringIsDecimal(' 1.2'), '" 1.2" is not a decimal');
  assertFalse(StringIsDecimal('1.2 '), '"1.2 " is not a decimal');
  assertTrue(StringIsDecimal('1.2e2'), '"1.2e2" is a decimal');
  assertTrue(StringIsDecimal('1.2e-2'), '"1.2e2" is a decimal');
  assertTrue(StringIsDecimal('1.2e+2'), '"1.2e2" is a decimal');
  assertFalse(StringIsDecimal('1.2e2e3'), '"1.2e2e3" is not a decimal');
end;

procedure TDecimalTests.TestCardinal(i: cardinal);
var
  i64 : int64;
  d : TFslDecimal;
begin
  i64 := i;
  d := TFslDecimal.valueOf(i64);
  assertTrue(d.AsCardinal = i);
  //check(d.AsInteger = i);
end;

procedure TDecimalTests.TestInfinity;
begin
  assertTrue(TFslDecimal.makeInfinity.IsInfinite);
  assertTrue(TFslDecimal.makeInfinity.Negated.IsNegative);
  assertFalse(TFslDecimal.makeUndefined.IsInfinite);
  assertFalse(TFslDecimal.makeInfinity.IsUndefined);
  assertFalse(TFslDecimal.makeNull.IsUndefined);
  assertFalse(TFslDecimal.makeNull.IsInfinite);
  assertFalse(TFslDecimal.makeNull.isANumber);
  assertTrue(TFslDecimal.makeInfinity.Equals(TFslDecimal.makeInfinity));

  assertTrue(TFslDecimal.ValueOf('Inf').IsInfinite);
  assertTrue(TFslDecimal.ValueOf('-Inf').IsInfinite);
  assertTrue(not TFslDecimal.ValueOf('Inf').IsNegative);
  assertTrue(TFslDecimal.ValueOf('-Inf').IsNegative);

  assertTrue(n('Inf',    up) = '0XXXXX.XXXXX');
  assertTrue(n('Inf',    dn) = '099999.99999');
  assertTrue(n('+Inf',    up) = '0XXXXX.XXXXX');

  assertTrue(n('-Inf',   up) = '!00000.00000');
  assertTrue(n('-Inf',   dn) = '!#####.#####');

end;

procedure TDecimalTests.TestInt64(i: int64);
var
  d : TFslDecimal;
begin
  d := TFslDecimal.valueOf(i);
  assertTrue(d.AsInt64 = i);
end;

{ TTurtleTests }

procedure TTurtleTests.parseTtl(filename: String; ok: boolean);
var
  s : String;
  ttl : TTurtleDocument;
begin
  s := fileToString(fhirTestFile(['turtle', filename]), TEncoding.UTF8);
  try
    ttl := TTurtleParser.parse(s);
    try
      assertTrue(ttl <> nil);
      assertTrue(ok);
    finally
      ttl.Free;
    end;
  except
    on e : Exception do
    begin
      assertTrue(not ok, 'Unexpected Exception: '+e.message);
    end;
  end;
end;

procedure TTurtleTests.test_double_lower_case_e1;
begin
  parseTtl('double_lower_case_e.nt', true);
end;

procedure TTurtleTests.test_double_lower_case_e2();
begin
  parseTtl('double_lower_case_e.ttl', true);
end;

procedure TTurtleTests.test_empty_collection1();
begin
  parseTtl('empty_collection.nt', true);
end;

procedure TTurtleTests.test_empty_collection2();
begin
  parseTtl('empty_collection.ttl', true);
end;

procedure TTurtleTests.test_first1();
begin
  parseTtl('first.nt', true);
end;

//procedure TTurtleTests.test_first2();
//begin
////     parseTtl('first.ttl', true);
//end;

procedure TTurtleTests.test_HYPHEN_MINUS_in_localNameNT();
begin
  parseTtl('HYPHEN_MINUS_in_localName.nt', true);
end;

procedure TTurtleTests.test_HYPHEN_MINUS_in_localName();
begin
  parseTtl('HYPHEN_MINUS_in_localName.ttl', true);
end;

procedure TTurtleTests.test_IRI_spoNT();
begin
  parseTtl('IRI_spo.nt', true);
end;

procedure TTurtleTests.test_IRI_subject();
begin
  parseTtl('IRI_subject.ttl', true);
end;

procedure TTurtleTests.test_IRI_with_all_punctuationNT();
begin
  parseTtl('IRI_with_all_punctuation.nt', true);
end;

procedure TTurtleTests.test_IRI_with_all_punctuation();
begin
  parseTtl('IRI_with_all_punctuation.ttl', true);
end;

procedure TTurtleTests.test_IRI_with_eight_digit_numeric_escape();
begin
  parseTtl('IRI_with_eight_digit_numeric_escape.ttl', true);
end;

procedure TTurtleTests.test_IRI_with_four_digit_numeric_escape();
begin
  parseTtl('IRI_with_four_digit_numeric_escape.ttl', true);
end;

procedure TTurtleTests.test_IRIREF_datatypeNT();
begin
  parseTtl('IRIREF_datatype.nt', true);
end;

procedure TTurtleTests.test_IRIREF_datatype();
begin
  parseTtl('IRIREF_datatype.ttl', true);
end;

procedure TTurtleTests.test_labeled_blank_node_objectNT();
begin
  parseTtl('labeled_blank_node_object.nt', true);
end;

procedure TTurtleTests.test_labeled_blank_node_object();
begin
  parseTtl('labeled_blank_node_object.ttl', true);
end;

procedure TTurtleTests.test_labeled_blank_node_subjectNT();
begin
  parseTtl('labeled_blank_node_subject.nt', true);
end;

procedure TTurtleTests.test_labeled_blank_node_subject();
begin
  parseTtl('labeled_blank_node_subject.ttl', true);
end;

procedure TTurtleTests.test_labeled_blank_node_with_leading_digit();
begin
  parseTtl('labeled_blank_node_with_leading_digit.ttl', true);
end;

procedure TTurtleTests.test_labeled_blank_node_with_leading_underscore();
begin
  parseTtl('labeled_blank_node_with_leading_underscore.ttl', true);
end;

procedure TTurtleTests.test_labeled_blank_node_with_non_leading_extras();
begin
  parseTtl('labeled_blank_node_with_non_leading_extras.ttl', true);
end;

procedure TTurtleTests.test_labeled_blank_node_with_PN_CHARS_BASE_character_boundaries();
begin
  parseTtl('labeled_blank_node_with_PN_CHARS_BASE_character_boundaries.ttl', false);
end;

procedure TTurtleTests.test_langtagged_LONG();
begin
  parseTtl('langtagged_LONG.ttl', true);
end;

procedure TTurtleTests.test_langtagged_LONG_with_subtagNT();
begin
  parseTtl('langtagged_LONG_with_subtag.nt', true);
end;

procedure TTurtleTests.test_langtagged_LONG_with_subtag();
begin
  parseTtl('langtagged_LONG_with_subtag.ttl', true);
end;

procedure TTurtleTests.test_langtagged_non_LONGNT();
begin
  parseTtl('langtagged_non_LONG.nt', true);
end;

procedure TTurtleTests.test_langtagged_non_LONG();
begin
  parseTtl('langtagged_non_LONG.ttl', true);
end;

procedure TTurtleTests.test_lantag_with_subtagNT();
begin
  parseTtl('lantag_with_subtag.nt', true);
end;

procedure TTurtleTests.test_lantag_with_subtag();
begin
  parseTtl('lantag_with_subtag.ttl', true);
end;

procedure TTurtleTests.test_lastNT();
begin
  parseTtl('last.nt', true);
end;

procedure TTurtleTests.test_last();
begin
  parseTtl('last.ttl', false);
end;

procedure TTurtleTests.test_literal_falseNT();
begin
  parseTtl('literal_false.nt', true);
end;

procedure TTurtleTests.test_literal_false();
begin
  parseTtl('literal_false.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG1();
begin
  parseTtl('LITERAL_LONG1.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG1_ascii_boundariesNT();
begin
  parseTtl('LITERAL_LONG1_ascii_boundaries.nt', false);
end;

procedure TTurtleTests.test_LITERAL_LONG1_ascii_boundaries();
begin
  parseTtl('LITERAL_LONG1_ascii_boundaries.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG1_with_1_squoteNT();
begin
  parseTtl('LITERAL_LONG1_with_1_squote.nt', true);
end;

procedure TTurtleTests.test_LITERAL_LONG1_with_1_squote();
begin
  parseTtl('LITERAL_LONG1_with_1_squote.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG1_with_2_squotesNT();
begin
  parseTtl('LITERAL_LONG1_with_2_squotes.nt', true);
end;

procedure TTurtleTests.test_LITERAL_LONG1_with_2_squotes();
begin
  parseTtl('LITERAL_LONG1_with_2_squotes.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG1_with_UTF8_boundaries();
begin
  parseTtl('LITERAL_LONG1_with_UTF8_boundaries.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG2();
begin
  parseTtl('LITERAL_LONG2.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG2_ascii_boundariesNT();
begin
  parseTtl('LITERAL_LONG2_ascii_boundaries.nt', false);
end;

procedure TTurtleTests.test_LITERAL_LONG2_ascii_boundaries();
begin
  parseTtl('LITERAL_LONG2_ascii_boundaries.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG2_with_1_squoteNT();
begin
  parseTtl('LITERAL_LONG2_with_1_squote.nt', true);
end;

procedure TTurtleTests.test_LITERAL_LONG2_with_1_squote();
begin
  parseTtl('LITERAL_LONG2_with_1_squote.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG2_with_2_squotesNT();
begin
  parseTtl('LITERAL_LONG2_with_2_squotes.nt', true);
end;

procedure TTurtleTests.test_LITERAL_LONG2_with_2_squotes();
begin
  parseTtl('LITERAL_LONG2_with_2_squotes.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_LONG2_with_REVERSE_SOLIDUSNT();
begin
  parseTtl('LITERAL_LONG2_with_REVERSE_SOLIDUS.nt', false);
end;

procedure TTurtleTests.test_LITERAL_LONG2_with_REVERSE_SOLIDUS();
begin
  parseTtl('LITERAL_LONG2_with_REVERSE_SOLIDUS.ttl', false);
end;

procedure TTurtleTests.test_LITERAL_LONG2_with_UTF8_boundaries();
begin
  parseTtl('LITERAL_LONG2_with_UTF8_boundaries.ttl', true);
end;

procedure TTurtleTests.test_literal_trueNT();
begin
  parseTtl('literal_true.nt', true);
end;

procedure TTurtleTests.test_literal_true();
begin
  parseTtl('literal_true.ttl', true);
end;

procedure TTurtleTests.test_literal_with_BACKSPACENT();
begin
  parseTtl('literal_with_BACKSPACE.nt', false);
end;

procedure TTurtleTests.test_literal_with_BACKSPACE();
begin
  parseTtl('literal_with_BACKSPACE.ttl', true);
end;

procedure TTurtleTests.test_literal_with_CARRIAGE_RETURNNT();
begin
  parseTtl('literal_with_CARRIAGE_RETURN.nt', true);
end;

procedure TTurtleTests.test_literal_with_CARRIAGE_RETURN();
begin
  parseTtl('literal_with_CARRIAGE_RETURN.ttl', true);
end;

procedure TTurtleTests.test_literal_with_CHARACTER_TABULATIONNT();
begin
  parseTtl('literal_with_CHARACTER_TABULATION.nt', true);
end;

procedure TTurtleTests.test_literal_with_CHARACTER_TABULATION();
begin
  parseTtl('literal_with_CHARACTER_TABULATION.ttl', true);
end;

procedure TTurtleTests.test_literal_with_escaped_BACKSPACE();
begin
  parseTtl('literal_with_escaped_BACKSPACE.ttl', false);
end;

procedure TTurtleTests.test_literal_with_escaped_CARRIAGE_RETURN();
begin
  parseTtl('literal_with_escaped_CARRIAGE_RETURN.ttl', true);
end;

procedure TTurtleTests.test_literal_with_escaped_CHARACTER_TABULATION();
begin
  parseTtl('literal_with_escaped_CHARACTER_TABULATION.ttl', true);
end;

procedure TTurtleTests.test_literal_with_escaped_FORM_FEED();
begin
  parseTtl('literal_with_escaped_FORM_FEED.ttl', true);
end;

procedure TTurtleTests.test_literal_with_escaped_LINE_FEED();
begin
  parseTtl('literal_with_escaped_LINE_FEED.ttl', true);
end;

//procedure TTurtleTests.test_literal_with_FORM_FEEDNT();
//begin
////     parseTtl('literal_with_FORM_FEED.nt', true);
//end;

procedure TTurtleTests.test_literal_with_FORM_FEED();
begin
  parseTtl('literal_with_FORM_FEED.ttl', true);
end;

procedure TTurtleTests.test_literal_with_LINE_FEEDNT();
begin
  parseTtl('literal_with_LINE_FEED.nt', true);
end;

procedure TTurtleTests.test_literal_with_LINE_FEED();
begin
  parseTtl('literal_with_LINE_FEED.ttl', true);
end;

procedure TTurtleTests.test_literal_with_numeric_escape4NT();
begin
  parseTtl('literal_with_numeric_escape4.nt', true);
end;

procedure TTurtleTests.test_literal_with_numeric_escape4();
begin
  parseTtl('literal_with_numeric_escape4.ttl', true);
end;

procedure TTurtleTests.test_literal_with_numeric_escape8();
begin
  parseTtl('literal_with_numeric_escape8.ttl', true);
end;

procedure TTurtleTests.test_literal_with_REVERSE_SOLIDUSNT();
begin
  parseTtl('literal_with_REVERSE_SOLIDUS.nt', false);
end;

procedure TTurtleTests.test_literal_with_REVERSE_SOLIDUS();
begin
  parseTtl('literal_with_REVERSE_SOLIDUS.ttl', true);
end;

procedure TTurtleTests.test_LITERAL_with_UTF8_boundariesNT();
begin
  parseTtl('LITERAL_with_UTF8_boundaries.nt', true);
end;

procedure TTurtleTests.test_LITERAL1NT();
begin
  parseTtl('LITERAL1.nt', true);
end;

procedure TTurtleTests.test_LITERAL1();
begin
  parseTtl('LITERAL1.ttl', true);
end;

procedure TTurtleTests.test_LITERAL1_all_controlsNT();
begin
  parseTtl('LITERAL1_all_controls.nt', false);
end;

procedure TTurtleTests.test_LITERAL1_all_controls();
begin
  parseTtl('LITERAL1_all_controls.ttl', true);
end;

procedure TTurtleTests.test_LITERAL1_all_punctuationNT();
begin
  parseTtl('LITERAL1_all_punctuation.nt', true);
end;

procedure TTurtleTests.test_LITERAL1_all_punctuation();
begin
  parseTtl('LITERAL1_all_punctuation.ttl', true);
end;

//procedure TTurtleTests.test_LITERAL1_ascii_boundariesNT();
//begin
////     parseTtl('LITERAL1_ascii_boundaries.nt', true);
//end;

procedure TTurtleTests.test_LITERAL1_ascii_boundaries();
begin
  parseTtl('LITERAL1_ascii_boundaries.ttl', true);
end;

procedure TTurtleTests.test_LITERAL1_with_UTF8_boundaries();
begin
  parseTtl('LITERAL1_with_UTF8_boundaries.ttl', true);
end;

procedure TTurtleTests.test_LITERAL2();
begin
  parseTtl('LITERAL2.ttl', true);
end;

procedure TTurtleTests.test_LITERAL2_ascii_boundariesNT();
begin
  parseTtl('LITERAL2_ascii_boundaries.nt', false);
end;

procedure TTurtleTests.test_LITERAL2_ascii_boundaries();
begin
  parseTtl('LITERAL2_ascii_boundaries.ttl', true);
end;

procedure TTurtleTests.test_LITERAL2_with_UTF8_boundaries();
begin
  parseTtl('LITERAL2_with_UTF8_boundaries.ttl', true);
end;

procedure TTurtleTests.test_localName_with_assigned_nfc_bmp_PN_CHARS_BASE_character_boundariesNT();
begin
  parseTtl('localName_with_assigned_nfc_bmp_PN_CHARS_BASE_character_boundaries.nt', true);
end;

procedure TTurtleTests.test_localName_with_assigned_nfc_bmp_PN_CHARS_BASE_character_boundaries();
begin
  parseTtl('localName_with_assigned_nfc_bmp_PN_CHARS_BASE_character_boundaries.ttl', true);
end;

procedure TTurtleTests.test_localName_with_assigned_nfc_PN_CHARS_BASE_character_boundariesNT();
begin
  parseTtl('localName_with_assigned_nfc_PN_CHARS_BASE_character_boundaries.nt', true);
end;

procedure TTurtleTests.test_localName_with_assigned_nfc_PN_CHARS_BASE_character_boundaries();
begin
  parseTtl('localName_with_assigned_nfc_PN_CHARS_BASE_character_boundaries.ttl', false);
end;
// don't need to support property names with ':'

//procedure TTurtleTests.test_localname_with_COLONNT();
//begin
////     parseTtl('localname_with_COLON.nt', true);
//end;

//procedure TTurtleTests.test_localname_with_COLON();
//begin
////     parseTtl('localname_with_COLON.ttl', true);
//end;

procedure TTurtleTests.test_localName_with_leading_digitNT();
begin
  parseTtl('localName_with_leading_digit.nt', true);
end;

procedure TTurtleTests.test_localName_with_leading_digit();
begin
  parseTtl('localName_with_leading_digit.ttl', true);
end;

procedure TTurtleTests.test_localName_with_leading_underscoreNT();
begin
  parseTtl('localName_with_leading_underscore.nt', true);
end;

procedure TTurtleTests.test_localName_with_leading_underscore();
begin
  parseTtl('localName_with_leading_underscore.ttl', true);
end;

procedure TTurtleTests.test_localName_with_nfc_PN_CHARS_BASE_character_boundariesNT();
begin
  parseTtl('localName_with_nfc_PN_CHARS_BASE_character_boundaries.nt', true);
end;

procedure TTurtleTests.test_localName_with_nfc_PN_CHARS_BASE_character_boundaries();
begin
  parseTtl('localName_with_nfc_PN_CHARS_BASE_character_boundaries.ttl', false);
end;

procedure TTurtleTests.test_localName_with_non_leading_extrasNT();
begin
  parseTtl('localName_with_non_leading_extras.nt', true);
end;

procedure TTurtleTests.test_localName_with_non_leading_extras();
begin
  parseTtl('localName_with_non_leading_extras.ttl', true);
end;

procedure TTurtleTests.test_negative_numericNT();
begin
  parseTtl('negative_numeric.nt', true);
end;

procedure TTurtleTests.test_negative_numeric();
begin
  parseTtl('negative_numeric.ttl', true);
end;

procedure TTurtleTests.test_nested_blankNodePropertyListsNT();
begin
  parseTtl('nested_blankNodePropertyLists.nt', true);
end;

procedure TTurtleTests.test_nested_blankNodePropertyLists();
begin
  parseTtl('nested_blankNodePropertyLists.ttl', true);
end;

procedure TTurtleTests.test_nested_collectionNT();
begin
  parseTtl('nested_collection.nt', true);
end;

procedure TTurtleTests.test_nested_collection();
begin
  parseTtl('nested_collection.ttl', false);
end;

procedure TTurtleTests.test_number_sign_following_localNameNT();
begin
  parseTtl('number_sign_following_localName.nt', true);
end;

//procedure TTurtleTests.test_number_sign_following_localName();
//begin
////     parseTtl('number_sign_following_localName.ttl', true);
//end;

procedure TTurtleTests.test_number_sign_following_PNAME_NSNT();
begin
  parseTtl('number_sign_following_PNAME_NS.nt', true);
end;

//procedure TTurtleTests.test_number_sign_following_PNAME_NS();
//begin
////     parseTtl('number_sign_following_PNAME_NS.ttl', true);
//end;

procedure TTurtleTests.test_numeric_with_leading_0NT();
begin
  parseTtl('numeric_with_leading_0.nt', true);
end;

procedure TTurtleTests.test_numeric_with_leading_0();
begin
  parseTtl('numeric_with_leading_0.ttl', true);
end;

procedure TTurtleTests.test_objectList_with_two_objectsNT();
begin
  parseTtl('objectList_with_two_objects.nt', true);
end;

procedure TTurtleTests.test_objectList_with_two_objects();
begin
  parseTtl('objectList_with_two_objects.ttl', true);
end;

procedure TTurtleTests.test_old_style_base();
begin
  parseTtl('old_style_base.ttl', true);
end;

procedure TTurtleTests.test_old_style_prefix();
begin
  parseTtl('old_style_prefix.ttl', true);
end;

procedure TTurtleTests.test_percent_escaped_localNameNT();
begin
  parseTtl('percent_escaped_localName.nt', true);
end;

//procedure TTurtleTests.test_percent_escaped_localName();
//begin
////     parseTtl('percent_escaped_localName.ttl', true);
//end;

procedure TTurtleTests.test_positive_numericNT();
begin
  parseTtl('positive_numeric.nt', true);
end;

procedure TTurtleTests.test_positive_numeric();
begin
  parseTtl('positive_numeric.ttl', true);
end;

procedure TTurtleTests.test_predicateObjectList_with_two_objectListsNT();
begin
  parseTtl('predicateObjectList_with_two_objectLists.nt', true);
end;

procedure TTurtleTests.test_predicateObjectList_with_two_objectLists();
begin
  parseTtl('predicateObjectList_with_two_objectLists.ttl', true);
end;

//procedure TTurtleTests.test_prefix_only_IRI();
//begin
////     parseTtl('prefix_only_IRI.ttl', true);
//end;

procedure TTurtleTests.test_prefix_reassigned_and_usedNT();
begin
  parseTtl('prefix_reassigned_and_used.nt', true);
end;

procedure TTurtleTests.test_prefix_reassigned_and_used();
begin
  parseTtl('prefix_reassigned_and_used.ttl', true);
end;

procedure TTurtleTests.test_prefix_with_non_leading_extras();
begin
  parseTtl('prefix_with_non_leading_extras.ttl', true);
end;

procedure TTurtleTests.test_prefix_with_PN_CHARS_BASE_character_boundaries();
begin
  parseTtl('prefix_with_PN_CHARS_BASE_character_boundaries.ttl', true);
end;

procedure TTurtleTests.test_prefixed_IRI_object();
begin
  parseTtl('prefixed_IRI_object.ttl', true);
end;

procedure TTurtleTests.test_prefixed_IRI_predicate();
begin
  parseTtl('prefixed_IRI_predicate.ttl', true);
end;

procedure TTurtleTests.test_prefixed_name_datatype();
begin
  parseTtl('prefixed_name_datatype.ttl', true);
end;

procedure TTurtleTests.test_repeated_semis_at_end();
begin
  parseTtl('repeated_semis_at_end.ttl', true);
end;

procedure TTurtleTests.test_repeated_semis_not_at_endNT();
begin
  parseTtl('repeated_semis_not_at_end.nt', true);
end;

procedure TTurtleTests.test_repeated_semis_not_at_end();
begin
  parseTtl('repeated_semis_not_at_end.ttl', true);
end;

procedure TTurtleTests.test_reserved_escaped_localNameNT();
begin
  parseTtl('reserved_escaped_localName.nt', true);
end;

//procedure TTurtleTests.test_reserved_escaped_localName();
//begin
////     parseTtl('reserved_escaped_localName.ttl', true);
//end;

procedure TTurtleTests.test_sole_blankNodePropertyList();
begin
  parseTtl('sole_blankNodePropertyList.ttl', true);
end;

procedure TTurtleTests.test_SPARQL_style_base();
begin
  parseTtl('SPARQL_style_base.ttl', true);
end;

procedure TTurtleTests.test_SPARQL_style_prefix();
begin
  parseTtl('SPARQL_style_prefix.ttl', true);
end;

procedure TTurtleTests.test_turtle_eval_bad_01();
begin
  parseTtl('turtle-eval-bad-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_eval_bad_02();
begin
  parseTtl('turtle-eval-bad-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_eval_bad_03();
begin
  parseTtl('turtle-eval-bad-03.ttl', false);
end;

//procedure TTurtleTests.test_turtle_eval_bad_04();
//begin
////     parseTtl('turtle-eval-bad-04.ttl', false);
//end;

procedure TTurtleTests.test_turtle_eval_struct_01NT();
begin
  parseTtl('turtle-eval-struct-01.nt', true);
end;

procedure TTurtleTests.test_turtle_eval_struct_01();
begin
  parseTtl('turtle-eval-struct-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_eval_struct_02NT();
begin
  parseTtl('turtle-eval-struct-02.nt', true);
end;

procedure TTurtleTests.test_turtle_eval_struct_02();
begin
  parseTtl('turtle-eval-struct-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_01NT();
begin
  parseTtl('turtle-subm-01.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_01();
begin
  parseTtl('turtle-subm-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_02NT();
begin
  parseTtl('turtle-subm-02.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_02();
begin
  parseTtl('turtle-subm-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_03NT();
begin
  parseTtl('turtle-subm-03.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_03();
begin
  parseTtl('turtle-subm-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_subm_04NT();
begin
  parseTtl('turtle-subm-04.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_04();
begin
  parseTtl('turtle-subm-04.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_05NT();
begin
  parseTtl('turtle-subm-05.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_05();
begin
  parseTtl('turtle-subm-05.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_06NT();
begin
  parseTtl('turtle-subm-06.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_06();
begin
  parseTtl('turtle-subm-06.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_07NT();
begin
  parseTtl('turtle-subm-07.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_07();
begin
  parseTtl('turtle-subm-07.ttl', false);
end;

procedure TTurtleTests.test_NT();
begin
  parseTtl('turtle-subm-08.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_08();
begin
  parseTtl('turtle-subm-08.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_09NT();
begin
  parseTtl('turtle-subm-09.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_09();
begin
  parseTtl('turtle-subm-09.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_10NT();
begin
  parseTtl('turtle-subm-10.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_10();
begin
  parseTtl('turtle-subm-10.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_11NT();
begin
  parseTtl('turtle-subm-11.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_11();
begin
  parseTtl('turtle-subm-11.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_12NT();
begin
  parseTtl('turtle-subm-12.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_12();
begin
  parseTtl('turtle-subm-12.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_13NT();
begin
  parseTtl('turtle-subm-13.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_13();
begin
  parseTtl('turtle-subm-13.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_14NT();
begin
  parseTtl('turtle-subm-14.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_14();
begin
  parseTtl('turtle-subm-14.ttl', false);
end;

procedure TTurtleTests.test_turtle_subm_15NT();
begin
  parseTtl('turtle-subm-15.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_15();
begin
  parseTtl('turtle-subm-15.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_16NT();
begin
  parseTtl('turtle-subm-16.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_16();
begin
  parseTtl('turtle-subm-16.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_17NT();
begin
  parseTtl('turtle-subm-17.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_17();
begin
  parseTtl('turtle-subm-17.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_18NT();
begin
  parseTtl('turtle-subm-18.nt', false);
end;

procedure TTurtleTests.test_turtle_subm_18();
begin
  parseTtl('turtle-subm-18.ttl', false);
end;

procedure TTurtleTests.test_turtle_subm_19NT();
begin
  parseTtl('turtle-subm-19.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_19();
begin
  parseTtl('turtle-subm-19.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_20NT();
begin
  parseTtl('turtle-subm-20.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_20();
begin
  parseTtl('turtle-subm-20.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_21NT();
begin
  parseTtl('turtle-subm-21.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_21();
begin
  parseTtl('turtle-subm-21.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_22NT();
begin
  parseTtl('turtle-subm-22.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_22();
begin
  parseTtl('turtle-subm-22.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_23NT();
begin
  parseTtl('turtle-subm-23.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_23();
begin
  parseTtl('turtle-subm-23.ttl', false);
end;

procedure TTurtleTests.test_turtle_subm_24NT();
begin
  parseTtl('turtle-subm-24.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_24();
begin
  parseTtl('turtle-subm-24.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_25NT();
begin
  parseTtl('turtle-subm-25.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_25();
begin
  parseTtl('turtle-subm-25.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_26NT();
begin
  parseTtl('turtle-subm-26.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_26();
begin
  parseTtl('turtle-subm-26.ttl', true);
end;

procedure TTurtleTests.test_turtle_subm_27NT();
begin
  parseTtl('turtle-subm-27.nt', true);
end;

procedure TTurtleTests.test_turtle_subm_27();
begin
  parseTtl('turtle-subm-27.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_base_01();
begin
  parseTtl('turtle-syntax-bad-base-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_base_02();
begin
  parseTtl('turtle-syntax-bad-base-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_base_03();
begin
  parseTtl('turtle-syntax-bad-base-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_esc_01();
begin
  parseTtl('turtle-syntax-bad-esc-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_esc_02();
begin
  parseTtl('turtle-syntax-bad-esc-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_esc_03();
begin
  parseTtl('turtle-syntax-bad-esc-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_esc_04();
begin
  parseTtl('turtle-syntax-bad-esc-04.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_kw_01();
begin
  parseTtl('turtle-syntax-bad-kw-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_kw_02();
begin
  parseTtl('turtle-syntax-bad-kw-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_kw_03();
begin
  parseTtl('turtle-syntax-bad-kw-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_kw_04();
begin
  parseTtl('turtle-syntax-bad-kw-04.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_kw_05();
begin
  parseTtl('turtle-syntax-bad-kw-05.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_lang_01();
begin
  parseTtl('turtle-syntax-bad-lang-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_LITERAL2_with_langtag_and_datatype();
begin
  parseTtl('turtle-syntax-bad-LITERAL2_with_langtag_and_datatype.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_ln_dash_start();
begin
  parseTtl('turtle-syntax-bad-ln-dash-start.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bad_ln_escape();
begin
  parseTtl('turtle-syntax-bad-ln-escape.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_ln_escape_start();
begin
  parseTtl('turtle-syntax-bad-ln-escape-start.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_missing_ns_dot_end();
begin
  parseTtl('turtle-syntax-bad-missing-ns-dot-end.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_missing_ns_dot_start();
begin
  parseTtl('turtle-syntax-bad-missing-ns-dot-start.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_01();
begin
  parseTtl('turtle-syntax-bad-n3-extras-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_02();
begin
  parseTtl('turtle-syntax-bad-n3-extras-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_03();
begin
  parseTtl('turtle-syntax-bad-n3-extras-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_04();
begin
  parseTtl('turtle-syntax-bad-n3-extras-04.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_05();
begin
  parseTtl('turtle-syntax-bad-n3-extras-05.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_07();
begin
  parseTtl('turtle-syntax-bad-n3-extras-07.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_08();
begin
  parseTtl('turtle-syntax-bad-n3-extras-08.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_09();
begin
  parseTtl('turtle-syntax-bad-n3-extras-09.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_10();
begin
  parseTtl('turtle-syntax-bad-n3-extras-10.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_11();
begin
  parseTtl('turtle-syntax-bad-n3-extras-11.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_12();
begin
  parseTtl('turtle-syntax-bad-n3-extras-12.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_n3_extras_13();
begin
  parseTtl('turtle-syntax-bad-n3-extras-13.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_ns_dot_end();
begin
  parseTtl('turtle-syntax-bad-ns-dot-end.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bad_ns_dot_start();
begin
  parseTtl('turtle-syntax-bad-ns-dot-start.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_num_01();
begin
  parseTtl('turtle-syntax-bad-num-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_num_02();
begin
  parseTtl('turtle-syntax-bad-num-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_num_03();
begin
  parseTtl('turtle-syntax-bad-num-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_num_04();
begin
  parseTtl('turtle-syntax-bad-num-04.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_num_05();
begin
  parseTtl('turtle-syntax-bad-num-05.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_number_dot_in_anon();
begin
  parseTtl('turtle-syntax-bad-number-dot-in-anon.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bad_pname_01();
begin
  parseTtl('turtle-syntax-bad-pname-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_pname_02();
begin
  parseTtl('turtle-syntax-bad-pname-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_prefix_01();
begin
  parseTtl('turtle-syntax-bad-prefix-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_prefix_02();
begin
  parseTtl('turtle-syntax-bad-prefix-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_prefix_03();
begin
  parseTtl('turtle-syntax-bad-prefix-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_prefix_04();
begin
  parseTtl('turtle-syntax-bad-prefix-04.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_prefix_05();
begin
  parseTtl('turtle-syntax-bad-prefix-05.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_string_01();
begin
  parseTtl('turtle-syntax-bad-string-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_string_02();
begin
  parseTtl('turtle-syntax-bad-string-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_string_03();
begin
  parseTtl('turtle-syntax-bad-string-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_string_04();
begin
  parseTtl('turtle-syntax-bad-string-04.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_string_05();
begin
  parseTtl('turtle-syntax-bad-string-05.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_string_06();
begin
  parseTtl('turtle-syntax-bad-string-06.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_string_07();
begin
  parseTtl('turtle-syntax-bad-string-07.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_01();
begin
  parseTtl('turtle-syntax-bad-struct-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_02();
begin
  parseTtl('turtle-syntax-bad-struct-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_03();
begin
  parseTtl('turtle-syntax-bad-struct-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_04();
begin
  parseTtl('turtle-syntax-bad-struct-04.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_05();
begin
  parseTtl('turtle-syntax-bad-struct-05.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_06();
begin
  parseTtl('turtle-syntax-bad-struct-06.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_07();
begin
  parseTtl('turtle-syntax-bad-struct-07.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_08();
begin
  parseTtl('turtle-syntax-bad-struct-08.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_09();
begin
  parseTtl('turtle-syntax-bad-struct-09.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_10();
begin
  parseTtl('turtle-syntax-bad-struct-10.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_11();
begin
  parseTtl('turtle-syntax-bad-struct-11.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_12();
begin
  parseTtl('turtle-syntax-bad-struct-12.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_13();
begin
  parseTtl('turtle-syntax-bad-struct-13.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_14();
begin
  parseTtl('turtle-syntax-bad-struct-14.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_15();
begin
  parseTtl('turtle-syntax-bad-struct-15.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_16();
begin
  parseTtl('turtle-syntax-bad-struct-16.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_struct_17();
begin
  parseTtl('turtle-syntax-bad-struct-17.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bad_uri_02();
begin
  parseTtl('turtle-syntax-bad-uri-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_bad_uri_03();
begin
  parseTtl('turtle-syntax-bad-uri-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_base_01();
begin
  parseTtl('turtle-syntax-base-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_base_02();
begin
  parseTtl('turtle-syntax-base-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_base_03();
begin
  parseTtl('turtle-syntax-base-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_base_04();
begin
  parseTtl('turtle-syntax-base-04.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_blank_label();
begin
  parseTtl('turtle-syntax-blank-label.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_01();
begin
  parseTtl('turtle-syntax-bnode-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_02();
begin
  parseTtl('turtle-syntax-bnode-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_03();
begin
  parseTtl('turtle-syntax-bnode-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_04();
begin
  parseTtl('turtle-syntax-bnode-04.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_05();
begin
  parseTtl('turtle-syntax-bnode-05.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_06();
begin
  parseTtl('turtle-syntax-bnode-06.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_07();
begin
  parseTtl('turtle-syntax-bnode-07.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_08();
begin
  parseTtl('turtle-syntax-bnode-08.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_09();
begin
  parseTtl('turtle-syntax-bnode-09.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_bnode_10();
begin
  parseTtl('turtle-syntax-bnode-10.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_datatypes_01();
begin
  parseTtl('turtle-syntax-datatypes-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_datatypes_02();
begin
  parseTtl('turtle-syntax-datatypes-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_file_01();
begin
  parseTtl('turtle-syntax-file-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_file_02();
begin
  parseTtl('turtle-syntax-file-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_file_03();
begin
  parseTtl('turtle-syntax-file-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_kw_01();
begin
  parseTtl('turtle-syntax-kw-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_kw_02();
begin
  parseTtl('turtle-syntax-kw-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_kw_03();
begin
  parseTtl('turtle-syntax-kw-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_lists_01();
begin
  parseTtl('turtle-syntax-lists-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_lists_02();
begin
  parseTtl('turtle-syntax-lists-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_ln_dots();
begin
  parseTtl('turtle-syntax-ln-dots.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_ns_dots();
begin
  parseTtl('turtle-syntax-ns-dots.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_01();
begin
  parseTtl('turtle-syntax-number-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_02();
begin
  parseTtl('turtle-syntax-number-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_03();
begin
  parseTtl('turtle-syntax-number-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_04();
begin
  parseTtl('turtle-syntax-number-04.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_06();
begin
  parseTtl('turtle-syntax-number-06.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_07();
begin
  parseTtl('turtle-syntax-number-07.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_09();
begin
  parseTtl('turtle-syntax-number-09.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_10();
begin
  parseTtl('turtle-syntax-number-10.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_number_11();
begin
  parseTtl('turtle-syntax-number-11.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_pname_esc_01();
begin
  parseTtl('turtle-syntax-pname-esc-01.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_pname_esc_02();
begin
  parseTtl('turtle-syntax-pname-esc-02.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_pname_esc_03();
begin
  parseTtl('turtle-syntax-pname-esc-03.ttl', false);
end;

procedure TTurtleTests.test_turtle_syntax_prefix_01();
begin
  parseTtl('turtle-syntax-prefix-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_prefix_03();
begin
  parseTtl('turtle-syntax-prefix-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_prefix_04();
begin
  parseTtl('turtle-syntax-prefix-04.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_prefix_07();
begin
  parseTtl('turtle-syntax-prefix-07.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_prefix_08();
begin
  parseTtl('turtle-syntax-prefix-08.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_prefix_09();
begin
  parseTtl('turtle-syntax-prefix-09.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_str_esc_01();
begin
  parseTtl('turtle-syntax-str-esc-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_str_esc_02();
begin
  parseTtl('turtle-syntax-str-esc-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_str_esc_03();
begin
  parseTtl('turtle-syntax-str-esc-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_01();
begin
  parseTtl('turtle-syntax-string-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_02();
begin
  parseTtl('turtle-syntax-string-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_03();
begin
  parseTtl('turtle-syntax-string-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_04();
begin
  parseTtl('turtle-syntax-string-04.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_05();
begin
  parseTtl('turtle-syntax-string-05.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_06();
begin
  parseTtl('turtle-syntax-string-06.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_07();
begin
  parseTtl('turtle-syntax-string-07.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_08();
begin
  parseTtl('turtle-syntax-string-08.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_09();
begin
  parseTtl('turtle-syntax-string-09.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_10();
begin
  parseTtl('turtle-syntax-string-10.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_string_11();
begin
  parseTtl('turtle-syntax-string-11.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_struct_01();
begin
  parseTtl('turtle-syntax-struct-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_struct_02();
begin
  parseTtl('turtle-syntax-struct-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_struct_03();
begin
  parseTtl('turtle-syntax-struct-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_struct_04();
begin
  parseTtl('turtle-syntax-struct-04.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_struct_05();
begin
  parseTtl('turtle-syntax-struct-05.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_uri_01();
begin
  parseTtl('turtle-syntax-uri-01.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_uri_02();
begin
  parseTtl('turtle-syntax-uri-02.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_uri_03();
begin
  parseTtl('turtle-syntax-uri-03.ttl', true);
end;

procedure TTurtleTests.test_turtle_syntax_uri_04();
begin
  parseTtl('turtle-syntax-uri-04.ttl', true);
end;

procedure TTurtleTests.test_two_LITERAL_LONG2sNT();
begin
  parseTtl('two_LITERAL_LONG2s.nt', true);
end;

procedure TTurtleTests.test_two_LITERAL_LONG2s();
begin
  parseTtl('two_LITERAL_LONG2s.ttl', true);
end;

procedure TTurtleTests.test_underscore_in_localNameNT();
begin
  parseTtl('underscore_in_localName.nt', true);
end;

procedure TTurtleTests.test_underscore_in_localName();
begin
  parseTtl('underscore_in_localName.ttl', true);
end;

procedure TTurtleTests.test_anonymous_blank_node_object();
begin
  parseTtl('anonymous_blank_node_object.ttl', true);
end;

procedure TTurtleTests.test_anonymous_blank_node_subject();
begin
  parseTtl('anonymous_blank_node_subject.ttl', true);
end;

procedure TTurtleTests.test_bareword_a_predicateNT();
begin
  parseTtl('bareword_a_predicate.nt', true);
end;

procedure TTurtleTests.test_bareword_a_predicate();
begin
  parseTtl('bareword_a_predicate.ttl', true);
end;

procedure TTurtleTests.test_bareword_decimalNT();
begin
  parseTtl('bareword_decimal.nt', true);
end;

procedure TTurtleTests.test_bareword_decimal();
begin
  parseTtl('bareword_decimal.ttl', true);
end;

procedure TTurtleTests.test_bareword_doubleNT();
begin
  parseTtl('bareword_double.nt', true);
end;

procedure TTurtleTests.test_bareword_double();
begin
  parseTtl('bareword_double.ttl', true);
end;

procedure TTurtleTests.test_bareword_integer();
begin
  parseTtl('bareword_integer.ttl', true);
end;

procedure TTurtleTests.test_blankNodePropertyList_as_objectNT();
begin
  parseTtl('blankNodePropertyList_as_object.nt', true);
end;

procedure TTurtleTests.test_blankNodePropertyList_as_object();
begin
  parseTtl('blankNodePropertyList_as_object.ttl', true);
end;

procedure TTurtleTests.test_blankNodePropertyList_as_subjectNT();
begin
  parseTtl('blankNodePropertyList_as_subject.nt', true);
end;

procedure TTurtleTests.test_blankNodePropertyList_containing_collectionNT();
begin
  parseTtl('blankNodePropertyList_containing_collection.nt', true);
end;

procedure TTurtleTests.test_blankNodePropertyList_containing_collection();
begin
  parseTtl('blankNodePropertyList_containing_collection.ttl', true);
end;

procedure TTurtleTests.test_blankNodePropertyList_with_multiple_triplesNT();
begin
  parseTtl('blankNodePropertyList_with_multiple_triples.nt', true);
end;

procedure TTurtleTests.test_blankNodePropertyList_with_multiple_triples();
begin
  parseTtl('blankNodePropertyList_with_multiple_triples.ttl', true);
end;

procedure TTurtleTests.test_collection_objectNT();
begin
  parseTtl('collection_object.nt', true);
end;

procedure TTurtleTests.test_collection_object();
begin
  parseTtl('collection_object.ttl', true);
end;

procedure TTurtleTests.test_collection_subjectNT();
begin
  parseTtl('collection_subject.nt', true);
end;

procedure TTurtleTests.test_collection_subject();
begin
  parseTtl('collection_subject.ttl', false);
end;

procedure TTurtleTests.test_comment_following_localName();
begin
  parseTtl('comment_following_localName.ttl', true);
end;

procedure TTurtleTests.test_comment_following_PNAME_NSNT();
begin
  parseTtl('comment_following_PNAME_NS.nt', true);
end;

procedure TTurtleTests.test_comment_following_PNAME_NS();
begin
  parseTtl('comment_following_PNAME_NS.ttl', false);
end;

procedure TTurtleTests.test__default_namespace_IRI();
begin
  parseTtl('default_namespace_IRI.ttl', true);
end;
//

var
  globalInt : cardinal;
  cs : TRTLCriticalSection;
  kcs : TFslLock;
  sem : TSemaphore;

Const
  TEST_FILE_CONTENT : AnsiString = 'this is some test content'+#13#10;

procedure TOSXTests.test60sec;
begin
  TFslDateTime.make(EncodeDate(2013, 4, 5) + EncodeTime(12, 34, 60, 0), dttzUnknown).toHL7
end;

procedure TOSXTests.TestFslFile;
var
  filename : String;
  f : TFslFile;
  s : AnsiString;
begin
  filename := Path([SystemTemp, 'delphi.file.test.txt']);
  if FileExists(filename) then
  begin
    FileSetReadOnly(filename, false);
    FileDelete(filename);
  end;
  assertFalse(FileExists(filename));
  f := TFslFile.Create(filename, fmCreate);
  try
    f.Write(TEST_FILE_CONTENT[1], length(TEST_FILE_CONTENT));
  finally
    f.Free;
  end;
  assertTrue(FileExists(filename));
  assertTrue(FileSize(filename) = 27);
  f := TFslFile.Create(filename, fmOpenRead);
  try
    SetLength(s, f.Size);
    f.Read(s[1], f.Size);
    assertTrue(s = TEST_FILE_CONTENT);
  finally
    f.Free;
  end;
  FileSetReadOnly(filename, true);
  FileDelete(filename);
  assertTrue(FileExists(filename));
  FileSetReadOnly(filename, false);
  FileDelete(filename);
  assertFalse(FileExists(filename));
end;

procedure TOSXTests.TestAdvObject;
var
  obj : TFslObject;
begin
  obj := TFslObject.Create;
  try
    assertTrue(obj.FslObjectReferenceCount = 0);
    obj.Link;
    assertTrue(obj.FslObjectReferenceCount = 1);
    obj.Free;
    assertTrue(obj.FslObjectReferenceCount = 0);
  finally
    obj.Free;
  end;
end;

procedure TOSXTests.TestCriticalSectionSimple;
begin
  InitializeCriticalSection(cs);
  try
    EnterCriticalSection(cs);
    try
      assertTrue(true);
    finally
      LeaveCriticalSection(cs);
    end;
  finally
    DeleteCriticalSection(cs);
  end;
end;

procedure TOSXTests.TestKCriticalSectionSimple;
begin
  kcs := TFslLock.Create('test');
  try
    kcs.Enter;
    try
      assertTrue(true);
    finally
      kcs.Leave;
    end;
  finally
    kcs.Free;
  end;
end;

type
  TTestCriticalSectionThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TTestKCriticalSectionThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TTestSemaphoreThread = class(TThread)
  protected
    procedure Execute; override;
  end;

procedure TOSXTests.TestCriticalSectionThreaded;
begin
  globalInt := GetCurrentThreadId;
  InitializeCriticalSection(cs);
  try
    EnterCriticalSection(cs);
    try
      TTestCriticalSectionThread.create(false);
      Sleep(10);
      assertTrue(globalInt = GetCurrentThreadId);
    finally
      LeaveCriticalSection(cs);
    end;
    sleep(10);
    EnterCriticalSection(cs);
    try
      assertTrue(globalInt <> GetCurrentThreadId);
    finally
      LeaveCriticalSection(cs);
    end;
  finally
    DeleteCriticalSection(cs);
  end;
end;

procedure TOSXTests.TestKCriticalSectionThreaded;
begin
  globalInt := GetCurrentThreadId;
  kcs := TFslLock.Create('none');
  try
    kcs.Enter;
    try
      TTestKCriticalSectionThread.create(false);
      Sleep(10);
      assertTrue(globalInt = GetCurrentThreadId);
    finally
      kcs.Leave;
    end;
    sleep(10);
    kcs.Enter;
    try
      assertTrue(globalInt <> GetCurrentThreadId);
    finally
      kcs.Leave;
    end;
  finally
    kcs.free;
  end;
end;

procedure TOSXTests.TestRemoveAccents;
begin
  assertEqual('Grahame Grieve', RemoveAccents('Grahame Grieve'));
  assertEqual('aaeeiiooouuu AAEEIIOOOUUU', RemoveAccents('aáeéiíoóöuúü AÁEÉIÍOÓÖUÚÜ'));
  assertEqual('Ваnерии Никоnаевич СЕРГЕЕВ', RemoveAccents('Валерий Николаевич СЕРГЕЕВ'));
end;

procedure TOSXTests.TestTemp;
begin
  assertTrue(SystemTemp <> '');
end;

procedure TOSXTests.TestFslDateTime;
var
  d1, d2 : TFslDateTime;
  dt1, dt2 : Double;
begin
  // null
  assertTrue(d1.null);
  assertFalse(d1.notNull);
  d1 := TFslDateTime.makeToday;
  assertTrue(d1.notNull);
  assertFalse(d1.null);
  d1 := TFslDateTime.makeNull;
  assertTrue(d1.null);
  assertFalse(d1.notNull);

  // format support
  assertTrue(TFslDateTime.fromXML('2013-04-05T12:34:56').toHL7 = '20130405123456');
  assertTrue(TFslDateTime.fromXML('2013-04-05T12:34:56Z').toHL7 = '20130405123456Z');
  assertTrue(TFslDateTime.fromXML('2013-04-05T12:34:56+10:00').toHL7 = '20130405123456+1000');
  assertTrue(TFslDateTime.fromXML('2013-04-05T12:34:56-10:00').toHL7 = '20130405123456-1000');
  assertTrue(TFslDateTime.fromXML('2013-04-05').toHL7 = '20130405');
  assertTrue(TFslDateTime.fromHL7('20130405123456-1000').toXML = '2013-04-05T12:34:56-10:00');

  // Date Time conversion
  assertTrue(TFslDateTime.make(EncodeDate(2013, 4, 5) + EncodeTime(12, 34,56, 0), dttzUnknown).toHL7 = '20130405123456.000');
  assertWillRaise(test60Sec, EConvertError, '');
  dt1 := EncodeDate(2013, 4, 5) + EncodeTime(12, 34,56, 0);
  dt2 := TFslDateTime.fromHL7('20130405123456').DateTime;
  assertTrue(dt1 = dt2);

  // comparison
  d1 := TFslDateTime.make(EncodeDate(2011, 2, 2)+ EncodeTime(14, 0, 0, 0), dttzLocal);
  d2 := TFslDateTime.make(EncodeDate(2011, 2, 2)+ EncodeTime(15, 0, 0, 0), dttzLocal);
  assertTrue(d2.after(d1, false));
  assertFalse(d1.after(d1, false));
  assertTrue(d1.after(d1, true));
  assertFalse(d2.before(d1, false));
  assertFalse(d1.before(d1, false));
  assertTrue(d1.before(d1, true));
  assertFalse(d1.after(d2, false));
  assertTrue(d1.before(d2, false));
  assertTrue(d1.compare(d2) = -1);
  assertTrue(d2.compare(d1) = 1);
  assertTrue(d1.compare(d1) = 0);

  // Timezone Wrangling
  d1 := TFslDateTime.make(EncodeDate(2011, 2, 2)+ EncodeTime(14, 0, 0, 0), dttzLocal); // during daylight savings (+11)
  d2 := TFslDateTime.make(EncodeDate(2011, 2, 2)+ EncodeTime(3, 0, 0, 0), dttzUTC); // UTC Time
  assertTrue(sameInstant(d1.DateTime - TimezoneBias(EncodeDate(2011, 2, 2)), d2.DateTime));
  assertTrue(sameInstant(d1.UTC.DateTime, d2.DateTime));
  assertTrue(not d1.equal(d2));
  assertTrue(d1.sameTime(d2));
  d1 := TFslDateTime.make(EncodeDate(2011, 7, 2)+ EncodeTime(14, 0, 0, 0), dttzLocal); // not during daylight savings (+10)
  d2 := TFslDateTime.make(EncodeDate(2011, 7, 2)+ EncodeTime(4, 0, 0, 0), dttzUTC); // UTC Time
  dt1 := d1.DateTime - TimezoneBias(EncodeDate(2011, 7, 2));
  dt2 := d2.DateTime;
  assertTrue(sameInstant(dt1, dt2));
  assertTrue(sameInstant(d1.UTC.DateTime, d2.DateTime));
  assertTrue(not d1.equal(d2));
  assertTrue(d1.sameTime(d2));
  assertTrue(TFslDateTime.fromHL7('20130405120000+1000').sameTime(TFslDateTime.fromHL7('20130405100000+0800')));
  assertTrue(TFslDateTime.fromXML('2017-11-05T05:30:00.0Z').sameTime(TFslDateTime.fromXML('2017-11-05T05:30:00.0Z')));
  assertTrue(TFslDateTime.fromXML('2017-11-05T09:30:00.0+04:00').sameTime(TFslDateTime.fromXML('2017-11-05T05:30:00.0Z')));
  assertTrue(TFslDateTime.fromXML('2017-11-05T01:30:00.0-04:00').sameTime(TFslDateTime.fromXML('2017-11-05T05:30:00.0Z')));
  assertTrue(TFslDateTime.fromXML('2017-11-05T09:30:00.0+04:00').sameTime(TFslDateTime.fromXML('2017-11-05T01:30:00.0-04:00')));

  // Min/Max
  assertTrue(TFslDateTime.fromHL7('20130405123456').Min.toHL7 = '20130405123456.000');
  assertTrue(TFslDateTime.fromHL7('20130405123456').Max.toHL7 = '20130405123457.000');
  assertTrue(TFslDateTime.fromHL7('201304051234').Min.toHL7 = '20130405123400.000');
  assertTrue(TFslDateTime.fromHL7('201304051234').Max.toHL7 = '20130405123500.000');

  assertTrue(TFslDateTime.fromHL7('201301010000').before(TFslDateTime.fromHL7('201301010000'), true));
  assertTrue(not TFslDateTime.fromHL7('201301010000').before(TFslDateTime.fromHL7('201301010000'), false));
  assertTrue(TFslDateTime.fromHL7('201301010000').before(TFslDateTime.fromHL7('201301010001'), true));
  assertTrue(not TFslDateTime.fromHL7('201301010001').before(TFslDateTime.fromHL7('201301010000'), true));
  //
//  d1 := UniversalDateTime;
//  d2 := LocalDateTime;
//  d3 := TimeZoneBias;
//  assertTrue(d1 <> d2);
//  assertTrue(d1 = d2 - d3);
end;

{ TTestCriticalSectionThread }

procedure TTestCriticalSectionThread.execute;
begin
  EnterCriticalSection(cs);
  try
    globalInt := GetCurrentThreadId;
  finally
    LeaveCriticalSection(cs);
  end;
end;

procedure TOSXTests.TestSemaphore;
var
  thread : TTestSemaphoreThread;
begin
  globalInt := 0;
  sem := TSemaphore.Create(nil, 0, 1, '');
  try
    thread := TTestSemaphoreThread.Create(false);
    try
    writeln('start');
      thread.FreeOnTerminate := true;
      while (globalInt = 0) do
        sleep(100);
      assertTrue(globalInt = 1, '1');
      writeln('release');
      sem.Release;
      sleep(500);
      assertTrue(globalInt = 2, '2');
      writeln('release');
      sem.Release;
      sleep(500);
      assertTrue(globalInt = 3, '3');
      sleep(500);
      assertTrue(globalInt = 3, '4');
    finally
      writeln('terminate');
      thread.Terminate;
      sem.release;
    end;
    sleep(500);
    writeln('check');
    assertTrue(globalInt = 100, '100');
  finally
    sem.Free;
  end;
end;

{ TTestSemaphoreThread }

procedure TTestSemaphoreThread.execute;
begin
  inc(globalInt);
  while not Terminated do
  begin
    writeln('wait');
    case sem.WaitFor(10000) of
      wrSignaled:
        begin
          writeln('inc global int');
          inc(globalInt);
        end;
      wrTimeout:
        begin
          writeln('timeout');
          raise exception.create('timeout');
        end;
      wrAbandoned :
        begin
          writeln('abandoned');
          raise exception.create('abandoned');
        end;
      wrError :
        begin
          writeln('error');
          raise exception.create('error');
        end;
    end;
  end;
  globalInt := 100;
end;

{ TTestKCriticalSectionThread }

procedure TTestKCriticalSectionThread.Execute;
begin
  kcs.Enter;
  try
    globalInt := GetCurrentThreadId;
  finally
    kcs.Leave;
  end;
end;

var
  gs : String;

{ TJWTTests }

procedure TJWTTests.Setup;
begin
  IdSSLOpenSSLHeaders.Load;
  LoadEAYExtensions(true);
end;

procedure TJWTTests.TestCert;
var
  jwk : TJWK;
  s: String;
begin
  jwk := TJWTUtils.loadKeyFromRSACert('C:\work\fhirserver\Exec\jwt-test.key.crt');
  try
    s := TJSONWriter.writeObjectStr(jwk.obj, true);
    Writeln(s);
    assertTrue(true);
  finally
    jwk.Free;
  end;
end;

procedure TJWTTests.TestPacking;
var
  jwk : TJWK;
  s : String;
  jwt : TJWT;
begin
  jwk := TJWK.create(TJSONParser.Parse('{"kty": "oct", "k": "AyM1SysPpbyDfgZld3umj1qzKObwVMkoqQ-EstJQLr_T-1qS0gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr1Z9CAow"}'));
  try
    // this test is from the spec
    s := TJWTUtils.pack(
      '{"typ":"JWT",'+#13#10+' "alg":"HS256"}',
      '{"iss":"joe",'+#13#10+' "exp":1300819380,'+#13#10+' "http://example.com/is_root":true}',
      jwt_hmac_sha256, jwk);
    assertTrue(s = 'eyJ0eXAiOiJKV1QiLA0KICJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlfQ.dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk',
      'packing failed. expected '+#13#10+'eyJ0eXAiOiJKV1QiLA0KICJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlfQ.dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk, but got '+s);
  finally
    jwk.Free;
  end;

  jwk := TJWK.create(TJSONParser.Parse(
     '{"kty":"RSA", '+#13#10+
     '  "kid": "http://tools.ietf.org/html/draft-ietf-jose-json-web-signature-26#appendix-A.2.1", '+#13#10+
     '  "n":"ofgWCuLjybRlzo0tZWJjNiuSfb4p4fAkd_wWJcyQoTbji9k0l8W26mPddxHmfHQp-Vaw-4qPCJrcS2mJPMEzP1Pt0Bm4d4QlL-yRT-SFd2lZS-pCgNMsD1W_YpRPEwOWvG6b32690r2jZ47soMZo9wGzjb_7OMg0LOL-bSf63kpaSHSXndS5z5rexMdb'+'BYUsLA9e-KXBdQOS-UTo7WTBEMa2R2CapHg665xsmtdVMTBQY4uDZlxvb3qCo5ZwKh9kG4LT6_I5IhlJH7aGhyxXFvUK-DWNmoudF8NAco9_h9iaGNj8q2ethFkMLs91kzk2PAcDTW9gb54h4FRWyuXpoQ", '+#13#10+
     '  "e":"AQAB", '+#13#10+
     '  "d":"Eq5xpGnNCivDflJsRQBXHx1hdR1k6Ulwe2JZD50LpXyWPEAeP88vLNO97IjlA7_GQ5sLKMgvfTeXZx9SE-7YwVol2NXOoAJe46sui395IW_GO-pWJ1O0BkTGoVEn2bKVRUCgu-GjBVaYLU6f3l9kJfFNS3E0QbVdxzubSu3Mkqzjkn439X0M_V51gfpR'+'LI9JYanrC4D4qAdGcopV_0ZHHzQlBjudU2QvXt4ehNYTCBr6XCLQUShb1juUO1ZdiYoFaFQT5Tw8bGUl_x_jTj3ccPDVZFD9pIuhLhBOneufuBiB4cS98l2SR_RQyGWSeWjnczT0QU91p1DhOVRuOopznQ" '+#13#10+
     ' } '+#13#10
   ));
  try
    gs := TJWTUtils.pack(
      '{"alg":"RS256"}',
      '{"iss":"joe",'+#13#10+' "exp":1300819380,'+#13#10+' "http://example.com/is_root":true}',
      jwt_hmac_rsa256, jwk);
  finally
    jwk.Free;
  end;

  jwt := TJWT.create;
  try
    jwt.id := GUIDToString(CreateGUID);
    s := TJWTUtils.rsa_pack(jwt, jwt_hmac_rsa256, 'C:\work\fhirserver\Exec\jwt-test.key.key', 'fhirserver');
    assertTrue(true);
  finally
    jwt.Free;
  end;
end;

var
  jwk : TJWKList;

procedure TJWTTests.TestUnpacking;
var
  jwt : TJWT;
begin
  // HS256 test from the spec
  jwk := TJWKList.create(TJSONParser.Parse('{"kty": "oct", "k": "AyM1SysPpbyDfgZld3umj1qzKObwVMkoqQ-EstJQLr_T-1qS0gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr1Z9CAow"}'));
  try
    jwt := TJWTUtils.unpack('eyJ0eXAiOiJKV1QiLA0KICJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlfQ.dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk', true, jwk);
    try
      // inspect
      assertTrue(true);
    finally
      jwt.Free;
    end;
  finally
    jwk.Free;
  end;
   (*
  // from google
  jwk := TJWKList.create(TJSONParser.Parse(
    // as downloaded from google at the same time as the JWT below
    '{'+#13#10+
    ' "keys": ['+#13#10+
    '  {'+#13#10+
    '   "kty": "RSA",'+#13#10+
    '   "alg": "RS256",'+#13#10+
    '   "use": "sig",'+#13#10+
    '   "kid": "024806d09e6067ca21bc6e25219d15dd981ddf9d",'+#13#10+
    '   "n": "AKGBohjSehyKnx7t5HZGzLtNaFpbNBiCf9O6G/qUeOy8l7XBflg/79G+t23eP77dJ+iCPEoLU1R/3NKPAk6Y6hKbSIvuzLY+B877ozutOn/6H/DNWumVZKnkSpDa7A5nsCNSm63b7uJ4XO5W0NtueiXj855h8j+WLi9vP8UwXhmL",'+#13#10+
    '   "e": "AQAB"'+#13#10+
    '  },'+#13#10+
    '  {'+#13#10+
    '   "kty": "RSA",'+#13#10+
    '   "alg": "RS256",'+#13#10+
    '   "use": "sig",'+#13#10+
    '   "kid": "8140c5f1c9d0c738c1b6328528f7ab1f672f5ba0",'+#13#10+
    '   "n": "AMAxJozHjwYxXqcimf93scqnDKZrKm1O4+TSH4eTJyjM1NU1DnhRJ8xL8fJd/rZwBWgPCUNi34pYlLWwfzR/17diqPgGSMt+mBVKXo5HD7+9SfQPjH3Fw810BQpxslBuAPsSGaNcLvHPpUSJDB/NH2rTxw6YtQ/R3neo7Amcfn/d",'+#13#10+
    '   "e": "AQAB"'+#13#10+
    '  }'+#13#10+
    ' ]'+#13#10+
    '}'+#13#10
  ));
  try
    jwt := TJWTUtils.unpack('eyJhbGciOiJSUzI1NiIsImtpZCI6IjAyNDgwNmQwOWU2MDY3Y2EyMWJjNmUyNTIxOWQxNWRkOTgxZGRmOWQifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwic3ViIjoiMTExOTA0NjIwMDUzMzY0MzkyMjg2Ii'+'wiYXpwIjoiOTQwMDA2MzEwMTM4LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiZW1haWwiOiJncmFoYW1lZ0BnbWFpbC5jb20iLCJhdF9oYXNoIjoidDg0MGJMS3FsRU'+'ZqUmQwLWlJS2dZUSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdWQiOiI5NDAwMDYzMTAxMzguYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJpYXQiOjE0MDIxODUxMjksImV'+'4cCI6MTQwMjE4OTAyOX0.Jybn06gURs7lcpCYaXBuszC7vacnWxwSwH_ffIDDu7bxOPo9fiVnRDCidKSLy4m0sAL1xxDHA5gXSZ9C6nj7abGqQ_LOrcPdTncuvYUPhF7mUq7fr3EPW-34PVkBSiOrjYdO6SOYyeP443WzPQRkhVJkRP4oQF-k0zXuwCkWlfc', true, jwk);
    try
      // inspect
      assertTrue(true);
    finally
      jwt.Free;
    end;
  finally
    jwk.free;
  end;

  // RS256 test from the spec (except the value is from above, because the sig doesn't match)
  jwk := TJWKList.create(TJSONParser.Parse(
     '{"kty":"RSA", '+#13#10+
     '  "kid": "http://tools.ietf.org/html/draft-ietf-jose-json-web-signature-26#appendix-A.2.1", '+#13#10+
     '  "n":"ofgWCuLjybRlzo0tZWJjNiuSfb4p4fAkd_wWJcyQoTbji9k0l8W26mPddxHmfHQp-Vaw-4qPCJrcS2mJPMEzP1Pt0Bm4d4QlL-yRT-SFd2lZS-pCgNMsD1W_YpRPEwOWvG6b32690r2jZ47soMZo9wGzjb_7OMg0LOL-bSf63kpaSHSXndS5z5rexMdbBYUsLA9e-KXBdQOS-UTo7WTBEMa2R2CapHg66'+'5xsmtdVMTBQY4uDZlxvb3qCo5ZwKh9kG4LT6_I5IhlJH7aGhyxXFvUK-DWNmoudF8NAco9_h9iaGNj8q2ethFkMLs91kzk2PAcDTW9gb54h4FRWyuXpoQ", '+#13#10+
     '  "e":"AQAB", '+#13#10+
     '  "d":"Eq5xpGnNCivDflJsRQBXHx1hdR1k6Ulwe2JZD50LpXyWPEAeP88vLNO97IjlA7_GQ5sLKMgvfTeXZx9SE-7YwVol2NXOoAJe46sui395IW_GO-pWJ1O0BkTGoVEn2bKVRUCgu-GjBVaYLU6f3l9kJfFNS3E0QbVdxzubSu3Mkqzjkn439X0M_V51gfpRLI9JYanrC4D4qAdGcopV_0ZHHzQlBjudU2QvX'+'t4ehNYTCBr6XCLQUShb1juUO1ZdiYoFaFQT5Tw8bGUl_x_jTj3ccPDVZFD9pIuhLhBOneufuBiB4cS98l2SR_RQyGWSeWjnczT0QU91p1DhOVRuOopznQ" '+#13#10+
     ' } '+#13#10
   ));
  try
    jwt := TJWTUtils.unpack(gs {'eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlfQ.LteI-Jtns1KTLm0-lnDU_gI8_QHDnnIfZCEB2dI-ix4YxLQjaOTVQolkaa-Y4Cie-mEd8c34vSWeeNRgVcXuJsZ_iVYywDWqUDpXY6KwdMx6kXZQ0-'+'mihsowKzrFbmhUWun2aGOx44w3wAxHpU5cqE55B0wx2v_f98zUojMp6mkje_pFRdgPmCIYTbym54npXz7goROYyVl8MEhi1HgKmkOVsihaVLfaf5rt3OMbK70Lup3RrkxFbneKslTQ3bwdMdl_Zk1vmjRklvjhmVXyFlEHZVAe4_4n_FYk6oq6UFFJDkEjrWo25B0lKC7XucZZ5b8NDr04xujyV4XaR11ZuQ'}, true, jwk);
    try
      // inspect
      assertTrue(true);
    finally
      jwt.Free;
    end;
  finally
    jwk.Free;
  end;
    *)
end;

{ TJsonTests }

procedure TJsonTests.TestCustomDecimal;
var
  json : TJsonObject;
  f : TFileStream;
begin
  f := TFileStream.Create(fhirTestFile(['r4', 'examples', 'observation-decimal.json']), fmopenRead + fmShareDenyWrite);
  try
    json := TJSONParser.Parse(f);
    try
      assertTrue(json <> nil);
    finally
      json.Free;
    end;
  finally
    f.Free;
  end;
end;

procedure TJsonTests.TestCustomDoc2;
var
  json : TJsonObject;
  f : TFileStream;
begin
  f := TFileStream.Create('C:\work\fhirserver\utilities\tests\test.json', fmopenRead + fmShareDenyWrite);
  try
    json := TJSONParser.Parse(f);
    try
      assertTrue(json <> nil);
      assertTrue(json.properties.Count = 3);
      assertTrue(json.str['type'] = 'FHIR Custom Resource Directory');
      assertTrue(json.arr['prefixes'].Count = 1);
      assertTrue(json.arr['names'].Count = 1);
    finally
      json.Free;
    end;
  finally
    f.Free;
  end;
end;

procedure TJsonTests.TestCustomDoc2Loose;
var
  json : TJsonObject;
  f : TFileStream;
begin
  f := TFileStream.Create('C:\work\fhirserver\utilities\tests\test-loose.json', fmopenRead + fmShareDenyWrite);
  try
    json := TJSONParser.Parse(f, 0, true);
    try
      assertTrue(json <> nil);
      assertTrue(json.properties.Count = 3);
      assertTrue(json.str['type'] = 'FHIR Custom Resource Directory');
      assertTrue(json.arr['prefixes'].Count = 1);
      assertTrue(json.arr['names'].Count = 1);
    finally
      json.Free;
    end;
  finally
    f.Free;
  end;
end;

procedure TJsonTests.TestResource;
var
  json : TJsonObject;
  f : TFileStream;
begin
  f := TFileStream.Create(fhirTestFile(['r4', 'examples', 'account-example.json']), fmopenRead + fmShareDenyWrite);
  try
    json := TJSONParser.Parse(f);
    try
      assertTrue(json <> nil);
    finally
      json.Free;
    end;
  finally
    f.Free;
  end;
end;

{$IFDEF FPC}

constructor TJsonPatchTests.Create;
var
  tests : TJsonArray;
  test : TJsonNode;
  i : integer;
  s : string;
begin
  inherited create;
  tests := TJSONParser.ParseNode(FileToBytes(ownTestFile(['resources', 'testcases', 'json', 'json-patch-tests.json']))) as TJsonArray;
  try
    i := 0;
    for test in tests do
    begin
      s := (test as TJsonObject)['comment'];
      s := s.Substring(0, s.IndexOf(' '));
      AddTest(TJsonPatchTest.create(s));
      inc(i);
    end;
  finally
    tests.free;
  end;
end;

{$ELSE}

{ JsonPatchTestCaseAttribute }

function JsonPatchTestCaseAttribute.GetCaseInfoArray: TestCaseInfoArray;
var
  tests : TJsonArray;
  test : TJsonNode;
  i : integer;
  s : String;
begin
  tests := TJSONParser.ParseNode(FileToBytes(ownTestFile(['resources', 'testcases', 'json', 'json-patch-tests.json']))) as TJsonArray;
  try
    SetLength(result, tests.Count);
    i := 0;
    for test in tests do
    begin
      s := (test as TJsonObject)['comment'];
      s := s.Substring(0, s.IndexOf(' '));
      result[i].Name := s;
      SetLength(result[i].Values, 1);
      result[i].Values[0] := s;
      inc(i);
    end;
  finally
    tests.free;
  end;
end;
{$ENDIF}

{ TJsonPatchTest }

procedure TJsonPatchTest.execute;
begin
  engine.applyPatch(test.obj['doc'], test.arr['patch']).Free;
end;

procedure TJsonPatchTest.PatchTest(Name: String);
var
  t : TJsonNode;
  outcome : TJsonObject;
  s : String;
begin
  for t in tests do
  begin
    test := t as TJsonObject;
    s := test['comment'];
    if s.StartsWith(Name) then
    begin
      if test.has('error') then
      begin
        assertWillRaise(execute, EJsonException, '');
      end
      else
      begin
        outcome := engine.applyPatch(test.obj['doc'], test.arr['patch']);
        try
          assertTrue(TJsonNode.compare(outcome, test.obj['expected']))
        finally
          outcome.Free;
        end;
      end;
    end;
  end;
end;

procedure TJsonPatchTest.setup;
begin
  tests := TJSONParser.ParseNode(FileToBytes(ownTestFile(['resources', 'testcases', 'json', 'json-patch-tests.json']))) as TJsonArray;
  engine := TJsonPatchEngine.Create;
end;

procedure TJsonPatchTest.teardown;
begin
  engine.Free;
  tests.Free;
end;

(*
{ TDigitalSignatureTests }

procedure TDigitalSignatureTests.testFile(filename : String);
var
  bytes : TBytes;
  f : TFileStream;
  sig : TDigitalSigner;
begin
  f := TFileStream.Create(filename, fmOpenRead);
  try
    setLength(bytes, f.Size);
    f.Read(bytes[0], length(bytes));
  finally
    f.free;
  end;
  sig := TDigitalSigner.Create;
  try
    assertTrue(sig.verifySignature(bytes));
  finally
    sig.Free;
  end;
end;

procedure TDigitalSignatureTests.testFileDSA;
begin
  testFile('C:\work\fhirserver\utilities\tests\signatures\java_example_dsa.xml');
end;

procedure TDigitalSignatureTests.testFileJames;
begin
  testFile('C:\work\fhirserver\utilities\tests\signatures\james.xml');
end;

procedure TDigitalSignatureTests.testFileRSA;
begin
  testFile('C:\work\fhirserver\utilities\tests\signatures\java_example_rsa.xml');
end;

procedure TDigitalSignatureTests.testGenRsa_1;
var
  bytes : TBytes;
  sig : TDigitalSigner;
begin
  sig := TDigitalSigner.Create;
  try
    sig.PrivateKey := 'C:\work\fhirserver\utilities\tests\signatures\private_key.pem';

    bytes := sig.signEnveloped(TEncoding.UTF8.GetBytes('<Envelope xmlns="urn:envelope">'+#13#10+'</Envelope>'+#13#10), sdXmlRSASha1, true);
  finally
    sig.Free;
  end;

  sig := TDigitalSigner.Create;
  try
    assertTrue(sig.verifySignature(bytes));
  finally
    sig.Free;
  end;
end;

procedure TDigitalSignatureTests.testGenRsa_256;
var
  bytes : TBytes;
  sig : TDigitalSigner;
begin
  sig := TDigitalSigner.Create;
  try
    sig.PrivateKey := 'C:\work\fhirserver\utilities\tests\signatures\private_key.pem';

    bytes := sig.signEnveloped(TEncoding.UTF8.GetBytes('<Envelope xmlns="urn:envelope">'+#13#10+'</Envelope>'+#13#10), sdXmlRSASha256, true);
  finally
    sig.Free;
  end;

  sig := TDigitalSigner.Create;
  try
    assertTrue(sig.verifySignature(bytes));
  finally
    sig.Free;
  end;
end;

//procedure TDigitalSignatureTests.testGenDsa_1;
//var
//  bytes : TBytes;
//  sig : TDigitalSigner;
//  output : string;
//begin
//  sig := TDigitalSigner.Create;
//  try
//    sig.PrivateKey := 'C:\work\fhirserver\utilities\tests\signatures\private_key.pem';
//
//    bytes := sig.signEnveloped(TEncoding.UTF8.GetBytes('<Envelope xmlns="urn:envelope">'+#13#10+'</Envelope>'+#13#10), sdXmlDSASha1, true);
//  finally
//    sig.Free;
//  end;
//
//  sig := TDigitalSigner.Create;
//  try
//    assertTrue(sig.verifySignature(bytes));
//  finally
//    sig.Free;
//  end;
//end;
//
//procedure TDigitalSignatureTests.testGenDsa_256;
//var
//  bytes : TBytes;
//  sig : TDigitalSigner;
//  output : string;
//begin
//  sig := TDigitalSigner.Create;
//  try
//    sig.PrivateKey := 'C:\work\fhirserver\utilities\tests\signatures\private_key.pem';
//
//    bytes := sig.signEnveloped(TEncoding.UTF8.GetBytes('<Envelope xmlns="urn:envelope">'+#13#10+'</Envelope>'+#13#10), sdXmlDSASha256, true);
//  finally
//    sig.Free;
//  end;
//
//  sig := TDigitalSigner.Create;
//  try
//    assertTrue(sig.verifySignature(bytes));
//  finally
//    sig.Free;
//  end;
//end;
  *)

{ TFslTestObjectList }

function TFslTestObjectList.itemClass: TFslObjectClass;
begin
  result := TFslTestObject;
end;

{ TFslCollectionsTests }

procedure TFslCollectionsTests.testAdd;
begin
  list := TFslTestObjectList.create;
  try
    list.Add(TFslTestObject.create);
    assertTrue(list.Count = 1);
  finally
    list.Free;
  end;
end;

procedure TFslCollectionsTests.executeFail();
begin
  list.Add(TFslTestObjectList.create);
end;

procedure TFslCollectionsTests.testAddFail;
begin
  list := TFslTestObjectList.create;
  try
    assertWillRaise(executeFail, EFslInvariant, '');
    assertTrue(list.Count = 0);
  finally
    list.Free;
  end;
end;

{ TFslTestObject }

constructor TFslTestObject.create(value: String);
begin
  Create;
  self.value := value;
end;

{ TXmlUtilsTest }

procedure TXmlUtilsTest.TestNoDense;
var
  x : TMXmlDocument;
  src, output, tgt : String;
begin
  src := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-pretty.xml', TEncoding.UTF8);
  tgt := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-pretty.xml', TEncoding.UTF8);
  x := TMXmlParser.parse(src, [xpDropWhitespace]);
  try
    output := x.ToXml(true, false);
  finally
    x.Free;
  end;
  StringToFile(output, 'C:\work\fhirserver\utilities\tests\xml\xml-output.xml', TEncoding.UTF8);
  assertEqual(output, tgt);
end;

procedure TXmlUtilsTest.TestNoPretty;
var
  x : TMXmlDocument;
  src, output, tgt : String;
begin
  src := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-condensed.xml', TEncoding.UTF8);
  tgt := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-condensed.xml', TEncoding.UTF8);
  x := TMXmlParser.parse(src, [xpDropWhitespace]);
  try
    output := x.ToXml(false, false);
  finally
    x.Free;
  end;
  StringToFile(output, 'C:\work\fhirserver\utilities\tests\xml\xml-output.xml', TEncoding.UTF8);
  assertEqual(output, tgt);
end;

procedure TXmlUtilsTest.TestPretty;
var
  x : TMXmlDocument;
  src, output, tgt : String;
begin
  src := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-condensed.xml', TEncoding.UTF8);
  tgt := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-pretty.xml', TEncoding.UTF8);
  x := TMXmlParser.parse(src, [xpDropWhitespace]);
  try
    output := x.ToXml(true, false);
  finally
    x.Free;
  end;
  StringToFile(output, 'C:\work\fhirserver\utilities\tests\xml\xml-output.xml', TEncoding.UTF8);
  assertEqual(output, tgt);
end;

procedure TXmlUtilsTest.TestUnPretty;
var
  x : TMXmlDocument;
  src, output, tgt : String;
begin
  src := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-pretty.xml', TEncoding.UTF8);
  tgt := FileToString('C:\work\fhirserver\utilities\tests\xml\xml-condensed.xml', TEncoding.UTF8);
  x := TMXmlParser.parse(src, [xpDropWhitespace]);
  try
    output := x.ToXml(false, false);
  finally
    x.Free;
  end;
  assertEqual(output, tgt);
end;

Procedure TLangParserTests.testBase;
var
  lang : THTTPLanguages;
begin
  lang := THTTPLanguages.create('en');
  assertTrue(lang.header = 'en');
  assertTrue(length(lang.Codes) = 1);
  assertTrue(lang.Codes[0] = 'en');
  assertTrue(lang.prefLang = 'en');
  assertTrue(lang.matches('en'));
  assertTrue(lang.matches('en-AU'));
  assertTrue(not lang.matches('eng'));
end;

{ TFslTestCase }

procedure TFslTestCase.assertPass;
begin
  {$IFDEF FPC}
  // nothing
  {$ELSE}
  Assert.Pass;
  {$ENDIF}
end;

procedure TFslTestCase.assertFail(message: String);
begin
  {$IFDEF FPC}
  TAssert.Fail(message);
  {$ELSE}
  Assert.Fail(message);
  {$ENDIF}
end;

procedure TFslTestCase.assertTrue(test: boolean; message: String);
begin
  {$IFDEF FPC}
  TAssert.AssertTrue(message, test);
  {$ELSE}
  Assert.IsTrue(test, message);
  {$ENDIF}
end;

procedure TFslTestCase.assertTrue(test: boolean);
begin
  {$IFDEF FPC}
  TAssert.AssertTrue(test);
  {$ELSE}
  Assert.IsTrue(test);
  {$ENDIF}
end;

procedure TFslTestCase.assertFalse(test: boolean; message: String);
begin
  {$IFDEF FPC}
  TAssert.AssertFalse(message, test);
  {$ELSE}
  Assert.IsFalse(test, message);
  {$ENDIF}
end;

procedure TFslTestCase.assertFalse(test: boolean);
begin
  {$IFDEF FPC}
  TAssert.AssertFalse(test);
  {$ELSE}
  Assert.IsFalse(test);
  {$ENDIF}
end;

procedure TFslTestCase.assertEqual(left, right, message: String);
begin
  {$IFDEF FPC}
  TAssert.AssertEquals(message, left, right);
  {$ELSE}
  Assert.AreEqual(left, right, message);
  {$ENDIF}
end;

procedure TFslTestCase.assertEqual(left, right: String);
begin
  {$IFDEF FPC}
  TAssert.AssertEquals(left, right);
  {$ELSE}
  Assert.AreEqual(left, right);
  {$ENDIF}
end;

procedure TFslTestCase.assertWillRaise(AMethod: TRunMethod; AExceptionClass: ExceptClass; AExceptionMessage : String);
begin
  {$IFDEF FPC}
  TAssert.AssertException(AExceptionMessage, AExceptionClass, AMethod);
  {$ELSE}
  Assert.WillRaise(AMethod, AExceptionClass, AExceptionMessage);
  {$ENDIF}
end;

{$IFNDEF FPC}
procedure TFslTestCase.setup;
begin

end;

procedure TFslTestCase.tearDown;
begin

end;
{$ENDIF}

procedure TFslTestCase.thread(proc: TRunMethod);
begin
  TFSLTestThread.Create(proc);
end;

{ TFslTestSuite }

{$IFDEF FPC}
constructor TFslTestSuite.Create(name : String);
begin
  inherited CreateWith('Test', name);
  FName := name;
end;

function TFslTestSuite.GetTestName: string;
begin
  Result := FName;
end;

procedure TFslTestSuite.Test;
begin
  TestCase(FName);
end;

{$ENDIF}

procedure TFslTestSuite.TestCase(name: String);
begin
  // nothing - override this
end;

{ TFslTestThread }

constructor TFslTestThread.Create(proc: TRunMethod);
begin
  FProc := proc;
  FreeOnTerminate := true;
  inherited Create(false);
end;

procedure TFslTestThread.execute;
begin
  Fproc;
end;

initialization
  {$IFDEF FPC}
  RegisterTest('Generics Tests', TFslGenericsTests);
  RegisterTest('Collection Tests', TFslCollectionsTests);
  RegisterTest('XPlatform Tests', TOSXTests);
  RegisterTest('Decimal Tests', TDecimalTests);
  RegisterTest('XML Tests', TXmlParserTests.create);
  RegisterTest('XML Utility Tests', TXmlUtilsTest);
  RegisterTest('XPath Tests', TXPathParserTests.create);
  RegisterTest('XPath Engine Tests', TXPathEngineTests.create);
  RegisterTest('XML Patch Tests', TXmlPatchTests.create);
  RegisterTest('Json Tests', TJsonTests);
  RegisterTest('JWT Tests', TJWTTests);
  RegisterTest('Turtle Tests', TTurtleTests);
  RegisterTest('Language Parser Tests', TLangParserTests);
  RegisterTest('Regex Test', TFslRegexTests);
  {$ELSE}
  TDUnitX.RegisterTestFixture(TFslGenericsTests);
  TDUnitX.RegisterTestFixture(TFslCollectionsTests);
  TDUnitX.RegisterTestFixture(TOSXTests);
  TDUnitX.RegisterTestFixture(TXmlParserTest);
  TDUnitX.RegisterTestFixture(TXmlUtilsTest);
  TDUnitX.RegisterTestFixture(TXPathParserTest);
  TDUnitX.RegisterTestFixture(TXPathEngineTest);
  TDUnitX.RegisterTestFixture(TXmlPatchTest);
  TDUnitX.RegisterTestFixture(TJsonTests);
  TDUnitX.RegisterTestFixture(TJsonPatchTest);
  TDUnitX.RegisterTestFixture(TJWTTests);
  TDUnitX.RegisterTestFixture(TTurtleTests);
  TDUnitX.RegisterTestFixture(TDecimalTests);
  TDUnitX.RegisterTestFixture(TLangParserTests);
//  TDUnitX.RegisterTestFixture(TDigitalSignatureTests);
  {$ENDIF}
end.




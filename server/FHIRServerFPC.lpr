program FHIRServerFPC;

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


uses
  {$IFDEF MSWINDOWS}
  FastMM4 in '..\dependencies\FMMAVX\FastMM4.pas',
  FastMM4Messages in '..\dependencies\FMMAVX\FastMM4Messages.pas',
  Windows,
  {$ENDIF}
  {$IFDEF LINUX}
  cthreads, cmem,
  {$ENDIF}
  Classes, SysUtils,
  Interfaces,
  IdSSLOpenSSLHeaders,
  RegularExpressions in '..\library\support\RegularExpressions.pas',
  IOUtils in '..\library\support\IOUtils.pas',
  FHIR.Base.Common in '..\library\base\FHIR.Base.Common.pas',
  FHIR.Base.Factory in '..\library\base\FHIR.Base.Factory.pas',
  FHIR.Base.Lang in '..\library\base\FHIR.Base.Lang.pas',
  FHIR.Base.Narrative in '..\library\base\FHIR.Base.Narrative.pas',
  FHIR.Base.Objects in '..\library\base\FHIR.Base.Objects.pas',
  FHIR.Base.Parser in '..\library\base\FHIR.Base.Parser.pas',
  FHIR.Base.PathEngine in '..\library\base\FHIR.Base.PathEngine.pas',
  FHIR.Base.Scim in '..\library\base\FHIR.Base.Scim.pas',
  FHIR.Base.Utilities in '..\library\base\FHIR.Base.Utilities.pas',
  FHIR.Base.Validator in '..\library\base\FHIR.Base.Validator.pas',
  FHIR.Base.Xhtml in '..\library\base\FHIR.Base.Xhtml.pas',
  FHIR.Cache.PackageManager in '..\library\cache\FHIR.Cache.PackageManager.pas',
  FHIR.CdsHooks.Client in '..\library\cdshooks\FHIR.CdsHooks.Client.pas',
  FHIR.CdsHooks.Server in 'FHIR.CdsHooks.Server.pas',
  FHIR.CdsHooks.Service in 'FHIR.CdsHooks.Service.pas',
  FHIR.CdsHooks.Utilities in '..\library\cdshooks\FHIR.CdsHooks.Utilities.pas',
  FHIR.Client.Base in '..\library\client\FHIR.Client.Base.pas',
  FHIR.Client.HTTP in '..\library\client\FHIR.Client.HTTP.pas',
  {$IFNDEF NO_JS}
  FHIR.Client.Javascript in '..\library\client\FHIR.Client.Javascript.pas',
  {$ENDIF}
  FHIR.Client.Threaded in '..\library\client\FHIR.Client.Threaded.pas',
  FHIR.Database.Dialects in '..\library\database\FHIR.Database.Dialects.pas',
  FHIR.Database.Logging in '..\library\database\FHIR.Database.Logging.pas',
  FHIR.Database.Manager in '..\library\database\FHIR.Database.Manager.pas',
  FHIR.Database.ODBC in '..\library\database\FHIR.Database.ODBC.pas',
  FHIR.Database.ODBC.Headers in '..\library\database\FHIR.Database.ODBC.Headers.pas',
  FHIR.Database.ODBC.Objects in '..\library\database\FHIR.Database.ODBC.Objects.pas',
  FHIR.Database.SQLite in '..\library\database\FHIR.Database.SQLite.pas',
  FHIR.Database.SQLite3.Objects in '..\library\database\FHIR.Database.SQLite3.Objects.pas',
  FHIR.Database.SQLite3.Utilities in '..\library\database\FHIR.Database.SQLite3.Utilities.pas',
  FHIR.Database.SQLite3.Wrapper in '..\library\database\FHIR.Database.SQLite3.Wrapper.pas',
  FHIR.Database.Utilities in '..\library\database\FHIR.Database.Utilities.pas',
  {$IFNDEF NO_JS}
  FHIR.Javascript in '..\library\javascript\FHIR.Javascript.pas',
  FHIR.Javascript.Base in '..\library\javascript\FHIR.Javascript.Base.pas',
  {$ENDIF}
  FHIR.Loinc.Importer in '..\library\loinc\FHIR.Loinc.Importer.pas',
  FHIR.Loinc.Publisher in '..\library\loinc\FHIR.Loinc.Publisher.pas',
  FHIR.Loinc.Services in '..\library\loinc\FHIR.Loinc.Services.pas',
  FHIR.Web.Twilio in '..\library\web\FHIR.Web.Twilio.pas',
  FHIR.R2.Base in '..\library\r2\FHIR.R2.Base.pas',
  FHIR.R2.Client in '..\library\r2\FHIR.R2.Client.pas',
  FHIR.R2.Common in '..\library\r2\FHIR.R2.Common.pas',
  FHIR.R2.Constants in '..\library\r2\FHIR.R2.Constants.pas',
  FHIR.R2.Context in '..\library\r2\FHIR.R2.Context.pas',
  FHIR.R2.ElementModel in '..\library\r2\FHIR.R2.ElementModel.pas',
  FHIR.R2.Factory in '..\library\r2\FHIR.R2.Factory.pas',
  FHIR.R2.Json in '..\library\r2\FHIR.R2.Json.pas',
  FHIR.R2.Narrative in '..\library\r2\FHIR.R2.Narrative.pas',
  FHIR.R2.OpBase in '..\library\r2\FHIR.R2.OpBase.pas',
  FHIR.R2.Operations in '..\library\r2\FHIR.R2.Operations.pas',
  FHIR.R2.Parser in '..\library\r2\FHIR.R2.Parser.pas',
  FHIR.R2.ParserBase in '..\library\r2\FHIR.R2.ParserBase.pas',
  FHIR.R2.PathEngine in '..\library\r2\FHIR.R2.PathEngine.pas',
  FHIR.R2.PathNode in '..\library\r2\FHIR.R2.PathNode.pas',
  FHIR.R2.Profiles in '..\library\r2\FHIR.R2.Profiles.pas',
  FHIR.R2.Resources in '..\library\r2\FHIR.R2.Resources.pas',
  FHIR.R2.Resources.Base in '..\library\r2\FHIR.R2.Resources.Base.pas',
  FHIR.R2.Resources.Admin in '..\library\r2\FHIR.R2.Resources.Admin.pas',
  FHIR.R2.Resources.Canonical in '..\library\r2\FHIR.R2.Resources.Canonical.pas',
  FHIR.R2.Resources.Clinical in '..\library\r2\FHIR.R2.Resources.Clinical.pas',
  FHIR.R2.Resources.Other in '..\library\r2\FHIR.R2.Resources.Other.pas',
  FHIR.R2.Types in '..\library\r2\FHIR.R2.Types.pas',
  FHIR.R2.Utilities in '..\library\r2\FHIR.R2.Utilities.pas',
  FHIR.R2.Validator in '..\library\r2\FHIR.R2.Validator.pas',
  FHIR.R2.Xml in '..\library\r2\FHIR.R2.Xml.pas',
  FHIR.R3.Base in '..\library\r3\FHIR.R3.Base.pas',
  FHIR.R3.Client in '..\library\r3\FHIR.R3.Client.pas',
  FHIR.R3.Common in '..\library\r3\FHIR.R3.Common.pas',
  FHIR.R3.Constants in '..\library\r3\FHIR.R3.Constants.pas',
  FHIR.R3.Context in '..\library\r3\FHIR.R3.Context.pas',
  FHIR.R3.ElementModel in '..\library\r3\FHIR.R3.ElementModel.pas',
  FHIR.R3.Factory in '..\library\r3\FHIR.R3.Factory.pas',
  FHIR.R3.Json in '..\library\r3\FHIR.R3.Json.pas',
  FHIR.R3.Narrative in '..\library\r3\FHIR.R3.Narrative.pas',
  FHIR.R3.OpBase in '..\library\r3\FHIR.R3.OpBase.pas',
  FHIR.R3.Operations in '..\library\r3\FHIR.R3.Operations.pas',
  FHIR.R3.Parser in '..\library\r3\FHIR.R3.Parser.pas',
  FHIR.R3.ParserBase in '..\library\r3\FHIR.R3.ParserBase.pas',
  FHIR.R3.PathEngine in '..\library\r3\FHIR.R3.PathEngine.pas',
  FHIR.R3.PathNode in '..\library\r3\FHIR.R3.PathNode.pas',
  FHIR.R3.Profiles in '..\library\r3\FHIR.R3.Profiles.pas',
  FHIR.R3.Resources in '..\library\r3\FHIR.R3.Resources.pas',
  FHIR.R3.Resources.Base in '..\library\r3\FHIR.R3.Resources.Base.pas',
  FHIR.R3.Resources.Admin in '..\library\r3\FHIR.R3.Resources.Admin.pas',
  FHIR.R3.Resources.Canonical in '..\library\r3\FHIR.R3.Resources.Canonical.pas',
  FHIR.R3.Resources.Clinical in '..\library\r3\FHIR.R3.Resources.Clinical.pas',
  FHIR.R3.Resources.Other in '..\library\r3\FHIR.R3.Resources.Other.pas',
  FHIR.R3.Turtle in '..\library\r3\FHIR.R3.Turtle.pas',
  FHIR.R3.Types in '..\library\r3\FHIR.R3.Types.pas',
  FHIR.R3.Utilities in '..\library\r3\FHIR.R3.Utilities.pas',
  FHIR.R3.Validator in '..\library\r3\FHIR.R3.Validator.pas',
  FHIR.R3.Xml in '..\library\r3\FHIR.R3.Xml.pas',
  FHIR.R4.AuthMap in '..\library\r4\FHIR.R4.AuthMap.pas',
  FHIR.R4.Base in '..\library\r4\FHIR.R4.Base.pas',
  FHIR.R4.Client in '..\library\r4\FHIR.R4.Client.pas',
  FHIR.R4.Common in '..\library\r4\FHIR.R4.Common.pas',
  FHIR.R4.Constants in '..\library\r4\FHIR.R4.Constants.pas',
  FHIR.R4.Context in '..\library\r4\FHIR.R4.Context.pas',
  FHIR.R4.ElementModel in '..\library\r4\FHIR.R4.ElementModel.pas',
  FHIR.R4.Factory in '..\library\r4\FHIR.R4.Factory.pas',
  FHIR.R4.IndexInfo in '..\library\r4\FHIR.R4.IndexInfo.pas',
  {$IFNDEF NO_JS}
  FHIR.R4.Javascript in '..\library\r4\FHIR.R4.Javascript.pas',
  {$ENDIF}
  FHIR.R4.Json in '..\library\r4\FHIR.R4.Json.pas',
  FHIR.R4.MapUtilities in '..\library\r4\FHIR.R4.MapUtilities.pas',
  FHIR.R4.Narrative in '..\library\r4\FHIR.R4.Narrative.pas',
  FHIR.R4.Narrative2 in '..\library\r4\FHIR.R4.Narrative2.pas',
  FHIR.R4.OpBase in '..\library\r4\FHIR.R4.OpBase.pas',
  FHIR.R4.Operations in '..\library\r4\FHIR.R4.Operations.pas',
  FHIR.R4.Parser in '..\library\r4\FHIR.R4.Parser.pas',
  FHIR.R4.ParserBase in '..\library\r4\FHIR.R4.ParserBase.pas',
  FHIR.R4.PathEngine in '..\library\r4\FHIR.R4.PathEngine.pas',
  FHIR.R4.PathNode in '..\library\r4\FHIR.R4.PathNode.pas',
  FHIR.R4.Profiles in '..\library\r4\FHIR.R4.Profiles.pas',
  FHIR.R4.Questionnaire in '..\library\r4\FHIR.R4.Questionnaire.pas',
  FHIR.R4.Resources in '..\library\r4\FHIR.R4.Resources.pas',
  FHIR.R4.Resources.Base in '..\library\r4\FHIR.R4.Resources.Base.pas',
  FHIR.R4.Resources.Admin in '..\library\r4\FHIR.R4.Resources.Admin.pas',
  FHIR.R4.Resources.Canonical in '..\library\r4\FHIR.R4.Resources.Canonical.pas',
  FHIR.R4.Resources.Clinical in '..\library\r4\FHIR.R4.Resources.Clinical.pas',
  FHIR.R4.Resources.Financial in '..\library\r4\FHIR.R4.Resources.Financial.pas',
  FHIR.R4.Resources.Medications in '..\library\r4\FHIR.R4.Resources.Medications.pas',
  FHIR.R4.Resources.Other in '..\library\r4\FHIR.R4.Resources.Other.pas',
  FHIR.R4.Turtle in '..\library\r4\FHIR.R4.Turtle.pas',
  FHIR.R4.Types in '..\library\r4\FHIR.R4.Types.pas',
  FHIR.R4.Utilities in '..\library\r4\FHIR.R4.Utilities.pas',
  FHIR.R4.Validator in '..\library\r4\FHIR.R4.Validator.pas',
  FHIR.R4.Xml in '..\library\r4\FHIR.R4.Xml.pas',
  FHIR.Scim.Search in 'FHIR.Scim.Search.pas',
  FHIR.Scim.Server in 'FHIR.Scim.Server.pas',
  FHIR.Server.AccessControl in 'FHIR.Server.AccessControl.pas',
  FHIR.Server.AuthMgr in 'FHIR.Server.AuthMgr.pas',
  FHIR.Server.ClosureMgr in 'FHIR.Server.ClosureMgr.pas',
  FHIR.Server.Constants in 'FHIR.Server.Constants.pas',
  FHIR.Server.DBInstaller in 'FHIR.Server.DBInstaller.pas',
  FHIR.Server.Database in 'FHIR.Server.Database.pas',
  FHIR.Server.GraphDefinition in 'FHIR.Server.GraphDefinition.pas',
  {$IFNDEF NO_JS}
  FHIR.Server.EventJs in 'FHIR.Server.EventJs.pas',
  FHIR.Server.Javascript in 'FHIR.Server.Javascript.pas',
  {$ENDIF}
  FHIR.Server.Jwt in 'FHIR.Server.Jwt.pas',
  FHIR.Server.Kernel in 'FHIR.Server.Kernel.pas',
  FHIR.Server.MpiSearch in 'FHIR.Server.MpiSearch.pas',
  FHIR.Server.ObsStats in 'FHIR.Server.ObsStats.pas',
  FHIR.Server.ReverseClient in 'FHIR.Server.ReverseClient.pas',
  FHIR.Server.Search in 'FHIR.Server.Search.pas',
  FHIR.Server.SearchSyntax in 'FHIR.Server.SearchSyntax.pas',
  FHIR.Server.Security in '..\library\tools\FHIR.Server.Security.pas',
  FHIR.Server.Session in '..\library\tools\FHIR.Server.Session.pas',
  FHIR.Server.Storage in 'FHIR.Server.Storage.pas',
  FHIR.Server.Subscriptions in 'FHIR.Server.Subscriptions.pas',
  FHIR.Server.UserMgr in 'FHIR.Server.UserMgr.pas',
  FHIR.Server.Utilities in 'FHIR.Server.Utilities.pas',
  FHIR.Server.Web in 'FHIR.Server.Web.pas',
  FHIR.Server.WebSource in 'FHIR.Server.WebSource.pas',
  FHIR.Server.XhtmlComp in 'FHIR.Server.XhtmlComp.pas',
  FHIR.Smart.Utilities in '..\library\smart\FHIR.Smart.Utilities.pas',
  FHIR.Snomed.Analysis in '..\library\snomed\FHIR.Snomed.Analysis.pas',
  FHIR.Snomed.Expressions in '..\library\snomed\FHIR.Snomed.Expressions.pas',
  FHIR.Snomed.Importer in '..\library\snomed\FHIR.Snomed.Importer.pas',
  FHIR.Snomed.Publisher in '..\library\snomed\FHIR.Snomed.Publisher.pas',
  FHIR.Snomed.Services in '..\library\snomed\FHIR.Snomed.Services.pas',
  FHIR.Support.Base in '..\library\support\FHIR.Support.Base.pas',
  FHIR.Support.Certs in '..\library\support\FHIR.Support.Certs.pas',
  FHIR.Support.Collections in '..\library\support\FHIR.Support.Collections.pas',
  FHIR.Support.Fpc in '..\library\support\FHIR.Support.Fpc.pas',
  {$IFNDEF NO_JS}
  FHIR.Support.Javascript in '..\library\support\FHIR.Support.Javascript.pas',
  {$ENDIF}
  FHIR.Support.Json in '..\library\support\FHIR.Support.Json.pas',
  FHIR.Support.Logging in '..\library\support\FHIR.Support.Logging.pas',
  FHIR.Support.MXml in '..\library\support\FHIR.Support.MXml.pas',
  FHIR.Support.Osx in '..\library\support\FHIR.Support.Osx.pas',
  {$IFDEF MSWINDOWS}
  FHIR.Support.MsXml in '..\library\support\FHIR.Support.MsXml.pas',
  FHIR.Support.Service in '..\library\support\FHIR.Support.Service.pas',
  FHIR.Support.Shell in '..\library\support\FHIR.Support.Shell.pas',
  {$ELSE}
  FHIR.Support.SystemService in '..\library\support\FHIR.Support.SystemService.pas',
  {$ENDIF}
  FHIR.Support.Signatures in '..\library\support\FHIR.Support.Signatures.pas',
  FHIR.Support.Stream in '..\library\support\FHIR.Support.Stream.pas',
  FHIR.Support.Threads in '..\library\support\FHIR.Support.Threads.pas',
  FHIR.Support.Turtle in '..\library\support\FHIR.Support.Turtle.pas',
  FHIR.Support.Utilities in '..\library\support\FHIR.Support.Utilities.pas',
  FHIR.Support.Xml in '..\library\support\FHIR.Support.Xml.pas',
  FHIR.Tools.CodeGen in '..\library\tools\FHIR.Tools.CodeGen.pas',
  FHIR.Tools.DiffEngine in '..\library\tools\FHIR.Tools.DiffEngine.pas',
  FHIR.Tools.GraphQL in '..\library\tools\FHIR.Tools.GraphQL.pas',
  FHIR.Tools.Indexing in '..\library\tools\FHIR.Tools.Indexing.pas',
  FHIR.Tools.Search in '..\library\tools\FHIR.Tools.Search.pas',
  FHIR.Tx.ACIR in 'FHIR.Tx.ACIR.pas',
  FHIR.Tx.CountryCode in 'FHIR.Tx.CountryCode.pas',
  FHIR.Tx.Iso4217 in 'FHIR.Tx.Iso4217.pas',
  FHIR.Tx.Lang in 'FHIR.Tx.Lang.pas',
  FHIR.Tx.Manager in 'FHIR.Tx.Manager.pas',
  FHIR.Tx.MimeTypes in 'FHIR.Tx.MimeTypes.pas',
  FHIR.Tx.Operations in 'FHIR.Tx.Operations.pas',
  FHIR.Tx.RxNorm in 'FHIR.Tx.RxNorm.pas',
  FHIR.Tx.Server in 'FHIR.Tx.Server.pas',
  FHIR.Tx.Service in '..\library\FHIR.Tx.Service.pas',
  FHIR.Tx.Unii in 'FHIR.Tx.Unii.pas',
  FHIR.Tx.Uri in 'FHIR.Tx.Uri.pas',
  FHIR.Tx.UsState in 'FHIR.Tx.UsState.pas',
  FHIR.Tx.Web in 'FHIR.Tx.Web.pas',
  FHIR.Ucum.Base in '..\library\ucum\FHIR.Ucum.Base.pas',
  FHIR.Ucum.Expressions in '..\library\ucum\FHIR.Ucum.Expressions.pas',
  FHIR.Ucum.Handlers in '..\library\ucum\FHIR.Ucum.Handlers.pas',
  FHIR.Ucum.IFace in '..\library\ucum\FHIR.Ucum.IFace.pas',
  FHIR.Ucum.Search in '..\library\ucum\FHIR.Ucum.Search.pas',
  FHIR.Ucum.Services in '..\library\ucum\FHIR.Ucum.Services.pas',
  FHIR.Ucum.Validators in '..\library\ucum\FHIR.Ucum.Validators.pas',
  FHIR.Support.SCrypt in '..\library\support\FHIR.Support.SCrypt.pas',
  FHIR.Web.Facebook in '..\library\web\FHIR.Web.Facebook.pas',
  FHIR.Web.Fetcher in '..\library\web\FHIR.Web.Fetcher.pas',
  FHIR.Web.GraphQL in '..\library\web\FHIR.Web.GraphQL.pas',
  FHIR.Web.HtmlGen in '..\library\web\FHIR.Web.HtmlGen.pas',
  FHIR.Web.Parsers in '..\library\web\FHIR.Web.Parsers.pas',
  FHIR.Web.Rdf in '..\library\web\FHIR.Web.Rdf.pas',
  FHIR.Web.Socket in '..\library\web\FHIR.Web.Socket.pas',
  FHIR.Web.WinInet in '..\library\web\FHIR.Web.WinInet.pas',
  FHIR.XVersion.ConvBase in '..\library\xversion\FHIR.XVersion.ConvBase.pas',
  FHIR.Server.Tags in 'FHIR.Server.Tags.pas',
  FHIR.Tools.CodeSystemProvider in '..\library\tools\FHIR.Tools.CodeSystemProvider.pas',
  FHIR.Tools.ValueSets in '..\library\tools\FHIR.Tools.ValueSets.pas',
  {$IFNDEF NO_JS}
  FHIR.R2.Javascript in '..\library\r2\FHIR.R2.Javascript.pas',
  FHIR.R3.Javascript in '..\library\r3\FHIR.R3.Javascript.pas',
  {$ENDIF}
  FHIR.Server.Context in 'FHIR.Server.Context.pas',
  FHIR.Server.Indexing in 'FHIR.Server.Indexing.pas',
  FHIR.R2.IndexInfo in '..\library\r2\FHIR.R2.IndexInfo.pas',
  FHIR.R3.IndexInfo in '..\library\r3\FHIR.R3.IndexInfo.pas',
  FHIR.R2.AuthMap in '..\library\r2\FHIR.R2.AuthMap.pas',
  FHIR.R3.AuthMap in '..\library\r3\FHIR.R3.AuthMap.pas',
  FHIR.R4.GraphDefinition in '..\library\r4\FHIR.R4.GraphDefinition.pas',
  FHIR.Base.GraphDefinition in '..\library\base\FHIR.Base.GraphDefinition.pas',
  FHIR.Server.BundleBuilder in 'FHIR.Server.BundleBuilder.pas',
  FHIR.Server.IndexingR4 in 'FHIR.Server.IndexingR4.pas',
  FHIR.Server.IndexingR3 in 'FHIR.Server.IndexingR3.pas',
  FHIR.Server.IndexingR2 in 'FHIR.Server.IndexingR2.pas',
  FHIR.Server.OperationsR2 in 'FHIR.Server.OperationsR2.pas',
  FHIR.Server.OperationsR3 in 'FHIR.Server.OperationsR3.pas',
  FHIR.Server.OperationsR4 in 'FHIR.Server.OperationsR4.pas',
  FHIR.Server.SubscriptionsR2 in 'FHIR.Server.SubscriptionsR2.pas',
  FHIR.Server.SubscriptionsR3 in 'FHIR.Server.SubscriptionsR3.pas',
  FHIR.Server.SubscriptionsR4 in 'FHIR.Server.SubscriptionsR4.pas',
  FHIR.R2.Questionnaire in '..\library\r2\FHIR.R2.Questionnaire.pas',
  FHIR.R2.Narrative2 in '..\library\r2\FHIR.R2.Narrative2.pas',
  FHIR.R3.Questionnaire in '..\library\r3\FHIR.R3.Questionnaire.pas',
  FHIR.R3.Narrative2 in '..\library\r3\FHIR.R3.Narrative2.pas',
  FHIR.XVersion.Convertors in '..\library\xversion\FHIR.XVersion.Convertors.pas',
  FHIR.XVersion.Conv_30_40 in '..\library\xversion\FHIR.XVersion.Conv_30_40.pas',
  FHIR.Tools.NDJsonParser in '..\library\tools\FHIR.Tools.NDJsonParser.pas',
  FHIR.Server.Factory in 'FHIR.Server.Factory.pas',
  FHIR.Server.ValidatorR4 in 'FHIR.Server.ValidatorR4.pas',
  FHIR.Server.ValidatorR2 in 'FHIR.Server.ValidatorR2.pas',
  FHIR.Server.ValidatorR3 in 'FHIR.Server.ValidatorR3.pas',
  FHIR.Server.SessionMgr in 'FHIR.Server.SessionMgr.pas',
  FHIR.Snomed.Combiner in '..\library\snomed\FHIR.Snomed.Combiner.pas',
  FHIR.Support.Lang in '..\library\support\FHIR.Support.Lang.pas',
  {$IFDEF MSWINDOWS}
  JclDebug in '..\dependencies\jcl\JclDebug.pas',
  JclBase in '..\dependencies\jcl\JclBase.pas',
  JclResources in '..\dependencies\jcl\JclResources.pas',
  JclFileUtils in '..\dependencies\jcl\JclFileUtils.pas',
  JclWin32 in '..\dependencies\jcl\JclWin32.pas',
  JclSysUtils in '..\dependencies\jcl\JclSysUtils.pas',
  JclSynch in '..\dependencies\jcl\JclSynch.pas',
  JclLogic in '..\dependencies\jcl\JclLogic.pas',
  JclRegistry in '..\dependencies\jcl\JclRegistry.pas',
  JclStrings in '..\dependencies\jcl\JclStrings.pas',
  JclAnsiStrings in '..\dependencies\jcl\JclAnsiStrings.pas',
  JclStreams in '..\dependencies\jcl\JclStreams.pas',
  JclStringConversions in '..\dependencies\jcl\JclStringConversions.pas',
  JclCharsets in '..\dependencies\jcl\JclCharsets.pas',
  JclMath in '..\dependencies\jcl\JclMath.pas',
  Jcl8087 in '..\dependencies\jcl\Jcl8087.pas',
  JclConsole in '..\dependencies\jcl\JclConsole.pas',
  JclShell in '..\dependencies\jcl\JclShell.pas',
  JclWideStrings in '..\dependencies\jcl\JclWideStrings.pas',
  JclUnicode in '..\dependencies\jcl\JclUnicode.pas',
  JclSysInfo in '..\dependencies\jcl\JclSysInfo.pas',
  Snmp in '..\dependencies\jcl\Snmp.pas',
  JclIniFiles in '..\dependencies\jcl\JclIniFiles.pas',
  JclSecurity in '..\dependencies\jcl\JclSecurity.pas',
  JclDateTime in '..\dependencies\jcl\JclDateTime.pas',
  JclPeImage in '..\dependencies\jcl\JclPeImage.pas',
  JclTD32 in '..\dependencies\jcl\JclTD32.pas',
  JclHookExcept in '..\dependencies\jcl\JclHookExcept.pas',
  {$ENDIF}
  FHIR.Server.v2Server in 'FHIR.Server.v2Server.pas',
  FHIR.v2.Protocol in '..\library\v2\FHIR.v2.Protocol.pas',
  FHIR.v2.Message in '..\library\v2\FHIR.v2.Message.pas',
  FHIR.Cda.Narrative in '..\library\cda\FHIR.Cda.Narrative.pas',
  FHIR.Cda.Base in '..\library\cda\FHIR.Cda.Base.pas',
  FHIR.Cda.Objects in '..\library\cda\FHIR.Cda.Objects.pas',
  FHIR.Cda.Types in '..\library\cda\FHIR.Cda.Types.pas',
  FHIR.Base.OIDs in '..\library\base\FHIR.Base.OIDs.pas',
  FHIR.Base.ElementModel in '..\library\base\FHIR.Base.ElementModel.pas',
  {$IFNDEF NO_JS}
  ChakraDebug in '..\dependencies\chakracore-delphi\ChakraDebug.pas',
  ChakraCoreUtils in '..\dependencies\chakracore-delphi\ChakraCoreUtils.pas',
  ChakraCoreClasses in '..\dependencies\chakracore-delphi\ChakraCoreClasses.pas',
  ChakraCore in '..\dependencies\chakracore-delphi\ChakraCore.pas',
  ChakraCommon in '..\dependencies\chakracore-delphi\ChakraCommon.pas',
  Compat in '..\dependencies\chakracore-delphi\Compat.pas',
  {$ENDIF}
  FHIR.Server.ConsentEngine in 'FHIR.Server.ConsentEngine.pas',
  FHIR.Tx.NDC in 'FHIR.Tx.NDC.pas',
  FHIR.Cache.NpmPackage in '..\library\cache\FHIR.Cache.NpmPackage.pas',
  FHIR.Server.IndexingR5 in 'FHIR.Server.IndexingR5.pas',
  FHIR.Server.OperationsR5 in 'FHIR.Server.OperationsR5.pas',
  FHIR.Server.SubscriptionsR5 in 'FHIR.Server.SubscriptionsR5.pas',
  FHIR.Server.ValidatorR5 in 'FHIR.Server.ValidatorR5.pas',
  FHIR.R5.Base in '..\library\r5\FHIR.R5.Base.pas',
  FHIR.R5.Constants in '..\library\r5\FHIR.R5.Constants.pas',
  FHIR.R5.Enums in '..\library\r5\FHIR.R5.Enums.pas',
  FHIR.R5.Factory in '..\library\r5\FHIR.R5.Factory.pas',
  FHIR.R5.IndexInfo in '..\library\r5\FHIR.R5.IndexInfo.pas',
  {$IFNDEF NO_JS}
  FHIR.R5.Javascript in '..\library\r5\FHIR.R5.Javascript.pas',
  {$ENDIF}
  FHIR.R5.Json in '..\library\r5\FHIR.R5.Json.pas',
  FHIR.R5.PathEngine in '..\library\r5\FHIR.R5.PathEngine.pas',
  FHIR.R5.PathNode in '..\library\r5\FHIR.R5.PathNode.pas',
  FHIR.R5.Profiles in '..\library\r5\FHIR.R5.Profiles.pas',
  FHIR.R5.Resources in '..\library\r5\FHIR.R5.Resources.pas',
  FHIR.R5.Resources.Base in '..\library\r5\FHIR.R5.Resources.Base.pas',
  FHIR.R5.Resources.Admin in '..\library\r5\FHIR.R5.Resources.Admin.pas',
  FHIR.R5.Resources.Canonical in '..\library\r5\FHIR.R5.Resources.Canonical.pas',
  FHIR.R5.Resources.Clinical in '..\library\r5\FHIR.R5.Resources.Clinical.pas',
  FHIR.R5.Resources.Financial in '..\library\r5\FHIR.R5.Resources.Financial.pas',
  FHIR.R5.Resources.Medications in '..\library\r5\FHIR.R5.Resources.Medications.pas',
  FHIR.R5.Resources.Other in '..\library\r5\FHIR.R5.Resources.Other.pas',
  FHIR.R5.Tags in '..\library\r5\FHIR.R5.Tags.pas',
  FHIR.R5.Turtle in '..\library\r5\FHIR.R5.Turtle.pas',
  FHIR.R5.Types in '..\library\r5\FHIR.R5.Types.pas',
  FHIR.R5.Utilities in '..\library\r5\FHIR.R5.Utilities.pas',
  FHIR.R5.Validator in '..\library\r5\FHIR.R5.Validator.pas',
  FHIR.R5.Xml in '..\library\r5\FHIR.R5.Xml.pas',
  FHIR.R5.Context in '..\library\r5\FHIR.R5.Context.pas',
  FHIR.R5.ParserBase in '..\library\r5\FHIR.R5.ParserBase.pas',
  FHIR.R5.Parser in '..\library\r5\FHIR.R5.Parser.pas',
  FHIR.R5.ElementModel in '..\library\r5\FHIR.R5.ElementModel.pas',
  FHIR.R5.Common in '..\library\r5\FHIR.R5.Common.pas',
  FHIR.R5.OpBase in '..\library\r5\FHIR.R5.OpBase.pas',
  FHIR.R5.Operations in '..\library\r5\FHIR.R5.Operations.pas',
  FHIR.R5.AuthMap in '..\library\r5\FHIR.R5.AuthMap.pas',
  FHIR.R5.Client in '..\library\r5\FHIR.R5.Client.pas',
  FHIR.R5.Narrative in '..\library\r5\FHIR.R5.Narrative.pas',
  FHIR.R5.Questionnaire in '..\library\r5\FHIR.R5.Questionnaire.pas',
  FHIR.R5.Narrative2 in '..\library\r5\FHIR.R5.Narrative2.pas',
  FHIR.R5.GraphDefinition in '..\library\r5\FHIR.R5.GraphDefinition.pas',
  FHIR.R5.MapUtilities in '..\library\r5\FHIR.R5.MapUtilities.pas',
  FHIR.Cache.PackageUpdater in '..\library\cache\FHIR.Cache.PackageUpdater.pas',
  FHIR.Server.Packages in 'FHIR.Server.Packages.pas',
  FHIR.Cache.PackageClient in '..\library\cache\FHIR.Cache.PackageClient.pas',
  FHIR.Server.Covid in 'Modules\FHIR.Server.Covid.pas',
  FHIR.R4.Liquid in '..\library\r4\FHIR.R4.Liquid.pas',
  FHIR.Server.Twilio in 'FHIR.Server.Twilio.pas',
  FHIR.Server.WebBase in 'FHIR.Server.WebBase.pas',
  FHIR.Server.ClientCacheManager in 'FHIR.Server.ClientCacheManager.pas',
  FHIR.Tx.HGVS in 'FHIR.Tx.HGVS.pas';

begin
  ExecuteFhirServer;
end.


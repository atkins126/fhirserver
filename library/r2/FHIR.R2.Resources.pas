unit FHIR.R2.Resources;

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

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
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

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
{$I fhir.r2.inc}

interface

// FHIR v1.0.2 generated 2015-10-24T07:41:03+11:00

uses
  SysUtils, Classes,
  FHIR.Support.Base, FHIR.Support.Utilities, FHIR.Support.Stream,
  FHIR.Base.Objects, FHIR.Base.Utilities, FHIR.Base.Lang,
  FHIR.R2.Base, FHIR.R2.Types, FHIR.R2.Resources.Base,
  FHIR.R2.Resources.Canonical, FHIR.R2.Resources.Admin, FHIR.R2.Resources.Clinical, FHIR.R2.Resources.Other;

Type
  TFhirResourceClass = FHIR.R2.Resources.Base.TFhirResourceClass;
  TFhirResourceType = FHIR.R2.Resources.Base.TFhirResourceType;
  TFhirResourceTypeSet = FHIR.R2.Resources.Base.TFhirResourceTypeSet;
  TFhirResource = FHIR.R2.Resources.Base.TFhirResource;
  TFhirResourceList = FHIR.R2.Resources.Base.TFhirResourceList;
  TFhirDomainResource = FHIR.R2.Resources.Base.TFhirDomainResource;
  TFhirDomainResourceList = FHIR.R2.Resources.Base.TFhirDomainResourceList;
  TFHIRMetadataResource = FHIR.R2.Resources.Canonical.TFHIRMetadataResource;

{$IFDEF FHIR_PARAMETERS}
  TFhirParametersParameter = FHIR.R2.Resources.Other.TFhirParametersParameter;
  TFhirParametersParameterList = FHIR.R2.Resources.Other.TFhirParametersParameterList;
  TFhirParameters = FHIR.R2.Resources.Other.TFhirParameters;
  TFhirParametersList = FHIR.R2.Resources.Other.TFhirParametersList;
{$ENDIF FHIR_PARAMETERS}
{$IFDEF FHIR_ACCOUNT}
  TFhirAccount = FHIR.R2.Resources.Clinical.TFhirAccount;
  TFhirAccountList = FHIR.R2.Resources.Clinical.TFhirAccountList;
{$ENDIF FHIR_ACCOUNT}
{$IFDEF FHIR_ALLERGYINTOLERANCE}
  TFhirAllergyIntoleranceReaction = FHIR.R2.Resources.Clinical.TFhirAllergyIntoleranceReaction;
  TFhirAllergyIntoleranceReactionList = FHIR.R2.Resources.Clinical.TFhirAllergyIntoleranceReactionList;
  TFhirAllergyIntolerance = FHIR.R2.Resources.Clinical.TFhirAllergyIntolerance;
  TFhirAllergyIntoleranceList = FHIR.R2.Resources.Clinical.TFhirAllergyIntoleranceList;
{$ENDIF FHIR_ALLERGYINTOLERANCE}
{$IFDEF FHIR_APPOINTMENT}
  TFhirAppointmentParticipant = FHIR.R2.Resources.Clinical.TFhirAppointmentParticipant;
  TFhirAppointmentParticipantList = FHIR.R2.Resources.Clinical.TFhirAppointmentParticipantList;
  TFhirAppointment = FHIR.R2.Resources.Clinical.TFhirAppointment;
  TFhirAppointmentList = FHIR.R2.Resources.Clinical.TFhirAppointmentList;
{$ENDIF FHIR_APPOINTMENT}
{$IFDEF FHIR_APPOINTMENTRESPONSE}
  TFhirAppointmentResponse = FHIR.R2.Resources.Clinical.TFhirAppointmentResponse;
  TFhirAppointmentResponseList = FHIR.R2.Resources.Clinical.TFhirAppointmentResponseList;
{$ENDIF FHIR_APPOINTMENTRESPONSE}
{$IFDEF FHIR_AUDITEVENT}
  TFhirAuditEventEvent = FHIR.R2.Resources.Other.TFhirAuditEventEvent;
  TFhirAuditEventEventList = FHIR.R2.Resources.Other.TFhirAuditEventEventList;
  TFhirAuditEventParticipant = FHIR.R2.Resources.Other.TFhirAuditEventParticipant;
  TFhirAuditEventParticipantList = FHIR.R2.Resources.Other.TFhirAuditEventParticipantList;
  TFhirAuditEventParticipantNetwork = FHIR.R2.Resources.Other.TFhirAuditEventParticipantNetwork;
  TFhirAuditEventParticipantNetworkList = FHIR.R2.Resources.Other.TFhirAuditEventParticipantNetworkList;
  TFhirAuditEventSource = FHIR.R2.Resources.Other.TFhirAuditEventSource;
  TFhirAuditEventSourceList = FHIR.R2.Resources.Other.TFhirAuditEventSourceList;
  TFhirAuditEventObject = FHIR.R2.Resources.Other.TFhirAuditEventObject;
  TFhirAuditEventObjectList = FHIR.R2.Resources.Other.TFhirAuditEventObjectList;
  TFhirAuditEventObjectDetail = FHIR.R2.Resources.Other.TFhirAuditEventObjectDetail;
  TFhirAuditEventObjectDetailList = FHIR.R2.Resources.Other.TFhirAuditEventObjectDetailList;
  TFhirAuditEvent = FHIR.R2.Resources.Other.TFhirAuditEvent;
  TFhirAuditEventList = FHIR.R2.Resources.Other.TFhirAuditEventList;
{$ENDIF FHIR_AUDITEVENT}
{$IFDEF FHIR_BASIC}
  TFhirBasic = FHIR.R2.Resources.Clinical.TFhirBasic;
  TFhirBasicList = FHIR.R2.Resources.Clinical.TFhirBasicList;
{$ENDIF FHIR_BASIC}
{$IFDEF FHIR_BINARY}
  TFhirBinary = FHIR.R2.Resources.Other.TFhirBinary;
  TFhirBinaryList = FHIR.R2.Resources.Other.TFhirBinaryList;
{$ENDIF FHIR_BINARY}
{$IFDEF FHIR_BODYSITE}
  TFhirBodySite = FHIR.R2.Resources.Clinical.TFhirBodySite;
  TFhirBodySiteList = FHIR.R2.Resources.Clinical.TFhirBodySiteList;
{$ENDIF FHIR_BODYSITE}
{$IFDEF FHIR_BUNDLE}
  TFhirBundleLink = FHIR.R2.Resources.Other.TFhirBundleLink;
  TFhirBundleLinkList = FHIR.R2.Resources.Other.TFhirBundleLinkList;
  TFhirBundleEntry = FHIR.R2.Resources.Other.TFhirBundleEntry;
  TFhirBundleEntryList = FHIR.R2.Resources.Other.TFhirBundleEntryList;
  TFhirBundleEntrySearch = FHIR.R2.Resources.Other.TFhirBundleEntrySearch;
  TFhirBundleEntrySearchList = FHIR.R2.Resources.Other.TFhirBundleEntrySearchList;
  TFhirBundleEntryRequest = FHIR.R2.Resources.Other.TFhirBundleEntryRequest;
  TFhirBundleEntryRequestList = FHIR.R2.Resources.Other.TFhirBundleEntryRequestList;
  TFhirBundleEntryResponse = FHIR.R2.Resources.Other.TFhirBundleEntryResponse;
  TFhirBundleEntryResponseList = FHIR.R2.Resources.Other.TFhirBundleEntryResponseList;
  TFhirBundle = FHIR.R2.Resources.Other.TFhirBundle;
  TFhirBundleList = FHIR.R2.Resources.Other.TFhirBundleList;
{$ENDIF FHIR_BUNDLE}
{$IFDEF FHIR_CAREPLAN}
  TFhirCarePlanRelatedPlan = FHIR.R2.Resources.Clinical.TFhirCarePlanRelatedPlan;
  TFhirCarePlanRelatedPlanList = FHIR.R2.Resources.Clinical.TFhirCarePlanRelatedPlanList;
  TFhirCarePlanParticipant = FHIR.R2.Resources.Clinical.TFhirCarePlanParticipant;
  TFhirCarePlanParticipantList = FHIR.R2.Resources.Clinical.TFhirCarePlanParticipantList;
  TFhirCarePlanActivity = FHIR.R2.Resources.Clinical.TFhirCarePlanActivity;
  TFhirCarePlanActivityList = FHIR.R2.Resources.Clinical.TFhirCarePlanActivityList;
  TFhirCarePlanActivityDetail = FHIR.R2.Resources.Clinical.TFhirCarePlanActivityDetail;
  TFhirCarePlanActivityDetailList = FHIR.R2.Resources.Clinical.TFhirCarePlanActivityDetailList;
  TFhirCarePlan = FHIR.R2.Resources.Clinical.TFhirCarePlan;
  TFhirCarePlanList = FHIR.R2.Resources.Clinical.TFhirCarePlanList;
{$ENDIF FHIR_CAREPLAN}
{$IFDEF FHIR_CLAIM}
  TFhirClaimPayee = FHIR.R2.Resources.Other.TFhirClaimPayee;
  TFhirClaimPayeeList = FHIR.R2.Resources.Other.TFhirClaimPayeeList;
  TFhirClaimDiagnosis = FHIR.R2.Resources.Other.TFhirClaimDiagnosis;
  TFhirClaimDiagnosisList = FHIR.R2.Resources.Other.TFhirClaimDiagnosisList;
  TFhirClaimCoverage = FHIR.R2.Resources.Other.TFhirClaimCoverage;
  TFhirClaimCoverageList = FHIR.R2.Resources.Other.TFhirClaimCoverageList;
  TFhirClaimItem = FHIR.R2.Resources.Other.TFhirClaimItem;
  TFhirClaimItemList = FHIR.R2.Resources.Other.TFhirClaimItemList;
  TFhirClaimItemDetail = FHIR.R2.Resources.Other.TFhirClaimItemDetail;
  TFhirClaimItemDetailList = FHIR.R2.Resources.Other.TFhirClaimItemDetailList;
  TFhirClaimItemDetailSubDetail = FHIR.R2.Resources.Other.TFhirClaimItemDetailSubDetail;
  TFhirClaimItemDetailSubDetailList = FHIR.R2.Resources.Other.TFhirClaimItemDetailSubDetailList;
  TFhirClaimItemProsthesis = FHIR.R2.Resources.Other.TFhirClaimItemProsthesis;
  TFhirClaimItemProsthesisList = FHIR.R2.Resources.Other.TFhirClaimItemProsthesisList;
  TFhirClaimMissingTeeth = FHIR.R2.Resources.Other.TFhirClaimMissingTeeth;
  TFhirClaimMissingTeethList = FHIR.R2.Resources.Other.TFhirClaimMissingTeethList;
  TFhirClaim = FHIR.R2.Resources.Other.TFhirClaim;
  TFhirClaimList = FHIR.R2.Resources.Other.TFhirClaimList;
{$ENDIF FHIR_CLAIM}
{$IFDEF FHIR_CLAIMRESPONSE}
  TFhirClaimResponseItem = FHIR.R2.Resources.Other.TFhirClaimResponseItem;
  TFhirClaimResponseItemList = FHIR.R2.Resources.Other.TFhirClaimResponseItemList;
  TFhirClaimResponseItemAdjudication = FHIR.R2.Resources.Other.TFhirClaimResponseItemAdjudication;
  TFhirClaimResponseItemAdjudicationList = FHIR.R2.Resources.Other.TFhirClaimResponseItemAdjudicationList;
  TFhirClaimResponseItemDetail = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetail;
  TFhirClaimResponseItemDetailList = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetailList;
  TFhirClaimResponseItemDetailAdjudication = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetailAdjudication;
  TFhirClaimResponseItemDetailAdjudicationList = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetailAdjudicationList;
  TFhirClaimResponseItemDetailSubDetail = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetailSubDetail;
  TFhirClaimResponseItemDetailSubDetailList = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetailSubDetailList;
  TFhirClaimResponseItemDetailSubDetailAdjudication = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetailSubDetailAdjudication;
  TFhirClaimResponseItemDetailSubDetailAdjudicationList = FHIR.R2.Resources.Other.TFhirClaimResponseItemDetailSubDetailAdjudicationList;
  TFhirClaimResponseAddItem = FHIR.R2.Resources.Other.TFhirClaimResponseAddItem;
  TFhirClaimResponseAddItemList = FHIR.R2.Resources.Other.TFhirClaimResponseAddItemList;
  TFhirClaimResponseAddItemAdjudication = FHIR.R2.Resources.Other.TFhirClaimResponseAddItemAdjudication;
  TFhirClaimResponseAddItemAdjudicationList = FHIR.R2.Resources.Other.TFhirClaimResponseAddItemAdjudicationList;
  TFhirClaimResponseAddItemDetail = FHIR.R2.Resources.Other.TFhirClaimResponseAddItemDetail;
  TFhirClaimResponseAddItemDetailList = FHIR.R2.Resources.Other.TFhirClaimResponseAddItemDetailList;
  TFhirClaimResponseAddItemDetailAdjudication = FHIR.R2.Resources.Other.TFhirClaimResponseAddItemDetailAdjudication;
  TFhirClaimResponseAddItemDetailAdjudicationList = FHIR.R2.Resources.Other.TFhirClaimResponseAddItemDetailAdjudicationList;
  TFhirClaimResponseError = FHIR.R2.Resources.Other.TFhirClaimResponseError;
  TFhirClaimResponseErrorList = FHIR.R2.Resources.Other.TFhirClaimResponseErrorList;
  TFhirClaimResponseNote = FHIR.R2.Resources.Other.TFhirClaimResponseNote;
  TFhirClaimResponseNoteList = FHIR.R2.Resources.Other.TFhirClaimResponseNoteList;
  TFhirClaimResponseCoverage = FHIR.R2.Resources.Other.TFhirClaimResponseCoverage;
  TFhirClaimResponseCoverageList = FHIR.R2.Resources.Other.TFhirClaimResponseCoverageList;
  TFhirClaimResponse = FHIR.R2.Resources.Other.TFhirClaimResponse;
  TFhirClaimResponseList = FHIR.R2.Resources.Other.TFhirClaimResponseList;
{$ENDIF FHIR_CLAIMRESPONSE}
{$IFDEF FHIR_CLINICALIMPRESSION}
  TFhirClinicalImpressionInvestigations = FHIR.R2.Resources.Clinical.TFhirClinicalImpressionInvestigations;
  TFhirClinicalImpressionInvestigationsList = FHIR.R2.Resources.Clinical.TFhirClinicalImpressionInvestigationsList;
  TFhirClinicalImpressionFinding = FHIR.R2.Resources.Clinical.TFhirClinicalImpressionFinding;
  TFhirClinicalImpressionFindingList = FHIR.R2.Resources.Clinical.TFhirClinicalImpressionFindingList;
  TFhirClinicalImpressionRuledOut = FHIR.R2.Resources.Clinical.TFhirClinicalImpressionRuledOut;
  TFhirClinicalImpressionRuledOutList = FHIR.R2.Resources.Clinical.TFhirClinicalImpressionRuledOutList;
  TFhirClinicalImpression = FHIR.R2.Resources.Clinical.TFhirClinicalImpression;
  TFhirClinicalImpressionList = FHIR.R2.Resources.Clinical.TFhirClinicalImpressionList;
{$ENDIF FHIR_CLINICALIMPRESSION}
{$IFDEF FHIR_COMMUNICATION}
  TFhirCommunicationPayload = FHIR.R2.Resources.Clinical.TFhirCommunicationPayload;
  TFhirCommunicationPayloadList = FHIR.R2.Resources.Clinical.TFhirCommunicationPayloadList;
  TFhirCommunication = FHIR.R2.Resources.Clinical.TFhirCommunication;
  TFhirCommunicationList = FHIR.R2.Resources.Clinical.TFhirCommunicationList;
{$ENDIF FHIR_COMMUNICATION}
{$IFDEF FHIR_COMMUNICATIONREQUEST}
  TFhirCommunicationRequestPayload = FHIR.R2.Resources.Clinical.TFhirCommunicationRequestPayload;
  TFhirCommunicationRequestPayloadList = FHIR.R2.Resources.Clinical.TFhirCommunicationRequestPayloadList;
  TFhirCommunicationRequest = FHIR.R2.Resources.Clinical.TFhirCommunicationRequest;
  TFhirCommunicationRequestList = FHIR.R2.Resources.Clinical.TFhirCommunicationRequestList;
{$ENDIF FHIR_COMMUNICATIONREQUEST}
{$IFDEF FHIR_COMPOSITION}
  TFhirCompositionAttester = FHIR.R2.Resources.Clinical.TFhirCompositionAttester;
  TFhirCompositionAttesterList = FHIR.R2.Resources.Clinical.TFhirCompositionAttesterList;
  TFhirCompositionEvent = FHIR.R2.Resources.Clinical.TFhirCompositionEvent;
  TFhirCompositionEventList = FHIR.R2.Resources.Clinical.TFhirCompositionEventList;
  TFhirCompositionSection = FHIR.R2.Resources.Clinical.TFhirCompositionSection;
  TFhirCompositionSectionList = FHIR.R2.Resources.Clinical.TFhirCompositionSectionList;
  TFhirComposition = FHIR.R2.Resources.Clinical.TFhirComposition;
  TFhirCompositionList = FHIR.R2.Resources.Clinical.TFhirCompositionList;
{$ENDIF FHIR_COMPOSITION}
{$IFDEF FHIR_CONCEPTMAP}
  TFhirConceptMapContact = FHIR.R2.Resources.Canonical.TFhirConceptMapContact;
  TFhirConceptMapContactList = FHIR.R2.Resources.Canonical.TFhirConceptMapContactList;
  TFhirConceptMapElement = FHIR.R2.Resources.Canonical.TFhirConceptMapElement;
  TFhirConceptMapElementList = FHIR.R2.Resources.Canonical.TFhirConceptMapElementList;
  TFhirConceptMapElementTarget = FHIR.R2.Resources.Canonical.TFhirConceptMapElementTarget;
  TFhirConceptMapElementTargetList = FHIR.R2.Resources.Canonical.TFhirConceptMapElementTargetList;
  TFhirConceptMapElementTargetDependsOn = FHIR.R2.Resources.Canonical.TFhirConceptMapElementTargetDependsOn;
  TFhirConceptMapElementTargetDependsOnList = FHIR.R2.Resources.Canonical.TFhirConceptMapElementTargetDependsOnList;
  TFhirConceptMap = FHIR.R2.Resources.Canonical.TFhirConceptMap;
  TFhirConceptMapList = FHIR.R2.Resources.Canonical.TFhirConceptMapList;
{$ENDIF FHIR_CONCEPTMAP}
{$IFDEF FHIR_CONDITION}
  TFhirConditionStage = FHIR.R2.Resources.Clinical.TFhirConditionStage;
  TFhirConditionStageList = FHIR.R2.Resources.Clinical.TFhirConditionStageList;
  TFhirConditionEvidence = FHIR.R2.Resources.Clinical.TFhirConditionEvidence;
  TFhirConditionEvidenceList = FHIR.R2.Resources.Clinical.TFhirConditionEvidenceList;
  TFhirCondition = FHIR.R2.Resources.Clinical.TFhirCondition;
  TFhirConditionList = FHIR.R2.Resources.Clinical.TFhirConditionList;
{$ENDIF FHIR_CONDITION}
{$IFDEF FHIR_CONFORMANCE}
  TFhirConformanceContact = FHIR.R2.Resources.Canonical.TFhirConformanceContact;
  TFhirConformanceContactList = FHIR.R2.Resources.Canonical.TFhirConformanceContactList;
  TFhirConformanceSoftware = FHIR.R2.Resources.Canonical.TFhirConformanceSoftware;
  TFhirConformanceSoftwareList = FHIR.R2.Resources.Canonical.TFhirConformanceSoftwareList;
  TFhirConformanceImplementation = FHIR.R2.Resources.Canonical.TFhirConformanceImplementation;
  TFhirConformanceImplementationList = FHIR.R2.Resources.Canonical.TFhirConformanceImplementationList;
  TFhirConformanceRest = FHIR.R2.Resources.Canonical.TFhirConformanceRest;
  TFhirConformanceRestList = FHIR.R2.Resources.Canonical.TFhirConformanceRestList;
  TFhirConformanceRestSecurity = FHIR.R2.Resources.Canonical.TFhirConformanceRestSecurity;
  TFhirConformanceRestSecurityList = FHIR.R2.Resources.Canonical.TFhirConformanceRestSecurityList;
  TFhirConformanceRestSecurityCertificate = FHIR.R2.Resources.Canonical.TFhirConformanceRestSecurityCertificate;
  TFhirConformanceRestSecurityCertificateList = FHIR.R2.Resources.Canonical.TFhirConformanceRestSecurityCertificateList;
  TFhirConformanceRestResource = FHIR.R2.Resources.Canonical.TFhirConformanceRestResource;
  TFhirConformanceRestResourceList = FHIR.R2.Resources.Canonical.TFhirConformanceRestResourceList;
  TFhirConformanceRestResourceInteraction = FHIR.R2.Resources.Canonical.TFhirConformanceRestResourceInteraction;
  TFhirConformanceRestResourceInteractionList = FHIR.R2.Resources.Canonical.TFhirConformanceRestResourceInteractionList;
  TFhirConformanceRestResourceSearchParam = FHIR.R2.Resources.Canonical.TFhirConformanceRestResourceSearchParam;
  TFhirConformanceRestResourceSearchParamList = FHIR.R2.Resources.Canonical.TFhirConformanceRestResourceSearchParamList;
  TFhirConformanceRestInteraction = FHIR.R2.Resources.Canonical.TFhirConformanceRestInteraction;
  TFhirConformanceRestInteractionList = FHIR.R2.Resources.Canonical.TFhirConformanceRestInteractionList;
  TFhirConformanceRestOperation = FHIR.R2.Resources.Canonical.TFhirConformanceRestOperation;
  TFhirConformanceRestOperationList = FHIR.R2.Resources.Canonical.TFhirConformanceRestOperationList;
  TFhirConformanceMessaging = FHIR.R2.Resources.Canonical.TFhirConformanceMessaging;
  TFhirConformanceMessagingList = FHIR.R2.Resources.Canonical.TFhirConformanceMessagingList;
  TFhirConformanceMessagingEndpoint = FHIR.R2.Resources.Canonical.TFhirConformanceMessagingEndpoint;
  TFhirConformanceMessagingEndpointList = FHIR.R2.Resources.Canonical.TFhirConformanceMessagingEndpointList;
  TFhirConformanceMessagingEvent = FHIR.R2.Resources.Canonical.TFhirConformanceMessagingEvent;
  TFhirConformanceMessagingEventList = FHIR.R2.Resources.Canonical.TFhirConformanceMessagingEventList;
  TFhirConformanceDocument = FHIR.R2.Resources.Canonical.TFhirConformanceDocument;
  TFhirConformanceDocumentList = FHIR.R2.Resources.Canonical.TFhirConformanceDocumentList;
  TFhirConformance = FHIR.R2.Resources.Canonical.TFhirConformance;
  TFhirConformanceList = FHIR.R2.Resources.Canonical.TFhirConformanceList;
{$ENDIF FHIR_CONFORMANCE}
{$IFDEF FHIR_CONTRACT}
  TFhirContractActor = FHIR.R2.Resources.Other.TFhirContractActor;
  TFhirContractActorList = FHIR.R2.Resources.Other.TFhirContractActorList;
  TFhirContractValuedItem = FHIR.R2.Resources.Other.TFhirContractValuedItem;
  TFhirContractValuedItemList = FHIR.R2.Resources.Other.TFhirContractValuedItemList;
  TFhirContractSigner = FHIR.R2.Resources.Other.TFhirContractSigner;
  TFhirContractSignerList = FHIR.R2.Resources.Other.TFhirContractSignerList;
  TFhirContractTerm = FHIR.R2.Resources.Other.TFhirContractTerm;
  TFhirContractTermList = FHIR.R2.Resources.Other.TFhirContractTermList;
  TFhirContractTermActor = FHIR.R2.Resources.Other.TFhirContractTermActor;
  TFhirContractTermActorList = FHIR.R2.Resources.Other.TFhirContractTermActorList;
  TFhirContractTermValuedItem = FHIR.R2.Resources.Other.TFhirContractTermValuedItem;
  TFhirContractTermValuedItemList = FHIR.R2.Resources.Other.TFhirContractTermValuedItemList;
  TFhirContractFriendly = FHIR.R2.Resources.Other.TFhirContractFriendly;
  TFhirContractFriendlyList = FHIR.R2.Resources.Other.TFhirContractFriendlyList;
  TFhirContractLegal = FHIR.R2.Resources.Other.TFhirContractLegal;
  TFhirContractLegalList = FHIR.R2.Resources.Other.TFhirContractLegalList;
  TFhirContractRule = FHIR.R2.Resources.Other.TFhirContractRule;
  TFhirContractRuleList = FHIR.R2.Resources.Other.TFhirContractRuleList;
  TFhirContract = FHIR.R2.Resources.Other.TFhirContract;
  TFhirContractList = FHIR.R2.Resources.Other.TFhirContractList;
{$ENDIF FHIR_CONTRACT}
{$IFDEF FHIR_COVERAGE}
  TFhirCoverage = FHIR.R2.Resources.Clinical.TFhirCoverage;
  TFhirCoverageList = FHIR.R2.Resources.Clinical.TFhirCoverageList;
{$ENDIF FHIR_COVERAGE}
{$IFDEF FHIR_DATAELEMENT}
  TFhirDataElementContact = FHIR.R2.Resources.Canonical.TFhirDataElementContact;
  TFhirDataElementContactList = FHIR.R2.Resources.Canonical.TFhirDataElementContactList;
  TFhirDataElementMapping = FHIR.R2.Resources.Canonical.TFhirDataElementMapping;
  TFhirDataElementMappingList = FHIR.R2.Resources.Canonical.TFhirDataElementMappingList;
  TFhirDataElement = FHIR.R2.Resources.Canonical.TFhirDataElement;
  TFhirDataElementList = FHIR.R2.Resources.Canonical.TFhirDataElementList;
{$ENDIF FHIR_DATAELEMENT}
{$IFDEF FHIR_DETECTEDISSUE}
  TFhirDetectedIssueMitigation = FHIR.R2.Resources.Clinical.TFhirDetectedIssueMitigation;
  TFhirDetectedIssueMitigationList = FHIR.R2.Resources.Clinical.TFhirDetectedIssueMitigationList;
  TFhirDetectedIssue = FHIR.R2.Resources.Clinical.TFhirDetectedIssue;
  TFhirDetectedIssueList = FHIR.R2.Resources.Clinical.TFhirDetectedIssueList;
{$ENDIF FHIR_DETECTEDISSUE}
{$IFDEF FHIR_DEVICE}
  TFhirDevice = FHIR.R2.Resources.Admin.TFhirDevice;
  TFhirDeviceList = FHIR.R2.Resources.Admin.TFhirDeviceList;
{$ENDIF FHIR_DEVICE}
{$IFDEF FHIR_DEVICECOMPONENT}
  TFhirDeviceComponentProductionSpecification = FHIR.R2.Resources.Admin.TFhirDeviceComponentProductionSpecification;
  TFhirDeviceComponentProductionSpecificationList = FHIR.R2.Resources.Admin.TFhirDeviceComponentProductionSpecificationList;
  TFhirDeviceComponent = FHIR.R2.Resources.Admin.TFhirDeviceComponent;
  TFhirDeviceComponentList = FHIR.R2.Resources.Admin.TFhirDeviceComponentList;
{$ENDIF FHIR_DEVICECOMPONENT}
{$IFDEF FHIR_DEVICEMETRIC}
  TFhirDeviceMetricCalibration = FHIR.R2.Resources.Admin.TFhirDeviceMetricCalibration;
  TFhirDeviceMetricCalibrationList = FHIR.R2.Resources.Admin.TFhirDeviceMetricCalibrationList;
  TFhirDeviceMetric = FHIR.R2.Resources.Admin.TFhirDeviceMetric;
  TFhirDeviceMetricList = FHIR.R2.Resources.Admin.TFhirDeviceMetricList;
{$ENDIF FHIR_DEVICEMETRIC}
{$IFDEF FHIR_DEVICEUSEREQUEST}
  TFhirDeviceUseRequest = FHIR.R2.Resources.Clinical.TFhirDeviceUseRequest;
  TFhirDeviceUseRequestList = FHIR.R2.Resources.Clinical.TFhirDeviceUseRequestList;
{$ENDIF FHIR_DEVICEUSEREQUEST}
{$IFDEF FHIR_DEVICEUSESTATEMENT}
  TFhirDeviceUseStatement = FHIR.R2.Resources.Clinical.TFhirDeviceUseStatement;
  TFhirDeviceUseStatementList = FHIR.R2.Resources.Clinical.TFhirDeviceUseStatementList;
{$ENDIF FHIR_DEVICEUSESTATEMENT}
{$IFDEF FHIR_DIAGNOSTICORDER}
  TFhirDiagnosticOrderEvent = FHIR.R2.Resources.Clinical.TFhirDiagnosticOrderEvent;
  TFhirDiagnosticOrderEventList = FHIR.R2.Resources.Clinical.TFhirDiagnosticOrderEventList;
  TFhirDiagnosticOrderItem = FHIR.R2.Resources.Clinical.TFhirDiagnosticOrderItem;
  TFhirDiagnosticOrderItemList = FHIR.R2.Resources.Clinical.TFhirDiagnosticOrderItemList;
  TFhirDiagnosticOrder = FHIR.R2.Resources.Clinical.TFhirDiagnosticOrder;
  TFhirDiagnosticOrderList = FHIR.R2.Resources.Clinical.TFhirDiagnosticOrderList;
{$ENDIF FHIR_DIAGNOSTICORDER}
{$IFDEF FHIR_DIAGNOSTICREPORT}
  TFhirDiagnosticReportImage = FHIR.R2.Resources.Clinical.TFhirDiagnosticReportImage;
  TFhirDiagnosticReportImageList = FHIR.R2.Resources.Clinical.TFhirDiagnosticReportImageList;
  TFhirDiagnosticReport = FHIR.R2.Resources.Clinical.TFhirDiagnosticReport;
  TFhirDiagnosticReportList = FHIR.R2.Resources.Clinical.TFhirDiagnosticReportList;
{$ENDIF FHIR_DIAGNOSTICREPORT}
{$IFDEF FHIR_DOCUMENTMANIFEST}
  TFhirDocumentManifestContent = FHIR.R2.Resources.Clinical.TFhirDocumentManifestContent;
  TFhirDocumentManifestContentList = FHIR.R2.Resources.Clinical.TFhirDocumentManifestContentList;
  TFhirDocumentManifestRelated = FHIR.R2.Resources.Clinical.TFhirDocumentManifestRelated;
  TFhirDocumentManifestRelatedList = FHIR.R2.Resources.Clinical.TFhirDocumentManifestRelatedList;
  TFhirDocumentManifest = FHIR.R2.Resources.Clinical.TFhirDocumentManifest;
  TFhirDocumentManifestList = FHIR.R2.Resources.Clinical.TFhirDocumentManifestList;
{$ENDIF FHIR_DOCUMENTMANIFEST}
{$IFDEF FHIR_DOCUMENTREFERENCE}
  TFhirDocumentReferenceRelatesTo = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceRelatesTo;
  TFhirDocumentReferenceRelatesToList = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceRelatesToList;
  TFhirDocumentReferenceContent = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceContent;
  TFhirDocumentReferenceContentList = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceContentList;
  TFhirDocumentReferenceContext = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceContext;
  TFhirDocumentReferenceContextList = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceContextList;
  TFhirDocumentReferenceContextRelated = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceContextRelated;
  TFhirDocumentReferenceContextRelatedList = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceContextRelatedList;
  TFhirDocumentReference = FHIR.R2.Resources.Clinical.TFhirDocumentReference;
  TFhirDocumentReferenceList = FHIR.R2.Resources.Clinical.TFhirDocumentReferenceList;
{$ENDIF FHIR_DOCUMENTREFERENCE}
{$IFDEF FHIR_ELIGIBILITYREQUEST}
  TFhirEligibilityRequest = FHIR.R2.Resources.Other.TFhirEligibilityRequest;
  TFhirEligibilityRequestList = FHIR.R2.Resources.Other.TFhirEligibilityRequestList;
{$ENDIF FHIR_ELIGIBILITYREQUEST}
{$IFDEF FHIR_ELIGIBILITYRESPONSE}
  TFhirEligibilityResponse = FHIR.R2.Resources.Other.TFhirEligibilityResponse;
  TFhirEligibilityResponseList = FHIR.R2.Resources.Other.TFhirEligibilityResponseList;
{$ENDIF FHIR_ELIGIBILITYRESPONSE}
{$IFDEF FHIR_ENCOUNTER}
  TFhirEncounterStatusHistory = FHIR.R2.Resources.Admin.TFhirEncounterStatusHistory;
  TFhirEncounterStatusHistoryList = FHIR.R2.Resources.Admin.TFhirEncounterStatusHistoryList;
  TFhirEncounterParticipant = FHIR.R2.Resources.Admin.TFhirEncounterParticipant;
  TFhirEncounterParticipantList = FHIR.R2.Resources.Admin.TFhirEncounterParticipantList;
  TFhirEncounterHospitalization = FHIR.R2.Resources.Admin.TFhirEncounterHospitalization;
  TFhirEncounterHospitalizationList = FHIR.R2.Resources.Admin.TFhirEncounterHospitalizationList;
  TFhirEncounterLocation = FHIR.R2.Resources.Admin.TFhirEncounterLocation;
  TFhirEncounterLocationList = FHIR.R2.Resources.Admin.TFhirEncounterLocationList;
  TFhirEncounter = FHIR.R2.Resources.Admin.TFhirEncounter;
  TFhirEncounterList = FHIR.R2.Resources.Admin.TFhirEncounterList;
{$ENDIF FHIR_ENCOUNTER}
{$IFDEF FHIR_ENROLLMENTREQUEST}
  TFhirEnrollmentRequest = FHIR.R2.Resources.Other.TFhirEnrollmentRequest;
  TFhirEnrollmentRequestList = FHIR.R2.Resources.Other.TFhirEnrollmentRequestList;
{$ENDIF FHIR_ENROLLMENTREQUEST}
{$IFDEF FHIR_ENROLLMENTRESPONSE}
  TFhirEnrollmentResponse = FHIR.R2.Resources.Other.TFhirEnrollmentResponse;
  TFhirEnrollmentResponseList = FHIR.R2.Resources.Other.TFhirEnrollmentResponseList;
{$ENDIF FHIR_ENROLLMENTRESPONSE}
{$IFDEF FHIR_EPISODEOFCARE}
  TFhirEpisodeOfCareStatusHistory = FHIR.R2.Resources.Admin.TFhirEpisodeOfCareStatusHistory;
  TFhirEpisodeOfCareStatusHistoryList = FHIR.R2.Resources.Admin.TFhirEpisodeOfCareStatusHistoryList;
  TFhirEpisodeOfCareCareTeam = FHIR.R2.Resources.Admin.TFhirEpisodeOfCareCareTeam;
  TFhirEpisodeOfCareCareTeamList = FHIR.R2.Resources.Admin.TFhirEpisodeOfCareCareTeamList;
  TFhirEpisodeOfCare = FHIR.R2.Resources.Admin.TFhirEpisodeOfCare;
  TFhirEpisodeOfCareList = FHIR.R2.Resources.Admin.TFhirEpisodeOfCareList;
{$ENDIF FHIR_EPISODEOFCARE}
{$IFDEF FHIR_EXPLANATIONOFBENEFIT}
  TFhirExplanationOfBenefit = FHIR.R2.Resources.Other.TFhirExplanationOfBenefit;
  TFhirExplanationOfBenefitList = FHIR.R2.Resources.Other.TFhirExplanationOfBenefitList;
{$ENDIF FHIR_EXPLANATIONOFBENEFIT}
{$IFDEF FHIR_FAMILYMEMBERHISTORY}
  TFhirFamilyMemberHistoryCondition = FHIR.R2.Resources.Clinical.TFhirFamilyMemberHistoryCondition;
  TFhirFamilyMemberHistoryConditionList = FHIR.R2.Resources.Clinical.TFhirFamilyMemberHistoryConditionList;
  TFhirFamilyMemberHistory = FHIR.R2.Resources.Clinical.TFhirFamilyMemberHistory;
  TFhirFamilyMemberHistoryList = FHIR.R2.Resources.Clinical.TFhirFamilyMemberHistoryList;
{$ENDIF FHIR_FAMILYMEMBERHISTORY}
{$IFDEF FHIR_FLAG}
  TFhirFlag = FHIR.R2.Resources.Clinical.TFhirFlag;
  TFhirFlagList = FHIR.R2.Resources.Clinical.TFhirFlagList;
{$ENDIF FHIR_FLAG}
{$IFDEF FHIR_GOAL}
  TFhirGoalOutcome = FHIR.R2.Resources.Clinical.TFhirGoalOutcome;
  TFhirGoalOutcomeList = FHIR.R2.Resources.Clinical.TFhirGoalOutcomeList;
  TFhirGoal = FHIR.R2.Resources.Clinical.TFhirGoal;
  TFhirGoalList = FHIR.R2.Resources.Clinical.TFhirGoalList;
{$ENDIF FHIR_GOAL}
{$IFDEF FHIR_GROUP}
  TFhirGroupCharacteristic = FHIR.R2.Resources.Admin.TFhirGroupCharacteristic;
  TFhirGroupCharacteristicList = FHIR.R2.Resources.Admin.TFhirGroupCharacteristicList;
  TFhirGroupMember = FHIR.R2.Resources.Admin.TFhirGroupMember;
  TFhirGroupMemberList = FHIR.R2.Resources.Admin.TFhirGroupMemberList;
  TFhirGroup = FHIR.R2.Resources.Admin.TFhirGroup;
  TFhirGroupList = FHIR.R2.Resources.Admin.TFhirGroupList;
{$ENDIF FHIR_GROUP}
{$IFDEF FHIR_HEALTHCARESERVICE}
  TFhirHealthcareServiceServiceType = FHIR.R2.Resources.Admin.TFhirHealthcareServiceServiceType;
  TFhirHealthcareServiceServiceTypeList = FHIR.R2.Resources.Admin.TFhirHealthcareServiceServiceTypeList;
  TFhirHealthcareServiceAvailableTime = FHIR.R2.Resources.Admin.TFhirHealthcareServiceAvailableTime;
  TFhirHealthcareServiceAvailableTimeList = FHIR.R2.Resources.Admin.TFhirHealthcareServiceAvailableTimeList;
  TFhirHealthcareServiceNotAvailable = FHIR.R2.Resources.Admin.TFhirHealthcareServiceNotAvailable;
  TFhirHealthcareServiceNotAvailableList = FHIR.R2.Resources.Admin.TFhirHealthcareServiceNotAvailableList;
  TFhirHealthcareService = FHIR.R2.Resources.Admin.TFhirHealthcareService;
  TFhirHealthcareServiceList = FHIR.R2.Resources.Admin.TFhirHealthcareServiceList;
{$ENDIF FHIR_HEALTHCARESERVICE}
{$IFDEF FHIR_IMAGINGOBJECTSELECTION}
  TFhirImagingObjectSelectionStudy = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudy;
  TFhirImagingObjectSelectionStudyList = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudyList;
  TFhirImagingObjectSelectionStudySeries = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudySeries;
  TFhirImagingObjectSelectionStudySeriesList = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudySeriesList;
  TFhirImagingObjectSelectionStudySeriesInstance = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudySeriesInstance;
  TFhirImagingObjectSelectionStudySeriesInstanceList = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudySeriesInstanceList;
  TFhirImagingObjectSelectionStudySeriesInstanceFrames = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudySeriesInstanceFrames;
  TFhirImagingObjectSelectionStudySeriesInstanceFramesList = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionStudySeriesInstanceFramesList;
  TFhirImagingObjectSelection = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelection;
  TFhirImagingObjectSelectionList = FHIR.R2.Resources.Clinical.TFhirImagingObjectSelectionList;
{$ENDIF FHIR_IMAGINGOBJECTSELECTION}
{$IFDEF FHIR_IMAGINGSTUDY}
  TFhirImagingStudySeries = FHIR.R2.Resources.Clinical.TFhirImagingStudySeries;
  TFhirImagingStudySeriesList = FHIR.R2.Resources.Clinical.TFhirImagingStudySeriesList;
  TFhirImagingStudySeriesInstance = FHIR.R2.Resources.Clinical.TFhirImagingStudySeriesInstance;
  TFhirImagingStudySeriesInstanceList = FHIR.R2.Resources.Clinical.TFhirImagingStudySeriesInstanceList;
  TFhirImagingStudy = FHIR.R2.Resources.Clinical.TFhirImagingStudy;
  TFhirImagingStudyList = FHIR.R2.Resources.Clinical.TFhirImagingStudyList;
{$ENDIF FHIR_IMAGINGSTUDY}
{$IFDEF FHIR_IMMUNIZATION}
  TFhirImmunizationExplanation = FHIR.R2.Resources.Clinical.TFhirImmunizationExplanation;
  TFhirImmunizationExplanationList = FHIR.R2.Resources.Clinical.TFhirImmunizationExplanationList;
  TFhirImmunizationReaction = FHIR.R2.Resources.Clinical.TFhirImmunizationReaction;
  TFhirImmunizationReactionList = FHIR.R2.Resources.Clinical.TFhirImmunizationReactionList;
  TFhirImmunizationVaccinationProtocol = FHIR.R2.Resources.Clinical.TFhirImmunizationVaccinationProtocol;
  TFhirImmunizationVaccinationProtocolList = FHIR.R2.Resources.Clinical.TFhirImmunizationVaccinationProtocolList;
  TFhirImmunization = FHIR.R2.Resources.Clinical.TFhirImmunization;
  TFhirImmunizationList = FHIR.R2.Resources.Clinical.TFhirImmunizationList;
{$ENDIF FHIR_IMMUNIZATION}
{$IFDEF FHIR_IMMUNIZATIONRECOMMENDATION}
  TFhirImmunizationRecommendationRecommendation = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendationRecommendation;
  TFhirImmunizationRecommendationRecommendationList = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendationRecommendationList;
  TFhirImmunizationRecommendationRecommendationDateCriterion = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendationRecommendationDateCriterion;
  TFhirImmunizationRecommendationRecommendationDateCriterionList = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendationRecommendationDateCriterionList;
  TFhirImmunizationRecommendationRecommendationProtocol = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendationRecommendationProtocol;
  TFhirImmunizationRecommendationRecommendationProtocolList = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendationRecommendationProtocolList;
  TFhirImmunizationRecommendation = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendation;
  TFhirImmunizationRecommendationList = FHIR.R2.Resources.Clinical.TFhirImmunizationRecommendationList;
{$ENDIF FHIR_IMMUNIZATIONRECOMMENDATION}
{$IFDEF FHIR_IMPLEMENTATIONGUIDE}
  TFhirImplementationGuideContact = FHIR.R2.Resources.Canonical.TFhirImplementationGuideContact;
  TFhirImplementationGuideContactList = FHIR.R2.Resources.Canonical.TFhirImplementationGuideContactList;
  TFhirImplementationGuideDependency = FHIR.R2.Resources.Canonical.TFhirImplementationGuideDependency;
  TFhirImplementationGuideDependencyList = FHIR.R2.Resources.Canonical.TFhirImplementationGuideDependencyList;
  TFhirImplementationGuidePackage = FHIR.R2.Resources.Canonical.TFhirImplementationGuidePackage;
  TFhirImplementationGuidePackageList = FHIR.R2.Resources.Canonical.TFhirImplementationGuidePackageList;
  TFhirImplementationGuidePackageResource = FHIR.R2.Resources.Canonical.TFhirImplementationGuidePackageResource;
  TFhirImplementationGuidePackageResourceList = FHIR.R2.Resources.Canonical.TFhirImplementationGuidePackageResourceList;
  TFhirImplementationGuideGlobal = FHIR.R2.Resources.Canonical.TFhirImplementationGuideGlobal;
  TFhirImplementationGuideGlobalList = FHIR.R2.Resources.Canonical.TFhirImplementationGuideGlobalList;
  TFhirImplementationGuidePage = FHIR.R2.Resources.Canonical.TFhirImplementationGuidePage;
  TFhirImplementationGuidePageList = FHIR.R2.Resources.Canonical.TFhirImplementationGuidePageList;
  TFhirImplementationGuide = FHIR.R2.Resources.Canonical.TFhirImplementationGuide;
  TFhirImplementationGuideList = FHIR.R2.Resources.Canonical.TFhirImplementationGuideList;
{$ENDIF FHIR_IMPLEMENTATIONGUIDE}
{$IFDEF FHIR_LIST}
  TFhirListEntry = FHIR.R2.Resources.Other.TFhirListEntry;
  TFhirListEntryList = FHIR.R2.Resources.Other.TFhirListEntryList;
  TFhirList = FHIR.R2.Resources.Other.TFhirList;
  TFhirListList = FHIR.R2.Resources.Other.TFhirListList;
{$ENDIF FHIR_LIST}
{$IFDEF FHIR_LOCATION}
  TFhirLocationPosition = FHIR.R2.Resources.Admin.TFhirLocationPosition;
  TFhirLocationPositionList = FHIR.R2.Resources.Admin.TFhirLocationPositionList;
  TFhirLocation = FHIR.R2.Resources.Admin.TFhirLocation;
  TFhirLocationList = FHIR.R2.Resources.Admin.TFhirLocationList;
{$ENDIF FHIR_LOCATION}
{$IFDEF FHIR_MEDIA}
  TFhirMedia = FHIR.R2.Resources.Clinical.TFhirMedia;
  TFhirMediaList = FHIR.R2.Resources.Clinical.TFhirMediaList;
{$ENDIF FHIR_MEDIA}
{$IFDEF FHIR_MEDICATION}
  TFhirMedicationProduct = FHIR.R2.Resources.Other.TFhirMedicationProduct;
  TFhirMedicationProductList = FHIR.R2.Resources.Other.TFhirMedicationProductList;
  TFhirMedicationProductIngredient = FHIR.R2.Resources.Other.TFhirMedicationProductIngredient;
  TFhirMedicationProductIngredientList = FHIR.R2.Resources.Other.TFhirMedicationProductIngredientList;
  TFhirMedicationProductBatch = FHIR.R2.Resources.Other.TFhirMedicationProductBatch;
  TFhirMedicationProductBatchList = FHIR.R2.Resources.Other.TFhirMedicationProductBatchList;
  TFhirMedicationPackage = FHIR.R2.Resources.Other.TFhirMedicationPackage;
  TFhirMedicationPackageList = FHIR.R2.Resources.Other.TFhirMedicationPackageList;
  TFhirMedicationPackageContent = FHIR.R2.Resources.Other.TFhirMedicationPackageContent;
  TFhirMedicationPackageContentList = FHIR.R2.Resources.Other.TFhirMedicationPackageContentList;
  TFhirMedication = FHIR.R2.Resources.Other.TFhirMedication;
  TFhirMedicationList = FHIR.R2.Resources.Other.TFhirMedicationList;
{$ENDIF FHIR_MEDICATION}
{$IFDEF FHIR_MEDICATIONADMINISTRATION}
  TFhirMedicationAdministrationDosage = FHIR.R2.Resources.Clinical.TFhirMedicationAdministrationDosage;
  TFhirMedicationAdministrationDosageList = FHIR.R2.Resources.Clinical.TFhirMedicationAdministrationDosageList;
  TFhirMedicationAdministration = FHIR.R2.Resources.Clinical.TFhirMedicationAdministration;
  TFhirMedicationAdministrationList = FHIR.R2.Resources.Clinical.TFhirMedicationAdministrationList;
{$ENDIF FHIR_MEDICATIONADMINISTRATION}
{$IFDEF FHIR_MEDICATIONDISPENSE}
  TFhirMedicationDispenseDosageInstruction = FHIR.R2.Resources.Clinical.TFhirMedicationDispenseDosageInstruction;
  TFhirMedicationDispenseDosageInstructionList = FHIR.R2.Resources.Clinical.TFhirMedicationDispenseDosageInstructionList;
  TFhirMedicationDispenseSubstitution = FHIR.R2.Resources.Clinical.TFhirMedicationDispenseSubstitution;
  TFhirMedicationDispenseSubstitutionList = FHIR.R2.Resources.Clinical.TFhirMedicationDispenseSubstitutionList;
  TFhirMedicationDispense = FHIR.R2.Resources.Clinical.TFhirMedicationDispense;
  TFhirMedicationDispenseList = FHIR.R2.Resources.Clinical.TFhirMedicationDispenseList;
{$ENDIF FHIR_MEDICATIONDISPENSE}
{$IFDEF FHIR_MEDICATIONORDER}
  TFhirMedicationOrderDosageInstruction = FHIR.R2.Resources.Clinical.TFhirMedicationOrderDosageInstruction;
  TFhirMedicationOrderDosageInstructionList = FHIR.R2.Resources.Clinical.TFhirMedicationOrderDosageInstructionList;
  TFhirMedicationOrderDispenseRequest = FHIR.R2.Resources.Clinical.TFhirMedicationOrderDispenseRequest;
  TFhirMedicationOrderDispenseRequestList = FHIR.R2.Resources.Clinical.TFhirMedicationOrderDispenseRequestList;
  TFhirMedicationOrderSubstitution = FHIR.R2.Resources.Clinical.TFhirMedicationOrderSubstitution;
  TFhirMedicationOrderSubstitutionList = FHIR.R2.Resources.Clinical.TFhirMedicationOrderSubstitutionList;
  TFhirMedicationOrder = FHIR.R2.Resources.Clinical.TFhirMedicationOrder;
  TFhirMedicationOrderList = FHIR.R2.Resources.Clinical.TFhirMedicationOrderList;
{$ENDIF FHIR_MEDICATIONORDER}
{$IFDEF FHIR_MEDICATIONSTATEMENT}
  TFhirMedicationStatementDosage = FHIR.R2.Resources.Clinical.TFhirMedicationStatementDosage;
  TFhirMedicationStatementDosageList = FHIR.R2.Resources.Clinical.TFhirMedicationStatementDosageList;
  TFhirMedicationStatement = FHIR.R2.Resources.Clinical.TFhirMedicationStatement;
  TFhirMedicationStatementList = FHIR.R2.Resources.Clinical.TFhirMedicationStatementList;
{$ENDIF FHIR_MEDICATIONSTATEMENT}
{$IFDEF FHIR_MESSAGEHEADER}
  TFhirMessageHeaderResponse = FHIR.R2.Resources.Other.TFhirMessageHeaderResponse;
  TFhirMessageHeaderResponseList = FHIR.R2.Resources.Other.TFhirMessageHeaderResponseList;
  TFhirMessageHeaderSource = FHIR.R2.Resources.Other.TFhirMessageHeaderSource;
  TFhirMessageHeaderSourceList = FHIR.R2.Resources.Other.TFhirMessageHeaderSourceList;
  TFhirMessageHeaderDestination = FHIR.R2.Resources.Other.TFhirMessageHeaderDestination;
  TFhirMessageHeaderDestinationList = FHIR.R2.Resources.Other.TFhirMessageHeaderDestinationList;
  TFhirMessageHeader = FHIR.R2.Resources.Other.TFhirMessageHeader;
  TFhirMessageHeaderList = FHIR.R2.Resources.Other.TFhirMessageHeaderList;
{$ENDIF FHIR_MESSAGEHEADER}
{$IFDEF FHIR_NAMINGSYSTEM}
  TFhirNamingSystemContact = FHIR.R2.Resources.Canonical.TFhirNamingSystemContact;
  TFhirNamingSystemContactList = FHIR.R2.Resources.Canonical.TFhirNamingSystemContactList;
  TFhirNamingSystemUniqueId = FHIR.R2.Resources.Canonical.TFhirNamingSystemUniqueId;
  TFhirNamingSystemUniqueIdList = FHIR.R2.Resources.Canonical.TFhirNamingSystemUniqueIdList;
  TFhirNamingSystem = FHIR.R2.Resources.Canonical.TFhirNamingSystem;
  TFhirNamingSystemList = FHIR.R2.Resources.Canonical.TFhirNamingSystemList;
{$ENDIF FHIR_NAMINGSYSTEM}
{$IFDEF FHIR_NUTRITIONORDER}
  TFhirNutritionOrderOralDiet = FHIR.R2.Resources.Clinical.TFhirNutritionOrderOralDiet;
  TFhirNutritionOrderOralDietList = FHIR.R2.Resources.Clinical.TFhirNutritionOrderOralDietList;
  TFhirNutritionOrderOralDietNutrient = FHIR.R2.Resources.Clinical.TFhirNutritionOrderOralDietNutrient;
  TFhirNutritionOrderOralDietNutrientList = FHIR.R2.Resources.Clinical.TFhirNutritionOrderOralDietNutrientList;
  TFhirNutritionOrderOralDietTexture = FHIR.R2.Resources.Clinical.TFhirNutritionOrderOralDietTexture;
  TFhirNutritionOrderOralDietTextureList = FHIR.R2.Resources.Clinical.TFhirNutritionOrderOralDietTextureList;
  TFhirNutritionOrderSupplement = FHIR.R2.Resources.Clinical.TFhirNutritionOrderSupplement;
  TFhirNutritionOrderSupplementList = FHIR.R2.Resources.Clinical.TFhirNutritionOrderSupplementList;
  TFhirNutritionOrderEnteralFormula = FHIR.R2.Resources.Clinical.TFhirNutritionOrderEnteralFormula;
  TFhirNutritionOrderEnteralFormulaList = FHIR.R2.Resources.Clinical.TFhirNutritionOrderEnteralFormulaList;
  TFhirNutritionOrderEnteralFormulaAdministration = FHIR.R2.Resources.Clinical.TFhirNutritionOrderEnteralFormulaAdministration;
  TFhirNutritionOrderEnteralFormulaAdministrationList = FHIR.R2.Resources.Clinical.TFhirNutritionOrderEnteralFormulaAdministrationList;
  TFhirNutritionOrder = FHIR.R2.Resources.Clinical.TFhirNutritionOrder;
  TFhirNutritionOrderList = FHIR.R2.Resources.Clinical.TFhirNutritionOrderList;
{$ENDIF FHIR_NUTRITIONORDER}
{$IFDEF FHIR_OBSERVATION}
  TFhirObservationReferenceRange = FHIR.R2.Resources.Clinical.TFhirObservationReferenceRange;
  TFhirObservationReferenceRangeList = FHIR.R2.Resources.Clinical.TFhirObservationReferenceRangeList;
  TFhirObservationRelated = FHIR.R2.Resources.Clinical.TFhirObservationRelated;
  TFhirObservationRelatedList = FHIR.R2.Resources.Clinical.TFhirObservationRelatedList;
  TFhirObservationComponent = FHIR.R2.Resources.Clinical.TFhirObservationComponent;
  TFhirObservationComponentList = FHIR.R2.Resources.Clinical.TFhirObservationComponentList;
  TFhirObservation = FHIR.R2.Resources.Clinical.TFhirObservation;
  TFhirObservationList = FHIR.R2.Resources.Clinical.TFhirObservationList;
{$ENDIF FHIR_OBSERVATION}
{$IFDEF FHIR_OPERATIONDEFINITION}
  TFhirOperationDefinitionContact = FHIR.R2.Resources.Canonical.TFhirOperationDefinitionContact;
  TFhirOperationDefinitionContactList = FHIR.R2.Resources.Canonical.TFhirOperationDefinitionContactList;
  TFhirOperationDefinitionParameter = FHIR.R2.Resources.Canonical.TFhirOperationDefinitionParameter;
  TFhirOperationDefinitionParameterList = FHIR.R2.Resources.Canonical.TFhirOperationDefinitionParameterList;
  TFhirOperationDefinitionParameterBinding = FHIR.R2.Resources.Canonical.TFhirOperationDefinitionParameterBinding;
  TFhirOperationDefinitionParameterBindingList = FHIR.R2.Resources.Canonical.TFhirOperationDefinitionParameterBindingList;
  TFhirOperationDefinition = FHIR.R2.Resources.Canonical.TFhirOperationDefinition;
  TFhirOperationDefinitionList = FHIR.R2.Resources.Canonical.TFhirOperationDefinitionList;
{$ENDIF FHIR_OPERATIONDEFINITION}
{$IFDEF FHIR_OPERATIONOUTCOME}
  TFhirOperationOutcomeIssue = FHIR.R2.Resources.Other.TFhirOperationOutcomeIssue;
  TFhirOperationOutcomeIssueList = FHIR.R2.Resources.Other.TFhirOperationOutcomeIssueList;
  TFhirOperationOutcome = FHIR.R2.Resources.Other.TFhirOperationOutcome;
  TFhirOperationOutcomeList = FHIR.R2.Resources.Other.TFhirOperationOutcomeList;
{$ENDIF FHIR_OPERATIONOUTCOME}
{$IFDEF FHIR_ORDER}
  TFhirOrderWhen = FHIR.R2.Resources.Other.TFhirOrderWhen;
  TFhirOrderWhenList = FHIR.R2.Resources.Other.TFhirOrderWhenList;
  TFhirOrder = FHIR.R2.Resources.Other.TFhirOrder;
  TFhirOrderList = FHIR.R2.Resources.Other.TFhirOrderList;
{$ENDIF FHIR_ORDER}
{$IFDEF FHIR_ORDERRESPONSE}
  TFhirOrderResponse = FHIR.R2.Resources.Other.TFhirOrderResponse;
  TFhirOrderResponseList = FHIR.R2.Resources.Other.TFhirOrderResponseList;
{$ENDIF FHIR_ORDERRESPONSE}
{$IFDEF FHIR_ORGANIZATION}
  TFhirOrganizationContact = FHIR.R2.Resources.Admin.TFhirOrganizationContact;
  TFhirOrganizationContactList = FHIR.R2.Resources.Admin.TFhirOrganizationContactList;
  TFhirOrganization = FHIR.R2.Resources.Admin.TFhirOrganization;
  TFhirOrganizationList = FHIR.R2.Resources.Admin.TFhirOrganizationList;
{$ENDIF FHIR_ORGANIZATION}
{$IFDEF FHIR_PATIENT}
  TFhirPatientContact = FHIR.R2.Resources.Admin.TFhirPatientContact;
  TFhirPatientContactList = FHIR.R2.Resources.Admin.TFhirPatientContactList;
  TFhirPatientAnimal = FHIR.R2.Resources.Admin.TFhirPatientAnimal;
  TFhirPatientAnimalList = FHIR.R2.Resources.Admin.TFhirPatientAnimalList;
  TFhirPatientCommunication = FHIR.R2.Resources.Admin.TFhirPatientCommunication;
  TFhirPatientCommunicationList = FHIR.R2.Resources.Admin.TFhirPatientCommunicationList;
  TFhirPatientLink = FHIR.R2.Resources.Admin.TFhirPatientLink;
  TFhirPatientLinkList = FHIR.R2.Resources.Admin.TFhirPatientLinkList;
  TFhirPatient = FHIR.R2.Resources.Admin.TFhirPatient;
  TFhirPatientList = FHIR.R2.Resources.Admin.TFhirPatientList;
{$ENDIF FHIR_PATIENT}
{$IFDEF FHIR_PAYMENTNOTICE}
  TFhirPaymentNotice = FHIR.R2.Resources.Other.TFhirPaymentNotice;
  TFhirPaymentNoticeList = FHIR.R2.Resources.Other.TFhirPaymentNoticeList;
{$ENDIF FHIR_PAYMENTNOTICE}
{$IFDEF FHIR_PAYMENTRECONCILIATION}
  TFhirPaymentReconciliationDetail = FHIR.R2.Resources.Other.TFhirPaymentReconciliationDetail;
  TFhirPaymentReconciliationDetailList = FHIR.R2.Resources.Other.TFhirPaymentReconciliationDetailList;
  TFhirPaymentReconciliationNote = FHIR.R2.Resources.Other.TFhirPaymentReconciliationNote;
  TFhirPaymentReconciliationNoteList = FHIR.R2.Resources.Other.TFhirPaymentReconciliationNoteList;
  TFhirPaymentReconciliation = FHIR.R2.Resources.Other.TFhirPaymentReconciliation;
  TFhirPaymentReconciliationList = FHIR.R2.Resources.Other.TFhirPaymentReconciliationList;
{$ENDIF FHIR_PAYMENTRECONCILIATION}
{$IFDEF FHIR_PERSON}
  TFhirPersonLink = FHIR.R2.Resources.Admin.TFhirPersonLink;
  TFhirPersonLinkList = FHIR.R2.Resources.Admin.TFhirPersonLinkList;
  TFhirPerson = FHIR.R2.Resources.Admin.TFhirPerson;
  TFhirPersonList = FHIR.R2.Resources.Admin.TFhirPersonList;
{$ENDIF FHIR_PERSON}
{$IFDEF FHIR_PRACTITIONER}
  TFhirPractitionerPractitionerRole = FHIR.R2.Resources.Admin.TFhirPractitionerPractitionerRole;
  TFhirPractitionerPractitionerRoleList = FHIR.R2.Resources.Admin.TFhirPractitionerPractitionerRoleList;
  TFhirPractitionerQualification = FHIR.R2.Resources.Admin.TFhirPractitionerQualification;
  TFhirPractitionerQualificationList = FHIR.R2.Resources.Admin.TFhirPractitionerQualificationList;
  TFhirPractitioner = FHIR.R2.Resources.Admin.TFhirPractitioner;
  TFhirPractitionerList = FHIR.R2.Resources.Admin.TFhirPractitionerList;
{$ENDIF FHIR_PRACTITIONER}
{$IFDEF FHIR_PROCEDURE}
  TFhirProcedurePerformer = FHIR.R2.Resources.Clinical.TFhirProcedurePerformer;
  TFhirProcedurePerformerList = FHIR.R2.Resources.Clinical.TFhirProcedurePerformerList;
  TFhirProcedureFocalDevice = FHIR.R2.Resources.Clinical.TFhirProcedureFocalDevice;
  TFhirProcedureFocalDeviceList = FHIR.R2.Resources.Clinical.TFhirProcedureFocalDeviceList;
  TFhirProcedure = FHIR.R2.Resources.Clinical.TFhirProcedure;
  TFhirProcedureList = FHIR.R2.Resources.Clinical.TFhirProcedureList;
{$ENDIF FHIR_PROCEDURE}
{$IFDEF FHIR_PROCEDUREREQUEST}
  TFhirProcedureRequest = FHIR.R2.Resources.Clinical.TFhirProcedureRequest;
  TFhirProcedureRequestList = FHIR.R2.Resources.Clinical.TFhirProcedureRequestList;
{$ENDIF FHIR_PROCEDUREREQUEST}
{$IFDEF FHIR_PROCESSREQUEST}
  TFhirProcessRequestItem = FHIR.R2.Resources.Other.TFhirProcessRequestItem;
  TFhirProcessRequestItemList = FHIR.R2.Resources.Other.TFhirProcessRequestItemList;
  TFhirProcessRequest = FHIR.R2.Resources.Other.TFhirProcessRequest;
  TFhirProcessRequestList = FHIR.R2.Resources.Other.TFhirProcessRequestList;
{$ENDIF FHIR_PROCESSREQUEST}
{$IFDEF FHIR_PROCESSRESPONSE}
  TFhirProcessResponseNotes = FHIR.R2.Resources.Other.TFhirProcessResponseNotes;
  TFhirProcessResponseNotesList = FHIR.R2.Resources.Other.TFhirProcessResponseNotesList;
  TFhirProcessResponse = FHIR.R2.Resources.Other.TFhirProcessResponse;
  TFhirProcessResponseList = FHIR.R2.Resources.Other.TFhirProcessResponseList;
{$ENDIF FHIR_PROCESSRESPONSE}
{$IFDEF FHIR_PROVENANCE}
  TFhirProvenanceAgent = FHIR.R2.Resources.Other.TFhirProvenanceAgent;
  TFhirProvenanceAgentList = FHIR.R2.Resources.Other.TFhirProvenanceAgentList;
  TFhirProvenanceAgentRelatedAgent = FHIR.R2.Resources.Other.TFhirProvenanceAgentRelatedAgent;
  TFhirProvenanceAgentRelatedAgentList = FHIR.R2.Resources.Other.TFhirProvenanceAgentRelatedAgentList;
  TFhirProvenanceEntity = FHIR.R2.Resources.Other.TFhirProvenanceEntity;
  TFhirProvenanceEntityList = FHIR.R2.Resources.Other.TFhirProvenanceEntityList;
  TFhirProvenance = FHIR.R2.Resources.Other.TFhirProvenance;
  TFhirProvenanceList = FHIR.R2.Resources.Other.TFhirProvenanceList;
{$ENDIF FHIR_PROVENANCE}
{$IFDEF FHIR_QUESTIONNAIRE}
  TFhirQuestionnaireGroup = FHIR.R2.Resources.Canonical.TFhirQuestionnaireGroup;
  TFhirQuestionnaireGroupList = FHIR.R2.Resources.Canonical.TFhirQuestionnaireGroupList;
  TFhirQuestionnaireGroupQuestion = FHIR.R2.Resources.Canonical.TFhirQuestionnaireGroupQuestion;
  TFhirQuestionnaireGroupQuestionList = FHIR.R2.Resources.Canonical.TFhirQuestionnaireGroupQuestionList;
  TFhirQuestionnaire = FHIR.R2.Resources.Canonical.TFhirQuestionnaire;
  TFhirQuestionnaireList = FHIR.R2.Resources.Canonical.TFhirQuestionnaireList;
{$ENDIF FHIR_QUESTIONNAIRE}
{$IFDEF FHIR_QUESTIONNAIRERESPONSE}
  TFhirQuestionnaireResponseGroup = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponseGroup;
  TFhirQuestionnaireResponseGroupList = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponseGroupList;
  TFhirQuestionnaireResponseGroupQuestion = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponseGroupQuestion;
  TFhirQuestionnaireResponseGroupQuestionList = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponseGroupQuestionList;
  TFhirQuestionnaireResponseGroupQuestionAnswer = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponseGroupQuestionAnswer;
  TFhirQuestionnaireResponseGroupQuestionAnswerList = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponseGroupQuestionAnswerList;
  TFhirQuestionnaireResponse = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponse;
  TFhirQuestionnaireResponseList = FHIR.R2.Resources.Clinical.TFhirQuestionnaireResponseList;
{$ENDIF FHIR_QUESTIONNAIRERESPONSE}
{$IFDEF FHIR_REFERRALREQUEST}
  TFhirReferralRequest = FHIR.R2.Resources.Clinical.TFhirReferralRequest;
  TFhirReferralRequestList = FHIR.R2.Resources.Clinical.TFhirReferralRequestList;
{$ENDIF FHIR_REFERRALREQUEST}
{$IFDEF FHIR_RELATEDPERSON}
  TFhirRelatedPerson = FHIR.R2.Resources.Admin.TFhirRelatedPerson;
  TFhirRelatedPersonList = FHIR.R2.Resources.Admin.TFhirRelatedPersonList;
{$ENDIF FHIR_RELATEDPERSON}
{$IFDEF FHIR_RISKASSESSMENT}
  TFhirRiskAssessmentPrediction = FHIR.R2.Resources.Clinical.TFhirRiskAssessmentPrediction;
  TFhirRiskAssessmentPredictionList = FHIR.R2.Resources.Clinical.TFhirRiskAssessmentPredictionList;
  TFhirRiskAssessment = FHIR.R2.Resources.Clinical.TFhirRiskAssessment;
  TFhirRiskAssessmentList = FHIR.R2.Resources.Clinical.TFhirRiskAssessmentList;
{$ENDIF FHIR_RISKASSESSMENT}
{$IFDEF FHIR_SCHEDULE}
  TFhirSchedule = FHIR.R2.Resources.Admin.TFhirSchedule;
  TFhirScheduleList = FHIR.R2.Resources.Admin.TFhirScheduleList;
{$ENDIF FHIR_SCHEDULE}
{$IFDEF FHIR_SEARCHPARAMETER}
  TFhirSearchParameterContact = FHIR.R2.Resources.Canonical.TFhirSearchParameterContact;
  TFhirSearchParameterContactList = FHIR.R2.Resources.Canonical.TFhirSearchParameterContactList;
  TFhirSearchParameter = FHIR.R2.Resources.Canonical.TFhirSearchParameter;
  TFhirSearchParameterList = FHIR.R2.Resources.Canonical.TFhirSearchParameterList;
{$ENDIF FHIR_SEARCHPARAMETER}
{$IFDEF FHIR_SLOT}
  TFhirSlot = FHIR.R2.Resources.Admin.TFhirSlot;
  TFhirSlotList = FHIR.R2.Resources.Admin.TFhirSlotList;
{$ENDIF FHIR_SLOT}
{$IFDEF FHIR_SPECIMEN}
  TFhirSpecimenCollection = FHIR.R2.Resources.Clinical.TFhirSpecimenCollection;
  TFhirSpecimenCollectionList = FHIR.R2.Resources.Clinical.TFhirSpecimenCollectionList;
  TFhirSpecimenTreatment = FHIR.R2.Resources.Clinical.TFhirSpecimenTreatment;
  TFhirSpecimenTreatmentList = FHIR.R2.Resources.Clinical.TFhirSpecimenTreatmentList;
  TFhirSpecimenContainer = FHIR.R2.Resources.Clinical.TFhirSpecimenContainer;
  TFhirSpecimenContainerList = FHIR.R2.Resources.Clinical.TFhirSpecimenContainerList;
  TFhirSpecimen = FHIR.R2.Resources.Clinical.TFhirSpecimen;
  TFhirSpecimenList = FHIR.R2.Resources.Clinical.TFhirSpecimenList;
{$ENDIF FHIR_SPECIMEN}
{$IFDEF FHIR_STRUCTUREDEFINITION}
  TFhirStructureDefinitionContact = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionContact;
  TFhirStructureDefinitionContactList = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionContactList;
  TFhirStructureDefinitionMapping = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionMapping;
  TFhirStructureDefinitionMappingList = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionMappingList;
  TFhirStructureDefinitionSnapshot = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionSnapshot;
  TFhirStructureDefinitionSnapshotList = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionSnapshotList;
  TFhirStructureDefinitionDifferential = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionDifferential;
  TFhirStructureDefinitionDifferentialList = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionDifferentialList;
  TFhirStructureDefinition = FHIR.R2.Resources.Canonical.TFhirStructureDefinition;
  TFhirStructureDefinitionList = FHIR.R2.Resources.Canonical.TFhirStructureDefinitionList;
{$ENDIF FHIR_STRUCTUREDEFINITION}
{$IFDEF FHIR_SUBSCRIPTION}
  TFhirSubscriptionChannel = FHIR.R2.Resources.Other.TFhirSubscriptionChannel;
  TFhirSubscriptionChannelList = FHIR.R2.Resources.Other.TFhirSubscriptionChannelList;
  TFhirSubscription = FHIR.R2.Resources.Other.TFhirSubscription;
  TFhirSubscriptionList = FHIR.R2.Resources.Other.TFhirSubscriptionList;
{$ENDIF FHIR_SUBSCRIPTION}
{$IFDEF FHIR_SUBSTANCE}
  TFhirSubstanceInstance = FHIR.R2.Resources.Admin.TFhirSubstanceInstance;
  TFhirSubstanceInstanceList = FHIR.R2.Resources.Admin.TFhirSubstanceInstanceList;
  TFhirSubstanceIngredient = FHIR.R2.Resources.Admin.TFhirSubstanceIngredient;
  TFhirSubstanceIngredientList = FHIR.R2.Resources.Admin.TFhirSubstanceIngredientList;
  TFhirSubstance = FHIR.R2.Resources.Admin.TFhirSubstance;
  TFhirSubstanceList = FHIR.R2.Resources.Admin.TFhirSubstanceList;
{$ENDIF FHIR_SUBSTANCE}
{$IFDEF FHIR_SUPPLYDELIVERY}
  TFhirSupplyDelivery = FHIR.R2.Resources.Clinical.TFhirSupplyDelivery;
  TFhirSupplyDeliveryList = FHIR.R2.Resources.Clinical.TFhirSupplyDeliveryList;
{$ENDIF FHIR_SUPPLYDELIVERY}
{$IFDEF FHIR_SUPPLYREQUEST}
  TFhirSupplyRequestWhen = FHIR.R2.Resources.Clinical.TFhirSupplyRequestWhen;
  TFhirSupplyRequestWhenList = FHIR.R2.Resources.Clinical.TFhirSupplyRequestWhenList;
  TFhirSupplyRequest = FHIR.R2.Resources.Clinical.TFhirSupplyRequest;
  TFhirSupplyRequestList = FHIR.R2.Resources.Clinical.TFhirSupplyRequestList;
{$ENDIF FHIR_SUPPLYREQUEST}
{$IFDEF FHIR_TESTSCRIPT}
  TFhirTestScriptContact = FHIR.R2.Resources.Canonical.TFhirTestScriptContact;
  TFhirTestScriptContactList = FHIR.R2.Resources.Canonical.TFhirTestScriptContactList;
  TFhirTestScriptMetadata = FHIR.R2.Resources.Canonical.TFhirTestScriptMetadata;
  TFhirTestScriptMetadataList = FHIR.R2.Resources.Canonical.TFhirTestScriptMetadataList;
  TFhirTestScriptMetadataLink = FHIR.R2.Resources.Canonical.TFhirTestScriptMetadataLink;
  TFhirTestScriptMetadataLinkList = FHIR.R2.Resources.Canonical.TFhirTestScriptMetadataLinkList;
  TFhirTestScriptMetadataCapability = FHIR.R2.Resources.Canonical.TFhirTestScriptMetadataCapability;
  TFhirTestScriptMetadataCapabilityList = FHIR.R2.Resources.Canonical.TFhirTestScriptMetadataCapabilityList;
  TFhirTestScriptFixture = FHIR.R2.Resources.Canonical.TFhirTestScriptFixture;
  TFhirTestScriptFixtureList = FHIR.R2.Resources.Canonical.TFhirTestScriptFixtureList;
  TFhirTestScriptVariable = FHIR.R2.Resources.Canonical.TFhirTestScriptVariable;
  TFhirTestScriptVariableList = FHIR.R2.Resources.Canonical.TFhirTestScriptVariableList;
  TFhirTestScriptSetup = FHIR.R2.Resources.Canonical.TFhirTestScriptSetup;
  TFhirTestScriptSetupList = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupList;
  TFhirTestScriptSetupAction = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupAction;
  TFhirTestScriptSetupActionList = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupActionList;
  TFhirTestScriptSetupActionOperation = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupActionOperation;
  TFhirTestScriptSetupActionOperationList = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupActionOperationList;
  TFhirTestScriptSetupActionOperationRequestHeader = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupActionOperationRequestHeader;
  TFhirTestScriptSetupActionOperationRequestHeaderList = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupActionOperationRequestHeaderList;
  TFhirTestScriptSetupActionAssert = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupActionAssert;
  TFhirTestScriptSetupActionAssertList = FHIR.R2.Resources.Canonical.TFhirTestScriptSetupActionAssertList;
  TFhirTestScriptTest = FHIR.R2.Resources.Canonical.TFhirTestScriptTest;
  TFhirTestScriptTestList = FHIR.R2.Resources.Canonical.TFhirTestScriptTestList;
  TFhirTestScriptTestAction = FHIR.R2.Resources.Canonical.TFhirTestScriptTestAction;
  TFhirTestScriptTestActionList = FHIR.R2.Resources.Canonical.TFhirTestScriptTestActionList;
  TFhirTestScriptTeardown = FHIR.R2.Resources.Canonical.TFhirTestScriptTeardown;
  TFhirTestScriptTeardownList = FHIR.R2.Resources.Canonical.TFhirTestScriptTeardownList;
  TFhirTestScriptTeardownAction = FHIR.R2.Resources.Canonical.TFhirTestScriptTeardownAction;
  TFhirTestScriptTeardownActionList = FHIR.R2.Resources.Canonical.TFhirTestScriptTeardownActionList;
  TFhirTestScript = FHIR.R2.Resources.Canonical.TFhirTestScript;
  TFhirTestScriptList = FHIR.R2.Resources.Canonical.TFhirTestScriptList;
{$ENDIF FHIR_TESTSCRIPT}
{$IFDEF FHIR_VALUESET}
  TFhirValueSetContact = FHIR.R2.Resources.Canonical.TFhirValueSetContact;
  TFhirValueSetContactList = FHIR.R2.Resources.Canonical.TFhirValueSetContactList;
  TFhirValueSetCodeSystem = FHIR.R2.Resources.Canonical.TFhirValueSetCodeSystem;
  TFhirValueSetCodeSystemList = FHIR.R2.Resources.Canonical.TFhirValueSetCodeSystemList;
  TFhirValueSetCodeSystemConcept = FHIR.R2.Resources.Canonical.TFhirValueSetCodeSystemConcept;
  TFhirValueSetCodeSystemConceptList = FHIR.R2.Resources.Canonical.TFhirValueSetCodeSystemConceptList;
  TFhirValueSetCodeSystemConceptDesignation = FHIR.R2.Resources.Canonical.TFhirValueSetCodeSystemConceptDesignation;
  TFhirValueSetCodeSystemConceptDesignationList = FHIR.R2.Resources.Canonical.TFhirValueSetCodeSystemConceptDesignationList;
  TFhirValueSetCompose = FHIR.R2.Resources.Canonical.TFhirValueSetCompose;
  TFhirValueSetComposeList = FHIR.R2.Resources.Canonical.TFhirValueSetComposeList;
  TFhirValueSetComposeInclude = FHIR.R2.Resources.Canonical.TFhirValueSetComposeInclude;
  TFhirValueSetComposeIncludeList = FHIR.R2.Resources.Canonical.TFhirValueSetComposeIncludeList;
  TFhirValueSetComposeIncludeConcept = FHIR.R2.Resources.Canonical.TFhirValueSetComposeIncludeConcept;
  TFhirValueSetComposeIncludeConceptList = FHIR.R2.Resources.Canonical.TFhirValueSetComposeIncludeConceptList;
  TFhirValueSetComposeIncludeFilter = FHIR.R2.Resources.Canonical.TFhirValueSetComposeIncludeFilter;
  TFhirValueSetComposeIncludeFilterList = FHIR.R2.Resources.Canonical.TFhirValueSetComposeIncludeFilterList;
  TFhirValueSetExpansion = FHIR.R2.Resources.Canonical.TFhirValueSetExpansion;
  TFhirValueSetExpansionList = FHIR.R2.Resources.Canonical.TFhirValueSetExpansionList;
  TFhirValueSetExpansionParameter = FHIR.R2.Resources.Canonical.TFhirValueSetExpansionParameter;
  TFhirValueSetExpansionParameterList = FHIR.R2.Resources.Canonical.TFhirValueSetExpansionParameterList;
  TFhirValueSetExpansionContains = FHIR.R2.Resources.Canonical.TFhirValueSetExpansionContains;
  TFhirValueSetExpansionContainsList = FHIR.R2.Resources.Canonical.TFhirValueSetExpansionContainsList;
  TFhirValueSet = FHIR.R2.Resources.Canonical.TFhirValueSet;
  TFhirValueSetList = FHIR.R2.Resources.Canonical.TFhirValueSetList;
{$ENDIF FHIR_VALUESET}
{$IFDEF FHIR_VISIONPRESCRIPTION}
  TFhirVisionPrescriptionDispense = FHIR.R2.Resources.Clinical.TFhirVisionPrescriptionDispense;
  TFhirVisionPrescriptionDispenseList = FHIR.R2.Resources.Clinical.TFhirVisionPrescriptionDispenseList;
  TFhirVisionPrescription = FHIR.R2.Resources.Clinical.TFhirVisionPrescription;
  TFhirVisionPrescriptionList = FHIR.R2.Resources.Clinical.TFhirVisionPrescriptionList;
{$ENDIF FHIR_VISIONPRESCRIPTION}

implementation

end.


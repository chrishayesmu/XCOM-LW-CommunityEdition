/*******************************************************************************
 * XGPendingRequestsUI generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGPendingRequestsUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation)
    implements(IFCRequestInterface);

enum EPRequest
{
    ePRequest_Main,
    ePRequest_Selected,
    ePRequest_MAX
};

struct TPendingRequest
{
    var EFCRequest eRequest;
    var ECountry ECountry;
    var TText txtTitle;
    var TText txtSubTitle;
    var TText txtTopSecretLabel;
    var TText txtDescription;
    var TLabeledText ltxtDueDate;
    var TLabeledText ltxtRequired;
    var TLabeledText ltxtInStorage;
    var TText txtRewardLabel;
    var array<TText> arrRewards;
    var TButtonText txtAccept;
    var TButtonText txtIgnore;
    var TImage img;

    structdefaultproperties
    {
        eRequest=EFCRequest.eFCR_None
        ECountry=ECountry.eCountry_USA
        txtTitle=(StrValue="",iState=0)
        txtSubTitle=(StrValue="",iState=0)
        txtTopSecretLabel=(StrValue="",iState=0)
        txtDescription=(StrValue="",iState=0)
        ltxtDueDate=(StrValue="",strLabel="",iState=0,bNumber=false)
        ltxtRequired=(StrValue="",strLabel="",iState=0,bNumber=false)
        ltxtInStorage=(StrValue="",strLabel="",iState=0,bNumber=false)
        txtRewardLabel=(StrValue="",iState=0)
        arrRewards=none
        txtAccept=(StrValue="",iState=0,iButton=0)
        txtIgnore=(StrValue="",iState=0,iButton=0)
        img=(iImage=0,strLabel="",iState=0,strPath="")
    }
};

var int m_iHighlight;
var array<TFCRequest> m_arrRequests;
var bool m_bCanDoSelectedRequest;
var TPendingRequest m_kRequest;
var const localized string m_strNumCodePieces;
var const localized string m_strNumEngineers;
var const localized string m_strNumScientist;
var const localized string m_strNumSatellite;
var const localized string m_strNewRecruit;
var const localized string m_strTitleLabel;
var const localized string m_strLabelRequested;
var const localized string m_strValueRequested;
var const localized string m_strValueInStorage;
var const localized string m_strLabelTimeLimit;
var const localized string m_strLabelInStorage;
var const localized string m_strTimeLimitDays;
var const localized string m_strLabelRewards;
var const localized string m_strLabelSellItems;
var const localized string m_strLabelTransferSatellite;
var const localized string m_strSellItemsDate;
var const localized string m_strLabelIgnoreRequest;
var const localized string m_strRequestCompletedTitleLabel;
var const localized string m_strLabelAwarded;
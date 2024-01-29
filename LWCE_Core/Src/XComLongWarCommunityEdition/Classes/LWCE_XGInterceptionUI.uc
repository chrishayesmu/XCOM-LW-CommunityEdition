class LWCE_XGInterceptionUI extends XGInterceptionUI;

struct LWCE_TShipOption
{
    var LWCE_XGShip kShip;
    var TText txtShipName;
    var TLabeledText txtOffense;
    var TText txtStatus;
    var int iState;
};

// We allow for the possibility of multiple enemy ships, though the vanilla game will only have one
var array<LWCE_XGShip> m_arrEnemyShips;
var array<LWCE_TShipOption> m_arrCEShipOptions;

function Init(int iView)
{
    m_imgBG.iImage = eImage_OldInterception;
    m_iCurrentJet = 0;

    m_kInterception = Spawn(class'LWCE_XGInterception');
    LWCE_XGInterception(m_kInterception).LWCE_Init(m_arrEnemyShips);
    UpdateSquadron();

    super(XGScreenMgr).Init(iView);
}

function BuildInterceptorList()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(BuildInterceptorList);
}

function OnChooseJet()
{
    if (m_arrCEShipOptions[m_iCurrentJet].iState == eUIState_Disabled)
    {
        PlayBadSound();
        return;
    }

    LWCE_XGInterception(m_kInterception).ToggleFriendlyShip(m_arrCEShipOptions[m_iCurrentJet].kShip);
    UpdateView();
}

function OnCursorLeft()
{
    if (m_iCurrentJet == 0)
    {
        m_iCurrentJet = m_arrCEShipOptions.Length - 1;
    }
    else
    {
        m_iCurrentJet -= 1;
    }

    UpdateView();
}

function OnCursorRight()
{
    if (m_iCurrentJet == m_arrCEShipOptions.Length - 1)
    {
        m_iCurrentJet = 0;
    }
    else
    {
        m_iCurrentJet += 1;
    }

    UpdateView();
}

function UpdateCurrentTarget()
{
    local LWCE_XGShip kTarget;
    local XGParamTag kTag;

    // Always use the first enemy ship as the target; pull it from the interception in case ships are getting removed as they die
    kTarget = LWCE_XGInterception(m_kInterception).m_arrEnemyShips[0];
    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    m_kTarget.imgTarget.iImage = eImage_MCUFOScramble;

    m_kTarget.txtSize.strLabel = m_strLabelSize;
    m_kTarget.txtSize.StrValue = "NOT IMPLEMENTED"; // m_kInterception.m_kUFOTarget.GetSizeString();

    kTag.StrValue0 = kTarget.GetName();
    kTag.StrValue1 = `LWCE_XGCONTINENT(kTarget.GetContinent()).GetName();
    m_kTarget.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strLabelShipOverRegion);
}

function UpdateSquadron()
{
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGShip kShip;
    local int Index, iShip;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());

    iShip = 0;
    m_arrCEShipOptions.Length = 0;

    for (Index = 0; Index < kHangar.m_arrCEShips.Length; Index++)
    {
        kShip = kHangar.m_arrCEShips[Index];

        if (kShip == none)
        {
            continue;
        }

        m_arrCEShipOptions.Add(1);
        m_arrCEShipOptions[iShip].kShip = kShip;
        m_arrCEShipOptions[iShip].txtShipName.StrValue = kShip.m_strCallsign;

        m_arrCEShipOptions[iShip].txtOffense.strLabel = m_strLabelLoadout;
        m_arrCEShipOptions[iShip].txtOffense.StrValue = kShip.GetWeaponString() @ "(" $ kShip.m_iConfirmedKills @ m_strLabelMaxSpeed;

        m_arrCEShipOptions[iShip].txtStatus.StrValue = kShip.GetStatusString();
        m_arrCEShipOptions[iShip].txtStatus.iState = kShip.GetStatusUIState();

        if (LWCE_XGInterception(m_kInterception).HasFriendlyShip(kShip))
        {
            m_arrCEShipOptions[iShip].iState = eUIState_Highlight;
        }
        else if (kShip.GetStatus() != eShipStatus_Ready)
        {
            m_arrCEShipOptions[iShip].iState = eUIState_Disabled;
        }
        else
        {
            m_arrCEShipOptions[iShip].iState = eUIState_Normal;
        }

        iShip += 1;
    }
}
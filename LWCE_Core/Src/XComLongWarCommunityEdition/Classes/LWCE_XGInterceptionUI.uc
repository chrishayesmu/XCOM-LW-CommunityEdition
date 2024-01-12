class LWCE_XGInterceptionUI extends XGInterceptionUI;

// We allow for the possibility of multiple enemy ships, though the vanilla game will only have one
var array<LWCE_XGShip> m_arrEnemyShips;

function Init(int iView)
{
    m_imgBG.iImage = eImage_OldInterception;
    m_iCurrentJet = 0;

    m_kInterception = Spawn(class'LWCE_XGInterception');
    LWCE_XGInterception(m_kInterception).LWCE_Init(m_arrEnemyShips);

    BuildInterceptorList();

    super(XGScreenMgr).Init(iView);
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
class UIStrategyComponent_SoldierInfo extends UI_FxsPanel;
//complete stub

var const localized string m_strStatusLabel;
var const localized string m_strMissionsLabel;
var const localized string m_strKillsLabel;
var XGStrategySoldier m_kSoldier;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, XGStrategySoldier kSoldier){}
simulated function OnInit(){}
function ZUpdateData(){}
event Destroyed(){}
final simulated function AS_SetMedals(string medalData){}
final simulated function AS_SetSoldierInformation(string _name, string _nickname, string _status, string _flagIcon, string _classLabel, string _classText, string _rankLabel, string _rankText, bool _showPromoteIcon, string _missions, string _kills){}

function UpdateData()
{
    local string theName, NickName, Status, flagIcon, classLabel, classText,
	    rankLabel, rankText, missionsText, killsText;

    local int iRank;
    local bool bIsShiv;

    theName = Caps(m_kSoldier.GetName(0) @ m_kSoldier.GetName(1));
    NickName = m_kSoldier.GetName(2);
    Status = class'UIUtilities'.static.GetHTMLColoredText(m_strStatusLabel, 0) @ class'UIUtilities'.static.GetHTMLColoredText(m_kSoldier.GetStatusString(), m_kSoldier.GetStatusUIState()) $ "   ";
    flagIcon = class'UIScreen'.static.GetFlagPath(m_kSoldier.GetCountry());
    classLabel = class'UIUtilities'.static.GetClassLabel(m_kSoldier.GetEnergy(), m_kSoldier.m_kChar.bHasPsiGift, class'XComPerkManager'.static.HasAnyGeneMod(m_kSoldier.m_kChar.aUpgrades));
    classText = Caps(m_kSoldier.GetClassName());

    if (m_kSoldier.IsATank())
    {
        iRank = m_kSoldier.GetSHIVRank();
        bIsShiv = true;
    }
    else
    {
        iRank = m_kSoldier.GetRank();
        bIsShiv = false;
    }

    rankLabel = class'UIUtilities'.static.GetRankLabel(iRank, bIsShiv);
    rankText = Caps(m_kSoldier.GetName(4));
    missionsText = class'UIUtilities'.static.GetHTMLColoredText(m_strMissionsLabel $ " " $ string(m_kSoldier.GetNumMissions()), 0);
    killsText = class'UIUtilities'.static.GetHTMLColoredText(m_strKillsLabel $ " " $ string(m_kSoldier.GetNumKills()), 0);

    if (m_kSoldier.HasAnyMedal())
    {
        if ((XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game)).GetGameCore().IsOptionEnabled(9))
        {
            iRank = int(float(class'XGFacility_Barracks'.default.NUM_MEDALOFHONOR_MISSIONS) * class'XGTacticalGameCore'.default.SW_MARATHON);
        }
        else
        {
            iRank = class'XGFacility_Barracks'.default.NUM_MEDALOFHONOR_MISSIONS;
        }

        iRank = Clamp(iRank - (m_kSoldier.m_iNumMissions >> 16), 0, iRank);

        Status @= class'UIUtilities'.static.GetHTMLColoredText("(" $ iRank $ " to promote)", eUIState_Highlight);
    }

    AS_SetSoldierInformation(theName, NickName, Status, flagIcon, classLabel, classText, rankLabel, rankText, m_kSoldier.HasAvailablePerksToAssign(), missionsText, killsText);
    AS_SetMedals(class'UIUtilities'.static.GetMedalLabels(m_kSoldier.m_arrMedals));
}
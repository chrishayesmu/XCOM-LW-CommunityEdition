class LWCE_UIStrategyComponent_SoldierInfo extends UIStrategyComponent_SoldierInfo;

function UpdateData()
{
    local string theName, NickName, Status, flagIcon, classLabel, classText,
	    rankLabel, rankText, missionsText, killsText;
    local int iRank;
    local bool bIsShiv;
    local LWCE_XGStrategySoldier kSoldier;

    kSoldier = LWCE_XGStrategySoldier(m_kSoldier);

    theName = Caps(kSoldier.GetName(eNameType_First) @ kSoldier.GetName(eNameType_Last));
    NickName = kSoldier.GetName(eNameType_Nick);
    Status = class'UIUtilities'.static.GetHTMLColoredText(m_strStatusLabel, eUIState_Normal) @ class'UIUtilities'.static.GetHTMLColoredText(kSoldier.GetStatusString(), kSoldier.GetStatusUIState()) $ "   ";
    flagIcon = class'UIScreen'.static.GetFlagPath(kSoldier.GetCountry());
    classLabel = class'UIUtilities'.static.GetClassLabel(kSoldier.m_kCEChar.iClassId, kSoldier.m_kCEChar.bHasPsiGift, class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kSoldier.m_kCEChar));
    classText = Caps(kSoldier.GetClassName());

    if (kSoldier.IsATank())
    {
        iRank = kSoldier.GetSHIVRank();
        bIsShiv = true;
    }
    else
    {
        iRank = kSoldier.GetRank();
        bIsShiv = false;
    }

    rankLabel = class'UIUtilities'.static.GetRankLabel(iRank, bIsShiv);
    rankText = Caps(kSoldier.GetName(eNameType_Rank));
    missionsText = class'UIUtilities'.static.GetHTMLColoredText(m_strMissionsLabel $ " " $ string(kSoldier.GetNumMissions()), eUIState_Normal);
    killsText = class'UIUtilities'.static.GetHTMLColoredText(m_strKillsLabel $ " " $ string(kSoldier.GetNumKills()), eUIState_Normal);

    AS_SetSoldierInformation(theName, NickName, Status, flagIcon, classLabel, classText, rankLabel, rankText, kSoldier.HasAvailablePerksToAssign(), missionsText, killsText);
    AS_SetMedals(class'UIUtilities'.static.GetMedalLabels(kSoldier.m_arrMedals));
}
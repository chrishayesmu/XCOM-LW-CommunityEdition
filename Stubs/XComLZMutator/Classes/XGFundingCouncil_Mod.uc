class XGFundingCouncil_Mod extends XGFundingCouncil
    notplaceable;

function TFCMission BuildMission(EFCMission eMission, ECountry ECountry){}
function FixDisplayName(out TFCMission kMission){}
function TFCMission BuildExtendedMission(EFCMission eMission, ECountry ECountry){}
function FilterVanillaMaps(out array<string> MapNames){}
function Init(){}
function EFCMission ChooseNextMissionByType(EMissionRegion eRegion, ECountry fcCountry){}
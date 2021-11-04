class XComHeadquartersCheatManager extends XComCheatManager within XComHeadquartersController;

var bool bSeeAll;
var bool bDoGlobeView;
var bool bFreeCam;
var bool bDebugAIEvents;
var bool bAllowDeluge;
var bool bDumpSkelPoseUpdates;
var ECharacter iForceAlienType;
var XGEntity kEntity;

exec function GivePerk(string strName)
{
    /**
	local XGSoldierUI kSoldierUI;
    local XComHQPresentationLayer kPres;
    local XComPlayerController PC;
    local int iIndex;
    local bool bFound;
    local TPerk kPerk;
    local XComPerkManager kPerkMan;
    local string strPerkName;

    kPerkMan = XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().GetBarracks().m_kPerkManager;
	PC = XComPlayerController(Outer.GetALocalPlayerController());
	kPres = XComHQPresentationLayer(PC.m_Pres);
    kSoldierUI = XGSoldierUI(kPres.GetMgr(class'XGSoldierUI',,, true));
    
	if((kSoldierUI != none) && kSoldierUI.m_kSoldier != none)
	{
		if(Left(strName, 5) ~= "clear")
		{
			if(split(strName, "clear", true) ~= " true")
			{
				kSoldierUI.m_kSoldier.ClearPerks(true);
			}
			else
			{
				kSoldierUI.m_kSoldier.ClearPerks();
			}
		}
		
		if(strName ~= "rolltree")
		{
			kSoldierUI.m_kSoldier.AssignRandomPerks();
		}
		
		if(Left(strName, 4) ~= "stat")
		{
			LogInternal(CAPS(Left(Mid(strName, 5), InStr(Mid(strName, 5), " "))));
			LogInternal(Left(Mid(strName, 5), InStr(Mid(strName, 5), " ")));
			LogInternal(Split(Mid(strName, 5), " ", true));

			switch(CAPS(Left(Mid(strName, 5), InStr(Mid(strName, 5), " "))))
			{

				case "HP":
					kSoldierUI.m_kSoldier.m_kChar.aStats[0] += int(Split(Mid(strName, 5), " ", true));
					break;
				case "DEF":
					kSoldierUI.m_kSoldier.m_kChar.aStats[2] += int(Split(Mid(strName, 5), " ", true));
					break;
				case "AIM":
					kSoldierUI.m_kSoldier.m_kChar.aStats[1] += int(Split(Mid(strName, 5), " ", true));
					break;
				case "WILL":
					kSoldierUI.m_kSoldier.m_kChar.aStats[7] += int(Split(Mid(strName, 5), " ", true));
					break;
				case "DR":
					kSoldierUI.m_kSoldier.m_kChar.aStats[4] += int(Split(Mid(strName, 5), " ", true));
					break;
				case "MOB":
					kSoldierUI.m_kSoldier.m_kChar.aStats[3] += int(Split(Mid(strName, 5), " ", true));
					break;
				default:
					kSoldierUI.m_kSoldier.m_kChar.aStats[int(Left(Mid(strName, 5), InStr(Mid(strName, 5), " ")))] += int(Split(Mid(strName, 5), " ", true));
					break;

			}
			
			if(Left(Mid(strName, 5), 4) ~= "roll")
			{
				kSoldierUI.m_kSoldier.m_kChar.aStats[0] = class'XGTacticalGameCore'.default.Characters[1].HP;
				kSoldierUI.m_kSoldier.m_kChar.aStats[1] = class'XGTacticalGameCore'.default.Characters[1].Offense;
				kSoldierUI.m_kSoldier.m_kChar.aStats[2] = class'XGTacticalGameCore'.default.Characters[1].Defense;
				kSoldierUI.m_kSoldier.m_kChar.aStats[3] = class'XGTacticalGameCore'.default.Characters[1].Mobility;
				kSoldierUI.m_kSoldier.m_kChar.aStats[7] = class'XGTacticalGameCore'.default.Characters[1].Will;
				XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBarracks.RandomizeStats(kSoldierUI.m_kSoldier);
			}
			
			if(Left(Mid(strName, 5), 7) ~= "default") 
			{
				kSoldierUI.m_kSoldier.m_kChar.aStats[0] = class'XGTacticalGameCore'.default.Characters[1].HP;
				kSoldierUI.m_kSoldier.m_kChar.aStats[1] = class'XGTacticalGameCore'.default.Characters[1].Offense;
				kSoldierUI.m_kSoldier.m_kChar.aStats[2] = class'XGTacticalGameCore'.default.Characters[1].Defense;
				kSoldierUI.m_kSoldier.m_kChar.aStats[3] = class'XGTacticalGameCore'.default.Characters[1].Mobility;
				kSoldierUI.m_kSoldier.m_kChar.aStats[7] = class'XGTacticalGameCore'.default.Characters[1].Will;
			}
			
			if(Split(strName, " ", true) ~= "levelup")
			{
				if(int(Mid(strName, 13)) > 0)
				{
					kSoldierUI.m_kSoldier.LevelUpStats(int(Mid(strName, 13)) << 8);
				}
				else
				{
					kSoldierUI.m_kSoldier.LevelUpStats(kSoldierUI.m_kSoldier.GetRank() << 8);
				}
			}
		}
		
		if(Left(strName, 3) ~= "xp ")
		{
			kSoldierUI.m_kSoldier.m_kSoldier.iXP += int(Mid(strName, 3));
			lvl:
			if(kSoldierUI.m_kSoldier.IsReadyToLevelUp())
			{
				kSoldierUI.m_kSoldier.LevelUp();
				goto lvl;
			}
		}
		
		if(Left(strName, 6) ~= "kills ")
		{
			kSoldierUI.m_kSoldier.m_kSoldier.iNumKills += int(Mid(strName, 6));
		}
		
		if(Left(strName, 9) ~= "missions ")
		{
			if(Mid(strName, 9, 8) ~= "officer ")
			{
				kSoldierUI.m_kSoldier.m_iNumMissions += int(Mid(strName, 17)) << 16;
			}
			else
			{
				kSoldierUI.m_kSoldier.m_iNumMissions += int(Mid(strName, 9));
			}
		}
		
		if(Left(strName, 6) ~= "gender")
		{
			if(Mid(strName, 7) ~= "m" || Mid(strName, 7) ~= "male" || Mid(strName, 7) ~= "1" || Mid(strName, 7) ~= "b" || Mid(strName, 7) ~= "boy" || Mid(strName, 7) ~= "man")
			{
				kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iGender = 1;
			}
			else
			{
				if(Mid(strName, 7) ~= "f" || Mid(strName, 7) ~= "female" || Mid(strName, 7) ~= "2" || Mid(strName, 7) ~= "g" || Mid(strName, 7) ~= "girl" || Mid(strName, 7) ~= "w" || Mid(strName, 7) ~= "woman")
				{
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iGender = 2;
				}
				else
				{
					if(kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iGender == 1)
					{
						kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iGender = 2;
					}
					else
					{
						kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iGender = 1;
					}
				}
			}
			XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).GotoState('InHQ');
			XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).Init(kSoldierUI.m_kSoldier.m_kChar, kSoldierUI.m_kSoldier.m_kChar.kInventory, kSoldierUI.m_kSoldier.m_kSoldier.kAppearance);
			XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).SetHead(XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleHeads[0]);
			kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iHead = XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleHeads[0];
			XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).SetHair(XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleHairs[1]);
			kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iHaircut = XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleHairs[1];
			XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).SetArmorDeco(XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleArmorKits[0]);
			kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iArmorDeco = XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleArmorKits[0];
			XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).SetVoice(XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleVoices[0]);
			kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iVoice = XComHumanPawn(kSoldierUI.m_kSoldier.m_kPawn).PossibleVoices[0];
			if(XGCustomizeUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGCustomizeUI',,, true)) != none)
			{
				XGCustomizeUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGCustomizeUI',,, true)).SetActiveSoldier(kSoldierUI.m_kSoldier);
				XGCustomizeUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGCustomizeUI',,, true)).UpdateMainMenu;
			}
			kSoldierUI.SetActiveSoldier(kSoldierUI.m_kSoldier);
			kSoldierUI.UpdateDoll();
			kSoldierUI.UpdateView();
		}
		
		if(Left(strName, 8) ~= "country ") 
		{
			if(int(Mid(strName, 8)) > 0)
			{
				kSoldierUI.m_kSoldier.m_kSoldier.iCountry = int(Mid(strName, 8));
			}
			else
			{
				if(Mid(strName, 8) ~= "USA" || Mid(strName, 8) ~= "US" || Mid(strName, 8) ~= "UnitedStates" || Mid(strName, 8) ~= "United States") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 0;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 0;
				}
				if(Mid(strName, 8) ~= "RUS" || Mid(strName, 8) ~= "RU" || Mid(strName, 8) ~= "Russia" || Mid(strName, 8) ~= "Rossija") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 1;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 1;
				}
				if(Mid(strName, 8) ~= "CHN" || Mid(strName, 8) ~= "CN" || Mid(strName, 8) ~= "China" || Mid(strName, 8) ~= "Zhongguo" || Mid(strName, 8) ~= "PRoC" || Mid(strName, 8) ~= "PeoplesRepublicOfChina" || Mid(strName, 8) ~= "People's Republic of China") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 2;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 2;
				}
				if(Mid(strName, 8) ~= "GBR" || Mid(strName, 8) ~= "GB" || Mid(strName, 8) ~= "UK" || Mid(strName, 8) ~= "UnitedKingdom" || Mid(strName, 8) ~= "United Kingdom" || Mid(strName, 8) ~= "GreatBritain" || Mid(strName, 8) ~= "Great Britain") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 3;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 3;
				}
				if(Mid(strName, 8) ~= "DEU" || Mid(strName, 8) ~= "DE" || Mid(strName, 8) ~= "Germany" || Mid(strName, 8) ~= "Deutschland") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 4;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 4;
				}
				if(Mid(strName, 8) ~= "FRA" || Mid(strName, 8) ~= "FR" || Mid(strName, 8) ~= "France") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 5;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 5;
				}
				if(Mid(strName, 8) ~= "JPN" || Mid(strName, 8) ~= "JP" || Mid(strName, 8) ~= "Japan" || Mid(strName, 8) ~= "Nihon" || Mid(strName, 8) ~= "Nippon" || Mid(strName, 8) ~= "NipponKoku" || Mid(strName, 8) ~= "Nippon Koku") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 6;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 6;
				}
				if(Mid(strName, 8) ~= "IND" || Mid(strName, 8) ~= "IN" || Mid(strName, 8) ~= "India" || Mid(strName, 8) ~= "IN" || Mid(strName, 8) ~= "Bharat" || Mid(strName, 8) ~= "BharatiyaGanarajya" || Mid(strName, 8) ~= "Bharatiya Ganarajya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 7;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 7;
				}
				if(Mid(strName, 8) ~= "AUS" || Mid(strName, 8) ~= "AU" || Mid(strName, 8) ~= "Australia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 8;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 8;
				}
				if(Mid(strName, 8) ~= "ITA" || Mid(strName, 8) ~= "IT" || Mid(strName, 8) ~= "Italy" || Mid(strName, 8) ~= "Italia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 9;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 9;
				}
				if(Mid(strName, 8) ~= "KOR" || Mid(strName, 8) ~= "KR" || Mid(strName, 8) ~= "SouthKorea" || Mid(strName, 8) ~= "South Korea" || Mid(strName, 8) ~= "Korea" || Mid(strName, 8) ~= "S.Korea" || Mid(strName, 8) ~= "SKorea" || Mid(strName, 8) ~= "S Korea" || Mid(strName, 8) ~= "Hanguk" || Mid(strName, 8) ~= "DaehanMinguk" || Mid(strName, 8) ~= "Daehan Minguk") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 10;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 10;
				}
				if(Mid(strName, 8) ~= "TUR" || Mid(strName, 8) ~= "TR" || Mid(strName, 8) ~= "Turkey" || Mid(strName, 8) ~= "Turkiye") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 11;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 11;
				}
				if(Mid(strName, 8) ~= "IDN" || Mid(strName, 8) ~= "ID" || Mid(strName, 8) ~= "Indonesia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 12;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 12;
				}
				if(Mid(strName, 8) ~= "ESP" || Mid(strName, 8) ~= "ES" || Mid(strName, 8) ~= "Spain" || Mid(strName, 8) ~= "Espana" || Mid(strName, 8) ~= "Espanya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 13;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 13;
				}
				if(Mid(strName, 8) ~= "PAK" || Mid(strName, 8) ~= "PK" || Mid(strName, 8) ~= "Pakistan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 14;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 14;
				}
				if(Mid(strName, 8) ~= "CAN" || Mid(strName, 8) ~= "CA" || Mid(strName, 8) ~= "Canada" || Mid(strName, 8) ~= "Kanata") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 15;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 15;
				}
				if(Mid(strName, 8) ~= "IRN" || Mid(strName, 8) ~= "IR" || Mid(strName, 8) ~= "Iran") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 16;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 16;
				}
				if(Mid(strName, 8) ~= "ISL" || Mid(strName, 8) ~= "IL" || Mid(strName, 8) ~= "Israel" || Mid(strName, 8) ~= "Yisrael" || Mid(strName, 8) ~= "Israil" || Mid(strName, 8) ~= "Yisra'el" || Mid(strName, 8) ~= "Isra'il") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 17;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 17;
				}
				if(Mid(strName, 8) ~= "EGY" || Mid(strName, 8) ~= "EG" || Mid(strName, 8) ~= "Egypt" || Mid(strName, 8) ~= "Misr") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 18;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 18;
				}
				if(Mid(strName, 8) ~= "BRA" || Mid(strName, 8) ~= "BR" || Mid(strName, 8) ~= "Brazil" || Mid(strName, 8) ~= "Brasil") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 19;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 19;
				}
				if(Mid(strName, 8) ~= "ARG" || Mid(strName, 8) ~= "AR" || Mid(strName, 8) ~= "Argentina") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 20;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 20;
				}
				if(Mid(strName, 8) ~= "MEX" || Mid(strName, 8) ~= "MX" || Mid(strName, 8) ~= "Mexico" || Mid(strName, 8) ~= "Anahuac" || Mid(strName, 8) ~= "Mexihco") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 21;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 21;
				}
				if(Mid(strName, 8) ~= "ZAF" || Mid(strName, 8) ~= "ZA" || Mid(strName, 8) ~= "SouthAfrica" || Mid(strName, 8) ~= "South Africa" || Mid(strName, 8) ~= "S.Africa" || Mid(strName, 8) ~= "SAfrica" || Mid(strName, 8) ~= "S Africa" || Mid(strName, 8) ~= "Suid-Afrika" || Mid(strName, 8) ~= "SuidAfrika" || Mid(strName, 8) ~= "Suid Afrika" || Mid(strName, 8) ~= "yeNingizimuAfrika" || Mid(strName, 8) ~= "yeNingizimu Afrika" || Mid(strName, 8) ~= "yaseNingizimuAfrika" || Mid(strName, 8) ~= "yaseNingizimu Afrika") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 22;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 22;
				}
				if(Mid(strName, 8) ~= "POL" || Mid(strName, 8) ~= "PL" || Mid(strName, 8) ~= "Poland" || Mid(strName, 8) ~= "Polska") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 23;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 23;
				}
				if(Mid(strName, 8) ~= "UKR" || Mid(strName, 8) ~= "UA" || Mid(strName, 8) ~= "Ukraine" || Mid(strName, 8) ~= "Ukrajina" || Mid(strName, 8) ~= "Ukraina") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 24;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 24;
				}
				if(Mid(strName, 8) ~= "NGA" || Mid(strName, 8) ~= "NG" || Mid(strName, 8) ~= "Nigeria") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 25;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 25;
				}
				if(Mid(strName, 8) ~= "VEN" || Mid(strName, 8) ~= "VE" || Mid(strName, 8) ~= "Venezuela") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 26;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 26;
				}
				if(Mid(strName, 8) ~= "GRC" || Mid(strName, 8) ~= "GR" || Mid(strName, 8) ~= "Greece" || Mid(strName, 8) ~= "Ellada" || Mid(strName, 8) ~= "Ellas") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 27;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 27;
				}
				if(Mid(strName, 8) ~= "COL" || Mid(strName, 8) ~= "CO" || Mid(strName, 8) ~= "Columbia" || Mid(strName, 8) ~= "Colombia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 28;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 28;
				}
				if(Mid(strName, 8) ~= "PRT" || Mid(strName, 8) ~= "PT" || Mid(strName, 8) ~= "Portugal") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 29;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 29;
				}
				if(Mid(strName, 8) ~= "SWE" || Mid(strName, 8) ~= "SE" || Mid(strName, 8) ~= "Sweden" || Mid(strName, 8) ~= "Sverige") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 30;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 30;
				}
				if(Mid(strName, 8) ~= "IRL" || Mid(strName, 8) ~= "IE" || Mid(strName, 8) ~= "Ireland" || Mid(strName, 8) ~= "Eire") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 31;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 31;
				}
				if(Mid(strName, 8) ~= "SCO" || Mid(strName, 8) ~= "Scotland" || Mid(strName, 8) ~= "Alba") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 32;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 32;
				}
				if(Mid(strName, 8) ~= "NOR" || Mid(strName, 8) ~= "NO" || Mid(strName, 8) ~= "Norway" || Mid(strName, 8) ~= "Norge" || Mid(strName, 8) ~= "Noreg") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 33;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 33;
				}
				if(Mid(strName, 8) ~= "NLD" || Mid(strName, 8) ~= "NL" || Mid(strName, 8) ~= "Netherlands" || Mid(strName, 8) ~= "Holland" || Mid(strName, 8) ~= "Nederland" || Mid(strName, 8) ~= "Nederlan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 34;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 34;
				}
				if(Mid(strName, 8) ~= "BEL" || Mid(strName, 8) ~= "BE" || Mid(strName, 8) ~= "Belgium" || Mid(strName, 8) ~= "Belgie" || Mid(strName, 8) ~= "Belgique" || Mid(strName, 8) ~= "Belgien") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 35;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 35;
				}
				if(Mid(strName, 8) ~= "BIH" || Mid(strName, 8) ~= "BA" || Mid(strName, 8) ~= "BosniaAndHerzegovina" || Mid(strName, 8) ~= "Bosnia and Herzegovina" || Mid(strName, 8) ~= "BosnaIHercegovina" || Mid(strName, 8) ~= "Bosna i Hercegovina") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 36;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 36;
				}
				if(Mid(strName, 8) ~= "HND" || Mid(strName, 8) ~= "HN" || Mid(strName, 8) ~= "Honduras") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 37;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 37;
				}
				if(Mid(strName, 8) ~= "DZA" || Mid(strName, 8) ~= "DZ" || Mid(strName, 8) ~= "Algeria" || Mid(strName, 8) ~= "al-Jazair" || Mid(strName, 8) ~= "alJazair" || Mid(strName, 8) ~= "al Jazair" || Mid(strName, 8) ~= "al-Jaza'ir" || Mid(strName, 8) ~= "alJaza'ir" || Mid(strName, 8) ~= "al Jaza'ir") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 38;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 38;
				}
				if(Mid(strName, 8) ~= "ETH" || Mid(strName, 8) ~= "ET" || Mid(strName, 8) ~= "Ethiopia" || Mid(strName, 8) ~= "Ityopya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 39;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 39;
				}
				if(Mid(strName, 8) ~= "KEN" || Mid(strName, 8) ~= "KE" || Mid(strName, 8) ~= "Kenya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 40;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 40;
				}
				if(Mid(strName, 8) ~= "MAR" || Mid(strName, 8) ~= "MA" || Mid(strName, 8) ~= "Morocco" || Mid(strName, 8) ~= "al-Magrib" || Mid(strName, 8) ~= "alMagrib" || Mid(strName, 8) ~= "al Magrib") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 41;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 41;
				}
				if(Mid(strName, 8) ~= "TZA" || Mid(strName, 8) ~= "TZ" || Mid(strName, 8) ~= "Tanzania") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 42;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 42;
				}
				if(Mid(strName, 8) ~= "ZWE" || Mid(strName, 8) ~= "ZW" || Mid(strName, 8) ~= "Zimbabwe") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 43;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 43;
				}
				if(Mid(strName, 8) ~= "BGD" || Mid(strName, 8) ~= "BD" || Mid(strName, 8) ~= "Bangladesh" || Mid(strName, 8) ~= "Banlades") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 44;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 44;
				}
				if(Mid(strName, 8) ~= "KAZ" || Mid(strName, 8) ~= "KZ" || Mid(strName, 8) ~= "Kazakhstan" || Mid(strName, 8) ~= "Kazakstan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 45;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 45;
				}
				if(Mid(strName, 8) ~= "MYS" || Mid(strName, 8) ~= "MY" || Mid(strName, 8) ~= "Malaysia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 46;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 46;
				}
				if(Mid(strName, 8) ~= "NZL" || Mid(strName, 8) ~= "NZ" || Mid(strName, 8) ~= "NewZealand" || Mid(strName, 8) ~= "New Zealand" || Mid(strName, 8) ~= "Aotearoa") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 47;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 47;
				}
				if(Mid(strName, 8) ~= "PHL" || Mid(strName, 8) ~= "PH" || Mid(strName, 8) ~= "Philippines" || Mid(strName, 8) ~= "Pilipinas") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 48;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 48;
				}
				if(Mid(strName, 8) ~= "SAU" || Mid(strName, 8) ~= "SA" || Mid(strName, 8) ~= "SaudiArabia" || Mid(strName, 8) ~= "Saudi Arabia" || Mid(strName, 8) ~= "as-Saudiya" || Mid(strName, 8) ~= "asSaudiya" || Mid(strName, 8) ~= "as Saudiya" || Mid(strName, 8) ~= "as-Sa'udiya" || Mid(strName, 8) ~= "asSa'udiya" || Mid(strName, 8) ~= "as Sa'udiya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 49;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 49;
				}
				if(Mid(strName, 8) ~= "TWN" || Mid(strName, 8) ~= "TW" || Mid(strName, 8) ~= "Taiwan" || Mid(strName, 8) ~= "Taipei" || Mid(strName, 8) ~= "Tai-wan" || Mid(strName, 8) ~= "Tai wan" || Mid(strName, 8) ~= "Chung-hua Min-kuo" || Mid(strName, 8) ~= "Chunghua Minkuo" || Mid(strName, 8) ~= "Chung hua Min kuo" || Mid(strName, 8) ~= "RoC" || Mid(strName, 8) ~= "Republic of China" || Mid(strName, 8) ~= "RepublicOfChina") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 50;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 50;
				}
				if(Mid(strName, 8) ~= "THA" || Mid(strName, 8) ~= "TH" || Mid(strName, 8) ~= "Thailand" || Mid(strName, 8) ~= "PrathetTai" || Mid(strName, 8) ~= "Prathet tai") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 51;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 51;
				}
				if(Mid(strName, 8) ~= "VNM" || Mid(strName, 8) ~= "VN" || Mid(strName, 8) ~= "VietNam" || Mid(strName, 8) ~= "Viet Nam") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 52;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 52;
				}
				if(Mid(strName, 8) ~= "AUT" || Mid(strName, 8) ~= "AT" || Mid(strName, 8) ~= "Austria" || Mid(strName, 8) ~= "Osterreich") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 53;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 53;
				}
				if(Mid(strName, 8) ~= "CZE" || Mid(strName, 8) ~= "CZ" || Mid(strName, 8) ~= "CzechRepublic" || Mid(strName, 8) ~= "Czech Republic" || Mid(strName, 8) ~= "Czech" || Mid(strName, 8) ~= "Cesko" || Mid(strName, 8) ~= "CeskaRepublika" || Mid(strName, 8) ~= "Ceska republika") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 54;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 54;
				}
				if(Mid(strName, 8) ~= "DNK" || Mid(strName, 8) ~= "DK" || Mid(strName, 8) ~= "Denmark") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 55;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 55;
				}
				if(Mid(strName, 8) ~= "FIN" || Mid(strName, 8) ~= "FI" || Mid(strName, 8) ~= "Finland" || Mid(strName, 8) ~= "Suomi") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 56;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 56;
				}
				if(Mid(strName, 8) ~= "HUN" || Mid(strName, 8) ~= "HU" || Mid(strName, 8) ~= "Hungary" || Mid(strName, 8) ~= "Magyarorszag") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 57;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 57;
				}
				if(Mid(strName, 8) ~= "ROU" || Mid(strName, 8) ~= "RO" || Mid(strName, 8) ~= "Romania") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 58;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 58;
				}
				if(Mid(strName, 8) ~= "CUB" || Mid(strName, 8) ~= "CU" || Mid(strName, 8) ~= "Cuba") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 59;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 59;
				}
				if(Mid(strName, 8) ~= "GTM" || Mid(strName, 8) ~= "GT" || Mid(strName, 8) ~= "Guatemala") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 60;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 60;
				}
				if(Mid(strName, 8) ~= "PAN" || Mid(strName, 8) ~= "PA" || Mid(strName, 8) ~= "Panama") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 61;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 61;
				}
				if(Mid(strName, 8) ~= "CHL" || Mid(strName, 8) ~= "CL" || Mid(strName, 8) ~= "Chile") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 62;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 62;
				}
				if(Mid(strName, 8) ~= "ECU" || Mid(strName, 8) ~= "EU" || Mid(strName, 8) ~= "Ecuador") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 63;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 63;
				}
				if(Mid(strName, 8) ~= "PER" || Mid(strName, 8) ~= "PR" || Mid(strName, 8) ~= "Peru") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 64;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 64;
				}
				if(Mid(strName, 8) ~= "UN" || Mid(strName, 8) ~= "UnitedNations" || Mid(strName, 8) ~= "United Nations") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 65;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 65;
				}
				if(Mid(strName, 8) ~= "XC" || Mid(strName, 8) ~= "XCOM" || Mid(strName, 8) ~= "X-COM" || Mid(strName, 8) ~= "X COM") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 66;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 66;
				}
				if(Mid(strName, 8) ~= "BOL" || Mid(strName, 8) ~= "BO" || Mid(strName, 8) ~= "Bolivia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 67;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 67;
				}
				if(Mid(strName, 8) ~= "NIC" || Mid(strName, 8) ~= "NI" || Mid(strName, 8) ~= "Nicaragua") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 68;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 68;
				}
				if(Mid(strName, 8) ~= "BGR" || Mid(strName, 8) ~= "BG" || Mid(strName, 8) ~= "Bulgaria" || Mid(strName, 8) ~= "Bulgarija") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 69;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 69;
				}
				if(Mid(strName, 8) ~= "HRV" || Mid(strName, 8) ~= "HR" || Mid(strName, 8) ~= "Croatia" || Mid(strName, 8) ~= "Hrvatska") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 70;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 70;
				}
				if(Mid(strName, 8) ~= "SRB" || Mid(strName, 8) ~= "RS" || Mid(strName, 8) ~= "Serbia" || Mid(strName, 8) ~= "Srbija") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 71;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 71;
				}
				if(Mid(strName, 8) ~= "SVK" || Mid(strName, 8) ~= "SK" || Mid(strName, 8) ~= "Slovakia" || Mid(strName, 8) ~= "Slovensko") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 72;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 72;
				}
				if(Mid(strName, 8) ~= "CHE" || Mid(strName, 8) ~= "CH" || Mid(strName, 8) ~= "Switzerland" || Mid(strName, 8) ~= "ConfoederatioHelvetica" || Mid(strName, 8) ~= "Confoederatio Helvetica" || Mid(strName, 8) ~= "HelveticConfederation" || Mid(strName, 8) ~= "Helvetic Confederation" || Mid(strName, 8) ~= "dieSchweiz" || Mid(strName, 8) ~= "die Schweiz" || Mid(strName, 8) ~= "Suisse" || Mid(strName, 8) ~= "Svizzera" || Mid(strName, 8) ~= "Svizra") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 73;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 73;
				}
				if(Mid(strName, 8) ~= "AGO" || Mid(strName, 8) ~= "AO" || Mid(strName, 8) ~= "Angola") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 74;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 74;
				}
				if(Mid(strName, 8) ~= "GHA" || Mid(strName, 8) ~= "GH" || Mid(strName, 8) ~= "Ghana") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 75;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 75;
				}
				if(Mid(strName, 8) ~= "IRQ" || Mid(strName, 8) ~= "IQ" || Mid(strName, 8) ~= "Iraq" || Mid(strName, 8) ~= "al-Iraq" || Mid(strName, 8) ~= "alIraq" || Mid(strName, 8) ~= "al Iraq" || Mid(strName, 8) ~= "al-'Iraq" || Mid(strName, 8) ~= "al'Iraq" || Mid(strName, 8) ~= "al 'Iraq") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 76;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 76;
				}
				if(Mid(strName, 8) ~= "JOR" || Mid(strName, 8) ~= "JO" || Mid(strName, 8) ~= "Jordan" || Mid(strName, 8) ~= "al-Urdun" || Mid(strName, 8) ~= "alUrdun" || Mid(strName, 8) ~= "al Urdun" || Mid(strName, 8) ~= "Urdun") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 77;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 77;
				}
				if(Mid(strName, 8) ~= "SYR" || Mid(strName, 8) ~= "SY" || Mid(strName, 8) ~= "Syria" || Mid(strName, 8) ~= "SyrianArabRepublic" || Mid(strName, 8) ~= "Syrian Arab Republic" || Mid(strName, 8) ~= "Syrian Arab Republic" || Mid(strName, 8) ~= "SAR" || Mid(strName, 8) ~= "Suriya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 78;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 78;
				}
				if(Mid(strName, 8) ~= "MNG" || Mid(strName, 8) ~= "MN" || Mid(strName, 8) ~= "Mongolia" || Mid(strName, 8) ~= "MongolUls" || Mid(strName, 8) ~= "Mongol Uls") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 79;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 79;
				}
				if(Mid(strName, 8) ~= "CRI" || Mid(strName, 8) ~= "CR" || Mid(strName, 8) ~= "CostaRica" || Mid(strName, 8) ~= "Costa Rica") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 80;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 80;
				}
				if(Mid(strName, 8) ~= "SLV" || Mid(strName, 8) ~= "SV" || Mid(strName, 8) ~= "ElSalvador" || Mid(strName, 8) ~= "El Salvador" || Mid(strName, 8) ~= "Salvador") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 81;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 81;
				}
				if(Mid(strName, 8) ~= "PRY" || Mid(strName, 8) ~= "PY" || Mid(strName, 8) ~= "Paraguay" || Mid(strName, 8) ~= "Paraguai") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 82;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 82;
				}
				if(Mid(strName, 8) ~= "URY" || Mid(strName, 8) ~= "UY" || Mid(strName, 8) ~= "Uraguay") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 83;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 83;
				}	
				if(Mid(strName, 8) ~= "ALB" || Mid(strName, 8) ~= "AL" || Mid(strName, 8) ~= "Albania" || Mid(strName, 8) ~= "Shqiperia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 84;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 84;
				}
				if(Mid(strName, 8) ~= "BLR" || Mid(strName, 8) ~= "BY" || Mid(strName, 8) ~= "Belarus" || Mid(strName, 8) ~= "Bieiarus" || Mid(strName, 8) ~= "Belarus'") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 85;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 85;
				}
				if(Mid(strName, 8) ~= "EST" || Mid(strName, 8) ~= "EE" || Mid(strName, 8) ~= "Estonia" || Mid(strName, 8) ~= "Eesti") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 86;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 86;
				}
				if(Mid(strName, 8) ~= "ISL" || Mid(strName, 8) ~= "IS" || Mid(strName, 8) ~= "Iceland" || Mid(strName, 8) ~= "Island") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 87;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 87;
				}
				if(Mid(strName, 8) ~= "RKS" || Mid(strName, 8) ~= "UNK" || Mid(strName, 8) ~= "XK" || Mid(strName, 8) ~= "KOS" || Mid(strName, 8) ~= "Kosovo" || Mid(strName, 8) ~= "Kosova" || Mid(strName, 8) ~= "Kosove") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 88;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 88;
				}
				if(Mid(strName, 8) ~= "LVA" || Mid(strName, 8) ~= "LV" || Mid(strName, 8) ~= "Latvia" || Mid(strName, 8) ~= "Latvija") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 89;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 89;
				}
				if(Mid(strName, 8) ~= "LTU" || Mid(strName, 8) ~= "LT" || Mid(strName, 8) ~= "Lithuania" || Mid(strName, 8) ~= "Lietuva") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 90;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 90;
				}
				if(Mid(strName, 8) ~= "MKD" || Mid(strName, 8) ~= "MK" || Mid(strName, 8) ~= "Macedonia" || Mid(strName, 8) ~= "Makedonija") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 91;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 91;
				}
				if(Mid(strName, 8) ~= "MDA" || Mid(strName, 8) ~= "MD" || Mid(strName, 8) ~= "Moldova") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 92;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 92;
				}
				if(Mid(strName, 8) ~= "MNE" || Mid(strName, 8) ~= "ME" || Mid(strName, 8) ~= "Montenegro" || Mid(strName, 8) ~= "CrnaGora" || Mid(strName, 8) ~= "Crna Gora") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 93;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 93;
				}
				if(Mid(strName, 8) ~= "SVN" || Mid(strName, 8) ~= "SI" || Mid(strName, 8) ~= "Slovenia" || Mid(strName, 8) ~= "Slovenija") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 94;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 94;
				}
				if(Mid(strName, 8) ~= "BWA" || Mid(strName, 8) ~= "BW" || Mid(strName, 8) ~= "Botswana") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 95;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 95;
				}
				if(Mid(strName, 8) ~= "CMR" || Mid(strName, 8) ~= "CM" || Mid(strName, 8) ~= "Cameroon" || Mid(strName, 8) ~= "Cameroun") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 96;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 96;
				}
				if(Mid(strName, 8) ~= "COD" || Mid(strName, 8) ~= "CD" || Mid(strName, 8) ~= "DRCongo" || Mid(strName, 8) ~= "DR Congo" || Mid(strName, 8) ~= "DemocraticRepublicOfCongo" || Mid(strName, 8) ~= "DemocraticRepublicOfTheCongo" || Mid(strName, 8) ~= "Democratic Republic of Congo" || Mid(strName, 8) ~= "Democratic Republic of the Congo" || Mid(strName, 8) ~= "Kinshassa" || Mid(strName, 8) ~= "RepubliqueDemocratiqueDuCongo" || Mid(strName, 8) ~= "Republique Democratique Du Congo") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 97;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 97;
				}
				if(Mid(strName, 8) ~= "GAB" || Mid(strName, 8) ~= "GA" || Mid(strName, 8) ~= "Gabon" || Mid(strName, 8) ~= "LeGabon" || Mid(strName, 8) ~= "Le Gabon") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 98;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 98;
				}
				if(Mid(strName, 8) ~= "CIV" || Mid(strName, 8) ~= "CI" || Mid(strName, 8) ~= "IvoryCoast" || Mid(strName, 8) ~= "Ivory Coast" || Mid(strName, 8) ~= "Ivory Coast" || Mid(strName, 8) ~= "CoteDIvoire" || Mid(strName, 8) ~= "Cote dIvoire" || Mid(strName, 8) ~= "CoteD'Ivoire" || Mid(strName, 8) ~= "Cote d'Ivoire") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 99;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 99;
				}
				if(Mid(strName, 8) ~= "LBY" || Mid(strName, 8) ~= "LY" || Mid(strName, 8) ~= "Libya" || Mid(strName, 8) ~= "Libiya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 100;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 100;
				}
				if(Mid(strName, 8) ~= "MOZ" || Mid(strName, 8) ~= "MZ" || Mid(strName, 8) ~= "Mozambique" || Mid(strName, 8) ~= "Mocambique") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 101;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 101;
				}
				if(Mid(strName, 8) ~= "NAM" || Mid(strName, 8) ~= "NA" || Mid(strName, 8) ~= "Namibia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 102;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 102;
				}
				if(Mid(strName, 8) ~= "SEN" || Mid(strName, 8) ~= "SN" || Mid(strName, 8) ~= "Senegal") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 103;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 103;
				}
				if(Mid(strName, 8) ~= "SDN" || Mid(strName, 8) ~= "SD" || Mid(strName, 8) ~= "Sudan" || Mid(strName, 8) ~= "as-Sudan" || Mid(strName, 8) ~= "asSudan" || Mid(strName, 8) ~= "as Sudan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 104;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 104;
				}
				if(Mid(strName, 8) ~= "TUN" || Mid(strName, 8) ~= "TN" || Mid(strName, 8) ~= "Tunisia" || Mid(strName, 8) ~= "Tunisiya") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 105;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 105;
				}
				if(Mid(strName, 8) ~= "ZMB" || Mid(strName, 8) ~= "ZM" || Mid(strName, 8) ~= "Zambia") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 106;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 106;
				}
				if(Mid(strName, 8) ~= "AFG" || Mid(strName, 8) ~= "AF" || Mid(strName, 8) ~= "Afghanistan" || Mid(strName, 8) ~= "Afganistan" || Mid(strName, 8) ~= "Afganestan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 107;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 107;
				}
				if(Mid(strName, 8) ~= "ARM" || Mid(strName, 8) ~= "AM" || Mid(strName, 8) ~= "Armenia" || Mid(strName, 8) ~= "Hayastan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 108;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 108;
				}
				if(Mid(strName, 8) ~= "AZE" || Mid(strName, 8) ~= "AZ" || Mid(strName, 8) ~= "Azerbaijan" || Mid(strName, 8) ~= "Azerbaycan" || Mid(strName, 8) ~= "Azerbaijan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 109;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 109;
				}
				if(Mid(strName, 8) ~= "GEO" || Mid(strName, 8) ~= "GE" || Mid(strName, 8) ~= "Georgia" || Mid(strName, 8) ~= "SakArtVelo" || Mid(strName, 8) ~= "Sak art velo" || Mid(strName, 8) ~= "Sak'art'velo") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 110;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 110;
				}
				if(Mid(strName, 8) ~= "KWT" || Mid(strName, 8) ~= "KW" || Mid(strName, 8) ~= "Kuwait" || Mid(strName, 8) ~= "al-Kuwayt" || Mid(strName, 8) ~= "alKuwayt" || Mid(strName, 8) ~= "al Kuwayt" || Mid(strName, 8) ~= "Kuwayt") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 111;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 111;
				}
				if(Mid(strName, 8) ~= "LBN" || Mid(strName, 8) ~= "LB" || Mid(strName, 8) ~= "Lebanon" || Mid(strName, 8) ~= "Lebannon" || Mid(strName, 8) ~= "Lubnan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 112;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 112;
				} 
				if(Mid(strName, 8) ~= "OMN" || Mid(strName, 8) ~= "OM" || Mid(strName, 8) ~= "Oman" || Mid(strName, 8) ~= "Uman" || Mid(strName, 8) ~= "'Uman") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 113;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 113;
				}
				if(Mid(strName, 8) ~= "PSE" || Mid(strName, 8) ~= "PS" || Mid(strName, 8) ~= "Palestine" || Mid(strName, 8) ~= "Filastin") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 114;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 114;
				} 
				if(Mid(strName, 8) ~= "QAT" || Mid(strName, 8) ~= "QA" || Mid(strName, 8) ~= "Qatar") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 115;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 115;
				}
				if(Mid(strName, 8) ~= "ARE" || Mid(strName, 8) ~= "AE" || Mid(strName, 8) ~= "UnitedArabEmirates" || Mid(strName, 8) ~= "United Arab Emirates" || Mid(strName, 8) ~= "UAE" || Mid(strName, 8) ~= "al-Imarat" || Mid(strName, 8) ~= "alImarat" || Mid(strName, 8) ~= "DawlatAl-ImaratAl-ArabiyaAl-Muttahida" || Mid(strName, 8) ~= "Dawlat al-Imarat al-Arabiya al-Muttahida" || Mid(strName, 8) ~= "Dawlat alImarat alArabiya alMuttahida" || Mid(strName, 8) ~= "Dawlat al Imarat al Arabiya al Muttahida" || Mid(strName, 8) ~= "DawlatAlImaratAlArabiyaAlMuttahida" || Mid(strName, 8) ~= "DawlatAl ImaratAl ArabiyaAl Muttahida" || Mid(strName, 8) ~= "DawlatAl-ImaratAl-'ArabiyaAl-Muttahida" || Mid(strName, 8) ~= "Dawlat al-Imarat al-'Arabiya al-Muttahida" || Mid(strName, 8) ~= "Dawlat alImarat al'Arabiya alMuttahida" || Mid(strName, 8) ~= "Dawlat al Imarat al 'Arabiya al Muttahida" || Mid(strName, 8) ~= "DawlatAlImaratAl'ArabiyaAlMuttahida" || Mid(strName, 8) ~= "DawlatAl ImaratAl 'ArabiyaAl Muttahida") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 116;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 116;
				}
				if(Mid(strName, 8) ~= "YEM" || Mid(strName, 8) ~= "YE" || Mid(strName, 8) ~= "Yemen" || Mid(strName, 8) ~= "al-Yaman" || Mid(strName, 8) ~= "alYaman" || Mid(strName, 8) ~= "al Yaman") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 117;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 117;
				}
				if(Mid(strName, 8) ~= "KHM" || Mid(strName, 8) ~= "KH" || Mid(strName, 8) ~= "Cambodia" || Mid(strName, 8) ~= "Kampuchea") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 118;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 118;
				}
				if(Mid(strName, 8) ~= "KGZ" || Mid(strName, 8) ~= "KG" || Mid(strName, 8) ~= "Kyrgyzstan") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 119;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 119;
				}
				if(Mid(strName, 8) ~= "LAO" || Mid(strName, 8) ~= "LA" || Mid(strName, 8) ~= "Laos" || Mid(strName, 8) ~= "Lao" || Mid(strName, 8) ~= "Law") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 120;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 120;
				}
				if(Mid(strName, 8) ~= "MMR" || Mid(strName, 8) ~= "MM" || Mid(strName, 8) ~= "Myanmar" || Mid(strName, 8) ~= "Burma" || Mid(strName, 8) ~= "Myanma" || Mid(strName, 8) ~= "Bama") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 121;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 121;
				}
				if(Mid(strName, 8) ~= "NPL" || Mid(strName, 8) ~= "NP" || Mid(strName, 8) ~= "Nepal") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 122;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 122;
				}
				if(Mid(strName, 8) ~= "SGP" || Mid(strName, 8) ~= "SG" || Mid(strName, 8) ~= "Singapore" || Mid(strName, 8) ~= "xinjiapo" || Mid(strName, 8) ~= "Singapura" || Mid(strName, 8) ~= "Cinkappur") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 123;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 123;
				}
				if(Mid(strName, 8) ~= "LKA" || Mid(strName, 8) ~= "LK" || Mid(strName, 8) ~= "SriLanka" || Mid(strName, 8) ~= "Sri Lanka" || Mid(strName, 8) ~= "Sri Lanka" || Mid(strName, 8) ~= "SriLamka" || Mid(strName, 8) ~= "Sri Lamka" || Mid(strName, 8) ~= "Ilankai") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 124;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 124;
				}
				if(Mid(strName, 8) ~= "TJK" || Mid(strName, 8) ~= "TJ" || Mid(strName, 8) ~= "Tajikistan" || Mid(strName, 8) ~= "Tojikiston") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 125;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 125;
				}
				if(Mid(strName, 8) ~= "UZB" || Mid(strName, 8) ~= "UZ" || Mid(strName, 8) ~= "Uzbekistan" || Mid(strName, 8) ~= "Ozbekiston" || Mid(strName, 8) ~= "O'zbekiston") {
					kSoldierUI.m_kSoldier.m_kSoldier.iCountry = 126;
					kSoldierUI.m_kSoldier.m_kSoldier.kAppearance.iFlag = 126;
				}
			}
			kSoldierUI.UpdateDoll();
			kSoldierUI.SetActiveSoldier(kSoldierUI.m_kSoldier);
			kSoldierUI.UpdateView();
		}
		

		
			outer.WorldInfo.Game.Mutate("ASCAscensionVersion", outer.GetALocalPlayerController());
			iIndex = 0;
			J0xA9:
			// End:0x148 [Loop If]
			if(0 < int(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2) && int(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2) < 3)
			{
				if(int(strName) > 172)
				{
					outer.WorldInfo.Game.Mutate("ASCPerks" $ "_" $ "GivePerk" $ "_" $ string(kSoldierUI.m_kSoldier.m_kSoldier.iID) $ "_" $ strName, outer.GetALocalPlayerController());
					goto eperks;
				}
				else
				{
					if(iIndex < 255)
					{
						goto innerloop;
					}
					else
					{
						goto endloop1;
					}
				}
			}
			else
			{
				if(iIndex < 172)
				{
					goto innerloop;
				}
				else
				{
					goto endloop1;
				}
			}
				innerloop:
				strPerkName = kPerkMan.GetPerkName(iIndex);
				// End:0x13A
				if(((strName != "") && strName != "NONE") && strPerkName ~= strName)
				{
					bFound = true;
					// [Explicit Break]
					goto endloop1;
				}
				++ iIndex;
				// [Loop Continue]
				goto J0xA9;
				
				endloop1:
			// End:0x3D2
			if(!bFound)
			{
				iIndex = int(strName);
				kPerk = kPerkMan.GetPerk(iIndex);
				// End:0x1FF
				if(kPerk.iPerk != 0)
				{
					bFound = true;
					strPerkName = kPerkMan.GetPerkName(iIndex);
				}
				// End:0x3D2
				if(iIndex < 0)
				{
					if(iIndex < -172)
					{
						outer.WorldInfo.Game.Mutate("ASCPerks" $ "_" $ "RemovePerk" $ "_" $ string(kSoldierUI.m_kSoldier.m_kSoldier.iID) $ "_" $ string(-1 * iIndex), outer.GetALocalPlayerController());
					}
					else
					{
						kSoldierUI.m_kSoldier.m_kChar.aUpgrades[-1 * iIndex] = 0;
					}
				}
			}
			// End:0x586
			if(bFound)
			{
				kSoldierUI.m_kSoldier.GivePerk(iIndex);
			}
			else 
			{
				
				if(Left(strName, 1) == "-")
				{
					outer.WorldInfo.Game.Mutate("ASCAscensionVersion", outer.GetALocalPlayerController());
					iIndex = 0;
					loopstart:
					if(0 < int(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2) && int(XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam")).StrValue2) < 3)
					{
						if(iIndex < 255)
						{
							goto innerloop2;
						}
						else
						{
							goto endloop;
						}
					}
					else
					{		
						if(iIndex < 172)
						{
							goto innerloop2;
						}
						else
						{
							goto endloop;
						}
					}
						innerloop2:
							strPerkName = kPerkMan.GetPerkName(iIndex);
							// End:0x13A
							if(((Mid(strName, 1) != "") && Mid(strName, 1) != "NONE") && strPerkName ~= Mid(strName, 1))
							{
								bFound = true;
								// [Explicit Break]
								goto endloop;
							}
							++ iIndex;
							// [Loop Continue]
							goto loopstart;
						
							endloop:
						}
					
					if(bFound)
					{
						if(iIndex < 172)
						{
							kSoldierUI.m_kSoldier.m_kChar.aUpgrades[iIndex] = 0;
						}
						else
						{
							if(iIndex < 255)
							{
								outer.WorldInfo.Game.Mutate("ASCPerks" $ "_" $ "RemovePerk" $ "_" $ string(kSoldierUI.m_kSoldier.m_kSoldier.iID) $ "_" $ string(iIndex), outer.GetALocalPlayerController());
							}
						}
					}
				}
	eperks:
		kSoldierUI.m_kSoldier.onLoadoutChange();
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierSummary.SetSoldier(kSoldierUI.m_kSoldier);
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.GetMgr().UpdateView();
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.UpdateAbilityData();
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierHeader.UpdateData();
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kSoldierPromote.m_kSoldierStats.UpdateData();
	}
	if((XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)) != none) && XGShip_Interceptor(XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)).m_kShip) != none) {
		
		if(Left(strName, 4) ~= "ship")
		{
			if(Mid(strName, 5, 4) ~= "name")
			{
				if(Left(class'XComLocalizer'.static.ExpandString(class'XGLocalizedData'.default.ShipWeaponFlavorTxt[11]), 4) == "F.O.")
				{
					XGShip_Interceptor(XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)).m_kShip).m_strCallsign = Left(XGShip_Interceptor(XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)).m_kShip).m_strCallsign, InStr(XGShip_Interceptor(XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)).m_kShip).m_strCallsign, " ")) @ Mid(strName, 10);
				}
				else
				{
					XGShip_Interceptor(XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)).m_kShip).m_strCallsign = Mid(strName, 10);
				}
			}
			if(Mid(strName, 5, 5) ~= "kills") {
				XGShip_Interceptor(XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)).m_kShip).m_iConfirmedKills += int(Mid(strName, 11));
			}
			if(Mid(strName, 5, 2) ~= "hp") {
				XGShip_Interceptor(XGHangarUI(XComHQPresentationLayer(XComPlayerController(Outer.GetALocalPlayerController()).m_Pres).GetMgr(class'XGHangarUI',,, true)).m_kShip).m_kTShip.iHP += int(Mid(strName, 8));
			}
		}
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kShipSummary.OnInit();
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kShipSummary.UpdateData();
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kShipList.OnInit();
		XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().PRES().m_kShipList.UpdateData();
	}
	if(XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBase != none)
	{
		if(strName ~= "BaseRoll")
		{
			XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBase.GenerateTiles();
		}
	}
	
    //return;   
    */
}
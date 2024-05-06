class XGFundingCouncil extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EFCRequestType
{
    eFCRType_None,
    eFCRType_SellArtifacts,
    eFCRType_SatLaunch,
    eFCRType_JetTransfer,
    eFCRType_MAX
};

enum EFCRequest
{
    eFCR_None,
    eFCR_SellBodies,
    eFCR_SellRobotics,
    eFCR_SellRoboticsII,
    eFCR_SellFragments,
    eFCR_SellNavComputers,
    eFCR_SellPharma,
    eFCR_SellWeapons,
    eFCR_SellWeaponsII,
    eFCR_SellPower,
    eFCR_SellAlloys,
    eFCR_SellArcs,
    eFCR_SatCountry,
    eFCR_JetTransfer,
    eFCR_SellMutons,
    eFCR_SellChryssalids,
    eFCR_SellHeavyFloaters,
    eFCR_SellSectopods,
    eFCR_SellStims,
    eFCR_SellPlasmaPistols,
    eFCR_SellPlasmaRifles,
    eFCR_SellLightPlasmaRifles,
    eFCR_SellHeavyPlasmas,
    eFCR_SellHeavyLasers,
    eFCR_SellScatterLasers,
    eFCR_SellAlloyCannons,
    eFCR_SellScopes,
    eFCR_SellNanoFiberVests,
    eFCR_SellMechtoidCores,
    eFCR_SellSeekerWrecks,
    eFCR_SellGhostGrenades,
    eFCR_SellGasGrenades,
    eFCR_SellReaperRounds,
    eFCR_SellMimicBeacons,
    eFCR_SellFlashbangs,
    eFCR_SellEXALTRifles,
    eFCR_SellEXALTSniperRifles,
    eFCR_SellEXALTLMGs,
    eFCR_SellEXALTRocketLaunchers,
    eFCR_SellEXALTLaserRifles,
    eFCR_SellEXALTLaserSniperRifles,
    eFCR_SellEXALTHeavyLasers,
    eFCR_MAX
};

enum EFCRewardType
{
    eFCReward_None,
    eFCReward_Money,
    eFCReward_Code,
    eFCReward_Soldier,
    eFCReward_Scientist,
    eFCReward_Engineer,
    eFCReward_Panic,
    eFCReward_Satellite,
    eFCReward_Elerium,
    eFCReward_CustomSoldier,
    eFCReward_ExaltIntel,
    eFCReward_MAX
};

struct TFundingCouncilRewardSoldier
{
    var string firstName;
    var string lastName;
    var string NickName;
    var ESoldierClass soldierClass;
    var ESoldierRanks SoldierRank;
    var TAppearance Appearance;
    var ECountry Country;
    var int HP;
    var int Aim;
    var int Will;
    var bool bPsiGift;
    var int RequiredRestDays;

    structdefaultproperties
    {
        firstName=""
        lastName=""
        NickName=""
        soldierClass=ESoldierClass.eSC_None
        SoldierRank=ESoldierRanks.eRank_Rookie
        Appearance=(iHead=-1,iGender=0,iRace=0,iHaircut=-1,iHairColor=0,iFacialHair=0,iBody=-1,iBodyMaterial=-1,iSkinColor=-1,iEyeColor=-1,iFlag=-1,iArmorSkin=-1,iVoice=-1,iLanguage=0,iAttitude=0,iArmorDeco=-1,iArmorTint=-1)
        Country=ECountry.eCountry_USA
        HP=0
        Aim=0
        Will=0
        bPsiGift=false
        RequiredRestDays=0
    }
};

struct TFCMission
{
    var EFCMission eMission;
    var EFCMissionType eType;
    var array<EFCRewardType> arrRewards;
    var array<TFundingCouncilRewardSoldier> arrRewardSoldiers;
    var XComNarrativeMoment NarrIntro;
    var string strName;
    var string strIntro;
    var string strCompletion;
    var string strFailure;
    var string strSituationBrief;
    var string strObjectivesBrief;
    var string strTickerSuccess;
    var string strTickerFail;
    var string strTickerIgnore;
    var string strMapName;
    var int iFirstAct;
    var int iPanicOnFailure;
    var bool bExplicitSoldier;
    var ECountry ECountry;
    var array<int> arrRewardAmounts;

    structdefaultproperties
    {
        eMission=EFCMission.eFCM_None
        eType=EFCMissionType.eFCMType_None
        arrRewards=none
        arrRewardSoldiers=none
        NarrIntro=none
        strName=""
        strIntro=""
        strCompletion=""
        strFailure=""
        strSituationBrief=""
        strObjectivesBrief=""
        strTickerSuccess=""
        strTickerFail=""
        strTickerIgnore=""
        strMapName=""
        iFirstAct=0
        iPanicOnFailure=0
        bExplicitSoldier=false
        ECountry=ECountry.eCountry_USA
        arrRewardAmounts=none
    }
};

struct TFCRequest
{
    var EFCRequest eRequest;
    var EFCRequestType eType;
    var array<EFCRewardType> arrRewards;
    var array<int> arrRewardAmounts;
    var array<ETechType> arrRequirements;
    var XComNarrativeMoment NarrIntro;
    var string strName;
    var string strIntro;
    var string strCompletion;
    var string strTickerSuccess;
    var string strTickerIgnore;
    var bool bExalt;
    var bool bEliteExalt;
    var ECountry ECountry;
    var EItemType eRequestedItem;
    var EItemType eDisplayItem;
    var int iRequestedAmount;
    var int iHours;
    var int iCooldown;
    var bool bIsTransferRequest;
    var bool bIsTransferComplete;

    structdefaultproperties
    {
        eRequest=EFCRequest.eFCR_None
        eType=EFCRequestType.eFCRType_None
        arrRewards=none
        arrRewardAmounts=none
        arrRequirements=none
        NarrIntro=none
        strName=""
        strIntro=""
        strCompletion=""
        strTickerSuccess=""
        strTickerIgnore=""
        bExalt=false
        bEliteExalt=false
        ECountry=ECountry.eCountry_USA
        eRequestedItem=eItem_NONE
        eDisplayItem=eItem_NONE
        iRequestedAmount=0
        iHours=0
        iCooldown=0
        bIsTransferRequest=false
        bIsTransferComplete=false
    }
};

struct CheckpointRecord
{
    var array<EFCMission> m_arrPreviousMissions;
    var array<EFCRequest> m_arrPreviousRequests;
    var int m_iLastAddedMissionID;
    var int m_iFirstRequestCountdown;
    var int m_iSecondRequestCountdown;
    var array<TFCRequest> m_arrPendingRequests;
    var array<TFCRequest> m_arrCurrentRequests;
    var bool m_bProgenyEnabled;
    var EFCMission m_eNextProgenyMission;
    var bool m_bSlingshotEnabled;
    var EFCMission m_eNextSlingshotMission;
    var EFCMission m_eLastSlingshotMission;
    var int m_iNextSlingshotDay;
    var int m_iNextAnnetteMusing;
    var bool m_bFuriesWon;
    var int m_iFCMissionsThisMonth;
    var int m_iFCRequestsThisMonth;
    var int m_iRequestCoolDown[EFCRequest];

    structdefaultproperties
    {
        m_arrPreviousMissions=none
        m_arrPreviousRequests=none
        m_iLastAddedMissionID=0
        m_iFirstRequestCountdown=0
        m_iSecondRequestCountdown=0
        m_arrPendingRequests=none
        m_arrCurrentRequests=none
        m_bProgenyEnabled=false
        m_eNextProgenyMission=eFCM_None
        m_bSlingshotEnabled=false
        m_eNextSlingshotMission=eFCM_None
        m_eLastSlingshotMission=eFCM_None
        m_iNextSlingshotDay=0
        m_iNextAnnetteMusing=0
        m_bFuriesWon=false
        m_iFCMissionsThisMonth=0
        m_iFCRequestsThisMonth=0
        m_iRequestCoolDown[0]=0
        m_iRequestCoolDown[1]=0
        m_iRequestCoolDown[2]=0
        m_iRequestCoolDown[3]=0
        m_iRequestCoolDown[4]=0
        m_iRequestCoolDown[5]=0
        m_iRequestCoolDown[6]=0
        m_iRequestCoolDown[7]=0
        m_iRequestCoolDown[8]=0
        m_iRequestCoolDown[9]=0
        m_iRequestCoolDown[10]=0
        m_iRequestCoolDown[11]=0
        m_iRequestCoolDown[12]=0
        m_iRequestCoolDown[13]=0
        m_iRequestCoolDown[14]=0
        m_iRequestCoolDown[15]=0
        m_iRequestCoolDown[16]=0
        m_iRequestCoolDown[17]=0
        m_iRequestCoolDown[18]=0
        m_iRequestCoolDown[19]=0
        m_iRequestCoolDown[20]=0
        m_iRequestCoolDown[21]=0
        m_iRequestCoolDown[22]=0
        m_iRequestCoolDown[23]=0
        m_iRequestCoolDown[24]=0
        m_iRequestCoolDown[25]=0
        m_iRequestCoolDown[26]=0
        m_iRequestCoolDown[27]=0
        m_iRequestCoolDown[28]=0
        m_iRequestCoolDown[29]=0
        m_iRequestCoolDown[30]=0
        m_iRequestCoolDown[31]=0
        m_iRequestCoolDown[32]=0
        m_iRequestCoolDown[33]=0
        m_iRequestCoolDown[34]=0
        m_iRequestCoolDown[35]=0
        m_iRequestCoolDown[36]=0
        m_iRequestCoolDown[37]=0
        m_iRequestCoolDown[38]=0
        m_iRequestCoolDown[39]=0
        m_iRequestCoolDown[40]=0
        m_iRequestCoolDown[41]=0
    }
};

var config int REQUEST_WINDOW1_MIN_DAY;
var config int REQUEST_WINDOW1_MAX_DAY;
var config int REQUEST_WINDOW2_MIN_DAY;
var config int REQUEST_WINDOW2_MAX_DAY;
var config int REQUEST_MISSION_CHANCE;
var config int FCREQUEST_DAYS;
var config int DELUGE_GAP_HOURS;
var config int MIN_MONEY_REWARD;
var config int MAX_MONEY_REWARD;
var config int MAX_MONEY_REWARD_HARD;
var config int MAX_MONEY_REWARD_CLASSIC;
var config int MIN_MONEY_REWARD_EASY;
var config float FIRST_MONTH_MULTIPLIER;
var config float SECOND_MONTH_MULTIPLIER;
var config int SMALL_DEMAND_AMOUNT;
var config int BIG_DEMAND_AMOUNT;
var config int HUGE_DEMAND_AMOUNT;
var config float PROFIT_MARGIN;
var config float FCM_MONEY_SCALAR;
var config float FCM_INTEL_CHANCE;
var config int BASE_REQUEST_COOLDOWN_DAYS;
var config int FC_REQUEST_EXTENDED_COOLDOWN_DAYS;
var config int MISSION_FAIL_LOW_PANIC;
var config int MISSION_FAIL_HIGH_PANIC;
var config int MISSION_REWARD_LOW_DAYS;
var config float MISSION_REWARD_LOW_MULT;
var config int MISSION_REWARD_MED_DAYS;
var config float MISSION_REWARD_MED_MULT;
var config int MISSION_REWARD_SOLDIER_LOW_LEVEL;
var config int MISSION_REWARD_SOLDIER_MED_LEVEL;
var config int MISSION_REWARD_SOLDIER_HIGH_LEVEL;
var config int SLINGSHOT_LOWFRIENDS_START_DAY;
var config int SLINGSHOT_CNFNDLIGHT_DAYS;
var config int SLINGSHOT_GANGPLANK_DAYS;
var int m_iFCMissionsThisMonth;
var int m_iFCRequestsThisMonth;
var int m_iRequestCoolDown[EFCRequest];
var bool m_bProgenyEnabled;
var bool m_bSlingshotEnabled;
var privatewrite bool m_bPlayAnnetteMusing;
var private bool m_bFuriesWon;
var EFCMission m_eNextProgenyMission;
var EFCMission m_eNextSlingshotMission;
var EFCMission m_eLastSlingshotMission;
var ECountry m_ePendingSatelliteRequestCountry;
var int m_iNextSlingshotDay;
var privatewrite int m_iNextAnnetteMusing;
var int m_iFirstRequestCountdown; // Countdown (hours) to the next FC mission
var int m_iSecondRequestCountdown; // Countdown (hours) to the next FC request
var array<EFCMission> m_arrPreviousMissions;
var array<EFCRequest> m_arrPreviousRequests;
var int m_iLastAddedMissionID;
var int m_iLastCompletedSatelliteTransferRequestID;
var array<TFCRequest> m_arrPendingRequests;
var array<TFCRequest> m_arrExpiredRequests;
var array<TFCRequest> m_arrCurrentRequests;
var array<TFCMission> m_arrTMissions;
var array<TFCRequest> m_arrTRequests;
var const localized string m_strMissionNames[EFCMission];
var const localized string m_strMissionIntro[EFCMission];
var const localized string m_strMissionComplete[EFCMission];
var const localized string m_strMissionSuccess[EFCMission];
var const localized string m_strMissionFail[EFCMission];
var const localized string m_strMissionIgnore[EFCMission];
var const localized string m_strMissionSituation[EFCMission];
var const localized string m_strMissionObjectives[EFCMission];
var const localized string m_strRequestNames[EFCRequest];
var const localized string m_strRequestIntro[EFCRequest];
var const localized string m_strRequestCompletion[EFCRequest];
var const localized string m_strRequestSuccess[EFCRequest];
var const localized string m_strRequestIgnore[EFCRequest];
var const localized string m_strLabelRequestExpiredExplanation;
var const localized string m_strSpecialMissionFailed;
var XGFundingCouncil_RequestAdaptor m_kSatRequestCompleteAdaptor;
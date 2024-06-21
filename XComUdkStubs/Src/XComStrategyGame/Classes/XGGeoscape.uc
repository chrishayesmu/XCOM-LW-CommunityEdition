/*******************************************************************************
 * XGGeoscape generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGGeoscape extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);

const MIN_FLIGHT_SECONDS = 3.0f;

struct TMCPin
{
    var Vector2D v2Loc;
    var TText txtTitle;
    var float fTimer;
};

struct CheckpointRecord
{
    var float m_fTimeScale;
    var float m_fAITimer;
    var float m_fGameTimer;
    var int m_iTicks;
    var int m_iDetectedUFOs;
    var bool m_bUFOIgnored;
    var array<XGMission> m_arrMissions;
    var int m_iNumMissions;
    var int m_iMissionCounter;
    var int m_iFunding;
    var int m_iFundingChange;
    var int m_iLastMonthPaid;
    var bool m_bFirstTime;
    var XGMission_ReturnToBase m_kReturnMission;
    var XGDateTime m_kDateTime;
    var array<XGInterception> m_arrInterceptions;
    var array<int> m_arrCraftEncounters;
    var bool m_bGlobeHidden;
    var bool m_bAchivementsEnabled;
    var bool m_bAchievementsDisabledXComHero;
    var XGEntity m_kTemple;
    var bool m_bDEMOPlayedTerror;
};

var float m_fTimeScale;
var float m_fAITimer;
var float m_fGameTimer;
var int m_iTicks;
var int m_iDetectedUFOs;
var bool m_bUFOIgnored;
var bool m_bGlobeHidden;
var bool m_bFirstTime;
var bool m_bInPauseMenu;
var bool m_bAchivementsEnabled;
var bool m_bAchievementsDisabledXComHero;
var bool m_bDEMOPlayedTerror;
var bool m_bSeeAll;
var bool m_bInFinalBriefing;
var bool m_bActiveFundingCouncilRequestPopup;
var array<XGMission> m_arrMissions;
var int m_iNumMissions;
var int m_iMissionCounter;
var int m_iLastMonthPaid;
var XGMission_ReturnToBase m_kReturnMission;
var XGDateTime m_kDateTime;
var array<TGeoscapeAlert> m_arrAlerts;
var array<XGInterception> m_arrInterceptions;
var array<int> m_arrCraftEncounters;
var export editinline AudioComponent m_sndUFOKlaxon;
var float m_fTimeForShips;
var XGEntity m_kTemple;
var XGGeoscapeUI UI;
var array<XGMission> m_arrRemove;
var float m_fTickTime;
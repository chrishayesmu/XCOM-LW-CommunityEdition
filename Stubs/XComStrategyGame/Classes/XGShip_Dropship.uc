class XGShip_Dropship extends XGShip
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord_XGShip_Dropship extends CheckpointRecord
{
    var XGDropshipCargoInfo CargoInfo;
    var array<XGStrategySoldier> m_arrSoldiers;
    var XGStrategySoldier m_kCovertOperative;
    var int m_iCapacity;
    var string m_strCallsign;
    var int m_iNumMissions;
    var array<int> m_arrUpgrades;
    var bool m_bReturnedFromCombat;
    var bool m_bReturnedFromFirstMission;
    var string m_strLastOpName;
    var bool m_bExtendSquadForHQAssault;
    var bool m_bReinforcementsForHQAssault;
};

var XGDropshipCargoInfo CargoInfo;
var array<XGStrategySoldier> m_arrSoldiers;
var XGStrategySoldier m_kCovertOperative;
var int m_iCapacity;
var string m_strCallsign;
var int m_iNumMissions;
var array<int> m_arrUpgrades;
var bool m_bReturnedFromCombat;
var bool m_bReturnedFromFirstMission;
var bool m_bAllCapturePointsHeld;
var bool m_bExtendSquadForHQAssault;
var bool m_bReinforcementsForHQAssault;
var string m_strLastOpName;
var const localized string m_strLabelReady;
var const localized string m_strProprietaryTitaniumAlloy;
var const localized string m_strDualVTOLRamjet;
var const localized string m_str5000Miles;

function BuildTransferData(){}
function ReconstructTransferData(){}
function bool HasReturnedFromCombat(){}
function bool CanPlayEngineSound(){}
function Init(TShip kTShip){}
function InitSound(){}
function Land(){}
function bool IsFull(){}
function int GetCapacity(){}
function string GetCallsign(){}
function bool HaveUpgrade(int iUpgrade){}
function float GetFlightTime(Vector2D v2Dest){}
function string GetStatusString(){}
function int GetStatusUIState(){}
function TShipUIInfo GetUIInfo(){}
function bool IsHumanShip(){}


DefaultProperties
{
}

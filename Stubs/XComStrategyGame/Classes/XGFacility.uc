class XGFacility extends XGStrategyActor
    hidecategories(Navigation)
    config(GameData)
    abstract
    notplaceable;

struct CheckpointRecord
{
    var bool m_bFirstVisit;
    var bool m_bRequiresAttention;
    var bool m_bDisabled;
};

var bool m_bFirstVisit;
var bool m_bRequiresAttention;
var bool m_bDisabled;
var XGGameData.EFacilityType m_eFacility;
var XComHQSoundCollection.EMusicCue m_eMusic;
var XComHQSoundCollection.EAmbienceCue m_eAmbience;
var name m_nmRoomName;

function XGRecapSaveData GetRecapSaveData(){    }
function BaseInit(){  }
function Init(bool bLoadingFromSave){  }
function InitNewGame(){   }
function InitLoadGame(){    }
function CreateEntity(){ }
function Activate(){   }
function Update(){   }
function Enter(int iView){    }
function PlayFacilitySounds(){   }
function Exit(){   }
function bool RequiresAttention(){}
function bool IsDisabled(){  }
function bool Narrative(XComNarrativeMoment Moment){}
function PlayFirstUnseenNarrative(XComNarrativeMoment kFirst, XComNarrativeMoment kSecond, optional XComNarrativeMoment kThird){}
function bool IsFirstVisit(){}
function name FacilityEntName(){}
function FindRoomLoc(){}
function SetDisabled(bool bDisable){}
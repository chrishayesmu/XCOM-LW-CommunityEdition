class XComSpawnPoint extends XComSpawnPointNativeBase
	dependsOn(XGGameData);
//complete stub

struct CheckpointRecord
{
    var Actor m_kLastActorSpawned;

    structdefaultproperties
    {
        m_kLastActorSpawned=none
    }
};

var() EUnitType UnitType;
var XComBuildingVolume m_kVolume;
var bool m_bInside;
var bool m_bInit;
var Actor m_kLastActorSpawned;

simulated event EUnitType GetUnitType()
{
    return UnitType;
}

function bool IsInside()
{
    local XComBuildingVolume kVolume;

    if(m_bInit)
    {
        return m_bInside;
    }
    foreach WorldInfo.AllActors(class'XComBuildingVolume', kVolume)
    {
        if((kVolume != none) && kVolume.IsInside)
        {
            if(kVolume.Encompasses(self))
            {
                m_kVolume = kVolume;
                m_bInside = true;
                m_bInit = true;                
                return m_bInside;
            }
        }        
    }    
    m_bInit = true;
    return false;
}

simulated function bool SnapToGround(optional float Distance=128.0)
{
    local Vector HitLocation, HitNormal;

    Distance = 128.0;
    if(Trace(HitLocation, HitNormal, Location + (vect(0.0, 0.0, -1.0) * Distance), Location, false) != none)
    {
        SetLocation(HitLocation + vect(0.0, 0.0, 32.0));
        return true;
    }
    return false;
}

function Init()
{
    m_bInside = IsInside();
}

function Vector GetSpawnPointLocation()
{
    return Location;
}

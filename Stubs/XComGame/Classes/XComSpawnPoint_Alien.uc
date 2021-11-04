class XComSpawnPoint_Alien extends XComSpawnPoint;
//complete stub

enum EBehavior
{
    EAIBehavior_None,
    EAIBehavior_Hunt,
    EAIBehavior_SeekActor,
    EAIBehavior_MAX
};

var() EBehavior m_eBehavior;
var() Actor kSeekActor;
var() float fSeekRadius;
var() bool m_bForcePlacement;
var() bool bKismetSpawnOnly;
var bool m_bUseAltLocation;
var Vector m_vAltLocation;

function SetAlternateLocation(Vector vLoc)
{
    m_bUseAltLocation = true;
    m_vAltLocation = vLoc;
}

function ClearAlternateLocation()
{
    m_bUseAltLocation = false;
}

function Vector GetSpawnPointLocation()
{
    if(m_bUseAltLocation)
    {
        return m_vAltLocation;
    }
    return super.GetSpawnPointLocation();
}



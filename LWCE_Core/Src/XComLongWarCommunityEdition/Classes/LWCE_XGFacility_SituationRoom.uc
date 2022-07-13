class LWCE_XGFacility_SituationRoom extends XGFacility_SituationRoom;

function bool IsCodeActive()
{
    local LWCE_XGFacility_Labs kLabs;

    kLabs = LWCE_XGFacility_Labs(LABS());

    return kLabs.LWCE_IsResearched('Tech_AlienOperations') && !kLabs.LWCE_IsTechAvailable('Tech_AlienCommunications');
}
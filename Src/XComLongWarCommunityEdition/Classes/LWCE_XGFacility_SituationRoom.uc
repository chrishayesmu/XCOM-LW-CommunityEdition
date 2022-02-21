class LWCE_XGFacility_SituationRoom extends XGFacility_SituationRoom;

function bool IsCodeActive()
{
    return LABS().IsResearched(`LW_TECH_ID(AlienOperations)) && !`LWCE_LABS.LWCE_IsTechAvailable(`LW_TECH_ID(AlienCommunications));
}
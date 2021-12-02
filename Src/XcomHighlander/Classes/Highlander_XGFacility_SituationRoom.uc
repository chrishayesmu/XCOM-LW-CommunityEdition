class Highlander_XGFacility_SituationRoom extends XGFacility_SituationRoom;

function bool IsCodeActive()
{
    return LABS().IsResearched(`LW_TECH_ID(AlienOperations)) && !`HL_LABS.HL_IsTechAvailable(`LW_TECH_ID(AlienCommunications));
}
class Highlander_XGFacility_SituationRoom extends XGFacility_SituationRoom;

function bool IsCodeActive()
{
    return LABS().IsResearched(eTech_BaseShard) && !`HL_LABS.HL_IsTechAvailable(eTech_Hyperwave);
}
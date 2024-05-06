class XGAIBehavior_FlyingUnit extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);

const MAX_TILE_HEIGHT = 10;
const MIN_TILE_HEIGHT = 3;

var int m_iFlightDuration;

defaultproperties
{
    m_bShouldIgnoreCover=true
    m_bCanIgnoreCover=true
}
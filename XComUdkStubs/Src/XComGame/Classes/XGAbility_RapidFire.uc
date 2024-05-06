class XGAbility_RapidFire extends XGAbility_GameCore
    native(Core)
    notplaceable
    hidecategories(Navigation);

var bool bShotTwice;
var privatewrite int m_iNumShots;

defaultproperties
{
    m_iNumShots=1
}
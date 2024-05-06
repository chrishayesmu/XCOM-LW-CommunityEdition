class XComMecPawn extends XComHumanPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var() XComMECSoundCollection MECSounds;
var EItemType m_ePreviewWeapon;
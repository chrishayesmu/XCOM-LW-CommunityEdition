class LWCE_XGShipEntity extends XGShipEntity;

function EShipType GetShipModel()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetShipModel);

    return EShipType(0);
}

function EShipAnimation GetAnim()
{
    local LWCE_XGShip kShip;

    kShip = LWCE_XGShip(GetShip());

    if (kShip.m_kObjective != none && kShip.m_kObjective.LWCE_GetType() == 'Hunt')
    {
        return eShipAnim_Hunting;
    }

    return eShipAnim_Flying;
}
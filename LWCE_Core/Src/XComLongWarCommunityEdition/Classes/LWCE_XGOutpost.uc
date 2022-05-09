class LWCE_XGOutpost extends XGOutpost;

function Init(int iContinent)
{
    m_iContinent = iContinent;
    SetEntity(Spawn(class'LWCE_XGBaseEntity'), eEntityGraphic_Hangar);
}
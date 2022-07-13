class LWCE_XGInterceptionThrowdownUI extends XGInterceptionThrowdownUI;

function SetupInterception()
{
    local int I;
    local LWCE_XGFacility_Hangar kHangar;
    local XGShip_Interceptor kInterceptor;
    local XGShip_UFO kUFO;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());

    if (m_kInterception != none)
    {
        m_kInterception.Destroy();
    }

    m_kInterception = Spawn(class'LWCE_XGInterception');
    m_kInterception.m_arrInterceptors.Remove(0, m_kInterception.m_arrInterceptors.Length);

    kUFO = Spawn(class'XGShip_UFO');
    kUFO.Init(ITEMTREE().GetShip(EShipType(m_iUFO)));

    m_kInterception.m_eUFOResult = eUR_NONE;
    m_kInterception.Init(kUFO);
    m_kInterception.m_bSimulatedCombat = true;

    for (I = 0; I < m_aiInterceptors.Length; I++)
    {
        if (m_aiInterceptors[I] == 0)
        {
            continue;
        }

        kInterceptor = Spawn(class'LWCE_XGShip_Interceptor');
        kInterceptor.Init(ITEMTREE().GetShip(EShipType(m_aiInterceptors[I])));
        kInterceptor.m_eWeapon = EItemType(m_aiInterceptorWeapon[I]);
        kInterceptor.m_kTShip.arrWeapons.Remove(0, kInterceptor.m_kTShip.arrWeapons.Length);
        kInterceptor.m_kTShip.arrWeapons.AddItem(kHangar.LWCE_ItemTypeToShipWeapon(kInterceptor.m_eWeapon));
        m_kInterception.ToggleInterceptor(kInterceptor);
    }
}
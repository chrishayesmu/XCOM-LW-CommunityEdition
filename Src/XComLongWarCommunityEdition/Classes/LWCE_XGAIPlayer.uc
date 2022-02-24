class LWCE_XGAIPlayer extends XGAIPlayer;

`include(generators.uci)

`LWCE_GENERATOR_XGPLAYER

function bool UpdateHealers()
{
    local XGUnit kUnit;

    m_arrHealer.Length = 0;

    foreach m_arrCachedSquad(kUnit)
    {
        if (kUnit.GetRemainingActions() == 0)
        {
            continue;
        }

        if (LWCE_XGInventory(kUnit.GetInventory()).LWCE_HasItemOfType(`LW_ITEM_ID(Medikit)) && kUnit.GetMediKitCharges() > 0)
        {
            m_arrHealer.AddItem(kUnit);
        }
    }

    return m_arrHealer.Length > 0;
}

simulated function UpdateWeaponTactics(XGInventory kInventory)
{
    local LWCE_XGInventory kCEInventory;

    kCEInventory = LWCE_XGInventory(kInventory);

    if (kCEInventory.LWCE_HasItemOfType(`LW_ITEM_ID(RecoillessRifle)) || kCEInventory.LWCE_HasItemOfType(`LW_ITEM_ID(RocketLauncher)))
    {
        m_fMinTeammateDistance = 224.0;
    }
}
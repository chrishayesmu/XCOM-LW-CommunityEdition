class LWCE_XGScreenMgr_Extensions extends Object
    abstract;

static function bool UnlockItem(name ItemName)
{
    local LWCE_TItemUnlock kUnlock;

    if (!Game().LWCE_UnlockItem(ItemName, kUnlock))
    {
        return false;
    }
    else
    {
        PRES().LWCE_UIItemUnlock(kUnlock);
    }

    return true;
}

static function bool UnlockFacility(name FacilityName)
{
    local LWCE_TItemUnlock kUnlock;

    if (!Game().LWCE_UnlockFacility(FacilityName, kUnlock))
    {
        return false;
    }
    else
    {
        PRES().LWCE_UIItemUnlock(kUnlock);
    }

    return true;
}

static function bool UnlockFoundryProject(name ProjectName)
{
    local LWCE_TItemUnlock kUnlock;

    if (!Game().LWCE_UnlockFoundryProject(ProjectName, kUnlock))
    {
        return false;
    }
    else
    {
        PRES().LWCE_UIItemUnlock(kUnlock);
    }

    return true;
}

protected static function LWCE_XGStrategy Game()
{
    return LWCE_XGStrategy(`HQGAME.GetGameCore());
}

protected static function LWCE_XComHQPresentationLayer PRES()
{
    return LWCE_XComHQPresentationLayer(`HQPRES);
}
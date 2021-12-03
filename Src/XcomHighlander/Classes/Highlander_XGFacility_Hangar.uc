class Highlander_XGFacility_Hangar extends XGFacility_Hangar;

var int m_iHLBestWeaponEquipped;

function AddDropship()
{
    if (m_kSkyranger == none)
    {
        m_kSkyranger = Spawn(class'Highlander_XGShip_Dropship');
        m_kSkyranger.Init(ITEMTREE().GetShip(eShip_Skyranger));
        m_kSkyranger.m_strCallsign = m_strCallsignSkyranger;
    }
}

function AddFirestorm(int iContinent)
{
    local int iInterceptorIndex, I;
    local XGShip_Interceptor kFirestorm;

    iInterceptorIndex = INDEX_NONE;
    kFirestorm = none;

    // Find the interceptor pilot with the most kills
    for (I = 0; I < m_arrInts.Length; I++)
    {
        if (m_arrInts[I] != none && !m_arrInts[I].IsFirestorm())
        {
            if (iInterceptorIndex == INDEX_NONE || m_arrInts[I].m_iConfirmedKills > m_arrInts[iInterceptorIndex].m_iConfirmedKills)
            {
                iInterceptorIndex = I;
            }
        }
    }

    kFirestorm = Spawn(class'Highlander_XGShip_Interceptor');
    kFirestorm.m_iHomeContinent = HQ().GetContinent();
    kFirestorm.m_iHomeBay = GetAvailableBay();
    kFirestorm.Init(ITEMTREE().GetShip(eShip_Firestorm));
    m_iFirestormCounter += 1;

    if (iInterceptorIndex >= 0)
    {
        // Swap callsign and kill count with the chosen interceptor (aka swap pilots)
        kFirestorm.m_strCallsign = m_arrInts[iInterceptorIndex].m_strCallsign;
        kFirestorm.m_iConfirmedKills = m_arrInts[iInterceptorIndex].m_iConfirmedKills;
        m_iInterceptorCounter += 1;
        m_arrInts[iInterceptorIndex].m_strCallsign = m_strCallsignInterceptor $ "-" $ string(m_iInterceptorCounter);
        m_arrInts[iInterceptorIndex].m_iConfirmedKills = 0;
    }
    else
    {
        kFirestorm.m_strCallsign = m_strCallsignFireStorm $ "-" $ string(m_iFirestormCounter);
    }

    m_arrInts.AddItem(kFirestorm);
    ReorderCraft();
    kFirestorm.UpdateHangarShip();
    UpdateHangarBays();
    GEOSCAPE().World().m_kFundingCouncil.OnShipAdded(eShip_Firestorm, HQ().GetContinent());
}

function AddInterceptor(int iContinent)
{
    local XGShip_Interceptor kInterceptor;

    if (iContinent == -1)
    {
        iContinent = HQ().GetContinent();
    }

    kInterceptor = Spawn(class'Highlander_XGShip_Interceptor');
    kInterceptor.m_iHomeContinent = iContinent;

    if (iContinent == HQ().GetContinent())
    {
        kInterceptor.m_iHomeBay = GetAvailableBay();
    }

    kInterceptor.Init(ITEMTREE().GetShip(eShip_Interceptor));

    m_iInterceptorCounter += 1;
    kInterceptor.m_strCallsign = m_strCallsignInterceptor $ "-" $ string(m_iInterceptorCounter);

    m_arrInts.AddItem(kInterceptor);

    ReorderCraft();
    kInterceptor.UpdateHangarShip();
    UpdateHangarBays();

    GEOSCAPE().World().m_kFundingCouncil.OnShipAdded(eShip_Interceptor, iContinent);
}

function EquipWeapon(EItemType eItem, XGShip_Interceptor kShip)
{
    `HL_LOG_DEPRECATED_CLS(EquipWeapon);
}

function HL_EquipWeapon(int iItemId, XGShip_Interceptor kShip)
{
    STORAGE().RemoveItem(iItemId, 1);
    Sound().PlaySFX(SNDLIB().SFX_Facility_ConstructItem);
    Highlander_XGShip_Interceptor(kShip).HL_EquipWeapon(iItemId);
    kShip.m_iStatus = eShipStatus_Rearming;

    if (iItemId == `LW_ITEM_ID(StingrayMissiles) || iItemId == `LW_ITEM_ID(AvalancheMissiles))
    {
        kShip.m_iHoursDown = 12;
    }
    else
    {
        kShip.m_iHoursDown = class'XGTacticalGameCore'.default.INTERCEPTOR_REARM_HOURS;
    }

    if (iItemId > m_iHLBestWeaponEquipped)
    {
        m_iHLBestWeaponEquipped = iItemId;
    }
}

function TContinentInfo GetContinentInfo(EContinent eCont)
{
    local Highlander_XGFacility_Engineering kEngineering;
    local TContinentInfo kInfo;
    local HL_TItemProject kProject;
    local int iOrder;

    kEngineering = `HL_ENGINEERING;

    kInfo.eCont = eCont;
    kInfo.strContinentName.StrValue = Continent(eCont).GetName();
    kInfo.arrCraft = GetInterceptorsByContinent(eCont);
    kInfo.iNumShips = kInfo.arrCraft.Length;

    for (iOrder = 0; iOrder < HQ().m_akInterceptorOrders.Length; iOrder++)
    {
        if (HQ().m_akInterceptorOrders[iOrder].iDestinationContinent == eCont)
        {
            kInfo.m_arrInterceptorOrderIndexes.AddItem(iOrder);
            kInfo.iNumShips += HQ().m_akInterceptorOrders[iOrder].iNumInterceptors;
        }
    }

    // For the home continent, check for any Firestorms being built
    if (eCont == `HQGAME.GetGameCore().GetHQ().GetContinent())
    {
        foreach kEngineering.m_arrHLItemProjects(kProject)
        {
            if (kProject.iItemId == `LW_ITEM_ID(Firestorm))
            {
                kInfo.iNumShips += kProject.iQuantity;
            }
        }
    }

    return kInfo;
}

function array<TItem> GetUpgrades(XGShip_Interceptor kShip)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `HL_LOG_DEPRECATED_CLS(GetUpgrades);

    return arrItems;
}

function array<HL_TItem> HL_GetUpgrades(XGShip_Interceptor kShip)
{
    local Highlander_XGItemTree kItemTree;
    local XGStorage kStorage;
    local array<HL_TItem> arrItems;
    local HL_TItem kItem;

    kItemTree = `HL_ITEMTREE;
    kStorage = STORAGE();

    foreach kItemTree.m_arrHLItems(kItem)
    {
        if (kItemTree.IsShipWeapon(kItem.iItemId) && kStorage.GetNumItemsAvailable(kItem.iItemId) > 0)
        {
            arrItems.AddItem(kItem);
        }
    }

    return arrItems;
}

static function EShipWeapon ItemTypeToShipWeapon(EItemType eItem)
{
    `HL_LOG_DEPRECATED(ItemTypeToShipWeapon);
    return 0;
}

static function int HL_ItemTypeToShipWeapon(int iItemId)
{
    // TODO: add mod hook
    switch (iItemId)
    {
        case `LW_ITEM_ID(StingrayMissiles):
            return eShipWeapon_Stingray;
        case `LW_ITEM_ID(PhoenixCannon):
            return eShipWeapon_Cannon;
        case `LW_ITEM_ID(AvalancheMissiles):
            return eShipWeapon_Avalanche;
        case `LW_ITEM_ID(LaserCannon):
            return eShipWeapon_Laser;
        case `LW_ITEM_ID(PlasmaCannon):
            return eShipWeapon_Plasma;
        case `LW_ITEM_ID(EMPCannon):
            return eShipWeapon_EMP;
        case `LW_ITEM_ID(FusionLance):
            return eShipWeapon_Fusion;
    }

    return 0;
}

function LandDropship(XGShip_Dropship kSkyranger)
{
    local Highlander_XGFacility_Labs kLabs;
    local array<HL_TTechState> arrPreLandTechs, arrPostLandTechs;
    local TMissionReward kEmptyReward;

    kLabs = `HL_LABS;

    arrPreLandTechs = kLabs.HL_GetCurrentTechStates();
    UnloadArtifacts(kSkyranger);

    if (kSkyranger.CargoInfo.m_iBattleResult == eResult_Victory)
    {
        if (RewardIsValid(kSkyranger.CargoInfo.m_kReward))
        {
            GiveMissionReward(kSkyranger);
            HQ().m_kLastReward = kSkyranger.CargoInfo.m_kReward;
        }
    }

    arrPostLandTechs = kLabs.HL_GetCurrentTechStates();
    kLabs.HL_CompilePostMissionReport(arrPreLandTechs, arrPostLandTechs);

    BARRACKS().LandSoldiers(kSkyranger);
    kSkyranger.CargoInfo.m_kReward = kEmptyReward;
    GEOSCAPE().Resume();

    if (ISCONTROLLED() && Game().GetNumMissionsTaken() == 1)
    {
        kLabs.m_arrMissionResults.Remove(0, kLabs.m_arrMissionResults.Length);
    }
}

function UnloadArtifacts(XGShip_Dropship kSkyranger)
{
    local int Index, iItemId, iNumArtifacts;
    local Highlander_XGDropshipCargoInfo kCargo;
    local Highlander_XGHeadquarters kHQ;
    local Highlander_XGItemTree kItemTree;

    kCargo = Highlander_XGDropshipCargoInfo(kSkyranger.CargoInfo);
    kHQ = `HL_HQ;
    kItemTree = `HL_ITEMTREE;

    kHQ.m_kHLLastCargoArtifacts = Spawn(class'HighlanderItemContainer');
    kHQ.m_kHLLastCargoArtifacts.CopyFrom(kCargo.m_kArtifactsContainer);
    `HL_LOG_CLS("Unloading artifacts from dropship: there are " $ kCargo.m_kArtifactsContainer.m_arrEntries.Length $ " entries to process");

    for (Index = 0; Index < kCargo.m_kArtifactsContainer.m_arrEntries.Length; Index++)
    {
        iItemId = kCargo.m_kArtifactsContainer.m_arrEntries[Index].iItemId;
        iNumArtifacts = kCargo.m_kArtifactsContainer.m_arrEntries[Index].iQuantity;

        if (iNumArtifacts > 0)
        {
            if (!kItemTree.HL_ItemIsValid(iItemId))
            {
                kHQ.m_kHLLastCargoArtifacts.Delete(iItemId);
            }
            else if (kItemTree.HL_IsCaptive(iItemId))
            {
                if (!kHQ.HasFacility(eFacility_AlienContain))
                {
                    kHQ.m_kHLLastCargoArtifacts.Delete(iItemId);
                    iItemId = kItemTree.HL_CaptiveToCorpse(iItemId);
                    LABS().m_bCaptiveDied = true;

                    // Add captive's corpse to cargo
                    kHQ.m_kHLLastCargoArtifacts.AdjustQuantity(iItemId, iNumArtifacts);
                }
                else
                {
                    kHQ.m_arrHLLastCaptives.AddItem(iItemId);

                    if (!STORAGE().EverHadItem(iItemId))
                    {
                        STAT_AddStat(eRecap_DifferentAliensCaptured, 1);
                    }

                    if (iItemId >= 0 && iItemId <= 255)
                    {
                        // Captives from mods currently will not trigger the alien containment cutscenes
                        Base().BeginAlienContainment(EItemType(iItemId));
                    }
                }

                SITROOM().PushNarrativeHeadline(eTickerNarrative_AlienCaptured);
                STORAGE().AddItem(iItemId, iNumArtifacts);
            }
            else if (iItemId == `LW_ITEM_ID(Elerium))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienNucleonics)))
                {
                    iNumArtifacts *= 1.20;
                }

                AddResource(eResource_Elerium, iNumArtifacts);
            }
            else if (iItemId == `LW_ITEM_ID(AlienAlloy))
            {
                if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienMetallurgy)))
                {
                    iNumArtifacts *= 1.20;
                }

                AddResource(eResource_Alloys, iNumArtifacts);
            }
            else
            {
                if (iItemId == `LW_ITEM_ID(WeaponFragment))
                {
                    if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(ImprovedSalvage)))
                    {
                        iNumArtifacts *= 1.20;
                    }
                }

                STORAGE().AddItem(iItemId, iNumArtifacts);
            }
        }
    }

    kCargo.m_kArtifactsContainer.Clear();
}
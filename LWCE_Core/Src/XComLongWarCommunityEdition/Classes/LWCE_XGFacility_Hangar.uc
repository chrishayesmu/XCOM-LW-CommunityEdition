class LWCE_XGFacility_Hangar extends XGFacility_Hangar
    config(LWCEQualityOfLife);

var const localized array<string> PilotNames;
var const localized array<string> PilotRanks;

var config bool bAutoNicknameNewPilots;

var name m_nmCEBestWeaponEquipped; // TODO: not being populated

function AddDropship()
{
    if (m_kSkyranger == none)
    {
        m_kSkyranger = Spawn(class'LWCE_XGShip_Dropship');
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

    kFirestorm = Spawn(class'LWCE_XGShip_Interceptor');
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

        if (bAutoNicknameNewPilots)
        {
            AssignRandomCallsign(m_arrInts[iInterceptorIndex]);
        }
        else
        {
            m_arrInts[iInterceptorIndex].m_strCallsign = m_strCallsignInterceptor $ "-" $ string(m_iInterceptorCounter);
            m_arrInts[iInterceptorIndex].m_iConfirmedKills = 0;
        }
    }
    else
    {
        if (bAutoNicknameNewPilots)
        {
            AssignRandomCallsign(kFirestorm);
        }
        else
        {
            kFirestorm.m_strCallsign = m_strCallsignFireStorm $ "-" $ string(m_iFirestormCounter);
        }
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

    kInterceptor = Spawn(class'LWCE_XGShip_Interceptor');
    kInterceptor.m_iHomeContinent = iContinent;

    if (iContinent == HQ().GetContinent())
    {
        kInterceptor.m_iHomeBay = GetAvailableBay();
    }

    kInterceptor.Init(ITEMTREE().GetShip(eShip_Interceptor));

    m_iInterceptorCounter += 1;
    kInterceptor.m_strCallsign = m_strCallsignInterceptor $ "-" $ string(m_iInterceptorCounter);

    m_arrInts.AddItem(kInterceptor);

    if (bAutoNicknameNewPilots)
    {
        AssignRandomCallsign(kInterceptor);
    }

    ReorderCraft();
    kInterceptor.UpdateHangarShip();
    UpdateHangarBays();

    GEOSCAPE().World().m_kFundingCouncil.OnShipAdded(eShip_Interceptor, iContinent);
}

function AssignRandomCallsign(XGShip_Interceptor kShip)
{
    LWCE_XGShip_Interceptor(kShip).SetCallsign(PilotNames[Rand(PilotNames.Length)]);
}

function bool CanEquip(int iItem, XGShip_Interceptor kShip, out string strHelp)
{
    `LWCE_LOG_DEPRECATED_CLS(CanEquip);

    return false;
}

function bool LWCE_CanEquip(name ItemName, LWCE_XGShip_Interceptor kShip, out string strHelp)
{
    local LWCEShipWeaponTemplate kShipWeapon;

    if (kShip.GetWeaponAtIndex(0) == ItemName)
    {
        strHelp = m_strCanEquipMessage;
        return false;
    }

    kShipWeapon = LWCEShipWeaponTemplate(`LWCE_ITEM(ItemName));

    if (!kShipWeapon.bCanEquipOnFirestorm && kShip.IsFirestorm())
    {
        strHelp = m_sUnavailable;
        return false;
    }

    if (!kShipWeapon.bCanEquipOnInterceptor && kShip.IsInterceptor())
    {
        strHelp = m_sUnavailable;
        return false;
    }

    return true;
}

function DetermineInterceptorStatus(XGShip_Interceptor kInterceptor)
{
    kInterceptor.m_iStatus = eShipStatus_Ready;

    if (kInterceptor.GetFuelPct() < 1.0f)
    {
        kInterceptor.m_iStatus = eShipStatus_Refuelling;
        kInterceptor.m_iHoursDown = 1;
    }

    if (kInterceptor.IsDamaged())
    {
        kInterceptor.m_iStatus = eShipStatus_Repairing;
        kInterceptor.m_iHoursDown = Max(1, int(float(class'XGTacticalGameCore'.default.INTERCEPTOR_REPAIR_HOURS) * (1.0f - kInterceptor.GetHPPct())));

        if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
        {
            kInterceptor.m_iHoursDown /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }

        if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_AdvancedRepair'))
        {
            kInterceptor.m_iHoursDown *= 0.670;
        }
    }
}

function EquipWeapon(EItemType eItem, XGShip_Interceptor kShip)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipWeapon);
}

function LWCE_EquipWeapon(name ItemName, XGShip_Interceptor kShip)
{
    local LWCEShipWeaponTemplate kTemplate;

    kTemplate = `LWCE_SHIP_WEAPON(ItemName);

    LWCE_XGStorage(STORAGE()).LWCE_RemoveItem(ItemName, 1);
    Sound().PlaySFX(SNDLIB().SFX_Facility_ConstructItem);
    LWCE_XGShip_Interceptor(kShip).LWCE_EquipWeapon(ItemName, 0);

    if (kShip.IsFirestorm())
    {
        kShip.m_iHoursDown = kTemplate.iFirestormArmingTimeHours;
    }
    else
    {
        kShip.m_iHoursDown = kTemplate.iInterceptorArmingTimeHours;
    }

    if (kShip.m_iHoursDown > 0)
    {
        kShip.m_iStatus = eShipStatus_Rearming;
    }

/* TODO implement an analogue for this? it's only used to play one narrative
    if (ItemName > m_iCEBestWeaponEquipped)
    {
        m_iCEBestWeaponEquipped = ItemName;
    }
*/
}

function TContinentInfo GetContinentInfo(EContinent eCont)
{
    local LWCE_XGFacility_Engineering kEngineering;
    local TContinentInfo kInfo;
    local LWCE_TItemProject kProject;
    local int iOrder;

    kEngineering = `LWCE_ENGINEERING;

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
        foreach kEngineering.m_arrCEItemProjects(kProject)
        {
            if (kProject.ItemName == 'Item_Firestorm')
            {
                kInfo.iNumShips += kProject.iQuantity;
            }
        }
    }

    return kInfo;
}

function string GetRankForKills(int iKills)
{
    local int Index;

    Index = Clamp(iKills, 0, PilotRanks.Length - 1);

    while (Index >= 0)
    {
        if (PilotRanks[Index] != "")
        {
            return PilotRanks[Index];
        }

        Index--;
    }

    return "";
}

function array<TItem> GetUpgrades(XGShip_Interceptor kShip)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetUpgrades);

    return arrItems;
}

function array<LWCEShipWeaponTemplate> LWCE_GetUpgrades(XGShip_Interceptor kShip)
{
    local LWCE_XGStorage kStorage;
    local array<LWCEShipWeaponTemplate> arrItems, arrTemplates;
    local LWCEItemTemplateManager kItemMgr;
    local LWCEShipWeaponTemplate kShipWeapon;

    kItemMgr = `LWCE_ITEM_TEMPLATE_MGR;
    kStorage = LWCE_XGStorage(STORAGE());

    arrTemplates = kItemMgr.GetAllShipWeaponTemplates();

    foreach arrTemplates(kShipWeapon)
    {
        if (kStorage.LWCE_GetNumItemsAvailable(kShipWeapon.GetItemName()) > 0)
        {
            arrItems.AddItem(kShipWeapon);
        }
    }

    return arrItems;
}

function GiveMissionReward(XGShip_Dropship kSkyranger)
{
    if (kSkyranger.CargoInfo.m_kReward.iScientists > 0)
    {
        AddResource(eResource_Scientists, kSkyranger.CargoInfo.m_kReward.iScientists);
    }

    if (kSkyranger.CargoInfo.m_kReward.iEngineers > 0)
    {
        AddResource(eResource_Engineers, kSkyranger.CargoInfo.m_kReward.iEngineers);
    }

    if (kSkyranger.CargoInfo.m_kReward.iCredits > 0)
    {
        AddResource(eResource_Money, kSkyranger.CargoInfo.m_kReward.iCredits);
    }

    if (kSkyranger.CargoInfo.m_kReward.iSoldierClass != 0)
    {
        LWCE_XGFacility_Barracks(BARRACKS()).LWCE_CreateSoldier(kSkyranger.CargoInfo.m_kReward.iSoldierClass, kSkyranger.CargoInfo.m_kReward.iSoldierLevel, kSkyranger.CargoInfo.m_kReward.iCountry);
        STAT_AddStat(eRecap_SoldiersCollected, 1);
    }
}

static function EShipWeapon ItemTypeToShipWeapon(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(ItemTypeToShipWeapon);
    return 0;
}

function LandDropship(XGShip_Dropship kSkyranger)
{
    local LWCE_XGFacility_Labs kLabs;
    local array<LWCE_TTechState> arrPreLandTechs, arrPostLandTechs;
    local TMissionReward kEmptyReward;

    kLabs = `LWCE_LABS;

    arrPreLandTechs = kLabs.LWCE_GetCurrentTechStates();
    UnloadArtifacts(kSkyranger);

    if (kSkyranger.CargoInfo.m_iBattleResult == eResult_Victory)
    {
        if (RewardIsValid(kSkyranger.CargoInfo.m_kReward))
        {
            GiveMissionReward(kSkyranger);
            HQ().m_kLastReward = kSkyranger.CargoInfo.m_kReward;
        }
    }

    arrPostLandTechs = kLabs.LWCE_GetCurrentTechStates();
    kLabs.LWCE_CompilePostMissionReport(arrPreLandTechs, arrPostLandTechs);

    BARRACKS().LandSoldiers(kSkyranger);
    kSkyranger.CargoInfo.m_kReward = kEmptyReward; // TODO: need to convert to LWCE_TMissionReward
    GEOSCAPE().Resume();
}

function bool OrderedHigher(XGShip_Interceptor kCraft1, XGShip_Interceptor kCraft2)
{
    // Same as the base OrderedHigher but without GetWeapon calls since our items are unordered

    if (kCraft1.m_iHomeContinent == HQ().m_iContinent && kCraft2.m_iHomeContinent != HQ().m_iContinent)
    {
        return true;
    }
    else if (kCraft2.m_iHomeContinent == HQ().m_iContinent && kCraft1.m_iHomeContinent != HQ().m_iContinent)
    {
        return false;
    }
    else if (kCraft1.m_iHomeContinent < kCraft2.m_iHomeContinent)
    {
        return true;
    }
    else if (kCraft2.m_iHomeContinent < kCraft1.m_iHomeContinent)
    {
        return false;
    }

    if (!kCraft1.IsDamaged() && kCraft2.IsDamaged())
    {
        return true;
    }
    else if (!kCraft2.IsDamaged() && kCraft1.IsDamaged())
    {
        return false;
    }

    if (kCraft1.m_iStatus != 2 && kCraft2.m_iStatus == 2)
    {
        return true;
    }
    else if (kCraft2.m_iStatus != 2 && kCraft1.m_iStatus == 2)
    {
        return false;
    }

    if (kCraft1.IsFirestorm() && !kCraft2.IsFirestorm())
    {
        return true;
    }
    else if (!kCraft1.IsFirestorm() && kCraft2.IsFirestorm())
    {
        return false;
    }

    return false;
}

function EItemType ShipTypeToItemType(EShipType eShip)
{
    `LWCE_LOG_DEPRECATED_CLS(ShipTypeToItemType);

    return eItem_None;
}

function name LWCE_ShipTypeToItemType(EShipType eShip)
{
    switch (eShip)
    {
        case eShip_Interceptor:
            return 'Item_Interceptor';
        case eShip_Skyranger:
            return 'Item_Skyranger';
        case eShip_Firestorm:
            return 'Item_Firestorm';
        default:
            return '';
    }
}

function UnloadArtifacts(XGShip_Dropship kSkyranger)
{
    local int Index, iNumArtifacts;
    local name ItemName;
    local LWCEItemTemplate kItem;
    local LWCE_XGDropshipCargoInfo kCargo;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGStorage kStorage;

    kCargo = LWCE_XGDropshipCargoInfo(kSkyranger.CargoInfo);
    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kHQ = `LWCE_HQ;
    kStorage = LWCE_XGStorage(STORAGE());

    kHQ.m_kCELastCargoArtifacts = Spawn(class'LWCEItemContainer');
    kHQ.m_kCELastCargoArtifacts.CopyFrom(kCargo.m_kArtifactsContainer);

    `LWCE_LOG_CLS("Unloading artifacts from dropship: there are " $ kCargo.m_kArtifactsContainer.m_arrEntries.Length $ " entries to process");

    for (Index = 0; Index < kCargo.m_kArtifactsContainer.m_arrEntries.Length; Index++)
    {
        ItemName = kCargo.m_kArtifactsContainer.m_arrEntries[Index].ItemName;
        iNumArtifacts = kCargo.m_kArtifactsContainer.m_arrEntries[Index].iQuantity;
        kItem = `LWCE_ITEM(ItemName);

        if (iNumArtifacts > 0)
        {
            if (kItem.IsCaptive())
            {
                if (!kHQ.HasFacility(eFacility_AlienContain))
                {
                    // Delete the captive from the cargo report
                    kHQ.m_kCELastCargoArtifacts.Delete(ItemName);
                    ItemName = kItem.nmCaptiveToCorpseId;
                    LABS().m_bCaptiveDied = true;

                    // Add captive's corpse to cargo
                    kHQ.m_kCELastCargoArtifacts.AdjustQuantity(ItemName, iNumArtifacts);
                }
                else
                {
                    kHQ.m_arrCELastCaptives.AddItem(ItemName);

                    if (!kStorage.LWCE_EverHadItem(ItemName))
                    {
                        STAT_AddStat(eRecap_DifferentAliensCaptured, 1);
                    }

                    // TODO: figure out if and why we need to start containment from the hangar rather than labs
                    // if (ItemName >= 0 && ItemName <= 255)
                    // {
                    //     Base().BeginAlienContainment(EItemType(ItemName));
                    // }
                }

                SITROOM().PushNarrativeHeadline(eTickerNarrative_AlienCaptured);
                kStorage.LWCE_AddItem(ItemName, iNumArtifacts);
            }
            else if (ItemName == 'Item_Elerium')
            {
                if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienNucleonics'))
                {
                    iNumArtifacts *= 1.20;
                }

                AddResource(eResource_Elerium, iNumArtifacts);
            }
            else if (ItemName == 'Item_AlienAlloy')
            {
                if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienMetallurgy'))
                {
                    iNumArtifacts *= 1.20;
                }

                AddResource(eResource_Alloys, iNumArtifacts);
            }
            else
            {
                if (ItemName == 'Item_WeaponFragment')
                {
                    if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedSalvage'))
                    {
                        iNumArtifacts *= 1.20;
                    }
                }

                kStorage.LWCE_AddItem(ItemName, iNumArtifacts);
            }
        }
    }

    kCargo.m_kArtifactsContainer.Clear();
}

function UpdateWeaponView(EShipWeapon eWeapon)
{
    `LWCE_LOG_DEPRECATED_CLS(UpdateWeaponView);
}

function LWCE_UpdateWeaponView(name ShipWeaponName)
{
    // TODO: move somewhere centralized and potentially make extensible
    if (LWCE_XGHangarShip_Firestorm(m_kViewWeaponsShip) != none)
    {
        LWCE_XGHangarShip_Firestorm(m_kViewWeaponsShip).LWCE_UpdateWeapon(ShipWeaponName);
    }
    else
    {
        LWCE_XGHangarShip(m_kViewWeaponsShip).LWCE_UpdateWeapon(ShipWeaponName);
    }
}
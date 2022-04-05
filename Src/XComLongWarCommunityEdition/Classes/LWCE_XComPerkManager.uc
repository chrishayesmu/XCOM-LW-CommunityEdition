class LWCE_XComPerkManager extends XComPerkManager
    config(LWCEClasses)
    dependson(LWCETypes);

var config array<LWCE_TPerkTree> arrPsionicClasses;
var config array<LWCE_TPerkTree> arrSoldierClasses; // includes MECs

var array<LWCE_TPerk> m_arrCEPerks;

simulated function BuildPerkTables()
{
    m_arrPerks.Length = 172;

    //             ID       Category      ImagePath                  bShowPerk   bIsGeneMod   bIsPsionic
    LWCE_BuildPerk(0,   ePerkCat_Passive, "Unknown",                   true,       false,       false);
    LWCE_BuildPerk(1,   ePerkCat_Passive, "StarHire",                  true,       false,       false);
    LWCE_BuildPerk(2,   ePerkCat_Active,  "PrecisionShot",             true,       false,       false);
    LWCE_BuildPerk(3,   ePerkCat_Passive, "SquadSight",                true,       false,       false);
    LWCE_BuildPerk(4,   ePerkCat_Passive, "SecondaryHeart",            true,       true,        false);
    LWCE_BuildPerk(5,   ePerkCat_Passive, "LowProfile",                true,       false,       false);
    LWCE_BuildPerk(6,   ePerkCat_Active,  "RunAndGun",                 true,       false,       false);
    LWCE_BuildPerk(7,   ePerkCat_Passive, "AutopsyRequired",           true,       false,       false);
    LWCE_BuildPerk(8,   ePerkCat_Active,  "CloseCyberdisc",            true,       false,       false);
    LWCE_BuildPerk(9,   ePerkCat_Active,  "DisablingShot",             true,       false,       false);
    LWCE_BuildPerk(10,  ePerkCat_Passive, "Opportunist",               true,       false,       false);
    LWCE_BuildPerk(11,  ePerkCat_Passive, "Executioner",               true,       false,       false);
    LWCE_BuildPerk(12,  ePerkCat_Passive, "LeadByExample",             false,      false,       false);
    LWCE_BuildPerk(13,  ePerkCat_Passive, "DoubleTap",                 true,       false,       false);
    LWCE_BuildPerk(14,  ePerkCat_Passive, "InTheZone",                 true,       false,       false);
    LWCE_BuildPerk(15,  ePerkCat_Passive, "DamnGoodGround",            true,       false,       false);
    LWCE_BuildPerk(16,  ePerkCat_Passive, "SnapShot",                  true,       false,       false);
    LWCE_BuildPerk(17,  ePerkCat_Passive, "WillToSurvive",             true,       false,       false);
    LWCE_BuildPerk(18,  ePerkCat_Active,  "FireRocket",                true,       false,       false);
    LWCE_BuildPerk(19,  ePerkCat_Passive, "TracerBeams",               true,       false,       false);
    LWCE_BuildPerk(20,  ePerkCat_Passive, "Adrenal",                   true,       true,        false);
    LWCE_BuildPerk(21,  ePerkCat_Active,  "Suppression",               true,       false,       false);
    LWCE_BuildPerk(22,  ePerkCat_Passive, "ShredderRocket",            true,       false,       false);
    LWCE_BuildPerk(23,  ePerkCat_Passive, "RapidReaction",             true,       false,       false);
    LWCE_BuildPerk(24,  ePerkCat_Passive, "Grenadier",                 true,       false,       false);
    LWCE_BuildPerk(25,  ePerkCat_Passive, "DangerZone",                true,       false,       false);
    LWCE_BuildPerk(26,  ePerkCat_Passive, "FireControl",               true,       false,       false);
    LWCE_BuildPerk(27,  ePerkCat_Passive, "ExtraConditioning",         true,       false,       false);
    LWCE_BuildPerk(28,  ePerkCat_Passive, "NeuralDamping",             true,       true,        false);
    LWCE_BuildPerk(29,  ePerkCat_Passive, "NeuralFeedback",            true,       false,       true);
    LWCE_BuildPerk(30,  ePerkCat_Passive, "ReactivePupils",            true,       true,        false);
    LWCE_BuildPerk(31,  ePerkCat_Passive, "Sprinter",                  true,       false,       false);
    LWCE_BuildPerk(32,  ePerkCat_Passive, "Aggression",                true,       false,       false);
    LWCE_BuildPerk(33,  ePerkCat_Passive, "TacticalSense",             true,       false,       false);
    LWCE_BuildPerk(34,  ePerkCat_Passive, "CloseAndPersonal",          true,       false,       false);
    LWCE_BuildPerk(35,  ePerkCat_Passive, "LightningReflexes",         true,       false,       false);
    LWCE_BuildPerk(36,  ePerkCat_Active,  "RapidFire",                 true,       false,       false);
    LWCE_BuildPerk(37,  ePerkCat_Active,  "Flush",                     true,       false,       false);
    LWCE_BuildPerk(38,  ePerkCat_Passive, "DepthPerception",           true,       true,        false);
    LWCE_BuildPerk(39,  ePerkCat_Passive, "BringEmOn",                 true,       false,       false);
    LWCE_BuildPerk(40,  ePerkCat_Passive, "CloseCombatSpecialist",     true,       false,       false);
    LWCE_BuildPerk(41,  ePerkCat_Passive, "KillerInstinct",            true,       false,       false);
    LWCE_BuildPerk(42,  ePerkCat_Passive, "BioelectricSkin",           true,       true,        false);
    LWCE_BuildPerk(43,  ePerkCat_Passive, "Resilience",                true,       false,       false);
    LWCE_BuildPerk(44,  ePerkCat_Active,  "SmokeBomb",                 true,       false,       false);
    LWCE_BuildPerk(45,  ePerkCat_Passive, "BattleFatigue",             true,       true,        false);
    LWCE_BuildPerk(46,  ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(47,  ePerkCat_Passive, "CoveringFire",              true,       false,       false);
    LWCE_BuildPerk(48,  ePerkCat_Passive, "FieldMedic",                true,       false,       false);
    LWCE_BuildPerk(49,  ePerkCat_Passive, "PsiLance",                  true,       false,       true);
    LWCE_BuildPerk(50,  ePerkCat_Passive, "MuscleDensity",             true,       true,        false);
    LWCE_BuildPerk(51,  ePerkCat_Passive, "CombatDrugs",               true,       false,       false);
    LWCE_BuildPerk(52,  ePerkCat_Passive, "DenseSmoke",                true,       false,       false);
    LWCE_BuildPerk(53,  ePerkCat_Passive, "ExpandedStorage",           true,       false,       false);
    LWCE_BuildPerk(54,  ePerkCat_Passive, "Sentinel",                  true,       false,       false);
    LWCE_BuildPerk(55,  ePerkCat_Passive, "Savior",                    true,       false,       false);
    LWCE_BuildPerk(56,  ePerkCat_Active,  "Revive",                    true,       false,       false);
    LWCE_BuildPerk(57,  ePerkCat_Passive, "HeightAdvantage",           true,       false,       false);
    LWCE_BuildPerk(58,  ePerkCat_Passive, "DeepPockets",               true,       false,       false);
    LWCE_BuildPerk(59,  ePerkCat_Passive, "AceInTheHole",              true,       false,       false);
    LWCE_BuildPerk(60,  ePerkCat_Passive, "SuppressedActive",          true,       false,       false);
    LWCE_BuildPerk(61,  ePerkCat_Passive, "CriticallyWounded",         true,       false,       false);
    LWCE_BuildPerk(62,  ePerkCat_Passive, "Flying",                    true,       false,       false);
    LWCE_BuildPerk(63,  ePerkCat_Passive, "Stealth",                   true,       false,       false);
    LWCE_BuildPerk(64,  ePerkCat_Passive, "HEATAmmo",                  true,       false,       false);
    LWCE_BuildPerk(65,  ePerkCat_Passive, "CombatStimsActive",         true,       false,       false);
    LWCE_BuildPerk(66,  ePerkCat_Passive, "DeathBlossom",              true,       false,       false);
    LWCE_BuildPerk(67,  ePerkCat_Passive, "Panicked",                  true,       false,       false);
    LWCE_BuildPerk(68,  ePerkCat_Active,  "PsiMindfray",               true,       false,       true);
    LWCE_BuildPerk(69,  ePerkCat_Active,  "PsiPanic",                  true,       false,       true);
    LWCE_BuildPerk(70,  ePerkCat_Active,  "PsiInspiration",            true,       false,       true);
    LWCE_BuildPerk(71,  ePerkCat_Active,  "PsiMindControl",            true,       false,       true);
    LWCE_BuildPerk(72,  ePerkCat_Active,  "PsiTelekineticField",       true,       false,       true);
    LWCE_BuildPerk(73,  ePerkCat_Active,  "PsiRift",                   true,       false,       true);
    LWCE_BuildPerk(74,  ePerkCat_Active,  "MindMerge",                 true,       false,       true);
    LWCE_BuildPerk(75,  ePerkCat_Active,  "MindMerge",                 true,       false,       true);
    LWCE_BuildPerk(76,  ePerkCat_Passive, "Harden",                    true,       false,       false);
    LWCE_BuildPerk(77,  ePerkCat_Active,  "MindMerge2",                true,       false,       true);
    LWCE_BuildPerk(78,  ePerkCat_Active,  "MindMerge2",                true,       false,       true);
    LWCE_BuildPerk(79,  ePerkCat_Active,  "Evasion",                   true,       false,       false);
    LWCE_BuildPerk(80,  ePerkCat_Active,  "Launch",                    true,       false,       false);
    LWCE_BuildPerk(81,  ePerkCat_Passive, "Bombard",                   true,       false,       false);
    LWCE_BuildPerk(82,  ePerkCat_Active,  "Leap",                      true,       false,       false);
    LWCE_BuildPerk(83,  ePerkCat_Active,  "PoisonSpit",                true,       false,       false);
    LWCE_BuildPerk(84,  ePerkCat_Active,  "PoisonSpit",                true,       false,       false);
    LWCE_BuildPerk(85,  ePerkCat_Active,  "Bloodcall",                 true,       false,       false);
    LWCE_BuildPerk(86,  ePerkCat_Active,  "Intimidate",                true,       false,       false);
    LWCE_BuildPerk(87,  ePerkCat_Passive, "FallenComrades",            true,       false,       false);
    LWCE_BuildPerk(88,  ePerkCat_Active,  "Bloodlust",                 true,       false,       false);
    LWCE_BuildPerk(89,  ePerkCat_Active,  "Bullrush",                  true,       false,       false);
    LWCE_BuildPerk(90,  ePerkCat_Passive, "HEATAmmo",                  true,       false,       false);
    LWCE_BuildPerk(91,  ePerkCat_Passive, "SmokeAndMirrors",           true,       false,       false);
    LWCE_BuildPerk(92,  ePerkCat_Passive, "Rocketeer",                 true,       false,       false);
    LWCE_BuildPerk(93,  ePerkCat_Passive, "Mayhem",                    true,       false,       false);
    LWCE_BuildPerk(94,  ePerkCat_Passive, "Gunslinger",                true,       false,       false);
    LWCE_BuildPerk(95,  ePerkCat_Passive, "MimeticSkin",               true,       false,       false);
    LWCE_BuildPerk(96,  ePerkCat_Active,  "ClusterBomb",               true,       false,       false);
    LWCE_BuildPerk(97,  ePerkCat_Active,  "PsiLance",                  true,       false,       true);
    LWCE_BuildPerk(98,  ePerkCat_Active,  "DeathBlossom",              true,       false,       false);
    LWCE_BuildPerk(99,  ePerkCat_Active,  "Overload",                  true,       false,       false);
    LWCE_BuildPerk(100, ePerkCat_Active,  "PsiMindControl",            true,       false,       true);
    LWCE_BuildPerk(101, ePerkCat_Active,  "PsiDrain",                  true,       false,       true);
    LWCE_BuildPerk(102, ePerkCat_Passive, "Repair",                    true,       false,       false);
    LWCE_BuildPerk(103, ePerkCat_Active,  "CannonFire",                true,       false,       false);
    LWCE_BuildPerk(104, ePerkCat_Passive, "Implant",                   true,       false,       false);
    LWCE_BuildPerk(105, ePerkCat_Passive, "Implant",                   true,       false,       false);
    LWCE_BuildPerk(106, ePerkCat_Passive, "BattleFatigue",             true,       false,       false);
    LWCE_BuildPerk(107, ePerkCat_Passive, "DONT_USE_ItemRangeBonus",   true,       false,       false);
    LWCE_BuildPerk(108, ePerkCat_Passive, "DONT_USE_ItemRangePenalty", true,       false,       false);
    LWCE_BuildPerk(109, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(110, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(111, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(112, ePerkCat_Passive, "Overload",                  true,       false,       false);
    LWCE_BuildPerk(113, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(114, ePerkCat_Passive, "ClusterBomb",               true,       false,       false);
    LWCE_BuildPerk(115, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(116, ePerkCat_Passive, "SentinelModule",            true,       false,       false);
    LWCE_BuildPerk(117, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(118, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(119, ePerkCat_Passive, "PsiDrain",                  true,       false,       true);
    LWCE_BuildPerk(120, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(121, ePerkCat_Passive, "MecCloseCombat",            true,       false,       false);
    LWCE_BuildPerk(122, ePerkCat_Passive, "AdrenalineSurge",           true,       false,       false);
    LWCE_BuildPerk(123, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(124, ePerkCat_Passive, "SentinelModule",            true,       false,       false);
    LWCE_BuildPerk(125, ePerkCat_Passive, "AlienGrenade",              false,      false,       false);
    LWCE_BuildPerk(126, ePerkCat_Passive, "BulletSwarm",               true,       false,       false);
    LWCE_BuildPerk(127, ePerkCat_Passive, "Stealth",                   true,       false,       false);
    LWCE_BuildPerk(128, ePerkCat_Passive, "Stealth",                   true,       false,       false);
    LWCE_BuildPerk(129, ePerkCat_Passive, "ReaperRounds",              true,       false,       false);
    LWCE_BuildPerk(130, ePerkCat_Passive, "Disoriented",               true,       false,       false);
    LWCE_BuildPerk(131, ePerkCat_Active,  "Barrage",                   true,       false,       false);
    LWCE_BuildPerk(132, ePerkCat_Passive, "ThreatAssesment",           true,       false,       false);
    LWCE_BuildPerk(133, ePerkCat_Passive, "FireControl",               true,       false,       false);
    LWCE_BuildPerk(134, ePerkCat_Passive, "DamageControl",             true,       false,       false);
    LWCE_BuildPerk(135, ePerkCat_Passive, "Xenobiology",               true,       false,       false);
    LWCE_BuildPerk(136, ePerkCat_Active,  "OneForAll",                 true,       false,       false);
    LWCE_BuildPerk(137, ePerkCat_Passive, "JetbootModule",             true,       false,       false);
    LWCE_BuildPerk(138, ePerkCat_Passive, "PlasmaBarrage",             true,       false,       false);
    LWCE_BuildPerk(139, ePerkCat_Passive, "RepairServos",              true,       false,       false);
    LWCE_BuildPerk(140, ePerkCat_Passive, "Overdrive",                 true,       false,       false);
    LWCE_BuildPerk(141, ePerkCat_Passive, "PlatformStability",         true,       false,       false);
    LWCE_BuildPerk(142, ePerkCat_Passive, "AbsorptionFields",          true,       false,       false);
    LWCE_BuildPerk(143, ePerkCat_Passive, "ShockArmor",                true,       false,       false);
    LWCE_BuildPerk(144, ePerkCat_Passive, "TargetingSensors",          true,       false,       false);
    LWCE_BuildPerk(145, ePerkCat_Passive, "BodyShield",                true,       false,       false);
    LWCE_BuildPerk(146, ePerkCat_Passive, "DistortionField",           true,       false,       true);
    LWCE_BuildPerk(147, ePerkCat_Passive, "AdrenalineSurge",           true,       false,       false);
    LWCE_BuildPerk(148, ePerkCat_Passive, "IronSkin",                  true,       true,        false);
    LWCE_BuildPerk(149, ePerkCat_Passive, "RegenPheromones",           true,       false,       true);
    LWCE_BuildPerk(150, ePerkCat_Passive, "BoneMarrow",                true,       false,       false);
    LWCE_BuildPerk(151, ePerkCat_Passive, "CommHack",                  true,       false,       false);
    LWCE_BuildPerk(152, ePerkCat_Passive, "UrbanDefense",              true,       false,       false);
    LWCE_BuildPerk(153, ePerkCat_Passive, "UrbanAim",                  true,       false,       false);
    LWCE_BuildPerk(154, ePerkCat_Passive, "DefendPanic",               true,       false,       false);
    LWCE_BuildPerk(155, ePerkCat_Passive, "RestorativeMist",           true,       true,        false);
    LWCE_BuildPerk(156, ePerkCat_Passive, "NationWill",                true,       false,       false);
    LWCE_BuildPerk(157, ePerkCat_Passive, "NationAim",                 true,       false,       false);
    LWCE_BuildPerk(158, ePerkCat_Passive, "HonorTerror",               true,       false,       false);
    LWCE_BuildPerk(159, ePerkCat_Passive, "HonorExalt",                true,       false,       false);
    LWCE_BuildPerk(160, ePerkCat_Passive, "StarWill",                  true,       false,       false);
    LWCE_BuildPerk(161, ePerkCat_Passive, "Dazed",                     true,       false,       false);
    LWCE_BuildPerk(162, ePerkCat_Passive, "DefendHealth",              true,       false,       false);
    LWCE_BuildPerk(163, ePerkCat_Passive, "DONT_USE_ItemRangeBonus",   true,       false,       false);
    LWCE_BuildPerk(164, ePerkCat_Passive, "Strangle",                  true,       false,       false);
    LWCE_BuildPerk(165, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(166, ePerkCat_Passive, "Strangle",                  true,       false,       false);
    LWCE_BuildPerk(167, ePerkCat_Passive, "Leap",                      true,       false,       false);
    LWCE_BuildPerk(168, ePerkCat_Active,  "MindMerge",                 true,       false,       true);
    LWCE_BuildPerk(169, ePerkCat_Passive, "ElectroPulse",              true,       false,       false);
    LWCE_BuildPerk(170, ePerkCat_Passive, "LeadByExample",             true,       false,       false);
    LWCE_BuildPerk(171, ePerkCat_Passive, "LeadByExample",             true,       false,       false);

    `LWCE_MOD_LOADER.OnPerksBuilt(m_arrCEPerks);
}

simulated function LWCE_BuildPerk(int iPerkId, int iCategory, string strImage, bool bShowPerk, bool bIsGeneMod, bool bIsPsionic)
{
    local LWCE_TPerk kPerk;

    // We still need to call the superclass's BuildPerk to populate the base game perk array,
    // which is used in native code we can't easily modify
    BuildPerk(iPerkId, iCategory, strImage, bShowPerk);

    kPerk.iCategory = iCategory;
    kPerk.iPerkId = iPerkId;
    kPerk.Icon = strImage;
    kPerk.bIsGeneMod = bIsGeneMod;
    kPerk.bIsPsionic = bIsPsionic;
    kPerk.bShowPerk = bShowPerk;

    // For base game perks, pull their strings from localization
    if (iPerkId < ePerk_MAX)
    {
        kPerk.strBonusDescription = m_strBonusTxt[iPerkId];
        kPerk.strBonusTitle = m_strBonusTitle[iPerkId];
        kPerk.strPassiveDescription = m_strPassiveTxt[iPerkId];
        kPerk.strPassiveTitle = m_strPassiveTitle[iPerkId];
        kPerk.strPenaltyDescription = m_strPenaltyTxt[iPerkId];
        kPerk.strPenaltyTitle = m_strPenaltyTitle[iPerkId];
    }

    m_arrCEPerks.AddItem(kPerk);
}

simulated function string GetBonusTitle(int iPerkId)
{
    return GetPerkName(iPerkId, ePerkBuff_Bonus);
}

simulated function string GetBriefSummary(int iPerkId)
{
    return GetPerkDescription(iPerkId, ePerkBuff_Passive);
}

simulated function string GetPenaltyTitle(int iPerkId)
{
    return GetPerkName(iPerkId, ePerkBuff_Penalty);
}

simulated function string GetPerkImage(int iPerk)
{
    local int Index;

    if (iPerk == 0)
    {
        return "";
    }

    if (iPerk == `LW_PERK_ID(IronSkin))
    {
        iPerk = `LW_PERK_ID(Concealment);
    }

    if (iPerk == `LW_PERK_ID(SmartMacrophages))
    {
        iPerk = `LW_PERK_ID(NeuralFeedback);
    }

    if (iPerk == `LW_PERK_ID(AdaptiveBoneMarrow))
    {
        iPerk = `LW_PERK_ID(FieldSurgeon);
    }

    Index = m_arrCEPerks.Find('iPerkId', iPerk);

    if (Index == INDEX_NONE)
    {
        return "";
    }

    return m_arrCEPerks[Index].Icon;
}

simulated function string GetPerkName(int iPerkId, optional EPerkBuffCategory perkCategory)
{
    local LWCE_TPerk kPerk;

    // For base game perks, we use the superclass data because it handles some tag localization for us
    if (iPerkId < ePerk_MAX)
    {
        return super.GetPerkName(iPerkId, perkCategory);
    }

    kPerk = LWCE_GetPerk(iPerkId);

    switch (perkCategory)
    {
        case ePerkBuff_Bonus:
            return kPerk.strBonusTitle;
        case ePerkBuff_Penalty:
            return kPerk.strPenaltyTitle;
        case ePerkBuff_Passive:
        default:
            return kPerk.strPassiveTitle;
    }
}

simulated function string GetPerkDescription(int iPerkId, optional EPerkBuffCategory perkCategory)
{
    local LWCE_TPerk kPerk;

    if (iPerkId == 0)
    {
        return "";
    }

    // For base game perks, we use the superclass data because it handles some tag localization for us
    if (iPerkId < ePerk_MAX)
    {
        if (m_arrPerks[iPerkId].strName[0] == "")
        {
            SetPerkStrings(iPerkId);
        }

        return m_arrPerks[iPerkId].strDescription[perkCategory];
    }
    else
    {
        kPerk = LWCE_GetPerk(iPerkId);

        switch (perkCategory)
        {
            case ePerkBuff_Bonus:
                return kPerk.strBonusDescription;
            case ePerkBuff_Penalty:
                return kPerk.strPenaltyDescription;
            case ePerkBuff_Passive:
            default:
                return kPerk.strPassiveDescription;
        }
    }
}

/// <summary>
/// Similar to GetPerkDescription, but provides an opportunity to use the context of which unit has
/// the buff in order to populate dynamic text for the buff's description.
/// </summary>
simulated function string GetDynamicPerkDescription(int iPerkId, LWCE_XGUnit kUnit, EPerkBuffCategory perkCategory)
{
    local string strText;

    switch (perkCategory)
    {
        case ePerkBuff_Bonus:
            strText = `LWCE_MOD_LOADER.GetDynamicBonusDescription(iPerkId, kUnit);
            break;
        case ePerkBuff_Penalty:
            strText = `LWCE_MOD_LOADER.GetDynamicPenaltyDescription(iPerkId, kUnit);
            break;
        case ePerkBuff_Passive:
        default:
            strText = GetPerkDescription(iPerkId, ePerkBuff_Passive); // Passives are never shown in context-sensitive areas
            break;
    }

    if (strText == "")
    {
        strText = GetPerkDescription(iPerkId, perkCategory);
    }

    return strText;
}

function EPerkType GetPerkInTreePsi(int branch, int Option)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetPerkInTreePsi was called. This needs to be replaced with LWCE_GetPerkInTree. Stack trace follows.");
    ScriptTrace();

    return ePerk_None;
}

function LWCE_TPerkTree GetTreeForClass(int iClassId, optional bool bIsPsiClass = false)
{
    local LWCE_TPerkTree kEmptyTree;
    local array<LWCE_TPerkTree> arrPossibleTrees;
    local int Index;

    arrPossibleTrees = bIsPsiClass ? arrPsionicClasses : arrSoldierClasses;
    Index = arrPossibleTrees.Find('iClassId', iClassId);

    if (Index != INDEX_NONE)
    {
        return arrPossibleTrees[Index];
    }

    kEmptyTree.iClassId = -100;
    return kEmptyTree;
}

function int GetNumColumnsInTreeRow(LWCE_XGStrategySoldier kSoldier, int iRow, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTree kTree;

    if (!TryFindMatchingTree(kTree, kSoldier, bIsPsiTree))
    {
        return 0;
    }

    if (kTree.arrPerkRows.Length <= iRow)
    {
        `LWCE_LOG_CLS("ERROR: perk tree doesn't have enough rows; requested row is " $ iRow);
        ScriptTrace();
        return 0;
    }

    if (kTree.arrPerkRows[iRow].arrPerkChoices.Length == 0)
    {
        `LWCE_LOG_CLS("Tree has no perks at requested rank.");
        return 0;
    }

    return kTree.arrPerkRows[iRow].arrPerkChoices.Length;
}

function int GetNumRowsInTree(LWCE_XGStrategySoldier kSoldier, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTree kTree;

    if (!TryFindMatchingTree(kTree, kSoldier, bIsPsiTree))
    {
        return 0;
    }

    return kTree.arrPerkRows.Length;
}

simulated function TPerk GetPerk(int iPerk)
{
    local TPerk kPerk;

    `LWCE_LOG_DEPRECATED_CLS(GetPerk);

    return kPerk;
}

simulated function LWCE_TPerk LWCE_GetPerk(int iPerkId)
{
    local int Index;
    local LWCE_TPerk kEmptyPerk;

    Index = m_arrCEPerks.Find('iPerkId', iPerkId);

    if (Index != INDEX_NONE)
    {
        return m_arrCEPerks[Index];
    }

    `LWCE_LOG_CLS("WARNING: did not find any perk with ID " $ iPerkId);

    return kEmptyPerk;
}

function EPerkType GetPerkInTree(ESoldierClass soldierClass, int branch, int Option, optional bool bIsPsiTree)
{
    `LWCE_LOG_DEPRECATED_CLS(GetPerkInTree);
    return 0;
}

function int LWCE_GetPerkInTree(LWCE_XGStrategySoldier kSoldier, int iRow, int iColumn, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTreeChoice kPerkChoice;

    if (!TryGetPerkChoiceInTree(kPerkChoice, kSoldier, iRow, iColumn, bIsPsiTree))
    {
        return 0;
    }

    return kPerkChoice.iPerkId;
}

function LWCE_TCharacterStats GetPerkStatChanges(LWCE_XGStrategySoldier kSoldier, int iRow, int iColumn, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTreeChoice kPerkChoice;
    local LWCE_TCharacterStats kStats;

    if (!TryGetPerkChoiceInTree(kPerkChoice, kSoldier, iRow, iColumn, bIsPsiTree))
    {
        return kStats;
    }

    return kPerkChoice.kStatChanges;
}

function GivePerk(XGUnit kUnit, int iPerkId)
{
    local LWCE_XGUnit kCEUnit;

    kCEUnit = LWCE_XGUnit(kUnit);

    if (kCEUnit.HasPerk(iPerkId))
    {
        return;
    }

    kCEUnit.GivePerk(iPerkId);

    if (XGBattle_SP(`BATTLE) != none)
    {
        switch (iPerkId)
        {
            case `LW_PERK_ID(FieldMedic):
                kUnit.SetMediKitCharges(3);
                break;
            case `LW_PERK_ID(ShockAndAwe):
                kUnit.SetRockets(2);
                break;
            case `LW_PERK_ID(ShredderAmmo):
                kUnit.SetShredderRockets(1);
                break;
            case `LW_PERK_ID(SmokeGrenade):
                kUnit.SetSmokeGrenadeCharges(3);
                break;
        }
    }
}

protected function bool TryFindMatchingTree(out LWCE_TPerkTree kMatchingTree, LWCE_XGStrategySoldier kSoldier, bool bIsPsiTree)
{
    local bool bFoundTree;
    local int iClassId;
    local array<LWCE_TPerkTree> arrTrees;
    local LWCE_TPerkTree kTree;

    iClassId = kSoldier.m_kCEChar.iClassId;
    arrTrees = bIsPsiTree ? arrPsionicClasses : arrSoldierClasses;

    foreach arrTrees(kTree)
    {
        if (kTree.iClassId != iClassId)
        {
            continue;
        }

        if (bFoundTree)
        {
            `LWCE_LOG_CLS("WARNING: found multiple trees matching iClassId = " $ iClassId $ ", bIsPsiTree = " $ bIsPsiTree);
            ScriptTrace();
            continue;
        }

        kMatchingTree = kTree;
        bFoundTree = true;
    }

    if (!bFoundTree)
    {
        `LWCE_LOG_CLS("ERROR: did not find any tree matching iClassId = " $ iClassId $ ", bIsPsiTree = " $ bIsPsiTree);
        return false;
    }

    return true;
}

function bool TryGetPerkChoiceInTree(out LWCE_TPerkTreeChoice kPerkChoice, LWCE_XGStrategySoldier kSoldier, int iRow, int iColumn, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTree kTree;

    if (!TryFindMatchingTree(kTree, kSoldier, bIsPsiTree))
    {
        return false;
    }

    if (kTree.arrPerkRows.Length <= iRow)
    {
        `LWCE_LOG_CLS("ERROR: perk tree doesn't have enough rows; requested row is " $ iRow);
        ScriptTrace();
        return false;
    }

    if (kTree.arrPerkRows[iRow].arrPerkChoices.Length == 0)
    {
        `LWCE_LOG_CLS("Tree has no perks at requested rank.");
        return false;
    }

    if (kTree.arrPerkRows[iRow].arrPerkChoices.Length <= iColumn)
    {
        `LWCE_LOG_CLS("ERROR: perk tree row " $ iRow $ " doesn't have enough columns; requested column is " $ iColumn);
        ScriptTrace();
        return false;
    }

    kPerkChoice = kTree.arrPerkRows[iRow].arrPerkChoices[iColumn];
    return true;
}

static simulated function bool LWCE_HasAnyGeneMod(out LWCE_TCharacter kChar)
{
    local LWCE_XComPerkManager kPerksMgr;
    local int Index;

    kPerksMgr = `LWCE_IS_STRAT_GAME ? `LWCE_PERKS_STRAT : `LWCE_PERKS_TAC;

    for (Index = 0; Index < kChar.arrPerks.Length; Index++)
    {
        if (kPerksMgr.LWCE_GetPerk(kChar.arrPerks[Index].Id).bIsGeneMod)
        {
            return true;
        }
    }

    return false;
}
class HighlanderTypes extends Object;

struct HL_TRange
{
    var int MinInclusive;
    var int MaxInclusive;
};

struct HL_TItemQuantity
{
    var int iItemId;
    var int iQuantity;
};

struct HL_TResearchCost
{
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iMeld;
    var int iWeaponFragments;
    var array<HL_TItemQuantity> arrItems;

    structdefaultproperties
    {
        iCash=0
        iAlloys=0
        iElerium=0
        iMeld=0
        iWeaponFragments=0
        arrItems=()
    }
};

// TODO: more customizable logic may be good in HL_TFoundryTech. For example, being able to make Foundry projects
// dependent on other Foundry projects, or even letting mods run arbitrary code to decide if a project is available,
// enabling (for example) mutually exclusive projects.
struct HL_TFoundryTech
{
    var int iTechId;            // The integer ID of the project. See README if you don't know how to choose IDs.
    var string strName;         // The friendly name of the Foundry project.
    var string strSummary;      // Friendly text describing the project to the player.

    var int iHours;             // The total number of engineer-hours required to complete this project. For example, if your project requires 15
                                // engineers and should take 48 hours to complete when at 15 engineers, this would be 15 * 48 = 720 hours.
    var int iEngineers;         // The number of engineers required to make progress at normal speed on this project.

    var int iAlloys;            // The number of alien alloys needed to start this project. Must be set both here and in kCost.
    var int iCash;              // The amount of cash needed to start this project. Must be set both here and in kCost.
    var int iElerium;           // The amount of elerium needed to start this project. Must be set both here and in kCost.
    var TResearchCost kCost;    // The base cost (unmodified by any continent bonuses or other situational modifiers) to start this project.

    var array<int> arrItemReqs; // A list of item IDs required to unlock this project. The player must have possessed these at one time,
                                // but doesn't necessarily need to still have them now.
    var array<int> arrTechReqs; // A list of research tech IDs required to unlock this project.
    var array<int> arrCredits;  // A list of research credit IDs that can apply to speed up this project.

    var string ImagePath;       // Path to an image to show in the Foundry UI for this project. Must include the "img:///" prefix.
                                // Typical Foundry images are 256x128.

    var bool bForceUnavailable; // If true, this project will never be shown in the list of available Foundry projects. This is the recommended
                                // way to deprecate Foundry projects from a mod, rather than deleting them (which may break existing game saves).
                                // If the player has already completed the project, it will still be visible in the Foundry.

    structdefaultproperties
    {
        iTechId=0
        strName=""
        strSummary=""
        iHours=0
        iEngineers=0
        iAlloys=0
        iCash=0
        iElerium=0
        kCost=(iCash=0,iElerium=0,iAlloys=0,arrItems=(),arrItemQuantities=())
        arrItemReqs=()
        arrTechReqs=()
        arrCredits=()
        ImagePath=""
        bForceUnavailable=false
    }
};

/**
 * Struct representing a research technology.
 */
struct HL_TTech
{
    var int iTechId;
    var string strName;     // The research name, as it will be seen when selecting research, browsing the archives, etc.
    var string strSummary;  // The summary text when selecting a new research in the Labs.
    var string strReport;   // The full text seen when the research is completed, or when viewing the research in the archives.
    var string strCustom;   // Extra text which is shown in yellow during the research results. Can be left blank if not needed.
    var string strCodename; // The codename which is seen during the research report.

    // Whether this is an autopsy or interrogation, and which character ID is the subject.
    // This has the following effects:
    //
    //     1. Autopsies/interrogations can benefit from special research time reductions, such as We Have Ways.
    //     2. Starting an autopsy/interrogation plays the associated cutscene for the subject character ID.
    //     3. Autopsies are required to view enemy perks, and to see special enemy names for navigators/leaders.
    //     4. Autopsied enemy types grant a damage bonus from the Vital Point Targeting perk.
    //
    // In Long War 1.0, some enemies (Outsiders, zombies, EXALT) don't have autopsy research, and always count as being
    // autopsied. With the Highlander, this behavior is retained even if a mod adds an autopsy tech for those enemies.
    // If any mod author wants to add those autopsies and wants this changed, please contact the Highlander team.
    var bool bIsAutopsy;
    var bool bIsInterrogation;
    var int iSubjectCharacterId;

    var int iHours; // How many scientist-hours this research takes. Each scientist completes one scientist-hour per hour, multiplied by research
                    // bonuses from laboratories and adjacencies. This value will be multiplied by DefaultGameCore.ini's TECH_TIME_BALANCE.
                    // For example, if this value is 240 (10 * 24), then 1 scientist can complete the research in 10 days, or 10 scientists in 1
                    // day, or 20 in 0.5 days, etc. This value is also reduced multiplicatively by research credits (see arrCredits below), situational
                    // modifiers such as We Have Ways for autopsies/interrogations, and others.

    var bool bRequiresAutopsy;       // If true, this research won't be unlocked until any autopsy research is completed, in addition to its other requirements.
    var bool bRequiresInterrogation; // If true, this research won't be unlocked until any interrogation research is completed, in addition to its other requirements.

    var int iCreditGranted; // The research credit ID granted by this tech, if any. See EResearchCredits for values.

    var array<int> arrItemReqs; // A list of item IDs required to unlock this project. The player must have possessed these at one time,
                                // but doesn't necessarily need to still have them now.
    var array<int> arrTechReqs; // A list of research tech IDs required to unlock this research.
    var array<int> arrUfoReqs;  // A list of UFO types that must be encountered before this research is available.

    var array<int> arrCredits;  // A list of research credit IDs that can apply to speed up this research.

    var string ImagePath;

    var HL_TResearchCost kCost;

    structdefaultproperties
    {
        iTechId=0
        strName=""
        strSummary=""
        strReport=""
        strCustom=""
        strCodename=""
        bIsAutopsy=false
        bIsInterrogation=false
        iHours=0
        iCreditGranted=0
        arrItemReqs=()
        arrTechReqs=()
        arrCredits=()
        ImagePath=""
        kCost=(iCash=0,iAlloys=0,iElerium=0,iMeld=0,iWeaponFragments=0,arrItems=())
    }
};

struct TModVersion
{
    var int Major;
    var int Minor;
    var int Revision;

    structdefaultproperties
    {
        Major=0
        Minor=0
        Revision=0
    }
};

// ------------------------------------------------------------------------------
// Structs beyond this point are unlikely to be needed by most mod authors. You
// can skip past them to see some utility functions.
// ------------------------------------------------------------------------------

struct HL_TLabArchivesUI
{
    var TMenu mnuArchives;
    var array<int> arrTechs;

    structdefaultproperties
    {
        mnuArchives=(strLabel="", arrOptions=(), bTakesNoInput=false)
        arrTechs=()
    }
};

struct HL_TResearchProgress
{
    var int iTechId;
    var int iHoursCompleted; // Scientist-hours of this research that have been completed
    var int iHoursSpent; // Number of clock hours the research has been worked on
    var XGDateTime kCompletionTime;
};

struct HL_TTechState
{
    var int iTechId;
    var ETechState eAvailabilityState;
};

static function TResearchCost HighlanderToBase_TResearchCost(HL_TResearchCost kInCost)
{
    local HL_TItemQuantity kItemQuantity;
    local TResearchCost kOutCost;

    kOutCost.iCash = kInCost.iCash;
    kOutCost.iAlloys = kInCost.iAlloys;
    kOutCost.iElerium = kInCost.iElerium;

    if (kInCost.iMeld > 0)
    {
        kOutCost.arrItems.AddItem(eItem_Meld);
        kOutCost.arrItemQuantities.AddItem(kInCost.iMeld);
    }

    if (kInCost.iWeaponFragments > 0)
    {
        kOutCost.arrItems.AddItem(eItem_WeaponFragment);
        kOutCost.arrItemQuantities.AddItem(kInCost.iWeaponFragments);
    }

    foreach kInCost.arrItems(kItemQuantity)
    {
        kOutCost.arrItems.AddItem(kItemQuantity.iItemId);
        kOutCost.arrItemQuantities.AddItem(kItemQuantity.iQuantity);
    }

    return kOutCost;
}
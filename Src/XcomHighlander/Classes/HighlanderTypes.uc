class HighlanderTypes extends Object;

struct HL_TRange
{
    var int MinInclusive;
    var int MaxInclusive;
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
class LWCE_XComHumanPawn extends XComHumanPawn;

`include(sort.uci)

// Based on XCOM 2's PawnContentRequest
struct LWCE_PawnContentRequest
{
	var name ContentCategory;
    var name Template;
	var string ArchetypeName;
	var Object kContent;
	var Delegate<OnContentLoadedDelegate> ContentLoadedFn;
};

var LWCE_TCharacter m_kCEChar;
var LWCE_TLoadout m_kCELoadout;
var LWCE_TAppearance m_kCEAppearance;

var name m_nmArmor;
var name m_nmPrimaryWeapon;

var array<LWCEArmorColorContentTemplate> m_arrCEArmorColors;
var array<LWCEArmorKitContentTemplate> m_arrCEArmorKits;
var array<LWCEFacialHairContentTemplate> m_arrCEFacialHairs;
var array<LWCEHairContentTemplate> m_arrCEHairs;
var array<LWCEHairColorContentTemplate> m_arrCEHairColors;
var array<LWCEHeadContentTemplate> m_arrCEHeads;
var array<LWCERaceTemplate> m_arrCERaces;
var array<LWCESkinColorContentTemplate> m_arrCESkinColors;
var array<LWCEVoiceContentTemplate> m_arrCEVoices;

var private array<LWCE_PawnContentRequest> m_arrCEPawnContentRequests;

delegate OnContentLoadedDelegate(LWCE_PawnContentRequest ContentRequest);

simulated event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}

simulated event PostBeginPlay()
{
    local LWCEPawnContentTemplate kPawnTemplate;
    local LWCE_XGUnit kUnit;
	local XComUnitPawn kArchetype;

    if (`LWCE_IS_TAC_GAME)
    {
        // During the tactical game, we can load our archetype directly and initialize from it
        kUnit = LWCE_XGUnit(GetGameUnit());

        if (kUnit == none)
        {
            kUnit = LWCE_XGUnit(Owner);

            if (kUnit != none)
            {
                // We're supposed to be owned by the unit's Owner; reset that here
                SetOwner(Owner.Owner);
            }
        }

        if (kUnit != none)
        {
            m_kCEAppearance = kUnit.m_kCESoldier.kAppearance;
            `LWCE_LOG_CLS("FindMatchingPawn: calling in tac game, unit iGender = " $ kUnit.m_kCESoldier.kAppearance.iGender $ ", local iGender = " $ m_kCEAppearance.iGender);
            kPawnTemplate = `LWCE_CONTENT_TEMPLATE_MGR.FindMatchingPawn(ECharacter(kUnit.LWCE_GetCharacter().GetCharacterType()), EGender(kUnit.m_kCESoldier.kAppearance.iGender), kUnit.LWCE_GetCharacter().GetCharacter().kInventory.nmArmor);
            kArchetype = XComUnitPawn(`LWCE_CONTENT_MGR.GetArchetypeByPath(kPawnTemplate.ArchetypeName));
            class'LWCEActorUtilities'.static.InitPawnFromArchetype(kArchetype, self);
        }
    }
	else if (`LWCE_IS_STRAT_GAME)
	{
        // During the strat game, we can't load the archetype directly because it hasn't necessarily
        // been requested by the content system. We just manually create a few necessary components, and
		// the remainder is populated later on.
		CylinderComponent = new (self) class'CylinderComponent';
		AttachComponent(CylinderComponent);
		CollisionComponent = CylinderComponent;

		LightEnvironment = new (self) class'DynamicLightEnvironmentComponent';
		LightEnvironment.bCastShadows = true;
		LightEnvironment.BoundsMethod = DLEB_ManualOverride;
		LightEnvironment.OverriddenBounds.BoxExtent.X = 75.0;
		LightEnvironment.OverriddenBounds.BoxExtent.Y = 75.0;
		LightEnvironment.OverriddenBounds.BoxExtent.Z = 75.0;
		LightEnvironment.OverriddenBounds.SphereRadius = 75.0;
		AttachComponent(LightEnvironment);

		Mesh = new (self) class'SkeletalMeshComponent';
		Mesh.SetLightEnvironment(LightEnvironment);
		AttachComponent(Mesh);

		RangeIndicator = new (self) class'StaticMeshComponent';
		AttachComponent(RangeIndicator);
	}

	m_kHeadMeshComponent = new (self) class'SkeletalMeshComponent';
	m_kHeadMeshComponent.SetActorCollision(true, false, false);
	m_kHeadMeshComponent.SetTraceBlocking(true, m_kHeadMeshComponent.BlockNonZeroExtent);
	m_kHeadMeshComponent.SetAcceptsDynamicDecals(true);
	m_kHeadMeshComponent.SetLightEnvironment(LightEnvironment);
	AttachComponent(m_kHeadMeshComponent);

	super.PostBeginPlay();
}

function LWCE_Init(const out LWCE_TCharacter inCharacter, const out LWCE_TInventory Inv, const out LWCE_TAppearance Appearance)
{
    `LWCE_LOG_CLS("LWCE_Init: current state is " $ GetStateName());

    m_kCEChar = inCharacter;
    bIsFemale = Appearance.iGender == eGender_Female;
    m_kCEAppearance = Appearance;

    LWCE_SetAppearance(Appearance, false);
    LWCE_SetInventory(m_kCEChar, Inv, Appearance);
    SetPhysics(PHYS_Flying);
    LWCE_FindPossibleCustomParts(m_kCEChar);
    SetAuxParameters(true, false, false);
}

simulated function AttachItem(Actor A, name SocketName, bool bIsRearBackPackItem, out MeshComponent kFoundMeshComponent)
{
    class'LWCE_XComUnitPawn_Extensions'.static.AttachItem(self, A, SocketName, bIsRearBackPackItem, kFoundMeshComponent);
}

simulated function AddKitRequests()
{
    local LWCE_PawnContentRequest kRequest;
    local LWCE_XGUnit GameUnit;
    local LWCE_TCharacter kChar;

    GameUnit = LWCE_XGUnit(GetGameUnit());
    kChar = GameUnit.LWCE_GetCharacter().GetCharacter();
    m_iRequestKit = -1;

    if (m_kCEAppearance.nmArmorKit != '' && kChar.kInventory.nmArmor != 'Item_LeatherJacket')
    {
        kRequest.ContentCategory = 'ArmorKit';
        kRequest.Template = m_kCEAppearance.nmArmorKit;
        m_arrCEPawnContentRequests.AddItem(kRequest);
    }
    else if (class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(kChar))
    {
        return;
    }
    else if (kChar.kInventory.nmArmor == 'Item_LeatherJacket')
    {
        return;
    }
    else
    {
        // TODO use default kit for gear
    }

// TODO
//    Kit = `LWCE_CONTENT_MGR.GetDefaultKitArchetypeForWeaponAndArmor(kChar.kInventory.nmArmor, nmPrimaryWeapon);
//
//    if (Kit != eKit_None)
//    {
//        kRequest.iID = Kit;
//        m_arrCEPawnContentRequests.AddItem(kRequest);
//        m_iRequestKit = Kit;
//    }
}

simulated function RequestFullPawnContent()
{
    local LWCEContentTemplate ContentTemplate;
    local LWCE_PawnContentRequest kRequest;
    local LWCE_XGUnit GameUnit;
    local LWCEContentTemplateManager kTemplateMgr;

    GameUnit = LWCE_XGUnit(GetGameUnit());
    kTemplateMgr = `LWCE_CONTENT_TEMPLATE_MGR;

    kRequest.ContentLoadedFn = OnPawnContentLoaded; // same for all request types

    if ( (m_bSetAppearance && m_bSetArmorKit) || (GameUnit != none && GameUnit.IsCivilian()) )
    {
        m_arrCEPawnContentRequests.Length = 0;

        if (IsInStrategy())
        {
            `LWCE_LOG_CLS("FindMatchingPawn: calling in RequestFullPawnContent, iGender = " $ m_kCEAppearance.iGender);
            ContentTemplate = kTemplateMgr.FindMatchingPawn(ECharacter(m_kCEChar.iCharacterType), EGender(m_kCEAppearance.iGender), m_kCEChar.kInventory.nmArmor);

            if (ContentTemplate == none)
            {
                `LWCE_LOG_CLS("ERROR: No valid pawn templates found for human pawn " $ self $ "! Cannot load pawn content.");
                return;
            }

            kRequest.ContentCategory = 'Pawn';
            kRequest.Template = ContentTemplate.GetContentTemplateName();
            kRequest.ArchetypeName = ContentTemplate.ArchetypeName;

            m_arrCEPawnContentRequests.AddItem(kRequest);
        }

        if (m_kCEAppearance.nmArmorKit != '')
        {
            `LWCE_LOG_CLS("Getting armor kit template " $ m_kCEAppearance.nmArmorKit);
            ContentTemplate = kTemplateMgr.FindArmorKitTemplate(m_kCEAppearance.nmArmorKit);

            kRequest.ContentCategory = 'ArmorKit';
            kRequest.Template = ContentTemplate.GetContentTemplateName();
            kRequest.ArchetypeName = ContentTemplate.ArchetypeName;

            m_arrCEPawnContentRequests.AddItem(kRequest);
        }

        if (m_kCEAppearance.nmHead != '')
        {
            `LWCE_LOG_CLS("Getting head template " $ m_kCEAppearance.nmHead);
            ContentTemplate = kTemplateMgr.FindHeadTemplate(m_kCEAppearance.nmHead);

            kRequest.ContentCategory = 'Head';
            kRequest.Template = ContentTemplate.GetContentTemplateName();
            kRequest.ArchetypeName = ContentTemplate.ArchetypeName;

            m_arrCEPawnContentRequests.AddItem(kRequest);
        }

        if (m_kCEAppearance.nmHaircut != '')
        {
            `LWCE_LOG_CLS("Getting hair template " $ m_kCEAppearance.nmHaircut);
            ContentTemplate = kTemplateMgr.FindHairTemplate(m_kCEAppearance.nmHaircut);

            // TODO: pick a random applicable hair template and save it to the appearance
            if (LWCEHairContentTemplate(ContentTemplate).bIsHelmet && !AreHelmetsAllowed())
            {

            }

            kRequest.ContentCategory = 'Hair';
            kRequest.Template = ContentTemplate.GetContentTemplateName();
            kRequest.ArchetypeName = ContentTemplate.ArchetypeName;

            m_arrCEPawnContentRequests.AddItem(kRequest);
        }

        if (m_kCEAppearance.nmVoice != '')
        {
            `LWCE_LOG_CLS("Getting voice template " $ m_kCEAppearance.nmVoice);
            ContentTemplate = kTemplateMgr.FindVoiceTemplate(m_kCEAppearance.nmVoice);

            kRequest.ContentCategory = 'Voice';
            kRequest.Template = ContentTemplate.GetContentTemplateName();
            kRequest.ArchetypeName = ContentTemplate.ArchetypeName;

            m_arrCEPawnContentRequests.AddItem(kRequest);
        }

        //AddKitRequests();

        NumPawnContentRequestsRemaining = m_arrCEPawnContentRequests.Length;

        SetTimer(0.010, false, 'MakeAllContentRequests');
    }
}

simulated function MakeAllContentRequests()
{
    local int Index;
    local delegate<OnContentLoadedDelegate> ContentLoadedFn;
    local LWCEContentManager kContentMgr;

    kContentMgr = `LWCE_CONTENT_MGR;

    // TODO: may need to load content asynchronously somehow
    for (Index = 0; Index < m_arrCEPawnContentRequests.Length; Index++)
    {
        m_arrCEPawnContentRequests[Index].kContent = kContentMgr.GetArchetypeByPath(m_arrCEPawnContentRequests[Index].ArchetypeName);
        ContentLoadedFn = m_arrCEPawnContentRequests[Index].ContentLoadedFn;

        `LWCE_LOG_CLS("Requested content " $ m_arrCEPawnContentRequests[Index].ArchetypeName $ " and loaded object " $ m_arrCEPawnContentRequests[Index].kContent);

        if (ContentLoadedFn != none)
        {
            ContentLoadedFn(m_arrCEPawnContentRequests[Index]);
        }
    }
}

simulated function PawnContentFullyLoaded()
{
    local bool bLoadedArmorKit;
    local LWCE_PawnContentRequest kRequest;

    foreach m_arrCEPawnContentRequests(kRequest)
    {
        `LWCE_LOG_CLS("PawnContentFullyLoaded: ContentCategory = " $ kRequest.ContentCategory $ ", kContent = " $ kRequest.kContent);

        switch (kRequest.ContentCategory)
        {
            case 'Pawn':
                OnArmorLoaded(kRequest.kContent, -1, -1);
                break;
            case 'Head':
                OnHeadLoaded(kRequest.kContent);
                break;
            case 'Hair':
                if (m_kCEAppearance.nmHaircut == '')
                {
                    RemoveHair();
                }
                else
                {
                    OnHairLoaded(kRequest.kContent);
                }

                break;
            case 'Body':
                OnBodyLoaded(kRequest.kContent);
                break;
            case 'ArmorKit':
                bLoadedArmorKit = kRequest.kContent != none;
                `LWCE_LOG_CLS("Armor kit loaded: kRequest.kContent = " $ kRequest.kContent);
                OnArmorKitLoaded(kRequest.kContent);
                break;
            case 'Voice':
                OnVoiceLoaded(kRequest.kContent);
                break;
        }
    }

    if (m_kCEAppearance.nmHaircut == '')
    {
        RemoveHair();
    }

    if (!bLoadedArmorKit)
    {
        DetachAuxMesh(m_kKitMesh);
    }

    UpdateAllMeshMaterials();
    LightEnvironment.ResetEnvironment();

    m_arrCEPawnContentRequests.Length = 0;
    NumPawnContentRequestsRemaining = 0;
}

simulated function SetAppearance(const out TAppearance kAppearance, optional bool bRequestContent = true)
{
    `LWCE_LOG_DEPRECATED_CLS(SetAppearance);
}

simulated function LWCE_SetAppearance(const out LWCE_TAppearance kAppearance, optional bool bRequestContent = true)
{
    m_kCEAppearance = kAppearance;
    bIsFemale = m_kCEAppearance.iGender == eGender_Female;
    m_bSetAppearance = true;

    if (bRequestContent)
    {
        RequestFullPawnContent();
    }
}

simulated function LWCE_SetInventory(const out LWCE_TCharacter inCharacter, const out LWCE_TInventory Inv, const out LWCE_TAppearance Appearance)
{
    local LWCE_TLoadout BlankLoadout;

    RemoveAttachments();
    DetachAuxMesh(m_kKitMesh);
    m_kCELoadout = BlankLoadout;
    class'LWCE_XGLoadoutMgr'.static.LWCE_ConvertTInventoryToSoldierLoadout(m_kCEChar, Inv, m_kCELoadout);

    BaseArmorTint.Primary.R = 0.0;
    BaseArmorTint.Primary.G = 0.0;
    BaseArmorTint.Primary.B = 0.0;

    BaseArmorTint.Secondary.R = 0.0;
    BaseArmorTint.Secondary.G = 0.0;
    BaseArmorTint.Secondary.B = 0.0;

    m_nmArmor = Inv.nmArmor;
    m_kCEAppearance = Appearance;
    m_bHasGeneMods = class'LWCE_XComPerkManager'.static.LWCE_HasAnyGeneMod(inCharacter);
    //PawnType = class'LWCE_XGBattleDesc'.static.LWCE_MapSoldierToPawn(Inv.nmArmor, Appearance.iGender);
    m_nmPrimaryWeapon = class'LWCE_XGTacticalGameCore'.static.LWCE_GetPrimaryWeapon(m_kCEChar.kInventory);
    m_bSetArmorKit = true;

    `LWCE_LOG_CLS("nmArmor = " $ Inv.nmArmor $ "; PawnType = " $ PawnType);

    RequestFullPawnContent();
}

function LWCE_FindPossibleCustomParts(const out LWCE_TCharacter inCharacter)
{
    local LWCEContentTemplateManager kTemplateMgr;
    local bool bResetAppearance;
    local name nmRace;

    kTemplateMgr = `LWCE_CONTENT_TEMPLATE_MGR;

    // Handle race first, because many other part types depend on it
    m_arrCERaces = kTemplateMgr.GetRaces();

    if (m_kCEAppearance.nmRace == '')
    {
        m_kCEAppearance.nmRace = m_arrCERaces[Rand(m_arrCERaces.Length)].GetContentTemplateName();
        bResetAppearance = true;

        `LWCE_LOG_CLS(self $ ": Chose new race " $ m_kCEAppearance.nmRace);
    }

    nmRace = kTemplateMgr.FindRaceTemplate(m_kCEAppearance.nmRace).Race;
    `LWCE_LOG_CLS("Soldier's race is " $ m_kCEAppearance.nmRace $ " which resolves to " $ nmRace);

    m_arrCEArmorKits = kTemplateMgr.FindMatchingArmorKits(inCharacter.kInventory.nmArmor); // TODO get default and set if needed
    m_arrCEFacialHairs = kTemplateMgr.GetFacialHairs();
    m_arrCEHairs = kTemplateMgr.FindMatchingHair(EGender(m_kCEAppearance.iGender), /* bCivilianOnly */ false, /* bAllowHelmets */ true);
    m_arrCEHeads = kTemplateMgr.FindMatchingHeads(ECharacter(m_kCEChar.iCharacterType), nmRace, EGender(m_kCEAppearance.iGender));
    m_arrCEVoices = kTemplateMgr.FindMatchingVoices(EGender(m_kCEAppearance.iGender), m_kCEAppearance.nmLanguage, inCharacter.bIsAugmented);

    m_arrCEArmorColors = kTemplateMgr.GetArmorColors();
    m_arrCEHairColors = kTemplateMgr.GetHairColors();
    m_arrCESkinColors = kTemplateMgr.FindMatchingSkinColors(nmRace);

    // If we've just changed race or gender, some of our appearance may be invalid. If that's the case, pick replacements at random.
    if (m_kCEAppearance.nmHaircut == '')
    {
        m_kCEAppearance.nmHaircut = m_arrCEHairs[Rand(m_arrCEHairs.Length)].GetContentTemplateName();
        bResetAppearance = true;
    }

    if (m_kCEAppearance.nmHead == '')
    {
        m_kCEAppearance.nmHead = m_arrCEHeads[Rand(m_arrCEHeads.Length)].GetContentTemplateName();
        bResetAppearance = true;
    }

    if (m_kCEAppearance.nmSkinColor == '')
    {
        m_kCEAppearance.nmSkinColor = m_arrCESkinColors[Rand(m_arrCESkinColors.Length)].GetContentTemplateName();
        bResetAppearance = true;
    }

    if (m_kCEAppearance.nmVoice == '')
    {
        m_kCEAppearance.nmVoice = m_arrCEVoices[Rand(m_arrCEVoices.Length)].GetContentTemplateName();
        bResetAppearance = true;
    }

    if (bResetAppearance)
    {
        LWCE_SetAppearance(m_kCEAppearance);
    }
}

// TODO document why this is out here
function SkeletalMesh GetBodyMesh(XComHumanPawn PawnArchetype);
function name GetSocketNameFromLocation(ELocation Loc);
function OnWeaponLoaded(Object WeaponArchetype);
function SetLightingChannelsForUnit();

function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID)
{
    `LWCE_LOG_CLS("OnArmorLoaded: delegating to InHQ. ArmorArchetype = " $ ArmorArchetype $ ", ContentId = " $ ContentId $ ", SubID = " $ SubID);
    InHQ_OnArmorLoaded(ArmorArchetype, ContentId, SubID);
}

// TODO document why this is out here
function InHQ_OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID)
{
    local int ItemIdx, MatIdx;
    local ItemAttachment Item;
    local SkeletalMesh BodyMesh, WeaponMesh;
    local XComHumanPawn PawnArchetype;
    local XComLinearColorPalette ArmorTintPalette;

    `LWCE_LOG_CLS("Loaded armor archetype " $ ArmorArchetype $ ". ContentId = " $ ContentId $ ", SubID = " $ SubID);

    PawnArchetype = XComHumanPawn(ArmorArchetype);
    bNeedsFallbackHair = PawnArchetype.bNeedsFallbackHair;
    OnHairLoaded(HairContent);
    BodyMesh = GetBodyMesh(PawnArchetype);

    if (BodyMesh != Mesh.SkeletalMesh)
    {
        Mesh.SetSkeletalMesh(BodyMesh);

        if (BodyMesh != PawnArchetype.Mesh.SkeletalMesh)
        {
            for (MatIdx = 0; MatIdx < BodyMesh.Materials.Length; MatIdx++)
            {
                Mesh.SetMaterial(MatIdx, BodyMesh.Materials[MatIdx]);
            }
        }
        else
        {
            for (MatIdx = 0; MatIdx < PawnArchetype.Mesh.GetNumElements(); MatIdx++)
            {
                Mesh.SetMaterial(MatIdx, PawnArchetype.Mesh.GetMaterial(MatIdx));
                Mesh.SetAuxMaterial(MatIdx, PawnArchetype.Mesh.GetAuxMaterial(MatIdx));
            }
        }

        AddRequiredAnimSets();
        Mesh.SetAnimTreeTemplate(HQAnimTree);
        Mesh.UpdateAnimations();

        UpdateAllMeshMaterials();

        Mesh.PrestreamTextures(10.0, true);
        Mesh.SetLightEnvironment(LightEnvironment);
    }

// TODO
/*
    if (`CONTENTMGR.GetContentInfo_Unit(PawnType, UnitInfo))
    {
        NumPossibleArmorSkins = UnitInfo.SkinArchetypes.Length;
    }
 */

    ArmorTintPalette = `CONTENTMGR.GetColorPalette(ePalette_ArmorTint);
    NumPossibleArmorTints = ArmorTintPalette != none ? ArmorTintPalette.Entries.Length : 0;
    RemoveAttachments();

    if (PawnType != ePawnType_MecCivvies && PawnType != ePawnType_Female_MecCivvies)
    {
        for (ItemIdx = 0; ItemIdx < eSlot_MAX; ItemIdx++)
        {
            if (m_kCELoadout.Items[ItemIdx] != '' && m_kCELoadout.Items[ItemIdx] != 'Item_PsiAmp')
            {
                if (m_kCELoadout.Items[ItemIdx] == m_nmPrimaryWeapon)
                {
                    Item.SocketName = GetSocketNameFromLocation(eSlot_RightHand);
                }
                else
                {
                    Item.SocketName = GetSocketNameFromLocation(ELocation(ItemIdx));
                }

                Item.Component = none;
                ActiveAttachments.AddItem(Item);
                WeaponMesh = `LWCE_CONTENT_MGR.GetWeaponSkeletalMesh(m_kCELoadout.Items[ItemIdx]);
                OnWeaponLoaded(WeaponMesh);
            }
        }
    }
    else
    {
        Mesh.SetAnimTreeTemplate(XComGameInfo(WorldInfo.Game).MECCivvieAnimTreeHQ);
    }

    SetLightingChannelsForUnit();
    LightEnvironment.ResetEnvironment();
    //SetTimer(0.10, false, 'RequestKitPostArmor');
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local AnimNodeBlendList HeadAnimNodeBL, HeadToggleBL;
    local string ComputedHeadAnim;
    local XGUnit GameUnit;

    AddRequiredAnimSets();

    class'LWCE_XComUnitPawn_Extensions'.static.PostInitAnimTree(self, SkelComp);

    super(Pawn).PostInitAnimTree(SkelComp);

    if (bIsFemale)
    {
        if (SkelComp == Mesh)
        {
            GenderBlender = AnimNodeAdditiveBlending(Mesh.Animations.FindAnimNode('GenderBlender'));
        }

        if (GenderBlender != none && !bSkipGenderBlender)
        {
            GenderBlender.bPassThroughWhenNotRendered = false;
            GenderBlender.SetBlendTarget(1.0, 0.0);
        }
    }

    if (HeadContent != none && m_kHeadMeshComponent.SkeletalMesh == HeadContent.SkeletalMesh)
    {
        ComputedHeadAnim = string(HeadContent.SkeletalMesh.Name);
        ComputedHeadAnim = Repl(ComputedHeadAnim, "SM_", "face_", true);
        HeadAnimNodeBL = AnimNodeBlendList(Mesh.Animations.FindAnimNode('Head'));
        HeadToggleBL = AnimNodeBlendList(Mesh.Animations.FindAnimNode('HeadToggle'));

        if (HeadAnimNodeBL != none && HeadToggleBL != none)
        {
            SetHeadAnim(HeadAnimNodeBL, name(ComputedHeadAnim));
            HeadAnimNodeBL.SetActiveChild(0, 0.0);
            HeadToggleBL.SetActiveChild(1, 0.0);

            // TODO: trying to add FaceGenNode to the SkeletalMeshComponent stub makes the compiler crash
            // m_kHeadMeshComponent.FaceGenNode = HeadToggleBL;
        }
    }

    InitLeftHandIK();
    GameUnit = XGUnit(GetGameUnit());

    if (IsInStrategy() || (GameUnit != none && GameUnit.GetArmorType() == eItem_ArmorArchangel))
    {
        m_kJetPackNode = XComAnimNodeJetpack(Mesh.FindAnimNode('Jetpack'));

        if (GameUnit != none && GameUnit.IsFlying())
        {
            m_kJetPackNode.SetActiveChild(2, 0.0);
        }
    }
}

simulated function SetArmorDeco(int DecoIdx)
{
    `LWCE_LOG_DEPRECATED_CLS(SetArmorDeco);
}

simulated function LWCE_SetArmorDeco(name nmArmorKit)
{
    m_kCEAppearance.nmArmorKit = nmArmorKit;

    if (IsA('XComMecPawn'))
    {
        UpdateAllMeshMaterials();
    }

    LWCE_SetAppearance(m_kCEAppearance);
}

simulated function SetArmorTint(int TintIdx)
{
    `LWCE_LOG_DEPRECATED_CLS(SetArmorTint);
}

simulated function LWCE_SetArmorTint(name nmArmorColor)
{
    m_kCEAppearance.nmArmorColor = nmArmorColor;
    UpdateAllMeshMaterials();
}

// There is no non-LWCE SetGender, but this keeps it consistent with other functions
simulated function LWCE_SetGender(int iGender)
{
    m_kCEAppearance.iGender = iGender;

    // Invalidate fields that are gender-dependent
    m_kCEAppearance.nmHaircut = '';
    m_kCEAppearance.nmHead = '';
    m_kCEAppearance.nmVoice = '';

    // Refresh the possible parts for this pawn. Don't bother calling LWCE_SetAppearance, that will
    // be done automatically in LWCE_FindPossibleCustomParts after it replaces the newly-blank fields.
    LWCE_FindPossibleCustomParts(m_kCEChar);
}

simulated function SetFacialHair(int PresetIdx)
{
    `LWCE_LOG_DEPRECATED_CLS(SetFacialHair);
}

simulated function LWCE_SetFacialHair(name nmFacialHair)
{
    if (m_kCEAppearance.iGender == eGender_Male)
    {
        m_kCEAppearance.nmFacialHair = nmFacialHair;
        UpdateMeshMaterials(m_kHeadMeshComponent);
    }
}

simulated function SetHair(int HairId)
{
    `LWCE_LOG_DEPRECATED_CLS(SetHair);
}

simulated function LWCE_SetHair(name nmHaircut)
{
    m_kCEAppearance.nmHaircut = nmHaircut;
    LWCE_SetAppearance(m_kCEAppearance);
}

simulated function SetHairColor(int ColorIdx)
{
    `LWCE_LOG_DEPRECATED_CLS(SetHairColor);
}

simulated function LWCE_SetHairColor(name nmHairColor)
{
    m_kCEAppearance.nmHairColor = nmHairColor;
    LWCE_SetAppearance(m_kCEAppearance);
}

simulated function SetHead(int HeadId)
{
    `LWCE_LOG_DEPRECATED_CLS(SetHead);
}

simulated function LWCE_SetHead(name nmHead)
{
    m_kCEAppearance.nmHead = nmHead;
    LWCE_SetAppearance(m_kCEAppearance);
}

simulated function SetRace(ECharacterRace Race)
{
    `LWCE_LOG_DEPRECATED_CLS(SetRace);
}

simulated function LWCE_SetRace(name nmRace)
{
    m_kCEAppearance.nmRace = nmRace;

    // Invalidate fields that are race-dependent
    m_kCEAppearance.nmHead = '';
    m_kCEAppearance.nmSkinColor = '';

    // Update possible parts and trigger replacements of newly-invalid parts
    LWCE_FindPossibleCustomParts(m_kCEChar);
}

simulated function SetSkinColor(int ColorIdx)
{
    `LWCE_LOG_DEPRECATED_CLS(SetSkinColor);
}

simulated function LWCE_SetSkinColor(name nmSkinColor)
{
    m_kCEAppearance.nmSkinColor = nmSkinColor;
    UpdateMeshMaterials(m_kHeadMeshComponent);
    UpdateMeshMaterials(Mesh);
}

simulated function SetVoice(ECharacterVoice NewVoice)
{
    `LWCE_LOG_DEPRECATED_CLS(SetVoice);
}

simulated function LWCE_SetVoice(name nmNewVoice)
{
    bShouldSpeak = true;
    m_kCEAppearance.nmVoice = nmNewVoice;
    LWCE_SetAppearance(m_kCEAppearance);
}

simulated function SetVoiceSilently(ECharacterVoice NewVoice)
{
    `LWCE_LOG_DEPRECATED_CLS(SetVoiceSilently);
}

simulated function LWCE_SetVoiceSilently(name nmNewVoice)
{
    m_kCEAppearance.nmVoice = nmNewVoice;
}

simulated function SetupForMatinee(optional Actor MatineeBase, optional bool bDisableFootIK, optional bool bDisableGenderBlender)
{
    PrepForMatinee();

    if (bDisableGenderBlender && bIsFemale && GenderBlender != none)
    {
        GenderBlender.SetBlendTarget(0.0, 0.0);
    }

    // Replaces call to superclass's SetupForMatinee
    class'LWCE_XComUnitPawn_Extensions'.static.SetupForMatinee(self, MatineeBase, bDisableFootIK, bDisableGenderBlender);
}

simulated function UpdateArmorMaterial(MeshComponent MeshComp, MaterialInstanceConstant MIC)
{
    local LinearColor ParamColor;
    local LWCEColorContentTemplate kTemplate;

    kTemplate = `LWCE_CONTENT_TEMPLATE_MGR.FindArmorColorTemplate(m_kCEAppearance.nmArmorColor);

    if (kTemplate != none)
    {
        `LWCE_LOG_CLS("Setting primary color to " $ kTemplate.PrimaryColor.R $ ", " $ kTemplate.PrimaryColor.G $ ", " $ kTemplate.PrimaryColor.B $ " and secondary to " $ kTemplate.SecondaryColor.R $ ", " $ kTemplate.SecondaryColor.G $ ", " $ kTemplate.SecondaryColor.B);
        ParamColor = ColorToLinearColor(kTemplate.PrimaryColor);
        MIC.SetVectorParameterValue('CMOD', ParamColor);

        ParamColor = ColorToLinearColor(kTemplate.SecondaryColor);
        MIC.SetVectorParameterValue('CMODB', ParamColor);
    }
    else
    {
        ParamColor = MakeLinearColor(1.0f, 1.0f, 1.0f, 0.0f);

        MIC.SetVectorParameterValue('CMOD', ParamColor);
        MIC.SetVectorParameterValue('CMODB', ParamColor);
    }
}

simulated function UpdateHairMaterial(MaterialInstanceConstant MIC)
{
    local LWCEColorContentTemplate kTemplate;
    local LinearColor ParamColor;

    kTemplate = `LWCE_CONTENT_TEMPLATE_MGR.FindHairColorTemplate(m_kCEAppearance.nmHairColor);
    ParamColor = ColorToLinearColor(kTemplate.PrimaryColor);
    MIC.SetVectorParameterValue('ColorMod', ParamColor);
}

simulated function UpdateSkinMaterial(MaterialInstanceConstant MIC, bool bHasHair)
{
    local LinearColor ParamColor;
    local LWCEColorContentTemplate kTemplate;
    local LWCEFacialHairContentTemplate kFacialHair;
    local LWCEContentTemplateManager kTemplateMgr;

    kTemplateMgr = `LWCE_CONTENT_TEMPLATE_MGR;

    kTemplate = kTemplateMgr.FindSkinColorTemplate(m_kCEAppearance.nmSkinColor);
    ParamColor = ColorToLinearColor(kTemplate.PrimaryColor);
    MIC.SetVectorParameterValue('SkinColor', ParamColor);

    kTemplate = kTemplateMgr.FindHairColorTemplate(m_kCEAppearance.nmHairColor);
    ParamColor = ColorToLinearColor(kTemplate.PrimaryColor);
    MIC.SetVectorParameterValue('HairColor', ParamColor);

    if (m_kCEAppearance.iGender == eGender_Male && bHasHair && m_kCEAppearance.nmFacialHair != '')
    {
        kFacialHair = kTemplateMgr.FindFacialHairTemplate(m_kCEAppearance.nmFacialHair);
        ParamColor = ColorToLinearColor(kFacialHair.Mask);

        MIC.SetScalarParameterValue('UVOffset', kFacialHair.UVOffset);
        MIC.SetVectorParameterValue('ChannelMask', ParamColor);
    }
    else
    {
        // Reset to no facial hair
        ParamColor.A = 1.0f;
        ParamColor.R = 0.0f;
        ParamColor.G = 0.0f;
        ParamColor.B = 0.0f;

        MIC.SetScalarParameterValue('UVOffset', 0.0f);
        MIC.SetVectorParameterValue('ChannelMask', ParamColor);
    }
}

protected function OnPawnContentLoaded(LWCE_PawnContentRequest ContentRequest)
{
    NumPawnContentRequestsRemaining--;

    if (NumPawnContentRequestsRemaining == 0)
    {
        PawnContentFullyLoaded();
    }
}

state InHQ
{
    simulated event BeginState(name PreviousStateName)
    {
        `LWCE_LOG_CLS("InHQ BeginState: prev = " $ PreviousStateName);
        super.BeginState(PreviousStateName);
    }

    simulated event EndState(name NextStateName)
    {
        `LWCE_LOG_CLS("InHQ EndState: next = " $ NextStateName);
        super.EndState(NextStateName);
    }

    simulated function AddKitRequests()
    {
        super.AddKitRequests();
    }

    function Init(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance)
    {
        `LWCE_LOG_DEPRECATED_CLS(Init);
    }

    function FindPossibleCustomParts(const out TCharacter inCharacter)
    {
        `LWCE_LOG_DEPRECATED_CLS(FindPossibleCustomParts);
    }

    function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID)
    {
        `LWCE_LOG_CLS("InHQ state: OnArmorLoaded with ArmorArchetype = " $ ArmorArchetype);
        InHQ_OnArmorLoaded(ArmorArchetype, ContentId, SubID);
    }

    function OnWeaponLoaded(Object WeaponArchetype)
    {
        super.OnWeaponLoaded(WeaponArchetype);
    }

    simulated function SetAppearance(const out TAppearance kAppearance, optional bool bRequestContent = true)
    {
        `LWCE_LOG_DEPRECATED_CLS(SetAppearance);
    }

    simulated function SetInventory(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance)
    {
        `LWCE_LOG_DEPRECATED_CLS(SetInventory);
    }
}

state CharacterCustomization
{
    simulated event BeginState(name PreviousStateName)
    {
        `LWCE_LOG_CLS("CharacterCustomization BeginState: prev = " $ PreviousStateName);
        super.BeginState(PreviousStateName);
    }

    simulated event EndState(name NextStateName)
    {
        `LWCE_LOG_CLS("CharacterCustomization EndState: next = " $ NextStateName);
        super.EndState(NextStateName);
    }

    simulated function Tick(float dt)
    {
        super.Tick(dt);
    }

    simulated function OnVoiceLoaded(Object VoiceArchetype)
    {
        `LWCE_LOG_CLS("Loaded voice archetype " $ VoiceArchetype);
        super.OnVoiceLoaded(VoiceArchetype);
    }

    simulated function RotateInPlace(int Dir)
    {
        super.RotateInPlace(Dir);
    }

    function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID)
    {
        InHQ_OnArmorLoaded(ArmorArchetype, ContentId, SubID);
    }

    function OnWeaponLoaded(Object WeaponArchetype)
    {
        super.OnWeaponLoaded(WeaponArchetype);
    }
}

`GENERATE_SORT(SortArmorKitTemplates,   LWCEArmorKitContentTemplate,   arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortHairTemplates,       LWCEHairContentTemplate,       arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortHeadTemplates,       LWCEHeadContentTemplate,       arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortRaceTemplates,       LWCERaceTemplate,              arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortVoiceTemplates,      LWCEVoiceContentTemplate,      arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortArmorColorTemplates, LWCEArmorColorContentTemplate, arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortHairColorTemplates,  LWCEHairColorContentTemplate,  arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
`GENERATE_SORT(SortSkinColorTemplates,  LWCESkinColorContentTemplate,  arrElements[Index].DisplayName > arrElements[Index + 1].DisplayName)
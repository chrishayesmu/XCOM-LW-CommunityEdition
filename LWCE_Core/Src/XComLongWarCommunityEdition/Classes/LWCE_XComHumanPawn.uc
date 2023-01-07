class LWCE_XComHumanPawn extends XComHumanPawn;

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

var private array<LWCE_PawnContentRequest> m_arrCEPawnContentRequests;

var private array<LWCEHairContentTemplate> m_arrCEHairs;
var private array<LWCEHeadContentTemplate> m_arrCEHeads;
var private array<LWCEVoiceContentTemplate> m_arrCEVoices;

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
    local name nmPrimaryWeapon;
    local LWCE_PawnContentRequest kRequest;
    local LWCE_XGUnit GameUnit;
    local LWCE_TCharacter kChar;

    GameUnit = LWCE_XGUnit(GetGameUnit());
    nmPrimaryWeapon = class'LWCE_XGTacticalGameCore'.static.LWCE_GetPrimaryWeapon(kChar.kInventory);
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
    local XComHairPackageInfo kHairInfo;

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

        if (m_kCEAppearance.nmBody != '')
        {
            `LWCE_LOG_CLS("Getting body template " $ m_kCEAppearance.nmBody);
            ContentTemplate = kTemplateMgr.FindBodyTemplate(m_kCEAppearance.nmBody);

            kRequest.ContentCategory = 'Body';
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

        if (!IsInStrategy())
        {
            AddKitRequests();
        }

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

    m_arrCEHairs.Length = 0;
    m_arrCEHeads.Length = 0;
    PossibleArmorKits.Length = 0;
    m_arrCEVoices.Length = 0;

    kTemplateMgr = `LWCE_CONTENT_TEMPLATE_MGR;

    m_arrCEHairs = kTemplateMgr.FindMatchingHair(EGender(m_kCEAppearance.iGender), /* bCivilianOnly */ false, /* bAllowHelmets */ true);
    m_arrCEHeads = kTemplateMgr.FindMatchingHeads(ECharacter(m_kCEChar.iCharacterType), m_kCEAppearance.nmRace, EGender(m_kCEAppearance.iGender));
    m_arrCEVoices = kTemplateMgr.FindMatchingVoices(EGender(m_kCEAppearance.iGender), m_kCEAppearance.nmLanguage, inCharacter.bIsAugmented);

    // Armor kit -1 represents the default armor kit, which changes based on armor + weapon combo
    // TODO replace
    PossibleArmorKits.AddItem(-1);

    if (inCharacter.bIsAugmented && inCharacter.kInventory.nmArmor != 'Item_BaseAugments')
    {
        // TODO modify these?
        PossibleArmorKits.AddItem(0);
        PossibleArmorKits.AddItem(1);
        PossibleArmorKits.AddItem(2);
    }
    else
    {
        `LWCE_CONTENT_MGR.GetPossibleArmorKits(inCharacter.kInventory.nmArmor, PossibleArmorKits);
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
    local XComUnitPackageInfo UnitInfo;

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

    ParamColor = ColorToLinearColor(m_kCEAppearance.ArmorTintPrimary);
    MIC.GetVectorParameterValue('CMOD', ParamColor);

    ParamColor = ColorToLinearColor(m_kCEAppearance.ArmorTintSecondary);
    MIC.GetVectorParameterValue('CMODB', ParamColor);
}

simulated function UpdateSkinMaterial(MaterialInstanceConstant MIC, bool bHasHair)
{
    local LinearColor ParamColor;
    local FacialHairPreset FacialHair;

    ParamColor = ColorToLinearColor(m_kCEAppearance.SkinColor);
    MIC.SetVectorParameterValue('SkinColor', ParamColor);

    ParamColor = ColorToLinearColor(m_kCEAppearance.HairColor);
    MIC.SetVectorParameterValue('HairColor', ParamColor);

    // TODO: add facial hair to m_kCEAppearance and rewrite this
    if (m_kAppearance.iGender == eGender_Male && bHasHair && m_kAppearance.iFacialHair != -1)
    {
        FacialHair = `CONTENTMGR.FacialHairPresets[m_kAppearance.iFacialHair];
        MIC.SetScalarParameterValue('UVOffset', FacialHair.U);
        MIC.SetVectorParameterValue('ChannelMask', FacialHair.Mask);
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

/*
defaultproperties
{
    CollisionComponent=none
	CylinderComponent=none
	LightEnvironment=none
	Mesh=none
	RangeIndicator=none
	MindMergeFX_Send=none
	MindMergeFX_Receive=none
	MindFrayFX_Receive=none
	MindControlFX_Receive=none
	MindControlFX_Send=none
	PsiPanicFX_Receive=none
	PsiInspiredFX_Receive=none
	DisablingShot_Receive=none
	StunShot_Receive=none
	TracerBeamedFX=none
	PoisonedByChryssalidFX=none
	PoisonedByThinmanFX=none
	ElectropulsedFX=none
	Components(0)=none
	Components(1)=none
	Components(2)=none
	Components(3)=none
	Components(4)=none
	Components(5)=none
	Components(6)=none
	Components(7)=none
	Components(8)=none
	Components(9)=none
	Components(10)=none
	Components(11)=none
	Components(12)=none
	Components(13)=none
	Components(14)=none
	Components(15)=none
}
 */
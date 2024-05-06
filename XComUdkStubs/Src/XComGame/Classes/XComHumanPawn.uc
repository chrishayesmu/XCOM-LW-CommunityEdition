class XComHumanPawn extends XComUnitPawn
    dependson(XGLoadoutMgr)
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

const HELMET_HAIR_STANDIN_MALE = 18;
const HELMET_HAIR_STANDIN_FEMALE = 2;

enum ECCPawnAnim
{
    ePawnAnim_Idle,
    ePawnAnim_LookAtEquippedWeapon,
    ePawnAnim_LookAtArmor,
    ePawnAnim_CloseUpIdle,
    ePawnAnim_MAX
};

struct PawnContentRequest
{
    var EContentCategory eCategory;
    var int iID;
    var int iSubID;
    var Object kContent;

    structdefaultproperties
    {
        iSubID=-1
    }
};

struct ItemAttachment
{
    var EItemType ItemType;
    var name SocketName;
    var export editinline MeshComponent Component;
    var Actor ItemActor;
};

var(XComUnitPawn) AnimSet JetPackAnimSet;
var(XComUnitPawn) bool AllowHelmets;
var bool bNeedsFallbackHair;
var privatewrite transient bool bShouldSpeak;
var private bool m_bSetReadyForViewing;
var bool bSkipGenderBlender;
var private bool m_bHasGeneMods;
var private bool m_bSetArmorKit;
var private bool m_bSetAppearance;
var protectedwrite TAppearance m_kAppearance;
var private repnotify TAppearance Replicated_kAppearance;
var transient array<XComPawnPhysicsProp> m_aPhysicsProps;
var protectedwrite transient AnimTree HQAnimTree;
var privatewrite XComHeadContent HeadContent;
var privatewrite XComBodyContent BodyContent;
var privatewrite XComHairContent HairContent;
var privatewrite XComCharacterVoice Voice;
var privatewrite XComLinearColorPaletteEntry BaseArmorTint;
var const array<AnimSet> RequiredAnimSets;
var int m_arrMedals[EMedalType];
var export editinline array<export editinline SkeletalMeshComponent> MedalMeshComps;
var private EItemType PrimaryWeapon;
var private EPawnType PawnType;
var private TLoadout Loadout;
var private int m_iArmor;
var protected string FemHQMesh;
var protected string MaleHQMesh;
var protected string FemHQMesh_GM;
var protected string MaleHQMesh_GM;
var private array<PawnContentRequest> PawnContentRequests;
var private int NumPawnContentRequestsRemaining;
var private int m_iRequestKit;
var private PawnContentRequest m_kVoiceRequest;
var transient array<ItemAttachment> ActiveAttachments;
var transient int NumPossibleArmorSkins;
var transient array<int> PossibleHeads;
var transient array<int> PossibleHairs;
var transient array<ECharacterVoice> PossibleVoices;
var transient int NumPossibleHairColors;
var transient int NumPossibleSkinColors;
var transient int NumPossibleArmorTints;
var transient array<int> PossibleArmorKits;
var transient TCharacter Character;
var transient AnimNodeAdditiveBlending GenderBlender;

defaultproperties
{
    AllowHelmets=true

    RequiredAnimSets(0)=AnimSet'CHH_SoldierMale_ANIMSET.Anims.AS_Utility'
    RequiredAnimSets(1)=AnimSet'CHH_CaucMale.Anims.AS_CaucMale'
    FemHQMesh="CHH_SoldierBaseFem_ANIMSET.Meshes.SM_SoldierBaseFem"
    MaleHQMesh="CHH_SoldierBaseMale_ANIMSET.Meshes.SM_SoldierBaseMale"
    FemHQMesh_GM="GeneModTrooper_MOD.Meshes.SM_GeneModTrooperFem"
    MaleHQMesh_GM="GeneModTrooper_MOD.Meshes.SM_GeneModTrooperMale"

    m_iRequestKit=-1

    begin object name=MyLightEnvironment
        bCastShadows=true
        BoundsMethod=EDynamicLightEnvironmentBoundsMethod.DLEB_ManualOverride
        OverriddenBounds=(BoxExtent=(X=75.0,Y=75.0,Z=75.0),SphereRadius=75.0)
    end object

    LightEnvironment=MyLightEnvironment

    begin object name=Head class=SkeletalMeshComponent
        bAcceptsDynamicDecals=true
        CollideActors=true
        BlockZeroExtent=true
    end object

    m_kHeadMeshComponent=Head

    begin object name=SkeletalMeshComponent
        LightEnvironment=MyLightEnvironment
    end object

    Mesh=SkeletalMeshComponent

    Components(0)=none
    Components(1)=none
    Components(2)=MyLightEnvironment
    Components(3)=SkeletalMeshComponent
    Components(4)=UnitCollisionCylinder
    Components(5)=RangeIndicatorMeshComponent
    Components(6)=MindMergeFX_Send0
    Components(7)=MindMergeFX_Receive0
    Components(8)=PsiPanicFX_Receive0
    Components(9)=MindFrayFX_Receive0
    Components(10)=MindControlFX_Send0
    Components(11)=MindControlFX_Receive0
    Components(12)=PsiInspiredFX_Receive0
    Components(13)=DisablingShot_Receive0
    Components(14)=StunShot_Receive0
    Components(15)=Head
}
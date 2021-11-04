class XComHumanPawn extends XComUnitPawn
	dependson(XGLoadoutMgr);
//complete  stub

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
var transient bool bShouldSpeak;
var bool m_bSetReadyForViewing;
var bool bSkipGenderBlender;
var bool m_bHasGeneMods;
var bool m_bSetArmorKit;
var bool m_bSetAppearance;
var TAppearance m_kAppearance;
var repnotify TAppearance Replicated_kAppearance;
var transient array<XComPawnPhysicsProp> m_aPhysicsProps;
var transient AnimTree HQAnimTree;
var XComHeadContent HeadContent;
var XComBodyContent BodyContent;
var XComHairContent HairContent;
var XComCharacterVoice Voice;
var XComLinearColorPaletteEntry BaseArmorTint;
var const array<AnimSet> RequiredAnimSets;
var int m_arrMedals[EMedalType];
var export editinline array<export editinline SkeletalMeshComponent> MedalMeshComps;
var EItemType PrimaryWeapon;
var EPawnType PawnType;
var TLoadout Loadout;
var int m_iArmor;
var string FemHQMesh;
var string MaleHQMesh;
var string FemHQMesh_GM;
var string MaleHQMesh_GM;
var array<PawnContentRequest> PawnContentRequests;
var int NumPawnContentRequestsRemaining;
var int m_iRequestKit;
var PawnContentRequest m_kVoiceRequest;
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

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        Replicated_kAppearance;
}

simulated event ReplicatedEvent(name VarName){}
simulated event PostBeginPlay(){}
simulated function SetXRayModTech(EGeneModTech eTech);
simulated event Destroyed(){}
simulated function RequestFullPawnContent(){}
simulated function MakeAllContentRequests(){}
simulated function AddKitRequests(){}
simulated function OnFullPawnContentLoaded(Object PawnContent, int ContentId, int SubID){}
simulated function PawnContentFullyLoaded(){}
simulated function bool SetHeadByTag(string strTag){}
simulated event bool RestoreAnimSetsToDefault(){}
simulated event FinishAnimControl(InterpGroup InInterpGroup){}
simulated function AddRequiredAnimSets(){}
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){}
simulated function UpdateAllMeshMaterials(){}
simulated function UpdateHairMaterial(MaterialInstanceConstant MIC){}
simulated function UpdateSkinMaterial(MaterialInstanceConstant MIC, bool bHasHair){}
simulated function UpdateArmorMaterial(MeshComponent MeshComp, MaterialInstanceConstant MIC){}
simulated function UpdateMECMaterial(MeshComponent MeshComp, MaterialInstanceConstant MIC){}
simulated function UpdateFlagMaterial(MaterialInstanceConstant MIC){}
simulated function UpdateCivilianBodyMaterial(MaterialInstanceConstant MIC);
simulated function UpdateMeshMaterials(MeshComponent MeshComp){}
simulated function SetHeadAnim(AnimNodeBlendList HeadNode, name AnimName){}
simulated function SetHead(int HeadId){}
simulated function SetHair(int HairId){}
simulated function SetHairColor(int ColorIdx){}
simulated function SetSkinColor(int ColorIdx){}
simulated function SetArmorDeco(int DecoIdx){}
simulated function SetArmorTint(int TintIdx){}
simulated function bool IsFemale(){}
simulated function bool IsMale(){}
simulated function SetFacialHair(int PresetIdx){}
simulated function SetVoice(ECharacterVoice NewVoice){}
simulated function SetVoiceSilently(ECharacterVoice NewVoice){}
simulated function SetLanguage(ECharacterLanguage NewLanguage){}
simulated function AttachKit(){}
simulated function RemoveProps(){}
simulated function RemoveProp(MeshComponent PropComponent){}
simulated function RemoveAttachments(){}
simulated function SetAppearanceHead(int iHead){}
simulated function GetSeamlessTravelActorList(bool bToTransitionMap, out array<Actor> ActorList){}
simulated function SetupForMatinee(optional Actor MatineeBase, optional bool bDisableFootIK, optional bool bDisableGenderBlender){}
simulated function ReturnFromMatinee(){}
simulated function FreezeHair(){}
simulated function WakeHair(){}
simulated function PrepForMatinee(){}
simulated function RemoveFromMatinee();
simulated function OnHeadLoaded(Object HeadArchetype){}
simulated function OnBodyLoaded(Object BodyArchetype){}
simulated function OnHairLoaded(Object HairArchetype){}
simulated function RemoveHair(){}
simulated function OnArmorKitLoaded(Object KitArchetype){}
simulated function AttachAuxMesh(SkeletalMesh SkelMesh, out SkeletalMeshComponent SkelMeshComp){}
simulated function DetachAuxMesh(out SkeletalMeshComponent SkelMeshComp){}
simulated function OnVoiceLoaded(Object VoiceArchetype){}
simulated function SetAppearance(const out TAppearance kAppearance, optional bool bRequestContent=true){}
function Init(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance);
simulated function SetRace(ECharacterRace Race);
simulated function SetInventory(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance);
simulated function RotateInPlace(int Dir);
simulated function RequestKitPostArmor();
reliable client simulated function UnitSpeak(ECharacterSpeech Event){}
simulated function bool HasSoldierHead(name kSoldierHeadName){}
simulated event OutsideWorldBounds();
simulated event FellOutOfWorld(class<DamageType> dmgType);
simulated function SetMedals(int Medals[EMedalType]){}
simulated function bool IsPawnReadyForViewing(){}
simulated function ReadyForViewing(){}
simulated function InitLeftHandIK(){}
function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID);
simulated function bool AreHelmetsAllowed(){}
simulated function bool IsUnitFullyComposed(optional bool bBoostTextures=true){}

state InHQ
{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function Tick(float dt){}
    simulated function array<int> GetAllPossiblePerkContent(){}
    simulated function RemoveFromMatinee(){}
    function name GetSocketNameFromLocation(ELocation Loc){}
    function FindPossibleCustomParts(const out TCharacter inCharacter){}
    function Init(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance){}
    simulated function SetAppearance(const out TAppearance Appearance, optional bool bRequestContent=true){}
    simulated function SetRace(ECharacterRace Race){}
    simulated function SetInventory(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance){}
    simulated function AddKitRequests(){}
    simulated function OnHeadLoaded(Object HeadArchetype){}
    simulated function OnHairLoaded(Object HairArchetype){}
    function SkeletalMesh GetBodyMesh(XComHumanPawn PawnArchetype){}
    function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID){}
    simulated function RequestKitPostArmor(){}
    function OnWeaponLoaded(Object WeaponArchetype){}
    simulated function OnArmorKitLoaded(Object KitArchetype){}
    function SetLightingChannelsForUnit(){}
    simulated function SkeletalMeshComponent GetPrimaryWeaponMeshComponent(){}
    simulated function name GetLeftHandIKSocketName(){}
}

state CharacterCustomization extends InHQ
{
    simulated event BeginState(name PreviousStateName){}
    simulated function OnVoiceLoaded(Object VoiceArchetype){}
    simulated function RotateInPlace(int Dir){}
}

state CovertOpsCustomization extends InHQ
{
    simulated function OnArmorKitLoaded(Object KitArchetype);
    simulated event BeginState(name PreviousStateName){}
    simulated function OnVoiceLoaded(Object VoiceArchetype){}
    function SkeletalMesh GetBodyMesh(XComHumanPawn PawnArchetype){}
    simulated function SetInventory(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance){}
    function name GetSocketNameFromLocation(XGInventoryNativeBase.ELocation Loc){}
    simulated function bool AreHelmetsAllowed(){}
    simulated function RotateInPlace(int Dir){}
}

state GeneLabXRay extends InHQ
{
    simulated function OnArmorKitLoaded(Object KitArchetype);
    simulated function OnHeadLoaded(Object HeadArchetype){}
    simulated event BeginState(name PreviousStateName){}
    simulated function SetXRayModTech(EGeneModTech eTech){}
    function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID){}
    simulated function OnVoiceLoaded(Object VoiceArchetype){}
    function SkeletalMesh GetBodyMesh(XComHumanPawn PawnArchetype){}
    simulated function OnHairLoaded(Object HairArchetype){}
    simulated function OnWeaponLoaded(Object WeaponArchetype){}
    simulated function RotateInPlace(int Dir){}
}

state OffDuty extends InHQ
{
    simulated function OnArmorKitLoaded(Object KitArchetype);
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    function SkeletalMesh GetBodyMesh(XComHumanPawn PawnArchetype){}
    simulated function OnWeaponLoaded(Object WeaponArchetype){}
    simulated function OnHeadLoaded(Object HeadArchetype){}
    simulated function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID){}
    simulated function bool AreHelmetsAllowed(){}
}
state MedalCeremony extends InHQ
{
	simulated function AddKitRequests();

    simulated function PawnContentFullyLoaded(){}
    simulated function SetInventory(const out TCharacter inCharacter, const out TInventory Inv, const out TAppearance Appearance){}
    simulated function SkeletalMeshComponent GetPrimaryWeaponMeshComponent(){}
    simulated function SkeletalMesh GetBodyMesh(XComHumanPawn PawnArchetype){}
    simulated function array<SkeletalMesh> GetDressMedalMeshes(){}
    simulated function bool AreHelmetsAllowed(){}
}


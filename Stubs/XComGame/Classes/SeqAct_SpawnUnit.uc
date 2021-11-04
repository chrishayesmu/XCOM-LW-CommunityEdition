// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class SeqAct_SpawnUnit extends SequenceAction
    native(Level)
    forcescriptorder(true)
    hidecategories(Object)
	dependson(XGTacticalGameCoreNativeBase);

var() class<XGUnit> UnitClass;
var() ELoadoutTypes LoadoutType;
var() bool bFemale;
var XGPlayer HumanPlayer;
var int CurrentSpawnPoint;
var XGUnit SpawnedUnit;
var Pawn UnitPawn;

event Activated()
{
    GetHumanPlayer();
    CurrentSpawnPoint = 0;
}

private final function GetHumanPlayer()
{
    local XComTacticalGRI TACTICALGRI;
    local XGBattle_SP BATTLE;

    TACTICALGRI = XComTacticalGRI(XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI));
    BATTLE = XGBattle_SP(TACTICALGRI.m_kBattle);
    HumanPlayer = BATTLE.GetHumanPlayer();
}

event bool IsUnitSpawnPending()
{
    if(HumanPlayer == none)
    {
        GetHumanPlayer();
    }
    return (HumanPlayer == none) || HumanPlayer.IsSpawningUnit();
}

function bool IsVIP()
{
    return LoadoutType == 22;
}

event bool SpawnUnit(Object SpawnVar)
{
    local bool bSuccess;
    local XComSpawnPoint SpawnPt;
    local EGender eForceGender;

    SpawnPt = XComSpawnPoint(SpawnVar);
    if(SpawnPt != none)
    {
        if(bFemale)
        {
            eForceGender = 2;
        }
        else
        {
            eForceGender = 1;
        }
        SpawnPt.SnapToGround(32.0);
        HumanPlayer.SpawnUnitAt(UnitClass, LoadoutType, SpawnPt, eForceGender, SpawnComplete, IsVIP());
        bSuccess = true;
    }
    else
    {
        bSuccess = false;
    }
    return bSuccess;
}

function SpawnComplete(XGUnit Unit)
{
    local XComTacticalController kTacticalController;

    SpawnedUnit = Unit;
    UnitPawn = Unit.GetPawn();
    ++ CurrentSpawnPoint;
    foreach GetWorldInfo().AllControllers(class'XComTacticalController', kTacticalController)
    {
        XComPresentationLayer(kTacticalController.m_Pres).m_kUnitFlagManager.AddFlag(Unit);        
    }    
}

defaultproperties
{
    UnitClass=class'XGUnit'
    LoadoutType=eLoadout_Rifleman
    bCallHandler=false
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="SpawnPoint(s)")
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Spawned Unit",PropertyName=SpawnedUnit,bWriteable=true)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawn",PropertyName=UnitPawn,bWriteable=true)
    ObjName="Spawn Unit"
}

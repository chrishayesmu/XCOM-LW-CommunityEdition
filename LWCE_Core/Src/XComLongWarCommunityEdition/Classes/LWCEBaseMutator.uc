class LWCEBaseMutator extends Mutator;

// The purpose of this mutator is to enable the base game to broadcast events into LWCE, despite not
// being able to actually call any of LWCE's classes. The mutator receives the events, interprets them
// and locates the necessary objects, and translates them into calls to LWCE's modding framework.
//
// Since the goal of LWCE is to avoid mod authors having to use mutators, any custom mutate strings inserted
// for this purpose will not be passed beyond this class.

struct MutateArguments
{
    var string MutateString;
    var string SenderName;
    var array<string> AdditionalArgs;
};

function Mutate(string MutateString, PlayerController Sender)
{
    local MutateArguments tArgs;

    tArgs = ParseMutateString(MutateString);

    if (tArgs.MutateString == "XComUnitPawn.TakeDirectDamage")
    {
        Handle_XComUnitPawn_TakeDirectDamage(tArgs);
    }
    else if (tArgs.MutateString == "XComProjectile.CalculateUnitDamage")
    {
        Handle_XComProjectile_CalculateUnitDamage(tArgs);
    }
    else if (tArgs.MutateString == "XComProjectile.InitFX")
    {
        Handle_XComProjectile_InitFX(tArgs);
    }
    else if (tArgs.MutateString == "XComProjectile.InitProjectile")
    {
        Handle_XComProjectile_InitProjectile(tArgs);
    }
    else if (tArgs.MutateString == "XComWeapon.PrepareProjectile")
    {
        Handle_XComWeapon_PrepareProjectile(tArgs);
    }
    else if (tArgs.MutateString == "XGLoadoutMgr.ApplyInventory")
    {
        Handle_XGLoadoutMgr_ApplyInventory(tArgs);
    }
    else
    {
        // If this doesn't match any of our cases, then pass it on
        super.Mutate(MutateString, Sender);
    }
}

private function Actor FindActorByNameAndClass(string strName, class<Actor> kClass)
{
    local Actor kActor;

    foreach AllActors(kClass, kActor)
    {
        if (strName == string(kActor.Name))
        {
            return kActor;
        }
    }

    return none;
}

private function MutateArguments ParseMutateString(string MutateString)
{
    local int Index;
    local MutateArguments tArgs;
    local array<string> arrParts;

    ParseStringIntoArray(MutateString, arrParts, "|", /* bCullEmpty */ true);

    tArgs.MutateString = arrParts[0];

    if (arrParts.Length > 1)
    {
        tArgs.SenderName = arrParts[1];
    }

    for (Index = 2; Index < arrParts.Length; Index++)
    {
        tArgs.AdditionalArgs.AddItem(arrParts[Index]);
    }

    return tArgs;
}

private function Handle_XComProjectile_CalculateUnitDamage(const out MutateArguments tArgs)
{
    local XComProjectile kProjectile;

    kProjectile = XComProjectile(FindActorByNameAndClass(tArgs.SenderName, class'XComProjectile'));

    class'LWCE_XComProjectile_Extensions'.static.CalculateUnitDamage(kProjectile);
}

private function Handle_XComProjectile_InitFX(const out MutateArguments tArgs)
{
    local XComProjectile kProjectile;
    local bool bResetParticles, bHit;

    kProjectile = XComProjectile(FindActorByNameAndClass(tArgs.SenderName, class'XComProjectile'));
    bResetParticles = bool(tArgs.AdditionalArgs[0]);
    bHit = bool(tArgs.AdditionalArgs[1]);

    class'LWCE_XComProjectile_Extensions'.static.InitFX(kProjectile, bResetParticles, bHit);
}

private function Handle_XComProjectile_InitProjectile(const out MutateArguments tArgs)
{
    local XComProjectile kProjectile;
    local Vector Direction;
    local array<string> arrDirectionParts;

    kProjectile = XComProjectile(FindActorByNameAndClass(tArgs.SenderName, class'XComProjectile'));

    ParseStringIntoArray(tArgs.AdditionalArgs[0], arrDirectionParts, ",", /* bCullEmpty */ true);
    Direction.X = float(arrDirectionParts[0]);
    Direction.Y = float(arrDirectionParts[1]);
    Direction.Z = float(arrDirectionParts[2]);

    class'LWCE_XComProjectile_Extensions'.static.InitProjectile(kProjectile, Direction, bool(tArgs.AdditionalArgs[1]), bool(tArgs.AdditionalArgs[2]));
}

private function Handle_XComUnitPawn_TakeDirectDamage(const out MutateArguments tArgs)
{
    local DamageEvent Dmg, DmgBlank;
    local XComUnitPawn kPawn;

    kPawn = XComUnitPawn(FindActorByNameAndClass(tArgs.SenderName, class'XComUnitPawn'));

    // We're using this field to pass an argument from the original function; reset it before doing anything else
    Dmg = kPawn.DamageEvent_CauseOfDeath;
    kPawn.DamageEvent_CauseOfDeath = DmgBlank;

    class'LWCE_XComUnitPawn_Extensions'.static.TakeDirectDamage(kPawn, Dmg);
}

private function Handle_XComWeapon_PrepareProjectile(const out MutateArguments tArgs)
{
    local int TemplateIndex;
    local XComWeapon kWeapon;

    kWeapon = XComWeapon(FindActorByNameAndClass(tArgs.SenderName, class'XComWeapon'));
    TemplateIndex = int(tArgs.AdditionalArgs[0]);

    class'LWCE_XComWeapon_Extensions'.static.PrepareProjectile(kWeapon, TemplateIndex);
}

private function Handle_XGLoadoutMgr_ApplyInventory(const out MutateArguments tArgs)
{
    local XGUnit kUnit;

    `LWCE_LOG_CLS("Handle_XGLoadoutMgr_ApplyInventory begin");

    kUnit = XGUnit(FindActorByNameAndClass(tArgs.SenderName, class'XGUnit'));

    class'LWCE_XGLoadoutMgr'.static.ApplyInventory(kUnit);

    `LWCE_LOG_CLS("Handle_XGLoadoutMgr_ApplyInventory end");
}
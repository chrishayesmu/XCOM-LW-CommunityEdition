class LWCE_XComHeadquartersController extends XComHeadquartersController;

event PostLogin()
{
    `LWCE_LOG_CLS("(LWCE override)");
    super.PostLogin();
}

exec function MapSoldiersToDropshipSeats()
{
    local array<SequenceObject> Events;
    local array<XComUnitPawn> Units;
    local XComUnitPawn UnitPawn;
    local int SeqIdx, UnitIdx, MecIdx, SoldierIdx, ShivIdx;

    local SeqEvent_OnTacticalIntro TacticalIntro;
    local SkeletalMeshActor A, Dropship;

    WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_OnTacticalIntro', true, Events);

    foreach WorldInfo.AllActors(class'XComUnitPawn', UnitPawn)
    {
        Units.AddItem(UnitPawn);

        if (UnitPawn.IsA('XComHumanPawn'))
        {
            XComHumanPawn(UnitPawn).PrepForMatinee();
        }
    }

    Units.Sort(SortLoadingScreenSoldiers);

    foreach AllActors(class'SkeletalMeshActor', A)
    {
        if (A.Tag == 'CinematicDropship')
        {
            Dropship = A;
            break;
        }
    }

    UnitIdx = 0;
    MecIdx = 0;
    SoldierIdx = 0;
    ShivIdx = 0;

    for (SeqIdx = 0; SeqIdx < Events.Length; SeqIdx++)
    {
        TacticalIntro = SeqEvent_OnTacticalIntro(Events[SeqIdx]);

        if (TacticalIntro != none)
        {
            while (UnitIdx < Units.Length)
            {
                UnitPawn = Units[UnitIdx];
                UnitPawn.Mesh.bUpdateSkelWhenNotRendered = true;

                // LWCE: fix None access of Dropship
                if (Dropship != none)
                {
                    UnitPawn.SetBase(Dropship,, Dropship.SkeletalMeshComponent, 'Cabin');
                }

                UnitPawn.SetupForMatinee();

                class'XGBattle'.static.AddPawnToTacticalIntro(UnitPawn, TacticalIntro, UnitIdx, MecIdx, SoldierIdx, ShivIdx);
            }

            TacticalIntro.strMapName = WorldInfo.GetMapName();
            TacticalIntro.CheckActivate(self, self);
        }
    }
}

defaultproperties
{
    m_kPresentationLayerClass=class'LWCE_XComHQPresentationLayer'
    CheatClass=class'LWCE_XComHeadquartersCheatManager'
    InputClass=class'LWCE_XComHeadquartersInput'
}
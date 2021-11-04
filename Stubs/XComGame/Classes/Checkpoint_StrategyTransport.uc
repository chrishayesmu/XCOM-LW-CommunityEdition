class Checkpoint_StrategyTransport extends Checkpoint
    native(Core)
    config(Checkpoint);

defaultproperties
{
    ActorClassesToRecord(0)=class'StrategyGameTransport'
    ActorClassesToRecord(1)=class'XGBattleDesc'
    ActorClassesToRecord(2)=class'XGDropshipCargoInfo'
    ActorClassesToRecord(3)=class'UITutorialSaveData'
    ActorClassesToRecord(4)=class'XGNarrative'
    ActorClassesToRecord(5)=class'XGRecapSaveData'
    ActorClassesToRecord(6)=class'XGSetupPhaseManagerBase'
    ActorClassesToDestroy(0)=class'StrategyGameTransport'
    ActorClassesToDestroy(1)=class'XGBattleDesc'
    ActorClassesToDestroy(2)=class'XGDropshipCargoInfo'
    ActorClassesToDestroy(3)=class'UITutorialSaveData'
    ActorClassesToDestroy(4)=class'XGNarrative'
    ActorClassesToDestroy(5)=class'XGRecapSaveData'
}
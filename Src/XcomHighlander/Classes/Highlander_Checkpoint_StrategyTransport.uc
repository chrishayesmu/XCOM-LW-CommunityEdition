class Highlander_Checkpoint_StrategyTransport extends Checkpoint_StrategyTransport;

defaultproperties
{
    ActorClassesToRecord(0)=class'StrategyGameTransport'
    ActorClassesToRecord(1)=class'XGBattleDesc'
    ActorClassesToRecord(2)=class'XGDropshipCargoInfo'
    ActorClassesToRecord(3)=class'UITutorialSaveData'
    ActorClassesToRecord(4)=class'XGNarrative'
    ActorClassesToRecord(5)=class'XGRecapSaveData'
    ActorClassesToRecord(6)=class'HighlanderItemContainer'
    ActorClassesToRecord(7)=class'XGSetupPhaseManagerBase'
    ActorClassesToDestroy(0)=class'StrategyGameTransport'
    ActorClassesToDestroy(1)=class'XGBattleDesc'
    ActorClassesToDestroy(2)=class'XGDropshipCargoInfo'
    ActorClassesToDestroy(3)=class'UITutorialSaveData'
    ActorClassesToDestroy(4)=class'XGNarrative'
    ActorClassesToDestroy(5)=class'HighlanderItemContainer'
    ActorClassesToDestroy(6)=class'XGRecapSaveData'
}
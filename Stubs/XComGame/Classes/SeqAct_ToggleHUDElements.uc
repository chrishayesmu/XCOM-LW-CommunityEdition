class SeqAct_ToggleHUDElements extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);
//complete stub
enum eHUDElement
{
    eHUDElement_InfoBox,
    eHUDElement_Abilities,
    eHUDElement_WeaponContainer,
    eHUDElement_StatsContainer,
    eHUDElement_Radar,
    eHUDElement_Perks,
    eHUDElement_MouseControls,
    eHUDElement_MAX
};

var() array<eHUDElement> HudElements;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Hide")
    InputLinks(1)=(LinkDesc="UnHide")
    ObjName="Toggle HUD Elements"
}
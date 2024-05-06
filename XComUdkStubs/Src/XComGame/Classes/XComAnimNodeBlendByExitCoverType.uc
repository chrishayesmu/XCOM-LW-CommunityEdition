class XComAnimNodeBlendByExitCoverType extends XComAnimNodeBlendList
    hidecategories(Object);

enum EExitCoverTypeToUse
{
    eECTTU_Zero,
    eECTTU_Ninety,
    eECTTU_OneEighty,
    eECTTU_Ninety_Stay,
    eECTTU_UseTurnNode,
    eECTTU_MAX
};

defaultproperties
{
    Children(0)=(Name="ExitCover Zero")
    Children(1)=(Name="ExitCover Ninety")
    Children(2)=(Name="ExitCover OneEighty")
    Children(3)=(Name="ExitCover Ninety (STAY)")
}
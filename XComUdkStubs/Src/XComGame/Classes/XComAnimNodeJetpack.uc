class XComAnimNodeJetpack extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object);

enum EAnimJetpack
{
    eAnimJetpack_Closed,
    eAnimJetpack_Closing,
    eAnimJetpack_Open,
    eAnimJetpack_Opening,
    eAnimJetpack_MAX
};

defaultproperties
{
    bPlayActiveChild=true
    Children(0)=(Name="Closed")
    Children(1)=(Name="Closing")
    Children(2)=(Name="Open")
    Children(3)=(Name="Opening")
    NodeName=Jetpack
}
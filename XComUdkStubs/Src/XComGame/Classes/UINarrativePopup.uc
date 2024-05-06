class UINarrativePopup extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var UINarrativeMgr m_kNarrativeMgr;
var string m_sMouseNavigation;
var bool bIsModal;
var name DisplayTag;

defaultproperties
{
    m_sMouseNavigation="theMouseNavigation"
    bIsModal=true
    DisplayTag=DropshipScreen
    s_package="/ package/gfxNarrativePopup/NarrativePopup"
    s_screenId="gfxNarrativePopup"
    e_InputState=eInputState_Consume
    s_name="theNarrativePopup"
}
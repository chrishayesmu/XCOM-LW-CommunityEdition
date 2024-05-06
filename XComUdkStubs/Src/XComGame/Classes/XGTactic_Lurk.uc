class XGTactic_Lurk extends XGTactic
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGTactic_Lurk extends CheckpointRecord
{
    var Vector m_vLurkLoc;
    var EItemType m_eLurkDevice;
};

var Vector m_vLurkLoc;
var EItemType m_eLurkDevice;

defaultproperties
{
    m_strName="LURK"
}
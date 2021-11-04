class XGMemorialUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EMemorialView
{
    eMemorialView_Main,
    eMemorialView_MAX
};

struct TMemorialEntry
{
    var TText txtName;
    var TText txtKills;
    var TText txtMissions;
    var TText txtStatus;
    var TText txtLastOp;
    var TText txtDate;
    var TText txtCauseOfDeath;
    var string Medals;
};

var array<TMemorialEntry> m_arrFallen;

function Init(int iView){}
function UpdateView(){}
function UpdateFallen(){}
function TMemorialEntry BuildMemorial(XGStrategySoldier kFallen){}
function OnPressButton(){}
function OnLeaveFacility(){}

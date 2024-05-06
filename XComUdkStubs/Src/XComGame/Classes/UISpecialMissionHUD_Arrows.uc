class UISpecialMissionHUD_Arrows extends UI_FxsPanel
    dependson(XGTacticalScreenMgr)
    notplaceable
    hidecategories(Navigation);

struct T2DArrow
{
    var string Id;
    var Vector2D Loc;
    var float rotationDegrees;
    var EUIState arrowState;
    var int arrowCounter;

    structdefaultproperties
    {
        arrowState=eUIState_Warning
        arrowCounter=-1
    }
};

struct T3DArrowActor
{
    var Vector Offset;
    var Actor KActor;
    var EUIState arrowState;
    var int arrowCounter;

    structdefaultproperties
    {
        arrowState=eUIState_Warning
        arrowCounter=-1
    }
};

var protected array<T3DArrowActor> arr3DArrows;
var protected array<T2DArrow> arr2DArrows;

defaultproperties
{
    s_name="arrowContainer"
}
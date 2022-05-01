class XGMissionEntity extends XGEntity;

enum EMissionAnimation
{
    eMissionAnim_Appearing,
    eMissionAnim_Idle,
    eMissionAnim_MAX
};

function Vector2D GetCoords(){}
function XGMission GetMission(){}
function EMissionType GetMissionModel(){}
function EMissionAnimation GetAnim(){}

defaultproperties
{
}
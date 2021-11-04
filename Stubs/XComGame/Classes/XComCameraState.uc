class XComCameraState extends Object
    abstract;
//complete stub

var transient PlayerController PCOwner;
var transient WorldInfo WorldInfo;

protected function InitCameraState(PlayerController ForPlayer)
{
    PCOwner = ForPlayer;
    WorldInfo = ForPlayer.WorldInfo;
    //return;    
}

function GetView(float DeltaTime, out Vector out_Focus, out Rotator out_Rotation, out float out_ViewDistance, out float out_FOV)
{
    //return;    
}

function CameraActor GetCameraActor()
{
    return none;
    //return ReturnValue;    
}

function EndCameraState()
{
    //return;    
}
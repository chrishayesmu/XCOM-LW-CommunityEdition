interface IXComBuildingVisInterface extends Interface
    native;
function OnChangedIndoorStatus()
{
    //return;    
}

function OnChangedFloor()
{
    //return;    
}

function XComPawnIndoorOutdoorInfo GetIndoorOutdoorInfo()
{
    //return ReturnValue;    
}

function Actor GetActor()
{
    //return ReturnValue;    
}

event XComBuildingVolume GetCurrentBuildingVolumeIfInside()
{
    //return ReturnValue;    
}

event bool IsInside()
{
    //return ReturnValue;    
}

DefaultProperties
{
}

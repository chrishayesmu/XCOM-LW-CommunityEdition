class XCom3DCursorMouseForCursorVolumes extends XCom3DCursorForCursorVolumes
    config(Game)
    hidecategories(Navigation);
//complete  stub

simulated function CursorSearchResult CursorSnapToFloor(int iDesiredFloor, optional CursorSearchDirection eSearchType){}

state CursorMode_NoCollision
{
    function Reset(){}    
    function AscendFloor(){}
    function DescendFloor(){}
}
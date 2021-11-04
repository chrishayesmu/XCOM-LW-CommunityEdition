class XCom3DCursorMouse extends XCom3DCursor
    config(Game)
    hidecategories(Navigation);

simulated function CursorSearchResult CursorSnapToFloor(int iDesiredFloor, optional XCom3DCursor.CursorSearchDirection eSearchType){}

state CursorMode_NoCollision
{
    function AscendFloor(){}
    function DescendFloor(){}
}
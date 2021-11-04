class XGStrategyActor extends XGStrategyActorNativeBase
    abstract
    notplaceable
    config(GameData);

var XGEntity m_kEntity;

function SetEntity(XGEntity kEntity, XGStrategyActorNativeBase.EEntityGraphic eGraphic){}
function XGEntity GetEntity(){}
function HideEntity(bool bHide){}
function bool RectContainsVect(TRect kRect, Vector2D v2Loc){}
function float RectArea(TRect kRect){}
function TRect Rect(float fLeft, float fTop, float fRight, float fBottom){}
function float RectWidth(TRect kRect)
{
    return kRect.fRight - kRect.fLeft;
    //return ReturnValue;    
}

function float RectHeight(TRect kRect)
{
    return kRect.fBottom - kRect.fTop;
    //return ReturnValue;    
}

function Vector2D RectCenter(TRect kRect)
{
    return vect2d(kRect.fLeft + ((RectWidth(kRect)) / float(2)), kRect.fTop + ((RectHeight(kRect)) / float(2)));
    //return ReturnValue;    
}

function Vector2D RectClamp(Vector2D v2Point, TRect kRect)
{
    // End:0x76
    if(v2Point.X < kRect.fLeft)
    {
        v2Point.X = kRect.fLeft;
    }
    // End:0xEC
    if(v2Point.Y < kRect.fTop)
    {
        v2Point.Y = kRect.fTop;
    }
    // End:0x162
    if(v2Point.X > kRect.fRight)
    {
        v2Point.X = kRect.fRight;
    }
    // End:0x1D8
    if(v2Point.Y > kRect.fBottom)
    {
        v2Point.Y = kRect.fBottom;
    }
    return v2Point;
    //return ReturnValue;    
}

function float MilesToXMapCoords(int iMiles)
{
    return float(iMiles) * 0.00010;
    //return ReturnValue;    
}

function float MilesToYMapCoords(int iMiles)
{
    return float(iMiles) * 0.00020;
    //return ReturnValue;    
}

function int XMapCoordsToMiles(float fCoords)
{
    return int(fCoords * float(10000));
    //return ReturnValue;    
}

function int YMapCoordsToMiles(float fCoords)
{
    return int(fCoords * float(5000));
    //return ReturnValue;    
}

function Vector2D ConvertToMiles(Vector2D v2MapCoords)
{
    return vect2d(float(XMapCoordsToMiles(v2MapCoords.X)), float(YMapCoordsToMiles(v2MapCoords.Y)));
    //return ReturnValue;    
}

function int DistanceInMiles(Vector2D v2One, Vector2D v2Two)
{ 
}
function XGTacticalScreenMgr.EImage GetCharacterImage(XGGameData.ECharacter eChar){}
function TConfigWeapon GetConfigWeapon(int iWeapon){}
function TConfigArmor GetConfigArmor(int iArmor){}
static function string GetSoldierClassName(XGTacticalGameCoreData.ESoldierClass eClass, optional int iRank){}
function string GetMissionDiffString(XGStrategyActorNativeBase.EMissionDifficulty eDiff){}
function bool RewardIsValid(out TMissionReward kReward){}
function AddResource(XGStrategyActorNativeBase.EResourceType eResource, int iAmount, optional bool bRefund){}
function int GetResource(XGStrategyActorNativeBase.EResourceType eResource){}
function string RecordResourceTransaction(XGStrategyActorNativeBase.EResourceType ResourceType, int iAmount, bool bWasRefund){}
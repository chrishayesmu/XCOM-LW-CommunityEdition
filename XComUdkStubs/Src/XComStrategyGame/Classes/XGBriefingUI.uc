/*******************************************************************************
 * XGBriefingUI generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGBriefingUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EBriefingView
{
    eBriefingView_Main,
    eBriefingView_MAX
};

struct TMissionHeader
{
    var TText txtOpName;
    var TText txtLocation;
    var TText txtMissionType;
    var TText txtTime;
};

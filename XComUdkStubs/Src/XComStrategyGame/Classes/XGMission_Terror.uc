/*******************************************************************************
 * XGMission_Terror generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGMission_Terror extends XGMission
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGMission_Terror extends CheckpointRecord
{
    var int m_iRemainingCivilians;
};

var int m_iRemainingCivilians;
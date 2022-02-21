class LWCE_SeqAct_SpecialMissionHandler_Initialize extends SeqAct_SpecialMissionHandler_Initialize;

// This class is not injected into the game because it's only used natively. The code here is just for reference;
// it is compiled and the bytecode is patched into the base class.

event Activated()
{
    local string strClassName;
    local Class<XComSpecialMissionHandler> MissionHandlerClass;
    local XComSpecialMissionHandler MissionHandler;
    local WorldInfo MyWorldInfo;

    MyWorldInfo = GetWorldInfo();

    foreach MyWorldInfo.AllActors(class'XComSpecialMissionHandler', MissionHandler)
    {
        break;
    }

    if (MissionHandler == none)
    {
        switch (SpecialMissionHandlerType)
        {
            case eSpecialMissionExtraction:
                strClassName = "XComLongWarCommunityEdition.LWCE_XComSpecialMissionHandler_Extraction";
                break;
            case eSpecialMissionRescue:
                strClassName = "XComLongWarCommunityEdition.LWCE_XComSpecialMissionHandler_Rescue";
                break;
            case eSpecialMissionBomb:
                strClassName = "XComLongWarCommunityEdition.LWCE_XComSpecialMissionHandler_Bomb";
                break;
            case eSpecialMissionTempleship:
                strClassName = "XComLongWarCommunityEdition.LWCE_XComSpecialMissionHandler_Templeship";
                break;
            case eSpecialMissionChrysHive:
                strClassName = "XComLongWarCommunityEdition.LWCE_XComSpecialMissionHandler_ChrysHive";
                break;
            case eSpecialMissionHQAssault:
                strClassName = "XComLongWarCommunityEdition.LWCE_XComSpecialMissionHandler_HQAssault";
                break;
            case eSpecialMissionDataRecovery:
                strClassName = "XComLongWarCommunityEdition.LWCE_XComSpecialMissionHandler_DataRecovery";
                break;
        }

        MissionHandlerClass = Class<XComSpecialMissionHandler>(DynamicLoadObject(strClassName, class'Class'));
        MissionHandler = MyWorldInfo.Spawn(MissionHandlerClass);
    }

    if (!MissionHandler.bInitialized)
    {
        MissionHandler.Initialize();
    }
}
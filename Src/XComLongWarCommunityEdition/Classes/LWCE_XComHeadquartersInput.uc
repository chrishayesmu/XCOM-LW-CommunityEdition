class LWCE_XComHeadquartersInput extends XComHeadquartersInput;

function bool HandleClickedGlobeActor(XGStrategyActor kStrategyActor)
{
    local XGMissionControlUI kXGMissionControlUI;
    local XGMission kMission;
    local XGMissionEntity kMissionEntity;
    local XGShip_UFO kUFO;
    local XGGeoscape kGeoscape;
    local int iMissionIndex, iUFOindex;

    if (kStrategyActor == none)
    {
        return false;
    }

    kXGMissionControlUI = XGMissionControlUI(`HQPRES.GetMgr(class'LWCE_XGMissionControlUI', none, -1, true));

    if (kXGMissionControlUI == none)
    {
        return false;
    }

    if (!kXGMissionControlUI.CanActivateMission())
    {
        return false;
    }

    if (kXGMissionControlUI.HasActiveAlert())
    {
        return false;
    }

    kGeoscape = `HQGAME.GetGameCore().GetGeoscape();

    if (kGeoscape == none)
    {
        return false;
    }

    kMissionEntity = XGMissionEntity(kStrategyActor.m_kEntity);

    if (kMissionEntity != none)
    {
        kMission = kMissionEntity.GetMission();

        if (kMission == none)
        {
            return false;
        }

        switch (kMission.m_iMissionType)
        {
            case eMission_Abduction:
                iMissionIndex = kXGMissionControlUI.m_kAbductInfo.arrAbductions.Find(kMission);

                if (iMissionIndex >= 0)
                {
                    kXGMissionControlUI.OnAbductionOption(iMissionIndex);
                    kXGMissionControlUI.GoToView(eMCView_Abduction);
                }

                break;
            case eMission_Crash:
            case eMission_LandedUFO:
            case eMission_HQAssault:
            case eMission_AlienBase:
            case eMission_TerrorSite:
            case eMission_Final:
            case eMission_Special:
            case eMission_DLC:
            case eMission_ExaltRaid:
                iMissionIndex = kGeoscape.m_arrMissions.Find(kMission);

                if (iMissionIndex >= 0)
                {
                    kGeoscape.MissionAlert(iMissionIndex);
                }

                break;
            }
    }

    kUFO = XGShip_UFO(kStrategyActor);

    if (kUFO != none)
    {
        iUFOindex = kUFO.AI().m_arrUFOs.Find(kUFO);

        if (iUFOindex >= 0)
        {
            kXGMissionControlUI.ShowUFOInterceptAlert(iUFOindex);
        }
    }

    return true;
}

simulated function ProcessGeoscapeRotation()
{
    local XGMissionControlUI kXGMissionControlUI;
    local XComBaseCamera kCamera;
    local XComCamState_Earth kCameraState;
    local Rotator kRotationDelta;

    kXGMissionControlUI = XGMissionControlUI(`HQPRES.GetMgr(class'LWCE_XGMissionControlUI', none, -1, true));

    if (kXGMissionControlUI != none && kXGMissionControlUI.HasActiveAlert())
    {
        m_bMouseDraggingGeoscape = false;
        return;
    }

    kCamera = XComBaseCamera(Outer.PlayerCamera);

    if (kCamera == none)
    {
        return;
    }

    kCameraState = XComCamState_Earth(kCamera.CameraState);

    if (kCameraState == none)
    {
        return;
    }

    if (UseTouchInput() && XComHeadQuarterTouchHandler(mTouchHandler).mCurrentTouchNumber != 1)
    {
        return;
    }

    if (m_bMouseDraggingGeoscape)
    {
        if (UseTouchInput())
        {
            kRotationDelta.Yaw = int(-XComHeadQuarterTouchHandler(mTouchHandler).mGeographicRotationMultiplier * aBaseX);
            kRotationDelta.Pitch = int(-aBaseZ * XComHeadQuarterTouchHandler(mTouchHandler).mGeographicRotationMultiplier);
        }
        else
        {
            kRotationDelta.Yaw = int(aMouseX * float(80));
            kRotationDelta.Pitch = int(aMouseY * float(80));
        }
    }
    else
    {
        kRotationDelta.Yaw = int(aTurn * float(160));
        kRotationDelta.Pitch = int(aLookUp * float(160));
    }

    kCameraState.AddRotationDelta(kRotationDelta);
}
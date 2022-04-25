class LWCE_XGBuildUI extends XGBuildUI;

function OnChooseTile()
{
    if (m_kCursor.iCursorState == eBCS_CantDo)
    {
        PlayBadSound();
    }
    else if (m_kCursor.iCursorState == eBCS_BuildFacility)
    {
        if (ISCONTROLLED() && Game().SETUPMGR().GetStateName() == 'Base3_Engineering')
        {
            XComHeadquartersInput(`HQGAME.PlayerController.PlayerInput).m_bDisableCancel = false;
        }

        GoToView(eBuildView_Menu);
        PRES().CAMLookAtHQTile(m_kCursor.X, m_kCursor.Y, 1.0);
    }
    else if (m_kCursor.iCursorState == eBCS_BuildAccessLift)
    {
        PRES().UIManufactureFacility(eFacility_AccessLift, m_kCursor.X, m_kCursor.Y);
    }
    else if (m_kCursor.iCursorState == eBCS_Cancel)
    {
        ConfirmCancelConstructionDialogue();
    }
    else if (m_kCursor.iCursorState == eBCS_Excavate)
    {
        Base().m_arrTiles[Base().TileIndex(m_kCursor.X, m_kCursor.Y)].bExcavation = true;
        ENGINEERING().AddConstructionProject(m_kCursor.iCursorState, m_kCursor.X, m_kCursor.Y);
        UpdateView();
        Sound().PlaySFX(SNDLIB().SFX_UI_ExcavationStarted);
    }
    else if (m_kCursor.iCursorState == eBCS_RemoveFacility)
    {
        LWCE_ConfirmRemovalDialogue(m_kCursor.X, m_kCursor.Y);
    }
}

protected function LWCE_ConfirmRemovalDialogue(int X, int Y)
{
    local TDialogueBoxData kDialogData;
    local EFacilityType eFacility;
    local int iPower, iSatCap;

    eFacility = EFacilityType(Base().GetFacilityAt(X, Y));
    kDialogData.eType = eDialog_Normal;
    kDialogData.strTitle = m_strRemoveTitle;
    kDialogData.strText = m_strRemoveBody;
    kDialogData.strAccept = m_strRemoveOK;
    kDialogData.strCancel = m_strRemoveCancel;
    kDialogData.fnCallback = ConfirmRemovalDialogueCallback;

    m_bCantRemove = false;

    PlaySmallOpenSound();

    if (eFacility == eFacility_Power || eFacility == eFacility_ThermalPower || eFacility == eFacility_EleriumGenerator)
    {
        iPower = Facility(eFacility).iPower;
        iPower += (Base().GetSurroundingAdjacencies(X, Y, 1) * class'XGTacticalGameCore'.default.POWER_ADJACENCY_BONUS);

        if ( (HQ().GetPowerCapacity() - HQ().GetPowerUsed()) < iPower )
        {
            kDialogData.strText = m_strPowerCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (eFacility == eFacility_AlienContain)
    {
        if (LABS().IsInterrogationTech(`LWCE_LABS.LWCE_GetCurrentTech().iTechId))
        {
            kDialogData.strText = m_strCaptiveCantRemoveBody;
            m_bCantRemove = true;
        }
        else
        {
            kDialogData.strText = m_strCaptiveRemoveBody;
        }
    }
    else if (eFacility == eFacility_Workshop)
    {
        if (ITEMTREE().GetEngineersRequiredForNextUplink(eFacility_SmallRadar, true) > ENGINEERING().GetNumEngineersAvailable())
        {
            kDialogData.strText = m_strWorkshopCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (eFacility == eFacility_SmallRadar || eFacility == eFacility_LargeRadar)
    {
        if (eFacility == eFacility_SmallRadar)
        {
            iSatCap = class'XGTacticalGameCore'.default.UPLINK_CAPACITY;
        }
        else
        {
            if (eFacility == eFacility_LargeRadar)
            {
                iSatCap = class'XGTacticalGameCore'.default.NEXUS_CAPACITY;
            }
        }

        iSatCap += (Base().GetSurroundingAdjacencies(X, Y, eAdj_Satellites) * class'XGTacticalGameCore'.default.UPLINK_ADJACENCY_BONUS);

        if ( (HQ().GetSatelliteLimit() - HQ().m_arrSatellites.Length) < iSatCap )
        {
            kDialogData.strText = m_strUplinkCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (eFacility == eFacility_Foundry)
    {
        if (ENGINEERING().m_arrFoundryProjects.Length > 0)
        {
            kDialogData.strText = m_strFoundryCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (eFacility == eFacility_PsiLabs)
    {
        if (`LWCE_PSILABS.m_arrCETraining.Length > 0)
        {
            kDialogData.strText = m_strPsiLabsCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (eFacility == eFacility_GeneticsLab)
    {
        if (GENELABS().m_arrPatients.Length > 0)
        {
            kDialogData.strText = m_strGeneLabsCantRemoveBody;
            m_bCantRemove = true;
        }
    }
    else if (eFacility == eFacility_CyberneticsLab)
    {
        if (CYBERNETICSLAB().m_arrPatients.Length > 0)
        {
            kDialogData.strText = m_strCyberneticsLabsCantRemoveBody;
            m_bCantRemove = true;
        }
        else if (CYBERNETICSLAB().m_arrRepairingMecs.Length > 0)
        {
            kDialogData.strText = m_strCyberneticsLabsCantRemoveMecs;
            m_bCantRemove = true;
        }
    }

    if (m_bCantRemove)
    {
        kDialogData.eType = eDialog_Warning;
        kDialogData.strTitle = m_strCantRemoveTitle;
        kDialogData.strCancel = "";
        kDialogData.strAccept = m_strOK;
    }

    PRES().UIRaiseDialog(kDialogData);
    GetUIScreen().Show();
}
class LWCE_UISoldierCustomize extends UISoldierCustomize;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager)
{
    local XGCustomizeUI kMgr;

    BaseInit(_controllerRef, _manager);

    m_iView = 0;
    m_hWidgetHelper = Spawn(class'UIWidgetHelper', self);
    m_kSoldier = kSoldier;

    kMgr = Spawn(class'LWCE_XGCustomizeUI', XComHQPresentationLayer(controllerRef.m_Pres));
    kMgr.m_kInterface = self;

    XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(kMgr);
    kMgr.Init(m_iView);
    kMgr.SetActiveSoldier(m_kSoldier);

    m_kLocalMgr = kMgr;
    m_kSoldierHeader = Spawn(class'LWCE_UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.s_name = name("theStuff.soldierInfoMC");
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    foreach AllActors(class'SkeletalMeshActor', m_kCameraRig)
    {
        if (m_kCameraRig.Tag == 'UICameraRig_SoldierCustomize')
        {
            m_kCameraRigDefaultLocation = m_kCameraRig.Location;
            break;
        }
    }

    manager.LoadScreen(self);
}

simulated function XGCustomizeUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGCustomizeUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGCustomizeUI', self, m_iView));
    }

    return m_kLocalMgr;
}

simulated function XGSoldierUI GetSoldierUIMgr()
{
    return XGSoldierUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSoldierUI', none));
}

simulated function UpdateData()
{
    local XGCustomizeUI kMgr;
    local TMenuOption kOption;
    local UIWidget_Spinner kSpinner;
    local UIWidget_Button kButton;
    local int I, iWidgetIndex, iLength;
    local Vector kCameraOffset;

    kMgr = GetMgr();

    if (m_kSoldier.m_kPawn == none)
    {
        for (I = 0; I < m_hWidgetHelper.GetNumWidgets(); I++)
        {
            m_hWidgetHelper.ClearWidget(I);
        }

        return;
    }

    kMgr.UpdateMainMenu();
    iWidgetIndex = 0;
    iLength = kMgr.m_kMainMenuButtonOptions.mnuOptions.arrOptions.Length;

    for (I = 0; I < NUM_BUTTONS; I++)
    {
        if (m_hWidgetHelper.GetNumWidgets() <= iWidgetIndex)
        {
            kButton = m_hWidgetHelper.NewButton();
        }
        else
        {
            kButton = UIWidget_Button(m_hWidgetHelper.GetWidget(iWidgetIndex));
        }

        if (I < iLength)
        {
            m_hWidgetHelper.SetActive(iWidgetIndex, true);
            kOption = kMgr.m_kMainMenuButtonOptions.mnuOptions.arrOptions[I];
            kButton.strTitle = Caps(kOption.strText);
            kButton.__del_OnValueChanged__Delegate = OnMenuButtonClick;

            if (kOption.iState != eUIState_Normal)
            {
                m_hWidgetHelper.DisableButton(iWidgetIndex);
            }
        }
        else
        {
            kButton.strTitle = "";
            kButton.iValue = -1;
            m_hWidgetHelper.SetActive(iWidgetIndex, false);
        }

        iWidgetIndex++;
    }

    iLength = kMgr.m_kMainMenuSpinnerOptions.mnuOptions.arrOptions.Length;

    for (I = 0; I < NUM_SPINNERS; I++)
    {
        if (m_hWidgetHelper.GetNumWidgets() <= iWidgetIndex)
        {
            kSpinner = m_hWidgetHelper.NewSpinner();
        }
        else
        {
            kSpinner = UIWidget_Spinner(m_hWidgetHelper.GetWidget(iWidgetIndex));
        }

        if (I < iLength)
        {
            kOption = kMgr.m_kMainMenuSpinnerOptions.mnuOptions.arrOptions[I];

            if (kOption.iState == eUIState_Normal)
            {
                m_hWidgetHelper.SetActive(iWidgetIndex, true);
                kSpinner.strTitle = kOption.strText;

                if (iWidgetIndex == 3)
                {
                    kSpinner.StrValue = m_arrLanguages[GetMgr().GetLanguageIndex()];
                }
                else
                {
                    kSpinner.StrValue = kOption.strHelp;
                }

                kSpinner.__del_OnIncrease__Delegate = OnSpinnerIncrease;
                kSpinner.__del_OnDecrease__Delegate = OnSpinnerDecrease;
                kSpinner.bCanSpin = true;
            }
            else if (kOption.iState == 3)
            {
                m_hWidgetHelper.SetActive(iWidgetIndex, true);
                kSpinner.strTitle = kOption.strText;
                kSpinner.StrValue = kOption.strHelp;
                kSpinner.__del_OnIncrease__Delegate = OnSpinnerIncrease;
                kSpinner.__del_OnDecrease__Delegate = OnSpinnerDecrease;
                kSpinner.bCanSpin = false;
            }
            else
            {
                kSpinner.strTitle = "";
                kSpinner.StrValue = "";
                m_hWidgetHelper.SetActive(iWidgetIndex, false);
            }
        }
        else
        {
            kSpinner.strTitle = "";
            kSpinner.StrValue = "";
            m_hWidgetHelper.SetActive(iWidgetIndex, false);
        }

        iWidgetIndex++;
    }

    while (!m_hWidgetHelper.GetCurrentWidget().bIsActive)
    {
        m_hWidgetHelper.m_iCurrentWidget--;
        m_hWidgetHelper.RealizeSelected();
    }

    m_hWidgetHelper.RefreshAllWidgets();

    if (m_kSoldier.IsAugmented())
    {
        if (m_kSoldier.m_kChar.kInventory.iArmor != eItem_MecCivvies)
        {
            kCameraOffset  = TransformVectorByRotation(m_kCameraRig.Rotation, vect(1.0, 0.0, 0.0)) * m_kCameraRigMecDistanceOffset;
            kCameraOffset += TransformVectorByRotation(m_kCameraRig.Rotation, vect(0.0, 1.0, 0.0)) * m_kCameraRigMecHorizontalOffset;
            kCameraOffset += TransformVectorByRotation(m_kCameraRig.Rotation, vect(0.0, 0.0, 1.0)) * m_kCameraRigMecVerticalOffset;
        }
    }

    m_kCameraRig.SetLocation(m_kCameraRigDefaultLocation - kCameraOffset);
    `HQPRES.CAMLookAtNamedLocation(m_strCameraTag, 1.0);
}

event Destroyed()
{
    m_kLocalMgr = none;
    `HQPRES.RemoveMgr(class'LWCE_XGCustomizeUI');
    super.Destroyed();
}
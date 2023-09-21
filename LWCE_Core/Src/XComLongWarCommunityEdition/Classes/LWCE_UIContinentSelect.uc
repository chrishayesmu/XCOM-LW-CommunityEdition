class LWCE_UIContinentSelect extends UIContinentSelect
    dependson(LWCE_XGContinentUI);

var private int m_iSelectedOption;
var private int m_iMaxOptions;

simulated function XGContinentUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = LWCE_XGContinentUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGContinentUI', (self), m_iView));
    }

    return m_kLocalMgr;
}

simulated function OnInit()
{
    super.OnInit();

    m_iMaxOptions = LWCE_XGContinentUI(GetMgr()).m_arrStartingOptions.Length;
}

simulated function UpdateData()
{
    local LWCE_XGContinentUI kMgr;
    local UIChooseTech.UIOption kOption;
    local int I;

    kMgr = LWCE_XGContinentUI(GetMgr());

    AS_SetTitle(Caps(kMgr.m_strLabelBaseLocation));
    m_arrUIOptions.Length = 0;

    for (I = 0; I < kMgr.m_arrStartingOptions.Length; I++)
    {
        kOption.iIndex = I;
        kOption.strLabel = kMgr.m_arrStartingOptions[I].CountryFriendlyName;
        kOption.iState = eUIState_Normal;

        m_arrUIOptions.AddItem(kOption);
    }

    UpdateLayout();
}

simulated function bool OnAccept(optional string Str = "")
{
    if (GetMgr().OnChooseCont(m_iSelectedOption))
    {
        manager.RaiseInputGate();
    }

    return true;
}

simulated function bool OnMouseEvent(int Cmd, array<string> args)
{
    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_L_MOUSE_IN:
            if (args[args.Length - 1] == "theStartButton")
            {
            }
            else if (args[args.Length - 1] == "theBackButton")
            {
            }
            else
            {
            }

            break;
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
            if (args[args.Length - 1] == "theStartButton")
            {
                OnAccept();
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }
            else if (args[args.Length - 1] == "theBackButton")
            {
                PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
                OnCancel();
            }
            else
            {
                m_iSelectedOption = int(Split(args[args.Length - 1], "option", true));
                LWCE_RealizeSelected();
                PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            }

            break;
    }

    return true;
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    if (!CheckInputIsReleaseOrDirectionRepeat(Cmd, Arg))
    {
        return false;
    }

    switch (Cmd)
    {
        case class'UI_FxsInput'.const.FXS_DPAD_UP:
        case class'UI_FxsInput'.const.FXS_ARROW_UP:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_UP:
            m_iSelectedOption = ((m_iSelectedOption - 1) + m_iMaxOptions) % m_iMaxOptions;
            LWCE_RealizeSelected();
            PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
            break;
        case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
        case class'UI_FxsInput'.const.FXS_ARROW_DOWN:
        case class'UI_FxsInput'.const.FXS_VIRTUAL_LSTICK_DOWN:
            m_iSelectedOption = (m_iSelectedOption + 1) % m_iMaxOptions;
            LWCE_RealizeSelected();
            PlaySound(`SoundCue("SoundUI.MenuScrollCue"), true);
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
            PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
            OnAccept("");
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_CIRCLE:
        case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
            PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
            OnCancel("");
            break;
    }

    return true;
}

simulated function LWCE_RealizeSelected()
{
    local ASValue myValue;
    local array<ASValue> myArray;

    LWCE_UpdateInfoPanelData(m_iSelectedOption);

    myValue.Type = AS_Number;
    myValue.N = m_iSelectedOption;
    myArray.AddItem(myValue);

    Invoke("SetListSelection", myArray);
}

simulated function UpdateLayout()
{
    super.UpdateLayout();

    LWCE_RealizeSelected();
}

simulated function LWCE_UpdateInfoPanelData(int Index)
{
    local LWCE_XGContinentUI kMgr;
    local LWCE_TStartingOption kOption;
    local string ContinentName, BonusName, InfoText;

    kMgr = LWCE_XGContinentUI(GetMgr());
    kOption = kMgr.m_arrStartingOptions[Index];

    ContinentName = class'UIUtilities'.static.GetHTMLColoredText(kOption.CountryFriendlyName, eUIState_Highlight, 26);
    BonusName = kMgr.m_strLabelReturnToContinent $ kMgr.ConvertCashToString(kOption.CountryStartingCash * class'XGTacticalGameCore'.default.FundingBalance[kMgr.Game().GetDifficulty() + 4]);

    // Country + continent bonus names and description
    InfoText  = class'UIUtilities'.static.GetHTMLColoredText(kOption.StartingBonusFriendlyName $ ": ", eUIState_Warning, 22);
    InfoText $= class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(kOption.StartingBonusFriendlyDescription), eUIState_Highlight, 16);
    InfoText $= "\n\n";
    InfoText $= class'UIUtilities'.static.GetHTMLColoredText(kMgr.m_strLabelBonus, eUIState_Highlight, 26);
    InfoText $= "\n";
    InfoText $= class'UIUtilities'.static.GetHTMLColoredText(kOption.ContinentBonusFriendlyName $ ": ", eUIState_Warning, 22);
    InfoText $= class'UIUtilities'.static.GetHTMLColoredText(class'XComLocalizer'.static.ExpandString(kOption.ContinentBonusFriendlyDescription), eUIState_Highlight, 16);

    // TODO implement string formatting here
    AS_UpdateInfo(/* kOption.txtBonusLabel.StrValue */ ContinentName, /* kOption.txtBonusTitle.StrValue */ BonusName, InfoText);

    XComHQPresentationLayer(Owner).CAMLookAtEarth(kOption.CountryCoords, 1.0, 1.0);
}
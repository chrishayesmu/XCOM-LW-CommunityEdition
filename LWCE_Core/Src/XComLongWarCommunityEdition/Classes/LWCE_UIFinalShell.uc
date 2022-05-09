class LWCE_UIFinalShell extends UIFinalShell;

var const localized string m_strModSettings;

var int m_iModSettings;

simulated function SetText()
{
    local ASValue myValue;
    local array<ASValue> myArray;
    local int iCurrentSel;

    myValue.Type = AS_String;
    iCurrentSel = 0;

    myValue.S = m_sSinglePlayer;
    myArray.AddItem(myValue);
    m_iSP = iCurrentSel++;

    myValue.S = m_sMultiplayer;
    myArray.AddItem(myValue);
    m_iMP = iCurrentSel++;

    myValue.S = m_sLoad;
    myArray.AddItem(myValue);
    m_iLoad = iCurrentSel++;

    myValue.S = m_sOptions;
    myArray.AddItem(myValue);
    m_iOptions = iCurrentSel++;

    myValue.S = m_strModSettings;
    myArray.AddItem(myValue);
    m_iModSettings = iCurrentSel++;

    myValue.S = m_sExitToDesktop;
    myArray.AddItem(myValue);
    m_iExit = iCurrentSel++;

    m_iMaxSelection = myArray.Length;
    Invoke("SetDisplay", myArray);
}

simulated function AcceptMenu()
{
    if (m_bDisableActions)
    {
        return;
    }

    if (m_iCurrentSelection == m_iModSettings)
    {
        LWCE_XComShellPresentationLayer(Owner).LWCE_UIModSettings();
    }
    else
    {
        super.AcceptMenu();
    }
}
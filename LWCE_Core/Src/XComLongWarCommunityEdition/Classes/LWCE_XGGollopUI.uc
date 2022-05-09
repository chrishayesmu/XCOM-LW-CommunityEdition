class LWCE_XGGollopUI extends XGGollopUI;

function GollopWarningCallback(EUIAction eAction)
{
    if (eAction == eUIAction_Accept)
    {
        GoToView(eGollopView_Choose);
        PRES().UISoldierList(class'LWCE_UISoldierList_Gollop');
    }

    UpdateView();
}
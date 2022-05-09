class LWCE_UIMedals extends UIMedals;

simulated function GoToView(int iView)
{
    m_iView = iView;
    AS_SetDisplayMode(iView);

    switch (iView)
    {
        case eMedalsView_Main:
            UpdateCurrentMedals();
            break;
        case eMedalsView_EditMedal:
            UpdateEditMedals();
            break;
        case eMedalsView_AssignPower:
            UpdateAssignPower();
            break;
        case eMedalsView_SoldierList:
            `HQPRES.UISoldierList(class'LWCE_UISoldierList_AssignMedal');
            break;
        case eMedalsView_EditMedalName:
            RequestUserData();
            break;
    }
}
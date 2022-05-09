class LWCE_XGGeneLabUI extends XGGeneLabUI;

function OnChooseSlot(int iSlot)
{
    if (iSlot < GENELABS().m_arrPatients.Length)
    {
        PlayBadSound();
    }
    else
    {
        GoToView(eGeneLabView_Add);
        `HQPRES.UISoldierList(class'LWCE_UISoldierList_GeneLab');
        PlayGoodSound();
    }
}
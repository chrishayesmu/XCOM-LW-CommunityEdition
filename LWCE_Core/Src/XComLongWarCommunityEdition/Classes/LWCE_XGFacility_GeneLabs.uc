class LWCE_XGFacility_GeneLabs extends XGFacility_GeneLabs
    dependson(LWCETypes);

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iModTime, iEvent, iHours, iTotalHours;
    local LWCE_THQEvent kEvent;
    local bool bAdded;
    local array<int> arrEventTimes;
    local TGeneLabsPatient kPatient;

    foreach m_arrPatients(kPatient)
    {
        iTotalHours = 0;

        foreach kPatient.m_arrHoursLeft(iHours)
        {
            iTotalHours += iHours;
        }

        if (arrEventTimes.Find(iTotalHours) == INDEX_NONE)
        {
            arrEventTimes.AddItem(iTotalHours);
        }
    }

    for (iModTime = 0; iModTime < arrEventTimes.Length; iModTime++)
    {
        kEvent.EventType = 'GeneModification';
        kEvent.iHours = arrEventTimes[iModTime];

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }
}
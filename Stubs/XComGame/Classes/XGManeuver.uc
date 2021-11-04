class XGManeuver extends XGOvermindActor;
//complete  stub

struct CheckpointRecord
{
    var EManeuverType m_eManeuver;
    var bool m_bComplete;
    var bool m_bStarted;
    var bool m_bSuccess;
    var array<XGUnit> m_arrOnTask;
    var array<EManeuverStatus> m_arrStatus;
};
var EManeuverType m_eManeuver;
var bool m_bComplete;
var bool m_bStarted;
var bool m_bSuccess;
var array<XGUnit> m_arrOnTask;
var array<EManeuverStatus> m_arrStatus;

function Init(EManeuverType eManeuver)
{
    m_eManeuver = eManeuver;
}

function bool AddUnit(XGUnit kUnit)
{
    m_bStarted = true;
    if(kUnit.m_kBehavior != none)
    {
        kUnit.m_kBehavior.AddManeuver(self);
        if(m_arrOnTask.Find(kUnit) == -1)
        {
            m_arrOnTask.AddItem(kUnit);
            m_arrStatus.AddItem(0);
        }
        return true;
    }
    return false;
}

function RemoveOthers(XGUnit kUnit)
{
    local XGUnit kOther;

    if(m_arrOnTask.Find(kUnit) != -1)
    {
        foreach m_arrOnTask(kOther)
        {
            if(kOther != kUnit)
            {
                kOther.m_kBehavior.m_kManeuver = none;
            }            
        }        
        m_arrOnTask.Length = 0;
        m_arrOnTask.AddItem(kUnit);
    }
}

function OnUnitComplete(XGUnit kUnit, EManeuverStatus eStatus)
{
    local int iUnit;
    local bool bAllDone, bAllSuccess;

    bAllDone = true;
    if(IsImmediate())
    {
        Complete(eStatus == 1);
    }
    else
    {
        iUnit = 0;
        J0x42:
        if(iUnit < m_arrOnTask.Length)
        {
            if(m_arrOnTask[iUnit] == kUnit)
            {
                m_arrStatus[iUnit] = eStatus;
            }
            if(m_arrStatus[iUnit] == 0)
            {
                bAllDone = false;
            }
            if(m_arrStatus[iUnit] == 2)
            {
                bAllSuccess = false;
            }
            ++ iUnit;
            goto J0x42;
        }
        if(bAllDone)
        {
            Complete(bAllSuccess);
        }
    }
}

function Complete(bool bSuccess)
{
    m_bComplete = true;
    m_bSuccess = bSuccess;
}

function bool IsComplete()
{
    return m_bComplete;
}

function bool IsImmediate()
{
    return m_eManeuver >= 2;
}

function bool IsCallManeuver()
{
    return m_eManeuver >= 7;
}

function bool IsPodRevealManeuver()
{
    return (m_eManeuver >= 3) && m_eManeuver <= 6;
}

function MarkForReveal(bool bReveal);

function bool IsMarkedForReveal()
{
    return false;
}

function CheckAssignments()
{
    local XGUnit kUnit;
    local array<XGUnit> arrRemoveList;

    foreach m_arrOnTask(kUnit)
    {
        if(kUnit == none || kUnit.IsDead() || kUnit.IsPanicking() || kUnit.IsPanicked() || kUnit.m_bStunned)
        {
            arrRemoveList.AddItem(kUnit);
        }        
    }    
    foreach arrRemoveList(kUnit)
    {
        m_arrOnTask.RemoveItem(kUnit);        
    }    
    if(m_arrOnTask.Length == 0)
    {
        m_bComplete = true;
        m_bSuccess = false;
    }
}

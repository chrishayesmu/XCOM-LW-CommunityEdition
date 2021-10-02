class Highlander_XGBattle_SPCaptureAndHold extends Highlander_XGBattle_SPCovertOpsExtraction
    config(GameData);

var const config int m_iAllPointsSafeCashRewardAmount;
var array<XComCapturePointVolume> m_arrCapturePoints;

function InitPlayers(optional bool bLoading)
{
    local XComCapturePointVolume kCapturePoint;

    bLoading = false;
    super.InitPlayers(bLoading);

    foreach AllActors(class'XComCapturePointVolume', kCapturePoint)
    {
        m_arrCapturePoints.AddItem(kCapturePoint);
    }
}

function CollectLoot()
{
    local XComCapturePointVolume kCapturePoint;

    super.CollectLoot();
    m_kDesc.m_kDropShipCargoInfo.m_bAllPointsHeld = false;

    foreach m_arrCapturePoints(kCapturePoint)
    {
        if (kCapturePoint.m_iCaptureSequenceIndex == 0 && kCapturePoint.IsActive())
        {
            m_kDesc.m_kDropShipCargoInfo.m_kReward.iCredits += m_iAllPointsSafeCashRewardAmount;
            m_kDesc.m_kDropShipCargoInfo.m_bAllPointsHeld = true;
        }
    }
}

function bool ShouldAwardIntel()
{
    return m_iResult == 1;
}

function bool DoesCovertOperativeHaveToSurvive()
{
    return false;
}

function bool AreAllCapturePointsCaptured()
{
    local XComCapturePointVolume kCapturePoint;

    foreach m_arrCapturePoints(kCapturePoint)
    {
        if (!kCapturePoint.IsCaptured())
        {
            return false;
        }
    }

    return true;
}
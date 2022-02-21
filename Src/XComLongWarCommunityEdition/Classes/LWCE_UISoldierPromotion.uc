class LWCE_UISoldierPromotion extends UISoldierPromotion;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, bool _psiPromote, bool _mecPromote)
{
    local XGSoldierUI kMgr;
    local int iView;

    BaseInit(_controllerRef, _manager);
    m_bPsiPromotion = _psiPromote;
    m_bMECPromotion = _mecPromote;

    if (_mecPromote)
    {
        iView = 3;
    }
    else if (_psiPromote)
    {
        iView = 2;
    }
    else
    {
        iView = 1;
    }

    m_kSoldier = kSoldier;

    if (!XComHQPresentationLayer(controllerRef.m_Pres).IsMgrRegistered(class'LWCE_XGSoldierUI'))
    {
        kMgr = Spawn(class'LWCE_XGSoldierUI', XComHQPresentationLayer(controllerRef.m_Pres));
        kMgr.m_kInterface = self;
        kMgr.m_kSoldier = kSoldier;
        XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(kMgr);

        kMgr.Init(iView);
        m_kLocalMgr = kMgr;
    }

    m_kSoldierHeader = Spawn(class'UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    m_kSoldierStats = Spawn(class'UIStrategyComponent_SoldierStats', self);
    m_kSoldierStats.Init(GetMgr(), _controllerRef, _manager, self);

    m_kMecSoldierStats = Spawn(class'UISoldierPromotion_MecBonusAbility', self);
    m_kMecSoldierStats.Init(_controllerRef, _manager, self, m_kSoldier);

    foreach AllActors(class'SkeletalMeshActor', m_kCameraRig)
    {
        if (m_kCameraRig.Tag == 'UICameraRig_SoldierPromote')
        {
            m_kCameraRigDefaultLocation = m_kCameraRig.Location;
            break;
        }
    }

    manager.LoadScreen(self);
}

simulated function XGSoldierUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGSoldierUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGSoldierUI', (self), iStaringView));
    }

    return m_kLocalMgr;
}
class LWCE_XComTacticalHUD extends XComTacticalHUD;

function IMouseInteractionInterface GetMousePickActor()
{
    local XComLevelVolume kLevelVolume;
    local XCom3DCursor k3DCursor;
    local bool bSkipActor, bDebugTrace, bFirstInter;
    local IMouseInteractionInterface kInterface;
    local Actor kHitActor;
    local XComPawn kHitPawn;
    local Vector vHitLocation, vHitNormal;
    local bool bHitActorIsPathable, bIsInterActor;
    local int iHitFloor;
    local IMouseInteractionInterface kBestInterface;
    local bool bBestActorIsPathable;
    local int iBestFloor;
    local XGUnit kUnit;

    bDebugTrace = false;

    if (PlayerOwner.CheatManager != none && XComTacticalCheatManager(PlayerOwner.CheatManager) != none && XComTacticalCheatManager(PlayerOwner.CheatManager).bDebugMouseTrace)
    {
        bDebugTrace = true;
    }

    kLevelVolume = `BATTLE.m_kLevel != none ? `BATTLE.m_kLevel.LevelVolume : none;

    if (kLevelVolume == none)
    {
        return none;
    }

    k3DCursor = Get3DCursor();

    if (k3DCursor == none)
    {
        return none;
    }

    kBestInterface = none;
    m_InteractionInterface = none;
    mShootEnemyTrace = none;
    bFirstInter = true;
    iBestFloor = -1;

    foreach TraceActors(class'Actor', kHitActor, vHitLocation, vHitNormal, CachedMouseWorldOrigin + (CachedMouseWorldDirection * 165536.0), CachedMouseWorldOrigin, vect(0.0, 0.0, 0.0))
    {
        kInterface = IMouseInteractionInterface(kHitActor);

        if (bDebugTrace)
        {
            DrawDebugSphere(vHitLocation, 15.0, 12, 0, 0, 255, false);
        }

        if (EqualEqual_InterfaceInterface(kInterface, (none)))
        {
            continue;
        }

        if (kHitActor.IsA('UIDisplay_LevelActor') && UIDisplay_LevelActor(kBestInterface).m_kMovie == none)
        {
            continue;
        }

        if (XComInteractiveLevelActor(kHitActor) == none)
        {
            if (XComLevelActor(kHitActor) != none && XComLevelActor(kHitActor).bIgnoreFor3DCursorCollision)
            {
                continue;
            }

            if (XComFracLevelActor(kHitActor) != none && XComFracLevelActor(kHitActor).bIgnoreFor3DCursorCollision)
            {
                continue;
            }

            if (!kLevelVolume.ContainsPoint(vHitLocation))
            {
                continue;
            }

            bIsInterActor = kInterface.IsA('XComInteractiveLevelActor');

            if ((vect(0.0, 0.0, 1.0) Dot vHitNormal) < 0.20)
            {
                continue;
            }
        }

        kHitPawn = XComPawn(kInterface);

        if (kHitPawn == none)
        {
            kHitPawn = GetPawnInSameTile(vHitLocation);
        }

        if (kHitPawn != none)
        {
            kUnit = XGUnit(XComUnitPawnNativeBase(kHitPawn).GetGameUnit());

            // LWCE check: don't allow clicking on our visibility helpers
            if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
            {
                continue;
            }
        }

        if (kHitPawn != none)
        {
            kInterface = kHitPawn;
        }

        if (kHitPawn != none)
        {
            kUnit = XGUnit(XComUnitPawnNativeBase(kHitPawn).GetGameUnit());

            if (!kUnit.IsLocalPlayerUnit())
            {
                mShootEnemyTrace = kInterface;
            }
        }

        iHitFloor = k3DCursor.WorldZToCursorFloor(vHitLocation);
        bHitActorIsPathable = IsPositionInPathableTile(vHitLocation);

        if (bFirstInter && bIsInterActor)
        {
            m_InteractionInterface = kInterface;
            bFirstInter = false;
        }

        if (EqualEqual_InterfaceInterface(kBestInterface, none) && bHitActorIsPathable && IsPointOutdoors(vHitLocation))
        {
            CachedHitLocation = vHitLocation;
            kBestInterface = kInterface;
            break;
        }

        if (NotEqual_InterfaceInterface(kBestInterface, none))
        {
            bSkipActor = true;

            if (iBestFloor > k3DCursor.m_iRequestedFloor && iHitFloor < iBestFloor)
            {
                bSkipActor = false;
            }

            if (bSkipActor && iHitFloor == iBestFloor)
            {
                if (bHitActorIsPathable && !bBestActorIsPathable && XComPawn(kBestInterface) == none && XComInteractiveLevelActor(kBestInterface) == none)
                {
                    bSkipActor = false;
                }
                else if (kHitPawn != none && XComPawn(kBestInterface) == none && XComInteractiveLevelActor(kBestInterface) == none)
                {
                    bSkipActor = false;
                }
            }

            if (bSkipActor)
            {
                continue;
            }
        }

        CachedHitLocation = vHitLocation;
        kBestInterface = kInterface;
        bBestActorIsPathable = bHitActorIsPathable;
        iBestFloor = iHitFloor;

        if (bDebugTrace)
        {
            DrawDebugSphere(vHitLocation, 16.0, 12, 255, 0, 0, false);
        }
    }

    return kBestInterface;
}
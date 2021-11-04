interface XComCoverInterface extends Interface
native(Cover);
//complete  stub

enum ECoverForceFlag
{
    CoverForce_Default,
    CoverForce_High,
    CoverForce_Low,
    CoverForce_MAX
};

// Export UXComCoverInterface::execConsiderForOccupancy(FFrame&, void* const)
native simulated function bool ConsiderForOccupancy();

// Export UXComCoverInterface::execShouldIgnoreForCover(FFrame&, void* const)
native simulated function bool ShouldIgnoreForCover();

// Export UXComCoverInterface::execCanClimbOver(FFrame&, void* const)
native simulated function bool CanClimbOver();

// Export UXComCoverInterface::execCanClimbOnto(FFrame&, void* const)
native simulated function bool CanClimbOnto();

// Export UXComCoverInterface::execUseRigidBodyCollisionForCover(FFrame&, void* const)
native simulated function bool UseRigidBodyCollisionForCover();

// Export UXComCoverInterface::execGetCoverForceFlag(FFrame&, void* const)
native simulated function ECoverForceFlag GetCoverForceFlag();

// Export UXComCoverInterface::execGetCoverIgnoreFlag(FFrame&, void* const)
native simulated function ECoverForceFlag GetCoverIgnoreFlag();
DefaultProperties
{
}

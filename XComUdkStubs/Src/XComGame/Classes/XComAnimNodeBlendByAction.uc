class XComAnimNodeBlendByAction extends XComAnimNodeBlendList
    native(Animation)
    hidecategories(Object);

enum EAnimAction
{
    eAnimAction_Unequip,
    eAnimAction_Equip,
    eAnimAction_OpenDoor,
    eAnimAction_ClimbOverLowObstacle,
    eAnimAction_ClimbOntoLowObstacle,
    eAnimAction_EnterCover,
    eAnimAction_ExitCover,
    eAnimAction_SignalStop,
    eAnimAction_GetLoot,
    eAnimAction_Interact,
    eAnimAction_BecomePossessed,
    eAnimAction_HurtFront,
    eAnimAction_HurtBack,
    eAnimAction_Idle,
    eAnimAction_OpenDoorHighCover_Far,
    eAnimAction_OpenDoorLowCover_Far,
    eAnimAction_OpenDoorNoCover,
    eAnimAction_ClimbOffLowObstacle,
    eAnimAction_MindMergeSend,
    eAnimAction_MindMergeReceive,
    eAnimAction_MindMergeDeath,
    eAnimAction_ShieldDamageFront,
    eAnimAction_ShieldDamageBack,
    eAnimAction_FireGrapple,
    eAnimAction_Grapple,
    eAnimAction_GrappleClimbUp,
    eAnimAction_GrappleClimbUpLedge,
    eAnimaction_SuccessfulKill,
    eAnimaction_Berserk,
    eAnimaction_UnEquipNew,
    eAnimaction_EquipNew,
    eAnimAction_BreakWindow,
    eAnimAction_AscendBegin,
    eAnimAction_Ascend,
    eAnimAction_AscendEnd,
    eAnimAction_DescendBegin,
    eAnimAction_Descend,
    eAnimAction_DescendEnd,
    eAnimAction_PsiAttack,
    eAnimAction_UnEquipStationary,
    eAnimAction_EquipStationary,
    eAnimAction_DropdownHighStart,
    eAnimAction_ClimbOverDropdownHighStart,
    eAnimAction_DropdownHighStop,
    eAnimAction_DropdownMidStart,
    eAnimAction_ClimbOverDropdownMidStart,
    eAnimAction_DropdownMidStop,
    eAnimAction_OpenState,
    eAnimAction_ClosedIdle,
    eAnimAction_AdrenalineSurgeHurtFront,
    eAnimAction_PsiAttack2,
    eAnimAction_PsiBomb,
    eAnimAction_PsiDrain,
    eAnimAction_PsiBless,
    eAnimAction_PsiReflect,
    eAnimAction_ShotMulti,
    eAnimAction_PlagueAttack,
    eAnimAction_JumpUpStart,
    eAnimAction_JumpUpStop,
    eAnimAction_CloseState,
    eAnimAction_DeathBlossom,
    eAnimAction_PsiBolt,
    eAnimAction_PsiPanic,
    eAnimAction_PsiControl,
    eAnimAction_MindFray,
    eAnimAction_Rift,
    eAnimAction_PsiInspiration,
    eAnimAction_TelekineticField,
    eAnimAction_ZombieGetUp,
    eAnimAction_DisablingShot,
    eAnimAction_BullRushStart,
    eAnimAction_BloodCall,
    eAnimAction_Reload,
    eAnimAction_SwitchSidesLL2LR,
    eAnimAction_SwitchSidesHL2HR,
    eAnimAction_None,
    EAnimAction_MAX
};

defaultproperties
{
    Children(0)=(Name="Unequip Item")
    Children(1)=(Name="Equip Item")
    Children(2)=(Name="Open Door")
    Children(3)=(Name="Climb Over Low Obstacle")
    Children(4)=(Name="Climb Onto Low Obstacle")
    Children(5)=(Name="Enter Cover")
    Children(6)=(Name="Exit Cover")
    Children(7)=(Name="Signal Stop")
    Children(8)=(Name="Get Loot")
    Children(9)=(Name="Interact")
    Children(10)=(Name="Become Possessed")
    Children(11)=(Name="Hurt Front")
    Children(12)=(Name="Hurt Back")
    Children(13)=(Name="Idle")
    Children(14)=(Name="OpenDoorHighCover_Far")
    Children(15)=(Name="OpenDoorLowCover_Far")
    Children(16)=(Name="OpenDoorNoCover")
    Children(17)=(Name="Climb Off Low Obstacle")
    Children(18)=(Name="MindMerge Send")
    Children(19)=(Name="MindMerge Receive")
    Children(20)=(Name="MindMerge Death")
    Children(21)=(Name="Shield Damage from Front")
    Children(22)=(Name="Shield Damage from Back")
    Children(23)=(Name="Fire Grappling Hook")
    Children(24)=(Name="Grapple")
    Children(25)=(Name="Grapple Climb Up")
    Children(26)=(Name="Grapple Climb Up Ledge")
    Children(27)=(Name="SuccessfulKill")
    Children(28)=(Name="Berserk")
    Children(29)=(Name="UnEquip New Item")
    Children(30)=(Name="Equip New Item")
    Children(31)=(Name="Break Window")
    Children(32)=(Name="Ascend Begin")
    Children(33)=(Name="Ascend")
    Children(34)=(Name="Ascend End")
    Children(35)=(Name="Descend Begin")
    Children(36)=(Name="Descend")
    Children(37)=(Name="Descend End")
    Children(38)=(Name="Psi Attack")
    Children(39)=(Name="UnEquip Stationary")
    Children(40)=(Name="Equip Stationary")
    Children(41)=(Name="High Dropdown Start")
    Children(42)=(Name="High ClimbOverDropdown Start")
    Children(43)=(Name="High Dropdown Stop")
    Children(44)=(Name="Mid Dropdown Start")
    Children(45)=(Name="Mid ClimbOverDropdown Start")
    Children(46)=(Name="Mid Dropdown Stop")
    Children(47)=(Name="Open State (for cyberdisc)")
    Children(48)=(Name="Closed Idle (for cyberdisc)")
    Children(49)=(Name="Adrenaline Surge Hurt Front")
    Children(50)=(Name="Psi Attack 2")
    Children(51)=(Name="Psi Bomb")
    Children(52)=(Name="Psi Drain")
    Children(53)=(Name="Psi Bless")
    Children(54)=(Name="Psi Reflect")
    Children(55)=(Name="ShotMulti")
    Children(56)=(Name="Plague Attack")
    Children(57)=(Name="Jump Up Start")
    Children(58)=(Name="Jump Up Stop")
    Children(59)=(Name="Close State (for cyberdisc)")
    Children(60)=(Name="Death Blossom (for cyberdisc)")
    Children(61)=(Name="Psi Bolt")
    Children(62)=(Name="Psi Panic")
    Children(63)=(Name="Psi Control")
    Children(64)=(Name="Mind Fray")
    Children(65)=(Name="Rift")
    Children(66)=(Name="Psi Inspiration")
    Children(67)=(Name="Telekinetic Field")
    Children(68)=(Name="Zombie Get Up")
    Children(69)=(Name="Disabling Shot")
    Children(70)=(Name="BullRush Start")
    Children(71)=(Name="Bloodcall")
    Children(72)=(Name="Reload")
    Children(73)=(Name="SwitchSidesLL2LR")
    Children(74)=(Name="SwitchSidesHL2HR")
    bFixNumChildren=false
}
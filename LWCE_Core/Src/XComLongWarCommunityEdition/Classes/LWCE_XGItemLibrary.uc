class LWCE_XGItemLibrary extends Object
    abstract;

static simulated function class<XGItem> GetItem(int iItem)
{
    switch (iItem)
    {
        case `LW_ITEM_ID(Pistol):
            return class'XGWeapon_Pistol';
        case `LW_ITEM_ID(RecoillessRifle):
            return class'XGWeapon_RocketLauncher';
        case `LW_ITEM_ID(LaserPistol):
            return class'XGWeapon_LaserPistol';
        case `LW_ITEM_ID(ScatterBlaster):
        case `LW_ITEM_ID(ScatterLaser):
            return class'XGWeapon_LaserAssaultGun';
        case `LW_ITEM_ID(PlasmaPistol):
            return class'XGWeapon_PlasmaPistol';
        case `LW_ITEM_ID(BlasterLauncher):
            return class'XGWeapon_BlasterLauncher';
        case `LW_ITEM_ID(AlienCannon_Mechtoid):
            return class'XGWeapon_MechtoidPlasmaCannon';
        case `LW_ITEM_ID(AlienPistol_Seeker):
            return class'XGWeapon_SeekerPlasmaPistol';
        case `LW_ITEM_ID(KineticStrikeModule):
            return class'XGWeapon_MEC_KineticStrike';
        case `LW_ITEM_ID(Flamethrower):
            return class'XGWeapon_MEC_FlameThrower';
        case `LW_ITEM_ID(GrenadeLauncher):
            return class'XGWeapon_MEC_GrenadeLauncher';
        case `LW_ITEM_ID(RestorativeMist):
            return class'XGWeapon_MEC_RestorativeMist';
        case `LW_ITEM_ID(ElectroPulse):
            return class'XGWeapon_MEC_Electropulse';
        case `LW_ITEM_ID(ProximityMineLauncher):
            return class'XGWeapon_MEC_ProximityMine';
        case `LW_ITEM_ID(ParticleCannon):
            return class'XGWeapon_ParticleBeam';
        case `LW_ITEM_ID(AssaultCarbine):
            return class'XGWeapon_SectopodArm';
        case `LW_ITEM_ID(AlienTurret):
            return class'XGWeapon_SectopodCannon';
        case `LW_ITEM_ID(ChryssalidClaw):
            return class'XGWeapon_ChryssalidClaw';
        case `LW_ITEM_ID(DroneBeam):
            return class'XGWeapon_DroneBeam';
        case `LW_ITEM_ID(PsiAmp):
            return class'XGWeapon_PsiAmp';
        case `LW_ITEM_ID(Grapple):
            return class'XGWeapon_Grapple';
        case `LW_ITEM_ID(AlienCannon_Cyberdisc):
            return class'XGWeapon_Cyberdisc';
        case `LW_ITEM_ID(AlienPistol):
            return class'XGWeapon_PlasmaPistolSectoid';
        case `LW_ITEM_ID(AlienCarbine):
            return class'XGWeapon_PlasmaLightRifle_ThinMan';
        case `LW_ITEM_ID(AlienCarbine_Floater):
            return class'XGWeapon_PlasmaLightRifle_Floater';
        case `LW_ITEM_ID(AlienCarbine_Muton):
            return class'XGWeapon_PlasmaLightRifle_Muton';
        case `LW_ITEM_ID(AlienRifle):
            return class'XGWeapon_PlasmaAssaultRifle_Muton';
        case `LW_ITEM_ID(AlienRifle_Floater):
            return class'XGWeapon_HeavyPlasma_Floater';
        case `LW_ITEM_ID(AlienHeavyWeapon):
            return class'XGWeapon_HeavyPlasma_Muton';
        case `LW_ITEM_ID(ZombieFist):
            return class'XGWeapon_ZombieFist';
        case `LW_ITEM_ID(PsiLocus):
            return class'XGWeapon_EtherealWeapon';
        case `LW_ITEM_ID(MutonBlade):
            return class'XGWeapon_MutonBlade';
        case `LW_ITEM_ID(AlienCarbine_Outsider):
            return class'XGWeapon_OutsiderWeapon';
        case `LW_ITEM_ID(GaussCarbine):
            return class'XGWeapon_SoldierNoWeapon';
        case `LW_ITEM_ID(AcidSpit):
            return class'XGWeapon_Plague';
        case `LW_ITEM_ID(SectopodClusterBomb):
            return class'XGWeapon_SectopodClusterBomb';
        case `LW_ITEM_ID(SeekerTentacles):
            return class'XGWeapon_SeekerTentacles';
        case `LW_ITEM_ID(Medikit):
            return class'XGWeapon_Medikit';
        case `LW_ITEM_ID(CombatStims):
            return class'XGWeapon_CombatStims';
        case `LW_ITEM_ID(MindShield):
            return class'XGWeapon_MindShield';
        case `LW_ITEM_ID(ChitinPlating):
            return class'XGWeapon_ChitinPlating';
        case `LW_ITEM_ID(ArcThrower):
            return class'XGWeapon_ArcThrower';
        case `LW_ITEM_ID(SCOPE):
            return class'XGWeapon_TargetingModule';
        case `LW_ITEM_ID(RespiratorImplant):
            return class'XGWeapon_RespiratorImplant';
        case `LW_ITEM_ID(ReaperPack):
            return class'XGWeapon_ReaperRounds';
        case `LW_ITEM_ID(HEGrenade):
            return class'XGWeapon_FragGrenade';
        case `LW_ITEM_ID(SmokeGrenade):
            return class'XGWeapon_SmokeGrenade';
        case `LW_ITEM_ID(FlashbangGrenade):
            return class'XGWeapon_FlashBang';
        case `LW_ITEM_ID(AlienGrenade):
            return class'XGWeapon_AlienGrenade';
        case `LW_ITEM_ID(ShadowDevice):
            return class'XGWeapon_GhostGrenade';
        case `LW_ITEM_ID(ChemGrenade):
            return class'XGWeapon_GasGrenade';
        case `LW_ITEM_ID(APGrenade):
            return class'XGWeapon_NeedleGrenade';
        case `LW_ITEM_ID(MimicBeacon):
            return class'XGWeapon_MimicBeacon';
        case `LW_ITEM_ID(AlienGrenade_Floater):
            return class'XGWeapon_FloaterGrenade';
        case `LW_ITEM_ID(AlienGrenade_Muton):
            return class'XGWeapon_MutonGrenade';
        case `LW_ITEM_ID(AlienGrenade_Cyberdisc):
            return class'XGWeapon_CyberdiscGrenade';
        case `LW_ITEM_ID(PsiGrenade):
            return class'XGWeapon_PsiGrenade';
        case `LW_ITEM_ID(BattleScanner):
            return class'XGWeapon_BattleScanner';
        case `LW_ITEM_ID(AlloyCannon):
        case `LW_ITEM_ID(ReflexCannon):
            return class'XGWeapon_AlloyCannon';
        case `LW_ITEM_ID(Autocannon):
            return class'XGWeapon_Shiv_Minigun';
        case `LW_ITEM_ID(SentryGun):
            return class'XGWeapon_Shiv_Sentry';
        case `LW_ITEM_ID(SuperheavyPulser):
            return class'XGWeapon_Shiv_Laser';
        case `LW_ITEM_ID(SuperheavyPlasma):
            return class'XGWeapon_Shiv_Plasma';
        case `LW_ITEM_ID(SuperheavyLaser):
            return class'XGWeapon_Shiv_Laser';
        case `LW_ITEM_ID(AlienCannon_Sectopod):
            return class'XGWeapon_SectopodChestCannon';
        case `LW_ITEM_ID(Minigun):
        case `LW_ITEM_ID(Railgun):
            return class'XGWeapon_Chaingun';
        case `LW_ITEM_ID(LaserLance):
        case `LW_ITEM_ID(PulseLance):
            return class'XGWeapon_Railgun';
        case `LW_ITEM_ID(AlloyJacketedRounds):
        case `LW_ITEM_ID(MarksmansScope):
        case `LW_ITEM_ID(EnhancedBeamOptics):
        case `LW_ITEM_ID(PlasmaStellerator):
        case `LW_ITEM_ID(AlloyPlating):
        case `LW_ITEM_ID(Rocket):
        case `LW_ITEM_ID(LaserSight):
        case `LW_ITEM_ID(HiCapMags):
        case `LW_ITEM_ID(ShredderRocket):
        case `LW_ITEM_ID(BattleComputer):
        case `LW_ITEM_ID(ChameleonSuit):
        case `LW_ITEM_ID(CeramicPlating):
        case `LW_ITEM_ID(AlienTrophy):
        case `LW_ITEM_ID(HEATAmmo):
        case `LW_ITEM_ID(HoloTargeter):
        case `LW_ITEM_ID(DrumMags):
        case `LW_ITEM_ID(SmartshellPod):
        case `LW_ITEM_ID(WeaponSupercooler):
        case `LW_ITEM_ID(TheThumper):
        case `LW_ITEM_ID(AutoSentryTurret):
        case `LW_ITEM_ID(AdaptiveTrackingPod):
        case `LW_ITEM_ID(CoreArmoring):
        case `LW_ITEM_ID(DamageControlPod):
        case `LW_ITEM_ID(Mec3Valiant):
        case `LW_ITEM_ID(Mec5Devastator):
        case `LW_ITEM_ID(FuelCell):
        case `LW_ITEM_ID(AlloyCarbidePlating):
        case `LW_ITEM_ID(Mec6Vanguard):
        case `LW_ITEM_ID(AlloyBipod):
        case `LW_ITEM_ID(BreachingAmmo):
        case `LW_ITEM_ID(ArmorPiercingAmmo):
        case `LW_ITEM_ID(AdvancedSuppressionModule):
        case `LW_ITEM_ID(ImpactVest):
        case `LW_ITEM_ID(TacticalSensors):
        case `LW_ITEM_ID(WalkerServos):
        case `LW_ITEM_ID(NeuralGunlink):
        case `LW_ITEM_ID(ShredderAmmo):
        case `LW_ITEM_ID(PsiScreen):
        case `LW_ITEM_ID(IlluminatorGunsight):
        case `LW_ITEM_ID(Mec7Vindicator):
        case `LW_ITEM_ID(IncineratorModule):
        case `LW_ITEM_ID(TargetingModule):
        case `LW_ITEM_ID(ReinforcedArmor):
        case `LW_ITEM_ID(EleriumTurbos):
        case `LW_ITEM_ID(MotionTracker):
        case `LW_ITEM_ID(CognitiveEnhancer):
        case `LW_ITEM_ID(Neuroregulator):
        case `LW_ITEM_ID(FlakAmmo):
            return class'XGWeapon_ReinforcedArmor';
        case `LW_ITEM_ID(RocketLauncher):
            return class'XGWeapon_ExaltRocketLauncher';
        case `LW_ITEM_ID(SniperRifle):
        case `LW_ITEM_ID(MarksmansRifle):
            return class'XGWeapon_ExaltSniperRifle';
        case `LW_ITEM_ID(GaussLongRifle):
        case `LW_ITEM_ID(AlloyStrikeRifle):
            return class'XGWeapon_SniperRifle';
        case `LW_ITEM_ID(PulseSniperRifle):
        case `LW_ITEM_ID(BlasterRifle):
            return class'XGWeapon_LaserSniperRifle';
        case `LW_ITEM_ID(PlasmaSniperRifle):
        case `LW_ITEM_ID(ReflexRifle):
            return class'XGWeapon_PlasmaSniperRifle';
        case `LW_ITEM_ID(AssaultRifle):
        case `LW_ITEM_ID(SMG):
        case `LW_ITEM_ID(MachinePistol):
        case `LW_ITEM_ID(BattleRifle):
            return class'XGWeapon_ExaltAssaultRifle';
        case `LW_ITEM_ID(LaserRifle):
        case `LW_ITEM_ID(LaserShatterray):
        case `LW_ITEM_ID(Heater):
        case `LW_ITEM_ID(HeavyLaserRifle):
        case `LW_ITEM_ID(LaserCarbine):
            return class'XGWeapon_ExaltLaserAssaultRifle';
        case `LW_ITEM_ID(GaussRifle):
        case `LW_ITEM_ID(GaussStuttergun):
        case `LW_ITEM_ID(GaussAutopistol):
        case `LW_ITEM_ID(HeavyGaussRifle):
            return class'XGWeapon_AssaultRifle';
        case `LW_ITEM_ID(PulseRifle):
        case `LW_ITEM_ID(PulseStengun):
        case `LW_ITEM_ID(Blaster):
        case `LW_ITEM_ID(HeavyPulseRifle):
        case `LW_ITEM_ID(PulseCarbine):
            return class'XGWeapon_LaserAssaultRifle';
        case `LW_ITEM_ID(PlasmaCarbine):
        case `LW_ITEM_ID(PlasmaStormgun):
        case `LW_ITEM_ID(PlasmaMauler):
            return class'XGWeapon_PlasmaLightRifle';
        case `LW_ITEM_ID(PlasmaRifle):
        case `LW_ITEM_ID(HeavyPlasmaRifle):
            return class'XGWeapon_PlasmaAssaultRifle';
        case `LW_ITEM_ID(SAW):
        case `LW_ITEM_ID(LMG):
            return class'XGWeapon_ExaltMinigun';
        case `LW_ITEM_ID(Autolaser):
        case `LW_ITEM_ID(GatlingLaser):
            return class'XGWeapon_ExaltHeavyLaser';
        case `LW_ITEM_ID(GaussAutorifle):
        case `LW_ITEM_ID(GaussMachineGun):
            return class'XGWeapon_Minigun';
        case `LW_ITEM_ID(PulseAutoblaster):
        case `LW_ITEM_ID(GatlingPulser):
            return class'XGWeapon_HeavyLaser';
        case `LW_ITEM_ID(PlasmaNovagun):
        case `LW_ITEM_ID(PlasmaDragon):
            return class'XGWeapon_HeavyPlasma';
        case `LW_ITEM_ID(LaserSniperRifle):
        case `LW_ITEM_ID(LaserStrikeRifle):
        case `LW_ITEM_ID(ArcRifle):
            return class'XGWeapon_ExaltLaserSniperRifle';
        case `LW_ITEM_ID(Shotgun):
        case `LW_ITEM_ID(SawedOffShotgun):
            return class'XGWeapon_Shotgun';
        default:
            return none;
    }
}
class LWCE_XComProjectile_Extensions extends Object
    abstract;

static simulated function CalculateUnitDamage(XComProjectile kSelf)
{
    if (kSelf.bWillDoDamage)
    {
        if (XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()) != none && XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()).m_kShot.GetType() == eAbility_RocketLauncher)
        {
            kSelf.MyDamageType = class'XComDamageType_Explosion';
        }

        if (XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()) != none && XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()).m_kShot.GetType() == eAbility_ShredderRocket)
        {
            kSelf.MyDamageType = class'XComDamageType_NeedleExplosion';
        }

        if (kSelf.bIsHit || ClassIsChildOf(kSelf.MyDamageType, class'XComDamageType_Explosion'))
        {
            kSelf.Damage = float(kSelf.UnitDamage);
        }

        if (kSelf.Damage == 0.0)
        {
            kSelf.Damage = 0.0;
        }
    }

    if (XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()) != none && kSelf.GetGameWeapon() != none)
    {
        kSelf.DamageRadius = class'LWCE_XGAbility_Extensions'.static.GetRadius(XGAction_Fire(kSelf.m_kFiredFromUnit.GetAction()).m_kShot);
    }
}

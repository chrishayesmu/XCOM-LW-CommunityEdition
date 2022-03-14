class LWCE_MeldLightComponent extends SpotLightComponent;

var protected bool m_bIsActive;
var protected XComMeldContainerActor m_kMeld;

function Init(XComMeldContainerActor kMeld, int iLightNum)
{
    m_kMeld = kMeld;
    m_kMeld.SetTimer(0.1, /* inbLoop */ true, 'FxTick', self);

    GetSkeletalMeshComponent().AttachComponent(self, name("topPanel" $ iLightNum $ "_b"));
}

function Deactivate()
{
    // TODO: quick wind down when collected
    SetEnabled(false);
    m_bIsActive = false;
    m_kMeld.ClearTimer('FxTick', self);

    if (m_kMeld.m_bCollected)
    {
        // TODO: on collecting, replace spotlights with a point light
    }
}

function FxTick()
{
    if (!m_bIsActive || m_kMeld.IsDestroyed() || m_kMeld.m_bCollected)
    {
        Deactivate();
    }
}

protected function SkeletalMeshComponent GetSkeletalMeshComponent()
{
    local SkeletalMeshComponent kComp;

    foreach m_kMeld.AllOwnedComponents(class'SkeletalMeshComponent', kComp)
    {
        return kComp;
    }

    return none;
}

defaultproperties
{
    m_bIsActive=true

    Brightness=1.6
    LightColor=(R=255, G=178, B=91, A=0)
    Radius=768.0
    Translation=(X=0, Y=0, Z=96.0)
}
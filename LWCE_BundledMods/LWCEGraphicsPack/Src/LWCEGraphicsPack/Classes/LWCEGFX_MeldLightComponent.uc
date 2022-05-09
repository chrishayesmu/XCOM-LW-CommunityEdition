class LWCEGFX_MeldLightComponent extends SpotLightComponent;

const WindDownDurationSeconds = 1.5f;
const WindDownTickFrequency = 0.03f;

var protected bool m_bIsActive;
var protected bool m_bHasDeactivated;
var protected float m_fInitialBrightness;
var protected float m_fWindDownTime;
var protected XComMeldContainerActor m_kMeld;

function Init(XComMeldContainerActor kMeld, int iLightNum)
{
    m_bIsActive = true;
    m_bHasDeactivated = false;
    m_fInitialBrightness = Brightness;

    m_kMeld = kMeld;
    m_kMeld.SetTimer(0.1, /* inbLoop */ true, 'FxTick', self);

    GetSkeletalMeshComponent().AttachComponent(self, name("topPanel" $ iLightNum $ "_b"));
}

function Deactivate()
{
    if (m_bHasDeactivated)
    {
        return;
    }

    m_bIsActive = false;
    m_kMeld.ClearTimer('FxTick', self);

    if (m_kMeld.m_bCollected)
    {
        // TODO: on collecting, replace spotlights with a point light
        // Quick wind down when collected
        m_kMeld.SetTimer(WindDownTickFrequency, /* inbLoop */ true, 'WindDownAnimation', self);
    }
    else
    {
        SetEnabled(false);
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

protected function WindDownAnimation()
{
    m_fWindDownTime += WindDownTickFrequency;

    if (m_fWindDownTime >= WindDownDurationSeconds)
    {
        m_kMeld.ClearTimer('WindDownAnimation', self);
        SetEnabled(false);
        return;
    }

    // Linearly decrease brightness
    Brightness = Lerp(m_fInitialBrightness, 0, m_fWindDownTime / WindDownDurationSeconds);
    UpdateColorAndBrightness();
}

defaultproperties
{
    m_fWindDownTime=0.0f

    Brightness=1.6
    LightColor=(R=255, G=178, B=91, A=0)
    Radius=768.0
    Translation=(X=0, Y=0, Z=96.0)
}
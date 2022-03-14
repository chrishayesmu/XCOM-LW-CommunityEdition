class LWCE_PointLightComponent extends PointLightComponent;

const TimerFrequency = 0.05;

var bool m_bFlickers;
var float m_fAnchor;
var float m_fBaseBrightness;
var float m_fBaseRadius;
var float m_fVariableBrightness;
var float m_fVariableRadius;

function Init(LWCEGraphicsController kGfx)
{
    FxTick();
    kGfx.SetTimer(TimerFrequency, /* inbLoop */ true, 'FxTick', self);
}

function FxTick()
{
    local bool bUpdateColorAndBrightness;
    local float RandBrightness, RandRadius;

    if (m_bFlickers)
    {
        RandBrightness = (`SYNC_RAND(m_fVariableBrightness * 100) / 100.0) + m_fBaseBrightness;
        RandRadius = (`SYNC_RAND(m_fVariableRadius * 100) / 100.0) + m_fBaseRadius;

        // Weigh the new values to not deviate too far from the current, to avoid heavy flickering
        Brightness = (RandBrightness + m_fAnchor * Brightness) / (1.0 + m_fAnchor);
        Radius = (RandRadius + m_fAnchor * Radius) / (1.0 + m_fAnchor);

        bUpdateColorAndBrightness = true;
    }

    if (bUpdateColorAndBrightness)
    {
        UpdateColorAndBrightness();
    }
}

defaultproperties
{
    m_bFlickers=false
    m_fAnchor=0.5
    m_fBaseRadius=164.0
    m_fBaseBrightness=1.25
    m_fVariableBrightness=0.4
    m_fVariableRadius=96.0
}
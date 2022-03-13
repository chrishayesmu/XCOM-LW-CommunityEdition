class LWCEFireLightComponent extends PointLightComponent;

var float Anchor;
var float BaseBrightness;
var float BaseRadius;
var float VariableBrightness;
var float VariableRadius;

function Init(LWCEGraphicsController kGfx)
{
    FxTick();
    kGfx.SetTimer(0.15, /* inbLoop */ true, 'FxTick', self);
}

function FxTick()
{
    local float RandBrightness, RandRadius;

    RandBrightness = (`SYNC_RAND(VariableBrightness * 100) / 100.0) + BaseBrightness;
    RandRadius = (`SYNC_RAND(VariableRadius * 100) / 100.0) + BaseRadius;

    // Weigh the new values to not deviate too far from the current, to avoid heavy flickering
    Brightness = (RandBrightness + Anchor * Brightness) / (1.0 + Anchor);
    Radius = (RandRadius + Anchor * Radius) / (1.0 + Anchor);

    UpdateColorAndBrightness();
}

defaultproperties
{
    Anchor=0.5
    BaseRadius=164.0
    BaseBrightness=1.25
    LightColor=(R=255, G=165, B=115, A=0)
    Translation=(X=0.0, Y=0.0, Z=64.0)
    VariableBrightness=0.4
    VariableRadius=96.0
}
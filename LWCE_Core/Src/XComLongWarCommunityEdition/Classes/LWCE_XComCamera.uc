class LWCE_XComCamera extends XComCamera;

simulated function SetCurrentView(XGCameraView kView, optional InterpCurveFloat SpeedCurve)
{
    `LWCE_LOG_CLS("SetCurrentView called with view " $ kView);
    ScriptTrace();

    super.SetCurrentView(kView, SpeedCurve);
}
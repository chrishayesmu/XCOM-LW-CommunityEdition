class LWCE_XComCameraManager extends XComCameraManager;

`if(`notdefined(FINAL_RELEASE))
simulated function UpdateVisibilityUnit(XGUnit kUnit)
{
    if (kUnit == none)
    {
        `LWCE_LOG_CLS("UpdateVisibilityUnit: kUnit is none. Stack trace follows.");
        ScriptTrace();
    }

    super.UpdateVisibilityUnit(kUnit);
}
`endif
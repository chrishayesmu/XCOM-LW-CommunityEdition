class Highlander_XGPlayer extends XGPlayer;

function Init(optional bool bLoading = false)
{
    `HL_LOG_CLS("Override successful");

    super.Init(bLoading);
}
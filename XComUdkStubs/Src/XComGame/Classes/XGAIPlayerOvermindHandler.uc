class XGAIPlayerOvermindHandler extends Actor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var XGOvermind m_kOvermind;
    var bool bEnabled;
};

var XGOvermind m_kOvermind;
var array<XGPod> m_arrActivePod;
var array<XGManeuver> m_arrImmediateManeuver;
var XGPod m_kActivePod;
var int m_iActivePod;
var int m_iCurrUnit;
var XGManeuver m_kActiveManeuver;
var bool bEnabled;
var bool bInited;
var XGAIPlayer m_kPlayer;
var XGAction m_kPrimaryAction;
var array<XGUnit> m_arrDeferred;
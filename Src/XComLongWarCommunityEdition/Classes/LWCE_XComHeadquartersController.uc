class LWCE_XComHeadquartersController extends XComHeadquartersController;

event PostLogin() {
    `LWCE_LOG_CLS("(LWCE override)");
    super.PostLogin();
}

defaultproperties
{
    m_kPresentationLayerClass=class'LWCE_XComHQPresentationLayer'
    CheatClass=class'LWCE_XComHeadquartersCheatManager'
    InputClass=class'LWCE_XComHeadquartersInput'
}
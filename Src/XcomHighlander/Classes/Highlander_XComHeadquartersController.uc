class Highlander_XComHeadquartersController extends XComHeadquartersController;

event PostLogin() {
    `HL_LOG_CLS("(highlander override)");
    super.PostLogin();
}

defaultproperties
{
    m_kPresentationLayerClass=class'Highlander_XComHQPresentationLayer'
    CheatClass=class'Highlander_XComHeadquartersCheatManager'
    InputClass=class'Highlander_XComHeadquartersInput'
}
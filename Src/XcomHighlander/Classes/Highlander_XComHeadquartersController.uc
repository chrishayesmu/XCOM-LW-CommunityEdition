class Highlander_XComHeadquartersController extends XComHeadquartersController;


event PostLogin() {
    `HL_LOG(string(Class) $ " : (highlander override)");
    super.PostLogin();
}
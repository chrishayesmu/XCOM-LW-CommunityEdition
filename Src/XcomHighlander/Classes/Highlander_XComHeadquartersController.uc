class Highlander_XComHeadquartersController extends XComHeadquartersController;


event PostLogin() {
    LogInternal(string(Class) $ " : (highlander override)");
    super.PostLogin();
}
class Highlander_XGFundingCouncil extends XGFundingCouncil;

function Init()
{
    LogInternal(string(Class) $ " : Init Override successful");
    super.Init();
}
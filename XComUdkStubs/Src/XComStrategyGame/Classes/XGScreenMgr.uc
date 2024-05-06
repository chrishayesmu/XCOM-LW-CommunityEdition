/*******************************************************************************
 * XGScreenMgr generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGScreenMgr extends XGStrategyActor
    abstract
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct TMiniWorld
{
    var TImage imgWorld;
    var TLabeledText ltxtFunding;
    var array<TRect> arrCountries;
    var array<Color> arrColors;
    var array<TText> arrTickerText;

    structdefaultproperties
    {
        imgWorld=(iImage=0,strLabel="",iState=0,strPath="")
        ltxtFunding=(StrValue="",strLabel="",iState=0,bNumber=false)
        arrCountries=none
        arrColors=none
        arrTickerText=none
    }
};

var int m_iCurrentView;
var string m_strVirtualKeyboard;
var TMiniWorld m_kMap;
var IScreenMgrInterface m_kInterface;
var const localized string m_aResourceTypeNames[EResourceType];
var const localized string m_strCreditsPrefix;
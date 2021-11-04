class UISoldierListBase extends UI_FxsScreen
    hidecategories(Navigation);
//complet stub

enum UISoldierListCategories
{
    eSLCat_Country,
    eSLCat_Rank,
    eSLCat_Class,
    eSLCat_ClassName,
    eSLCat_Name,
    eSLCat_LastName,
    eSLCat_Nickname,
    eSLCat_Status,
    eSLCat_Promotable,
    eSLCat_PsiPromotable,
    eSLCat_IsPsiSoldier,
    eSLCat_HasGeneMod,
    eSLCat_Medals,
    eSLCat_ShivRank,
    eSLCat_SoldierListIndex,
    eSLCat_MAX
};

struct UISoldierOption
{
    var int iIndex;
    var int iState;
    var int iRank;
    var int iCountry;
    var int iClass;
    var string strClassName;
    var string strName;
    var string strNickName;
    var string strStatus;
    var string strMedals;
    var int iStatusState;
    var bool bPromotable;
    var bool bPsiPromotable;
    var bool bIsPsiSoldier;
    var bool bHasGeneMod;
    var bool bShiv;
  
};

var const localized string m_strSoldierListBaseTitle;
var const localized string m_strSoldierListBaseClassLabel;
var const localized string m_strSoldierListBaseStatusLabel;
var const localized string m_strBackLabel;
var bool m_bHasAccepted;
var int m_iCurrentSelection;
var array<UISoldierOption> m_arrUIOptions;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool RunAcceptLogic(optional int optionIndex){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function UpdateData();
simulated function UpdateDataFromTable(TTableMenu kTable){}
simulated function UpdateHeaders(){}
simulated function UpdateButtonHelp(){}
simulated function bool CanAccept(int optionIndex){}
simulated function bool OnAccept(optional string selectedOption){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string selectedOption){}
simulated function UpdateDisplay(){}
simulated function RealizeSelected(){}
simulated function AS_AddSoldier(string _name, string _className, string _status, bool _disabled, bool _promotable, bool _psiPromotable, string _rankLabel, string _classLabel, string _flagLabel){}
simulated function AS_AddSoldierWithNickname(string _name, string _nickname, string _className, string _status, bool _disabled, bool _promotable, bool _psiPromotable, string _rankLabel, string _classLabel, string _flagLabel, string Medals){}
simulated function AS_SetTitleLabels(string _titleLabel, string _classLabel, string _statusLabel){}
simulated function AS_SetCountLabel(string _soldierCount){}
simulated function AS_SetHelp(int Index, string Text, string buttonIcon){}
simulated function AS_SetMouseNavigationText(string str0, string str1){}

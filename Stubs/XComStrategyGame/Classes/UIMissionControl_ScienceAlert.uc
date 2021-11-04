class UIMissionControl_ScienceAlert extends UIMissionControl_ProjectCompleteAlert
    hidecategories(Navigation);
//complete stub

var const localized string m_strResearchCompleteSubTitle;

simulated function UpdateData()
{
    local TMCAlert kAlertData;

    kAlertData = GetMgr().m_kCurrentAlert;
    AS_SetTitle(class'UIUtilities'.static.CapsCheckForGermanScharfesS(kAlertData.txtTitle.StrValue));
    AS_SetSubTitle(m_strResearchCompleteSubTitle);
    AS_SetText(kAlertData.arrText[0].StrValue);
    UpdateButtonText();
    AS_SetImage(class'UIUtilities'.static.GetTechImagePath(GetMgr().m_kCurrentAlert.imgAlert.iImage));
    //return;    
}
class LWCE_UIDebrief extends UIDebrief
    dependson(LWCE_XGDebriefUI);

var protected LWCE_XGDebriefUI m_kCEMgr;

simulated function OnInit()
{
    super(UI_FxsScreen).OnInit();

    m_kCEMgr = LWCE_XGDebriefUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGDebriefUI', self));
    m_kCEMgr.m_kSkyranger = m_kSkyranger;

    m_kMgr = m_kCEMgr; // for non-overridden methods

    RealizeLabels();

    GoToView(m_kCEMgr.m_iCurrentView);
}

event Destroyed()
{
    `HQPRES.RemoveMgr(class'LWCE_XGDebriefUI');
    m_kCEMgr = none;
    super.Destroyed();
}

simulated function bool OnPressUp()
{
    switch (m_iView)
    {
        case eDebriefView_Soldiers:
            -- m_iCurrentSelection;

            if (m_iCurrentSelection < 0)
            {
                m_iCurrentSelection = m_kCEMgr.m_kCESoldierDebrief.arrItems.Length - 1;
            }

            AS_SetSoldierSelection(m_iCurrentSelection);
            m_kCEMgr.PlayScrollSound();
            break;
        case eDebriefView_Science:
            m_kCEMgr.PlayScrollSound();
            AS_ScrollUp();
            break;
    }

    return true;
}

simulated function bool OnPressDown()
{
    switch (m_iView)
    {
        case eDebriefView_Soldiers:
            ++ m_iCurrentSelection;

            if (m_iCurrentSelection >= m_kCEMgr.m_kCESoldierDebrief.arrItems.Length)
            {
                m_iCurrentSelection = 0;
            }

            AS_SetSoldierSelection(m_iCurrentSelection);
            m_kCEMgr.PlayScrollSound();
            break;
        case eDebriefView_Science:
            m_kCEMgr.PlayScrollSound();
            AS_ScrollDown();
            break;
    }

    return true;
}

simulated function RealizeLabels()
{
    local string operationTitleText, soldierDebriefText, scienceDebriefText, councilDebriefText, covertOpDebriefTitle, covertOpDebriefSubTitle, strContinue, strPromote;

    operationTitleText = class'UIUtilities'.static.CapsCheckForGermanScharfesS(m_kCEMgr.m_kCESoldierDebrief.txtOpName.StrValue);
    soldierDebriefText = m_kCEMgr.m_kCESoldierDebrief.txtTitle.StrValue;
    scienceDebriefText = m_kCEMgr.m_kScienceDebrief.txtTitle.StrValue;
    councilDebriefText = m_kCEMgr.m_kCouncilDebrief.txtTitle.StrValue;
    covertOpDebriefTitle = m_kCEMgr.m_kCECovertOpDebrief.txtTitle.StrValue;
    covertOpDebriefSubTitle = m_kCEMgr.m_kCECovertOpDebrief.txtSubTitle.StrValue;
    strContinue = m_strContinue;
    strPromote = class'UI_FxsGamepadIcons'.static.HTML("Icon_Y_TRIANGLE", 20, -5) $ m_strPromote;

    AS_SetTitles(m_strDebrief, operationTitleText, soldierDebriefText, scienceDebriefText, councilDebriefText, covertOpDebriefTitle, covertOpDebriefSubTitle);
    AS_SetLabels(m_strKills, m_strMissions, m_strActive, m_strWounded, m_strDays, m_strKIA, strContinue, strPromote, m_strPromoteMouse);
}

simulated function ShowCovertOpDebrief()
{
    local string portraitPath, flagImageLabel, rankIconLabel, classIconLabel, nameStr, NickName;
    local int killsOverall, killsThisMission, Missions, promoteRank;
    local string promoteText, classPromoteText;
    local bool isPsiPromoted;
    local string Status;
    local LWCE_TSoldierDebriefItem Soldier;
    local LWCE_XGDebriefUI kMgr;

    kMgr = LWCE_XGDebriefUI(m_kMgr);

    RealizeLabels();
    XComHQPresentationLayer(Owner).GetStrategyHUD().ClearButtonHelp();
    XComHQPresentationLayer(Owner).GetStrategyHUD().Hide();

    m_iCurrentSelection = -1;
    Soldier = kMgr.m_kCECovertOpDebrief.covertSoldier;
    portraitPath = Soldier.imgSoldier.strPath;
    flagImageLabel = Soldier.imgFlag.strPath;
    rankIconLabel = class'UIUtilities'.static.GetRankLabel(Soldier.iSoldierRank, Soldier.m_bIsTank);
    classIconLabel = `LWCE_BARRACKS.GetClassIcon(Soldier.iSoldierClassId, Soldier.m_bIsPsiSoldier, Soldier.m_bHasGeneMod);
    nameStr = Soldier.txtName.StrValue;
    NickName = Soldier.kPromotion.txtNickname.StrValue;
    killsOverall = int(Soldier.txtKills.StrValue);
    killsThisMission = -1;
    Missions = int(Soldier.txtMissions.StrValue);
    promoteRank = Soldier.iSoldierRank;
    promoteText = Soldier.kPromotion.txtPromotion.StrValue;
    classPromoteText = Soldier.kPromotion.txtClassPromotion.StrValue;
    isPsiPromoted = Soldier.m_bPsiPromoted;
    Status = class'UIUtilities'.static.GetHTMLColoredText(Caps(Soldier.txtStatus.StrValue), Soldier.txtStatus.iState);

    if (Soldier.m_bPsiPromoted || Soldier.m_bWasPromoted)
    {
        if (m_iCurrentSelection == -1 && !manager.IsMouseActive())
        {
            m_iCurrentSelection = 0;
        }
    }

    AS_SetCovertSoldier(portraitPath, flagImageLabel, rankIconLabel, classIconLabel, nameStr, NickName, killsOverall, killsThisMission, Missions, promoteRank, promoteText, classPromoteText, Status, Soldier.m_isDead, isPsiPromoted);

    if (m_iCurrentSelection == -1)
    {
        AS_SetSoldierSelection(-1);
    }
    else if (!manager.IsMouseActive())
    {
        AS_SetSoldierSelection(0);
    }

    AS_SetCovertInfo(kMgr.m_kCECovertOpDebrief.bSuccessful, kMgr.m_kCECovertOpDebrief.txtFeedback.StrValue, kMgr.m_kCECovertOpDebrief.txtClueTitle.StrValue $ "\n" $ kMgr.m_kCECovertOpDebrief.txtClueBody.StrValue);
    AS_ShowCovertOpDebrief();
}

simulated function ShowScienceDebrief()
{
    local int iListId, iLoot, iItem, Len, Amount;
    local string Description, Title, imagePath;

    if (m_iView == eDebriefView_Science)
    {
        iListId = 0;
        Len = m_kCEMgr.m_kScienceDebrief.arrItems.Length;

        for (iItem = 0; iItem < Len; iItem++)
        {
            if (iItem == 0)
            {
                AS_AddListHeader(iListId++, m_kCEMgr.m_kScienceDebrief.arrItems[iItem].txtTitle.StrValue);
            }

            Title = m_kCEMgr.m_kScienceDebrief.arrItems[iItem].txtTech.StrValue;
            Description = m_kCEMgr.m_kScienceDebrief.arrItems[iItem].txtBody.StrValue;
            imagePath = m_kCEMgr.m_kScienceDebrief.arrItems[iItem].imgTech.strPath;
            AS_AddScienceResearch(iListId++, Title, Description, imagePath);
        }

        AS_AddListHeader(iListId++, m_kCEMgr.m_kScienceDebrief.txtLootTitle.StrValue);
        Len = m_kCEMgr.m_kScienceDebrief.arrLoot.Length;

        for (iLoot = 0; iLoot < Len; iLoot++)
        {
            Description = m_kCEMgr.m_kScienceDebrief.arrLoot[iLoot].txtItem.StrValue;
            Amount = int(m_kCEMgr.m_kScienceDebrief.arrLoot[iLoot].txtQuantity.StrValue);
            imagePath = m_kCEMgr.m_kScienceDebrief.arrLoot[iLoot].imgItem.strPath;
            AS_AddScienceItem(iListId++, Description, Amount, imagePath);
        }
    }
    else
    {
        Invoke("ClearScienceDebrief");
        iListId = 0;
        Len = m_kCEMgr.m_kEngineeringDebrief.arrItems.Length;

        if (m_kCEMgr.m_kEngineeringDebrief.iHighlighted > 0)
        {
            AS_AddListHeader(iListId++, m_kCEMgr.m_kEngineeringDebrief.txtAdvisor.StrValue);
        }

        for (iItem = 0; iItem < m_kCEMgr.m_kEngineeringDebrief.iHighlighted; iItem++)
        {
            Description = m_kCEMgr.m_kEngineeringDebrief.arrItems[iItem].txtItem.StrValue;
            Amount = int(m_kCEMgr.m_kEngineeringDebrief.arrItems[iItem].txtBody.StrValue);
            imagePath = m_kCEMgr.m_kEngineeringDebrief.arrItems[iItem].imgItem.strPath;
            AS_AddScienceItem(iListId++, Description, Amount, imagePath);
        }

        if (iItem < Len)
        {
            AS_AddListHeader(iListId++, m_kCEMgr.m_kEngineeringDebrief.txtTitle.StrValue);
        }

        while (iItem < Len)
        {
            Description = m_kCEMgr.m_kEngineeringDebrief.arrItems[iItem].txtItem.StrValue;
            Amount = int(m_kCEMgr.m_kEngineeringDebrief.arrItems[iItem].txtBody.StrValue);
            imagePath = m_kCEMgr.m_kEngineeringDebrief.arrItems[iItem].imgItem.strPath;
            AS_AddScienceItem(iListId++, Description, Amount, imagePath);

            iItem++;
        }
    }

    if (Len == 0)
    {
        m_kCEMgr.OnAdvance();
    }
    else
    {
        AS_ShowScienceDebrief();
    }
}

simulated function ShowSoldierDebrief()
{
    local bool isPsiPromoted;
    local int I, Len;
    local int killsOverall, killsThisMission, Missions, promoteRank;
    local string portraitPath, flagImageLabel, rankIconLabel, classIconLabel, nameStr, NickName;
    local string promoteText, classPromoteText;
    local string Status;
    local LWCE_TSoldierDebriefItem Soldier;

    XComHQPresentationLayer(Owner).GetStrategyHUD().ClearButtonHelp();
    XComHQPresentationLayer(Owner).GetStrategyHUD().Hide();
    Len = m_kCEMgr.m_kCESoldierDebrief.arrItems.Length;
    m_iCurrentSelection = -1;

    for (I = 0; I < Len; I++)
    {
        Soldier = m_kCEMgr.m_kCESoldierDebrief.arrItems[I];
        portraitPath = Soldier.imgSoldier.strPath;
        flagImageLabel = Soldier.imgFlag.strPath;
        rankIconLabel = class'UIUtilities'.static.GetRankLabel(Soldier.iSoldierRank, Soldier.m_bIsTank);
        classIconLabel = `LWCE_BARRACKS.GetClassIcon(Soldier.iSoldierClassId, Soldier.m_bIsPsiSoldier, Soldier.m_bHasGeneMod);
        nameStr = Soldier.txtName.StrValue;
        NickName = Soldier.kPromotion.txtNickname.StrValue;
        killsOverall = int(Soldier.txtKills.StrValue);
        killsThisMission = -1;
        Missions = int(Soldier.txtMissions.StrValue);
        promoteRank = Soldier.iSoldierRank;
        promoteText = Soldier.kPromotion.txtPromotion.StrValue;
        classPromoteText = Soldier.kPromotion.txtClassPromotion.StrValue;
        isPsiPromoted = Soldier.m_bPsiPromoted;
        Status = class'UIUtilities'.static.GetHTMLColoredText(Caps(Soldier.txtStatus.StrValue), Soldier.txtStatus.iState);

        if (Soldier.m_bPsiPromoted || Soldier.m_bWasPromoted)
        {
            m_arrPromotedIndexes.AddItem(I);

            if (m_iCurrentSelection == -1 && !manager.IsMouseActive())
            {
                m_iCurrentSelection = 0;
            }
        }

        if (!Soldier.m_bIsTank)
        {
            AS_SetSoldier(I, portraitPath, flagImageLabel, rankIconLabel, classIconLabel, nameStr, NickName, killsOverall, killsThisMission, Missions, promoteRank, promoteText, classPromoteText, Status, Soldier.m_isDead, isPsiPromoted);
        }
        else
        {
            AS_SetShiv(I, nameStr, killsOverall, killsThisMission, Missions, !Soldier.m_isDead, Status, rankIconLabel);
        }
    }

    if (m_iCurrentSelection == -1)
    {
        AS_SetSoldierSelection(0);
    }
    else if (!manager.IsMouseActive())
    {
        AS_SetSoldierSelection(m_arrPromotedIndexes[m_iCurrentSelection]);
    }

    AS_ShowSoldierDebrief();
}
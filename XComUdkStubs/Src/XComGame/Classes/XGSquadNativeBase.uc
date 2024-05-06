class XGSquadNativeBase extends Actor
    native(Unit)
    notplaceable
    hidecategories(Navigation);

const MaxUnitCount = 128;

struct CheckpointRecord
{
    var XGUnit m_arrPermanentMembers[128];
    var int m_iNumPermanentUnits;
    var int m_iNumCloseUnits;
    var string m_strName;
    var string m_strMotto;
    var Color m_clrColors;
    var XGPlayer m_kPlayer;
    var int m_iCloseCombatInit;
    var XGUnit m_arrUnits[128];
    var int m_iNumUnits;
    var ETeam m_eTeam;
    var bool m_bHasSeenOtherTeam;
    var int m_iLeader;
};

var protected repnotify XGUnit m_arrPermanentMembers[128];
var protected repnotify int m_iNumPermanentUnits;
var protected int m_iNumCloseUnits;
var protected string m_strName;
var protected string m_strMotto;
var protected Color m_clrColors;
var XGPlayer m_kPlayer;
var protected int m_iCloseCombatInit;
var protected repnotify XGUnit m_arrUnits[128];
var protected repnotify int m_iNumUnits;
var bool m_bHasSeenOtherTeam;
var private int m_iLeader;
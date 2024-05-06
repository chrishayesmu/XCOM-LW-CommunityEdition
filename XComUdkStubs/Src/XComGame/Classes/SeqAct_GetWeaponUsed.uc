class SeqAct_GetWeaponUsed extends SequenceAction
    native(Unit)
    dependson(XGGameData)
    forcescriptorder(true)
    hidecategories(Object);

var() ETeam WeaponTeam;
var array<EItemType> HumanWeapons;
var array<EItemType> AlienWeapons;

defaultproperties
{
    HumanWeapons(0)=18
    HumanWeapons(1)=39
    HumanWeapons(2)=0
    HumanWeapons(3)=0
    HumanWeapons(4)=0
    HumanWeapons(5)=0
    HumanWeapons(6)=0
    HumanWeapons(7)=0
    HumanWeapons(8)=127
    HumanWeapons(9)=38
    HumanWeapons(10)=0
    HumanWeapons(11)=0
    HumanWeapons(12)=0
    HumanWeapons(13)=0
    HumanWeapons(14)=0
    HumanWeapons(15)=0
    HumanWeapons(16)=62
    HumanWeapons(17)=39
    HumanWeapons(18)=0
    HumanWeapons(19)=0
    HumanWeapons(20)=0
    HumanWeapons(21)=0
    HumanWeapons(22)=0
    HumanWeapons(23)=0
    HumanWeapons(24)=231
    HumanWeapons(25)=38
    HumanWeapons(26)=0
    HumanWeapons(27)=0
    HumanWeapons(28)=0
    HumanWeapons(29)=0
    HumanWeapons(30)=0
    AlienWeapons(0)=43
    AlienWeapons(1)=39
    AlienWeapons(2)=0
    AlienWeapons(3)=0
    AlienWeapons(4)=0
    AlienWeapons(5)=0
    AlienWeapons(6)=0
    AlienWeapons(7)=0
    AlienWeapons(8)=44
    AlienWeapons(9)=39
    AlienWeapons(10)=0
    AlienWeapons(11)=0
    AlienWeapons(12)=0
    AlienWeapons(13)=0
    AlienWeapons(14)=0
    AlienWeapons(15)=0
    AlienWeapons(16)=48
    AlienWeapons(17)=39
    AlienWeapons(18)=0
    AlienWeapons(19)=0
    AlienWeapons(20)=0
    AlienWeapons(21)=0
    AlienWeapons(22)=0
    bCallHandler=false
    bAutoActivateOutputLinks=false
    ObjName="Get Weapon Used"
}
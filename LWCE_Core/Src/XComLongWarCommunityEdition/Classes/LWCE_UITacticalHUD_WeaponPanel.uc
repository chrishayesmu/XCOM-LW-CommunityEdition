class LWCE_UITacticalHUD_WeaponPanel extends UITacticalHUD_WeaponPanel;

simulated function SetWeaponAndAmmo(XGWeapon kWeapon)
{
    local LWCE_TCharacter kChar;
    local ASValue myValue;
    local array<ASValue> myArray;
    local XGAbility_Targeted kTAbility;

    if (kWeapon != none)
    {
        m_kWeapon = kWeapon;
        kTAbility = XGAbility_Targeted(UITacticalHUD(screen).m_kAbilityHUD.GetSelectedAbility());

        myValue.Type = AS_String;
        myValue.S = LWCE_XGWeapon(kWeapon).m_kTemplate.strWeaponPanelImageData;
        myArray.AddItem(myValue);

        myValue.Type = AS_Number;
        myValue.N = kWeapon.GetRemainingAmmo();
        myArray.AddItem(myValue);

        myValue.Type = AS_Number;

        if (kTAbility == none || kTAbility.m_kWeapon != kWeapon)
        {
            myValue.N = 0;
        }
        else
        {
            kChar = LWCE_XGUnit(kTAbility.m_kUnit).LWCE_GetCharacter().GetCharacter();
            myValue.N = `LWCE_GAMECORE.LWCE_GetOverheatIncrement(LWCE_XGWeapon(kTAbility.m_kWeapon).m_TemplateName, kTAbility.GetType(), kChar, /* bReactionFire */ false);

            if (kTAbility.GetType() == eAbility_RapidFire)
            {
                myValue.N *= 2.0f;
            }
        }

        myArray.AddItem(myValue);

        myValue.Type = AS_Boolean;
        myValue.B = false;
        myArray.AddItem(myValue);

        myValue.Type = AS_Boolean;
        myValue.B = kWeapon.GetRemainingAmmo() == 0 && !kWeapon.HasProperty(eWP_NoReload);
        myArray.AddItem(myValue);
    }
    else
    {
        myValue.Type = AS_String;
        myValue.S = "";
        myArray.AddItem(myValue);

        myValue.Type = AS_Number;
        myValue.N = 0.0;
        myArray.AddItem(myValue);

        myValue.Type = AS_Number;
        myValue.N = 0.0;
        myArray.AddItem(myValue);

        myValue.Type = AS_Boolean;
        myValue.B = false;
        myArray.AddItem(myValue);
    }

    Invoke("SetWeaponAndAmmo", myArray);
}
class LWCEStandardDamageCalculator extends Object;

/// <summary>
/// Defines generic operations to be performed on ability attributes (specifically, floats).
/// Each operation takes the original value and an incoming value, performs the specified operation on them,
/// and stores the result in place of the original value.
/// </summary>
enum EOperation
{
    eOp_None,
    eOp_Add,              // Adds the incoming value to the original value.
    eOp_Multiply,         // Multiplies the incoming value by the original value.
    eOp_MultiplyAndFloor, // Multiplies the incoming value by the original value, then floors the product.
    eOp_MultiplyAndRound, // Multiplies the incoming value by the original value, then rounds the product.
    eOp_SetValue,         // Replaces the original value with the incoming value.
    eOp_Function          // Executes a custom-provided function to determine the new value.
};

delegate static CustomOperation(out float fInValue, float fOperandValue);

static function ApplyOperation(out float fOutValue, float fOperandValue, EOperation Operation, delegate<CustomOperation> CustomOperationFn)
{
    switch (Operation)
    {
        case eOp_Add:
            fOutValue += fOperandValue;
            break;
        case eOp_Multiply:
            fOutValue *= fOperandValue;
            break;
        case eOp_MultiplyAndFloor:
            fOutValue = FFloor(fOutValue * fOperandValue);
            break;
        case eOp_MultiplyAndRound:
            fOutValue = Round(fOutValue * fOperandValue);
            break;
        case eOp_SetValue:
            fOutValue = fOperandValue;
            break;
        case eOp_Function:
            `if(`notdefined(FINAL_RELEASE))
                if (CustomOperationFn == none)
                {
                    `LWCE_LOG_CLS("ERROR: operation code is eOp_Function but no custom operation delegate is provided!");
                    return;
                }
            `endif

            CustomOperationFn(fOutValue, fOperandValue);
    }
}

/// <summary>
/// Calculates the range of possible damage rolls for the given parameters.
/// </summary>
/// <param name="bIsCrit">Whether the attack is a critical hit.</param>
/// <param name="iWeaponBaseDamage">The damage of the weapon being used.</param>
/// <param name="iModifiedDamage">All damage modifications which occur pre-roll, such as from effects or ability modifiers.</param>
/// <param name="iMinRoll">The lowest possible resulting roll.</param>
/// <param name="iMaxRoll">The highest possible resulting roll.</param>
/// <remarks>
/// Based on XGTacticalGameCore.CalcOverallDamage. Note that damage rolls are not uniformly distributed in the range
/// granted here. If you need an actual roll, use RollForDamage.
/// </remarks>
static function GetDamageRollRange(bool bIsCrit, int iBaseDamage, int iModifiedDamage, out int iMinRoll, out int iMaxRoll)
{
    local bool bDamageRoulette;
    local int iRandDamageMin, iRandDamageMax;

    bDamageRoulette = `LWCE_GAMECORE.IsOptionEnabled(eGO_RandomDamage);

    iMinRoll = iBaseDamage + iModifiedDamage;
    iMaxRoll = iBaseDamage + iModifiedDamage;

    iRandDamageMin = 0;
    iRandDamageMax = ((bDamageRoulette ? 4 : 2) * iMaxRoll + 2) - 1;

    if (bDamageRoulette)
    {
        iMinRoll = ( (bIsCrit ? 6 : 2) * iMinRoll + 1 + iRandDamageMin) / 4;
        iMaxRoll = ( (bIsCrit ? 6 : 2) * iMaxRoll + 1 + iRandDamageMax) / 4;
    }
    else
    {
        iMinRoll = ( (bIsCrit ? 5 : 3) * iMinRoll + 1 + iRandDamageMin) / 4;
        iMaxRoll = ( (bIsCrit ? 5 : 3) * iMaxRoll + 1 + iRandDamageMax) / 4;
    }

    if (bIsCrit)
    {
        iMinRoll = Max(iMinRoll, ( (bDamageRoulette ? 6 : 5) * (iBaseDamage + iModifiedDamage) + 2) / 4);
        iMaxRoll = Max(iMaxRoll, ( (bDamageRoulette ? 6 : 5) * (iBaseDamage + iModifiedDamage) + 2) / 4);
    }

    iMinRoll = Max(iMinRoll, 0);
    iMaxRoll = Max(iMaxRoll, 0);
}

static function int RollForDamage(bool bIsCrit, int iBaseDamage, int iModifiedDamage)
{
    local bool bDamageRoulette;
    local int iDamage, iRandDamage;

    bDamageRoulette = `LWCE_GAMECORE.IsOptionEnabled(eGO_RandomDamage);
    iDamage = iBaseDamage + iModifiedDamage;

    iRandDamage = `SYNC_RAND_STATIC( (bDamageRoulette ? 4 : 2) * iDamage + 2 );

    if (bDamageRoulette)
    {
        iDamage = ( (bIsCrit ? 6 : 2) * iDamage + 1 + iRandDamage) / 4;
    }
    else
    {
        iDamage = ( (bIsCrit ? 5 : 3) * iDamage + 1 + iRandDamage) / 4;
    }

    if (bIsCrit)
    {
        iDamage = Max(iDamage, ( (bDamageRoulette ? 6 : 5) * (iBaseDamage + iModifiedDamage) + 2) / 4);
    }

    if (iDamage < 1)
    {
        iDamage = 1;
    }

    return iDamage;
}
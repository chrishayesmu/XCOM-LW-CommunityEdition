interface LWCE_XGCharacter;

function AddPerk(const LWCE_TIDWithSource kData);

function array<name> GetAllBackpackItems();
function bool HasAbility(int iAbilityId);
function bool HasCharacterProperty(int iCharPropId);
function bool HasItemInInventory(name ItemName);
function bool HasPerk(int iPerkId);
function bool HasTraversal(int iTraversalId);
function bool IsPsionic();

function LWCE_TCharacter GetCharacter();
function SetCharacter(const LWCE_TCharacter kChar);

function LWCE_TInventory GetInventory();
function SetInventory(const LWCE_TInventory kInventory);

function int GetCharacterType();
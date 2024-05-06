//=============================================================================
// Input
// Object that maps key events to key bindings
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class Input extends Interaction
	native(UserInterface)
	config(Input)
    transient;

struct native KeyBind
{
	var config name		Name;
	var config string	Command;
	var config bool		Control,
						Shift,
						Alt;

	/** if true, the bind will not be activated if the corresponding key is held down */
	var	config bool		bIgnoreCtrl, bIgnoreShift, bIgnoreAlt;

structcpptext
{
	FKeyBind()
	: Name()
	, Control(FALSE), Shift(FALSE), Alt(FALSE)
	, bIgnoreCtrl(FALSE), bIgnoreShift(FALSE), bIgnoreAlt(FALSE)
	{}
}
};

var config array<KeyBind>				Bindings;

/** list of keys which this interaction handled a pressed event for */
var protectedwrite array<name>				PressedKeys;

var const EInputEvent					CurrentEvent;
var const float							CurrentDelta;
var const float							CurrentDeltaTime;

var native const Map{FName,void*}		NameToPtr;
var native const init array<pointer>	AxisArray{FLOAT};

cpptext
{
	// UInteraction interface.

	virtual UBOOL InputKey(INT ControllerId, FName Key, enum EInputEvent Event, FLOAT AmountDepressed = 1.f, UBOOL bGamepad = FALSE );
	virtual UBOOL InputAxis(INT ControllerId, FName Key, FLOAT Delta, FLOAT DeltaTime, UBOOL bGamepad=FALSE);
	virtual void Tick(FLOAT DeltaTime);
	UBOOL IsPressed( FName InKey ) const;
	UBOOL IsCtrlPressed() const;
	UBOOL IsShiftPressed() const;
	UBOOL IsAltPressed() const;

	// UInput interface.
	virtual UBOOL Exec(const TCHAR* Cmd,FOutputDevice& Ar);

	/**
	 * Clears the PressedKeys array.  Should be called when another interaction which swallows some (but perhaps not all) input is activated.
	 */
	virtual void FlushPressedKeys()
	{
		PressedKeys.Empty();
	}

	// Protected.

	BYTE* FindButtonName(const TCHAR* ButtonName);
	FLOAT* FindAxisName(const TCHAR* ButtonName);
	/**
	 * Returns the Name of a bind using the bind's Command as the key
	 * StartBind Index is where the search will start from and where the index result will be stored
	 *   -- If you don't where to start your search from (as the list will search backwards), set the StartBindIndex to -1 before passing it in
	 */
	FString GetBindNameFromCommand(const FString& KeyCommand, INT* StartBindIndex = NULL ) const;
	void ExecInputCommands(const TCHAR* Cmd,class FOutputDevice& Ar);
	virtual void UpdateAxisValue( FLOAT* Axis, FLOAT Delta );
}

/**
 * Resets this input object, flushing all pressed keys and clearing all player 'input' variables.
 */
native function ResetInput();

native function string GetBind(const out Name Key);

exec function SetBind(const out name BindName, string Command)
{
	local KeyBind	NewBind;
	local int		BindIndex;

	if ( Left(Command,1) == "\"" && Right(Command,1) == "\"" )
	{
		Command = Mid(Command, 1, Len(Command) - 2);
	}

	for(BindIndex = Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(Bindings[BindIndex].Name == BindName)
		{
			Bindings[BindIndex].Command = Command;
			// `log("Binding '"@BindName@"' found, setting command '"@Command@"'");
			SaveConfig();
			return;
		}
	}

	// `log("Binding '"@BindName@"' NOT found, adding new binding with command '"@Command@"'");
	NewBind.Name = BindName;
	NewBind.Command = Command;
	Bindings[Bindings.Length] = NewBind;
	SaveConfig();
}


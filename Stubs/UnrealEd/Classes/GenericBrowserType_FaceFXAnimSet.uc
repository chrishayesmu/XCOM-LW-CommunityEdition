/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// GenericBrowserType_FaceFXAnimSet: FaceFX AnimSets
//=============================================================================

class GenericBrowserType_FaceFXAnimSet
	extends GenericBrowserType
	native;

cpptext
{
	virtual void Init();
	virtual UBOOL ShowObjectEditor( UObject* InObject );

	/**
	 * Returns a list of commands that this object supports (or the object type supports, if InObject is NULL)
	 *
	 * @param	InObjects		The objects to query commands for (if NULL, query commands for all objects of this type.)
	 * @param	OutCommands		The list of custom commands to support
	 */
	virtual void QuerySupportedCommands( class USelection* InObjects, TArray< FObjectSupportedCommandType >& OutCommands ) const;

	virtual void InvokeCustomCommand( INT InCommand, TArray<UObject*>& InObjects);
}
	
defaultproperties
{
	Description="FaceFX Animations"
}
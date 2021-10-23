/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class SoundNode extends Object
	native( Sound )
	abstract
	hidecategories( Object )
	editinlinenew;

var native const int	NodeUpdateHint;
var array<SoundNode>	ChildNodes;


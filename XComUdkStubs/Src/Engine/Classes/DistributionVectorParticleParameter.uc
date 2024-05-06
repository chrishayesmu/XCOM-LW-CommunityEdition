/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class DistributionVectorParticleParameter extends DistributionVectorParameterBase
	native(Particle)
	collapsecategories
	hidecategories(Object)
	editinlinenew;
	
cpptext
{
	virtual UBOOL GetParamValue(UObject* Data, FName ParamName, FVector& OutVector);
}

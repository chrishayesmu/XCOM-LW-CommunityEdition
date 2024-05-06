/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * This is the base class for per-platform support for uploading analytics events
 */
 
class AnalyticEventsBase extends PlatformInterfaceBase
	native(PlatformInterface);

/** Named param/value string pairing */
struct native EventStringParam
{
	/** parameter name */
	var string ParamName;
	/** parameter value */
	var string ParamValue;

	structcpptext
	{
		FEventStringParam(const FString& InNameStr,const FString& InValueStr)
		{
			appMemzero(this, sizeof(FEventStringParam));
			ParamName = InNameStr;
			ParamValue = InValueStr;
		}
		FEventStringParam(EEventParm)
		{
			appMemzero(this, sizeof(FEventStringParam));
		}
	}
};

/** TRUE if a session has been started and is currently in progress */
var const bool bSessionInProgress;

/** 
 * @return TRUE if a session has been started and is currently in progress 
 */
function bool IsSessionInProgress()
{
	return bSessionInProgress;
}

/**
 * Perform any initialization. Called once after singleton instantiation
 */
native event Init();

/**
 * Start capturing stats for upload 
 */
native event StartSession();

/**
 * End capturing stats and queue the upload 
 */
native event EndSession();

/**
 * Adds a named event to the session
 *
 * @param EventName unique string for named event
 */
native event LogStringEvent(string EventName);

/**
 * Adds a named event to the session with a single parameter/value
 *
 * @param EventName unique string for named 
 * @param ParamName parameter name for the event
 * @param ParamValue parameter value for the event
 */
native event LogStringEventParam(string EventName, string ParamName, string ParamValue);

/**
 * Adds a named event to the session with a single parameter/value
 *
 * @param EventName unique string for named 
 * @param ParamArray array of parameter name/value pairs
 */
native event LogStringEventParamArray(string EventName, array<EventStringParam> ParamArray);

/**
 * Adds a named error event with corresponding error message
 *
 * @param ErrorName unique string for error event 
 * @param ErrorMessage message detailing the error encountered
 */
native event LogErrorMessage(string ErrorName, string ErrorMessage);

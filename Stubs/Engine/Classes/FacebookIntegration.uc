/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * This is the base class for Facebook integration (each platform has a subclass
 */
class FacebookIntegration extends PlatformInterfaceBase
	native(PlatformInterface)
	config(Engine);



enum EFacebookIntegrationDelegate
{
	FID_AuthorizationComplete,
	FID_FacebookRequestComplete,
	FID_WebRequestComplete,
};


/** The application ID to link to */
var config string AppID;

/** Username of the current user */
var string Username;

/** Id of the current user */
var string UserId;

/** Access token as retrieved from FB */
var string AccessToken;



/**
 * Perform any needed initialization
 */
native event bool Init();

/**
 * Starts the process of allowing the app to use Facebook
 */
native event bool Authorize();

/**
 * @return true if the app has been authorized by the current user
 */
native event bool IsAuthorized();

/**
 * Kicks off a generic web request (response will come via delegate call)
 *
 * @param URL The URL for the request, can be http or https (if the current platform supports sending https)
 * @param POSTPayload If specified, the request will use the POST method, and the given string will be the payload (as UTF8)
 */
native event WebRequest(string URL, string POSTPayload);

/**
 * Kicks off a Facebook GraphAPI request (response will come via delegate)
 *
 * @param GraphRequest The request to make (like "me/friends")
 */
native event FacebookRequest(string GraphRequest);

/**
 * Call this to disconnect from Facebook. Next time authorization happens, the auth webpage
 * will be shown again
 */
native event Disconnect();

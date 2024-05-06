/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class reads a set of files from Live/NP servers and uses it to
 * update the game.
 */
class IniLocPatcher extends Object
	native
	config(Engine);

/** Holds the list of files to download and their download state */
struct native IniLocFileEntry
{
	/** The file to read from the online service */
	var string Filename;
	/** Whether the file should be treated as unicode or not */
	var bool bIsUnicode;
	/** The state of that read */
	var EOnlineEnumerationReadState ReadState;
};

/** The list of files to request from the online service */
var config array<IniLocFileEntry> Files;

/** Cached access to the system interface */
var transient OnlineTitleFileInterface TitleFileInterface;

/**
 * Delegate fired when a file read from the network platform's title specific storage is complete
 *
 * @param bWasSuccessful whether the file read was successful or not
 * @param FileName the name of the file this was for
 */
delegate OnReadTitleFileComplete(bool bWasSuccessful,string FileName);

/**
 * Initializes the patcher, sets delegates, vars, etc.
 */
function Init()
{
	local OnlineSubsystem OnlineSub;
	local int Index;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		TitleFileInterface = OnlineSub.TitleFileInterface;
		if (TitleFileInterface != None)
		{
			// Set the callback for notifications of files completing
			TitleFileInterface.AddReadTitleFileCompleteDelegate(OnReadFileComplete);
		}
		else
		{
			// Mark all as failed to be read since there is no way to read them
			for (Index = 0; Index < Files.Length; Index++)
			{
				Files[Index].ReadState = OERS_Failed;
			}
		}
	}
}

/**
 * Reads the set of files from the online service
 */
function DownloadFiles()
{
	local int Index;

	// If there is online interface, then try to download the files
	if (TitleFileInterface != None)
	{
		// Iterate through files trying to download them
		for (Index = 0; Index < Files.Length; Index++)
		{
			// Kick off the read of that file if not already started or failed
			if (Files[Index].ReadState == OERS_NotStarted)
			{
				// If this is a loc file name, make sure we are getting the right language
				Files[Index].Filename = UpdateLocFileName(Files[Index].Filename);
				if (TitleFileInterface.ReadTitleFile(Files[Index].Filename))
				{
					Files[Index].ReadState = OERS_InProgress;
				}
				else
				{
					Files[Index].ReadState = OERS_Failed;
				}
			}
		}
	}
}

/**
 * Notifies us when the download of a file is complete
 *
 * @param bWasSuccessful true if the download completed ok, false otherwise
 * @param FileName the file that was downloaded (or failed to)
 */
function OnReadFileComplete(bool bWasSuccessful,string FileName)
{
	local int Index;
	local array<byte> FileData;

	// Iterate through files to verify that this is one that we requested
	for (Index = 0; Index < Files.Length; Index++)
	{
		if (Files[Index].Filename == FileName)
		{
			if (bWasSuccessful)
			{
				Files[Index].ReadState = OERS_Done;
				// Read the contents so that they can be processed
				if (TitleFileInterface.GetTitleFileContents(FileName,FileData) &&
					FileData.Length > 0)
				{
					ProcessIniLocFile(FileName,Files[Index].bIsUnicode,FileData);
				}
				else
				{
					Files[Index].ReadState = OERS_Failed;
				}
			}
			else
			{
				`Log("Failed to download the file ("$Files[Index].Filename$") from system interface");
				Files[Index].ReadState = OERS_Failed;
			}
		}
	}
}

/**
 * Takes the data, merges with the INI/Loc system, and then reloads the config for the
 * affected objects
 *
 * @param FileName the name of the file being merged
 * @param bIsUnicode whether the file should be treated as unicode or not
 * @param FileData the file data to merge with the config cache
 */
native function ProcessIniLocFile(string FileName,bool bIsUnicode,const out array<byte> FileData);

/**
 * Adds a loc/ini file to download
 *
 * @param FileName the file to download
 */
function AddFileToDownload(string FileName)
{
	local int FileIndex;

	FileIndex = Files.Find('FileName',FileName);
	// Don't add more than once
	if (FileIndex == INDEX_NONE)
	{
		// Add a new entry which will default to not started
		FileIndex = Files.Length;
		Files.Length = FileIndex + 1;
		Files[FileIndex].FileName = FileName;
		// Any file that is not INT or INI should be Unicode
		Files[FileIndex].bIsUnicode = InStr(FileName,".ini",,true) == INDEX_NONE && InStr(FileName,".int",,true) == INDEX_NONE;
	}
	else
	{
		Files[FileIndex].ReadState = OERS_NotStarted;
	}
	// Kick off the download
	DownloadFiles();
}

/**
 * Adds the specified delegate to the registered downloader. Since the file read can come from
 * different objects, this method hides that detail, but still lets callers get notifications
 *
 * @param ReadTitleFileCompleteDelegate the delegate to set
 */
function AddReadFileDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
	// Add the delegate if not None
	if (ReadTitleFileCompleteDelegate != None && TitleFileInterface != None)
	{
		// Set the callback for notifications of files completing
		TitleFileInterface.AddReadTitleFileCompleteDelegate(ReadTitleFileCompleteDelegate);
	}
}

/**
 * Clears the specified delegate from any registered downloaders
 *
 * @param ReadTitleFileCompleteDelegate the delegate to remove from the downloader
 */
function ClearReadFileDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
	if (ReadTitleFileCompleteDelegate != None && TitleFileInterface != None)
	{
		TitleFileInterface.ClearReadTitleFileCompleteDelegate(ReadTitleFileCompleteDelegate);
	}
}

/**
 * Tells any subclasses to clear their cached file data
 */
function ClearCachedFiles()
{
	local int Index;

	// Iterate through files trying to download them
	for (Index = 0; Index < Files.Length; Index++)
	{
		// Reset their status
		Files[Index].ReadState = OERS_NotStarted;
	}

	if (TitleFileInterface != None)
	{
		TitleFileInterface.ClearDownloadedFiles();
	}
}

/**
 * Gets the proper language extension for the loc file
 *
 * @param FileName the file name being modified
 *
 * @return the modified file name for this language setting
 */
native function string UpdateLocFileName(string FileName);
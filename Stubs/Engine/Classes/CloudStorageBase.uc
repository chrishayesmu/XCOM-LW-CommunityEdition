/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * This is the base class for the various platform interface classes
 */
 
class CloudStorageBase extends PlatformInterfaceBase
	native(PlatformInterface);


/** All the types of delegate callbacks that a CloudStorage subclass may receive from C++ */
enum ECloudStorageDelegate
{
	// @todo: Fill in the result descriptions for these guys (and the other PI subclasses)
	CSD_KeyValueReadComplete,
	CSD_KeyValueWriteComplete,
	CSD_ValueChanged,
	CSD_DocumentQueryComplete,
	CSD_DocumentReadComplete,
	CSD_DocumentWriteComplete,
	
	// Data:Document index that has the conflict
	// Type:Int
	// Desc:Called when multiple machines have 
	//      updated the document, and script needs to determine which one to use, via the Resolve*
	//      functions
	CSD_DocumentConflictDetected, 
};


/**
 * Perform any initialization
 */
native event Init();

/**
 * Initiate reading a key/value pair from cloud storage. A CSD_KeyValueReadComplete
 * delegate will be called when it completes (if this function returns true)
 * 
 * @param KeyName String name of the key to retrieve
 * @param Type Type of data to retrieve 
 * @param SerializedObj If you are reading an object (PIDT_Object), it will de-serialize the binary blob into this object
 *
 * @return True if successful
 */
native event bool ReadKeyValue(string KeyName, EPlatformInterfaceDataType Type, optional Object SerializedObj);

/**
 * Write a key/value pair to the cloud. A CSD_KeyValueWriteComplete
 * delegate will be called when it completes (if this function returns true)
 *
 * @param KeyName String name of the key to write
 * @param Value The type and value to write
 *
 * @return True if successful
 */
native event bool WriteKeyValue(string KeyName, const out PlatformInterfaceData Value);


/**
 * Kick off an async query of documents that exist in the cloud. If any documents have
 * already been retrieved, this will flush those documents, and refresh the set. A
 * CSD_DocumentQueryComplete delegate will be called when it completes  (if this 
 * function returns true). Then use GetNumCloudDocuments() and GetCloudDocumentName() 
 * to get the information about any existing documents.
 *
 * @return True if successful
 */
native event bool QueryForCloudDocuments();

/**
 * @return the number of documents that are known to exist in the cloud
 */
native event int GetNumCloudDocuments(optional bool bIsForConflict);

/**
 * @return the name of the given cloud by index (up to GetNumCloudDocuments() - 1)
 */
native event string GetCloudDocumentName(int Index);

/**
 * Create a new document in the cloud (uninitialized, unsaved, use the Write/Save functions)
 *
 * @param Filename Filename for the cloud document (with any extension you want)
 * 
 * @return Index of the new document, or -1 on failure
 */
native event int CreateCloudDocument(string Filename);





/**
 * Reads a document into memory (or whatever is needed so that the ParseDocumentAs* functions
 * operate synchronously without stalling the game). A CSD_DocumentReadComplete delegate
 * will be called (if this function returns true).
 *
 * @param Index index of the document to read
 *
 * @param True if successful
 */
native event bool ReadCloudDocument(int Index, optional bool bIsForConflict);

/**
 * Once a document has been read in, use this to return a string representing the 
 * entire document. This should only be used if SaveDocumentWithString was used to
 * generate the document.
 *
 * @param Index index of the document to read
 *
 * @return The document as a string. It will be empty if anything went wrong.
 */
native event string ParseDocumentAsString(int Index, optional bool bIsForConflict);

/**
 * Once a document has been read in, use this to return a string representing the 
 * entire document. This should only be used if SaveDocumentWithString was used to
 * generate the document.
 *
 * @param Index index of the document to read
 * @param ByteData The array of bytes to be filled out. It will be empty if anything went wrong
 */
native event ParseDocumentAsBytes(int Index, out array<byte> ByteData, optional bool bIsForConflict);

/**
 * Once a document has been read in, use this to return a string representing the 
 * entire document. This should only be used if SaveDocumentWithString was used to
 * generate the document.
 *
 * @param Index index of the document to read
 * @param ExpectedVersion Version number expected to be in the save data. If this doesn't match what's there, this function will return NULL
 * @param ObjectClass The class of the object to create
 *
 * @return The object deserialized from the document. It will be none if anything went wrongs
 */
native event object ParseDocumentAsObject(int Index, class ObjectClass, int ExpectedVersion, optional bool bIsForConflict);




/**
 * Writes a document that has been already "saved" using the SaveDocumentWith* functions.
 * A CSD_DocumentWriteComplete delegate will be called (if this function returns true).
 *
 * @param Index index of the document to read
 *
 * @param True if successful
 */
native event bool WriteCloudDocument(int Index);

/**
 * Prepare a document for writing to the cloud with a string as input data. This is
 * synchronous
 *
 * @param Index index of the document to save
 * @param StringData The data to put into the document
 *
 * @param True if successful
 */
native event bool SaveDocumentWithString(int Index, string StringData);

/**
 * Prepare a document for writing to the cloud with an array of bytes as input data. This is
 * synchronous
 *
 * @param Index index of the document to save
 * @param ByteData The array of generic bytes to put into the document
 *
 * @param True if successful
 */
native event bool SaveDocumentWithBytes(int Index, array<byte> ByteData);

/**
 * Prepare a document for writing to the cloud with an object as input data. This is
 * synchronous
 *
 * @param Index index of the document to save
 * @param ObjectData The object to serialize to bytes and put into the document
 *
 * @param True if successful
 */
native event bool SaveDocumentWithObject(int Index, object ObjectData, int SaveVersion);




/**
 * If there was a conflict notification, this will simply tell the cloud interface
 * to choose the most recently modified version, and toss any others
 */
native event bool ResolveConflictWithNewestDocument();

/**
 * If there was a conflict notification, this will tell the cloud interface
 * to choose the version with a given Index to be the master version, and to
 * toss any others
 *
 * @param Index Conflict version index
 */
native event bool ResolveConflictWithVersionIndex(int Index);
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * This is the base class for per-platform microtransaction support
 */
 
class MicroTransactionBase extends PlatformInterfaceBase
	native(PlatformInterface);


/** All the types of delegate callbacks that a MicroTransaction subclass may receive from C++ */
enum EMicroTransactionDelegate
{
	// Data:None
	// Desc:QueryForAvailablePurchases() is complete and AvailableProducts is ready for use
	MTD_PurchaseQueryComplete,

	// Data:Result code, and identifier of the product that completed
	// Type:Custom
	// Desc:IntValue will have one of the enums in EMicroTransactionResult, and StringValue
	//      will have the Identifier from the PurchaseInfo that was bought with BeginPurchase
	//      If MTR_Failed was returned, then LastError and LastErrorSolution should be filled
	//		out with the most recent localized and possible resolutions
	MTD_PurchaseComplete,
};

/** Result of a purchase */
enum EMicroTransactionResult
{
	MTR_Succeeded,
	MTR_Failed,
	MTR_Canceled,
	MTR_RestoredFromServer,
};

// enum EPurchaseType
// {
// 	MTPT_Consumable,
// 	MTPT_OneTime,
// 	MTPT_Subscription,
// };

/**
 * Purchase information structure
 */
struct native PurchaseInfo
{
// 	/** What kind of microtransaction purchase is this? */
// 	var EPurchaseType Type;

	/** Unique identifier for the purchase */
	var string Identifier;

	/** Name displayable to the user */
	var string DisplayName;

	/** Description displayable to the user */
	var string DisplayDescription;

	/** Price displayable to the user */
	var string DisplayPrice;
};

/** The list of products available to purchase, filled out by the time a MTD_PurchaseQueryComplete is fired */
var array<PurchaseInfo> AvailableProducts;

/** In case of errors, this will describe the most recent error */
var string LastError;

/** In case of errors, this will describe possible solutions (if there are any) */
var string LastErrorSolution;

/**
 * Perform any initialization
 */
native event Init();


/**
 * Query system for what purchases are available. Will fire a MTD_PurchaseQueryComplete
 * if this function returns true.
 *
 * @return True if the query started successfully (delegate will receive final result)
 */
native event bool QueryForAvailablePurchases();

/**
 * @return True if the user is allowed to make purchases - should give a nice message if not
 */
native event bool IsAllowedToMakePurchases();

/**
 * Triggers a product purchase. Will fire a MTF_PurchaseComplete if this function
 * returns true.
 *
 * @param Index which product to purchase
 * 
 * @param True if the purchase was kicked off (delegate will receive final result)
 */
native event bool BeginPurchase(int Index);


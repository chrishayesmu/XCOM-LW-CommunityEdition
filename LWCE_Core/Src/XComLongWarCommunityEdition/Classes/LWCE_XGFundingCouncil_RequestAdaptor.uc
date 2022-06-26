class LWCE_XGFundingCouncil_RequestAdaptor extends XGFundingCouncil_RequestAdaptor
    implements(LWCE_IFCRequestInterface)
    dependson(LWCE_XGFundingCouncil);

simulated function GetRequestData(out TFCRequest kRequestRef)
{
    `LWCE_LOG_DEPRECATED_CLS(GetRequestData);
}

simulated function LWCE_GetRequestData(out LWCE_TFCRequest kRequestRef)
{
    LWCE_XGFundingCouncil(Outer).LWCE_GetCompletedSatRequestData(kRequestRef);
}
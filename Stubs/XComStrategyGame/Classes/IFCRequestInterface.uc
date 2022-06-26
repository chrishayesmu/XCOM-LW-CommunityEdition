interface IFCRequestInterface extends Interface
    dependson(XGFundingCouncil);

simulated function GetRequestData(out TFCRequest kRequestData){}
simulated function bool OnAcceptRequest(){}
simulated function bool OnCancelRequest(){}
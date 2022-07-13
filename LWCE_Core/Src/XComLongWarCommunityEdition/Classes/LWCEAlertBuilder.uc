class LWCEAlertBuilder extends Object
    dependson(LWCE_XGGeoscape);

var private LWCE_TGeoscapeAlert Data;

static function LWCEAlertBuilder NewAlert(name AlertType)
{
    local LWCEAlertBuilder kBuilder;

    kBuilder = new (none) class'LWCEAlertBuilder';
    kBuilder.Data.AlertType = AlertType;

    return kBuilder;
}

function LWCEAlertBuilder AddBool(bool Value)
{
    local LWCE_TData kAlertData;

    kAlertData.eType = eDT_Bool;
    kAlertData.bData = Value;

    Data.arrData.AddItem(kAlertData);

    return self;
}

function LWCEAlertBuilder AddInt(int Value)
{
    local LWCE_TData kAlertData;

    kAlertData.eType = eDT_Int;
    kAlertData.iData = Value;

    Data.arrData.AddItem(kAlertData);

    return self;
}

function LWCEAlertBuilder AddName(name Value)
{
    local LWCE_TData kAlertData;

    kAlertData.eType = eDT_Name;
    kAlertData.nmData = Value;

    Data.arrData.AddItem(kAlertData);

    return self;
}

function LWCEAlertBuilder AddString(string Value)
{
    local LWCE_TData kAlertData;

    kAlertData.eType = eDT_String;
    kAlertData.strData = Value;

    Data.arrData.AddItem(kAlertData);

    return self;
}

function LWCE_TGeoscapeAlert Build()
{
    return Data;
}
class LWCEAlertBuilder extends Object
    dependson(LWCE_XGGeoscape);

var private LWCE_TGeoscapeAlert Data;

static function LWCEAlertBuilder NewAlert(name AlertType)
{
    local LWCEAlertBuilder kBuilder;

    kBuilder = new (none) class'LWCEAlertBuilder';
    kBuilder.Data.AlertType = AlertType;
    kBuilder.Data.kData = class'LWCEDataContainer'.static.New(AlertType);

    return kBuilder;
}

function LWCEAlertBuilder AddBool(bool Value)
{
    Data.kData.AddBool(Value);

    return self;
}

function LWCEAlertBuilder AddInt(int Value)
{
    Data.kData.AddInt(Value);

    return self;
}

function LWCEAlertBuilder AddName(name Value)
{
    Data.kData.AddName(Value);

    return self;
}

function LWCEAlertBuilder AddString(string Value)
{
    Data.kData.AddString(Value);

    return self;
}

function LWCE_TGeoscapeAlert Build()
{
    return Data;
}
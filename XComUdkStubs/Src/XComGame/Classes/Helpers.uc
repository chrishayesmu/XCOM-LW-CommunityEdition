class Helpers extends Object
    abstract
    native;

struct native ProjectPathPredictionPoint
{
    var transient float Time;
    var transient Vector Location;
    var transient Vector Velocity;
};

struct native CamCageResult
{
    var int iCamZoneID;
    var int iCamZoneBlocked;
};
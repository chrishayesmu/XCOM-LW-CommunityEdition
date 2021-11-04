class XComProfileGrid extends Actor
    transient
    native;
//complete stub

struct native StatItem
{
    var IntPoint Tile;
    var float Fps;
    var float MS;
};


var transient float LocalTime;
var transient float DelayTime;
var transient int Index;
var transient int Heading;
var transient int Pitch;
var transient int Roll;
var transient float FOV;
var array<StatItem> StatItems;

simulated function Update(float dt);
native function SaveStatItems(string Filename);

simulated event Tick(float dt){}
function SetCamera(Vector pos){}

auto state Idle{}

state Processing{
    simulated function Update(float dt){}
}

state Complete{
    simulated event BeginState(name PrevStateName){}
}

defaultproperties
{
    DelayTime=0.050
    Heading=27693
    Pitch=-8563
    FOV=70.0
}

class XComColorWarper extends Object
    native;

enum EColorAdjustType
{
    eColorAdj_Set,
    eColorAdj_Pulse,
    eColorAdj_MAX
};

var Color CurrentColor;
var Color Color0;
var Color Color1;
var XComColorWarper.EColorAdjustType ColorType;

defaultproperties
{
    CurrentColor=(R=0,G=0,B=0,A=255)
    Color0=(R=0,G=0,B=0,A=255)
    Color1=(R=0,G=0,B=0,A=255)
}
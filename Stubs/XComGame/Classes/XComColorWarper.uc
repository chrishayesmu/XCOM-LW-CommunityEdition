class XComColorWarper extends Object
    native;
//complete stub

enum EColorAdjustType
{
    eColorAdj_Set,
    eColorAdj_Pulse,
    eColorAdj_MAX
};

var Color CurrentColor;
var Color Color0;
var Color Color1;
var EColorAdjustType ColorType;

function SetColorImmediate(Color TheColor){}
function PulseToColorRepeatedly(Color TheColor0, Color TheColor1, float TotalDuration){}
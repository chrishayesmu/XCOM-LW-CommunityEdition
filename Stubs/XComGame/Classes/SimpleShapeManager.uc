class SimpleShapeManager extends Actor
    notplaceable
    hidecategories(Navigation);

struct ShapePair
{
    var bool bDestroy;
    var bool bPersistent;
    var DynamicSMActor_Spawnable Shape;

};

var array<ShapePair> mShapes;

final function ShapePair AddShape(StaticMesh StaticMesh, bool bPersistent){}
function DrawSphere(Vector Position, Vector Scale3D, optional LinearColor C, optional bool bPersistent){}
function DrawBox(Vector Position, Vector Scale3D, optional LinearColor C, optional bool bPersistent){}
function DrawCylinder(Vector Start, Vector End, float Radius, optional LinearColor C, optional float FlattenScale, optional bool bPersistent){}
function DrawMultiCylinder(Vector Start, Vector End, float Radius, array<float> arrTransitions, array<LinearColor> arrColors, optional bool bBlendColors, optional float FlattenScale, optional bool bPersistent){}
function DrawLine(Vector Start, Vector End, float Thickness, optional LinearColor C, optional float FlattenScale, optional bool bPersistent){}
function DrawCone(Vector Start, Vector End, float Theta, optional LinearColor C, optional float FlattenScale, optional bool bPersistent, optional bool bSweepAnimation){}
function DrawMultiCone(Vector Start, Vector End, float Theta, array<float> arrTransitions, array<LinearColor> arrColors, optional bool bBlendColors, optional float FlattenScale, optional bool bPersistent, optional bool bSweepAnimation){}
function UpdateMultiMaterial(MaterialInstance MInst, array<float> arrTransitions, array<LinearColor> arrColors, LinearColor PositionMask, bool bBlendColors, bool bSweepAnimation){}
function FlushPersistentShapes(){}
function Tick(float fDeltaTime){}
function DynamicSMActor_Spawnable CreateCone(Vector vEnd, Vector vStart, float fRadius, float fHeight, Color clrCone){}
function DynamicSMActor_Spawnable CreateCylinder(Vector vCenter, float fRadius, float fHeight, Color clrCylinder){}

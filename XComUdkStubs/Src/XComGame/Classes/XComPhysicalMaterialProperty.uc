// The real XComPhysicalMaterialProperty extends PhysicalMaterialPropertyBase, which is a native abstract class
// defined by the engine. Since we can't implement the native portions of it, trying to use that class will result
// in the editor crashing. However, it defines no native data, and doesn't seem to have anything that a normal Object
// wouldn't have. Therefore for the UDK, we just define our own non-native class deriving from Object.
// TODO this doesn't seem to work; the PhysicalMaterial is now holding something that seems invalid
class XComPhysicalMaterialProperty extends Object
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() EMaterialType MaterialType;
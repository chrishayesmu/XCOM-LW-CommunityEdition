class XComHUD extends HUD
    transient
    config(Game)
    hidecategories(Navigation);

var privatewrite Vector CachedCameraWorldOrigin;
var privatewrite Vector CachedCameraWorldDirection;
var privatewrite Vector CachedMouseWorldOrigin;
var privatewrite Vector CachedMouseWorldDirection;
var protectedwrite Vector CachedHitLocation;
var privatewrite IMouseInteractionInterface CachedMouseInteractionInterface;
var privatewrite MaterialInstanceConstant GammaLogo;
var privatewrite bool bEnableGammaLogoDrawing;
var bool bEnableLoadingTexture;
var privatewrite IMouseInteractionInterface CachedMouseInteractionInterface_Inter;
var privatewrite Vector2D ViewSize;
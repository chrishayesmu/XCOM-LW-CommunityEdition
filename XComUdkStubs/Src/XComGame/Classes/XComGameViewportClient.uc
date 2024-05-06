class XComGameViewportClient extends GameViewportClient within Engine
    transient
    native
    config(Engine);

var delegate<TouchedCallback> m_touchedDelegate;

delegate TouchedCallback()
{
}
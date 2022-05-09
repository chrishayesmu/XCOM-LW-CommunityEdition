class LWCEUIWidget extends GFxObject;

function float GetX()
{
    return GetFloat("_x");
}

function float GetY()
{
    return GetFloat("_y");
}

function SetX(float fX)
{
    SetFloat("_x", fX);
}

function SetY(float fY)
{
    SetFloat("_y", fY);
}
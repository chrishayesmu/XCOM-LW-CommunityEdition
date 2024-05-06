class XComCursorVolume extends Volume
    native
    hidecategories(Navigation,Movement,Display);

var() const int m_iFloorNumber;
var() const bool m_bTreatAsStair;
var() const bool m_bIgnoreHoles;
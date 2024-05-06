class XGLayout extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

const VALIDATE_RADIUS = 1440;

struct CheckpointRecord
{
    var array<TBuilding> m_arrBuildings;
    var Box m_kBounds;
    var array<TMapSection> m_arrSections;
    var int m_iNumSectionRows;
    var int m_iNumSectionColumns;
    var float m_fSectionWidth;
    var float m_fSectionHeight;
};

var array<TBuilding> m_arrBuildings;
var Box m_kBounds;
var array<TMapSection> m_arrSections;
var int m_iNumSectionRows;
var int m_iNumSectionColumns;
var float m_fSectionWidth;
var float m_fSectionHeight;
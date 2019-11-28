
class Scrollbar
{
  Rectangle m_bg = new Rectangle();
  Rectangle m_fg = new Rectangle();

  float m_scroll = 0.0f;
  float m_scrollMax = 0.0f;
  float m_scrollRatio = 0.0f;
  float m_scrollbarBGHeight = 1.0f;
  float m_scrollbarFGHeight = 1.0f;
  final float m_scrollSpeed = 50;

  float getYDisplacement()
  {
    return m_scroll;
  }

  boolean isMouseOver()
  {
    return m_bg.isMouseOver();
  }

  // Check
  boolean isNeeded()
  {
    return (m_scrollbarFGHeight < m_scrollbarBGHeight);
  }
  float getRequiredWidth()
  {
    return isNeeded() ? m_bg.w() : 0;
  }

  void updateScroll(float direction)
  {
    m_scroll += direction * m_scrollSpeed;
    m_scroll = constrain(m_scroll, 0, m_scrollMax);

    if (m_scrollMax == 0.0)
      m_scrollRatio = 1.0;
    else
      m_scrollRatio = m_scroll / m_scrollMax;
  }

  void setSize(float x, float y, float w, float h, float compareHeight)
  {
    m_scrollbarBGHeight = h;
    m_scrollbarFGHeight = min(m_scrollbarBGHeight / compareHeight, 1) * m_scrollbarBGHeight;
  
    m_scrollMax = max(0, compareHeight - m_scrollbarBGHeight);

    m_bg.set(x, y, w, h, 0);

    m_fg.set(
      x, 
      y + m_scrollRatio * (h - m_scrollbarFGHeight), 
      w, 
      m_scrollbarFGHeight, 
      0
      );
  }
  void draw()
  {
    m_bg.draw(COLOR_DARK_GREY);
    m_fg.draw(COLOR_WHITE_FAINT);
  }
}

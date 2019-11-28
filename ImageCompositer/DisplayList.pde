
class DisplayList
{
  Rectangle rec_title = new Rectangle();
  Rectangle rec_bg = new Rectangle();

  Scrollbar scrollbar = new Scrollbar();

  ArrayList<String> m_lines = new ArrayList<String>();
  int m_selectedLineIndex = -1;
  boolean m_ignoreDuplicate = true;

  void add(String str)
  {
    if(m_ignoreDuplicate)
    {
      for(int i = 0; i < m_lines.size(); i++)
      {
        if(m_lines.get(i).equals(str))
          return;
      }
    }
    
    m_lines.add(str);
  }
  void unselect()
  {
    m_selectedLineIndex = -1;
  }
  String getSelection()
  {
    if (m_selectedLineIndex == -1)
      return "";

    return m_lines.get(m_selectedLineIndex);
  }
  void eraseSelection()
  {
    if (m_selectedLineIndex == -1)
      return;

    m_lines.remove(m_selectedLineIndex);
    m_selectedLineIndex = -1;
  }

  float rowHeight()
  {
    return TextSize + 5;
  }

  void setBG(float x, float y, float w, float h)
  {
    float padding = PaddingFG + PaddingBG;
    rec_title.set(x, y, w, rowHeight() + padding, padding);
    rec_bg.set(x, y + rowHeight(), w, h - rowHeight() + PaddingBG - PaddingFG/2, padding);

    scrollbar.setSize(x + w - padding/2 - SCROLLBAR_WIDTH, y + rowHeight() + padding/2, SCROLLBAR_WIDTH, rec_bg.h(), rowHeight() * m_lines.size());
    scrollbar.updateScroll(0);
  }

  void updateScroll(float direction)
  {
    if (rec_bg.isMouseOver() || scrollbar.isMouseOver())
    {
      scrollbar.updateScroll(direction);
    }
  }

  void update()
  {
    // Seleciton Removal
    if (mousePressed)
    {
      unselect();

      for (int i = 0; i < m_lines.size(); i++)
      {
        Rectangle r = new Rectangle(
          rec_bg.x(), rec_bg.y() + (i * rowHeight()) - scrollbar.getYDisplacement(), 
          rec_bg.w(), rowHeight(), 
          0
          );

        if (r.isMouseOver())
        {
          m_selectedLineIndex = i;
          break;
        }
      }
    }
  }
  void draw()
  {
    rec_title.draw(COLOR_WHITE_FAINT);

    // Draw Title
    rec_title.maskArea();
    fill(0);
    setFontBold(true);
    text("Export Sizes:", rec_title.x() + 4, rec_title.y() + TextSize);
    setFontBold(false);
    noClip();

    // Draw BG
    rec_bg.draw(COLOR_DARK_GREY);

    // Draw Lists of text
    rec_bg.maskArea();
    for (int i = 0; i < m_lines.size(); i++)
    {
      Rectangle r = new Rectangle(
        rec_bg.x(), rec_bg.y() + (i * rowHeight()) - scrollbar.getYDisplacement(), 
        rec_bg.w(), rowHeight(), 
        0
        );

      if (r.isMouseOver())
      {
        if (MousePressed)
          m_selectedLineIndex = i;

        r.draw(COLOR_MID_GREY);
        if (m_selectedLineIndex == i)
          fill(COLOR_YELLOW);
        else
          fill(COLOR_ORANGE);
      }
      //
      else
      {
        if (m_selectedLineIndex == i)
        {
          r.draw(COLOR_LIGHT_GREY);
          fill(COLOR_YELLOW);
        } else
        {
          r.draw(COLOR_BLACK);
          fill(COLOR_WHITE_FAINT);
        }
      }
      //
      text(m_lines.get(i), rec_bg.x() + 4, rec_bg.y() + (i * rowHeight()) + TextSize - scrollbar.getYDisplacement());
    }
    noClip();

    // Draw Scrollbar
    scrollbar.draw();
  }
}

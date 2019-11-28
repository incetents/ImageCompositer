
class InputBox
{
  Rectangle rec_bg = new Rectangle();
  String m_text = "";
  boolean m_selected = false;
  boolean m_numbersOnly = false;
  int m_characterLimit = -1;
  boolean m_locked = false;

  void setSize(float x, float y, float w, float h, float padding)
  {
    rec_bg.set(x, y, w, h, padding);
  }

  float x()
  {
    return rec_bg.x();
  }
  float y()
  {
    return rec_bg.y();
  }
  float w()
  {
    return rec_bg.w();
  }
  float h()
  {
    return rec_bg.h();
  }

  void unselect()
  {
    m_selected = false;
  }

  void updateInput(char c)
  {
    if (!m_selected || m_locked)
      return;

    // Input limit
    if (m_text.length() == m_characterLimit)
      return;

    // Numbers only [ignore character and 0 if first character
    if (m_numbersOnly && (!Character.isDigit(c) || (m_text.length() == 0 && c == '0')))
      return;

    m_text += c;
  }
  void eraseInput()
  {
    if (m_text == null || !m_selected || m_text.length() == 0)
      return;

    m_text = m_text.substring(0, m_text.length() - 1);
  }

  void update()
  {
    if (mousePressed && !m_locked)
    {
      unselect();

      if (rec_bg.isMouseOver())
        m_selected = true;
    }
  }
  void draw()
  {
    // BG
    if (m_selected)
      stroke(COLOR_YELLOW);
    else
      stroke(0);

    if (m_locked)
      rec_bg.draw(COLOR_DARK_GREY);
    else if (rec_bg.isMouseOver())
      if (mousePressed)
        rec_bg.draw(COLOR_MID_GREY);
      else
        rec_bg.draw(COLOR_LIGHT_GREY);
    else
      rec_bg.draw(COLOR_WHITE_FAINT);

    noStroke();

    // Text
    fill(0);
    rec_bg.maskArea();
    text(m_text, rec_bg.x() + 2, rec_bg.y() + TextSize);
    noClip();

    // Input Vertical Line
    if (m_selected && (floor(millis() / 500.0) % 2 == 0))
    {
      noFill();
      stroke(0);
      float textW = textWidth(m_text);
      line(rec_bg.x() + textW  + 2, rec_bg.y(), rec_bg.x() + textW  + 2, rec_bg.y() + rec_bg.h());
      noStroke();
    }
  }
}

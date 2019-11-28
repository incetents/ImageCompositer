
class Rectangle
{
  float[] m_data = {0, 0, 0, 0};
  float m_padding = 0;
  Rectangle()
  {
  }
  Rectangle(float x, float y, float w, float h, float padding)
  {
    set(x,y,w,h,padding);
  }
  void set(float x, float y, float w, float h, float padding)
  {
    m_data[0] = x;
    m_data[1] = y;
    m_data[2] = w;
    m_data[3] = h;
    m_padding = padding;
  }
  float x_nopadding() { 
    return m_data[0];
  }
  float y_nopadding() { 
    return m_data[1];
  }
  float w_nopadding() { 
    return m_data[2];
  }
  float h_nopadding() { 
    return m_data[3];
  }
  float x(){
    return m_data[0] + m_padding/2;
  }
  float y(){
    return m_data[1] + m_padding/2;
  }
  float w(){
    return m_data[2] - m_padding;
  }
  float h(){
    return m_data[3] - m_padding;
  }
  
  // [0,1] of where the MouseX is on the rectangle
  float mouseXHoverRatio()
  {
    return constrain((mouseX - x()) / w(), 0, 1);
  }
  // [0,1] of where the MouseY is on the rectangle
  float mouseYHoverRatio()
  {
    return constrain((mouseX - y()) / h(), 0, 1);
  }
  
  boolean isMouseOver()
  {
    return (
      mouseX >= (m_data[0] + m_padding/2) && mouseX < (m_data[0] + m_data[2] - m_padding/2) &&
      mouseY >= (m_data[1] + m_padding/2) && mouseY < (m_data[1] + m_data[3] - m_padding/2)
      );
  }
  void maskArea()
  {
    clip(m_data[0] + m_padding/2, m_data[1] + m_padding/2, m_data[2] - m_padding, m_data[3] - m_padding);
  }
  void draw(color c)
  {
    fill(c);
    rect(m_data[0] + m_padding/2, m_data[1] + m_padding/2, m_data[2] - m_padding, m_data[3] - m_padding);
  }
  void draw()
  {
    rect(m_data[0] + m_padding/2, m_data[1] + m_padding/2, m_data[2] - m_padding, m_data[3] - m_padding);
  }
}

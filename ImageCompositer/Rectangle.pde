
class Rectangle
{
  float[] data = {0, 0, 0, 0};
  Rectangle()
  {
  }
  Rectangle(float x, float y, float w, float h)
  {
    set(x,y,w,h);
  }
  void set(float x, float y, float w, float h)
  {
    data[0] = x;
    data[1] = y;
    data[2] = w;
    data[3] = h;
  }
  float x() { 
    return data[0];
  }
  float y() { 
    return data[1];
  }
  float w() { 
    return data[2];
  }
  float h() { 
    return data[3];
  }
  boolean isMouseOver()
  {
    return (
      mouseX >= data[0] && mouseX < (data[0] + data[2]) &&
      mouseY >= data[1] && mouseY < (data[1] + data[3])
      );
  }
  void maskArea()
  {
    clip(data[0], data[1], data[2], data[3]);
  }
  void draw()
  {
    rect(data[0], data[1], data[2], data[3]);
  }
}

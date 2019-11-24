
class Rectangle
{
  float[] data = {0, 0, 0, 0};
  float padding = 0;
  Rectangle()
  {
  }
  Rectangle(float x, float y, float w, float h, float _padding)
  {
    set(x,y,w,h,_padding);
  }
  void set(float x, float y, float w, float h, float _padding)
  {
    data[0] = x;
    data[1] = y;
    data[2] = w;
    data[3] = h;
    padding = _padding;
  }
  float x_nopadding() { 
    return data[0];
  }
  float y_nopadding() { 
    return data[1];
  }
  float w_nopadding() { 
    return data[2];
  }
  float h_nopadding() { 
    return data[3];
  }
  float x(){
    return data[0] + padding/2;
  }
  float y(){
    return data[1] + padding/2;
  }
  float w(){
    return data[2] - padding;
  }
  float h(){
    return data[3] - padding;
  }
  
  boolean isMouseOver()
  {
    return (
      mouseX >= (data[0] + padding/2) && mouseX < (data[0] + data[2] - padding/2) &&
      mouseY >= (data[1] + padding/2) && mouseY < (data[1] + data[3] - padding/2)
      );
  }
  void maskArea()
  {
    clip(data[0] + padding/2, data[1] + padding/2, data[2] - padding, data[3] - padding);
  }
  void draw()
  {
    rect(data[0] + padding/2, data[1] + padding/2, data[2] - padding, data[3] - padding);
  }
}

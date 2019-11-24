
// Button IDS
enum ButtonID
{
  NONE, 
    ADD_FILE_TO_MASTERLIST, 
    ADD_FOLDER_TO_MASTERLIST, 
    ADD_IMAGE_LAYER,
    EXPORT_IMAGES
}
// Master Button Request
ButtonID ButtonRequest = ButtonID.NONE;

class Button_Square extends Rectangle
{
  ButtonID _id = ButtonID.NONE;
  color _color_normal = color(200);
  color _color_highlighted = color(255);
  color _color_pressed = color(100);
  boolean _outline = true;
  color _color_outline = color(0);
  Image _image = null;
  private String _text;
  private float _width = -1;
 // private boolean _pressed = false;
  private boolean _released = false;

  Button_Square(ButtonID id, String text)
  {
    _id = id;
    _text = text;
  }
  float width()
  {
    if (_width == -1)
    {
      setFontBold(true);
      _width = textWidth(_text) + 5;
      setFontBold(false);
    }
    return _width;
  }
  void setColors(color normal, color highlighted, color pressed)
  {
    _color_normal = normal;
    _color_highlighted = highlighted;
    _color_pressed = pressed;
  }

  boolean isPressed()
  {
    return isMouseOver() && MouseReleased;
  }

  void draw()
  {
    boolean _pressed = isMouseOver() && mousePressed;
    
    if (_outline)
    {
      stroke(_color_outline);
      strokeWeight(1);
    }
    //
    else
      noStroke();

    if (_image == null)
    {
      // Square
      if (isMouseOver())
        if (_pressed)
          super.draw(_color_pressed);
        else
          super.draw(_color_highlighted);
      else
        super.draw(_color_normal);
    }
    //
    else
    {
      if (isMouseOver())
        if (_pressed)
          tint(65);
        else
          tint(160);
      else
        tint(255);
      _image.draw(x(), y(), w(), h());
      tint(255);
    }

    // Text
    if (_text.length() > 0)
    {
      fill(0);
      setFontBold(true);
      text(_text, x() + 2, y() + TextSize);
      setFontBold(false);
    }

    if (_outline)
      noStroke();
  }
}

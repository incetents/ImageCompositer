
enum LayerType
{
  MASTER, 
    IMAGE
}

class Layer
{
  private final float LayerIconPadding = 8;

  String        m_name;
  LayerType     m_type;
  Image         m_image = null;
  Button_Square m_button_visible = new Button_Square(ButtonID.NONE, "");
  Button_Square m_button_moveUp = new Button_Square(ButtonID.NONE, "");
  Button_Square m_button_moveDown = new Button_Square(ButtonID.NONE, "");
  boolean       m_enabled = true;

  Layer(String _name, LayerType _type, String _filePath)
  {
    m_name = _name;
    m_type = _type;
    if (_type == LayerType.IMAGE)
    {
      if (_filePath.length() > 0)
        m_image = new Image(_filePath);
    } else
    {
      m_image = new Image();
    }
  }
  void update()
  {
    if ((m_image == null || m_image.m_image == null) && m_type == LayerType.IMAGE)
      m_button_visible._image = image_editor_eyeClosed;
    else if (m_enabled)
      m_button_visible._image = image_editor_eyeOpen;
    else
      m_button_visible._image = image_editor_eyeClosed;

    m_button_moveUp._image = image_editor_up;
    m_button_moveDown._image = image_editor_down;
  }
  void draw(Rectangle bg_rect, boolean selected)
  {
    float alpha = 255;

    if (m_image == null || m_image.m_image == null || !m_enabled)
      alpha = 60;

    // BG
    if (selected)
      fill(COLOR_ORANGE_LIGHT, alpha);
    else if (bg_rect.isMouseOver())
      fill(COLOR_YELLOW, alpha);
    else
      fill(COLOR_WHITE_FAINT, alpha);

    // BG
    stroke(0);
    bg_rect.draw();

    // Icon
    if (m_image != null && m_image.m_image != null)
    {
      m_image.draw(
        bg_rect.x() + LayerIconPadding/2, 
        bg_rect.y() + LayerIconPadding/2, 
        bg_rect.h() - LayerIconPadding, 
        bg_rect.h() - LayerIconPadding
        );
    }

    // Outline
    noFill();
    stroke(0, 100);
    rect(
      bg_rect.x() + LayerIconPadding/2, 
      bg_rect.y() + LayerIconPadding/2, 
      bg_rect.h() - LayerIconPadding, 
      bg_rect.h() - LayerIconPadding
      );

    // Name
    fill(0);
    text(m_name, bg_rect.x() + bg_rect.h(), bg_rect.y() + bg_rect.h()/2 + 0);

    // Button
    noStroke();
    stroke(255);
    float buttonHeight = bg_rect.h() / 3;

    // Buttons // Auto disable if no image and in Image mode

    m_button_moveUp.set(
      bg_rect.x() + bg_rect.w() - buttonHeight, 
      bg_rect.y(), 
      buttonHeight, buttonHeight, 
      0
      );

    m_button_visible.set(
      bg_rect.x() + bg_rect.w() - buttonHeight, 
      bg_rect.y() + buttonHeight, 
      buttonHeight, buttonHeight, 
      0
      );

    m_button_moveDown.set(
      bg_rect.x() + bg_rect.w() - buttonHeight, 
      bg_rect.y() + buttonHeight * 2, 
      buttonHeight, buttonHeight, 
      0
      );

    m_button_visible.draw();
    m_button_moveUp.draw();
    m_button_moveDown.draw();
  }
}

class LayerSystem
{
  // Position
  PVector m_position = new PVector(0, 0);
  // Sizes
  float m_width = 300;
  final float m_layer_displayer_height = 60;
  final float m_title_displayer_height = 20;
  // Rectangle Placements
  Rectangle rec_bg = new Rectangle();
  Rectangle rec_fg_title = new Rectangle();
  Rectangle rec_fg_layers = new Rectangle();
  // Layers
  ArrayList<Layer> m_Layers = new ArrayList<Layer>();
  Layer m_selectedLayer = null;
  // Buttons
  Button_Square button_addImageLayer = new Button_Square(ButtonID.ADD_IMAGE_LAYER, "Add Image");
  // Scrollbar
  Scrollbar scrollbar = new Scrollbar();

  void updateScroll(float direction)
  {
    update();
    if (rec_fg_layers.isMouseOver() || scrollbar.isMouseOver())
    {
      scrollbar.updateScroll(direction);
    }
  }

  void unselect()
  {
    m_selectedLayer = null;
  }
  void eraseSelectedLayer()
  {
    if (m_selectedLayer == null)
      return;
    if (m_selectedLayer.m_type == LayerType.MASTER)
      return;

    for (int i = 0; i < m_Layers.size(); i++)
    {
      if (m_Layers.get(i) == m_selectedLayer)
      {
        m_Layers.remove(i);
        m_selectedLayer = null;
        break; // end for loop
      }
    }
  }

  void update()
  {
    // Rectangle Data
    rec_bg.set(
      m_position.x, 
      m_position.y, 
      m_width, 
      ScreenHeight, 
      PaddingBG
      );
    rec_fg_title.set(
      m_position.x, 
      m_position.y, 
      m_width, 
      m_title_displayer_height + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    rec_fg_layers.set(
      m_position.x, 
      m_position.y + m_title_displayer_height + PaddingFG/2, 
      m_width - scrollbar.getRequiredWidth(), 
      ScreenHeight - m_title_displayer_height - PaddingFG/2 - BUTTON_HEIGHT, 
      PaddingBG + PaddingFG
      );

    // Button Data
    button_addImageLayer.set(
      m_position.x, 
      m_position.y + rec_fg_title.h() + 3*PaddingFG/4 + rec_fg_layers.h(), 
      button_addImageLayer.width() + (PaddingBG + PaddingFG), 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    button_addImageLayer.setColors(
      COLOR_GREEN, 
      COLOR_GREEN_LIGHT, 
      COLOR_GREEN_DARK
      );
    button_addImageLayer._color_outline = COLOR_GREEN_DARK;

    // Button inputs
    if (button_addImageLayer.isPressed())
    {
      ButtonRequest = button_addImageLayer._id;
      selectInput("Select Image to Import:", "fileSelected");
    }

    // Scrollbar
    scrollbar.setSize(
      rec_fg_layers.x() + rec_fg_layers.w() - 0, 
      rec_fg_layers.y(), 
      SCROLLBAR_WIDTH, 
      rec_fg_layers.h(), 
      (m_Layers.size() * m_layer_displayer_height - PaddingFG)
      );

    // Select Layer
    for (int i = 0; i < m_Layers.size(); i++)
    {
      // Update
      m_Layers.get(i).update();
      // Button Visibility
      if (m_Layers.get(i).m_button_visible.isPressed())
      {
        m_Layers.get(i).m_enabled = !m_Layers.get(i).m_enabled;
      }
      // Button Move Up/Down
      if (m_Layers.get(i).m_button_moveUp.isPressed() && (i > 0))
      {
        Layer tmp = m_Layers.get(i);
        m_Layers.set(i, m_Layers.get(i - 1));
        m_Layers.set(i - 1, tmp);
        break;
      }
      if (m_Layers.get(i).m_button_moveDown.isPressed() && (i < m_Layers.size() - 1))
      {
        Layer tmp = m_Layers.get(i);
        m_Layers.set(i, m_Layers.get(i + 1));
        m_Layers.set(i + 1, tmp);
        break;
      }

      // Layer BG
      Rectangle layerRect = new Rectangle(
        m_position.x, 
        m_position.y + rec_fg_title.h() + (i * (m_layer_displayer_height - 1)) + (PaddingFG/2) - scrollbar.getYDisplacement(), 
        m_width - scrollbar.getRequiredWidth(), 
        m_layer_displayer_height + (PaddingBG + PaddingFG), 
        PaddingBG + PaddingFG + 2
        );
      // Selection
      if (mousePressed && layerRect.isMouseOver())
      {
        unselectAll();
        m_selectedLayer = m_Layers.get(i);
      }
    }
  }

  void draw()
  {
    // BG
    fill(COLOR_LIGHT_GREY);
    rec_bg.draw();

    // Title
    fill(COLOR_MID_GREY);
    rec_fg_title.draw();

    // Write Title
    DrawShadowedText("Layers", rec_fg_title.x() + 7, rec_fg_title.y() + TextSize, COLOR_ORANGE);

    // Layer BG
    fill(COLOR_MID_GREY);
    rec_fg_layers.draw();

    // Mask Layers
    rec_fg_layers.maskArea();

    // Layers
    stroke(0);
    strokeWeight(2);
    setFontBold(true);

    for (int i = 0; i < m_Layers.size(); i++)
    {
      // Layer BG
      Rectangle layerRect = new Rectangle(
        m_position.x, 
        m_position.y + rec_fg_title.h() + (i * (m_layer_displayer_height - 1)) + (PaddingFG/2) - scrollbar.getYDisplacement(), 
        m_width - scrollbar.getRequiredWidth(), 
        m_layer_displayer_height + (PaddingBG + PaddingFG), 
        PaddingBG + PaddingFG + 2
        );

      // Draw
      Layer layer = m_Layers.get(i);
      layer.draw(layerRect, m_selectedLayer == layer);
    }

    noStroke();
    setFontBold(false);
    noClip();

    // Buttons
    button_addImageLayer.draw();

    // Scrollbar
    if (scrollbar.isNeeded())
      scrollbar.draw();
  }
}

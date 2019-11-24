
final float LayerIconPadding = 8;
class Layer
{
  String m_name;

  Layer(String _name)
  {
    m_name = _name;
  }
  void draw(Rectangle bg_rect, boolean selected)
  {
    // BG
    if (selected)
      fill(COLOR_ORANGE_LIGHT);
    else if (bg_rect.isMouseOver())
      fill(COLOR_YELLOW);
    else
      fill(COLOR_WHITE_FAINT);
    bg_rect.draw();

    // Icon
    fill(0);
    rect(
      bg_rect.x() + LayerIconPadding/2, 
      bg_rect.y() + LayerIconPadding/2, 
      bg_rect.h() - LayerIconPadding, 
      bg_rect.h() - LayerIconPadding
      );

    // Name
    text(m_name, bg_rect.x() + bg_rect.h(), bg_rect.y() + bg_rect.h()/2 + 0);
  }
}

class LayerSystem
{
  // Position
  PVector m_position;
  // Sizes
  final float m_width = 300;
  final float m_layer_displayer_height = 60;
  final float m_title_displayer_height = 20;
  // Rectangle Placements
  Rectangle rec_bg = new Rectangle();
  Rectangle rec_fg_title = new Rectangle();
  Rectangle rec_fg_layers = new Rectangle();
  // Layers
  ArrayList<Layer> Layers = new ArrayList<Layer>();
  Layer m_selectedLayer = null;

  LayerSystem(float x, float y)
  {
    m_position = new PVector(x, y);
    Layers.add(new Layer("MASTER"));
    Layers.add(new Layer("Image 1"));
    Layers.add(new Layer("Image 2"));
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
      m_width, 
      ScreenHeight - m_title_displayer_height - PaddingFG/2, 
      PaddingBG + PaddingFG
      );

    // Select Layer
    for (int i = 0; i < Layers.size(); i++)
    {
      // Layer BG
      Rectangle layerRect = new Rectangle(
        m_position.x, 
        m_position.y + rec_fg_title.h() + (i * (m_layer_displayer_height - 1)) + (PaddingFG/2), 
        m_width, 
        m_layer_displayer_height + (PaddingBG + PaddingFG), 
        PaddingBG + PaddingFG + 2
        );
      // Selection
      if (mousePressed && layerRect.isMouseOver())
      {
        m_selectedLayer = Layers.get(i);
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

    for (int i = 0; i < Layers.size(); i++)
    {
      // Layer BG
      Rectangle layerRect = new Rectangle(
        m_position.x, 
        m_position.y + rec_fg_title.h() + (i * (m_layer_displayer_height - 1)) + (PaddingFG/2), 
        m_width, 
        m_layer_displayer_height + (PaddingBG + PaddingFG), 
        PaddingBG + PaddingFG + 2
        );

      // Draw
      Layer layer = Layers.get(i);
      layer.draw(layerRect, m_selectedLayer == layer);
    }

    noStroke();
    setFontBold(false);
    noClip();
  }
}

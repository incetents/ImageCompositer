
class ExportSystem
{
  // Position
  PVector m_position = new PVector(0, 0);
  // Sizes
  float m_width = 300;
  final float m_title_displayer_height = 20;
  // Rectangle Placements
  Rectangle rec_bg = new Rectangle();
  Rectangle rec_fg_title = new Rectangle();
  // Buttons
  Button_Square button_export = new Button_Square(ButtonID.EXPORT_IMAGES, "Export");

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

    // Button Data
    button_export.set(
      m_position.x, 
      m_position.y + rec_fg_title.h() + PaddingFG/2, 
      button_export.width() + (PaddingBG + PaddingFG), 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    button_export.setColors(
      COLOR_GREEN, 
      COLOR_GREEN_LIGHT, 
      COLOR_GREEN_DARK
      );
    button_export._color_outline = COLOR_GREEN_DARK;
    
   // Button inputs
    if (button_export.isPressed())
    {
      ButtonRequest = button_export._id;
      selectFolder("Select Location to Export Images:", "folderSelected");
    }
  }
  void draw()
  {
    //BG
    rec_bg.draw(COLOR_LIGHT_GREY);
    // Title
    rec_fg_title.draw(COLOR_MID_GREY);
    // Write Title
    DrawShadowedText("Export Settings", rec_fg_title.x() + 4, rec_fg_title.y() + TextSize, COLOR_ORANGE);

    // Export Button
    button_export.draw();
  }
}

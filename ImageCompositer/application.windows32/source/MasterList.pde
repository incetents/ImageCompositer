
class MasterList
{
  ArrayList<Image> m_images = new ArrayList<Image>();
  Image m_selectedImage = null;

  // Position
  PVector m_position = new PVector(0, 0);
  // Sizes
  float m_width = 300;
  final float m_image_displayer_height = 150;
  final float m_title_displayer_height = 20;
  // Rectangle Placements
  Rectangle rec_bg = new Rectangle();
  Rectangle rec_fg_title = new Rectangle();
  Rectangle rec_fg_image = new Rectangle();
  Rectangle rec_fg_list = new Rectangle();
  // Buttons
  Button_Square button_addFile = new Button_Square("Import File");
  Button_Square button_addFolder = new Button_Square("Import Folder");
  // Scrollbar
  Scrollbar scrollbar = new Scrollbar();

  void eraseSelectedImage()
  {
    if (m_selectedImage == null)
      return;
    for (int i = 0; i < m_images.size(); i++)
    {
      if (m_images.get(i) == m_selectedImage)
      {
        m_images.remove(i);
        m_selectedImage = null;
        // fix scroll
        scrollbar.updateScroll(0.0);
        break; // end for loop
      }
    }
  }

  void updateScroll(float direction)
  {
    update();
    if (rec_fg_list.isMouseOver() || scrollbar.isMouseOver())
    {
      scrollbar.updateScroll(direction);
    }
  }

  void unselect()
  {
    m_selectedImage = null;
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

    rec_fg_image.set(
      m_position.x, 
      m_position.y + (ScreenHeight - m_image_displayer_height) - (PaddingBG + PaddingFG), 
      m_width, 
      m_image_displayer_height + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    rec_fg_title.set(
      m_position.x, 
      m_position.y, 
      m_width, 
      m_title_displayer_height + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    rec_fg_list.set(
      m_position.x, 
      m_position.y + rec_fg_title.h() + PaddingFG/2, 
      m_width - scrollbar.getRequiredWidth(), 
      ScreenHeight - rec_fg_title.h() - rec_fg_image.h() - PaddingFG - BUTTON_HEIGHT, 
      PaddingBG + PaddingFG
      );

    // Scrollbar
    scrollbar.setSize(
      rec_fg_list.x() + rec_fg_list.w(), 
      rec_fg_list.y(), 
      SCROLLBAR_WIDTH, 
      rec_fg_list.h(), 
      (m_images.size() * TextSize)
      );

    // Button Data
    button_addFile.set(
      m_position.x, 
      m_position.y + rec_fg_title.h() + 3*PaddingFG/4 + rec_fg_list.h(), 
      button_addFile.width() + (PaddingBG + PaddingFG), 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    button_addFile.setColors(
      COLOR_GREEN, 
      COLOR_GREEN_LIGHT, 
      COLOR_GREEN_DARK
      );
    button_addFile._color_outline = COLOR_GREEN_DARK;

    button_addFolder.set(
      m_position.x + button_addFile.w() + 5, 
      m_position.y + rec_fg_title.h() + 3*PaddingFG/4 + rec_fg_list.h(), 
      button_addFolder.width() + (PaddingBG + PaddingFG), 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    button_addFolder.setColors(
      COLOR_GREEN, 
      COLOR_GREEN_LIGHT, 
      COLOR_GREEN_DARK
      );
    button_addFolder._color_outline = COLOR_GREEN_DARK;

    // Button inputs
    if (button_addFile.pressDown())
    {
      selectInput("Select Image to Import:", "fileSelect_AddFileToMasterList");
    }
    //
    else if (button_addFolder.pressDown())
    {
      selectFolder("Select Folder to Import:", "folderSelect_AddFolderToMasterList");
    }

    // Select Image
    if (mousePressed)
    {
      unselect();

      for (int i = 0; i < m_images.size(); i++)
      {
        Rectangle r = new Rectangle(rec_fg_list.x(), rec_fg_list.y() + (TextSize * i) - scrollbar.getYDisplacement(), rec_fg_list.w(), TextSize, 0);

        // Item Click
        if (rec_fg_list.isMouseOver() && r.isMouseOver())
        {
          m_selectedImage = m_images.get(i);
          break;
        }
      }
    }
  }

  void draw()
  {
    // BG
    rec_bg.draw(COLOR_LIGHT_GREY);

    // Title
    rec_fg_title.draw(COLOR_MID_GREY);

    // Write Title
    rec_fg_title.maskArea();
    DrawShadowedText("Master List", rec_fg_title.x() + 4, rec_fg_title.y() + TextSize, COLOR_ORANGE);
    noClip();

    // Image Displayer
    rec_fg_image.draw(COLOR_BLACK);

    // Checkerboard on image displayer
    if (m_selectedImage != null)
    {
      tint(255, 50);
      rec_fg_image.maskArea();
      float timeSlow = millis() / 80.0;
      float x_offset = timeSlow % rec_fg_image.w();
      float y_offset = timeSlow % rec_fg_image.h();
      image_checkerboard.draw(rec_fg_image.x() + x_offset, rec_fg_image.y() + y_offset, rec_fg_image.w(), rec_fg_image.h());
      image_checkerboard.draw(rec_fg_image.x() + x_offset - rec_fg_image.w(), rec_fg_image.y() + y_offset, rec_fg_image.w(), rec_fg_image.h());
      image_checkerboard.draw(rec_fg_image.x() + x_offset, rec_fg_image.y() + y_offset - rec_fg_image.h(), rec_fg_image.w(), rec_fg_image.h());
      image_checkerboard.draw(rec_fg_image.x() + x_offset - rec_fg_image.w(), rec_fg_image.y() + y_offset - rec_fg_image.h(), rec_fg_image.w(), rec_fg_image.h());
      noClip();
      tint(255, 255);
    }

    // Image Lists
    rec_fg_list.draw(COLOR_MID_GREY);

    // Mask name section
    rec_fg_list.maskArea();

    // Selection Box
    for (int i = 0; i < m_images.size(); i++)
    {
      if (m_selectedImage == m_images.get(i))
      {
        Rectangle r = new Rectangle(rec_fg_list.x(), rec_fg_list.y() + (TextSize * i) - scrollbar.getYDisplacement(), rec_fg_list.w(), TextSize, 0);
        r.draw(color(COLOR_BLACK, 140));
      }
    }

    // Write image names
    for (int i = 0; i < m_images.size(); i++)
    {
      Rectangle r = new Rectangle(rec_fg_list.x(), rec_fg_list.y() + (TextSize * i) - scrollbar.getYDisplacement(), rec_fg_list.w(), TextSize, 0);

      // Color of text
      color c = COLOR_BLACK;

      //
      if (r.isMouseOver() && rec_fg_list.isMouseOver())
      {
        //
        if ( m_selectedImage == m_images.get(i))
        {
          c = COLOR_RED;
        }
        //
        else
          //
          c = COLOR_ORANGE;
      }
      //
      else if (m_images.get(i).m_image == null)
      {
        c = COLOR_WHITE_FAINT;
      } else
        c = COLOR_YELLOW;

      // Justify text on right side if too large
      if (m_images.get(i).fileNameLength() > r.w() - scrollbar.getRequiredWidth() - 4)
      {
        DrawShadowedText(m_images.get(i).fileName(), r.x() - m_images.get(i).fileNameLength() + r.w() - scrollbar.getRequiredWidth() - 4, r.y() + TextSize - 3, c);
      }
      // Justify on left side
      else
      {
        DrawShadowedText(m_images.get(i).fileName(), r.x(), r.y() + TextSize - 3, c);
      }
    }

    // mask image section
    rec_fg_image.maskArea();

    // Draw Display Image
    if (m_selectedImage != null && m_selectedImage.m_image != null)
    {
      float h_size = rec_fg_image.h() * m_selectedImage.aspectRatio();
      // Check if enough room
      if (h_size <= rec_fg_image.w())
      {
        image(m_selectedImage.m_image, 
          rec_fg_image.x() + rec_fg_image.w()/2 - h_size/2, rec_fg_image.y(), 
          h_size, rec_fg_image.h()
          );
      }
      //
      else
      {
        float v_size = rec_fg_image.w() / m_selectedImage.aspectRatio();
        image(m_selectedImage.m_image, 
          rec_fg_image.x(), rec_fg_image.y() + rec_fg_image.h()/2 - v_size/2, 
          rec_fg_image.w(), v_size
          );
      }

      // Draw Displayed Image path (bg)
      fill(0, 100);
      rect(rec_fg_image.x(), rec_fg_image.y() + rec_fg_image.h() - (TextSize + 2), rec_fg_image.w(), (TextSize + 2));
      // Draw Displayed Image path
      float textX = lerp(rec_fg_image.x(), rec_fg_image.x() - m_selectedImage.directoryLength() + rec_fg_image.w(), rec_fg_image.mouseXHoverRatio());

      DrawShadowedText(m_selectedImage.directory(), textX, rec_fg_image.y() + rec_fg_image.h() - 4, color(255));
    }

    // No mask
    noClip();

    // Scrollbar
    if (scrollbar.isNeeded())
      scrollbar.draw();

    // Button
    button_addFile.draw();
    button_addFolder.draw();
  }
}

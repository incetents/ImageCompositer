
class MasterList
{
  ArrayList<Image> m_images = new ArrayList<Image>();
  Image m_selectedImage = null;

  // Position
  PVector m_position;
  // Sizes
  final float m_width = 300;
  final float m_image_displayer_height = 150;
  final float m_title_displayer_height = 20;
  // Data
  float m_scroll = 0.0f;
  float m_scrollMax = 0.0f;
  // Rectangle Placements
  Rectangle rec_bg = new Rectangle();
  Rectangle rec_fg_title = new Rectangle();
  Rectangle rec_fg_image = new Rectangle();
  Rectangle rec_fg_list = new Rectangle();
  Rectangle rec_scrollbar_bg = new Rectangle();
  Rectangle rec_scrollbar_fg = new Rectangle();

  MasterList(float x, float y)
  {
    m_position = new PVector(x, y);
  }

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
        scrollUpdate(0.0);
        break; // end for loop
      }
    }
  }

  void scrollUpdate(float direction)
  {
    update();
    if (rec_fg_list.isMouseOver())
    {
      m_scroll += direction * 50;
      m_scroll = constrain(m_scroll, 0, m_scrollMax);
    }
  }

  void update()
  {
    // Calc Data
    float TotalTextVSpace = m_images.size() * TextSize;
    float ExcessVSpace = TotalTextVSpace - rec_fg_list.h();
    m_scrollMax = ExcessVSpace;

    float ScrollbarRatio = min(rec_fg_list.h() / TotalTextVSpace, 1);
    float ScrollbarHeight = ScrollbarRatio * rec_fg_list.h();

    float ScrollAmount = m_scroll;
    if (m_scrollMax != 0)
      ScrollAmount /= m_scrollMax;

    float ScrollbarY = lerp(rec_fg_list.y(), rec_fg_list.y() + rec_fg_list.h() - ScrollbarHeight, ScrollAmount);

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
      m_position.y + (ScreenHeight - m_image_displayer_height), 
      m_width, 
      m_image_displayer_height, 
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
      m_width, 
      ScreenHeight - rec_fg_title.h() - rec_fg_image.h() - PaddingFG, 
      PaddingBG + PaddingFG
      );

    rec_scrollbar_bg.set(
      rec_fg_list.x() + rec_fg_list.w() - 10, 
      rec_fg_list.y(), 
      10, 
      rec_fg_list.h(), 
      0
      );
    rec_scrollbar_fg.set(
      rec_fg_list.x() + rec_fg_list.w() - 10, 
      ScrollbarY, 
      10, 
      ScrollbarHeight, 
      0
      );

    // Select Image
    if (mousePressed)
    {
      for (int i = 0; i < m_images.size(); i++)
      {
        Rectangle r = new Rectangle(rec_fg_list.x(), rec_fg_list.y() + (TextSize * i) - m_scroll, rec_fg_list.w(), TextSize, 0);
        //
        if (r.isMouseOver() && rec_fg_list.isMouseOver())
        {
          //


          m_selectedImage = m_images.get(i);
        }
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
    DrawShadowedText("Master List", rec_fg_title.x() + 4, rec_fg_title.y() + TextSize, COLOR_ORANGE);

    // Image Displayer
    fill(COLOR_BLACK);
    rec_fg_image.draw();

    // Image Lists
    fill(COLOR_MID_GREY);
    rec_fg_list.draw();

    // Mask name section
    rec_fg_list.maskArea();

    // Selection Box
    for (int i = 0; i < m_images.size(); i++)
    {
      if (m_selectedImage == m_images.get(i))
      {
        fill(COLOR_BLACK, 140);
        Rectangle r = new Rectangle(rec_fg_list.x(), rec_fg_list.y() + (TextSize * i) - m_scroll, rec_fg_list.w(), TextSize, 0);
        r.draw();
      }
    }

    // Write image names
    for (int i = 0; i < m_images.size(); i++)
    {
      Rectangle r = new Rectangle(rec_fg_list.x(), rec_fg_list.y() + (TextSize * i) - m_scroll, rec_fg_list.w(), TextSize, 0);

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
      if (m_images.get(i).m_filePathWidth > r.w() - rec_scrollbar_bg.w() - 4)
      {
        DrawShadowedText(m_images.get(i).m_filePath, r.x() - m_images.get(i).m_filePathWidth + r.w() - rec_scrollbar_bg.w() - 4, r.y() + TextSize - 3, c);
      }
      // Justify on left side
      else
      {
        DrawShadowedText(m_images.get(i).m_filePath, r.x(), r.y() + TextSize - 3, c);
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
      } else
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
      DrawShadowedText(m_selectedImage.m_filePath, rec_fg_image.x() - m_selectedImage.m_filePathWidth + rec_fg_image.w(), rec_fg_image.y() + rec_fg_image.h() - 4, color(255));
    }

    // No mask
    noClip();

    // Scrollbar
    fill(COLOR_DARK_GREY);
    rec_scrollbar_bg.draw();
    fill(COLOR_WHITE_FAINT);
    rec_scrollbar_fg.draw();
  }
}

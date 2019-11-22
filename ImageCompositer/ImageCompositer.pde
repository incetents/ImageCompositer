// Library
import drop.*;
SDrop drop;

// Sizes
int ScreenWidth = 1020;
int ScreenHeight = 720;
int TextSize = 15;

// Setup
void settings()
{
  size(ScreenWidth, ScreenHeight);
  noSmooth();
}
void setup()
{
  noStroke();
  surface.setResizable(true);
  drop = new SDrop(this);
  init();
}

// Screens
MasterList masterList1 = new MasterList(0, 0);

class MasterList
{
  ArrayList<Image> m_images = new ArrayList<Image>();
  Image m_selectedImage = null;

  PVector m_position;
  // Sizes
  final float m_bg_width = 200;
  final float m_bg_padding = 8;
  final float m_fg_padding = 4;
  final float m_displayer_height = 150;
  // Slots
  Rectangle rec_bg = new Rectangle();
  Rectangle rec_fg_image = new Rectangle();
  Rectangle rec_fg_list = new Rectangle();
  Rectangle rec_scrollbar_bg = new Rectangle();
  Rectangle rec_scrollbar_fg = new Rectangle();

  MasterList(float x, float y)
  {
    m_position = new PVector(x, y);
  }

  void draw()
  {
    // Rectangle Data
    rec_bg.set(
      m_position.x + m_bg_padding/2, 
      m_position.y + m_bg_padding/2, 
      m_bg_width - m_bg_padding, 
      ScreenHeight - m_bg_padding
      );
    rec_fg_image.set(
      rec_bg.x() + m_fg_padding/2, 
      rec_bg.y() + m_fg_padding/2 + (ScreenHeight - m_displayer_height), 
      rec_bg.w() - m_fg_padding, 
      m_displayer_height - m_bg_padding - m_fg_padding
      );
    rec_fg_list.set(
      rec_bg.x() + m_fg_padding/2, 
      rec_bg.y() + m_fg_padding/2, 
      rec_bg.w() - m_fg_padding, 
      ScreenHeight - m_displayer_height - m_fg_padding
      );
    rec_scrollbar_bg.set(
      rec_fg_list.x() + rec_fg_list.w() - 10, 
      rec_fg_list.y(), 
      10, 
      rec_fg_list.h()
      );
    rec_scrollbar_fg.set(
      rec_fg_list.x() + rec_fg_list.w() - 10, 
      rec_fg_list.y(), 
      10, 
      15
      );

    // BG
    fill(116);
    rec_bg.draw();

    // Image Displayer
    fill(0);
    rec_fg_image.draw();

    // Image Lists
    fill(64);
    rec_fg_list.draw();

    // Mask name section
    rec_fg_list.maskArea();

    // Scrollbar
    fill(39);
    rec_scrollbar_bg.draw();
    fill(200);
    rec_scrollbar_fg.draw();

    // Write image names
    for (int i = 0; i < m_images.size(); i++)
    {
      Rectangle r = new Rectangle(rec_fg_list.x() + m_fg_padding/2, rec_fg_list.y() + TextSize * (i + 0), rec_fg_list.w(), TextSize);

      color c = color(0, 0, 0);

      if (r.isMouseOver())
      {
        if (mousePressed)
        {
          m_selectedImage = m_images.get(i);
          c = color(200, 25, 0);
        } else
          c = color(255, 127, 0);
      } else
        c = color(255, 255, 0);

      // Justify text on right side if too large
      if (m_images.get(i).m_filePathWidth > r.w())
      {
        DrawShadowedText(m_images.get(i).m_filePath, r.x() - m_images.get(i).m_filePathWidth + r.w() - m_fg_padding/2, r.y() + TextSize, c);
      }
      // Justify on left side
      else
      {
        DrawShadowedText(m_images.get(i).m_filePath, r.x(), r.y() + TextSize, c);
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

      // Draw Displayed Image path
      DrawShadowedText(m_selectedImage.m_filePath, rec_fg_image.x() - m_selectedImage.m_filePathWidth + rec_fg_image.w(), rec_fg_image.y() + rec_fg_image.h() - 5, color(255));
    }

    // No mask
    noClip();
  }
}

void init()
{
  textSize(TextSize);
  textLeading(TextSize);
  //
  masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\color.jpg"));
  masterList1.m_images.add(new Image("color1.jpg"));
  masterList1.m_images.add(new Image("color2.jpg"));
  masterList1.m_images.add(new Image("color3.jpg"));
  masterList1.m_images.add(new Image("test.png"));
  for (int i = 0; i < 100; i++)
    masterList1.m_images.add(new Image("EMPTY" + str(i)));
}
void draw()
{
  ScreenWidth = width;
  ScreenHeight = height;

  background(39);

  masterList1.draw();

  //if (test != null)
  //  image(test, 0, 0, 400, 400);
}

void dropEvent(DropEvent theDropEvent)
{
  if (theDropEvent.isImage())
  {
    println(theDropEvent.filePath());
    //test = theDropEvent.loadImage();

    masterList1.m_images.add(new Image(theDropEvent.filePath()));
  }
}

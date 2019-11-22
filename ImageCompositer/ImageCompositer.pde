// Library
import drop.*;
SDrop drop;

// Sizes
int ScreenWidth = 1020;
int ScreenHeight = 720;
final int TextSize = 15;

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
  final float m_bg_width = 300;
  final float m_image_displayer_height = 150;
  final float m_title_displayer_height = 20;
  // Padding
  final float m_bg_padding = 8;
  final float m_fg_padding = 4;
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
      m_position.x + m_bg_padding/2, 
      m_position.y + m_bg_padding/2, 
      m_bg_width - m_bg_padding, 
      ScreenHeight - m_bg_padding
      );
    rec_fg_image.set(
      rec_bg.x() + m_fg_padding/2, 
      rec_bg.y() + m_fg_padding/2 + (ScreenHeight - m_image_displayer_height), 
      rec_bg.w() - m_fg_padding, 
      m_image_displayer_height - m_bg_padding - m_fg_padding
      );
    rec_fg_title.set(
      rec_bg.x() + m_fg_padding/2, 
      rec_bg.y() + m_fg_padding/2, 
      rec_bg.w() - m_fg_padding, 
      m_title_displayer_height
      );
    rec_fg_list.set(
      rec_bg.x() + m_fg_padding/2, 
      rec_bg.y() + m_fg_padding/2 + m_title_displayer_height + m_fg_padding/2, 
      rec_bg.w() - m_fg_padding, 
      ScreenHeight - m_image_displayer_height - m_fg_padding - m_title_displayer_height
      );
    rec_scrollbar_bg.set(
      rec_fg_list.x() + rec_fg_list.w() - 10, 
      rec_fg_list.y(), 
      10, 
      rec_fg_list.h()
      );
    rec_scrollbar_fg.set(
      rec_fg_list.x() + rec_fg_list.w() - 10, 
      ScrollbarY, 
      10, 
      ScrollbarHeight
      );
  }

  void draw()
  {
    // BG
    fill(116);
    rec_bg.draw();

    // Title
    fill(COLOR_MID_GREY);
    rec_fg_title.draw();

    // Write Title
    DrawShadowedText("Master List", rec_fg_title.x() + 7, rec_fg_title.y() + TextSize, COLOR_ORANGE);

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
        Rectangle r = new Rectangle(rec_fg_list.x() + m_fg_padding/2, rec_fg_list.y() + (TextSize * i) - m_scroll, rec_fg_list.w(), TextSize);
        r.draw();
      }
    }

    // Write image names
    for (int i = 0; i < m_images.size(); i++)
    {
      Rectangle r = new Rectangle(rec_fg_list.x() + m_fg_padding/2, rec_fg_list.y() + (TextSize * i) - m_scroll, rec_fg_list.w(), TextSize);

      // Color of text
      color c = COLOR_BLACK;


      //
      if (r.isMouseOver() && rec_fg_list.isMouseOver())
      {
        //
        if (mousePressed)
        {
          m_selectedImage = m_images.get(i);
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
        c = COLOR_LIGHT_GREY;
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
    fill(COLOR_LIGHT_GREY);
    rec_scrollbar_fg.draw();
  }
}

void init()
{
  textSize(TextSize);
  textLeading(TextSize);
  //
  masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\cloud.png"));
  masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\color.jpg"));

  masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\test.png"));
  for (int i = 0; i < 84; i++)
    masterList1.m_images.add(new Image("EMPTY" + str(i)));

  masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\Metal11_disp.jpg"));
}
void draw()
{
  ScreenWidth = width;
  ScreenHeight = height;

  background(COLOR_DARK_GREY);

  masterList1.update();
  masterList1.draw();
}

void keyPressed()
{
  // Delete
  //println(keyCode);
  if (keyCode == 8 || keyCode == 127) // RETURN and DELETE
  {
    masterList1.eraseSelectedImage();
  }
}
void keyReleased()
{
}

void mouseWheel(MouseEvent event)
{
  //float e = event.getCount();
  //println(e);
  masterList1.scrollUpdate(event.getCount());
}

void dropEvent(DropEvent theDropEvent)
{
  if (theDropEvent.isImage())
  {
    println(theDropEvent.filePath());
    //test = theDropEvent.loadImage();

    if (fileExists(theDropEvent.filePath()))
      println("FileExists");

    masterList1.m_images.add(new Image(theDropEvent.filePath()));
  }
}

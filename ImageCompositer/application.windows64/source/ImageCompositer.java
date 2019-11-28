import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import drop.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ImageCompositer extends PApplet {


// Library

SDrop drop;

// Padding
float PaddingBG = 8;
float PaddingFG = 12;

// Mouse Released
boolean MousePressed = false;
boolean MouseReleased = false;

// Sizes
int ScreenWidth = 1020;
int ScreenHeight = 720;

// Screens
MasterList masterList1 = new MasterList();
LayerSystem layerSystem1 = new LayerSystem();
ExportSystem exportSystem1 = new ExportSystem();

// Setup
public void settings()
{
  size(ScreenWidth, ScreenHeight);
  noSmooth();
}
public void setup()
{
  noStroke();
  surface.setResizable(true);
  drop = new SDrop(this);
  init();
}

public void init()
{
  image_editor_eyeOpen = new Image("eye_open.png");
  image_editor_eyeClosed = new Image("eye_closed_red.png");
  image_editor_up = new Image("up_arrow.png");
  image_editor_down = new Image("down_arrow.png");
  image_editor_infinity = new Image("infinity.png");
  image_editor_infinity_locked = new Image("infinity_locked.png");

  // Checkerboard
  ArrayList<Integer> imagePixels = new ArrayList<Integer>();
  for (int y = 0; y < 8; y++)
  {
    for (int x = 0; x < 8; x++)
    {
      //int index = y * 8 + x;
      if (x % 2 == y % 2)
        imagePixels.add(color(255));
      else
        imagePixels.add(color(90));
    }
  }
  image_checkerboard = new Image(imagePixels, 8, false);

  initFonts();
  textSize(TextSize);
  textLeading(TextSize);
  //
  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\letter_a.png"));
  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\letter_b.png"));
  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\letter_c.png"));
  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\letter_d.png"));
  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\letter_e.png"));

  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\test.png"));
  //for (int i = 0; i < 38; i++)
  //  masterList1.m_images.add(new Image("EMPTY" + str(i)));


  //layerSystem1.m_Layers.add(new Layer(LayerType.IMAGE, "\\Users\\incet\\OneDrive\\Desktop\\debug images\\outline_green.png"));
  layerSystem1.m_Layers.add(new Layer(LayerType.MASTER, ""));
  //layerSystem1.m_Layers.add(new Layer(LayerType.IMAGE, "\\Users\\incet\\OneDrive\\Desktop\\debug images\\circle_blue.png"));
}
public void draw()
{
  ScreenWidth = width;
  ScreenHeight = height;

  background(COLOR_DARK_GREY);

  // 25 %
  masterList1.m_position.x = PaddingBG/4;
  masterList1.m_width = (ScreenWidth * 0.25f);
  masterList1.update();
  masterList1.draw();

  // 33 %
  layerSystem1.m_position.x = (ScreenWidth * 0.25f);
  layerSystem1.m_width = (ScreenWidth / 3);
  layerSystem1.update();
  layerSystem1.draw();

  // 42%
  exportSystem1.m_position.x = (ScreenWidth * 0.25f + ScreenWidth / 3) - PaddingBG/4;
  exportSystem1.m_width = ScreenWidth - (ScreenWidth * 0.25f) - (ScreenWidth / 3);
  exportSystem1.update();
  exportSystem1.draw();

  // End of frame update
  MousePressed = false;
  MouseReleased = false;
}

public void keyPressed()
{
  // Delete
  //println(keyCode);
  if (keyCode == 8 || keyCode == 127) // RETURN and DELETE
  {
    masterList1.eraseSelectedImage();
    layerSystem1.eraseSelectedLayer();
    exportSystem1.eraseSelectedSize();
  }

  //if (key == '1')
  //  PaddingBG--;
  //else if (key == '2')
  //  PaddingBG++;

  //if (key == '3')
  //  PaddingFG--;
  //else if (key == '4')
  //  PaddingFG++;

  PaddingBG = max(PaddingBG, 0);
  PaddingFG = max(PaddingFG, 0);

  //println(keyCode);
  //println(key);
  if(key == '?')
    println("ERR");

  // Update input of input boxes
  if (keyCode == 8 || keyCode == 127) // RETURN and DELETE
  {
    exportSystem1.eraseInput();
  }
  // Ignore Special Keys
  //else if(keyCode == 16 || keyCode == 17 || keyCode == 18 || keyCode == 9) // SHIFT, CTRL, ALT, TAB
  //{}
  else if(Character.isDigit(key) || Character.isLetter(key))
  {
    exportSystem1.updateInput(key);
  }

  if (key == 'a' || key == 'A')
  {
  }
}
public void keyReleased()
{
  if (key == 'a' || key == 'A')
  {
  }
}

public void mousePressed()
{
  MousePressed = true;
}
public void mouseReleased()
{
  MouseReleased = true;
}

public void mouseWheel(MouseEvent event)
{
  //float e = event.getCount();
  //println(e);
  masterList1.updateScroll(event.getCount());
  layerSystem1.updateScroll(event.getCount());
  exportSystem1.updateScroll(event.getCount());
}

// FILE Select
public void fileSelect_AddFileToMasterList(File selection)
{
  if (selection == null)
  {
    println("Selection Abort");
    return;
  }

  masterList1.m_images.add(new Image(selection.getAbsolutePath()));
}
public void fileSelect_AddImageLayer(File selection)
{
  if (selection == null)
  {
    println("Selection Abort");
    return;
  }

  layerSystem1.m_Layers.add(new Layer(LayerType.IMAGE, selection.getAbsolutePath()));
}
// Folder Select
public void folderSelect_AddFolderToMasterList(File selection)
{
  if (selection == null)
  {
    println("Selection Abort");
    return;
  }

  java.io.File folder = new java.io.File(selection.getAbsolutePath());
  // list the files in the data folder
  String[] filenames = folder.list();

  // Get files
  for (int i = 0; i < filenames.length; i++)
  {
    masterList1.m_images.add(new Image(folder.getAbsolutePath() + '\\' + filenames[i]));
  }
}
public void folderSelect_ExportImages(File selection)
{
  if (selection == null)
  {
    println("Selection Abort");
    return;
  }

  exportSystem1.m_exportLastLocation = new File(selection.getAbsolutePath());
  exportSystem1.ExportImages(selection.getAbsolutePath(), layerSystem1, masterList1);
}


public void dropEvent(DropEvent theDropEvent)
{
  if (theDropEvent.isImage())
  {
    //println(theDropEvent.filePath());
    //test = theDropEvent.loadImage();

    if (fileExists(theDropEvent.filePath()))
    {
      //println("FileExists");
      masterList1.m_images.add(new Image(theDropEvent.filePath()));
    }

    //
  }
}


class Button_Square extends Rectangle
{
  int _color_normal = color(200);
  int _color_highlighted = color(255);
  int _color_pressed = color(100);
  boolean _outline = true;
  int _color_outline = color(0);
  Image _image = null;
  private String _text;
  private float _width = -1;

  Button_Square(String text)
  {
    _text = text;
  }
  public float width()
  {
    if (_width == -1)
    {
      setFontBold(true);
      _width = textWidth(_text) + 5;
      setFontBold(false);
    }
    return _width;
  }
  public void setColors(int normal, int highlighted, int pressed)
  {
    _color_normal = normal;
    _color_highlighted = highlighted;
    _color_pressed = pressed;
  }

  public boolean press()
  {
    return isMouseOver() && mousePressed;
  }
  public boolean pressUp()
  {
    return isMouseOver() && MouseReleased;
  }
  public boolean pressDown()
  {
    return isMouseOver() && MousePressed;
  }

  public void draw()
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

class DisplayList
{
  Rectangle rec_title = new Rectangle();
  Rectangle rec_bg = new Rectangle();

  Scrollbar scrollbar = new Scrollbar();

  ArrayList<String> m_lines = new ArrayList<String>();
  int m_selectedLineIndex = -1;
  boolean m_ignoreDuplicate = true;

  public void add(String str)
  {
    if(m_ignoreDuplicate)
    {
      for(int i = 0; i < m_lines.size(); i++)
      {
        if(m_lines.get(i).equals(str))
          return;
      }
    }
    
    m_lines.add(str);
  }
  public void unselect()
  {
    m_selectedLineIndex = -1;
  }
  public String getSelection()
  {
    if (m_selectedLineIndex == -1)
      return "";

    return m_lines.get(m_selectedLineIndex);
  }
  public void eraseSelection()
  {
    if (m_selectedLineIndex == -1)
      return;

    m_lines.remove(m_selectedLineIndex);
    m_selectedLineIndex = -1;
  }

  public float rowHeight()
  {
    return TextSize + 5;
  }

  public void setBG(float x, float y, float w, float h)
  {
    float padding = PaddingFG + PaddingBG;
    rec_title.set(x, y, w, rowHeight() + padding, padding);
    rec_bg.set(x, y + rowHeight(), w, h - rowHeight() + PaddingBG - PaddingFG/2, padding);

    scrollbar.setSize(x + w - padding/2 - SCROLLBAR_WIDTH, y + rowHeight() + padding/2, SCROLLBAR_WIDTH, rec_bg.h(), rowHeight() * m_lines.size());
    scrollbar.updateScroll(0);
  }

  public void updateScroll(float direction)
  {
    if (rec_bg.isMouseOver() || scrollbar.isMouseOver())
    {
      scrollbar.updateScroll(direction);
    }
  }

  public void update()
  {
    // Seleciton Removal
    if (mousePressed)
    {
      unselect();

      for (int i = 0; i < m_lines.size(); i++)
      {
        Rectangle r = new Rectangle(
          rec_bg.x(), rec_bg.y() + (i * rowHeight()) - scrollbar.getYDisplacement(), 
          rec_bg.w(), rowHeight(), 
          0
          );

        if (r.isMouseOver())
        {
          m_selectedLineIndex = i;
          break;
        }
      }
    }
  }
  public void draw()
  {
    rec_title.draw(COLOR_WHITE_FAINT);

    // Draw Title
    rec_title.maskArea();
    fill(0);
    setFontBold(true);
    text("Export Sizes:", rec_title.x() + 4, rec_title.y() + TextSize);
    setFontBold(false);
    noClip();

    // Draw BG
    rec_bg.draw(COLOR_DARK_GREY);

    // Draw Lists of text
    rec_bg.maskArea();
    for (int i = 0; i < m_lines.size(); i++)
    {
      Rectangle r = new Rectangle(
        rec_bg.x(), rec_bg.y() + (i * rowHeight()) - scrollbar.getYDisplacement(), 
        rec_bg.w(), rowHeight(), 
        0
        );

      if (r.isMouseOver())
      {
        if (MousePressed)
          m_selectedLineIndex = i;

        r.draw(COLOR_MID_GREY);
        if (m_selectedLineIndex == i)
          fill(COLOR_YELLOW);
        else
          fill(COLOR_ORANGE);
      }
      //
      else
      {
        if (m_selectedLineIndex == i)
        {
          r.draw(COLOR_LIGHT_GREY);
          fill(COLOR_YELLOW);
        } else
        {
          r.draw(COLOR_BLACK);
          fill(COLOR_WHITE_FAINT);
        }
      }
      //
      text(m_lines.get(i), rec_bg.x() + 4, rec_bg.y() + (i * rowHeight()) + TextSize - scrollbar.getYDisplacement());
    }
    noClip();

    // Draw Scrollbar
    scrollbar.draw();
  }
}

class ExportSystem
{
  // Position
  PVector m_position = new PVector(0, 0);
  // Sizes
  float m_width = 300;
  final float m_title_displayer_height = 20;
  final float m_buttonVerticalSpace = 6;
  final float m_leftSidePercent = 0.42f;
  // Rectangle Placements
  Rectangle rec_bg = new Rectangle();
  Rectangle rec_fg_title = new Rectangle();
  Rectangle rec_exportName = new Rectangle();
  // Buttons
  Button_Square button_export = new Button_Square("Export");
  Button_Square button_addSize = new Button_Square("Add Size");
  Button_Square button_linkSize = new Button_Square("");
  // Size Choices
  DisplayList sizeList = new DisplayList();
  InputBox sizeInputWidth = new InputBox();
  InputBox sizeInputHeight = new InputBox();
  boolean m_linkSizes = true;
  File m_exportLastLocation = null;
  // Prefix/Postfix to name
  InputBox prefixInput = new InputBox();
  InputBox postfixInput = new InputBox();


  ExportSystem()
  {
    sizeList.add("[Master]");

    sizeInputWidth.m_characterLimit = 5;
    sizeInputWidth.m_numbersOnly = true;

    sizeInputHeight.m_characterLimit = 5;
    sizeInputHeight.m_numbersOnly = true;
  }

  public void updateInput(char c)
  {
    sizeInputWidth.updateInput(c);
    sizeInputHeight.updateInput(c);
    prefixInput.updateInput(c);
    postfixInput.updateInput(c);
  }
  public void eraseInput()
  {
    sizeInputWidth.eraseInput();
    sizeInputHeight.eraseInput();
    prefixInput.eraseInput();
    postfixInput.eraseInput();
  }

  public void updateScroll(float direction)
  {
    sizeList.updateScroll(direction);
  }

  public void unselect()
  {
    sizeList.unselect();
  }

  public void eraseSelectedSize()
  {
    if (sizeList.getSelection() != "[Master]")
      sizeList.eraseSelection();
  }

  public void update()
  {
    // Rectangle Data
    rec_bg.set(
      m_position.x, 
      m_position.y, 
      m_width, 
      2*ScreenHeight/3, 
      PaddingBG
      );
    rec_fg_title.set(
      m_position.x, 
      m_position.y, 
      m_width, 
      m_title_displayer_height + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    rec_exportName.set(
      m_position.x, 
      m_position.y + rec_bg.h() - m_title_displayer_height - PaddingFG, 
      m_width, 
      m_title_displayer_height + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );

    // Button Data
    button_export.set(
      m_position.x + (rec_bg.w() * m_leftSidePercent) + 8, 
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

    button_addSize.set(
      button_export.x_nopadding(), 
      m_position.y + rec_fg_title.h()*2 + m_buttonVerticalSpace*1 + PaddingFG/2, 
      button_addSize.width() + (PaddingBG + PaddingFG), 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    button_addSize.setColors(
      COLOR_GREEN, 
      COLOR_GREEN_LIGHT, 
      COLOR_GREEN_DARK
      );
    button_addSize._color_outline = COLOR_GREEN_DARK;

    // Size List
    sizeList.setBG(
      m_position.x, 
      m_position.y + rec_fg_title.h() + PaddingFG/2, 
      (rec_bg.w() * m_leftSidePercent) + (PaddingBG + PaddingFG), 
      rec_bg.h() - rec_fg_title.h() - m_title_displayer_height - rec_exportName.h() - PaddingFG/2
      );
    sizeList.update();

    // Input Box
    sizeInputWidth.setSize(
      button_export.x_nopadding(), 
      m_position.y + rec_fg_title.h() + (rec_fg_title.h() + m_buttonVerticalSpace)*2 + PaddingFG/2, 
      50 + (PaddingBG + PaddingFG), 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    sizeInputWidth.update();

    sizeInputHeight.setSize(
      button_export.x_nopadding(), 
      m_position.y + rec_fg_title.h() + (rec_fg_title.h() + m_buttonVerticalSpace)*3 + PaddingFG/2, 
      50 + (PaddingBG + PaddingFG), 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    sizeInputHeight.update();

    prefixInput.setSize(
      button_export.x_nopadding(), 
      m_position.y + rec_fg_title.h() + (rec_fg_title.h() + m_buttonVerticalSpace)*5 + PaddingFG/2, 
      (rec_bg.w() * (1.0f - m_leftSidePercent)) + PaddingFG/2 - 8, 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    prefixInput.update();

    postfixInput.setSize(
      button_export.x_nopadding(), 
      m_position.y + rec_fg_title.h() + (rec_fg_title.h() + m_buttonVerticalSpace)*7 + PaddingFG/2, 
      (rec_bg.w() * (1.0f - m_leftSidePercent)) + PaddingFG/2 - 8, 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    postfixInput.update();

    // Link Button
    button_linkSize.set(
      button_addSize.x() + button_addSize.w() + 8, 
      button_addSize.y(), 
      BUTTON_HEIGHT + 1, 
      BUTTON_HEIGHT + 1, 
      0
      );
    if (m_linkSizes)
    {
      sizeInputHeight.m_locked = true;
      sizeInputHeight.m_text = sizeInputWidth.m_text;
      button_linkSize._image = image_editor_infinity;
    } else
    {
      sizeInputHeight.m_locked = false;
      button_linkSize._image = image_editor_infinity_locked;
    }

    // Button inputs
    if (button_export.pressDown())
    {
      selectFolder("Select Location to Export Images:", "folderSelect_ExportImages", m_exportLastLocation);
    }
    if (button_addSize.pressDown())
    {
      if (m_linkSizes)
      {
        if (sizeInputWidth.m_text.length() > 0)
          sizeList.add(sizeInputWidth.m_text + " x " + sizeInputWidth.m_text);
      }
      //
      else
      {
        if (sizeInputWidth.m_text.length() > 0 && sizeInputHeight.m_text.length() > 0)
          sizeList.add(sizeInputWidth.m_text + " x " + sizeInputHeight.m_text);
      }
    }
    if (button_linkSize.pressDown())
    {
      m_linkSizes = !m_linkSizes;
    }
  }
  public void draw()
  {
    //BG
    rec_bg.draw(COLOR_LIGHT_GREY);
    // Title
    rec_fg_title.draw(COLOR_MID_GREY);
    // Write Title
    rec_fg_title.maskArea();
    DrawShadowedText("Export Settings", rec_fg_title.x() + 4, rec_fg_title.y() + TextSize, COLOR_ORANGE);
    noClip();

    // Buttons
    button_export.draw();
    button_addSize.draw();

    // Input Size Box
    sizeInputWidth.draw();
    sizeInputHeight.draw();
    // Input Size Box Text
    if (m_linkSizes)
    {
      text("- Size", sizeInputWidth.x() + sizeInputWidth.w(), sizeInputWidth.y() + TextSize);
      text("- Size", sizeInputHeight.x() + sizeInputHeight.w(), sizeInputHeight.y() + TextSize);
    }
    //
    else
    {
      text("- Width", sizeInputWidth.x() + sizeInputWidth.w(), sizeInputWidth.y() + TextSize);
      text("- Height", sizeInputHeight.x() + sizeInputHeight.w(), sizeInputHeight.y() + TextSize);
    }
    // Link Inputs
    button_linkSize.draw();

    // Prefix/Post Fix info
    fill(0);
    text("Prefix Name:", prefixInput.x(), prefixInput.y() - 2); 
    text("Postfix Name:", postfixInput.x(), postfixInput.y() - 2); 

    // Result Name BG
    rec_exportName.draw(COLOR_MID_GREY);

    // Result Name Text
    fill(0);
    text("Resulting Filename:", rec_exportName.x() + 2, rec_exportName.y() - 4);
    fill(COLOR_ORANGE);
    String result = "";
    if (prefixInput.m_text.length() > 0)
      result += prefixInput.m_text + '_';

    result += "filename";

    if (postfixInput.m_text.length() > 0)
      result += '_' + postfixInput.m_text;

    result += "_widthXheight";
    result +=".png";

    text(result, rec_exportName.x() + 4, rec_exportName.y() + TextSize);

    postfixInput.draw();
    prefixInput.draw();

    // Size List
    sizeList.draw();
  }

  public void ExportImages(String filePath, LayerSystem layerSystem, MasterList masterList)
  {
    println("~!~");
    for (int s = 0; s < sizeList.m_lines.size(); s++)
    {
      // Check every Master image
      for (int m = 0; m < masterList.m_images.size(); m++)
      {
        // Master Image
        Image masterImage = masterList.m_images.get(m);

        // Name
        String TargetName = masterImage.fileName();
        // Remove extension
        int dotExt = TargetName.lastIndexOf('.');
        if (dotExt != -1)
          TargetName = TargetName.substring(0, TargetName.lastIndexOf('.'));

        // if null, do nothing
        if (masterImage.m_image == null)
        {
          println("Skipped Master Image that was NULL: " + TargetName);
          continue;
        }

        // Target Size
        int TargetWidth = -1;
        int TargetHeight = -1;
        String m_sizeInfo = sizeList.m_lines.get(s);
        if (m_sizeInfo.equals("[Master]"))
        {
          TargetWidth = masterImage.m_image.width;
          TargetHeight = masterImage.m_image.height;
        }
        //
        else
        {
          String[] m_sizeInfoSplit = m_sizeInfo.split("x");
          if (m_sizeInfoSplit.length == 2)
          {
            TargetWidth = PApplet.parseInt(m_sizeInfoSplit[0].trim());
            TargetHeight = PApplet.parseInt(m_sizeInfoSplit[1].trim());
          }
        }

        // Error Check
        if (TargetWidth == -1 || TargetHeight == -1)
        {
          println("ERROR EXPORTING IMAGE SIZE: " + TargetWidth + ", " + TargetHeight);
          continue;
        }


        // Final image pixels (start empty)
        ArrayList<Integer> finalImagePixels = new ArrayList<Integer>(TargetWidth * TargetHeight);
        for (int fill = 0; fill < TargetWidth * TargetHeight; fill++)
          finalImagePixels.add(color(0, 0, 0, 0));

        // Each Pixel
        for (int y = 0; y < TargetHeight; y++)
        {
          for (int x = 0; x < TargetWidth; x++)
          {
            int index = y * TargetWidth + x;

            float[] Pixel = { 0, 0, 0, 0};

            // Each Layer
            for (int l = layerSystem.m_Layers.size() - 1; l >= 0; l--)
            {
              // Acquire Layer Image
              Layer layer = layerSystem.m_Layers.get(l);
              if (!layer.imageAvailable())
                continue;

              Image layerImage = null;
              //
              if (layer.m_type == LayerType.IMAGE)
                layerImage = layer.m_image;
              else if (layer.m_type == LayerType.MASTER)
                layerImage =masterImage;
              //
              if (layerImage == null)
                continue;

              // PixelColorID
              Integer _pixelColorID;
              // Fetch pixel
              if (layerImage.width() == TargetWidth && layerImage.height() == TargetHeight)
              {
                _pixelColorID = layerImage.fetchPixel(index);
              }
              // Sample Pixel
              else
              {
                float u = PApplet.parseFloat(x) / PApplet.parseFloat(TargetWidth);
                float v = PApplet.parseFloat(y) / PApplet.parseFloat(TargetHeight);
                _pixelColorID = layerImage.samplePixel(u, v);
              }
              // Convert ID to color
              float alpha = alpha(_pixelColorID) / 255.0f;
              // Interpolate colors
              Pixel[0] = lerp(Pixel[0], red(_pixelColorID), alpha);
              Pixel[1] = lerp(Pixel[1], green(_pixelColorID), alpha);
              Pixel[2] = lerp(Pixel[2], blue(_pixelColorID), alpha);
              Pixel[3] = min(Pixel[3] + alpha(_pixelColorID), 255); // Alpha is additive
            }

            Integer _finalColor = color(Pixel[0], Pixel[1], Pixel[2], Pixel[3]);
            finalImagePixels.set(index, _finalColor);
          }
        }

        Image outputImage = new Image(finalImagePixels, TargetWidth, true);
        String outputPath = filePath + '\\';

        if (prefixInput.m_text.length() > 0)
          outputPath += prefixInput.m_text + '_';

        outputPath += TargetName;

        if (postfixInput.m_text.length() > 0)
          outputPath += '_' + postfixInput.m_text;

        outputPath += '_' + str(TargetWidth) + "x" + str(TargetHeight) + ".png";

        println(outputPath);
        outputImage.save(outputPath);
      }
    }
  }
}

class Image
{
  private PImage m_image = null;
  private File m_file = null;

  public void draw(float x, float y, float w, float h)
  {
    if (m_image == null)
      return;

    image(m_image, x, y, w, h);
  }

  public float width()
  {
    if (m_image != null)
      return m_image.width;

    return 0;
  }
  public float height()
  {
    if (m_image != null)
      return m_image.height;

    return 0;
  }
  public float aspectRatio()
  {
    if (m_image != null)
      return m_image.width/m_image.height;

    return 1;
  }
  public String fileName()
  {
    if (m_file == null)
      return "";

    return m_file.getName();
  }
  public String directory()
  {
    if (m_file == null)
      return "";

    return m_file.getAbsolutePath();
  }

  public float fileNameLength()
  {
    return textWidth(fileName());
  }
  public float directoryLength()
  {
    return textWidth(directory());
  }

  public int fetchPixel(int index)
  {
    if(m_image == null)
      return color(0,0,0,0);
    
    return m_image.pixels[index];
  }
  public int samplePixel(float u, float v)
  {
    if(m_image == null)
      return color(0,0,0,0);
    
    int x = PApplet.parseInt(u * m_image.width);
    int y = PApplet.parseInt(v * m_image.height);
    int index = y * m_image.width + x;
    
    return m_image.pixels[index];
  }
  //color GetPixel(int i, int _targetWidth, int _targetHeight)
  //{
  //  // Pixel Fetch
  //  if (_targetWidth == m_image.width && _targetHeight == m_image.height)
  //  {
  //    return m_image.pixels[i];
  //  }
  //  // Pixel Sample
  //  int target_x = i % _targetWidth;
  //  int target_y = i / _targetHeight;
  //  float resized_x = constrain(float(target_x) / float(_targetWidth), 0.0f, 1.0f);
  //  float resized_y = constrain(float(target_y) / float(_targetHeight), 0.0f, 1.0f);
  //  int new_x = int(resized_x * float(m_image.width));
  //  int new_y = int(resized_y * float(m_image.height));

  //  color c = m_image.get(new_x, new_y);

  //  return c;
  //}

  public void save(String filepath)
  {
    if (m_image == null)
      println("Saving Error (no image), " + filepath);

    m_image.save(filepath);
  }

  Image(Image other)
  {
    m_image = other.m_image.get();
  }
  Image(String filepath)
  {
    // m_filePath = filepath;
    m_file = new File(filepath);
    // m_filePathWidth = textWidth(filepath);
    if (fileExists(filepath))
      m_image = loadImage(filepath);
    else
      println("Failed to load image: " + filepath);
  }
  Image(ArrayList<Integer> _colors, int _width, boolean _hasAlpha)
  {
    int _height = _colors.size() / _width;

    m_image = createImage(_width, _height, _hasAlpha ? ARGB : RGB);
    m_image.loadPixels();

    for (int i = 0; i < _colors.size(); i++)
    {
      m_image.pixels[i] = _colors.get(i);
    }

    m_image.updatePixels();
  }
}

class InputBox
{
  Rectangle rec_bg = new Rectangle();
  String m_text = "";
  boolean m_selected = false;
  boolean m_numbersOnly = false;
  int m_characterLimit = -1;
  boolean m_locked = false;

  public void setSize(float x, float y, float w, float h, float padding)
  {
    rec_bg.set(x, y, w, h, padding);
  }

  public float x()
  {
    return rec_bg.x();
  }
  public float y()
  {
    return rec_bg.y();
  }
  public float w()
  {
    return rec_bg.w();
  }
  public float h()
  {
    return rec_bg.h();
  }

  public void unselect()
  {
    m_selected = false;
  }

  public void updateInput(char c)
  {
    if (!m_selected || m_locked)
      return;

    // Input limit
    if (m_text.length() == m_characterLimit)
      return;

    // Numbers only [ignore character and 0 if first character
    if (m_numbersOnly && (!Character.isDigit(c) || (m_text.length() == 0 && c == '0')))
      return;

    m_text += c;
  }
  public void eraseInput()
  {
    if (m_text == null || !m_selected || m_text.length() == 0)
      return;

    m_text = m_text.substring(0, m_text.length() - 1);
  }

  public void update()
  {
    if (mousePressed && !m_locked)
    {
      unselect();

      if (rec_bg.isMouseOver())
        m_selected = true;
    }
  }
  public void draw()
  {
    // BG
    if (m_selected)
      stroke(COLOR_YELLOW);
    else
      stroke(0);

    if (m_locked)
      rec_bg.draw(COLOR_DARK_GREY);
    else if (rec_bg.isMouseOver())
      if (mousePressed)
        rec_bg.draw(COLOR_MID_GREY);
      else
        rec_bg.draw(COLOR_LIGHT_GREY);
    else
      rec_bg.draw(COLOR_WHITE_FAINT);

    noStroke();

    // Text
    fill(0);
    rec_bg.maskArea();
    text(m_text, rec_bg.x() + 2, rec_bg.y() + TextSize);
    noClip();

    // Input Vertical Line
    if (m_selected && (floor(millis() / 500.0f) % 2 == 0))
    {
      noFill();
      stroke(0);
      float textW = textWidth(m_text);
      line(rec_bg.x() + textW  + 2, rec_bg.y(), rec_bg.x() + textW  + 2, rec_bg.y() + rec_bg.h());
      noStroke();
    }
  }
}

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
  Button_Square m_button_visible = new Button_Square("");
  Button_Square m_button_moveUp = new Button_Square("");
  Button_Square m_button_moveDown = new Button_Square("");
  boolean       m_enabled = true;

  Layer(LayerType _type, String _filePath)
  {
    m_type = _type;
    if (_type == LayerType.IMAGE)
    {
      if (_filePath.length() > 0)
      {
        m_image = new Image(_filePath);
        m_name = m_image.fileName();
      }
      //
      else
        m_name = "ERROR";
    }
    //
    else
    {
      m_name = "MASTER";
    }
  }
  public boolean imageAvailable()
  {
    // Disabled = no image
    if (!m_enabled)
      return false;

    // Null image for Image mode = no image
    if (m_type == LayerType.IMAGE && m_image == null)
      return false;

    return true;
  }
  public void update()
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
  public void draw(Rectangle bg_rect, boolean selected)
  {
    float alpha = 255;

    if (!imageAvailable())
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
    // Master Icon
    else if (m_type == LayerType.MASTER)
    {
      // Checkerboard first
      image_checkerboard.draw(
        bg_rect.x() + LayerIconPadding/2, 
        bg_rect.y() + LayerIconPadding/2, 
        bg_rect.h() - LayerIconPadding, 
        bg_rect.h() - LayerIconPadding
        );
      // Selected Icon from master list
      if (masterList1.m_selectedImage != null)
      {
        masterList1.m_selectedImage.draw(
          bg_rect.x() + LayerIconPadding/2, 
          bg_rect.y() + LayerIconPadding/2, 
          bg_rect.h() - LayerIconPadding, 
          bg_rect.h() - LayerIconPadding
          );
      }
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
  Button_Square button_addImageLayer = new Button_Square("Add Image");
  // Scrollbar
  Scrollbar scrollbar = new Scrollbar();

  public Layer getMasterLayer()
  {
    for (int i = 0; i < m_Layers.size(); i++)
    {
      if (m_Layers.get(i).m_type == LayerType.MASTER)
        return m_Layers.get(i);
    }
    return null;
  }

  public void updateScroll(float direction)
  {
    update();
    if (rec_fg_layers.isMouseOver() || scrollbar.isMouseOver())
    {
      scrollbar.updateScroll(direction);
    }
  }

  public void unselect()
  {
    m_selectedLayer = null;
  }
  public void eraseSelectedLayer()
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

  public void update()
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
    if (button_addImageLayer.pressDown())
    {
      selectInput("Select Image to Import:", "fileSelect_AddImageLayer");
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
      if (m_Layers.get(i).m_button_visible.pressDown())
      {
        m_Layers.get(i).m_enabled = !m_Layers.get(i).m_enabled;
      }
      // Button Move Up/Down
      if (m_Layers.get(i).m_button_moveUp.pressDown() && (i > 0))
      {
        Layer tmp = m_Layers.get(i);
        m_Layers.set(i, m_Layers.get(i - 1));
        m_Layers.set(i - 1, tmp);
        break;
      }
      if (m_Layers.get(i).m_button_moveDown.pressDown() && (i < m_Layers.size() - 1))
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
      if (mousePressed)
      {
        unselect();

        // Item Click
        if (rec_fg_layers.isMouseOver() && layerRect.isMouseOver())
        {
          m_selectedLayer = m_Layers.get(i);
          break;
        }
      }
    }
  }

  public void draw()
  {
    // BG
    fill(COLOR_LIGHT_GREY);
    rec_bg.draw();

    // Title
    fill(COLOR_MID_GREY);
    rec_fg_title.draw();

    // Write Title
    rec_fg_title.maskArea();
    DrawShadowedText("Layers", rec_fg_title.x() + 7, rec_fg_title.y() + TextSize, COLOR_ORANGE);
    noClip();

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

  public void eraseSelectedImage()
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
        scrollbar.updateScroll(0.0f);
        break; // end for loop
      }
    }
  }

  public void updateScroll(float direction)
  {
    update();
    if (rec_fg_list.isMouseOver() || scrollbar.isMouseOver())
    {
      scrollbar.updateScroll(direction);
    }
  }

  public void unselect()
  {
    m_selectedImage = null;
  }

  public void update()
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

  public void draw()
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
      float timeSlow = millis() / 80.0f;
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
      int c = COLOR_BLACK;

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

class Rectangle
{
  float[] m_data = {0, 0, 0, 0};
  float m_padding = 0;
  Rectangle()
  {
  }
  Rectangle(float x, float y, float w, float h, float padding)
  {
    set(x,y,w,h,padding);
  }
  public void set(float x, float y, float w, float h, float padding)
  {
    m_data[0] = x;
    m_data[1] = y;
    m_data[2] = w;
    m_data[3] = h;
    m_padding = padding;
  }
  public float x_nopadding() { 
    return m_data[0];
  }
  public float y_nopadding() { 
    return m_data[1];
  }
  public float w_nopadding() { 
    return m_data[2];
  }
  public float h_nopadding() { 
    return m_data[3];
  }
  public float x(){
    return m_data[0] + m_padding/2;
  }
  public float y(){
    return m_data[1] + m_padding/2;
  }
  public float w(){
    return m_data[2] - m_padding;
  }
  public float h(){
    return m_data[3] - m_padding;
  }
  
  // [0,1] of where the MouseX is on the rectangle
  public float mouseXHoverRatio()
  {
    return constrain((mouseX - x()) / w(), 0, 1);
  }
  // [0,1] of where the MouseY is on the rectangle
  public float mouseYHoverRatio()
  {
    return constrain((mouseX - y()) / h(), 0, 1);
  }
  
  public boolean isMouseOver()
  {
    return (
      mouseX >= (m_data[0] + m_padding/2) && mouseX < (m_data[0] + m_data[2] - m_padding/2) &&
      mouseY >= (m_data[1] + m_padding/2) && mouseY < (m_data[1] + m_data[3] - m_padding/2)
      );
  }
  public void maskArea()
  {
    clip(m_data[0] + m_padding/2, m_data[1] + m_padding/2, m_data[2] - m_padding, m_data[3] - m_padding);
  }
  public void draw(int c)
  {
    fill(c);
    rect(m_data[0] + m_padding/2, m_data[1] + m_padding/2, m_data[2] - m_padding, m_data[3] - m_padding);
  }
  public void draw()
  {
    rect(m_data[0] + m_padding/2, m_data[1] + m_padding/2, m_data[2] - m_padding, m_data[3] - m_padding);
  }
}

class Scrollbar
{
  Rectangle m_bg = new Rectangle();
  Rectangle m_fg = new Rectangle();

  float m_scroll = 0.0f;
  float m_scrollMax = 0.0f;
  float m_scrollRatio = 0.0f;
  float m_scrollbarBGHeight = 1.0f;
  float m_scrollbarFGHeight = 1.0f;
  final float m_scrollSpeed = 50;

  public float getYDisplacement()
  {
    return m_scroll;
  }

  public boolean isMouseOver()
  {
    return m_bg.isMouseOver();
  }

  // Check
  public boolean isNeeded()
  {
    return (m_scrollbarFGHeight < m_scrollbarBGHeight);
  }
  public float getRequiredWidth()
  {
    return isNeeded() ? m_bg.w() : 0;
  }

  public void updateScroll(float direction)
  {
    m_scroll += direction * m_scrollSpeed;
    m_scroll = constrain(m_scroll, 0, m_scrollMax);

    if (m_scrollMax == 0.0f)
      m_scrollRatio = 1.0f;
    else
      m_scrollRatio = m_scroll / m_scrollMax;
  }

  public void setSize(float x, float y, float w, float h, float compareHeight)
  {
    m_scrollbarBGHeight = h;
    m_scrollbarFGHeight = min(m_scrollbarBGHeight / compareHeight, 1) * m_scrollbarBGHeight;
  
    m_scrollMax = max(0, compareHeight - m_scrollbarBGHeight);

    m_bg.set(x, y, w, h, 0);

    m_fg.set(
      x, 
      y + m_scrollRatio * (h - m_scrollbarFGHeight), 
      w, 
      m_scrollbarFGHeight, 
      0
      );
  }
  public void draw()
  {
    m_bg.draw(COLOR_DARK_GREY);
    m_fg.draw(COLOR_WHITE_FAINT);
  }
}

// Master Colors [Colorful]
final int COLOR_ORANGE = color(255, 127, 0);
final int COLOR_ORANGE_LIGHT = color(255, 195, 45);
final int COLOR_YELLOW = color(255, 255, 0);
final int COLOR_RED = color(230, 65, 65);
final int COLOR_RED_LIGHT = color(245, 95, 95);
final int COLOR_RED_DARK = color(180, 0, 0);
final int COLOR_GREEN = color(45, 245, 45);
final int COLOR_GREEN_LIGHT = color(95, 245, 95);
final int COLOR_GREEN_DARK = color(0, 180, 0);
// Master Colors [Monochrome]
final int COLOR_BLACK = color(0);
final int COLOR_DARK_GREY = color(40);
final int COLOR_MID_GREY = color(60);
final int COLOR_LIGHT_GREY = color(115);
final int COLOR_WHITE_FAINT = color(200);

// Fonts
PFont FONT_ARIAL;
PFont FONT_ARIAL_BOLD;
public void initFonts()
{
  FONT_ARIAL = createFont("Arial", TextSize);
  FONT_ARIAL_BOLD = createFont("Arial Bold", TextSize);
  textFont(FONT_ARIAL);
}
public void setFontBold(boolean state)
{
  if (state)
    textFont(FONT_ARIAL_BOLD);
  else
    textFont(FONT_ARIAL);
}

// Editor Images
Image image_editor_eyeOpen = null;
Image image_editor_eyeClosed = null;
Image image_editor_up = null;
Image image_editor_down = null;
Image image_checkerboard = null;
Image image_editor_infinity = null;
Image image_editor_infinity_locked = null;

// Misc Variables
final float BUTTON_HEIGHT = 20;
final int TextSize = 15;
final float SCROLLBAR_WIDTH = 10;

// Utility Functions
public void DrawShadowedText(String str, float x, float y, int c)
{
  fill(0);
  text(str, x+1, y+1);
  fill(c);
  text(str, x, y);
}
public boolean fileExists(String path)
{
  // Check data path
  File file = new File(dataPath("") + '/' + path);
  if(file.isFile())
    return true;
  
  // Check full path
  file = new File(path);
  return file.isFile(); // return file.exists();
}
public void printColor(int c)
{
   println(red(c) + " " + green(c) + " " + blue(c));
}

MessageBox messageBox = null;
enum MessageBoxType
{
  IMPORT
}
class MessageBox
{
  private MessageBoxType m_type;
  private String m_message;
  private ArrayList<String> m_choices = new ArrayList<String>();
  //
  MessageBox(MessageBoxType type)
  {
    m_type = type;

    switch(m_type)
    {
    case IMPORT:
      {
        m_message = "Where to Import Image(s)";
        m_choices.add("Master List");
        m_choices.add("Layers");
      }
      break;
    }
  }
  //
  public void update()
  {
    switch(m_type)
    {
    case IMPORT:
      {
      }
      break;
    }
  }
  //
  public void draw()
  {
    switch(m_type)
    {
    case IMPORT:
      {
        // BG
        fill(0, 150);
        rect(0, 0, ScreenWidth, ScreenHeight);

        // Center Box
        fill(COLOR_MID_GREY);
        rect(ScreenWidth/4, ScreenHeight/4, ScreenWidth/2, ScreenHeight/2);

        fill(255);
        setFontBold(true);
        text(m_message, ScreenWidth/2 - textWidth(m_message)/2, ScreenHeight/2 - TextSize);

        for (int i = 0; i < m_choices.size(); i++)
        {
          text(m_choices.get(i), ScreenWidth/2 - textWidth(m_choices.get(i))/2, ScreenHeight/2 - TextSize +  (i + 1) * 40);
        }
        setFontBold(false);
      }
      break;
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ImageCompositer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

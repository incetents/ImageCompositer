
// Library
import drop.*;
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

void init()
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
void draw()
{
  ScreenWidth = width;
  ScreenHeight = height;

  background(COLOR_DARK_GREY);

  // 25 %
  masterList1.m_position.x = PaddingBG/4;
  masterList1.m_width = (ScreenWidth * 0.25);
  masterList1.update();
  masterList1.draw();

  // 33 %
  layerSystem1.m_position.x = (ScreenWidth * 0.25);
  layerSystem1.m_width = (ScreenWidth / 3);
  layerSystem1.update();
  layerSystem1.draw();

  // 42%
  exportSystem1.m_position.x = (ScreenWidth * 0.25 + ScreenWidth / 3) - PaddingBG/4;
  exportSystem1.m_width = ScreenWidth - (ScreenWidth * 0.25) - (ScreenWidth / 3);
  exportSystem1.update();
  exportSystem1.draw();

  // End of frame update
  MousePressed = false;
  MouseReleased = false;
}

void keyPressed()
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
void keyReleased()
{
  if (key == 'a' || key == 'A')
  {
  }
}

void mousePressed()
{
  MousePressed = true;
}
void mouseReleased()
{
  MouseReleased = true;
}

void mouseWheel(MouseEvent event)
{
  //float e = event.getCount();
  //println(e);
  masterList1.updateScroll(event.getCount());
  layerSystem1.updateScroll(event.getCount());
  exportSystem1.updateScroll(event.getCount());
}

// FILE Select
void fileSelect_AddFileToMasterList(File selection)
{
  if (selection == null)
  {
    println("Selection Abort");
    return;
  }

  masterList1.m_images.add(new Image(selection.getAbsolutePath()));
}
void fileSelect_AddImageLayer(File selection)
{
  if (selection == null)
  {
    println("Selection Abort");
    return;
  }

  layerSystem1.m_Layers.add(new Layer(LayerType.IMAGE, selection.getAbsolutePath()));
}
// Folder Select
void folderSelect_AddFolderToMasterList(File selection)
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
void folderSelect_ExportImages(File selection)
{
  if (selection == null)
  {
    println("Selection Abort");
    return;
  }

  exportSystem1.m_exportLastLocation = new File(selection.getAbsolutePath());
  exportSystem1.ExportImages(selection.getAbsolutePath(), layerSystem1, masterList1);
}


void dropEvent(DropEvent theDropEvent)
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

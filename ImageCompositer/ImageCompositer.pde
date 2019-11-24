// Library
import drop.*;
SDrop drop;

// Padding
float PaddingBG = 8;
float PaddingFG = 12;

// Mouse Released
boolean MouseReleased = false;

// Sizes
int ScreenWidth = 1020;
int ScreenHeight = 720;

// Screens
MasterList masterList1 = new MasterList();
LayerSystem layerSystem1 = new LayerSystem();
ExportSystem exportSystem1 = new ExportSystem();

void unselectAll()
{
  masterList1.unselect();
  layerSystem1.unselect();
}

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
  image_editor_eyeClosed = new Image("eye_closed.png");
  image_editor_up = new Image("up_arrow.png");
  image_editor_down = new Image("down_arrow.png");

  initFonts();
  textSize(TextSize);
  textLeading(TextSize);
  //
  masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\cloud.png"));
  masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\color.jpg"));


  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\test.png"));
  //for (int i = 0; i < 28; i++)
  //  masterList1.m_images.add(new Image("EMPTY" + str(i)));

  //masterList1.m_images.add(new Image("\\Users\\incet\\OneDrive\\Desktop\\debug images\\Metal11_disp.jpg"));

  layerSystem1.m_Layers.add(new Layer("MASTER", LayerType.MASTER, ""));

  for (int i = 0; i < 3; i++)
    layerSystem1.m_Layers.add(new Layer("test" + str(i), LayerType.IMAGE, ""));
}
void draw()
{
  ScreenWidth = width;
  ScreenHeight = height;

  background(COLOR_DARK_GREY);

  boolean UpdateSystems = ButtonRequest == ButtonID.NONE;

  if (UpdateSystems)
  {
    masterList1.m_position.x = PaddingBG/4;
    masterList1.m_width = (ScreenWidth / 3);
    masterList1.update();
  }

  masterList1.draw();

  if (UpdateSystems)
  {

    layerSystem1.m_position.x = (ScreenWidth / 3);
    layerSystem1.m_width = (ScreenWidth / 3);
    layerSystem1.update();
  }

  layerSystem1.draw();

  if (UpdateSystems)
  {
    exportSystem1.m_position.x = (2 * ScreenWidth / 3) - PaddingBG/4;
    exportSystem1.m_width = (ScreenWidth / 3);
    exportSystem1.update();
  }

  exportSystem1.draw();

  // End of frame update
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
  }

  if (key == '1')
    PaddingBG--;
  else if (key == '2')
    PaddingBG++;

  if (key == '3')
    PaddingFG--;
  else if (key == '4')
    PaddingFG++;

  PaddingBG = max(PaddingBG, 0);
  PaddingFG = max(PaddingFG, 0);

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
}

// FILE IMPORT
void fileSelected(File selection)
{
  //
  if (selection == null)
  {
    // Selection Cancelled or exited
    println("No selection");
  }
  //
  else if (ButtonRequest == ButtonID.ADD_FILE_TO_MASTERLIST)
  {
    masterList1.m_images.add(new Image(selection.getAbsolutePath()));
  }
  //
  else if (ButtonRequest == ButtonID.ADD_IMAGE_LAYER)
  {
    File f = new File(selection.getAbsolutePath());
    layerSystem1.m_Layers.add(new Layer(f.getName(), LayerType.IMAGE, selection.getAbsolutePath()));
  }

  // End Request
  ButtonRequest = ButtonID.NONE;
}
// FOLDER IMPORT
void folderSelected(File selection)
{
  //
  if (selection == null)
  {
    // Selection Cancelled or exited
    println("No selection");
  }
  //
  else if (ButtonRequest == ButtonID.ADD_FOLDER_TO_MASTERLIST)
  {
    println("User selected " + selection.getAbsolutePath());
    java.io.File folder = new java.io.File(selection.getAbsolutePath());
    // list the files in the data folder
    String[] filenames = folder.list();

    // Get files
    for (int i = 0; i < filenames.length; i++)
    {
      masterList1.m_images.add(new Image(folder.getAbsolutePath() + '\\' + filenames[i]));
    }
  }
  //
  else if (ButtonRequest == ButtonID.EXPORT_IMAGES)
  {
    println("EXPORT");
  }
  // End Request
  ButtonRequest = ButtonID.NONE;
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

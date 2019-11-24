// Library
import drop.*;
SDrop drop;

// Padding
final float PaddingBG = 10;
final float PaddingFG = 24;

// Sizes
int ScreenWidth = 1020;
int ScreenHeight = 720;
final int TextSize = 15;

// Screens
MasterList masterList1 = new MasterList(0, 0);
LayerSystem layerSystem1 = new LayerSystem(masterList1.m_width - PaddingBG/2, 0);
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
  void update()
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
  void draw()
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
        text(m_message, ScreenWidth/2 - textWidth(m_message)/2, ScreenHeight/2 - TextSize);
      }
      break;
    }
  }
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
  initFonts();
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

  if (messageBox == null)
    masterList1.update();
  masterList1.draw();

  if (messageBox == null)
    layerSystem1.update();
  layerSystem1.draw();

  if (messageBox != null)
  {
    messageBox.update();
    messageBox.draw();
  }
}

void keyPressed()
{
  // Delete
  //println(keyCode);
  if (keyCode == 8 || keyCode == 127) // RETURN and DELETE
  {
    masterList1.eraseSelectedImage();
  }
  
  if(key == 'a' || key == 'A')
  {
    messageBox = new MessageBox(MessageBoxType.IMPORT);
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
    //println(theDropEvent.filePath());
    //test = theDropEvent.loadImage();

    if (fileExists(theDropEvent.filePath()))
      println("FileExists");

    //masterList1.m_images.add(new Image(theDropEvent.filePath()));
  }
}

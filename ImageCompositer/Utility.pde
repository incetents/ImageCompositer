
// Master Colors [Colorful]
final color COLOR_ORANGE = color(255, 127, 0);
final color COLOR_ORANGE_LIGHT = color(255, 195, 45);
final color COLOR_YELLOW = color(255, 255, 0);
final color COLOR_RED = color(230, 65, 65);
final color COLOR_GREEN = color(45, 245, 45);
final color COLOR_GREEN_LIGHT = color(95, 245, 95);
final color COLOR_GREEN_DARK = color(0, 180, 0);
// Master Colors [Monochrome]
final color COLOR_BLACK = color(0);
final color COLOR_DARK_GREY = color(40);
final color COLOR_MID_GREY = color(60);
final color COLOR_LIGHT_GREY = color(115);
final color COLOR_WHITE_FAINT = color(200);

// Fonts
PFont FONT_ARIAL;
PFont FONT_ARIAL_BOLD;
void initFonts()
{
  FONT_ARIAL = createFont("Arial", TextSize);
  FONT_ARIAL_BOLD = createFont("Arial Bold", TextSize);
  textFont(FONT_ARIAL);
}
void setFontBold(boolean state)
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

// Misc Variables
final float BUTTON_HEIGHT = 20;
final int TextSize = 15;
final float SCROLLBAR_WIDTH = 10;

// Utility Functions
void DrawShadowedText(String str, float x, float y, color c)
{
  fill(0);
  text(str, x+1, y+1);
  fill(c);
  text(str, x, y);
}
boolean fileExists(String path)
{
  // Check data path
  File file = new File(dataPath("") + '/' + path);
  if(file.isFile())
    return true;
  
  // Check full path
  file = new File(path);
  return file.isFile(); // return file.exists();
}
void printColor(color c)
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

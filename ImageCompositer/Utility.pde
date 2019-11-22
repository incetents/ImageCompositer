
// Master Colors
final color COLOR_ORANGE = color(255,127,0);
final color COLOR_YELLOW = color(255,255,0);
final color COLOR_RED = color(230, 65, 65);
final color COLOR_BLACK = color(0);
final color COLOR_DARK_GREY = color(40);
final color COLOR_MID_GREY = color(60);
final color COLOR_LIGHT_GREY = color(200);

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
  File file = new File(path);
  return file.exists();
} 

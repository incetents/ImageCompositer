
void DrawShadowedText(String str, float x, float y, color c)
{
  fill(0);
  text(str, x+1, y+1);
  fill(c);
  text(str, x, y);
}

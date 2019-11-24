
class Image
{
  private PImage m_image = null;
  private File m_file = null;

  void draw(float x, float y, float w, float h)
  {
    if (m_image == null)
      return;

    image(m_image, x, y, w, h);
  }

  float width()
  {
    if (m_image != null)
      return m_image.width;

    return 0;
  }
  float height()
  {
    if (m_image != null)
      return m_image.height;

    return 0;
  }
  float aspectRatio()
  {
    if (m_image != null)
      return m_image.width/m_image.height;

    return 1;
  }
  String fileName()
  {
    if (m_file == null)
      return "";

    return m_file.getName();
  }
  String directory()
  {
    if (m_file == null)
      return "";

    return m_file.getAbsolutePath();
  }

  float fileNameLength()
  {
    return textWidth(fileName());
  }
  float directoryLength()
  {
    return textWidth(directory());
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
  Image()
  {
    m_image = createImage(8, 8, RGB);
    m_image.loadPixels();

    for (int y = 0; y < 8; y++)
    {
      for (int x = 0; x < 8; x++)
      {
        int index = y * 8 + x;
        if (x % 2 == y % 2)
          m_image.pixels[index] = color(255);
        else
          m_image.pixels[index] = color(90);
      }
    }
    
    m_image.updatePixels();
  }
}

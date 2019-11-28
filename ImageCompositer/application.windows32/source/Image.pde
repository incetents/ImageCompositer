
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

  color fetchPixel(int index)
  {
    if(m_image == null)
      return color(0,0,0,0);
    
    return m_image.pixels[index];
  }
  color samplePixel(float u, float v)
  {
    if(m_image == null)
      return color(0,0,0,0);
    
    int x = int(u * m_image.width);
    int y = int(v * m_image.height);
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

  void save(String filepath)
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

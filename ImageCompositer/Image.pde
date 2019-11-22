
class Image
{
  PImage m_image = null;
  String m_filePath;
  float m_filePathWidth;
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
  Image(String filepath)
  {
    m_filePath = filepath;
    m_filePathWidth = textWidth(filepath);
    m_image = loadImage(m_filePath);
    println(m_image);
  }
}

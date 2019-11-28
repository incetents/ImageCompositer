
class ExportSystem
{
  // Position
  PVector m_position = new PVector(0, 0);
  // Sizes
  float m_width = 300;
  final float m_title_displayer_height = 20;
  final float m_buttonVerticalSpace = 6;
  final float m_leftSidePercent = 0.42;
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

  void updateInput(char c)
  {
    sizeInputWidth.updateInput(c);
    sizeInputHeight.updateInput(c);
    prefixInput.updateInput(c);
    postfixInput.updateInput(c);
  }
  void eraseInput()
  {
    sizeInputWidth.eraseInput();
    sizeInputHeight.eraseInput();
    prefixInput.eraseInput();
    postfixInput.eraseInput();
  }

  void updateScroll(float direction)
  {
    sizeList.updateScroll(direction);
  }

  void unselect()
  {
    sizeList.unselect();
  }

  void eraseSelectedSize()
  {
    if (sizeList.getSelection() != "[Master]")
      sizeList.eraseSelection();
  }

  void update()
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
      (rec_bg.w() * (1.0 - m_leftSidePercent)) + PaddingFG/2 - 8, 
      BUTTON_HEIGHT + (PaddingBG + PaddingFG), 
      PaddingBG + PaddingFG
      );
    prefixInput.update();

    postfixInput.setSize(
      button_export.x_nopadding(), 
      m_position.y + rec_fg_title.h() + (rec_fg_title.h() + m_buttonVerticalSpace)*7 + PaddingFG/2, 
      (rec_bg.w() * (1.0 - m_leftSidePercent)) + PaddingFG/2 - 8, 
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
  void draw()
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

  void ExportImages(String filePath, LayerSystem layerSystem, MasterList masterList)
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
            TargetWidth = int(m_sizeInfoSplit[0].trim());
            TargetHeight = int(m_sizeInfoSplit[1].trim());
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
                float u = float(x) / float(TargetWidth);
                float v = float(y) / float(TargetHeight);
                _pixelColorID = layerImage.samplePixel(u, v);
              }
              // Convert ID to color
              float alpha = alpha(_pixelColorID) / 255.0;
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

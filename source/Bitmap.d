module tgd.Bitmap;

import derelict.freeimage.freeimage;

public import tgd.Color;

class Bitmap
{
    private FIBITMAP* m_bitmap;

    public this(in int width, in int height)
    {
        this.m_bitmap = FreeImage_Allocate(width, height, 24);
    }

    public void save(in string fileName, in int fileFormat = FIF_PNG)
    {
        import std.string : toStringz;

        FreeImage_Save(fileFormat, this.m_bitmap, fileName.toStringz(), 0);
    }

    public void setPixelColor()(in int x, in int y, Color* color)
    {
        FreeImage_SetPixelColor(this.m_bitmap, x, y, color);
    }

    public Color* opIndexAssign(Color* color, int x, int y)
    {
        this.setPixelColor(x, y, color);
        return color;
    }

    public void dispose()
    {
        if (this.m_bitmap !is null)
        {
            FreeImage_Unload(this.m_bitmap);
        }
    }
}

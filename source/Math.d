module tgd.Math;

public import std.math;

import tgd.Color;

float distance(float x1, float y1, float x2, float y2) pure nothrow @safe @nogc
{
    return ceil( sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2)) );
}

Color lerp()(in auto ref Color c1, in auto ref Color c2, float a) pure nothrow @safe @nogc
{
    ubyte b = cast(ubyte)( (c2.rgbBlue - c1.rgbBlue) * a + c1.rgbBlue );
    ubyte g = cast(ubyte)( (c2.rgbGreen- c1.rgbGreen) * a + c1.rgbGreen );
    ubyte r = cast(ubyte)( (c2.rgbRed - c1.rgbRed) * a + c1.rgbRed );

    return Color(b, g, r);
}

struct Point
{
    public int x;
    public int y;
}

struct Size
{
    public int width;
    public int height;
}

struct Rectangle
{
    public Point position;
    public Size size;

    public this(in int x, in int y, in int width, in int height) pure nothrow @safe @nogc
    {
        this.position = Point(x, y);
        this.size = Size(width, height);
    }
    
    @property pure nothrow @safe @nogc
    {
        public int right()
        {
            return position.x + size.width;
        }

        public int top()
        {
            return position.y + size.height;
        }
    }
}
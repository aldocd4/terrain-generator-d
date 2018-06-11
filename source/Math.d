module tgd.Math;

public import std.math;

float distance(float x1, float y1, float x2, float y2) 
{
    return ceil( sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2)) );
}    
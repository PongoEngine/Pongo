package pongo.display;

@:enum
abstract BlendMode(Int) to Int
{
    var NORMAL = 1;
    var LIGHTEST = 2;
    var SUBTRACT = 3;
}


// BLEND - linear interpolation of colours: C = A*factor + B

// ADD - additive blending with white clip: C = min(A*factor + B, 255)

// SUBTRACT - subtractive blending with black clip: C = max(B - A*factor, 0)

// DARKEST - only the darkest colour succeeds: C = min(A*factor, B)

// LIGHTEST - only the lightest colour succeeds: C = max(A*factor, B)

// DIFFERENCE - subtract colors from underlying image.

// EXCLUSION - similar to DIFFERENCE, but less extreme.

// MULTIPLY - Multiply the colors, result will always be darker.

// SCREEN - Opposite multiply, uses inverse values of the colors.

// OVERLAY - A mix of MULTIPLY and SCREEN. Multiplies dark values, and screens light values.

// HARD_LIGHT - SCREEN when greater than 50% gray, MULTIPLY when lower.

// SOFT_LIGHT - Mix of DARKEST and LIGHTEST. Works like OVERLAY, but not as harsh.

// DODGE - Lightens light tones and increases contrast, ignores darks. Called "Color Dodge" in Illustrator and Photoshop.

// BURN
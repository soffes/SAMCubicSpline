# SAMCubicSpline

I found this math somewhere and tweaked it some to work the way I needed it. A [cubic spline](http://en.wikipedia.org/wiki/Cubic_spline) is great for drawing the curve in a tone curve filter.

## Installation

Simply add the following to your Podfile:

``` ruby
pod 'SAMCubicSpline'
```

If you're not using CocoaPods, simply add the source files in the `SAMCubicSpline` directory to your project. **There are no dependencies and it works on Mac and iOS.**

## Example

A quick sample to draw a spline into an already setup `CGContextRef` and assumes you'll finish drawing the line at the end.

``` objc
// Setup a spline with some control points
SAMCubicSpline *spline = [[SAMCubicSpline alloc] initWithPoints:@[
  [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.039f)],
  [NSValue valueWithCGPoint:CGPointMake(0.588f, 0.525f)],
  [NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)],
]];

// Iterate over the X values in the area we want to draw
CGSize graphSize = CGSizeMake(100.0f, 100.0f);
for (CGFloat x = 0.0f; x < size.width; x++) {
  // Get the Y value of our point
  CGFloat y = [spline interpolate:x / size.width] * size.height;

  // Add the point to the context's path
  if (x == 0.0f) {
    CGContextMoveToPoint(context, x, y);
  } else {
    CGContextAddLineToPoint(context, x, y);
  }
}
```

## Thanks

This was abstracted from [Footage](http://footageapp.com). Thanks to [Drew Wilson](http://drewwilson.com) for allowing me to open source this!

//
//  SAMCubicSpline.h
//  SAMCubicSpline
//
//  Created by Sam Soffes on 12/16/13.
//  Copyright (c) 2013-2014 Sam Soffes. All rights reserved.
//

@interface SAMCubicSpline : NSObject

/**
 Initialize a new cubic spline.

 @param points An array of `NSValue` objects containing `CGPoint` structs. These points are the control points of the
 curve.

 @return A new cubic spline.
 */
- (instancetype)initWithPoints:(NSArray *)points;

/**
 Input an X value between 0 and 1.

 @return The corresponding Y value.
 */
- (CGFloat)interpolate:(CGFloat)x;

@end

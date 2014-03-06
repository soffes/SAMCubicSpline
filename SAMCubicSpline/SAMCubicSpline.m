//
//  SAMCubicSpline.m
//  SAMCubicSpline
//
//  Created by Sam Soffes on 12/16/13.
//  Copyright (c) 2013-2014 Sam Soffes. All rights reserved.
//

#import "SAMCubicSpline.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#define SAMCGPointValue(value) [value CGPointValue]
#else
#define SAMCGPointValue(value) [value pointValue]
#endif

@interface SAMCubicSpline ()
@property (nonatomic, copy) NSArray *points;
@property (nonatomic, copy) NSArray *b;
@property (nonatomic, copy) NSArray *c;
@property (nonatomic, copy) NSArray *d;
@end

@implementation SAMCubicSpline

- (instancetype)initWithPoints:(NSArray *)points {
	if ((self = [super init])) {
		self.points = points;

		if (points.count > 0) {
			NSUInteger count = points.count;
			NSUInteger n = count; // - 1;
			CGFloat x[count];
			CGFloat a[count];
			CGFloat h[count];
			CGFloat y[count];
			CGFloat l[count];
			CGFloat u[count];
			CGFloat z[count];
			CGFloat k[count];
			CGFloat s[count];

			for (NSUInteger i = 0; i < points.count; i++) {
				CGPoint point = SAMCGPointValue(points[i]);
				x[i] = point.x;
				a[i] = point.y;
			}

			for (NSUInteger i = 0; i < n; i++) {
				h[i] = x[i + 1] - x[i];
				k[i] = a[i + 1] - a[i];
				s[i] = k[i] / h[i];
			}

			for (NSUInteger i = 1; i < n; i++) {
				y[i] = 3 / h[i] * (a[i + 1] - a[i]) - 3 / h[i - 1] * (a[i] - a[i - 1]);
			}

			l[0] = 1;
			u[0] = 0;
			z[0] = 0;

			for (NSUInteger i = 1; i < n; i++) {
				l[i] = 2 * (x[i + 1] - x[i - 1]) - h[i - 1] * u[i - 1];
				u[i] = h[i] / l[i];
				z[i] = (y[i] - h[i - 1] * z[i - 1]) / l[i];
			}

			l[n] = 1;
			z[n] = 0;

			NSMutableArray *b = [[NSMutableArray alloc] initWithCapacity:n];
			NSMutableArray *c = [[NSMutableArray alloc] initWithCapacity:n];
			NSMutableArray *d = [[NSMutableArray alloc] initWithCapacity:n];

			for (NSUInteger i = 0; i <= n; i++) {
				b[i] = @0;
				c[i] = @0;
				d[i] = @0;
			}

			for (NSInteger i = n - 1; i >= 0; i--) {
				c[i] = @(z[i] - u[i] * [c[i + 1] floatValue]);
				b[i] = @((a[i + 1] - a[i]) / h[i] - h[i] * ([c[i + 1] floatValue] + 2.0f * [c[i] floatValue]) / 3.0f);
				d[i] = @(([c[i + 1] floatValue] - [c[i] floatValue]) / (3 * h[i]));
			}

			c[n] = @0;

			self.b = b;
			self.c = c;
			self.d = d;
		}
	}
	return self;
}


- (CGFloat)interpolate:(CGFloat)input {
	if (self.points.count == 0) {
		// No points. Return identity.
		return input;
	}

	CGFloat x[self.points.count];
	CGFloat a[self.points.count];

	for (NSUInteger i = 0; i < self.points.count; i++) {
		CGPoint point = SAMCGPointValue(self.points[i]);
		x[i] = point.x;
		a[i] = point.y;
	}

	NSInteger i = 0;
	for (i = self.points.count - 1; i > 0; i--) {
		if (x[i] <= input) {
			break;
		}
	}

	CGFloat deltaX = input - (CGFloat)x[i];
	return a[i] + [self.b[i] floatValue] * deltaX + [self.c[i] floatValue] * pow(deltaX, 2) + [self.d[i] floatValue] * pow(deltaX, 3);
}

@end

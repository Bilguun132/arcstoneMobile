//
//  SGaugeQualitativeRange.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 An `SGaugeQualitativeRange` describes a color range on the `SGaugeAxis`.
 
 For example, to set the ranges as 55 to 65 as yellow, 65 to 70 as orange, and 70+ as red:
 
    gauge.qualitativeRanges = @[
        [SGaugeQualitativeRange rangeWithMinimum:@55 maximum:@65 color:[ UIColor yellowColor ]],
        [SGaugeQualitativeRange rangeWithMinimum:@65 maximum:@70 color:[ UIColor orangeColor ]],
        [SGaugeQualitativeRange rangeWithMinimum:@70 maximum:nil color:[ UIColor redColor ]]];
 
 The size of the range drawn on the axis can be configured with the `qualitativeRangeInnerPosition` and `qualitativeRangeOuterPosition` property on the `SGaugeStyle`.
 */
@interface SGaugeQualitativeRange : NSObject

/** Factory method to create a range with a given `minimum`, `maximum` and `color`.
 @param minimum The minimum value at which the color will be rendered. If set to nil, the minimum range of the gauge will be used.
 @param maximum The maximum value at which the color will be rendered. If set to nil, the maximum range of the gauge will be used.
 @param color The color of the range to render.
 */
+(id)rangeWithMinimum:(NSNumber*)minimum maximum:(NSNumber*)maximum color:(UIColor*)color;
/** Create a range with a given `minimum`, `maximum` and `color`.
 @param minimum The minimum value at which the color will be rendered. If set to nil, the minimum range of the gauge will be used.
 @param maximum The maximum value at which the color will be rendered. If set to nil, the maximum range of the gauge will be used.
 @param color The color of the range to render.
 */
-(id)initWithMinimum:(NSNumber*)minimum maximum:(NSNumber*)maximum color:(UIColor*)color;

/** The minimum value at which the color will be rendered. */
@property (nonatomic, readonly) NSNumber *minimum;
/** The maximum value to which the color will be rendered. */
@property (nonatomic, readonly) NSNumber *maximum;
/** The color of the range */
@property (nonatomic, readonly) UIColor *color;

@end

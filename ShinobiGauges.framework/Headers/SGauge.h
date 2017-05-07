//
//  SGauge.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGaugeAxis;
@protocol SGaugeNeedle;
@class SGaugeStyle;
@protocol SGaugeDelegate;

/**
 The `SGauge` is a component representing a single value. They appear in one of two layout styles:
 
 * Radial (`SGaugeRadial`)

    <img src="../docImages/radialGaugeThumb.png" />
 
 * Linear (`SGaugeLinear`)
 
    <img src="../docImages/linearGaugeThumb.png" />
 
 The gauge indicates the current `value` with a needle, pointing towards the value.
 
 <h3> Styling Axes and Axis Labels </h3>
 
 <img src="../docImages/axisStyle.png" />
 
 <h3> Styling the Needle </h3>
 
 <img src="../docImages/needleStyle.png" />
 
 <h3> Applying colors to the Ranges and Background </h3>
 
 <img src="../docImages/gaugeStyle.png" />
 
 It can also optionally color some sections of the gauge, to indicate special values. For example,
 a car revometer may wish to colour values above 7000 rpm in red, to indicate a "danger zone".
 */
@interface SGauge : UIView

#pragma mark - Setup
/** @name Setup */

/**
 Create a gauge with a given range.
 
 @param frame The size and position of the gauge
 @param minimum The minimum value of the axis
 @param maximum The maximum value of the axis
 */
-(id)initWithFrame:(CGRect)frame fromMinimum:(NSNumber*)minimum toMaximum:(NSNumber*)maximum;

/** The minimum range of the gauge. */
@property (nonatomic, retain) NSNumber *minimumValue;

/** The maximum range of the gauge. */
@property (nonatomic, retain) NSNumber *maximumValue;

#pragma mark - Configuration
/** @name Configuration */

/** Returns information about the current build version and type of the ShinobiGauges project. */
+(NSString*)getInfo;

/** Returns information about the current build version and type of the ShinobiGauges project. */
-(NSString*)getInfo;

/** Set the license key for the trial version of the ShinobiGauges framework. You will be emailed the license key when you download the framework. */
-(void)setLicenseKey:(NSString*)licenseKey;

/** The current value of the gauge */
@property (nonatomic, assign) CGFloat value;

/** Set the value of the gauge, and animate the needle to the new position.
 
 If duration is `0`, then no animation will occur.
 */
-(void)setValue:(CGFloat)value duration:(CGFloat)duration;

/** Translates a value on the gauge to a coordinate.
 @param value The value within the gauge range
 @param offset The offset in points from the axis
 
 This is primarily used to calculate tick marks, and should be referenced if creating custom tickmarks.
 */
-(CGPoint)positionOfValue:(CGFloat)value atOffset:(CGFloat)offset;

/** The angle at which an element should be rotated to, at a given value. Measured in radians.
 @param value The value within the gauge range
 
 Used for displaying the needle, tick marks, and tick labels. On an SGaugeLinear, this just returns 0.
 */
-(CGFloat)angleOfValue:(CGFloat)value;

/** The needle object, used to point to the current value.
 
 Defaults to a single black line, in the center of the gauge. */
@property (nonatomic, retain) UIView<SGaugeNeedle> *needle;

/** The axis displayed around the perimeter of the gauge.
 
 This may be in a linear or radial display, depending on the gauge. Includes major and minor tick marks, and labels.
 */
@property (nonatomic, retain) SGaugeAxis *axis;

#pragma mark - Appearance
/** @name Appearance */

/** An array of `SGaugeQualitativeRange` objects, to indicate sections of the gauge which will be coloured. */
@property (nonatomic, retain) NSArray *qualitativeRanges;

/** The z-ordering of the qualitative ranges. Defaults to `0`.
 
 When used in conjunction with the zPosition property on the layer of the `SGaugeNeedle` and `SGaugeAxis`, the order to draw each in can be specified. */
@property (nonatomic, assign) CGFloat qualitativeRangeZPosition;

/** The style to use for drawing the gauge, the axis and the needle. */
@property (nonatomic, retain) SGaugeStyle *style;

#pragma mark - Delegation
/** @name Delegation */

/** The delegate used by the gauge, to inform of changes to the gauge. See the `SGaugeDelegate` protocol for more details. */
@property (nonatomic, assign) id<SGaugeDelegate> delegate;

@end

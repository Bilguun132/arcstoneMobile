//
//  SGaugeStyle.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SGaugeTickAlign) {
    SGaugeTickAlignTop = -1,
    SGaugeTickAlignCenter = 0,
    SGaugeTickAlignBottom = 1
};

typedef NS_OPTIONS(NSInteger, SGaugeTickMirror) {
    SGaugeTickMirrorNone = 0,
    SGaugeTickMirrorTickmarks = 1 << 0,
    SGaugeTickMirrorTicklabels = 1 << 1,
    SGaugeTickMirrorBaseline = 1 << 2
};

/**
 The `SGaugeStyle` offers control over the appearance of the `SGauge`
 
 <h3> Styling axes and axis labels </h3>
 
 <img src="../docImages/axisStyle.png" />
 
 <h3> Styling the needle </h3>
 
 <img src="../docImages/needleStyle.png" />
 
<h3> Applying colors to the ranges and background </h3>

 <img src="../docImages/gaugeStyle.png" />
 
 */
@interface SGaugeStyle : NSObject<NSCopying>
{
}

#pragma mark - Gauge Layout
/** @name Gauge Layout */

/** The offset from the baseline to draw the tick mark labels at. Default to `20pts`.
 
 In a radial gauge, this will place the labels this many points further from the center than the major tick labels.
 In a linear gauge, this will place the labels this many points underneath the major tick labels.
 */
@property (nonatomic, assign) CGFloat tickLabelOffsetFromBaseline;

/** The alignment of the tickmarks from the baseline. Defaults to `SGaugeTickAlignTop`.
 
 * `SGaugeTickAlignTop`: The tick marks will be drawn from the baseline, radiating inwards.
 * `SGaugeTickAlignBottom`: The tick marks will be drawn from the baseline, radiating outwards.
 * `SGaugeTickAlignCenter`: The tick marks will be drawn centered on the baseline. */
@property (nonatomic, assign) SGaugeTickAlign tickMarkAlignment;

/** The offset from the axis to display the baseline, as a proportion of the total radius. Defaults to `1`.
 
 At `1`, the baseline touches the axis.
 A lower value draws the baseline closer to the center.
 A higher value draws the baseline further from the center. */
@property (nonatomic, assign) CGFloat tickBaselinePosition;

#pragma mark - Tick Labels
/** @name Tick Labels */

/** Whether or not tick mark labels should be displayed. Defaults to `YES`. */
@property (nonatomic, assign) BOOL showTickLabels;

/** The font and size to use for tick mark labels. Defaults to HelveticaNeue */
@property (nonatomic, retain) UIFont *tickLabelFont;

/** The text color of the axis labels. */
@property (nonatomic, retain) UIColor *tickLabelColor;

/** Whether the tick labels will be displayed horizontally, or whether they will rotate around the edge of a radial gauge. Defaults to `NO`.
 
 If `YES`, the tick labels will rotate around the axis.
 If `NO`, all tick labels will be drawn horizontally. */
@property (nonatomic, assign) BOOL tickLabelsRotate;

#pragma mark - Tick marks
/** @name Tick Marks */

/** The dimensions of the major ticks. Default to `{2, 12}`. */
@property (nonatomic, assign) CGSize majorTickSize;

/** The color of the major tick marker. */
@property (nonatomic, retain) UIColor *majorTickColor;

/** The dimensions of the minor ticks. Default to `{1, 6}`. */
@property (nonatomic, assign) CGSize minorTickSize;

/** The color of the minor tick marker. */
@property (nonatomic, retain) UIColor *minorTickColor;

/** The width of the Tick track baseline. */
@property (nonatomic, assign) CGFloat tickBaselineWidth;

/** The color of the Tick track baseline. */
@property (nonatomic, retain) UIColor *tickBaselineColor;

#pragma mark - Qualtitative ranges
/** @name Qualitative Ranges */

/** The width of the border around Qualitative Ranges. Defaults to `0`. */
@property (nonatomic, assign) CGFloat qualitativeRangeBorderWidth;

/** The inner radius of the Qualitative Range, as a proportion of the whole height. Defaults to `0.75`. */
@property (nonatomic, assign) CGFloat qualitativeRangeInnerPosition;

/** The outer radius of the Qualitative Range, as a proportion of the whole height. Defaults to `1.0`. */
@property (nonatomic, assign) CGFloat qualitativeRangeOuterPosition;

/** The color of the border around Qualitative Ranges. */
@property (nonatomic, retain) UIColor *qualitativeRangeBorderColor;

/** Whether or not to draw the Qualitative Range from the minimum to the current value. Default to NO. */
@property (nonatomic, assign) BOOL qualitativeRangeActiveSegmentIsColored;

#pragma mark - Fill Color

/** Whether or not to fill the gauge up from the minimum to the current value. Defaults to NO.*/
@property (nonatomic, assign) BOOL fillToValue;

/** The inner radius of the Fill Value, as a proportion of the whole height. Defaults to `0.4`. */
@property (nonatomic, assign) CGFloat fillValueInnerRadius;

/** The inner radius of the Fill Value, as a proportion of the whole height. Defaults to `0.6`. */
@property (nonatomic, assign) CGFloat fillValueOuterRadius;

/** The color of the Value Fill. */
@property (nonatomic, retain) UIColor *fillValueColor;

/** The width of the border around the Value Fill. Defaults to `0`. */
@property (nonatomic, assign) CGFloat fillValueBorderWidth;

/** The color of the border around the Value Fill. */
@property (nonatomic, retain) UIColor *fillValueBorderColor;

#pragma mark - Needle
/** @name Needle */

/** The length of the needle, as a proportion of the radius.
 
 When set to `1`, the needle reaches from the center to the axis.
 When set to `0.5`, the needle reaches from the center to half way between the center and axis.
 */
@property (nonatomic, assign) CGFloat needleLength;

/** The width of the needle. */
@property (nonatomic, assign) CGFloat needleWidth;

/** The color of the needle. */
@property (nonatomic, retain) UIColor *needleColor;

/** The width of the needle border, measured in points. */
@property (nonatomic, assign) CGFloat needleBorderWidth;

/** The color of the needle border. */
@property (nonatomic, retain) UIColor *needleBorderColor;

/** The radius of the knob at the end of the needle, in points. */
@property (nonatomic, assign) CGFloat knobRadius;

/** The color of the knob at the end of the needle. */
@property (nonatomic, retain) UIColor *knobColor;

/** The width of the border around the knob at the end of the needle, measured in points. */
@property (nonatomic, assign) CGFloat knobBorderWidth;

/** The color of the border around the knob at the end of the needle. */
@property (nonatomic, retain) UIColor *knobBorderColor;

#pragma mark - Gauge appearance
/** @name Gauge Appearance */

/** The radius of the corners of the `SGaugeLinear` and bevel. */
@property (nonatomic, assign) CGFloat cornerRadius;

/** The size of the bevel around the gauge. */
@property (nonatomic, assign) CGFloat bevelWidth;

/** The color of the bevel, used around the gauge perimeter.
 
 The bevel uses a linear gradient between `bevelPrimaryColor` and `bevelSecondaryColor`. */
@property (nonatomic, retain) UIColor *bevelPrimaryColor;

/** The secondary color of the bevel, used around the gauge perimeter.
 
 The bevel uses a linear gradient between `bevelPrimaryColor` and `bevelSecondaryColor`. */
@property (nonatomic, retain) UIColor *bevelSecondaryColor;

/** The proportion of the bevel which is "flat" at the edge, before sloping in towards the center. Defaults to `0.5`. */
@property (nonatomic, assign) CGFloat bevelFlatProportion;

/** Whether or not the border should stop at the edge of the axis track, or form a full circle.
 
 This only applies to the style of radial gauges.
 If `YES`, the border and background will be drawn as a full circle.
 If `NO`, the border and background will start at the `arcAngleStart`, and finish at the `arcAngleEnd`. */
@property (nonatomic, assign) BOOL borderIsFullCircle;

/** The amount of padding on either end of the axis before the border is drawn. */
@property (nonatomic, assign) CGFloat axisPadding;

/** An integer bitmask that determines how the tickmarks and ticklabels are mirrored. Defaults to `SGaugeTickMirrorNone`.
 
 The value of this mask is specified by combining the constants defined in `SGaugeTickMirror` using the C bitwise OR operator.
 
 * `SGaugeTickMirrorNone`: The option for indicating that nothing will be mirrored.
 * `SGaugeTickMirrorTickmarks`: The option for indicating that the tickmarks will be mirrored.
 * `SGaugeTickMirrorTicklabels`: The option for indicating that the ticklabels will be mirrored.
 * `SGaugeTickMirrorBaseline`: The option for indicating that the baseline will be mirrored.
 */
@property (nonatomic, assign) enum SGaugeTickMirror axisMirrorBehavior;

/** The background color to use at the outer edge of the gauge. If different from the `innerBackgroundColor`, a gradient will be drawn between the two. */
@property (nonatomic, retain) UIColor *outerBackgroundColor;

/** The background color to use at the inner edge of the gauge. If different from the `outerBackgroundColor`, a gradient will be drawn between the two.  */
@property (nonatomic, retain) UIColor *innerBackgroundColor;

#pragma mark - Glass Effect
/** @name Glass Effect */

/** Whether or not to add a glass effect to the gauge. Defaults to `YES`. */
@property (nonatomic, assign) BOOL showGlassEffect;

/**  The color of the glass effect over the gauge. */
@property (nonatomic, retain) UIColor *glassColor;

@end

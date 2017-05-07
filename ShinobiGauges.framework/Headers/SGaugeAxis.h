//
//  SGaugeAxis.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGaugeStyle.h"

@class SGauge;

/**
 The axis shows the major and minor tick marks, and labels around the perimeter of the gauge.
 
 The axis may be drawn in a linear or radial way, depending on the parent gauge passed in on creation.
 
 The `majorTickFrequency` and `minorTickFrequency` control how often the tick marks are drawn. These can be styled using the `SGaugeStyle` on the main `SGauge` class, or by using the `gauge:alterTickMark:atValue:isMajorTick:` method on the `SGaugeDelegate`.
 
 Values are shown next to each major tick. These can be styled or turned off using the `SGaugeStyle` on the main `SGauge` class, or by using the `gauge:alterTickLabel:atValue:` method on the `SGaugeDelegate`.
 */
@interface SGaugeAxis : UIView

#pragma mark - Setup
/** @name Setup */

/** Create an axis, with a reference to a parent gauge/ */
- (id)initWithGauge:(SGauge*)gauge;

/** The minimum value of the range of the axis. Default value is auto-populated by the `SGauge` on initialization. */
@property (nonatomic, assign) double minimumValue;

/** The maximum value of the range of the axis. Default value is auto-populated by the `SGauge` on initialization. */
@property (nonatomic, assign) double maximumValue;

#pragma mark - Tickmarks
/** @name Tickmarks */

/** The spacing between the major ticks on the axis. Default value is auto-calculated from the range of the `SGauge`. */
@property (nonatomic, assign) double majorTickFrequency;

/** The spacing between the minor ticks on the axis. Default value is auto-calculated from the range of the `SGauge`. */
@property (nonatomic, assign) double minorTickFrequency;

#pragma mark - Appearance
/** @name Appearance */

/** A label formatter for tick mark labels.
 
 Use this to set formatting options for tick labels on this axis - currencies, (negative) value styles etc. */
@property (nonatomic, retain) NSFormatter *formatter;

/** The offset from the baseline to draw the tick mark labels at. Defaults to the value of `tickLabelOffsetFromBaseline` from the `SGaugeStyle` of the gauge passed in in `initWithGauge:`.
 
 In a radial gauge, this will place the labels this many points further from the center than the major tick labels.
 In a linear gauge, this will place the labels this many points underneath the major tick labels.
 */
@property (nonatomic, assign) CGFloat tickLabelOffsetFromBaseline;

/** The alignment of the tickmarks from the baseline. Defaults to the value of `tickMarkAlignment` from the `SGaugeStyle` of the gauge passed in in `initWithGauge:`.
 
 If `SGaugeTickAlignTop`, the tick marks will be drawn from the baseline, radiating inwards.
 If `SGaugeTickAlignBottom`, the tick marks will be drawn from the baseline, radiating outwards.
 If `SGaugeTickAlignCenter`, the tick marks will be drawn centered on the baseline. */
@property (nonatomic, assign) SGaugeTickAlign tickMarkAlignment;

/** The offset from the axis to display the baseline, as a proportion of the total radius. Defaults to the value of `tickBaselinePosition` from the `SGaugeStyle` of the gauge passed in in `initWithGauge:`.
 
 At `1`, the baseline touches the axis.
 A lower value draws the baseline closer to the center.
 A higher value draws the baseline further from the center. */
@property (nonatomic, assign) CGFloat tickBaselinePosition;

#pragma mark - Subclassing
/** @name Subclassing */

/** Creates the view to use as a tick label.
 
 Implement this method to create custom tick marks, or use the `SGaugeDelegate` method `gauge:alterTickMark:atValue:isMajorTick:`.
 */
-(UIView*)viewForTickMarkAtValue:(CGFloat)value isMajorTick:(BOOL)isMajorTick;


@end

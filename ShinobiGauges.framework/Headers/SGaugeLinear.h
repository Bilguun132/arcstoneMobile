//
//  SGaugeLinear.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import "SGauge.h"

typedef NS_ENUM(NSInteger, SGaugeLinearOrientation) {
    SGaugeLinearOrientationHorizontal,
    SGaugeLinearOrientationVertical
};

typedef NS_ENUM(NSInteger, SGaugeLinearNeedleOrientation) {
    SGaugeLinearNeedleOrientationUpright,
    SGaugeLinearNeedleOrientationReversed
};

/** An `SGaugeLinear` is a gauge drawn from left-to-right as a linear display. Tickmarks are drawn underneath, with labels under the ticks.
 
 <img src="../docImages/linearGauge.png" />
 
  The `SGaugeLinear` inherits from the `SGauge` base class. The methods and properties on the base class can be used to control all other aspects of the gauge's behavior.
 */
@interface SGaugeLinear : SGauge

/** The orientation of the `SGaugeLinear`. Defaults to `SGaugeLinearOrientationHorizontal`.
 
 * `SGaugeLinearOrientationHorizontal`: The gauge is drawn as a horizontal line, from left to right.
 * `SGaugeLinearOrientationVertical`: The gauge is drawn as a vertical line, from top to bottom. */
@property (nonatomic, assign) SGaugeLinearOrientation orientation;

/** The orientation of the `SGaugeNeedle`. Defaults to `SGaugeLinearNeedleOrientationUpright`.
 
 * `SGaugeLinearNeedleOrientationUpright`: The needle will point from the axis outwards.
 * `SGaugeLinearNeedleOrientationReversed`: The needle will point from the opposite edge towards the axis. */
@property (nonatomic, assign) SGaugeLinearNeedleOrientation needleOrientation;

@end

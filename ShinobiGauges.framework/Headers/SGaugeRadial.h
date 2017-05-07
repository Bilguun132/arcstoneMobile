//
//  SGaugeRadial.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import "SGauge.h"

/** An `SGaugeRadial` is a gauge displaying a circular arc composed of Ticks, Labels and a Needle
 
 <img src="../docImages/radialGauge.png" />
 
 The gauge allows for custom arcs, starting at `arcAngleStart` and finishing at `arcAngleEnd`. If these two values are the same, then the gauge is drawn as a complete circle.
 
 The `SGaugeRadial` inherits from the `SGauge` base class. The methods and properties on the base class can be used to control all other aspects of the gauge's behavior.
 */
@interface SGaugeRadial : SGauge

/** The angle in radians to start drawing the gauge from.
 
  An angle of `0` represents the top, with positive values going clockwise. Defaults to -3π/4
 */
@property (nonatomic, assign) CGFloat arcAngleStart;
/** The angle in radians to draw the gauge to.
 
 An angle of `0` represents the top, with positive values going clockwise. Defaults to 3π/4.
 */
@property (nonatomic, assign) CGFloat arcAngleEnd;

@end

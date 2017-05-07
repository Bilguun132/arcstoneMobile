//
//  SGaugeNeedle.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGauge;
@class SGaugeStyle;

/**
 The needle of the gauge, used to indicate the current value.
 
 The needle sets a custom anchor point, to allow it to rotate around the end of the needle, as opposed to the center.
 If creating a custom needle, the `needle.layer.anchorPoint` will need updating, to rotate around the correct point.
 */
@protocol SGaugeNeedle

#pragma mark - Drawing Methods

@optional
/** @name Optional Drawing Methods */

/** Redraws the needle with an updated value. */
-(void)redrawWithValue:(CGFloat)value;
/** Redraws the needle with an updated style. */
-(void)refreshWithStyle:(SGaugeStyle*)style;

@end

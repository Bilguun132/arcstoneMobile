//
//  SGaugeDelegate.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `SGaugeDelegate` defines optional methods, which allow you to manage the appearance of the `SGauge` and its component parts.
 */
@protocol SGaugeDelegate <NSObject>

@optional
/** @name Optional Methods */

/** Allows the delegate to apply additional styling to the tick label before it is displayed.
 
 This is called whenever the `SGaugeAxis` is redrawn, after all defaults from `SGaugeStyle` have been applied.
 */
-(void)gauge:(SGauge*)gauge alterTickLabel:(UILabel*)tickLabel atValue:(CGFloat)value;

/** Allows the delegate to apply additional styling to the tickmark before it is displayed.
 
 When this is called, the defaults from `SGaugeStyle` have already been applied.
 */
-(void)gauge:(SGauge*)gauge alterTickMark:(UIView*)tickMark atValue:(CGFloat)value isMajorTick:(BOOL)majorTick;

/** Allows the delegate to apply additional styling to the needle before it is displayed.
 
 When this is called, the defaults from `SGaugeStyle` have already been applied.
 The value supplied is the old value. The new value can be retrieved from the `SGauge`.
 */
-(void)gauge:(SGauge*)gauge alterNeedle:(UIView*)needle onChangeFromValue:(CGFloat)oldValue;

@end

//
//  ShinobiGauges.h
//  ShinobiGauges
//
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import "SGaugeAxis.h"
#import "SGaugeQualitativeRange.h"
#import "SGaugeNeedle.h"

#import "SGaugeLinear.h"
#import "SGaugeRadial.h"
#import "SGaugeDelegate.h"

#import "SGaugeStyle.h"
#import "SGaugeDarkStyle.h"
#import "SGaugeLightStyle.h"
#import "SGaugeDashboardStyle.h"

/** ShinobiGauges is a global utility class for the ShinobiGauges framework.
 
 It allows you to do the following:
 
 - Get information on the version and edition of the framework.
 - For trial versions of ShinobiGauges, it allows you to set the license key. This enables you to use the framework for the duration of the trial period.
 
 */
@interface ShinobiGauges : NSObject

#pragma mark - Info
/** @name Info */

/** Returns information about the current build version and type of the ShinobiGauges project. */
+(NSString*)getInfo;

#pragma mark - Licensing
/** @name Licensing */

/** Set the license key for the trial version of the ShinobiGauges framework. You will be emailed the license key when you download the framework. */
+(void)setLicenseKey:(NSString*)licenseKey;

/** Returns the license key entered for the framework by the trial user. */
+(NSString*)licenseKey;

@end

//
//  NSDate+SRGMethods.m
//  Thresholds
//
//  Created by Sergi Borras on 11/20/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "NSDate+SRGMethods.h"

@implementation NSDate (SRGMethods)
- (NSDate *)dateByAddingDays:(NSInteger)days
{
    return [self dateByAddingTimeInterval:60*60*24*days];
}
@end

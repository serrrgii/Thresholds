//
//  SRGThreshold.h
//  TimeEvents
//
//  Created by Sergi Borras on 11/12/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGArchiveObject.h"

@interface SRGThreshold : SRGArchiveObject

@property (readonly, strong, nonatomic) NSNumber *requiredCounters;
@property (readonly, strong, nonatomic) NSNumber *counters;
@property (readonly, strong, nonatomic) NSDate *startDate;
@property (readonly, strong, nonatomic) NSDate *endDate;
@property (readonly, strong, nonatomic) void(^onDidReachLimit)(SRGThreshold *);

+ (instancetype) thresholdWithStringIdentifier:(NSString *)name requiredCounters:(NSNumber *)times startDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)setDidReachLimitHandler:(void(^)(SRGThreshold *treshold))onDidReachLimit;
- (BOOL)addCounter:(NSError **)anError;
@end

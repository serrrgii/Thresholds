//
//  SRGThresholdContext.h
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGArchiveObject.h"

@class SRGThreshold;

typedef NS_ENUM(NSUInteger, SRGThresholdContextErrorCodes) {
    SRGThresholdContextExistsErrorCode,
    SRGThresholdExistsInContext,
    SRGThresholdNotFound
};

@interface SRGThresholdContext : SRGArchiveObject
@property (readonly, strong, nonatomic) NSDictionary *thresholds;
- (BOOL)addThreshold:(SRGThreshold *)threshold failure:(NSError **)error;
+ (instancetype)contextWithStringIdentifier:(NSString *)identifier failure:(NSError **)error;
- (void)setDidReachLimitHandler:(void(^)(SRGThresholdContext *context))onDidReachLimit;
- (BOOL)addCounterWithThresholdIdentifier:(NSString *)identifier failure:(NSError **)error;
- (id)objectForKeyedSubscript:(id <NSCopying>)key;
@end

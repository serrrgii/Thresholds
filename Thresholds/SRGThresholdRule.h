//
//  SRGThresholdRule.h
//  TimeEvents
//
//  Created by Sergi Borras on 11/14/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SRGThresholdRuleErrorCodes) {
    SRGThresholdLimitErrorCode,
    SRGThresholdStartDateErrorCode,
    SRGThresholdEndDateErrorCode
};

@class SRGThreshold;
@interface SRGThresholdRule : NSObject
- (void)validateThreshold:(SRGThreshold *)threshold success:(void(^)())onSuccess failure:(void(^)(NSError *error))onFailure;
@end

@interface SRGThresholdLimitRule : SRGThresholdRule

@end

@interface SRGThresholdStartDateRule : SRGThresholdRule

@end

@interface SRGThresholdEndDateRule : SRGThresholdRule

@end
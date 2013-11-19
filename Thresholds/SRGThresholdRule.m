//
//  SRGThresholdRule.m
//  TimeEvents
//
//  Created by Sergi Borras on 11/14/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "SRGThresholdRule.h"
#import "SRGThreshold.h"
#import "NSObject+Errors.h"

@implementation SRGThresholdLimitRule
- (void)validateThreshold:(SRGThreshold *)threshold success:(void (^)())onSuccess failure:(void (^)(NSError *))onFailure
{
    NSString *errorDescription;
    NSString *errorRecoverySuggestion;
    NSError *error;
    
    if (threshold.counters.unsignedIntegerValue == threshold.requiredCounters.unsignedIntegerValue)
    {
        errorDescription = NSLocalizedString(@"Bad threshold state", nil);
        errorRecoverySuggestion = NSLocalizedString(@"This threshold has already reached its limit", nil);
        error = [self generateErrorWithDescription:errorDescription
                                recoverySuggestion:errorRecoverySuggestion
                                              code:SRGThresholdLimitErrorCode];
        onFailure(error);
        return;
    }
    
    onSuccess();
}
@end

@implementation SRGThresholdStartDateRule
- (void)validateThreshold:(SRGThreshold *)threshold success:(void (^)())onSuccess failure:(void (^)(NSError *))onFailure
{
    NSString *errorDescription;
    NSString *errorRecoverySuggestion;
    NSError *error;
    
    NSDate *now = [NSDate date];
    
    if (threshold.startDate != nil &&
        [now compare:threshold.startDate] == NSOrderedAscending)
    {
        errorDescription = NSLocalizedString(@"Bad date", nil);
        errorRecoverySuggestion = NSLocalizedString(@"Can't add a counter in a date before the start date of the threshold", nil);
        error = [self generateErrorWithDescription:errorDescription
                                recoverySuggestion:errorRecoverySuggestion
                                              code:SRGThresholdStartDateErrorCode];
        onFailure(error);
        return;
    }
    
    onSuccess();
}
@end

@implementation SRGThresholdEndDateRule
- (void)validateThreshold:(SRGThreshold *)threshold success:(void (^)())onSuccess failure:(void (^)(NSError *))onFailure
{
    NSString *errorDescription;
    NSString *errorRecoverySuggestion;
    NSError *error;
    
    NSDate *now = [NSDate date];
    
    if (threshold.endDate != nil &&
        [now compare:threshold.endDate] == NSOrderedDescending)

    {
        errorDescription = NSLocalizedString(@"Bad date", nil);
        errorRecoverySuggestion = NSLocalizedString(@"Can't add a counter in a date after the end date of the threshold", nil);
        error = [self generateErrorWithDescription:errorDescription
                                recoverySuggestion:errorRecoverySuggestion
                                              code:SRGThresholdEndDateErrorCode];
        onFailure(error);
        return;
    }
    
    onSuccess();
}
@end


//
//  SRGThresholdContext.m
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "SRGThresholdContext.h"
#import "NSObject+Errors.h"
#import "SRGThreshold.h"

@interface SRGThresholdContext()<NSCoding>
@property (readwrite, strong, nonatomic) NSString *identifier;
@property (readwrite, strong, nonatomic) NSMutableDictionary *mutableThresholds;
@property (readwrite, strong, nonatomic) void(^onDidReachLimit)(SRGThresholdContext *);
@end
@implementation SRGThresholdContext

+ (instancetype)contextWithStringIdentifier:(NSString *)identifier failure:(NSError **)error
{
    if ([self fetchWithStringIdentifier:identifier]) {
        
        *error = [self generateErrorWithDescription:NSLocalizedString(@"Threshold context exists", nil)
                                 recoverySuggestion:NSLocalizedString(@"Use fetch with string identifier instead", nil)
                                               code:SRGThresholdContextExistsErrorCode];

        return nil;
    }
    
    return [self archiveObjectWithStringIdentifier:identifier];
}

- (BOOL)addThreshold:(SRGThreshold *)threshold failure:(NSError *__autoreleasing *)error
{
    if (self.mutableThresholds == nil)
    {
        self.mutableThresholds = [NSMutableDictionary dictionary];
    }
    
    if ([self.mutableThresholds objectForKey:threshold.identifier]) {
        *error = [self generateErrorWithDescription:NSLocalizedString(@"Threshold exists", nil)
                                 recoverySuggestion:NSLocalizedString(@"Add a threshold with a diferent name", nil)
                                               code:SRGThresholdExistsInContext];
        return NO;
    }
    
    [self.mutableThresholds setObject:threshold
                               forKey:threshold.identifier];
    
    [threshold setDidReachLimitHandler:^(SRGThreshold *treshold) {
        
        if ([self reachedAllThresholds] && self.onDidReachLimit) {
            
            self.onDidReachLimit(self);
        };
    }];
    
    return YES;
}
- (BOOL)addCounterWithThresholdIdentifier:(NSString *)identifier failure:(NSError *__autoreleasing *)error
{
    SRGThreshold *threshold = [self.thresholds objectForKey:identifier];
    
    if (threshold == nil)
    {
        *error = [self generateErrorWithDescription:NSLocalizedString(@"Error adding counter", nil)
                                 recoverySuggestion:NSLocalizedString(@"This context does not contain a threshold with the provided identifier", nil)
                                               code:SRGThresholdNotFound];
        return NO;
    }
    
    return [threshold addCounter:error];

}
- (void)setDidReachLimitHandler:(void (^)(SRGThresholdContext *))onDidReachLimit
{
    self.onDidReachLimit = onDidReachLimit;
}
- (BOOL)reachedAllThresholds
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        SRGThreshold *each = (SRGThreshold *)evaluatedObject;
        return each.requiredCounters.unsignedIntegerValue == each.counters.unsignedIntegerValue;
    }];
    NSArray *reachedThresholds = [self.mutableThresholds.allValues filteredArrayUsingPredicate:predicate];
    
    return reachedThresholds.count == self.thresholds.count;
}
- (NSDictionary *)thresholds
{
    return [self.mutableThresholds copy];
}
#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.identifier = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(identifier))];
        self.mutableThresholds = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(thresholds))];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier
                  forKey:NSStringFromSelector(@selector(identifier))];
    [aCoder encodeObject:self.thresholds
                  forKey:NSStringFromSelector(@selector(thresholds))];
}
@end

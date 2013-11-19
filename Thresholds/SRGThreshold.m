//
//  SRGThreshold.m
//  TimeEvents
//
//  Created by Sergi Borras on 11/12/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "SRGThreshold.h"
#import "SRGThresholdRule.h"

@interface SRGThreshold()<NSCoding>
@property (readwrite, strong, nonatomic) NSString *name;
@property (readwrite, strong, nonatomic) NSNumber *requiredCounters;
@property (readwrite, strong, nonatomic) NSNumber *counters;
@property (readwrite, strong, nonatomic) NSDate *startDate;
@property (readwrite, strong, nonatomic) NSDate *endDate;
@property (readwrite, strong, nonatomic) void(^onDidReachLimit)(SRGThreshold *);
@property (readwrite, strong, nonatomic) NSArray *rules;
@end
@implementation SRGThreshold
- (id)initWithName:(NSString *)name requiredCounters:(NSNumber *)requiredCounters startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if (self)
    {
        self.name = name;
        self.requiredCounters = requiredCounters;
        self.startDate = startDate;
        self.endDate = endDate;
        [self setupRules];
    }
    return self;
}

+ (instancetype)thresholdWithName:(NSString *)name requiredCounters:(NSNumber *)requiredCounters startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    return [[self alloc] initWithName:name
                     requiredCounters:(NSNumber *)requiredCounters
                            startDate:startDate
                              endDate:endDate];
}
- (void)setupRules
{
    self.rules = @[[SRGThresholdLimitRule new],
                   [SRGThresholdStartDateRule new],
                   [SRGThresholdEndDateRule new]];
}
- (void)setDidReachLimitHandler:(void (^)(SRGThreshold *))onDidReachLimit
{
    self.onDidReachLimit = onDidReachLimit;
}
- (BOOL)addCounter:(NSError *__autoreleasing *)anError
{
    BOOL result = NO;
    __block NSError *validationError;
    
    [self.rules enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj validateThreshold:self
                       success:^{
                           
                       } failure:^(NSError *error) {
                           validationError = error;
                           *stop = YES;
                       }];
    }];
    
    *anError = validationError;
    
    if (!validationError)
    {
        self.counters = [NSNumber numberWithUnsignedInt:self.counters.unsignedIntValue+1];
        
        [[SRGThresholdLimitRule new] validateThreshold:self
                                          success:^{
                                            
                                          } failure:^(NSError *error) {
                                              if (self.onDidReachLimit)
                                              {
                                                  self.onDidReachLimit(self);
                                              }
                                          }];
        result = YES;
    }
    
    return result;
}
#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.name = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
        self.requiredCounters = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(requiredCounters))];
        self.counters = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(counters))];
        self.startDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(startDate))];
        self.endDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(endDate))];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name
                  forKey:NSStringFromSelector(@selector(name))];
    [aCoder encodeObject:self.requiredCounters
                  forKey:NSStringFromSelector(@selector(requiredCounters))];
    [aCoder encodeObject:self.counters
                  forKey:NSStringFromSelector(@selector(counters))];
    [aCoder encodeObject:self.startDate
                  forKey:NSStringFromSelector(@selector(startDate))];
    [aCoder encodeObject:self.endDate
                  forKey:NSStringFromSelector(@selector(endDate))];
}
@end

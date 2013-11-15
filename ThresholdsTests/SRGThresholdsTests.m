//
//  SRGThresholdTests.m
//
//
//  Created by Sergi Borras on 11/13/13.
//
//

#import "Kiwi.h"
#import "SRGThreshold.h"

SPEC_BEGIN(SRGThresholdSpec)

static NSString *const SpecThresholdName = @"my threhold";


describe(@"A treshold", ^{
    
    
    __block SRGThreshold *threshold;
    __block NSNumber *limit;
    __block NSDate *startDate;
    __block NSDate *endDate;
    
    context(@"when initialized", ^{
        
        limit = [NSNumber numberWithUnsignedInteger:3];
        startDate = [NSDate date];
        endDate = [startDate dateByAddingTimeInterval:60*60*24*2];
        threshold = [SRGThreshold thresholdWithName:SpecThresholdName
                                   requiredCounters:limit
                                          startDate:startDate
                                            endDate:endDate];
        
        it(@"has the correct limit", ^{
            [[threshold.requiredCounters should] beIdenticalTo:limit];
        });
        it(@"has the correct name", ^{
            [[threshold.name should] beIdenticalTo:SpecThresholdName];
        });
        it(@"has the correct start date", ^{
            [[threshold.startDate should] beIdenticalTo:startDate];
        });
        it(@"has the correct end date", ^{
            [[threshold.endDate should] beIdenticalTo:endDate];
        });
        context(@"when adding callbacks", ^{
            
            it(@"should allow me to set the reached limit callback", ^{
                [[threshold should] respondToSelector:@selector(setDidReachLimitHandler:)];
            });
            
            __block void (^onThresholdDidReachLimit)(SRGThreshold *threshold);
            
            beforeAll(^{
                onThresholdDidReachLimit = ^void(SRGThreshold *threshold)
                {
                    
                };
                [threshold setDidReachLimitHandler:onThresholdDidReachLimit];
            });
            
            it (@"should set the proper callback block", ^{
                [[threshold.onDidReachLimit should] beIdenticalTo:onThresholdDidReachLimit];
            });
        });
        
        context(@"when adding counters", ^{
            
            it (@"should let us add counters", ^(){
                [[threshold should] respondToSelector:@selector(addCounter:)];
            });
            
            __block NSError *error;
            
            beforeEach(^{
                error = nil;
            });
            
            context(@"and the startDate is later than the current date", ^{
                
                it(@"should fail", ^()
                   {
                       startDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*1];
                       endDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*2];
                       threshold = [SRGThreshold thresholdWithName:SpecThresholdName
                                                  requiredCounters:[NSNumber numberWithInt:3]
                                                         startDate:startDate
                                                           endDate:endDate];
                       [threshold addCounter:&error];
                       [[error should] beNonNil];
                   });
            });
            
            context(@"and the endDate is sooner than the current date", ^{
                it(@"should fail", ^{
                    startDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*2];
                    endDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*1];
                    threshold = [SRGThreshold thresholdWithName:SpecThresholdName
                                               requiredCounters:[NSNumber numberWithInt:3]
                                                      startDate:startDate
                                                        endDate:endDate];
                    [threshold addCounter:&error];
                    [[error should] beNonNil];
                });
            });
            
            
            context(@"and date is between startDate and endDate", ^{
                context(@"and it has not reached its limit", ^{
                    it(@"should succeed", ^{
                        startDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*2];
                        endDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*1];
                        threshold = [SRGThreshold thresholdWithName:SpecThresholdName
                                                   requiredCounters:[NSNumber numberWithInt:3]
                                                          startDate:startDate
                                                            endDate:endDate];
                        [threshold addCounter:&error];
                        [[error should] beNil];
                    });
                });
            });
            
        });
    });
});
SPEC_END

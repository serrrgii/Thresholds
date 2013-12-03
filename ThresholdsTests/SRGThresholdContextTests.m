//
//  SRGThresholdContextTests.m
//  Thresholds
//
//  Created by Sergi Borras on 11/18/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "Kiwi.h"
#import "SRGThresholdContext.h"
#import "SRGThreshold.h"
#import "NSDate+SRGMethods.h"

SPEC_BEGIN(ThresholdContextSpec)

static NSString *const ContextIdentifier = @"com.srg.gyg.myidentifier";
static NSString *const SecondContextIdentifier = @"com.srg.gyg.myidentifier2";
static NSString *const ThresholdIdentifier = @"mythreshold";
static NSString *const SecondThresholdIdentifier = @"mysecondthreshold";
static NSString *const ThirdThresholdIdenfifier = @"mythirdthreshold";

describe(@"Threshold contexts", ^{
    __block SRGThresholdContext *thresholdContext;
    context(@"before initializing", ^{
        it(@"should allow to create a context with a string identifier", ^{
            [[SRGThresholdContext.class should] respondToSelector:@selector(contextWithStringIdentifier:failure:)];
        });
    });
    context(@"after initializing", ^{
        __block NSError *error;
        beforeAll(^{
           
            NSString *domainName = [NSBundle mainBundle].bundleIdentifier;
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
            
            thresholdContext = [SRGThresholdContext contextWithStringIdentifier:ContextIdentifier
                                                                        failure:&error];
            [thresholdContext archive];
        });
        it(@"created an instance of the context", ^{
            [[thresholdContext should] beNonNil];
            [[thresholdContext should] beMemberOfClass:SRGThresholdContext.class];
        });
        it(@"the instance has the correct identifier", ^{
            [[thresholdContext.identifier should] equal:ContextIdentifier];
        });
        it(@"generated no error", ^{
            [[error should] beNil];
        });
        afterAll(^{
            
        });
        context(@"and initializing another instance", ^{
            context(@"when using a different identifier", ^{
                beforeAll(^{
                    thresholdContext = [SRGThresholdContext contextWithStringIdentifier:SecondContextIdentifier
                                                                                failure:&error];
                });
                it(@"should create a context instance", ^{
                    [[thresholdContext should] beNonNil];
                });
                it(@"the instance has the correct identifier", ^{
                    [[thresholdContext.identifier should] equal:SecondContextIdentifier];
                });
                it(@"generated no error", ^{
                    [[error should] beNil];
                });
            });
            context(@"when reusing an identifier", ^{
                beforeAll(^{
                    thresholdContext = [SRGThresholdContext contextWithStringIdentifier:ContextIdentifier
                                                                                failure:&error];
                });
                it(@"does not create an instance of the context", ^{
                    [[thresholdContext should] beNil];
                });
                it(@"should return an error", ^{
                    [[error should] beNonNil];
                });
            });
        });
        context(@"when adding a threshold", ^{
            
            NSDate *startDate = [[NSDate date] dateByAddingDays:-1];
            NSDate *endDate = [[NSDate date] dateByAddingDays:1];
            
            beforeAll(^{
                error = nil;
                thresholdContext = [SRGThresholdContext contextWithStringIdentifier:SecondContextIdentifier
                                                                            failure:&error];
            });
            it(@"should let us add it", ^{
                [[thresholdContext should] respondToSelector:@selector(addThreshold:failure:)];
            });
            context(@"when adding a threshold", ^{
                __block SRGThreshold *threshold;
                context(@"when using a new identifier", ^{
                    beforeAll(^{
                        threshold = [SRGThreshold thresholdWithStringIdentifier:ThresholdIdentifier
                                                               requiredCounters:@3
                                                                      startDate:startDate
                                                                        endDate:endDate];
                        [thresholdContext addThreshold:threshold
                                               failure:&error];
                    });
                    it(@"should not set an error", ^{
                        [[error should] beNil];
                    });
                    it(@"should contain one threshold", ^{
                        
                        [[thresholdContext.thresholds should] haveCountOf:1];
                    });
                    
                    it(@"should contain the added threshold", ^{
                        
                        [[[thresholdContext.thresholds objectForKey:threshold.identifier] should] beNonNil];
                    });
                    
                });
                context(@"when adding a second threshold", ^{
                    context(@"reusing an identifier", ^{
                        beforeAll(^{
                            threshold = [SRGThreshold thresholdWithStringIdentifier:ThresholdIdentifier
                                                                   requiredCounters:@3
                                                                          startDate:startDate
                                                                            endDate:endDate];
                            [thresholdContext addThreshold:threshold
                                                   failure:&error];
                        });
                        it(@"should not add the threshold", ^{
                            [[[thresholdContext.thresholds objectForKey:threshold.identifier] shouldNot] equal:threshold];
                        });
                        it(@"should generate an error", ^{
                            [[error should] beNonNil];
                        });
                    });
                    context(@"with a new identifier", ^{
                        beforeAll(^{
                            error = nil;
                            threshold = [SRGThreshold thresholdWithStringIdentifier:SecondThresholdIdentifier
                                                                   requiredCounters:@3
                                                                          startDate:startDate
                                                                            endDate:endDate];
                            [thresholdContext addThreshold:threshold
                                                   failure:&error];
                        });
                        
                        it(@"should not set an error", ^{
                            [[error should] beNil];
                        });
                        
                        it(@"should contain two thresholds", ^{
                            
                            [[thresholdContext.thresholds should] haveCountOf:2];
                        });
                        
                        it(@"should contain the added threshold", ^{
                            
                            [[[thresholdContext.thresholds objectForKey:threshold.identifier] should] beNonNil];
                        });
                    });
                });
            });
            
            context(@"when adding counters", ^{
                context(@"to an existing threshold", ^{
                    
                    __block SRGThreshold *threshold;
                    __block BOOL result = NO;
                    __block NSError *error = nil;
                    
                    afterEach(^{
                        result = YES;
                        error = nil;
                    });
                    
                    context(@"when the threshold has not reached its limit", ^{
                        beforeAll(^{
                            [thresholdContext addCounterWithThresholdIdentifier:ThresholdIdentifier                                                                        failure:&error];
                            threshold = thresholdContext[ThresholdIdentifier];
                        });
                        it(@"should not generate an error.", ^{
                            [[error should] beNil];
                        });
                        it(@"threshold counters should have increased", ^{
                            [[threshold.counters should] equal:@1];
                        });
                    });
                    
                    context(@"when the threshold has reached its limit", ^{
                        beforeAll(^{
                            
                            [thresholdContext addCounterWithThresholdIdentifier:ThresholdIdentifier failure:&error];
                            [thresholdContext addCounterWithThresholdIdentifier:ThresholdIdentifier failure:&error];
                            
                            [thresholdContext addCounterWithThresholdIdentifier:ThresholdIdentifier failure:&error];
                        });
                       
                        it(@"should generate an error.", ^{
                            [[error should] beNonNil];
                        });
                        
                        it(@"the threshold context counters should be equal to their limit", ^{
                            [[threshold.counters should] equal:threshold.requiredCounters];
                        });
                    });
                });
            });
            
            context(@"when all counters reach their limits", ^{
                __block BOOL reachedAll = NO;
                beforeAll(^{
                    error = nil;
                    [thresholdContext addThreshold:[SRGThreshold thresholdWithStringIdentifier:ThirdThresholdIdenfifier
                                                                              requiredCounters:@2
                                                                                     startDate:startDate
                                                                                       endDate:endDate]
                                           failure:&error];
                   
                    [thresholdContext setDidReachLimitHandler:^(SRGThresholdContext *context) {
                        reachedAll = YES;
                    }];
                    
                    [thresholdContext addCounterWithThresholdIdentifier:SecondThresholdIdentifier failure:&error];
                    [thresholdContext addCounterWithThresholdIdentifier:SecondThresholdIdentifier failure:&error];
                    [thresholdContext addCounterWithThresholdIdentifier:SecondThresholdIdentifier failure:&error];
                    [thresholdContext addCounterWithThresholdIdentifier:ThirdThresholdIdenfifier failure:&error];
                    [thresholdContext addCounterWithThresholdIdentifier:ThirdThresholdIdenfifier failure:&error];
                });
                
                it(@"should call the reach limit handler", ^{
                    
                    [[theValue(reachedAll) should] equal:theValue(YES)];
                    
                });
            });
            
            context(@"when unarchiving the context", ^{
                it(@"should publish an unarchiving method", ^{
                    [[thresholdContext should] respondToSelector:@selector(unarchive)];
                });
                context(@"after archiving the context", ^{
                    __block SRGThresholdContext *unarchivedContext = nil;
                    __block SRGThreshold *archivedChildThreshold = nil;
                    __block SRGThreshold *unarchivedChildThreshold = nil;
                    beforeAll(^{
                        [thresholdContext archive];
                        unarchivedContext = (SRGThresholdContext *)[thresholdContext unarchive];
                        archivedChildThreshold = thresholdContext[ThirdThresholdIdenfifier];
                        unarchivedChildThreshold = unarchivedContext[ThirdThresholdIdenfifier];
                    });
                    it(@"should not be nil", ^{
                        [[unarchivedContext should] beNonNil];
                    });
                    it(@"should have the correct number of thresholds", ^{
                        [[theValue(unarchivedContext.thresholds.count) should] equal:theValue(thresholdContext.thresholds.count)];
                    });
                    it(@"child threshold should not be nil", ^{
                        [[unarchivedContext should] beNonNil];
                    });
                    it(@"child threshold should have the correct number of counters", ^{
                        [[unarchivedChildThreshold.counters should] equal:archivedChildThreshold.counters];
                    });
                    it(@"child threshold should have the correct number of required counters", ^{
                        [[unarchivedChildThreshold.requiredCounters should] equal:archivedChildThreshold.requiredCounters];
                    });
                });
            });
        });
    });
});
SPEC_END

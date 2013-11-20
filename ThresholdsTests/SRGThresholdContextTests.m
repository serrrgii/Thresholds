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
            
            thresholdContext = [SRGThresholdContext contextWithStringIdentifier:ContextIdentifier failure:&error];
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
            beforeAll(^{
                error = nil;
                thresholdContext = [SRGThresholdContext contextWithStringIdentifier:SecondContextIdentifier
                                                                            failure:&error];
            });
            it(@"should let us add it", ^{
                [[thresholdContext should] respondToSelector:@selector(addThreshold:failure:)];
            });
            context(@"after adding a threshold", ^{
                __block SRGThreshold *threshold;
                context(@"using a new identifier", ^{
                    beforeAll(^{
                        threshold = [SRGThreshold thresholdWithStringIdentifier:ThresholdIdentifier
                                                               requiredCounters:@3
                                                                      startDate:[[NSDate date] dateByAddingDays:-1]
                                                                        endDate:[[NSDate date] dateByAddingDays:1]];
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
                
            });
        });
    });
});
SPEC_END

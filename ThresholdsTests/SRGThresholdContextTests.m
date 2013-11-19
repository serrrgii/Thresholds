//
//  SRGThresholdContextTests.m
//  Thresholds
//
//  Created by Sergi Borras on 11/18/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "Kiwi.h"
#import "SRGThresholdContext.h"

SPEC_BEGIN(ThresholdContextSpec)

static NSString *const ContextIdentifier = @"com.srg.gyg.myidentifier";
static NSString *const SecondContextIdentifier = @"com.srg.gyg.myidentifier2";

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
            thresholdContext = [SRGThresholdContext contextWithStringIdentifier:ContextIdentifier failure:&error];
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
        context(@"and after initializing another instance", ^{
            context(@"using a different identifier", ^{
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
        });
    });
});
SPEC_END

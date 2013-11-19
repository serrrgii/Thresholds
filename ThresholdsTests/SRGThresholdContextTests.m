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

describe(@"Threshold contexts", ^{
    __block SRGThresholdContext *thresholdContext;
    context(@"before initializing", ^{
        it(@"should allow to create a context with a string identifier", ^{
            [[SRGThresholdContext.class should] respondToSelector:@selector(contextWithStringIdentifier:)];
        });
    });
    context(@"after initializing", ^{
        beforeAll(^{
            thresholdContext = [SRGThresholdContext contextWithStringIdentifier:ContextIdentifier];
        });
        it(@"should not be nil", ^{
            [[thresholdContext should] beNonNil];
        });
    });
});
SPEC_END

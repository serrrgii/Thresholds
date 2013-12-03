//
//  SRGThresholdRule.h
//  TimeEvents
//
//  Created by Sergi Borras on 11/14/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGThresholdRuling.h"

typedef NS_ENUM(NSUInteger, SRGThresholdRuleErrorCodes) {
    SRGThresholdLimitErrorCode,
    SRGThresholdStartDateErrorCode,
    SRGThresholdEndDateErrorCode
};

@interface SRGThresholdLimitRule : NSObject<SRGThresholdRuling>

@end

@interface SRGThresholdStartDateRule : NSObject<SRGThresholdRuling>

@end

@interface SRGThresholdEndDateRule : NSObject<SRGThresholdRuling>

@end
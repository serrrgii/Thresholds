//
//  SRGThresholdRuling.h
//  Thresholds
//
//  Created by Sergi Borras on 12/3/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>



@class SRGThreshold;

@protocol SRGThresholdRuling <NSObject>
- (BOOL)validateThreshold:(SRGThreshold *)threshold error:(NSError **)error;
@end

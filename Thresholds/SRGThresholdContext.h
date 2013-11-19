//
//  SRGThresholdContext.h
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGArchiveObject.h"

typedef NS_ENUM(NSUInteger, SRGThresholdContextErrorCodes) {
    SRGThresholdContextExistsErrorCode
};

@interface SRGThresholdContext : SRGArchiveObject
+ (instancetype)contextWithStringIdentifier:(NSString *)identifier failure:(NSError **)error;
@end

//
//  NSObject+Errors.m
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "NSObject+Errors.h"

@implementation NSObject (Errors)
- (NSError *)generateErrorWithDescription:(NSString *)description recoverySuggestion:(NSString *)suggestion code:(NSUInteger)code
{
    return [self.class generateErrorWithDescription:description
                                 recoverySuggestion:suggestion
                                               code:code];
}
+ (NSError *)generateErrorWithDescription:(NSString *)description recoverySuggestion:(NSString *)suggestion code:(NSUInteger)code
{
    NSArray *recoveryOptions = @[NSLocalizedString(@"Ok", @"Title of button inside alert.")];
    
    NSDictionary *errorUserInfo = @{
                                    NSLocalizedDescriptionKey : description,
                                    NSLocalizedRecoverySuggestionErrorKey : suggestion,
                                    NSLocalizedRecoveryOptionsErrorKey :recoveryOptions
                                    };
    
    NSString *errorDomain = [NSBundle mainBundle].bundleIdentifier;
    
    return [NSError errorWithDomain:errorDomain
                               code:code
                           userInfo:errorUserInfo];
}
@end

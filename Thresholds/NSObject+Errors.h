//
//  NSObject+Errors.h
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Errors)
- (NSError *)generateErrorWithDescription:(NSString *)description recoverySuggestion:(NSString *)suggestion code:(NSUInteger)code;
+ (NSError *)generateErrorWithDescription:(NSString *)description recoverySuggestion:(NSString *)suggestion code:(NSUInteger)code;
@end

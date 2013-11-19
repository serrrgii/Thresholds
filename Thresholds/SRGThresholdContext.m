//
//  SRGThresholdContext.m
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "SRGThresholdContext.h"
#import "NSObject+Errors.h"

@interface SRGThresholdContext()<NSCoding>
@property (readwrite, strong, nonatomic) NSString *identifier;
@end
@implementation SRGThresholdContext

+ (instancetype)contextWithStringIdentifier:(NSString *)identifier failure:(NSError **)error
{
    if ([self fetchWithStringIdentifier:identifier]) {
        
        *error = [self generateErrorWithDescription:NSLocalizedString(@"Threshold context exists", nil)
                                 recoverySuggestion:NSLocalizedString(@"Use fetch with string identifier instead", nil)
                                               code:SRGThresholdContextExistsErrorCode];

        return nil;
    }
    
    return [self archiveObjectWithStringIdentifier:identifier];
}
#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.identifier = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(identifier))];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier
                  forKey:NSStringFromSelector(@selector(identifier))];
}
@end

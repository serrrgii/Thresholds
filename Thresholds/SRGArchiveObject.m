//
//  SRGArchiveObject.m
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "SRGArchiveObject.h"

@interface SRGArchiveObject()
@property (readwrite, strong, nonatomic) NSString *identifier;
@end
@implementation SRGArchiveObject
- (id)initWithStringIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self)
    {
        self.identifier = identifier;
    }
    return self;
}
+ (instancetype)archiveObjectWithStringIdentifier:(NSString *)identifier
{
    return [[self alloc] initWithStringIdentifier:identifier];
}
- (void)archive
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:self.identifier];
}
- (SRGArchiveObject *)unarchive
{
    return [self.class fetchWithStringIdentifier:self.identifier];
}
+ (instancetype)fetchWithStringIdentifier:(NSString *)identifier
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
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

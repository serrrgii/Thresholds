//
//  SRGArchiveObject.h
//  Thresholds
//
//  Created by Sergi Borras on 11/19/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRGArchiveObject : NSObject<NSCoding>
@property (readonly, strong, nonatomic) NSString *identifier;
+ (instancetype)archiveObjectWithStringIdentifier:(NSString *)identifier;
+ (instancetype)fetchWithStringIdentifier:(NSString *)identifier;
- (void)archive;
- (SRGArchiveObject *)unarchive;
@end

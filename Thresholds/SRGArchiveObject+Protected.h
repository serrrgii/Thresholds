//
//  SRGArchiveObject+Protected.h
//  Thresholds
//
//  Created by Sergi Borras on 11/29/13.
//  Copyright (c) 2013 Sergi Borras. All rights reserved.
//

#import "SRGArchiveObject.h"

@interface SRGArchiveObject (Protected)
- (id)initWithStringIdentifier:(NSString *)identifier;
@property (readwrite, strong, nonatomic) NSString *identifier;
@end

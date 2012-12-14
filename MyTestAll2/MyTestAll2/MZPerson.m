//
//  MZPerson.m
//  MyTestAll2
//
//  Created by uistrong on 12-12-14.
//  Copyright (c) 2012年 uistrong. All rights reserved.
//

#import "MZPerson.h"

@implementation MZPerson


- (id) init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString*) name{
    return _name;
}

- (void) setName:(NSString *)name{
    if (_name != name) {
        [_name release];
        _name = [name retain];
    }
}

- (void) dealloc{
    [_name release];
    [super dealloc];
}
@end

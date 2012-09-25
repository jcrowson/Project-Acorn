//
//  PackageLocation.m
//  Project Acorn
//
//  Created by James Crowson on 25/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import "PackageLocation.h"

@implementation PackageLocation

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}


@end
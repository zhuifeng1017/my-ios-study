//
//  MZLocation.m
//  MyTestAll
//
//  Created by  on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZLocation.h"

@implementation MZLocation
@synthesize delegate;

+ (MZLocation*) shareInstance
{
    static MZLocation* instance = nil;
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //_locationManager.headingFilter = 5.0;
        
        _locationManager.delegate = self;
        self.delegate = nil;
    }
    return self;
}

- (void)startUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled ]) {
        [_locationManager startUpdatingLocation];
    }
}

- (void)startUpdatingHeading
{
    if ([CLLocationManager headingAvailable ]) {
        [_locationManager startUpdatingHeading];
    }
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

- (void)stopUpdatingHeading
{
    [_locationManager stopUpdatingHeading];
}



- (void)locationManager:(CLLocationManager *)locationManager 
    didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation;
{
    if (self.delegate) {
        [self.delegate updatingLocation:newLocation];
    }
}

/*
 指南针数据读取
 */

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{	
    if (self.delegate) {
        [self.delegate UpdatingHeading:newHeading];
    }
}

/*
 校正指南针界面
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
	return YES;
}
@end

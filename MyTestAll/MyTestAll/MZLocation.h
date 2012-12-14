//
//  MZLocation.h
//  MyTestAll
//
//  Created by  on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@protocol MZLocationModelDelegate<NSObject>

@optional
- (void)updatingLocation:(CLLocation *)newLocation;
- (void)UpdatingHeading:(CLHeading *)newHeading;
@end

@interface MZLocation : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

+ (MZLocation*) shareInstance;
- (void)stopUpdatingHeading;
- (void)stopUpdatingLocation;
- (void)startUpdatingHeading;
- (void)startUpdatingLocation;

@property (assign, nonatomic) id<MZLocationModelDelegate> delegate;
@end

//
//  FindJobsController.h
//  Project Acorn
//
//  Created by James Crowson on 28/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface FindJobsController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    MKMapView *mapView;
    CLLocationManager *locationManager;

}

@property (nonatomic, strong) NSArray *listOfLatitudesOfCollectJobs;
@property (nonatomic, strong) NSArray *listOfLongitudesOfCollectJobs;

@property (nonatomic, strong) NSArray *listOfLatitudesOfDeliverJobs;
@property (nonatomic, strong) NSArray *listOfLongitudesOfDeliverJobs;

@end

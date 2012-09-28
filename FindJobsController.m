//
//  FindJobsController.m
//  Project Acorn
//
//  Created by James Crowson on 28/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import "FindJobsController.h"

@interface FindJobsController ()

@end

@implementation FindJobsController

@synthesize listOfLatitudesOfCollectJobs;
@synthesize listOfLongitudesOfCollectJobs;

@synthesize listOfLatitudesOfDeliverJobs;
@synthesize listOfLongitudesOfDeliverJobs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,320,450)];    
    mapView.delegate = self;
    [mapView setMapType: MKMapTypeStandard];
    [self.view addSubview: mapView]; 

    
    locationManager = [[CLLocationManager alloc] init];

    [locationManager setDelegate:self];

    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [mapView setShowsUserLocation:YES];
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    
    self.listOfLatitudesOfCollectJobs = [[NSArray alloc] initWithObjects:@"51.488936",@"51.517017",nil];
    self.listOfLongitudesOfCollectJobs = [[NSArray alloc] initWithObjects:@"-0.1221",@"-0.123611",nil];
    
    self.listOfLatitudesOfDeliverJobs = [[NSArray alloc] initWithObjects:@"51.490229",@"51.517717",nil];
    self.listOfLongitudesOfDeliverJobs = [[NSArray alloc] initWithObjects:@"-0.119137",@"-0.126898",nil];
    
    for (int i=0; i<2; i++) {
        
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude = [[self.listOfLatitudesOfCollectJobs objectAtIndex:i] doubleValue];
        coordinate.longitude = [[self.listOfLongitudesOfCollectJobs objectAtIndex:i] doubleValue];;
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:[NSString stringWithFormat:@"%i", i]];

        [mapView addAnnotation:annotation];
                
    }
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    MKPointAnnotation *annotation = view.annotation;
    NSString *annotationID = view.annotation.title;
    
    if([annotation.title isEqualToString:annotationID])
    {
        
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude = [[self.listOfLatitudesOfDeliverJobs objectAtIndex:[annotationID intValue]] doubleValue];
        coordinate.longitude = [[self.listOfLongitudesOfDeliverJobs objectAtIndex:[annotationID intValue]] doubleValue];;
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:[NSString stringWithFormat:@"Deliver"]];

        [mapView addAnnotation:annotation];

    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    if ([[annotation title] isEqualToString:@"Deliver"] ) {
        
        NSLog(@"Selected Deliver");
        static NSString *annotationIdentifier = @"DeliveryPinIdentifier"; 
        MKPinAnnotationView *deliverPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        
        [deliverPin setPinColor:MKPinAnnotationColorGreen];
        deliverPin.animatesDrop = NO; 
        deliverPin.canShowCallout = YES; 

        return deliverPin; 
        
    }
    /*
    static NSString *annotationIdentifier = @"CollectPinIdentifier";
    MKPinAnnotationView *collectPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    
    [collectPin setPinColor:MKPinAnnotationColorRed];
    collectPin.animatesDrop = YES; 
    collectPin.canShowCallout = YES; 
    
    return collectPin; 
     */
    
    return nil;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

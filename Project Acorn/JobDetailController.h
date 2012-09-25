//
//  JobDetailController.h
//  Project Acorn
//
//  Created by James Crowson on 19/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface JobDetailController : UIViewController <ZXingDelegate, UITextFieldDelegate> {
    
    BOOL doneInitialZoom;
    UITextField *deliveryCodeTextField;
    
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, copy) NSString *qrCodeResult;
@property (nonatomic, strong) IBOutlet UITextView *deliverToText;
@property (strong, nonatomic) IBOutlet UILabel *jobStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *deliveryCodeLabel;
@property (strong, nonatomic) IBOutlet UITextField *deliveryCodeTextField;
@property (strong, nonatomic) NSArray *geocodeArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *scanBarcodeButton;

@property  double lat;
@property  double lon;


//Params to map to values from previous view
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *jobStatus;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *collectionAddressLine1;
@property (strong, nonatomic) NSString *collectionAddressLine2;
@property (strong, nonatomic) NSString *collectionPostcode;
@property (strong, nonatomic) NSString *collectionCity;
@property (strong, nonatomic) NSString *deliveryAddressLine1;
@property (strong, nonatomic) NSString *deliveryAddressLine2;
@property (strong, nonatomic) NSString *deliveryCity;
@property (strong, nonatomic) NSString *deliveryPostcode;
@property (strong, nonatomic) NSString *recipientFirstName;
@property (strong, nonatomic) NSString *recipientLastName;
@property (strong, nonatomic) NSString *comment;


- (IBAction)collectPressed:(id)sender;

@end

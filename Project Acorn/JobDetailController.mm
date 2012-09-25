//
//  JobDetailController.m
//  Project Acorn
//
//  Created by James Crowson on 19/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "JobDetailController.h"
#import "QRCodeReader.h"
#import "PackageLocation.h"

@interface JobDetailController ()

@end

@implementation JobDetailController
@synthesize deliverToText;
@synthesize jobStatusLabel;
@synthesize deliveryCodeLabel;
@synthesize deliveryCodeTextField;
@synthesize mapView;
@synthesize qrCodeResult;
@synthesize geocodeArray;
@synthesize scanBarcodeButton;
@synthesize lat;
@synthesize lon;

@synthesize jobTitle;
@synthesize jobStatus;
@synthesize price;
@synthesize collectionAddressLine1;
@synthesize collectionAddressLine2;
@synthesize collectionPostcode;
@synthesize collectionCity;

@synthesize deliveryAddressLine1;
@synthesize deliveryAddressLine2;
@synthesize deliveryPostcode;
@synthesize deliveryCity;
@synthesize recipientFirstName;
@synthesize recipientLastName;
@synthesize comment;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.deliveryCodeTextField setDelegate:self];
    [self.deliveryCodeTextField setReturnKeyType:UIReturnKeyDone];
    [self.deliveryCodeTextField addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];

    /********************************************
     * Params passed from previous view via segue
     ********************************************/
        
    self.jobStatusLabel.text = [NSString stringWithFormat:@"Status: %@", self.jobStatus];
    
    //set navbar title to job number:
    self.navigationItem.title = self.jobTitle;
    
    /********************************************
     * If Not Collected
     ********************************************/
    
    if ([self.jobStatus isEqualToString:@"Not Collected"]) {
        
        //Hit the Google Maps API to Geocode the postcode into lat and long.
        NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", self.collectionPostcode];
        
        NSURL *googleURL = [NSURL URLWithString:googleMapsURLString];
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:googleURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) 
                                   withObject:data waitUntilDone:YES];
            
        });
        
        self.scanBarcodeButton.enabled = YES;
        
        self.deliverToText.text  = [NSString stringWithFormat:@"Collection Address: \n %@ \n %@ \n %@ \n %@", self.collectionAddressLine1, self.collectionAddressLine2, self.collectionCity, self.collectionPostcode];
        
        self.deliveryCodeLabel.hidden  = YES;
        self.deliveryCodeTextField.hidden = YES;

    }
    
        
    /********************************************
     * If Collected
     ********************************************/
    
    else if ([self.jobStatus isEqualToString:@"Collected"]) {
        
        //Hit the Google Maps API to Geocode the postcode into lat and long.
        NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", self.deliveryPostcode];
        
        NSURL *googleURL = [NSURL URLWithString:googleMapsURLString];
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:googleURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) 
                                   withObject:data waitUntilDone:YES];
            
        });

        
        self.jobStatusLabel.text = [NSString stringWithFormat:@"Status: %@", self.jobStatus];
        
        self.deliverToText.text  = [NSString stringWithFormat:@"Delivery Address: \n %@ \n %@ \n %@ \n %@", self.deliveryAddressLine1, self.deliveryAddressLine2, self.deliveryCity, self.deliveryPostcode];

        //Hide the collect button when they've scanned the package and it's the correct one.
        self.scanBarcodeButton.enabled = NO;
        
        //show the text field
        self.deliveryCodeLabel.hidden = NO;
        self.deliveryCodeTextField.hidden = NO;

    }
    
    
    /********************************************
     * If Delivered
     ********************************************/
    
    else if ([self.jobStatus isEqualToString:@"Delivered"]) {
        
        //Hit the Google Maps API to Geocode the postcode into lat and long.
        NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", self.deliveryPostcode];
        
        NSURL *googleURL = [NSURL URLWithString:googleMapsURLString];
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:googleURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) 
                                   withObject:data waitUntilDone:YES];
            
        });
        
        self.jobStatusLabel.text = @"Status: Delivered";
        self.deliverToText.text = @"Job Complete! Congratulations!";
    
        //Hide the collect button when they've scanned the package and it's the correct one.
        self.scanBarcodeButton.enabled = NO;
    
        //show the text field
        self.deliveryCodeLabel.hidden = YES;
        self.deliveryCodeTextField.hidden = YES;
    
    }
}

- (IBAction)textFieldFinished:(id)sender
{
     [sender resignFirstResponder];
}


- (void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions 
                          error:&error];

    self.geocodeArray = [json objectForKey:@"results"];
    NSLog(@"geocode:%@", self.geocodeArray); 
    
    NSDictionary *geocode = [self.geocodeArray objectAtIndex:0];
        
    self.lon = [[[(NSDictionary*)[geocode objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng" ] doubleValue];
    self.lat = [[[(NSDictionary*)[geocode objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat" ] doubleValue];
    
    NSLog(@"lat:%f lon: %f", self.lat, self.lon);
    
    /********************************************
     * ZOOM TO LOCATION IN MAP
     ********************************************/
    
    CLLocationCoordinate2D zoomLocation;
    
    zoomLocation.latitude = self.lat;
    zoomLocation.longitude= self.lon;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
    
    [self.mapView setRegion:adjustedRegion animated:YES];

    PackageLocation *package = [[PackageLocation alloc] initWithName:self.comment address:nil coordinate:zoomLocation];
    
    [self.mapView addAnnotation:package];
    
    [self.mapView selectAnnotation:package animated:YES];
    
}


#pragma mark -
#pragma mark Open QR Reader

- (IBAction)collectPressed:(id)sender {
    
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    [self presentModalViewController:widController animated:YES];
    [widController release];

}


#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    
    if (self.isViewLoaded) {
        
        /********************************************
         * POST to webservice
         ********************************************/
        
        //Get job number (normall from the row in the UITableView)
        NSString *jobNumber = self.jobTitle;
        
        //POST var to web service
        NSString *post = [NSString stringWithFormat:@"collectBarCodeID=%@&jobNumber=%@", result, jobNumber];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://listogra.ph/collect.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLResponse *response = NULL;
        NSError *requestError = NULL;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",responseString);
        
        /********************************************
         * Handling the PHP file response
         ********************************************/
        
        if ([responseString isEqualToString:@"200"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:@"Success"];
            [alert setMessage:@"QR Code Scanned Successfully"];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            [alert release];
            
            self.jobStatusLabel.text = [NSString stringWithFormat:@"Status: Collected "];
            
            self.deliverToText.text  = [NSString stringWithFormat:@"Collection Address: \n %@ \n %@ \n %@ \n %@", self.deliveryAddressLine1, self.deliveryAddressLine2, self.deliveryCity, self.deliveryPostcode];
            
            //Hide the collect button when they've scanned the package and it's the correct one.
            self.scanBarcodeButton.enabled = NO;
            
            //show the text field
            self.deliveryCodeLabel.hidden = NO;
            self.deliveryCodeTextField.hidden = NO;
            
            //Hit the Google Maps API to Geocode the postcode into lat and long.
            NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", self.deliveryPostcode];
            
            NSURL *googleURL = [NSURL URLWithString:googleMapsURLString];
            
            dispatch_async(kBgQueue, ^{
                NSData* data = [NSData dataWithContentsOfURL:googleURL];
                [self performSelectorOnMainThread:@selector(fetchedData:) 
                                       withObject:data waitUntilDone:YES];
                
            });

            
        }
        
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:@"Error"];
            [alert setMessage:@"Incorrect QR Code"];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"Ok"];
            [alert show];
            [alert release];
        }
        
    }
    
    
    [self dismissModalViewControllerAnimated:NO];
}


-(void) zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Send Delivery Code
-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    /********************************************
     * POST to webservice
     ********************************************/
    
    //Get job number (normall from the row in the UITableView)
    NSString *jobNumber = self.jobTitle;
    
    //Get the delivery code from the users input
    NSString *deliverCode = self.deliveryCodeTextField.text;
    
    //POST var to web service
    NSString *post = [NSString stringWithFormat:@"deliverBarCodeID=%@&jobNumber=%@", deliverCode, jobNumber];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://listogra.ph/deliver.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",responseString);
    
    /********************************************
     * Handling the PHP file response
     ********************************************/
    
    if ([responseString isEqualToString:@"200"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Success"];
        [alert setMessage:@"Package Successfully Delivered"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        [alert release];
        
        self.jobStatusLabel.text = @"Delivered";
        self.deliverToText.text = @"Dropped off package at location";
        
        //Hide the collect button when they've scanned the package and it's the correct one.
        self.scanBarcodeButton.enabled = YES;
        
        //show the text field
        self.deliveryCodeLabel.hidden = YES;
        self.deliveryCodeTextField.hidden = YES;
        
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Error"];
        [alert setMessage:@"Incorrect Delivery Code"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
        [alert release];
    }

}

- (void)viewDidUnload
{
    [self setDeliverToText:nil];
    [self setJobStatusLabel:nil];
    [self setDeliveryCodeLabel:nil];
    [self setDeliveryCodeTextField:nil];
    [self setMapView:nil];
    [self setScanBarcodeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end

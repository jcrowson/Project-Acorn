//
//  JobDetailController.m
//  Project Acorn
//
//  Created by James Crowson on 19/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//


#import "JobDetailController.h"
#import "QRCodeReader.h"

@interface JobDetailController ()

@end

@implementation JobDetailController
@synthesize deliverToText;
@synthesize jobStatusLabel;
@synthesize collectButton;
@synthesize deliveryCodeLabel;
@synthesize deliveryCodeTextField;
@synthesize submitDeliveryCodeButton;
@synthesize qrCodeResult;
@synthesize jobStatus;


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    /********************************************
     * Params passed from previous view via segue
     ********************************************/
        
    self.jobStatusLabel.text = [NSString stringWithFormat:@"Status: %@", self.jobStatus];

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
        NSString *jobNumber = @"12345";
        
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
            
            self.jobStatusLabel.text = @"Collected";
            self.deliverToText.text = @"James Crowson SE1 7HF";
            
            //Hide the collect button when they've scanned the package and it's the correct one.
            self.collectButton.hidden = YES;
            
            //show the text field
            self.deliveryCodeLabel.hidden = NO;
            self.deliveryCodeTextField.hidden = NO;
            self.submitDeliveryCodeButton.hidden = NO;
            
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

#pragma mark -
#pragma mark Send Delivery Code

- (IBAction)sendDeliveryCodePressed:(id)sender {
    
    /********************************************
     * POST to webservice
     ********************************************/
    
    //Get job number (normall from the row in the UITableView)
    NSString *jobNumber = @"12345";
    
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
        self.collectButton.hidden = YES;
        
        //show the text field
        self.deliveryCodeLabel.hidden = YES;
        self.deliveryCodeTextField.hidden = YES;
        self.submitDeliveryCodeButton.hidden = YES;
        
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

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions 
                          error:&error];
    
    NSArray* latestLoans = [json objectForKey:@"jobs"]; //2
    
    NSLog(@"jobs: %@", latestLoans); //3
    
    // 1) Get the latest loan
    NSDictionary* loan = [latestLoans objectAtIndex:0];
    
    // 2) Get the funded amount and loan amount
    self.jobStatus = [loan objectForKey:@"status"];
    
    //logic to control what stage the job is at depending on job status
    
    if ([self.jobStatus isEqualToString:@"Not Collected"]) {
        
        self.deliverToText.text = @"Collect package from: Mr James Crowson, SE1 7HF";
        self.collectButton.hidden = NO;
        self.deliveryCodeLabel.hidden = YES;
        self.deliveryCodeTextField.hidden = YES;
        self.submitDeliveryCodeButton.hidden = YES;
    }
    
    else if ([self.jobStatus isEqualToString:@"Collected"]) {
        
        self.deliverToText.text = @"Deliver Package to:";
        self.collectButton.hidden = YES;
        self.deliveryCodeLabel.hidden = NO;
        self.deliveryCodeTextField.hidden = NO;
        self.submitDeliveryCodeButton.hidden = NO;

    }
    
    else {
        
        self.deliverToText.text = @"Dropped off package at location";
        //Hide the collect button when they've scanned the package and it's the correct one.
        self.collectButton.hidden = YES;
        //show the text field
        self.deliveryCodeLabel.hidden = YES;
        self.deliveryCodeTextField.hidden = YES;
        self.submitDeliveryCodeButton.hidden = YES;
        
    }

    
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setDeliverToText:nil];
    [self setJobStatusLabel:nil];
    [self setCollectButton:nil];
    [self setDeliveryCodeLabel:nil];
    [self setDeliveryCodeTextField:nil];
    [self setSubmitDeliveryCodeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end

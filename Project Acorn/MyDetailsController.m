//
//  MyDetailsController.m
//  Project Acorn
//
//  Created by James Crowson on 24/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kLatestKivaLoansURL [NSURL URLWithString: @"http://listogra.ph/agent.php"]

#import "MyDetailsController.h"
#import "SVProgressHUD.h"
#import "KeychainItemWrapper.h"


@interface MyDetailsController ()

@end

@implementation MyDetailsController
@synthesize photograph;
@synthesize usernameLabel;
@synthesize reputationLabel;
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize addressLine1Label;
@synthesize addressLine2Label;
@synthesize cityLabel;
@synthesize postcodeLabel;
@synthesize countryLabel;
@synthesize mobileLabel;
@synthesize mobileVerifiedLabel;
@synthesize skypeLabel;
@synthesize skypeVerifiedLabel;
@synthesize agentDetails;

@synthesize username;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    }

-(void) viewDidAppear:(BOOL)animated {
    
    //get the username and password from the keychain
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"RunjoLoginKey" accessGroup:nil];
    self.username = [keychainItem objectForKey:kSecAttrAccount];
    
    if ([self.username length] != 0) {
        
        NSLog(@"The username is:%@", self.username);
        
        /********************************************
         * POST to webservice
         ********************************************/
            
        //POST var to web service
        NSString *post = [NSString stringWithFormat:@"agentUsernameFromPhone=%@", self.username];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://listogra.ph/agent.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLResponse *response = NULL;
        NSError *requestError = NULL;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
                
        dispatch_async(kBgQueue, ^{
            NSData* data = responseData;
            [self performSelectorOnMainThread:@selector(fetchedData:) 
                                   withObject:data waitUntilDone:YES];
        });

    }
}

- (void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions 
                          error:&error];
    
    self.agentDetails = [json objectForKey:@"agent"];
    
    NSDictionary *agent = [self.agentDetails objectAtIndex:0];
    
    NSURL *imageURL = [NSURL URLWithString:[agent objectForKey:@"photograph"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.photograph.image = [UIImage imageWithData:imageData];
    
    self.usernameLabel.text = [agent objectForKey:@"username"];
    self.reputationLabel.text = [agent objectForKey:@"reputation"];
    self.firstNameLabel.text = [agent objectForKey:@"firstName"];
    self.lastNameLabel.text = [agent objectForKey:@"lastName"];

    self.addressLine1Label.text = [agent objectForKey:@"addressLine1"];
    self.addressLine2Label.text = [agent objectForKey:@"addressLine2"];
    self.cityLabel.text = [agent objectForKey:@"city"];
    self.postcodeLabel.text = [agent objectForKey:@"postcode"];
    self.countryLabel.text = [agent objectForKey:@"country"];
    
    self.mobileLabel.text = [agent objectForKey:@"mobile"];
    self.mobileVerifiedLabel.text = [agent objectForKey:@"mobileVerified"];
    self.skypeLabel.text = [agent objectForKey:@"skype"];
    self.skypeVerifiedLabel.text = [agent objectForKey:@"skypeVerified"];
        
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setPhotograph:nil];
    [self setUsernameLabel:nil];
    [self setReputationLabel:nil];
    [self setFirstNameLabel:nil];
    [self setLastNameLabel:nil];
    [self setAddressLine1Label:nil];
    [self setAddressLine2Label:nil];
    [self setCityLabel:nil];
    [self setPostcodeLabel:nil];
    [self setCountryLabel:nil];
    [self setMobileLabel:nil];
    [self setMobileVerifiedLabel:nil];
    [self setSkypeLabel:nil];
    [self setSkypeVerifiedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)logOutButtonPressed:(id)sender {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"RunjoLoginKey" accessGroup:nil];
    
    [keychainItem resetKeychainItem];
    
    [self performSelector:@selector(changeTabBarToInitialTab) withObject:self afterDelay:1];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;    
    [self presentModalViewController:loginVC animated:YES];

}

-(void)changeTabBarToInitialTab {
    
        [self.tabBarController setSelectedIndex:0];
}

@end

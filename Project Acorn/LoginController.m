//
//  LoginController.m
//  Project Acorn
//
//  Created by James Crowson on 24/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import "LoginController.h"
#import "JobsController.h"
#import "SVProgressHUD.h"
#import "KeychainItemWrapper.h"


@interface LoginController ()

@end

@implementation LoginController

@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"RunjoLoginKey" accessGroup:nil];
    [keychainItem resetKeychainItem];
    NSLog(@"username is:%@",[keychainItem objectForKey:kSecAttrAccount]);

}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (IBAction)loginButtonPressed:(id)sender {
    
    /********************************************
     * POST to webservice
     ********************************************/
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;

    //POST var to web service
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://listogra.ph/login.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",responseString);
    
    if ([responseString isEqualToString:@"200"]) {
        
        /********************************************
         * Storing keychain info
         ********************************************/
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"RunjoLoginKey" accessGroup:nil];
        
        //Create a keychain and save the users' name and password
        [keychainItem setObject:self.passwordField.text forKey:kSecValueData];
        [keychainItem setObject:self.usernameField.text forKey:kSecAttrAccount];
        
        //login successful
        [self dismissModalViewControllerAnimated:YES];
        [SVProgressHUD showWithStatus:@"Loading Jobs"];

    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Problem with login"];
        [alert setMessage:@"Incorrect username or password. Please try again."];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }

}

@end

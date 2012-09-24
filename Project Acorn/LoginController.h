//
//  LoginController.h
//  Project Acorn
//
//  Created by James Crowson on 24/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonPressed:(id)sender;

@end

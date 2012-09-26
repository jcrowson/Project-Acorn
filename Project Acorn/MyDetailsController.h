//
//  MyDetailsController.h
//  Project Acorn
//
//  Created by James Crowson on 24/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDetailsController : UITableViewController

//IB Outlets
@property (strong, nonatomic) IBOutlet UIImageView *photograph;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *reputationLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLine1Label;
@property (strong, nonatomic) IBOutlet UILabel *addressLine2Label;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *postcodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileVerifiedLabel;
@property (strong, nonatomic) IBOutlet UILabel *skypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *skypeVerifiedLabel;
- (IBAction)logOutButtonPressed:(id)sender;

@property (nonatomic, strong) NSArray *agentDetails;

@end

//
//  JobDetailController.h
//  Project Acorn
//
//  Created by James Crowson on 19/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"

@interface JobDetailController : UIViewController <ZXingDelegate>

@property (nonatomic, copy) NSString *qrCodeResult;
@property (nonatomic, strong) IBOutlet UITextView *deliverToText;
@property (strong, nonatomic) IBOutlet UILabel *jobStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectButton;
@property (strong, nonatomic) IBOutlet UILabel *deliveryCodeLabel;
@property (strong, nonatomic) IBOutlet UITextField *deliveryCodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *submitDeliveryCodeButton;
@property (strong, nonatomic) NSString *jobStatus;

- (IBAction)collectPressed:(id)sender;
- (IBAction)sendDeliveryCodePressed:(id)sender;

@end

//
//  JobTableViewCell.h
//  Project Acorn
//
//  Created by James Crowson on 20/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *jobNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *postcodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *costLabel;
@property (nonatomic, strong) IBOutlet UILabel *deliverPostcodeLabel;

@end

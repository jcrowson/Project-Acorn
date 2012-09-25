//
//  JobTableViewCell.m
//  Project Acorn
//
//  Created by James Crowson on 20/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import "JobTableViewCell.h"

@implementation JobTableViewCell

@synthesize jobNumberLabel;
@synthesize statusLabel;
@synthesize costLabel;
@synthesize postcodeLabel;
@synthesize deliverPostcodeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

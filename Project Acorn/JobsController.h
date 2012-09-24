//
//  JobsController.h
//  Project Acorn
//
//  Created by James Crowson on 20/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobDetailController.h"

@interface JobsController : UITableViewController 
    

@property (nonatomic, strong) NSMutableArray *listOfJobs;
@property (nonatomic, strong) NSMutableArray *listOfJobStatuses;
@property (nonatomic, strong) NSMutableArray *listOfJobCosts;
@property (nonatomic, strong) NSMutableArray *listOfJobPostcodes;


@end

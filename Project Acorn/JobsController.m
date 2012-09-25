//
//  JobsController.m
//  Project Acorn
//
//  Created by James Crowson on 20/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kLatestKivaLoansURL [NSURL URLWithString: @"http://listogra.ph/jobs.php"]

#import "JobsController.h"
#import "JobTableViewCell.h"

@interface JobsController ()

@end

@implementation JobsController

@synthesize listOfJobs;


- (void)viewDidLoad
{
    [super viewDidLoad];

        
}

-(void) viewDidAppear:(BOOL)animated {
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });

}


- (void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions 
                          error:&error];
    
    self.listOfJobs = [json objectForKey:@"jobs"];
       
    int allJobsCount = [self.listOfJobs count];
    NSLog(@"number of jobs = %i", allJobsCount);

    [self.tableView reloadData];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.listOfJobs count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"jobTableViewCell";
    
    JobTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JobTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *aJob = [self.listOfJobs objectAtIndex:[indexPath row]];
    cell.jobNumberLabel.text = [aJob objectForKey:@"jobNumber"];
    cell.postcodeLabel.text = [aJob objectForKey:@"collectionPostcode"];
    cell.costLabel.text = [aJob objectForKey:@"price"]; 
    cell.statusLabel.text = [aJob objectForKey:@"status"]; 
    cell.deliverPostcodeLabel.text = [aJob objectForKey:@"recipientPostCode"];

    return cell;   
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showJobDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //Get the destination controller
        JobDetailController *destViewController = segue.destinationViewController;
        
        NSDictionary *aJob = [self.listOfJobs objectAtIndex:[indexPath row]];
        
        //Get the variable 
        destViewController.jobStatus = [aJob objectForKey:@"status"];
        destViewController.jobTitle = [aJob objectForKey:@"jobNumber"];
        destViewController.collectionPostcode = [aJob objectForKey:@"collectionPostcode"]; 
        destViewController.deliveryPostcode = [aJob objectForKey:@"recipientPostCode"];
        destViewController.comment = [aJob objectForKey:@"comments"];
                
    }
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end

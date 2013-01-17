//
//  MonthViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "MonthViewController.h"
#import "AlbumListCell.h"
#import "RequestController.h"
#import "DateViewController.h"
#import "MonthGroup.h"
#import "UIImageExtension.h"

@implementation MonthViewController
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark
- (void) didSuccessRequest:(id)result{
    [_activity stopAnimating];
    
    if (_resultController){
        [_resultController release];
        _resultController = nil;
    }
    
    _resultController = (NSFetchedResultsController*)[result retain];
    [_tableView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_tableView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - View lifecycle

- (void) dealloc{
    [_activity release];
    [_formatter release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy"];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self.view setAlpha:0.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear monthview");
    [super viewWillAppear:animated];
    
    [RequestController requestMonthGroupsOnBackgroundFromDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[_resultController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_resultController sections]objectAtIndex:section]numberOfObjects];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 23.0)] autorelease];
    UIImageView *bgHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CategoryBar_Bg"]];
    [headerView addSubview:bgHeader];
    [bgHeader release];
    
    UILabel * secLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _tableView.frame.size.width-5, 23.0)];
    secLabel.backgroundColor = [UIColor clearColor];
    secLabel.font = [UIFont boldSystemFontOfSize:14.0];
    secLabel.textColor = RGB(130, 130, 130);
    secLabel.shadowColor = RGB(52, 52, 52);
    secLabel.shadowOffset = CGSizeMake(0, -1.1);
    secLabel.textAlignment = UITextAlignmentLeft;
    
    NSString * str;
    NSDate * year = [(MonthGroup*)[[[[_resultController sections]objectAtIndex:section] objects] objectAtIndex:0] year];
    str = [_formatter stringFromDate:year];
    secLabel.text = [str substringWithRange:NSMakeRange(0, 4)];
    [bgHeader addSubview:secLabel];
    [secLabel release];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AlbumListCell *cell = (AlbumListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AlbumListCell" owner:nil options:nil];
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[AlbumListCell class]])
			{
				cell = (AlbumListCell *)currentObject;
                [cell initCell];
				break;
			}
		}
	}
    // cell appearance
    [cell setFirstRow:indexPath.row==0?YES:NO];
    
    // Configure the cell...
    MonthGroup * month = [_resultController objectAtIndexPath:indexPath];
    
    if (month) {
        NSLog(@"month: %@",month.year);
        
        [cell setThumb:nil title:[month monthTitle]  subTitle:[NSString stringWithFormat:@"(%d)", [month.photos count]]];
        
        if (0 < [month.photos count]) {
            
            
            NSString * filePath = [LIBRARY_FOLDER stringByAppendingPathComponent:[[[month.photos allObjects] objectAtIndex:0] thumb_url]];
            
            UIImage * thumb = [UIImage imageFilePath:filePath forSession:self];
            [cell setThumb:thumb];
            [cell setNeedsLayout];
        }
    }
    

    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonthGroup * group = [_resultController objectAtIndexPath:indexPath];    
    DateViewController * dateViewController = [[DateViewController alloc] initWithType:DateViewControllerTypeAsMonth groupMonth:group.month orGroupId:nil];
    dateViewController.title = [group monthTitle];
    
    [[self _navigation] pushViewController:dateViewController animated:YES];
    [dateViewController release];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)refresh{
    [RequestController requestMonthGroupsOnBackgroundFromDelegate:self];
}
@end

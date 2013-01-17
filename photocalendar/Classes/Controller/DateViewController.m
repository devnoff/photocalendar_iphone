//
//  DateViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 7..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "DateViewController.h"
#import "CSBarButtonItemUtils.h"
#import "RequestController.h"
#import "PhotoCell.h"
#import "UIImage+Resize.h"
#import "PhotoModel.h"
#import "DateGroup.h"
#import "MonthGroup.h"
#import "PhotoViewController.h"
#import "UIImageExtension.h"


@interface DateViewController()
- (void) loadData;
@end

@implementation DateViewController

@synthesize groupId = _groupId;
@synthesize groupMonth = _groupMonth;
@synthesize type = _type;
@synthesize tableView = _tableView;


- (id) initWithType:(DateViewControllerType)type groupMonth:(NSDate*)month orGroupId:(NSString*)groupId{
    self = [self initWithNibName:@"DateViewController" bundle:nil];
    if (self) {
        
        _type = type;
        _groupMonth = [month retain];
        _groupId = [groupId retain];
        
    }
    
    return self;
}

- (void) loadData{
    switch (_type) {
        case DateViewControllerTypeAsGroupId:
            [RequestController backgroundRequestPhotosInGroup:_groupId fromDelegate:self];
            break;
            
        case DateViewControllerTypeAsMonth:
            [RequestController backgroundRequestPHotosInMonth:_groupMonth fromDelegate:self];
            break;
    }
}


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        _photoVC = [[PhotoViewController alloc]init];
        
    }
    
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

 
- (void)dealloc{
    [_tableView release];
    [_groupMonth release];
    [_groupId release];
    [_resultController release];
    [_activity release];
    [_photoVC release];
    [_summaryLabel release];
    [UIImage clearSession:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
    self.view.frame = CGRectMake(0, 0, 320, 324);
    _tableView.frame = CGRectMake(0, 0, 320, 324);
    
    NSLog(@"viewdidload dateview");
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[CSBarButtonItemUtils backButtonWithTitle:NSLocalizedString(@"BACK", nil) target:self action:@selector(backBtnTapped:)]];
    
    
}



- (void) backBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwillappear");
    
    //[self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
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

static int sectionCount = 0;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    sectionCount = [[_resultController sections] count];
    return sectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return ceil([[[_resultController sections] objectAtIndex:section] numberOfObjects]/4.0);
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowCnt = ceil([[[_resultController sections] objectAtIndex:indexPath.section] numberOfObjects]/4.0);
    if (indexPath.row == rowCnt-1) {
        return 82.0;
    }
    return 80.0;
}

static int count = 0;
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if SYSTEM_VERSION_LESS_THAN(@"5") {
        if (count < sectionCount) {
            count++;
            return @" ";
        }
    }
    
    NSLog(@"section title :%@",[[[_resultController sections] objectAtIndex:section] name]);
    return [[[_resultController sections] objectAtIndex:section] name];
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
    
    
    NSString * dateStr= [[[_resultController sections] objectAtIndex:section] name];
    NSLog(@"section title :%@",dateStr);
    NSArray * strs = [dateStr componentsSeparatedByString:@":"];
    if (_type == DateViewControllerTypeAsGroupId) {
        secLabel.text = [strs objectAtIndex:0];
    } else {
        secLabel.text = [strs objectAtIndex:1];
    }
    
    [bgHeader addSubview:secLabel];
    [secLabel release];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PhotoCell *cell = (PhotoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:nil options:nil];
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[PhotoCell class]])
			{
				cell = (PhotoCell *)currentObject;
                cell.delegate = self;
                [cell initialize];
				break;
			}
		}
	}
    
    int total = [[[_resultController sections] objectAtIndex:indexPath.section] numberOfObjects];
    
    int start = indexPath.row * 4;
    int end = start + 4;
    if (total < end) {
        end = total;
    }
    
    for (int i=start; i<end; i++) {
        
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];

        PhotoModel * photo = (PhotoModel*)[_resultController objectAtIndexPath:myIndexPath];  
        
//        NSLog(@"photo: %@",photo);
        
        NSString * filePath = [LIBRARY_FOLDER stringByAppendingPathComponent:photo.thumb_url];
        UIImage * thumb = [UIImage imageFilePath:filePath forSession:self];
        
        [cell setImage:thumb 
               atIndex:(i % 4) 
andIndexForResultController:[[_resultController fetchedObjects] indexOfObject:photo]];
        [cell setDuration:[photo.duration doubleValue] forIndex:i%4];
        [cell setNeedsLayout];
        
        }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) scrollToIndex:(NSInteger)index{
//    NSIndexPath * indexPath = [_resultController indexPathForObject:[[_resultController fetchedObjects]objectAtIndex:index]];
//    NSIndexPath * myIndexPath = [NSIndexPath indexPathForRow:ceil(indexPath.row/4.0) inSection:indexPath.section];
//    [_tableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}



#pragma mark - RequestControllerDelegate Method

- (void) didSuccessRequest:(id)result{
    
    NSLog(@"success with result");
    
    [_activity stopAnimating];
    
    if (_resultController){
        [_resultController release];
        _resultController = nil;
    }
    _resultController = (NSFetchedResultsController*)[result retain];
    [_tableView reloadData];
    
    [self updateSummaryLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_tableView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
    
    PhotoDataSource * dataSource = [[PhotoDataSource alloc] initWithResultController:_resultController];
    _photoVC.photoDataSource = dataSource;
    [dataSource release];
    
}


#pragma mark - PhotoButtonDelegate Method

-(void) photoButtonTapped:(id)sender{
    
    NSLog(@"index %d", [(PhotoButton*)sender index]);
    [_photoVC setDefaultPage:[(PhotoButton*)sender index]];
    [self.navigationController pushViewController:_photoVC animated:YES];
}

#pragma mark - 
- (void) updateSummaryLabel{
    
    int photoSum = 0;
    int videoSum = 0;
    int unknownSum = 0;
    for (PhotoModel * photo in [_resultController fetchedObjects]){
        if ([photo.type isEqualToString:ALAssetTypeVideo]) {
            videoSum++;
        } else if([photo.type isEqualToString:ALAssetTypePhoto]){
            photoSum++;
        } else {
            unknownSum++;
        }
    }
    
    NSString *photoText = [NSString stringWithFormat:@"%d Photo%@", photoSum, photoSum>1?@"s":@""];
    NSString *videoText = [NSString stringWithFormat:@"%d Video%@", videoSum, videoSum>1?@"s":@""];
    NSString *unknownText = [NSString stringWithFormat:@"%d Unknown%@", unknownSum, unknownSum>1?@"s":@""];
    
    NSMutableArray * arr = [NSMutableArray array];
    if(photoSum>0) [arr addObject:photoText];
    if(videoSum>0) [arr addObject:videoText];
    if(unknownSum>0) [arr addObject:unknownText];
    
    NSString * labelText = [arr componentsJoinedByString:@", "];
    _summaryLabel.text = labelText;
}

- (void)refresh{
    [self loadData];
}

@end

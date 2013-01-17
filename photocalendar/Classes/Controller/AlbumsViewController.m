//
//  AlbumsViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumListCell.h"
#import "RequestController.h"
#import "PhotoGroup.h"
#import "DateViewController.h"
#import "NoPhotoView.h"

@interface AlbumsViewController()
@end

@implementation AlbumsViewController
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

#pragma mark - View lifecycle

- (void)dealloc{
    [_tableView release];
    [_resultController release];
    [_activity release];
    [super dealloc];
}


- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     NSLog(@"viewdid unload albums");
    [self.view setAlpha:0.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [RequestController requestAlbumGroupsFromDelegate:self];
    
    
    BOOL zero = [[NSUserDefaults standardUserDefaults] boolForKey:@"ZERO_PHOTO"];
    if (zero) {
        for(UIView * v in [self.view subviews]){
            if ([v isKindOfClass:[NoPhotoView class]]) {
                return;
            }
        }
        
        NoPhotoView *noView = [[NoPhotoView alloc]initWithFrame:self.view.frame];
        [self.view insertSubview:noView atIndex:0];
        [noView release];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (IS_FIRST) {
//        [self performSelector:@selector(showHeaderView) withObject:nil afterDelay:.5];      
//        FIRST(NO);
//        SYNC_USER_DEFAULT;
//    }
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
    NSLog(@"section : %d",[[_resultController sections] count]);
    
    return [[_resultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[_resultController sections] objectAtIndex:section] numberOfObjects];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
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
    [cell setFirstRow:NO];
    
    // Configure the cell...
    PhotoGroup * group = [_resultController objectAtIndexPath:indexPath];
    UIImage * thumb = [UIImage imageWithData:group.poster];
    //UIImage * thumb = [UIImage imageWithContentsOfFile:group.thumb_url];
    
    [cell setThumb:thumb title:group.group_name subTitle:[NSString stringWithFormat:@"(%d)",[group.photos count]]];
    
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectRowAtIndexPath");

    PhotoGroup * group = [_resultController objectAtIndexPath:indexPath];
    
    DateViewController * dateViewController = [[DateViewController alloc] initWithType:DateViewControllerTypeAsGroupId groupMonth:nil orGroupId:group.group_id];

    [dateViewController setTitle:group.group_name];
    
    
    [[self _navigation] pushViewController:dateViewController animated:YES];
    
    [dateViewController release];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark

- (void)didSuccessRequest:(id)result{
    [_activity stopAnimating];
    
    
    NSLog(@"resutscontroller retaincount: %d", [_resultController retainCount]);
    if (_resultController) {
        [_resultController release];
        _resultController = nil;
    }
    _resultController = [(NSFetchedResultsController*)result retain];
    [_tableView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_tableView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)refresh{
    [RequestController requestAlbumGroupsFromDelegate:self];
}

@end

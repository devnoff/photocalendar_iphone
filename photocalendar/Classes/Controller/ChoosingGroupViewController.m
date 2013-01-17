//
//  ChoosingGroupViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 23..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "ChoosingGroupViewController.h"
#import "AlbumListCell.h"
#import "AppDelegate.h"

@interface ChoosingGroupViewController()
- (void)collectGroupDB;
@end

@implementation ChoosingGroupViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _choosenGroup = [[NSMutableSet alloc] init];
        _groups = [[NSMutableArray alloc] init];
        _library = [[ALAssetsLibrary alloc] init];
        _groupsMapping = [[NSMutableDictionary alloc] init];
        
              
    }
    return self;
}

- (void)loadHiddenGroup{
    
    _hiddenGroup = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:HIDDEN_GROUP_PLIST]){
        _hiddenGroup = [[NSMutableSet alloc]initWithArray:[NSArray arrayWithContentsOfFile:HIDDEN_GROUP_PLIST]];
    } else{
        _hiddenGroup = [[NSMutableSet alloc]init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)dealloc{
    
    [_tableView release];
    [_summaryLabel release];
    [_choosenGroup release];
    [_groups release];
    [_library release];
    [_groupsMapping release];
    [_sectionHeader release];
    [_cancelBtn release];
    [_importBtn release];
    [_titleLabel release];
    [_hiddenGroup release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self collectGroupDB];
    [self loadHiddenGroup];  
    [self collectGroupList];
//    [self updateSummaryLabel];
    
    
    // init views
    
    _cancelBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    CGRect cancelRect = _cancelBtn.titleLabel.frame;
    cancelRect.origin.y = 2;
    _cancelBtn.titleLabel.shadowColor = [UIColor redColor];
    _cancelBtn.titleLabel.frame = cancelRect;
    [_cancelBtn setTitle:NSLocalizedString(@"CLOSE", nil) forState:UIControlStateNormal];

    
    _importBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    CGRect importRect = _importBtn.titleLabel.frame;
    cancelRect.origin.y = 2;
    _importBtn.titleLabel.frame = importRect;
    _importBtn.titleLabel.shadowColor = [UIColor blueColor];
    [_importBtn setTitle:NSLocalizedString(@"DONE", nil) forState:UIControlStateNormal];

    _titleLabel.text = NSLocalizedString(@"CHOOSE_GROUPS", nil);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 서머리 라벨 초기화 
    NSString * labelText = [NSString stringWithFormat:NSLocalizedString(@"%d Group, %d Item Selected", nil), 0, 0];
    _summaryLabel.text = labelText;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.sectionHeader;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_groups count];
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
                [cell initForCellModeSelect];
                cell.delegate = self;
				break;
			}
		}
	}
    [cell setFirstRow:NO];
    
    // Configure the cell...
    DOGroup *group = [_groups objectAtIndex:indexPath.row];
    cell.group = group;
    
    if (group) {
        UIImage * thumb = [UIImage imageWithData:group.poster];
        [cell setThumb:thumb title:group.group_name subTitle:[NSString stringWithFormat:@"(%d)",[group.photo_cnt intValue]]];
    
        
        cell.selected = ![_hiddenGroup containsObject:group.group_id];
    }
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

#pragma mark -

- (void) collectGroupList{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(queue, ^{
//    [_library enumerateGroupsWithTypes:ALAssetsGroupAll
//                                  usingBlock: ^(ALAssetsGroup *group, BOOL *stop){ 
//                                      if (group!=nil) {
//                                          [group setAssetsFilter:[ALAssetsFilter allPhotos]];
//                                          
//                                          DOGroup * photoGroup = [[[DOGroup alloc] init]autorelease];
//                                          photoGroup.group_name = [group valueForProperty:ALAssetsGroupPropertyName];
//                                          photoGroup.group_type = [group valueForProperty:ALAssetsGroupPropertyType];
//                                          NSString * groupId = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
//                                          groupId = groupId==nil?[NSString stringWithFormat:@"%@%@",photoGroup.group_name,photoGroup.group_type]:groupId;
//                                          photoGroup.group_id = groupId;
//                                          photoGroup.photo_cnt = [NSNumber numberWithInteger:[group numberOfAssets]];
//                                          
//                                          UIImage * img = [UIImage imageWithCGImage:[group posterImage]];
//                                          NSData * imgData = UIImageJPEGRepresentation(img, 1.0);
//                                          photoGroup.poster = imgData;
//                                          
//                                          [_groups addObject:photoGroup];
//                                          [photoGroup release];
//                                      } else {
//                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                          [_tableView reloadData];
//                                          });
//                                      }
//                                  }
//                                failureBlock: ^(NSError *error) {}];
//    });
    
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll
                            usingBlock: ^(ALAssetsGroup *group, BOOL *stop){ 
                                if (group!=nil) {
                                    if (!HAS_UPGRADED) {
                                        [group setAssetsFilter:[ALAssetsFilter allPhotos]];    
                                    } else {
                                        [group setAssetsFilter:[ALAssetsFilter allAssets]];    
                                    }
                                    
                                    
                                    NSString * groupId = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
                                    
                                    
                                    DOGroup *photoGroup = [[[DOGroup alloc] init]autorelease];
                                    photoGroup.group_name = [group valueForProperty:ALAssetsGroupPropertyName];
                                    photoGroup.group_type = [group valueForProperty:ALAssetsGroupPropertyType];
                                    
                                    groupId = groupId==nil?[NSString stringWithFormat:@"%@%@",photoGroup.group_name,photoGroup.group_type]:groupId;
                                    photoGroup.group_id = groupId;
                                    photoGroup.photo_cnt = [NSNumber numberWithInteger:[group numberOfAssets]];
                                    
                                    UIImage * img = [UIImage imageWithCGImage:[group posterImage]];
                                    NSData * imgData = UIImageJPEGRepresentation(img, 1.0);
                                    photoGroup.poster = imgData;
                                    
                                             
//                                    DOGroup * photoGroup = [_groupsMapping objectForKey:groupId];
//                                    if (!photoGroup) {
//                                        photoGroup = [[[DOGroup alloc] init]autorelease];
//                                        photoGroup.group_name = [group valueForProperty:ALAssetsGroupPropertyName];
//                                        photoGroup.group_type = [group valueForProperty:ALAssetsGroupPropertyType];
//                                        
//                                        groupId = groupId==nil?[NSString stringWithFormat:@"%@%@",photoGroup.group_name,photoGroup.group_type]:groupId;
//                                        photoGroup.group_id = groupId;
//                                        photoGroup.photo_cnt = [NSNumber numberWithInteger:[group numberOfAssets]];
//                                        
//                                        UIImage * img = [UIImage imageWithCGImage:[group posterImage]];
//                                        NSData * imgData = UIImageJPEGRepresentation(img, 1.0);
//                                        photoGroup.poster = imgData;
//                                    } else {
//                                        photoGroup.group_name = [group valueForProperty:ALAssetsGroupPropertyName];
//                                        photoGroup.group_type = [group valueForProperty:ALAssetsGroupPropertyType];
//                                        photoGroup.photo_cnt = [NSNumber numberWithInteger:[group numberOfAssets]];
//                                        [_choosenGroup addObject:photoGroup];
//                                    }
                                    [_groups addObject:photoGroup];

                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        // 저장된 숨겨진 그룹이 현재 불러온 에셋 그룹에 없다면 숨겨진 그룹에서 그룹 삭제
                                        NSMutableSet *deletable = [NSMutableSet setWithSet:_hiddenGroup];
                                        for (DOGroup *group in _groups){
                                            NSString *gid = [deletable member:group.group_id];
                                            if (gid) [deletable removeObject:gid];
                                        }
                                        
                                        if([deletable count]>0) [_hiddenGroup minusSet:deletable];

                                        
                                        
                                        [_tableView reloadData];
                                        
                                        [self updateSummaryLabel];
                                    });
                                }
                            }
                          failureBlock: ^(NSError *error) {}];

}


- (void) updateSummaryLabel{
    int countGroup = [_groups count] - _hiddenGroup.count;
    int countPhoto = 0;
    for (DOGroup *group in _groups) {
        if (![_hiddenGroup containsObject:group.group_id])
            countPhoto = countPhoto + [group.photo_cnt intValue];
    }
    
    NSString * labelText = [NSString stringWithFormat:
                            NSLocalizedString(@"%d Group%@, %d Item%@ Selected", nil), 
                            countGroup, 
                            countGroup>1?NSLocalizedString(@"s", nil):@"", 
                            countPhoto, 
                            countPhoto>1?NSLocalizedString(@"s", nil):@""];
    _summaryLabel.text = labelText;
}

- (IBAction)cancelBtnTapped:(id)sender{
    [[self _navigation] dismissModalViewControllerAnimated:YES];
}


- (IBAction)importBtnTapped:(id)sender{
    
    NSLog(@"hidden group count : %d",[_hiddenGroup count]);
//    
//    NSMutableSet *deletable = [NSMutableSet setWithSet:_hiddenGroup];
//    for (DOGroup *group in _groups){
//        NSString *gid = [deletable member:group.group_id];
//        if (gid) [deletable removeObject:gid];
//    }
//    
//    if([deletable count]>0) [_hiddenGroup minusSet:deletable];
    
    NSArray *arr = [[NSArray alloc] initWithArray:[_hiddenGroup allObjects]];
    [arr writeToFile:HIDDEN_GROUP_PLIST atomically:NO];
    [arr release];
    
    
    [[self _navigation] dismissModalViewControllerAnimated:YES];
    
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate runBackgroundLoading];
//
//    LoadingViewController * loading = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
//    loading.delegate = delegate;
//    loading.choosenGroup = _choosenGroup;
//    loading.view.alpha = 0.0f;
//    //delegate.window.rootViewController = loading;
//    [[self _navigation] presentModalViewController:loading animated:YES];
//    
//    
//    [UIView animateWithDuration:.3 
//                     animations:^{
//                         loading.view.alpha = 1.0f;
//                     } 
//                     completion:^(BOOL finished){
//                         [loading startLoading];
//                         [loading release];
//                     }];
    
//    [delegate loadLoadingViewController];
}


- (void)collectGroupDB{
    
    
    NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
    NSManagedObjectContext * _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:coord];
    
    
    // collect group from DB
    NSFetchRequest *groups = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoGroup" inManagedObjectContext:_context];
    [groups setEntity:entity];
    
    NSArray * groupEntries = [_context executeFetchRequest:groups error:nil];
    
    for(PhotoGroup * pg in groupEntries){

        
        DOGroup * photoGroup = [[[DOGroup alloc] init]autorelease];
        photoGroup.group_name = pg.group_name;
        photoGroup.group_type = pg.group_type;
        NSString * groupId = pg.group_id;
        groupId = groupId==nil?[NSString stringWithFormat:@"%@%@",photoGroup.group_name,photoGroup.group_type]:groupId;
        photoGroup.group_id = groupId;
        photoGroup.photo_cnt = pg.photo_cnt;
        photoGroup.poster = pg.poster;
        
        [_groupsMapping setObject:photoGroup forKey:groupId];
    }
    
    [groups release];
}


#pragma mark - AlbumListCellDelegate methods

- (void)didSelectedGroup:(DOGroup *)group{
    NSLog(@"choosen group count did select group : %d",[_choosenGroup count]);
//    [_choosenGroup addObject:group];
    [_hiddenGroup removeObject:group.group_id];
    [self updateSummaryLabel];
}

- (void)didDeselectedGroup:(DOGroup *)group{
//    [_choosenGroup removeObject:group];
    [_hiddenGroup addObject:group.group_id];
    [self updateSummaryLabel];
}



@end

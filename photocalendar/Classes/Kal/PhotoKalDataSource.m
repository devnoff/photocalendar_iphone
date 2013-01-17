//
//  PhotoKalDataSource.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 16..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "PhotoKalDataSource.h"
#import "PhotoDateCell.h"
#import "CSDateCalculator.h"
#import "DateGroup.h"
#import "PhotoModel.h"
#import "AppDelegate.h"

@interface PhotoKalDataSource()
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation PhotoKalDataSource
@synthesize resultController = _resultController;
@synthesize dates = _dates;
@synthesize items = _items;


- (void) dealloc{
    [_resultController release];
    [_dates release];
    [_items release];
    [super dealloc];
}



+ (PhotoKalDataSource*)dataSource{
    return [[[[self class] alloc] init] autorelease];
}


#pragma mark - KalDataSource Protocal Method

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate{
    
    
    [RequestController requestPhotosFromDate:fromDate toDate:toDate fromDelegate:self];
    _delegate = delegate;
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate{

    return _dates;
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dc = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:toDate];
    
    NSArray * arr = [_resultController fetchedObjects];
    for(DateGroup * group in arr){
        NSDateComponents *dc1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:group.date];
        if(dc.year==dc1.year&&dc.month==dc1.month&&dc.day==dc1.day){
            
            _items = [[group photosArray] retain];
            return;
        }
    }
}

- (void)removeAllItems{
    [_items release];
    _items = nil;
}


#pragma mark - UITableViewDelegate Method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"MyCell";
	PhotoDateCell *cell = (PhotoDateCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"PhotoDateCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
	}
    
	// cell setting
    if (_items!=nil) {
        PhotoModel * photo = (PhotoModel*)[_items objectAtIndex:indexPath.row];
        cell.timeLabel.text = [photo dateStrAsFormat:NSLocalizedString(@"FORMAT_CALENDAR_ITEM", nil)];
        NSString * filePath = [LIBRARY_FOLDER stringByAppendingPathComponent:photo.thumb_url];
        [cell.photo setImage:[UIImage imageWithContentsOfFile:filePath]];
        
        
        // 동영상 아이콘 표시
        [cell showMovieIcon:[photo.type isEqualToString:ALAssetTypeVideo]];
    }
    
    [cell setFirstRow:indexPath.row==0?YES:NO];
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_items) {
        return [_items count];
    }
	return 0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoDataSource *data = [[PhotoDataSource alloc] initForPhotoModels];
    [data setPhotoModels:_items];
    
    PhotoViewController * pvc = [[PhotoViewController alloc] init];
    [pvc setPhotoDataSource:data];
    [pvc setDefaultPage:indexPath.row];
    
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] navCon] pushViewController:pvc animated:YES];    
    
    [pvc release];
    [data release];
 
    
}

#pragma mark - RequestControllerDelegate methods

-(void)didSuccessRequest:(id)result{
    NSDictionary *dic = (NSDictionary*)result;
    self.resultController = [dic objectForKey:RESULTCONTROLLER];
    self.dates = [dic objectForKey:DATES];
    [_delegate loadedDataSource:self];
    
}

@end

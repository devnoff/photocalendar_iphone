
//
//  LoadingViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "LoadingViewController.h"
#import "PhotoModel.h"
#import "PhotoGroup.h"
#import "MonthGroup.h"
#import "DateGroup.h"
#import "RequestController.h"
#import "AppDelegate.h"
#import <ImageIO/ImageIO.h>
#import "DOGroup.h"


@interface DOPHoto : NSObject {
    NSDate * date_create;
    NSString * url;
    PhotoGroup * group;
    NSString * type;
}

@property(nonatomic,retain) NSDate * date_create;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) PhotoGroup * group;
@property(nonatomic,retain) NSString * type;
@end

@implementation DOPHoto
@synthesize date_create,url,group,type;

@end


#pragma mark - 

@interface LoadingViewController()
- (void)initialize;
- (void)collectDataFromDB;



- (void)insert;
- (void)deleteAllObjects:(NSString*) entityDescription;
- (void)updateProgressWithValues:(NSInteger)currCnt totalCnt:(NSInteger)totalCnt withTitle:(NSString*)title;
- (void)collectDataFromAssetsLibrary;
- (PhotoModel*)createPhotoEntityIfNotExistWithAsset:(ALAsset*)asset inCurrentContext:(NSManagedObjectContext*)context;

- (DateGroup*)dateGroupCotainedPhotoModel:(PhotoModel*)photo withContext:(NSManagedObjectContext*)context;
- (MonthGroup*)monthGroupContainedPHotoModel:(PhotoModel*)photo withContext:(NSManagedObjectContext*)context;

- (void)successLoading;
- (void)failedLoading;

- (BOOL)isExistInChoosenGroup:(NSString*)groupID withType:(NSInteger)type;


- (void) removeEmptyPhotoAndGroup;

//- (void)collectDataFromChoosenGroup;

- (void)convertDateFormateIfItdifferent;



- (void)insertContextFinished;
- (void)deleteContextFinished;

- (void)updateWrongURL;

- (void)removeWholeDataWithCallBack:(SEL)callBack;
- (void)deleteAllObjects: (NSString *) entityDescription withContext:(NSManagedObjectContext*)context;

- (void)startInserting;
- (BOOL)validVersion; 


// create cache directory

- (BOOL)createCacheDirectory;

@end

@implementation LoadingViewController
@synthesize delegate=_delegate;
@synthesize choosenGroup = _choosenGroup;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

- (void)initialize{
    // Custom initialization   
    
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    _monthGroup = [[NSMutableDictionary alloc] init];
    _dateGroup = [[NSMutableDictionary alloc] init];
    _photos = [[NSMutableDictionary alloc] init];
    
    _formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy.MM.dd cccc:d, cccc"];
    
    
    _groupsDB = [[NSMutableDictionary alloc] init];
    _photosDB = [[NSMutableDictionary alloc] init];
    
    
    
    _urlsGroup = [[NSMutableDictionary alloc] init];
    
    
    _deletablePhotos = [[NSMutableSet alloc] init];
    
    sync = 0;
    
    [self createCacheDirectory];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_progView release];
    [_assetsLibrary release];
    [_progDesc release];
    [_monthGroup release];
    [_dateGroup release];
    [_formatter release];
    [_photos release];
    [_choosenGroup release];
    [_photosDB release];
    [_groupsDB release];
    [_groupDBKeys release];
    [_photosDBKeys release];
    [_urlsGroup release];
    [_context release];
    [_activity release];
    [_deletablePhotos release];
    if (collectQueue) {
        dispatch_release(collectQueue);    
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -

//  1.1 업데이트에서 발생하는 썸네일 썸네일 URL을 절대경로에서 상대경로로 바꿔주는 코드
- (void)updateWrongURL {
    for (PhotoModel *photo in [_photosDB allValues]) {
        NSRange  r = [photo.thumb_url rangeOfString:@"Library/"];
        NSString * e = [photo.thumb_url substringFromIndex:NSMaxRange(r)];
        NSLog(@"%@",e);
        photo.thumb_url = e;
    }
}


- (void)virtualProgressBarWithDesc:(NSString *)description{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        int i =0;
        int total = 80;
        int num;
        while (_workingProgress) {
            
            num = i % 80;
            [self updateProgressWithValues:num totalCnt:total withTitle:description];
            
            [NSThread sleepForTimeInterval:.1];
            i++;
        }    
        
    });
    
    
}


- (void) removeWholeDataWithCallBack:(SEL)callBack{
    
//    if (_choosenGroup!=nil) {
//        [_choosenGroup release];
//        _choosenGroup = nil;    
//    }
//    
    
    _workingProgress = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self virtualProgressBarWithDesc:@"Removing cache data"];
    }); 
    
    
    // 썸네일 이미지 삭제 for under 1.4
    NSString *docsDir = LIBRARY_FOLDER;
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    
    
    NSDirectoryEnumerator *dirEnum =
    [localFileManager enumeratorAtPath:docsDir];
    
    NSString *file;
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString: @"jpg"]) {
            // process the document
            NSError * err;
            [localFileManager removeItemAtPath:[docsDir stringByAppendingPathComponent:file] error:&err];
            
        }
    }  
    
//    if (APP_VERSION_LESS_THAN(@"1.4")) {
//          
//    }
//    
//    
//    // 섬네일 이미지 삭제 from 1.4
//    NSError * err;
//    docsDir = PHOTO_CACHE_FOLDER;
//    if ([localFileManager removeItemAtPath:docsDir error:&err]) {
//        NSLog(@"success removing cache images");
//    } else {
//        NSLog(@"failed removing cache images : %@", err);
//    }
    
    
    [localFileManager release];
    
    // 데이터 베이스 삭제
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([app releasePersistantStoreCoordinator]) {
        [self performSelectorOnMainThread:callBack withObject:nil waitUntilDone:NO];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self failedLoading];
        }); 
        
    }
    
    // 이미지 캐시 디렉토리 생성
    [self createCacheDirectory];
    
    _workingProgress = NO;
    [self updateProgressWithValues:1 totalCnt:1 withTitle:@"Removing cache data"];
}

- (BOOL)createCacheDirectory{
    // 이미지 캐시 디랙토리 생성
    BOOL isDir;
    NSFileManager * fManager = [NSFileManager defaultManager]; 
    if(!([fManager fileExistsAtPath:PHOTO_CACHE_FOLDER isDirectory:&isDir]&&isDir)){
        if ([fManager createDirectoryAtPath:PHOTO_CACHE_FOLDER withIntermediateDirectories:YES attributes:nil error:nil]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}



#pragma mark - 

- (void)startInserting{
    dispatch_async(collectQueue, ^{
        
        [self collectDataFromDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self insert];
        }); 
        
    });  
}



- (void)startLoading{
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    NSLog(@"APP VERSION %@",GET_APP_VERSION);
    
    NSLog(@"start");
    collectQueue = dispatch_queue_create("collectQueue", NULL);
    
    dispatch_async(collectQueue, ^{
        
        /*
         *
         * 앱버전이 현재버전과 일치할 경우 로딩시작
         * 그렇지 않을 경우 전체 데이터를 삭제한 뒤 로딩 시작
         */
        
        if ([self validVersion]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startInserting];
            });     
        } else {
            [self removeWholeDataWithCallBack:@selector(startInserting)];
        }
        
        
        
    });    
}


- (BOOL)validVersion{
    
    // 앱이 설치 후 처음 실행 됨
    if (!HAS_DATA_LOADED) {
        return YES;
    }
    
    // for 1.2
    if (!GET_APP_VERSION) {    
        return NO;
    }
    
    // for 1.3
    if(APP_VERSION_LESS_THAN(@"1.5")){
        return NO;
    }
    
    return YES;
    
}

- (void)collectDataFromDB{
    
    NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:coord];
    
    
    int i = 0;
    int total = 0;
    
    
    // collect group from DB
    NSFetchRequest *groups = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoGroup" inManagedObjectContext:_context];
    [groups setEntity:entity];
    
    NSArray * groupEntries = [_context executeFetchRequest:groups error:nil];
    
    
    total = [groupEntries count];
    for(PhotoGroup * pg in groupEntries){
        [_groupsDB setObject:pg forKey:pg.group_id];
        
//        NSMutableSet * photosUrl = [[NSMutableSet alloc] init];
//        for(PhotoModel * pm in pg.photos){
//            [photosUrl addObject:pm.url];
//        }
//        [_urlsGroup setObject:photosUrl forKey:pg.group_id];
//        [photosUrl release];
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Collecting"];
    }
    _groupDBKeys = [[NSSet alloc] initWithArray:[_groupsDB allKeys]];
    
    [groups release];
    
    
    
    
    // collect photomodel from DB
    NSFetchRequest *photos = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"PhotoModel" inManagedObjectContext:_context];
    [photos setEntity:entity1];
    
    NSArray * photoEntries = [_context executeFetchRequest:photos error:nil];
    
    i = 0;
    total = [photoEntries count];
    
    for(PhotoModel * pm in photoEntries){
        [_photosDB setObject:pm forKey:pm.url];
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Collecting"];
    }
    
    _photosDBKeys = [[NSSet alloc] initWithArray:[_photosDB allKeys]];
    
    [_deletablePhotos setSet:_photosDBKeys];
    
    [photos release];
    
    
    
    
    
    // collect datemodel from DB
    NSFetchRequest *dates = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"DateGroup" inManagedObjectContext:_context];
    [dates setEntity:entity2];
    
    NSArray * dateEntries = [_context executeFetchRequest:dates error:nil];
    
    i = 0;
    total = [dateEntries count];
    for(DateGroup * group in dateEntries){
        [_dateGroup setObject:group forKey:group.date];
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Collecting"];
    }
    [dates release];
    
    
    
    
    // collect monthmodel from DB
    NSFetchRequest *months = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity3 = [NSEntityDescription entityForName:@"MonthGroup" inManagedObjectContext:_context];
    [months setEntity:entity3];
    
    NSArray * monthEntries = [_context executeFetchRequest:months error:nil];
    
    i = 0;
    total = [monthEntries count];
    for(MonthGroup * group in monthEntries){
        [_monthGroup setObject:group forKey:group.month];
        
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Collecting"];
    }
    [months release];
    
    
    
    
}

- (void) insert{
    
    // remove photo data cache
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    

    cnt = 0;
    _curCnt = 0;
    
    
    /*
     * 그룹 선택하여 로딩시
     *
     */
    
    if (_choosenGroup) {
        for (DOGroup *group in [_choosenGroup allObjects]) {
            cnt = cnt + [group.photo_cnt intValue];
        }
        
        NSLog(@"choosed photo count: %d",cnt);
        dispatch_async(collectQueue, ^{
            if (cnt>0) {
                [self collectDataFromAssetsLibrary];    
            } else {
                
                [self removeWholeDataWithCallBack:@selector(deleteContextFinished)];
                
            }    
        }); 
        
        return;
    }
    
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock: ^(ALAssetsGroup *group, BOOL *stop){ 
                                      if (group!=nil) {
                                          if (!HAS_UPGRADED) {
                                              [group setAssetsFilter:[ALAssetsFilter allPhotos]];    
                                          } else {
                                              [group setAssetsFilter:[ALAssetsFilter allAssets]];    
                                          }
                                          
                                          NSNumber *groupType = [group valueForProperty:ALAssetsGroupPropertyType];
                                          
                                          if ([self isExistInChoosenGroup:nil withType:[groupType integerValue]]) {
                                              cnt = cnt + [group numberOfAssets];
                                          }
                                          
                                            
                                      } else {
                                          NSLog(@"total count: %d",cnt);
                                          
                                          dispatch_async(collectQueue, ^{
                                              if (cnt>0) {
                                                  [self collectDataFromAssetsLibrary];    
                                              } else {
                
                                                  
                                                  [self removeWholeDataWithCallBack:@selector(deleteContextFinished)];
                                                  
                                              }    
                                          }); 
                                          
                                      }
                                  }
                                failureBlock: ^(NSError *error) {
                                    NSLog(@"failed: %@",error);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [_delegate didFailedLoading];
                                    }); 
                                }];
    
    
    
    
    
}

- (void) deleteContextFinished{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate didFinishLoadindWithNoPhoto];
    });
    
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest * allEntry = [[NSFetchRequest alloc] init];
    [allEntry setEntity:[NSEntityDescription entityForName:entityDescription inManagedObjectContext:_context]];
    [allEntry setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * entries = [_context executeFetchRequest:allEntry error:&error];
    [allEntry release];
    //error handling goes here
    for (NSManagedObject * car in entries) {
        [_context deleteObject:car];
    }
}

- (void) deleteAllObjects: (NSString *) entityDescription withContext:(NSManagedObjectContext*)context {
    NSFetchRequest * allEntry = [[NSFetchRequest alloc] init];
    [allEntry setEntity:[NSEntityDescription entityForName:entityDescription inManagedObjectContext:context]];
    [allEntry setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * entries = [context executeFetchRequest:allEntry error:&error];
    [allEntry release];
    //error handling goes here
    for (NSManagedObject * car in entries) {
        [context deleteObject:car];
    }
}





- (void)updateProgressWithValues:(NSInteger)currCnt totalCnt:(NSInteger)totalCnt withTitle:(NSString*)title{
    NSInteger count = currCnt;
    NSInteger total = totalCnt;
    double prog = (count+0.0)/(total+0.0);
    //NSLog(@"prog: %f",prog);
    NSString * desc = title;
    if (!desc) {
        desc = [NSString stringWithFormat:@"%d/%d", count,total];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progView setProgress:prog];
        [_progDesc setText:desc];

    });
}

- (BOOL)isExistInChoosenGroup:(NSString*)groupID withType:(NSInteger)type{
    
    // 최초 실행시에 포토스트림을 가져오지 않음
    if (!_choosenGroup) {
        
        if (type==ALAssetsGroupPhotoStream) {
            return NO;
        }
        return YES;
    }
    
    for (DOGroup *group in _choosenGroup){
        if ([group.group_id isEqualToString:groupID]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)collectDataFromAssetsLibrary{

    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                                      
                                      if (group != nil) {
                                          
                                          if (!HAS_UPGRADED) {
                                              [group setAssetsFilter:[ALAssetsFilter allPhotos]];    
                                          } else {
                                              [group setAssetsFilter:[ALAssetsFilter allAssets]];    
                                          }
                                          
                                          NSString * groupId = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
                                          NSString * groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                          NSNumber * groupType = [group valueForProperty:ALAssetsGroupPropertyType];
                                          
                                          groupId = groupId==nil?[NSString stringWithFormat:@"%@%@",groupName,groupType]:groupId;
                                          
                                          
                                          /*
                                           * 그룹선택하여 로딩시 이 블록 안해서 asset enumerate
                                           *
                                           */
                                          
                                          if ([self isExistInChoosenGroup:groupId withType:[groupType integerValue]]) {
                                          
                                              NSString * key = (NSString*)[_groupDBKeys member:groupId];
                                              
                                              UIImage * img = [UIImage imageWithCGImage:[group posterImage]];
                                              NSData * imgData = UIImageJPEGRepresentation(img, 1.0);
                                              
                                              if ([group numberOfAssets]>0) {
                                                  PhotoGroup * photoGroup;
                                                  if (key) {
                                                      photoGroup = (PhotoGroup*)[_groupsDB objectForKey:key];
                                                      [_groupsDB removeObjectForKey:key];//
                                                      
                                                      NSLog(@"photoGroup retainCount: %d",[photoGroup retainCount]);
                                                  } else {
                                                      
                                                      photoGroup = (PhotoGroup*)[NSEntityDescription insertNewObjectForEntityForName:@"PhotoGroup" inManagedObjectContext:_context];
                                                      
                                                      photoGroup.group_type = groupType;
                                                      photoGroup.group_id = groupId;
                                                      
                                                  }
                                                  [photoGroup setPoster:imgData];
                                                  photoGroup.group_name = groupName;
                                                  photoGroup.photo_cnt = [NSNumber numberWithInteger:[group numberOfAssets]];
                                                  
                                                  
                                                  [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {    
                                                      if (result!=nil) {
                                                          
                                                          NSString *assetUrl = [[[result defaultRepresentation]url]absoluteString];
                                                          NSString * key = (NSString*)[_photosDBKeys member:assetUrl];
                                                          
                                                          PhotoModel * photoModel;
                                                          if (key) {
                                                              photoModel = (PhotoModel*)[_context objectWithID:[[_photosDB objectForKey:key] objectID]];;
                                                          } else {
                                                              photoModel = [self createPhotoEntityIfNotExistWithAsset:result inCurrentContext:_context];
                                                          }
                                                          
                                                          if(![photoGroup.photos containsObject:photoModel]){
                                                              [photoModel addGroupObject:photoGroup];    
                                                          }
                                                          
                                                          
                                                          // URL을 가진 Photo 가 DB에 있을시 key를 '삭제목록'에서 제거
                                                          [_deletablePhotos removeObject:assetUrl];
//                                                          NSString * url = [urlsInGroup member:assetUrl];
//                                                          if (url) {
//                                                              [urlsInGroup removeObject:url];
//                                                          }
                                                          
                                                          
                                                          _curCnt++;
                                                          
                                                          [self updateProgressWithValues:_curCnt totalCnt:cnt withTitle:nil];
                                                          
                                                          
                                                          if (_curCnt==cnt) {
                                                              NSLog(@"Finished insert group");
                                                              [self convertDateFormateIfItdifferent];
                                                              [self removeEmptyPhotoAndGroup];
                                                              
                                                              [[NSNotificationCenter defaultCenter] addObserver:self
                                                                                                       selector:@selector(insertContextFinished)
                                                                                                           name:NSManagedObjectContextDidSaveNotification
                                                                                                         object:_context];
                                                              
                                                              NSError *err;
                                                              if ([_context save:&err]) {
                                                                  NSLog(@"context save success!");
                                                              } else {
                                                                  NSLog(@"failed to save context : %@",err);
                                                              }
                                                              
                                                              
                                                          } 
                                                      } else { // finish asset enemerate
                                                          NSLog(@"finish");
                                                          
                                                      }
                                                      
                                                  }];
                                               }
                                          }
                                          
                                          
                                      } else { // finish assetgroup enemerate
                                          //[self successLoading];
                                          NSLog(@"finished group");
                                          
                                      }
                                  }
     
                                failureBlock: ^(NSError *error) {
                                    NSLog(@"failed: %@",error);
                                }];
    

}

- (PhotoModel*)createPhotoEntityIfNotExistWithAsset:(ALAsset*)asset inCurrentContext:(NSManagedObjectContext*)context{
    
    NSString *assetUrl = [[[asset defaultRepresentation]url]absoluteString];
    
    PhotoModel * photo = [_photos objectForKey:assetUrl];
    if (photo) {
        
        NSLog(@"exist: %@", photo.url);
        return photo;
    } else {
        photo = (PhotoModel*)[NSEntityDescription insertNewObjectForEntityForName:@"PhotoModel" inManagedObjectContext:context];
        
        
        // 썸네일 이미지 저장
        CGImageRef imgRef = [asset thumbnail];
        
        if (imgRef) {
            
            UIImage *image = [[UIImage alloc] initWithCGImage:imgRef];
            
            NSData *compressedImageData = UIImageJPEGRepresentation(image, 1.0f);
            
            
            NSRange  r = [assetUrl rangeOfString:@"id="];
            NSFileManager * fManager = [NSFileManager defaultManager]; 
            NSString * e = [assetUrl substringFromIndex:NSMaxRange(r)];
            
            //        NSLog(@"%@",e);
            NSString *fileName = [NSString stringWithFormat: @"thumbnail_%@.jpg", e];
            NSString * filePath = [LIBRARY_FOLDER stringByAppendingPathComponent:fileName];  
            if (![fManager fileExistsAtPath:filePath]) {
                //If the data was compressed properly...
                if(compressedImageData) [compressedImageData writeToFile:filePath atomically:NO];
                
                //If it wasn't...
                else
                {
                    UIGraphicsBeginImageContext(image.size);
                    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    compressedImageData = UIImageJPEGRepresentation(newImage, 0.5f);
                    [compressedImageData writeToFile:filePath atomically:NO];
                    [newImage release];
                }
            }
            
            [image release];
            
            
            photo.thumb_url = fileName;    
        }
        
        
        // 날짜 저장
        
        
        // 메타데이터에 촬영날짜가 있을 경우 촬영날짜를 입력
        NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
        dateFormatter.dateFormat = @"y:MM:dd HH:mm:SS";
        
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        NSDate *date = [dateFormatter dateFromString:[[[[asset defaultRepresentation] metadata] objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"]];
        // do something
        if (!date) {
            date = [asset valueForProperty:ALAssetPropertyDate];
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *dateComponent = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) 
                                                      fromDate:date];
        NSDateComponents *monthComponent = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) 
                                                       fromDate:date];
        NSDateComponents *yearComponent = [calendar components:(NSYearCalendarUnit) 
                                                      fromDate:date];
        
        NSDate *group_date = [calendar dateFromComponents:dateComponent];
        NSDate *group_date_month = [calendar dateFromComponents:monthComponent];
        NSDate *group_date_year = [calendar dateFromComponents:yearComponent];
        
        photo.url = assetUrl;
        
        
        photo.UTI = [[asset defaultRepresentation]UTI];
        photo.type = [asset valueForProperty:ALAssetPropertyType];
        photo.date_create = date;
        photo.group_date = group_date;
//        photo.group_date_day = group_date;
        photo.group_date_month = group_date_month;
        photo.group_date_year = group_date_year;
        
        [pool release];
        
        // 타입
        if ([photo.type isEqualToString:ALAssetTypeVideo]) {
            photo.duration = [asset valueForProperty:ALAssetPropertyDuration];    
        } else if ([photo.type isEqualToString:ALAssetTypeUnknown]){
            id dur = [asset valueForProperty:ALAssetPropertyDuration];
            if ([dur isKindOfClass:[NSNumber class]]) {
                photo.duration = [asset valueForProperty:ALAssetPropertyDuration];
            }
        }
        
     
        
        // 위치 정보 저장
        
        CLLocation* loc = [asset valueForProperty:ALAssetPropertyLocation];
        
        if (loc) {
            if (!(isnan(loc.coordinate.latitude)||isnan(loc.coordinate.longitude))) {
                [photo setLocation_lat:[NSNumber numberWithDouble:loc.coordinate.latitude]];
                [photo setLocation_long:[NSNumber numberWithDouble:loc.coordinate.longitude]];
                
            } else {

                NSLog(@"no codes");

            }    
        } else {

            NSLog(@"no loc");

        }
        
        
        
        [photo setLocation_lat:[NSNumber numberWithDouble:loc.coordinate.latitude]];
        [photo setLocation_long:[NSNumber numberWithDouble:loc.coordinate.longitude]];
        
        
        photo.date = [self dateGroupCotainedPhotoModel:photo withContext:context];
        photo.month = [self monthGroupContainedPHotoModel:photo withContext:context];
        
        
        [_photos setObject:photo forKey:assetUrl];
        return photo;
    }
}

- (DateGroup*)dateGroupCotainedPhotoModel:(PhotoModel*)photo withContext:(NSManagedObjectContext*)context{
    NSDate * date = photo.group_date;
    DateGroup * group;
    @try {
        group = (DateGroup*)[context objectWithID:[[_dateGroup objectForKey:date] objectID]];
    }
    @catch (NSException *exception) {
        group = nil;
    }
    @finally {
        if (!group) {
            group = (DateGroup*)[NSEntityDescription insertNewObjectForEntityForName:@"DateGroup" inManagedObjectContext:context];    
            group.date = date;
//            NSLog(@"date: %@",date);
            group.url = photo.url;
            group.date_str = [_formatter stringFromDate:date];
            [group addPhotosObject:photo];
//            NSLog(@"date_Str: %@", group.date_str);
            [_dateGroup setObject:group forKey:date];
            return group;
        } else {
            return group;
        }    
    }
    
}


- (MonthGroup*)monthGroupContainedPHotoModel:(PhotoModel*)photo withContext:(NSManagedObjectContext*)context{
    NSDate * month = photo.group_date_month;
    
    MonthGroup * group;
    
    @try {
        group = (MonthGroup*)[context objectWithID:[[_monthGroup objectForKey:month] objectID]];    
    }
    @catch (NSException *exception) {
        group = nil;
    }
    @finally {
        if (!group) {
            group = (MonthGroup*)[NSEntityDescription insertNewObjectForEntityForName:@"MonthGroup" inManagedObjectContext:context];
            group.month = month;
            group.year = photo.group_date_year;
            group.url = photo.url;
            [group addPhotosObject:photo];
            [_monthGroup setObject:group forKey:month];
            return group;
        } else {
            return group;
        }
    }
    
}


- (void)convertDateFormateIfItdifferent{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * locale = [defaults objectForKey:@"Locale"];
 
    if (locale) {
        if (![[[NSLocale currentLocale]objectForKey:NSLocaleCountryCode] isEqualToString:locale]) {
            for(DateGroup * group in [_dateGroup allValues]){
                NSString * dateStr = [_formatter stringFromDate:group.date];
                group.date_str = dateStr;
            }
        }    
    }
    
}

- (void) removeEmptyPhotoAndGroup{
    

        
    // collect not existing data and remove
    
    int i = 0;
    int total = 0;
    
    
    NSFileManager * fManager = [NSFileManager defaultManager];
    NSError *err=nil;
    
//    for(NSSet * set in [_urlsGroup allValues]){
//        i = 0;
//        total = [set count];
//        
//        for(NSString* str in [set allObjects]){
//            PhotoModel * photo = [_photosDB objectForKey:str];
//            
//            if ([fManager fileExistsAtPath:photo.thumb_url]) {
//                [fManager removeItemAtPath:photo.thumb_url error:&err]; 
//                if (err) {
//                    NSLog(@"rmv error : %@",err);
//                }    
//            }
//            
//            [photo removeGroup:photo.group];
//            [photo.month removePhotosObject:photo];
//            [photo.date removePhotosObject:photo];
//            photo.month = nil;
//            photo.date = nil;
//            
//            NSError *err;
//            if ([photo validateForDelete:&err])
//                [_context deleteObject:photo];
//            else NSLog(@"error : %@",err);
//            
//            i++;
//            [self updateProgressWithValues:i totalCnt:total withTitle:@"Syncing"];
//        }
//    }
//    
//    
    total = [_deletablePhotos count];
    for (NSString * str  in _deletablePhotos){
        PhotoModel * photo = [_photosDB objectForKey:str];
        
        if ([fManager fileExistsAtPath:photo.thumb_url]) {
            [fManager removeItemAtPath:photo.thumb_url error:&err]; 
            if (err) {
                NSLog(@"rmv error : %@",err);
            }    
        }
        
        [photo removeGroup:photo.group];
        [photo.month removePhotosObject:photo];
        [photo.date removePhotosObject:photo];
        photo.month = nil;
        photo.date = nil;
        
        NSError *err;
        if ([photo validateForDelete:&err])
            [_context deleteObject:photo];
        else NSLog(@"error : %@",err);
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Syncing"];
    }
    
    
    i = 0;
    total = [[_groupsDB allValues]count];
    
    for(PhotoGroup * group in [_groupsDB allValues]){
        NSLog(@"떨거지 그룹: %@",group);
        
        [group removePhotos:group.photos];
        
        NSError * err;
        if ([group validateForDelete:&err]) {
            [_context deleteObject:group];      
        } else {
            NSLog(@"delete error: %@",err);
        }
        
        
        
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Syncing"];
    }
    
    
    i = 0;
    total = [[_dateGroup allValues]count];
    for(DateGroup * group in [_dateGroup allValues]){
        if ([group.photos count]<1) {
            [_context deleteObject:group];
        }
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Syncing"];
    }
    
    i = 0;
    total = [[_monthGroup allValues]count];
    for(MonthGroup * group in [_monthGroup allValues]){
        if ([group.photos count]<1) {
            [_context deleteObject:group];
        }
        
        i++;
        [self updateProgressWithValues:i totalCnt:total withTitle:@"Syncing"];
    }
    
}


- (void)successLoading {

    NSLog(@"successLoading");
    [_activity stopAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 버전 저장
    SET_APP_VERSION(APP_VERSION);
    
    // 지역설정저장
    NSString* locale = [[NSLocale currentLocale]objectForKey:NSLocaleCountryCode];
    [defaults setObject:locale forKey:@"Locale"];
    [defaults setBool:NO forKey:@"ZERO_PHOTO"];
    [defaults setBool:YES forKey:kHasDataLoaded];
    [defaults synchronize];
    
    
    [_delegate didFinishedLoading];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];

}



- (void) insertContextFinished{
    dispatch_async(dispatch_get_main_queue(), ^{
       [self successLoading];
    });     
    
}

- (void)failedLoading{
    [_delegate didFinishedLoading];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];

}


@end

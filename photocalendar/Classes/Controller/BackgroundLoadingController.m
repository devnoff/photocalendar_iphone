//
//  BackgroundLoadingController.m
//  photocalendar
//
//  Created by Park Yongnam on 12. 1. 10..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "BackgroundLoadingController.h"
#import "PhotoModel.h"
#import "PhotoGroup.h"
#import "MonthGroup.h"
#import "DateGroup.h"
#import "RequestController.h"
#import "AppDelegate.h"
#import <ImageIO/ImageIO.h>


@interface BackgroundLoadingController()

// 초기화
- (void)initialize;

- (void)checkingVersion;

- (void)removeCurrentCacheAndDB;

- (void)removePreviousCacheAndDB;

- (BOOL)createNewCacheDirectory;
//
//- (void)createNewDBFile;
//
//- (void)resetCoreData;

- (void)loadHiddenGroup;

- (BOOL)validateLoadGroup:(NSString*)groupID withType:(NSInteger)type;

- (void)startLoading;

- (void)computeWithValidCountOfAsset;

- (void)collectDataFromDB;

- (void)collectDataFromAssetsLibrary;

- (PhotoModel *)createPhotoEntityIfNotExistWithAsset:(ALAsset*)asset inCurrentContext:(NSManagedObjectContext*)context;

- (DateGroup *)dateGroupCotainedPhotoModel:(PhotoModel*)photo withContext:(NSManagedObjectContext*)context;

- (MonthGroup *)monthGroupContainedPHotoModel:(PhotoModel*)photo withContext:(NSManagedObjectContext*)context;

- (void)convertDateFormateIfItdifferent;

- (void) removeEmptyPhotoAndGroup;

- (void) insertContextFinished;

- (void)successLoading;

- (void)failedLoading;

- (void)failedLoadingCauseNoPhoto;

- (void)updateUIprogressValue:(int)current total:(int)total title:(NSString *)title;
@end

@implementation BackgroundLoadingController
@synthesize delegate = _delegate;


#pragma mark - 0.초기화
/* 
 * 초기화 
 */

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
        
    _deletablePhotos = [[NSMutableSet alloc] init];
    
    
    collectQueue = dispatch_queue_create("collectQueue", NULL);
    
    dispatch_async(collectQueue, ^{
        [self checkingVersion];  
    });
    
    
}




#pragma mark - 1.메모리 관리
/* 
 * 메모리 관리
 */
- (void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_assetsLibrary release];
    [_monthGroup release];
    [_dateGroup release];
    [_formatter release];
    [_photos release];
    [_hiddenGroup release];
    [_photosDB release];
    [_groupsDB release];
    [_groupDBKeys release];
    [_photosDBKeys release];
    [_context release];
    [_deletablePhotos release];
    if (collectQueue) {
        dispatch_release(collectQueue);    
    }
    
    [super dealloc];
}


#pragma mark - 2.버전 체크
/* 
 * 버전 채크 : 1.5 버전 이전의 데이터는 새로운 DB와 이미지 캐시가 생성된 후에 백그라운드에서 삭제가 진행됨
 *
 * 1. 1.5 미만일 경우 
 *      - 새로운 캐시 디렉토리 생성
 *      - 새로운 DB 파일 생성
 *      - 데이터 로드
 *      - AppDelegate CoreData 리셋 : Sqlite 파일 경로 User Default 이용
 *      - 이전 버전 캐시 및 DB 삭제
 * 2. 1.5 이상일 경우 - 
 *      - 데이터 로드
 *
 */ 

- (void)checkingVersion{
    
    NSPersistentStoreCoordinator * coord = nil;
    // 앱버전이 1.5이하 이거나 앱버전이 없을 경우
    if(APP_VERSION_LESS_THAN(@"1.5")||!GET_APP_VERSION){
        [self createNewCacheDirectory];
        
         coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] newPersistentStoreCoordinatorWithName:PHOTOCAL_DB_NAME_FOR_UPPER_V15];
        
        _removingPrevData = YES;
    } else {
        coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
    }
    
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:coord];
    
    [self startLoading];
}


#pragma mark - 3.1.현재버전의 이미지 캐시 및 DB 삭제
/* 
 * 현재 버전의 이미지 캐시 및 DB 삭제 : 
 * 1. 설정에서 선택한 그룹이 없거나
 * 2. 폰에 사진이 하나도 없을 경우 
 */

- (void)removeCurrentCacheAndDB{
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    
    // 섬네일 이미지 삭제 from 1.4
    NSError * err;
    NSString *docsDir = PHOTO_CACHE_FORLDER_FOR_UPPER_V15;
    if ([localFileManager removeItemAtPath:docsDir error:&err]) {
        NSLog(@"success removing cache images");
    } else {
        NSLog(@"failed removing cache images : %@", err);
    }
    
    [localFileManager release];
    
    
    // 데이터베이스 삭제
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app releasePersistantStoreCoordinator];
}

#pragma mark - 3.2.이전버전의 이미지 캐시 및 DB 삭제
/* 
 * 이전 버전의 이미지 캐시 및 DB 삭제 : 
 * 1. 버전 체크 후 새로운 데이터가 로두된 후
 */

- (void)removePreviousCacheAndDB{
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
        
    // 섬네일 이미지 삭제 from 1.4
    NSError * err;
    docsDir = PHOTO_CACHE_FOLDER;
    if ([localFileManager removeItemAtPath:docsDir error:&err]) {
        NSLog(@"success removing cache images");
    } else {
        NSLog(@"failed removing cache images : %@", err);
    }
    
    [localFileManager release];
    
    
    // 데이터베이스 삭제
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![app releasePersistantStoreCoordinator]){
        [self failedLoading];
    }
    
}
 

#pragma mark - 5.새로운 캐시 디렉토리 생성
/* 
 * 새로운 캐시 디렉토리 생성 : 
 * 캐시디렉토리는 PHOTO_CACHE_FORLDER_FOR_UPPER_V15 의 매크로로 생성
 */ 

- (BOOL)createNewCacheDirectory{
    // 이미지 캐시 디랙토리 생성
    BOOL isDir;
    NSFileManager * fManager = [NSFileManager defaultManager]; 
    if(!([fManager fileExistsAtPath:PHOTO_CACHE_FORLDER_FOR_UPPER_V15 isDirectory:&isDir]&&isDir)){
        if ([fManager createDirectoryAtPath:PHOTO_CACHE_FORLDER_FOR_UPPER_V15 withIntermediateDirectories:YES attributes:nil error:nil]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}



#pragma mark - 6.새로운 DB 파일 생성
/* 
 * 새로운 DB 파일 생성 :
 * 새로운 DB 파일명은 PHOTOCAL_DB_FOR_UPPER_V15 의 매크로로 생성
 */

//- (void)createNewDBFile{
//    
//}


#pragma mark - 7.코어데이터 리셋
/* 
 * 코어데이터를 새로이 로드한 캐디와 DB로 대체
 * 
 */

//- (void)resetCoreData{
//    
//}



#pragma mark - 8.데이터 로드
/* 
 * 데이터 로드 : DB의 데이터와 AssetLibrary 를 비교하여 데이터 로드
 * 1. Asset 숫자를 먼저 가져와서 사진이 없을 경우 현재버전의 캐시와 DB 삭제
 * 2. 사진이 있을 경우 DB에서 데이터 수집 후 AssetLibrary 수집
 */

- (void)startLoading{
    [self loadHiddenGroup];
    [self computeWithValidCountOfAsset];
}


#pragma mark - a. 숨김그룹 로드
/*
 * 숨김그룹 미리로드
 */

- (void)loadHiddenGroup{
    
    _hiddenGroup = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:HIDDEN_GROUP_PLIST]){
        _hiddenGroup = [[NSSet alloc]initWithArray:[NSArray arrayWithContentsOfFile:HIDDEN_GROUP_PLIST]];
    } else{
        _hiddenGroup = [[NSSet alloc]init];
    }
}

#pragma mark - b. 숨김그룹 채크
/*
 * 그룹데이터 로드시 숨김그룹은 제외한다
 */

- (BOOL)validateLoadGroup:(NSString*)groupID withType:(NSInteger)type{
    if (_hiddenGroup){
        for (NSString * gId in _hiddenGroup){
            if ([gId isEqualToString:groupID]) {
                return NO;
            }
        }
    } else {
        if (type==ALAssetsGroupPhotoStream) {
            // 숨김 그룹에 포토스트르립 그룹 아이디 추가
            NSArray *arr = [[NSArray alloc] initWithObjects:groupID, nil];
            [arr writeToFile:HIDDEN_GROUP_PLIST atomically:NO];
            [arr release];
            return NO;
        }
    }
    return YES;
}



#pragma mark - 8.0.Asset숫자 수집
- (void)computeWithValidCountOfAsset{
    // 카운트 초기화
    cnt = 0;
    _curCnt = 0;
    
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock: ^(ALAssetsGroup *group, BOOL *stop){ 
                                      if (group!=nil) {
                                          if (!HAS_UPGRADED) {
                                              [group setAssetsFilter:[ALAssetsFilter allPhotos]];    
                                          } else {
                                              [group setAssetsFilter:[ALAssetsFilter allAssets]];    
                                          }
                                          
                                          NSNumber *groupType = [group valueForProperty:ALAssetsGroupPropertyType];
                                          NSString * groupId = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
                                          NSString * groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                          
                                          groupId = groupId==nil?[NSString stringWithFormat:@"%@%@",groupName,groupType]:groupId;
                                          
                                          if ([self validateLoadGroup:groupId withType:[groupType intValue]]) {
                                              cnt = cnt + [group numberOfAssets];
                                          }
                                          
                                          
                                      } else {
                                          NSLog(@"total count: %d",cnt);
                                          
                                          if (cnt<1) {
                                              // 사진이 없을 경우 현재버전의 캐시와 DB 삭제   
                                              [self removeCurrentCacheAndDB];
                                              // 로드 완료 
                                              [self failedLoadingCauseNoPhoto];
                                              
                                          } else {
                                              // 사진이 있을 경우 DB에서 데이터 수집
                                              [self collectDataFromDB];
                                              [self collectDataFromAssetsLibrary];
                                          }  
                                          
                                      }
                                  }
                                failureBlock: ^(NSError *error) {
                                    NSLog(@"failed: %@",error);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        // 에셋을 사용할 수 없을 경우 실패 화면을 띄움
                                        [_delegate backgroundLoadingDidFailedLoading];
                                    }); 
                                }];

    
}

#pragma mark - 8.1.DB데이터 불러오기
/*
 * DB데이터 불러오기 : AssetLibray 의 데이터와 비교하기 위해 메모리에 로드
 */
- (void)collectDataFromDB{
    
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
        
        [self updateUIprogressValue:i total:total title:@"Collecting.."];
        
        i++;
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
        
        [self updateUIprogressValue:i total:total title:@"Collecting.."];
        
        i++;
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
        [self updateUIprogressValue:i total:total title:@"Collecting.."];
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
        [self updateUIprogressValue:i total:total title:@"Collecting.."];
    }
    [months release];
    

}


#pragma mark - 8.2.AssetLibrary 데이터 불러오기
/*
 * AssetLibrary 데이터를 불러와서 DB 데이터와 비교하여 새로운 데이터 일 경우 레코드를 생성하여 입력
 */
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
                                          
                                          if ([self validateLoadGroup:groupId withType:[groupType integerValue]]) {
                                              
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

                                                          
                                                          _curCnt++;
                                                          
                                                          [self updateUIprogressValue:_curCnt total:cnt  title:nil];
                                                          
                                                          
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

#pragma mark - 8.2.1.사진 객체 생성
/*
 * 파라미터로 받은 에셋의 절대경로 값이 DB에 없다면 사진 객체를 새로 생성한다
 */
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



#pragma mark - 8.2.2.일자 그룹 객체 생성
/*
 * 파라미터로 받은 사진객체의 자자가 속한 날짜 그룹이 DB에 없다면 일자 그룹 객체를 새로 생성한다
 */
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


#pragma mark - 8.2.3.월 그룹 객체 생성
/*
 * 파라미터로 받은 사진객체의 날짜가 속한 월 그룹이 DB에 없다면 월 그룹 객체를 새로 생성한다
 */
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



#pragma mark - 8.2.4.일자 그룹 날짜 포멧 변경
/*
 * 일자 그룹의 날짜 포멧은 상세 보기 섹션바에 이용되는데 사용자의 지역 설정에 맞게 포멧을 변경한다
 */
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

#pragma mark - 8.2.5.빈 그룹 삭제
/*
 * DB와 AssetLibrary 를 비교하여 AssetLibrary 에 더이상 존재하지 않는 객체가 DB에 존재할 경우 이를 제거해줌
 */
- (void)removeEmptyPhotoAndGroup{
    
    
    
    // collect not existing data and remove
    
    int i = 0;
    int total = 0;
    
    
    NSFileManager * fManager = [NSFileManager defaultManager];
    NSError *err=nil;
    
  
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
        [self updateUIprogressValue:i total:total title:@"Syncing.."];
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
        [self updateUIprogressValue:i total:total title:@"Syncing.."];
    }
    
    
    i = 0;
    total = [[_dateGroup allValues]count];
    for(DateGroup * group in [_dateGroup allValues]){
        if ([group.photos count]<1) {
            [_context deleteObject:group];
        }
        
        i++;
        [self updateUIprogressValue:i total:total title:@"Syncing.."];
    }
    
    i = 0;
    total = [[_monthGroup allValues]count];
    for(MonthGroup * group in [_monthGroup allValues]){
        if ([group.photos count]<1) {
            [_context deleteObject:group];
        }
        
        i++;
        [self updateUIprogressValue:i total:total title:@"Syncing.."];
    }
    
}


#pragma mark - 9.로드 완료
- (void) insertContextFinished{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self successLoading];
    });   
}

#pragma mark - 10.로딩 성공
- (void)successLoading{
    //  지난 데이터 삭제 플레그가 있을 경우 DB파일명 변경 
    if (_removingPrevData) {
//        [self removePreviousCacheAndDB];
        SET_DB_FILE_NAME(PHOTOCAL_DB_NAME_FOR_UPPER_V15);       
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 버전 저장
    SET_APP_VERSION(APP_VERSION);
    
    // 지역설정저장
    NSString* locale = [[NSLocale currentLocale]objectForKey:NSLocaleCountryCode];
    [defaults setObject:locale forKey:@"Locale"];
    [defaults setBool:NO forKey:@"ZERO_PHOTO"];
    [defaults setBool:YES forKey:kHasDataLoaded];
    [defaults synchronize];
    
    
    [_delegate backgroundLoadingDidFinishedLoadingWithAssetsLibrary:_assetsLibrary];
    
}

#pragma mark - 11.로딩 실패
- (void)failedLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate backgroundLoadingDidFinishedLoadingWithAssetsLibrary:_assetsLibrary];
    });     
    
}
                      
#pragma mark - 12.사진 없음
- (void)failedLoadingCauseNoPhoto{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate backgroundLoadingDidFinishLoadindWithNoPhoto];
    }); 
    
}


#pragma mark - 13.UI Update
- (void)updateUIprogressValue:(int)current total:(int)total title:(NSString *)title{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_delegate backgroundLoadingUpdateUIProcessingValue:current total:total title:title];
//    }); 

    [_delegate backgroundLoadingUpdateUIProcessingValue:current total:total title:title];
    
}

@end

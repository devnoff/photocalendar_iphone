//
//  BackgroundLoadingController.h
//  photocalendar
//
//  Created by Park Yongnam on 12. 1. 10..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@protocol BackgroundLoadingControllerDelegate;
@interface BackgroundLoadingController : NSObject{
    id <BackgroundLoadingControllerDelegate> _delegate;
    
    // 카운트 
    int cnt; // 전체 asset 합계
    int _curCnt; // 현재 진행중인 카운드
    
    // 에셋 라이브러리
    ALAssetsLibrary * _assetsLibrary;
    
    // 비교를 위해 할당된 메모리 객체
    NSMutableDictionary * _monthGroup;
    NSMutableDictionary * _dateGroup;
    NSMutableDictionary * _photos;
    
    // 날짜 포메터
    NSDateFormatter * _formatter;
    
    // 선택된 그룹
    NSSet * _hiddenGroup;
    
    // DB 데이터를 로드한 메모리 객체
    NSMutableDictionary * _groupsDB;
    NSMutableDictionary * _photosDB;
    NSSet * _groupDBKeys;
    NSSet * _photosDBKeys;
    
    
    // 콘텍스트
    NSManagedObjectContext * _context;
    
    // GCD 객체
    dispatch_queue_t collectQueue;
    
    // 삭제할 사진들
    NSMutableSet *_deletablePhotos;
    
    // UI업데이트 스레드 스위치
    BOOL _workingProgress;
    
    // 지난 데이터 삭제 플레그
    BOOL _removingPrevData;

}

@property (nonatomic, assign) id<BackgroundLoadingControllerDelegate> delegate;

@end

@protocol BackgroundLoadingControllerDelegate <NSObject>
- (void) backgroundLoadingDidFinishedLoadingWithAssetsLibrary:(ALAssetsLibrary *)library;
- (void) backgroundLoadingDidFailedLoading;
- (void) backgroundLoadingDidFinishLoadindWithNoPhoto;
- (void) backgroundLoadingUpdateUIProcessingValue:(int)current total:(int)total title:(NSString*)title;
@end

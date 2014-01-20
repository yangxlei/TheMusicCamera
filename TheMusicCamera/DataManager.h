//
//  DataManager.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTTabBarController.h"

@class Music;

@interface DataManager : NSObject
{
    
}

@property (nonatomic, strong) GTTabBarController *mainTabBarController;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *downloadPath;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSMutableArray *musicList;
@property (strong, nonatomic) NSMutableArray *recordMusicList;
@property (strong, nonatomic) UIImage *shareImg;

@property (readwrite) BOOL isPhotoView;
@property (readwrite) int fromNo;

- (int)getMusicId;
- (void) getLoadMusicList;
- (void) getLoadRecordMusicList;
- (void) insertMusicInfo:(Music*)music;
- (void) updateMusicInfo:(Music*)music;
- (void)deleteMusicWithID:(int)musicID;
- (void)deleteMusicWithName:(NSString *)musicName;
- (int)selectMusicDate;
- (NSString *)selectMusicWithID:(int)musicID;

+ (DataManager *) sharedManager;

@end

@interface UIViewController (UIViewControllerCategory)


- (void)navgationImage:(NSString *)imageName;
- (UIButton *)navgationButton:(NSString *)buttonImage andFrame:(CGRect)rect;


@end

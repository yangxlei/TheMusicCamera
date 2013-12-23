//
//  DBAccress.h
//  iELearning
//
//  Created by MAC on 12/06/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class DataManager;
@class Music;

@interface DBAccress : NSObject
{
    FMDatabase *db;
    DataManager *dataManager;
}


- (void) getLoadMusicList:(NSMutableArray*)list;
- (void) getLoadRecordMusicList:(NSMutableArray*)list;
- (void) insertMusicInfo:(Music*)music;
- (void)deleteMusicWithID:(int)musicID;
- (void)deleteMusicWithName:(NSString *)musicName;

/////////////////////////////////////////////

- (int)getMusicId;

@end

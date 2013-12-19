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

@interface DBAccress : NSObject
{
    FMDatabase *db;
    DataManager *dataManager;
}


- (void) getLoadMusicList:(NSMutableArray*)list;

/////////////////////////////////////////////

- (int)getMusicId;

@end

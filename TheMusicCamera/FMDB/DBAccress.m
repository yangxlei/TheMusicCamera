//
//  DBAccress.m
//  iELearning
//
//  Created by MAC on 12/06/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBAccress.h"
#import "FMDatabase.h"
#import "DataManager.h"

@implementation DBAccress


-(id) init
{
	self = [super init];
	
	if (self){	
        dataManager=[DataManager sharedManager];
        db = [FMDatabase databaseWithPath:dataManager.databasePath];
	}
	
	return self;
}

- (void)openDatabase 
{
    [db open];
}

- (void)closeDatabase {
    if (db) {
        [db close];
    }
}

- (int)getMusicId
{
    int musicId = 0;
    
    [self openDatabase];
    
    FMResultSet *rs = [db executeQuery:@"select max(id) from musicList"];
    
    while ([rs next]) {
        musicId = [rs intForColumnIndex:0];
    }
    
    [self closeDatabase];
    
    return musicId + 1;
}

@end

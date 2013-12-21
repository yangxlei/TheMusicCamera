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
#import "Music.h"

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

- (void) getLoadMusicList:(NSMutableArray*)list
{
    [self openDatabase];
    
    FMResultSet *rs = [db executeQuery:@"select id,name,path from musicList "];
    
    while ([rs next]) {
        Music *music = [[Music alloc] init];
        
        music.ID= [rs intForColumnIndex:0];
        music.name= [rs stringForColumnIndex:1];
        music.path= [rs stringForColumnIndex:2];

        [list addObject:music];
    }
    
    [self closeDatabase];
}

- (void) insertCourseInfo:(NSMutableArray*)list
{
    [self openDatabase];
    [db beginTransaction];
    
    BOOL isSucceeded = YES;
    
    NSString *sql = @"insert into musicList ("
    "id,"
    "path,"
    "name)"
    "VALUES (?,?,?)";
    
    for(Music *music in list )
    {
        if( ![db executeUpdate:sql,
              [NSNumber numberWithInteger:music.ID],
              music.name,
              music.path
              ])
        {
            isSucceeded = NO;
            break;
        }
    }
        
    if( isSucceeded )
    {
        [db commit];
    }
    else
    {
        [db rollback];
    }
    
    [self closeDatabase];
    
}

@end

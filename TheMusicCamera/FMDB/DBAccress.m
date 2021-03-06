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

- (void) getLoadRecordMusicList:(NSMutableArray*)list
{
    [self openDatabase];
    
    FMResultSet *rs = [db executeQuery:@"select id,name,path,defaultValue from musicList where defaultValue=0"];
    
    while ([rs next]) {
        Music *music = [[Music alloc] init];
        
        music.ID= [rs intForColumnIndex:0];
        music.name= [rs stringForColumnIndex:1];
        music.path= [rs stringForColumnIndex:2];
        
        [list addObject:music];
    }
    
    [self closeDatabase];

}

- (void) insertMusicInfo:(Music*)music
{
    [self openDatabase];
    
    int musicId = 0;
    
    FMResultSet *rs = [db executeQuery:@"select max(id) from musicList"];
    
    while ([rs next]) {
        musicId = [rs intForColumnIndex:0];
    }
    
    if(![db executeUpdate:@"insert into musicList(id,path,name,defaultValue ) values(?,?,?,0)",[NSNumber numberWithInteger:musicId+1],music.path,music.name]) {
        
    }
    
    [self closeDatabase];
    
}

- (void) updateMusicInfo:(Music*)music
{
    [self openDatabase];
    
    int musicId = 0;
    
    FMResultSet *rs = [db executeQuery:@"select max(id) from musicList"];
    
    while ([rs next]) {
        musicId = [rs intForColumnIndex:0];
    }
    
    if(![db executeUpdate:@"update musicList set path =?,name =?,defaultValue =0 where item = 'datainfo_update_time'",music.path,music.name]) {
        
    }
    
    [self closeDatabase];
}

- (void)deleteMusicWithID:(int)musicID
{
    [self openDatabase];
    NSString *sql = [NSString stringWithFormat:@"delete from musicList where id=%d",musicID];
    
    FMResultSet *rs = [db executeQuery:sql];
    
    while ([rs next]) {
        
    }
    
    [self closeDatabase];
}

- (NSString *)selectMusicWithID:(int)musicID
{
    [self openDatabase];
    NSString *sql = [NSString stringWithFormat:@"select path from musicList where id=%d",musicID];
    
    NSString *name ;
    FMResultSet *rs = [db executeQuery:sql];
    
    while ([rs next]) {
        name = [rs stringForColumnIndex:0];
    }
    
    [self closeDatabase];
    return name;
}

- (void)deleteMusicWithName:(NSString *)musicName
{
    [self openDatabase];
    NSString *sql = [NSString stringWithFormat:@"delete from musicList where name=%@",musicName];
    
    FMResultSet *rs = [db executeQuery:sql];
    
    while ([rs next]) {
        
    }
    
    [self closeDatabase];

}

- (int)selectMusicDate
{
    [self openDatabase];
    
    int num=1;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];

    NSString *sql = [NSString stringWithFormat:@"select id,name,path,defaultValue from musicList where name like '%@%%'",dateString];

    FMResultSet *rs = [db executeQuery:sql];
    
    while ([rs next]) {
        num++;
    }
    
    [self closeDatabase];
    
    return num;
}

@end

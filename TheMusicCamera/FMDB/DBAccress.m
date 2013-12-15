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


@end

//
//  DataManager.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager



-(id) init{
	self = [super init];
	
	if (self){

        
    }
	return self;
}


//////////////////////////////////////////////////////////////////////////
static DataManager *sharedDataManager = nil;

+ (DataManager *) sharedManager
{
    @synchronized(self)
	{
        if (sharedDataManager == nil)
		{
            return [[self alloc] init];
        }
    }
	
    return sharedDataManager;
}

+(id)alloc
{
	@synchronized(self)
	{
		NSAssert(sharedDataManager == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedDataManager = [super alloc];
		return sharedDataManager;
	}
	return nil;
}


@end

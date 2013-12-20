//
//  Music.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-18.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject

@property (readwrite) int ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *path;

@end

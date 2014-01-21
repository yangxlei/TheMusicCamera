//
//  nibLoader.m
//  answer
//
//  Created by HaiJiao Chen on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "nibLoader.h"

@implementation nibLoader
@synthesize obj;

+(id)load:(NSString*)nib params:(id)params
{
    nibLoader* load = [[nibLoader alloc] init];
    NSBundle* main = [NSBundle mainBundle];
    [main loadNibNamed:nib owner:load options:nil];
    id ret = [[load.obj retain] autorelease];
    [load release];
    if ([ret respondsToSelector:@selector(viewLoadFromNib:)])
    {
        [ret performSelector:@selector(viewLoadFromNib:) withObject:params];
    }
    return ret;
}
- (void)dealloc
{
    [obj release];
    [super dealloc];
}
@end

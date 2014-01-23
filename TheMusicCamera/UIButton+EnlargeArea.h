//
//  UIButton+EnlargeArea.h
//  TheMusicCamera
//
//  Created by song on 14-1-22.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(EnlargeArea)

- (void) setEnlargeEdge:(CGFloat) edge;

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
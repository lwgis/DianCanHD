//
//  CellView.m
//  DianCanHD
//
//  Created by 李炜 on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CellView.h"

@implementation CellView
@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor]; 
    }
    return self;
}
-(void)setImage:(UIImage *)image{
    if (self.imageView==nil) {
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:iv];
        [self setImageView:iv];     
        [iv release];
    }
    [self.imageView setImage:image];
}
-(void)releaseImage{
    [self.imageView setImage:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  RecipePageView.m
//  DianCanHD
//
//  Created by 李炜 on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipePageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation RecipePageView
@synthesize listRecipe,fullImageView,leftImageView,rightImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
- (UIImage *) imageByRenderingView:(UIView *)aView {
    UIGraphicsBeginImageContext(aView.frame.size);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];   
    UIImage *parentImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return parentImage;
}
- (UIImage *) imageByRenderingView:(UIView *)aView  isLeft:(BOOL)left{
    //    return [UIImage imageNamed:@"photo.jpeg"];
    CGSize size=CGSizeMake(aView.frame.size.width/2, aView.frame.size.height);
    CGFloat width=size.width;
    if (left) {
        width=0;
    }
    CGRect myImageRect=CGRectMake(width,0 , size.width, size.height);    
    UIImage* bigImage= [self imageByRenderingView:aView];
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
	return smallImage ;
}

-(void)bindFirstRecipe:(Recipe *)firstRecipe secondRecipe:(Recipe *)secondRecipe thirdRecipe:(Recipe *)thirdRecipe{
    self.listRecipe=[[NSMutableArray alloc] init];
    [self.listRecipe addObject:firstRecipe];
    [self.listRecipe addObject:secondRecipe];
    [self.listRecipe addObject:thirdRecipe];
//    UIImage *image=[UIImage imageNamed:@"111.jpg"];
    UIImageView *firstView=[[UIImageView alloc] initWithFrame:CGRectMake(24, 74, 670, 451)];
//    firstView.backgroundColor=[UIColor orangeColor];
    [firstView setImage:firstRecipe.image.image];
    [firstView setTag:0];
    [self addSubview:firstView];
    [firstView release];
    UIImageView *secondView=[[UIImageView alloc] initWithFrame:CGRectMake(24, 549, 322, 451)];
    [secondView setImage:secondRecipe.image.image];

    [secondView setTag:1];
    [self addSubview:secondView];
    [secondView release];
    UIImageView *thirdView=[[UIImageView alloc] initWithFrame:CGRectMake(370, 549, 322, 451)];
    [thirdView setImage:thirdRecipe.image.image];

    [thirdView setTag:2];
    [self addSubview:thirdView];
    [thirdView release];
    self.fullImageView=[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.fullImageView setImage:[self imageByRenderingView:self]];
    self.leftImageView=[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    [self.leftImageView setImage:[self imageByRenderingView:self isLeft:YES]];
    self.rightImageView=[[CellView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    [self.rightImageView setImage:[self imageByRenderingView:self isLeft:NO]];

}
-(void)dealloc{
    [self.listRecipe removeAllObjects];
    [listRecipe release];
    [fullImageView release];
    [leftImageView release];
    [rightImageView release];
    [super dealloc];
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

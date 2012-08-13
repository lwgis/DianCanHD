//
//  RecipePageView.m
//  DianCanHD
//
//  Created by 李炜 on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipePageView.h"
#import "RecipeCellView.h"
#import <QuartzCore/QuartzCore.h>
@implementation RecipePageView
@synthesize listRecipe,fullImageView,leftImageView,rightImageView,numLable,fullImage,leftImage,rightImage,isInitFlip;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        UILabel *aLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:aLable];
        [self setNumLable:aLable];
        [aLable release];
        if (self.fullImageView==nil&&self.leftImageView==nil&&self.rightImageView==nil) {
            self.fullImageView=[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.fullImageView.backgroundColor=[UIColor whiteColor];
            //            [self.fullImageView setImage:[UIImage imageNamed:@"white.jpg"]];
            //    [self.fullImageView setImage:[self imageByRenderingView:self]];
            self.leftImageView=[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
            self.leftImageView.backgroundColor=[UIColor whiteColor];
            //            [self.leftImageView setImage:[UIImage imageNamed:@"white.jpg"]];
            //    [self.leftImageView setImage:[self imageByRenderingView:self isLeft:YES]];
            self.rightImageView=[[CellView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
            self.rightImageView.backgroundColor=[UIColor whiteColor];
            //            [self.rightImageView setImage:[UIImage imageNamed:@"white.jpg"]];
            //    [self.rightImageView setImage:[self imageByRenderingView:self isLeft:NO]];
            [self loadImage];
        }
    }
    isInitFlip=NO;
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

-(void)setAllImage{
    @try {
        [self.leftImageView setImage:[self imageByRenderingView:self isLeft:YES]];
        [self.rightImageView setImage:[self imageByRenderingView:self isLeft:NO]];
        [self.fullImageView setImage:[self imageByRenderingView:self]];
        self.fullImageView.backgroundColor=[UIColor blackColor];
        self.leftImageView.backgroundColor=[UIColor blackColor];
        self.rightImageView.backgroundColor=[UIColor blackColor];
        isInitFlip=YES;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    @finally {
//        self.fullImageView.backgroundColor=[UIColor blackColor];
//        self.leftImageView.backgroundColor=[UIColor blackColor];
//        self.rightImageView.backgroundColor=[UIColor blackColor];
    }
  
}

- (void)initFlip {
    @try {
        if (!self.isInitFlip) {
//            [self.fullImageView setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
//            [self.leftImageView setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
//            [self.rightImageView setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
//            [NSThread detachNewThreadSelector:@selector(setAllImage) toTarget:self withObject:nil];
            [self setAllImage];

        }
    }
    @catch (NSException *exception) {    
        NSLog(@"%@",exception.reason);
    }
    @finally {        
    }  
//        [self setAllImage];
 }
- (void)initTurnFlip {
    @try {
        if (!self.isInitFlip) {
//            [self.fullImageView setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
//            [self.leftImageView setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
//            [self.rightImageView setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
            [self setAllImage];
        }
    }
    @catch (NSException *exception) {    
        NSLog(@"%@",exception.reason);
    }
    @finally {        
    }  
}

-(void)removeFlip{
//    if (self.fullImageView!=nil&&self.leftImageView!=nil&&self.rightImageView!=nil) {
//    [fullImageView.imageView removeFromSuperview];
//    [leftImageView.imageView removeFromSuperview];
//    [rightImageView.imageView removeFromSuperview];
//    [fullImageView release];
//    [leftImageView release];
//    [rightImageView release];
//    self.fullImageView=nil;
//    self.leftImageView=nil;
//    self.rightImageView=nil;
//        [self.fullImageView.imageView.image release];
//        [self.rightImageView.imageView.image release];
//        [self.leftImageView.imageView.image release];
        [self.fullImageView releaseImage];
        [self.rightImageView releaseImage];
        [self.leftImageView releaseImage];
        [self removeImage];
        isInitFlip=NO;
//    }
}
-(void)bindFirstRecipe:(Recipe *)firstRecipe secondRecipe:(Recipe *)secondRecipe thirdRecipe:(Recipe *)thirdRecipe{
    self.listRecipe=[[NSMutableArray alloc] init];
    [self.listRecipe addObject:firstRecipe];
    [self.listRecipe addObject:secondRecipe];
    [self.listRecipe addObject:thirdRecipe];
    RecipeCellView *firstView=[[RecipeCellView alloc] initWithFrame:CGRectMake(24, 10, 670, 451)];
    [firstView setRecipe:firstRecipe textSize:30];
    [self addSubview:firstView];
    [firstView release];
    RecipeCellView *secondView=[[RecipeCellView alloc] initWithFrame:CGRectMake(24, 549-70, 322, 451)];
    [secondView setRecipe:secondRecipe textSize:24];
    [self addSubview:secondView];
    [secondView release];
    RecipeCellView *thirdView=[[RecipeCellView alloc] initWithFrame:CGRectMake(370, 549-70, 322, 451)];
    [thirdView setRecipe:thirdRecipe textSize:24];
    [self addSubview:thirdView];
    [thirdView release];
}
-(void)bindFirstRecipe:(Recipe *)firstRecipe secondRecipe:(Recipe *)secondRecipe thirdRecipe:(Recipe *)thirdRecipe fourthRecipe:(Recipe *)fourthRecipe{
    self.listRecipe=[[NSMutableArray alloc] init];
    [self.listRecipe addObject:firstRecipe];
    [self.listRecipe addObject:secondRecipe];
    [self.listRecipe addObject:thirdRecipe];
    [self.listRecipe addObject:fourthRecipe];
    CGFloat width=350;
    RecipeCellView *firstView=[[RecipeCellView alloc] initWithFrame:CGRectMake(20, 10, width, width*2/3)];
    [firstView setRecipe:firstRecipe textSize:24];
    [self addSubview:firstView];
    [firstView release];
    RecipeCellView *secondView=[[RecipeCellView alloc] initWithFrame:CGRectMake(20, 10+width*2/3+10, width, width*2/3)];
    [secondView setRecipe:secondRecipe textSize:24];
    [self addSubview:secondView];
    [secondView release];
    RecipeCellView *thirdView=[[RecipeCellView alloc] initWithFrame:CGRectMake(20, 0+2*width*2/3+2*10+10, 650+40, 650*2/3)];
    [thirdView setRecipe:thirdRecipe textSize:30];
    [self addSubview:thirdView];
    [thirdView release];
    RecipeCellView *fourthView=[[RecipeCellView alloc] initWithFrame:CGRectMake(width+10+20, 10, 330, 350+125)];
    [fourthView setRecipe:fourthRecipe textSize:24];
    [self addSubview:fourthView];
    [fourthView release];
}

-(void)loadImage{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[RecipeCellView class]]) {
            RecipeCellView *rcView=(RecipeCellView *)view;
            [rcView loadImage];
        }
    }
}
-(void)removeImage{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[RecipeCellView class]]) {
            RecipeCellView *rcView=(RecipeCellView *)view;
            [rcView removeImage];
        }
    }
    isInitFlip=NO;
//    [fullImage release];
//    [leftImage release ];
//    [rightImage release ];
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

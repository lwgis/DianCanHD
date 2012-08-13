//
//  RecipeCellView.m
//  DianCanHD
//
//  Created by 李炜 on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecipeCellView.h"
#import "RecipeImage.h"
#import <QuartzCore/QuartzCore.h>
@implementation RecipeCellView
@synthesize recipe,imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self setImageView:iv];
        [self addSubview:iv];
        [iv release];
    }
    return self;
}
-(void)setRecipe:(Recipe *)aRecipe textSize:(CGFloat)size{
    [self setRecipe:aRecipe];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font=[UIFont fontWithName:label.font.fontName size:size];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    NSString *text=[NSString stringWithFormat:@"%@  ￥%@.00",aRecipe.rName ,[aRecipe.rPrice stringValue]];
    [label setText:text];
    [label sizeToFit];
    CGFloat x=imageView.frame.size.width/2-label.frame.size.width/2;
    [label setFrame:CGRectMake(x, 0, label.frame.size.width, label.frame.size.height)];
    UIImageView *imageViewBackgroud=[[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height)];
    imageViewBackgroud.backgroundColor=[UIColor clearColor];
    [imageViewBackgroud setImage:[UIImage imageNamed:@"backgroud.png"]];
    [self addSubview:imageViewBackgroud];
    [self addSubview:label];
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(imageView.frame.size.width-50, imageView.frame.size.height-50, 40, 40)];
    [self addSubview:addButton];
    UIButton *removeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [removeButton setImage:[UIImage imageNamed:@"removeButton.png"] forState:UIControlStateNormal];
    [removeButton setFrame:CGRectMake(0, imageView.frame.size.height-50, 40, 40)];
    [self addSubview:removeButton];
    [label release];
    [imageViewBackgroud release];
    UILabel *lableCount=[[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width-30, 0,30, 30)];
    lableCount.layer.cornerRadius=20;
    [lableCount setTextColor:[UIColor whiteColor]];
    lableCount.textAlignment=UITextAlignmentCenter;
    [lableCount setBackgroundColor:[UIColor clearColor]];
    [lableCount setText:@"2"];
    UIImageView *iv=[[UIImageView alloc] initWithFrame:lableCount.frame];
    [iv setImage:[UIImage imageNamed:@"recipeCount.png"]];
    [self addSubview:iv];
    [iv release];
    [self addSubview:lableCount];
    [lableCount release];
}
-(void)addButtonClick{
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+50, self.frame.size.width, self.frame.size.height)];
    [iv setImage:self.imageView.image];
    [self.superview.superview.superview addSubview:iv];
    [UIView animateWithDuration:0.5 animations:^{
        iv.alpha=0.1;
        [iv setFrame:CGRectMake(768, 0, 10, 10)];
    } completion:^(BOOL finished) {
        [iv removeFromSuperview];
        [iv release];
    }];
}
-(void)loadImage{
    [self.imageView setImage:self.recipe.image.image];
}
-(void)removeImage{
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

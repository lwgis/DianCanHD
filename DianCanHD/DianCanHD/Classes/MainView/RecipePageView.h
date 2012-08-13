//
//  RecipePageView.h
//  DianCanHD
//
//  Created by 李炜 on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "RecipeImage.h"
#import "CellView.h"
@interface RecipePageView : UIView
@property(nonatomic,retain)NSMutableArray *listRecipe;
@property(nonatomic,retain)UIImage *fullImage;
@property(nonatomic,retain)UIImage *leftImage;
@property(nonatomic,retain)UIImage *rightImage;
@property(nonatomic,retain)CellView *fullImageView;
@property(nonatomic,retain)CellView *leftImageView;
@property(nonatomic,retain)CellView *rightImageView;
@property(nonatomic,assign)UILabel *numLable;
@property(nonatomic,assign)BOOL isInitFlip;
- (void)initFlip;
- (void)initTurnFlip;
-(void)removeFlip;
-(void)bindFirstRecipe:(Recipe *)firstRecipe secondRecipe:(Recipe *)secondRecipe thirdRecipe:(Recipe *)thirdRecipe fourthRecipe:(Recipe *)fourthRecipe;
-(void)bindFirstRecipe:(Recipe *)firstRecipe secondRecipe:(Recipe *)secondRecipe thirdRecipe:(Recipe *)thirdRecipe;
-(void)loadImage;
-(void)removeImage;
@end

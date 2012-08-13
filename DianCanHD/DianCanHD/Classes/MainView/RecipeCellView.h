//
//  RecipeCellView.h
//  DianCanHD
//
//  Created by 李炜 on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@interface RecipeCellView : UIView
@property(nonatomic,retain)Recipe *recipe;
@property(nonatomic,assign)UIImageView *imageView;
-(void)setRecipe:(Recipe *)aRecipe textSize:(CGFloat)size;
-(void)loadImage;
-(void)removeImage;
@end

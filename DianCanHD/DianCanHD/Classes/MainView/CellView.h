//
//  CellView.h
//  DianCanHD
//
//  Created by 李炜 on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView
@property(nonatomic,assign)UIImageView *imageView;
-(void)setImage:(UIImage *)image;
-(void)releaseImage;
@end

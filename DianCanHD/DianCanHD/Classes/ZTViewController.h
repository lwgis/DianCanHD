//
//  ZTViewController.h
//  DianCanHD
//
//  Created by 李炜 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellView.h"
#import "RecipePageView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define m34_value -0.0005;
@interface ZTViewController : UIViewController<NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,assign)CellView *frontView;
@property(nonatomic,assign)CellView *blackView;
@property(nonatomic,assign)CellView *blackgroudLeft;
@property(nonatomic,assign)CellView *blackgroudRight;
@property(nonatomic,assign)RecipePageView *currentView;
@property(nonatomic,retain)UIView *groupView;
@property(nonatomic,retain)NSMutableArray *outCellViews;
@property(nonatomic,retain)UIPanGestureRecognizer *gestureRecognizer;
@property(nonatomic,retain)NSMutableArray *listRecipe;
@property(nonatomic,retain)AVAudioPlayer *player;
@property(nonatomic,retain)UIView *flipView;
@property(nonatomic,retain)NSMutableArray *listPageView;
@property(nonatomic,retain)NSMutableArray *categoryPageNum;
@property(nonatomic,assign)UIView *categoryView;
-(void)initFlip;
-(void)playTurnBookSound;
@end

//
//  ZTViewController.h
//  DianCanHD
//
//  Created by 李炜 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellView.h"
#define m34_value -0.0005;
@interface ZTViewController : UIViewController<NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain)CellView *frontView;
@property(nonatomic,retain)CellView *blackView;
@property(nonatomic,retain)CellView *blackgroudLeft;
@property(nonatomic,retain)CellView *blackgroudRight;
@property(nonatomic,assign)UIView *currentView;
@property(nonatomic,retain)UIView *groupView;
@property(nonatomic,retain)NSMutableArray *outCellViews;
@property(nonatomic,retain)UIPanGestureRecognizer *gestureRecognizer;
@property(nonatomic,retain)NSMutableArray *listRecipe;
@end

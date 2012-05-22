//
//  ZTViewController.m
//  DianCanHD
//
//  Created by 李炜 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZTViewController.h"
#import "ZTAppDelegate.h"
#import "Recipe.h"
#import "RecipeImage.h"
#import "CellView.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "RecipePageView.h"
@implementation ZTViewController
{
    BOOL touchOn;
    BOOL isFormLeft;
}
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize frontView,blackView,blackgroudLeft,blackgroudRight,gestureRecognizer,currentView,groupView,outCellViews;
@synthesize listRecipe;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view setFrame:CGRectMake(0,0, 768, 1024)];
    ZTAppDelegate *appDelegate=(ZTAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext=appDelegate.managedObjectContext;
    gestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.maximumNumberOfTouches = 1;
    gestureRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:gestureRecognizer];
    self.listRecipe=[[NSMutableArray alloc] init];
    NSInteger n=0;
    for (NSInteger i=0; i<self.fetchedResultsController.sections.count; i++) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:i];
        for (NSInteger j=0; j<[sectionInfo numberOfObjects]; j++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:i];
            Recipe *recipe=(Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
            CellView *imageView=[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [imageView.imageView setFrame:CGRectMake(25, 25, self.view.frame.size.width-50, self.view.frame.size.height-50)];
            [imageView setTag:n];
            [imageView setImage:recipe.image.image];
            UILabel *labelName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 25)];
            labelName.textAlignment=UITextAlignmentCenter;
            [labelName setText:recipe.rName];
            labelName.backgroundColor=[UIColor clearColor];
            [imageView addSubview:labelName];
            [labelName release];
//            [self.view addSubview:imageView];
            [imageView release];
            [self.listRecipe addObject:recipe];
            n++;
        }
    }
    while (self.listRecipe.count>3) {
        RecipePageView *recipePageView=[[RecipePageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        Recipe *firstRecipe=(Recipe *)[listRecipe objectAtIndex:0];
        Recipe *secondRecipe=(Recipe *)[listRecipe objectAtIndex:1];
        Recipe *thirdRecipe=(Recipe *)[listRecipe objectAtIndex:2];
        [recipePageView bindFirstRecipe:firstRecipe secondRecipe:secondRecipe thirdRecipe:thirdRecipe];
        [self.listRecipe removeObject:firstRecipe];
        [self.listRecipe removeObject:secondRecipe];
        [self.listRecipe removeObject:thirdRecipe];
        [self.view addSubview:recipePageView];
        [recipePageView release];
    }
    NSLog(@"%d",n);
    self.outCellViews=[[NSMutableArray alloc]init];
    [self setFrontView:nil];
    [self setBlackgroudLeft:nil];
    [self setBlackgroudRight:nil];
    [self setBlackView:nil];
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

- (void)panned:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:{
            float value = [recognizer translationInView:self.view].x;
            NSLog(@"UIGestureRecognizerStatePossible %f",value);

        }
            
            break;
            //        case UIGestureRecognizerStateRecognized: // for discrete recognizers
            //            break;
        case UIGestureRecognizerStateFailed: // cannot recognize for multi touch sequence
        {
            float value = [recognizer translationInView:self.view].x;
            NSLog(@"UIGestureRecognizerStateFailed %f",value);

        }
            break;
        case UIGestureRecognizerStateBegan: {
            // allow controlled flip only when touch begins within the pan region
            touchOn=NO;
          
        }
            break;
        case UIGestureRecognizerStateChanged:{            
            float value = [recognizer translationInView:self.view].x;
            if (value>1&&!touchOn) {
                isFormLeft=NO;
                touchOn=YES;
            }
            if (value<-1&&!touchOn) {
                isFormLeft=YES;
                touchOn=YES;
            }
            //往后翻页
            if (isFormLeft&&touchOn) {
                if (self.view.subviews.count<2) {
                    return;
                }
                if (self.blackgroudLeft==nil&&self.blackgroudRight==nil&&self.frontView==nil&&self.blackView==nil) {
                    self.blackgroudLeft=[[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height)] autorelease];
                    self.blackgroudLeft.backgroundColor=[UIColor blackColor];
                    [self.blackgroudLeft setImage:[self imageByRenderingView:[self.view.subviews objectAtIndex:self.view.subviews.count-1] isLeft:YES]];
                    self.currentView=[self.view.subviews objectAtIndex:self.view.subviews.count-1];
                    self.blackgroudRight=[[[CellView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2,0,  self.view.frame.size.width/2, self.view.frame.size.height)] autorelease];
                    self.blackgroudRight.backgroundColor=[UIColor blackColor];
                    [self.blackgroudRight setImage:[self imageByRenderingView:[self.view.subviews objectAtIndex:self.view.subviews.count-2] isLeft:NO]];
                    self.frontView=[[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
                    self.frontView.backgroundColor=[UIColor blackColor];
                    [self.frontView setImage:[self imageByRenderingView:[self.view.subviews objectAtIndex:self.view.subviews.count-1]]];
                     self.blackView=[[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
                    self.blackView.backgroundColor=[UIColor blackColor];
                    [self.blackView setImage:[self imageByRenderingView:[self.view.subviews objectAtIndex:self.view.subviews.count-2]]];
                    self.groupView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
                    [self.groupView addSubview:frontView];
                    [self.groupView addSubview:self.blackgroudRight];
                    [self.groupView addSubview:blackView];
                    [self.groupView addSubview:self.blackgroudLeft];
                    [self.view addSubview:groupView];
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(180*value/768) * M_PI / 180.0f, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((180*value/768)+180) * M_PI / 180.0f+0.0001), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;
                }
                else{
                    if (value>-1) {
                        value=-1;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(180*value/768) * M_PI / 180.0f, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((180*value/768)+180) * M_PI / 180.0f+0.0001), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;

//                    self.blackView.layer.transform=CATransform3DMakeRotation((((180*value/768)+180) * M_PI / 180.0f+0.0001), 0,1, 0);
                    self.blackgroudRight.imageView.alpha=1.2*fabs(value/384);
                    self.blackgroudLeft.imageView.alpha=1.2*(768+value)/384;
                    CGFloat alpha=1+0.5*value/768;
                    if (alpha<0.90) {
                        alpha=0.90;
                    }
                    self.frontView.imageView.alpha=alpha;
                    self.blackView.imageView.alpha=alpha;
//                    [self.frontView.imageView.layer setFrame:CGRectMake(self.frontView.frame.origin.x, self.frontView.frame.origin.y+15*value/768, self.frontView.frame.size.width, self.frontView.frame.size.height-30*value/768)];
             }
            }
            //往前翻页
            if (!isFormLeft&&touchOn) {
                if (self.outCellViews.count<1) {
                    return;
                }
                if (self.blackgroudLeft==nil&&self.blackgroudRight==nil&&self.frontView==nil&&self.blackView==nil) {
                    self.blackgroudLeft=[[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height)] autorelease];
                    self.blackgroudLeft.backgroundColor=[UIColor blackColor];
                    [self.blackgroudLeft setImage:[self imageByRenderingView:[self.outCellViews objectAtIndex:self.outCellViews.count-1] isLeft:YES]];
                    self.currentView=[self.outCellViews objectAtIndex:self.outCellViews.count-1];
                    self.blackgroudRight=[[[CellView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2,0,  self.view.frame.size.width/2, self.view.frame.size.height)] autorelease];
                    self.blackgroudRight.backgroundColor=[UIColor blackColor];
                    [self.blackgroudRight setImage:[self imageByRenderingView:[self.view.subviews objectAtIndex:self.view.subviews.count-1] isLeft:NO]];
                    self.frontView=[[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
                    self.frontView.backgroundColor=[UIColor blackColor];
                    [self.frontView setImage:[self imageByRenderingView:[self.view.subviews objectAtIndex:self.view.subviews.count-1]]];
                    self.blackView=[[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
                    self.blackView.backgroundColor=[UIColor blackColor];
                    [self.blackView setImage:[self imageByRenderingView:[self.outCellViews objectAtIndex:self.outCellViews.count-1]]];
                    self.groupView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
                    [self.groupView addSubview:frontView];
                    [self.groupView addSubview:self.blackgroudRight];
                    [self.groupView addSubview:blackView];
                    [self.groupView addSubview:self.blackgroudLeft];
                    [self.view addSubview:groupView];
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(180*value/768) * M_PI / 180.0f+0.0001, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((180*value/768) +180)* M_PI / 180.0f), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;                }
                else{
                    if (value<1) {
                        value=1;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(180*value/768) * M_PI / 180.0f+0.0001, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((180*value/768) +180)* M_PI / 180.0f), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;
                    
                    //                    self.blackView.layer.transform=CATransform3DMakeRotation((((180*value/768)+180) * M_PI / 180.0f+0.0001), 0,1, 0);
                    self.blackgroudRight.imageView.alpha=(2-fabs(value/384));
                    self.blackgroudLeft.imageView.alpha=value/384;
                    CGFloat alpha=1-0.5*value/768;
                    if (alpha<0.90) {
                        alpha=0.90;
                    }
                    self.frontView.imageView.alpha=alpha;
                    self.blackView.imageView.alpha=alpha;

                }
            }
        }break;
        case UIGestureRecognizerStateCancelled: // cancellation touch
            break;
        case UIGestureRecognizerStateEnded: {
            float value = [recognizer translationInView:self.view].x;
            //往后翻页
            if (isFormLeft&&touchOn) {
                if (value<-5) {      
                    if (self.view.subviews.count<2) {
                        return;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(180*(value-1)/768) * M_PI / 180.0f,0, 1, 0);
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((180*(value+1)/768)+180) * M_PI / 180.0f+0.0001), 0, 1, 0);
                    self.frontView.layer.transform=transformFront;                
                    self.blackView.layer.transform=transformBlack;
                    CATransform3D transformFront1 = CATransform3DIdentity;
                    transformFront1.m34 = m34_value; // 透视效果
                    transformFront1 =CATransform3DRotate(transformFront1,(180* M_PI / 180.0f),0, 1, 0);
                    CATransform3D transformBlack1 = CATransform3DIdentity;
                    transformBlack1.m34 = m34_value; // 透视效果
                    transformBlack1 =  CATransform3DRotate(transformBlack1,(360.001* M_PI / 180.0f), 0, 1, 0);
                    self.view.userInteractionEnabled=NO;
                    [UIView animateWithDuration:0.6*(768-fabs(value))/768 animations:^{
                        self.blackgroudRight.imageView.alpha=1;
                        self.blackgroudLeft.imageView.alpha=0;
                        self.blackView.imageView.alpha=1;
                        
                        self.frontView.layer.transform=transformFront1;
                        
                        self.blackView.layer.transform=transformBlack1;
                    } completion:^(BOOL finished) {
                        [self.blackgroudLeft removeFromSuperview];
                        [self.outCellViews addObject:self.currentView];
                        NSLog(@"%d",self.outCellViews.count);
                        [self.currentView removeFromSuperview];
                        currentView=nil;
                        [self.frontView removeFromSuperview];
                        [self.groupView removeFromSuperview];
                        [self.blackgroudRight removeFromSuperview];
                        [frontView release];
                        frontView=nil;
                        [blackView release];
                        blackView=nil;
                        [self.blackView removeFromSuperview];
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.view.userInteractionEnabled=YES;
                    }  ] ;
                }
                else{
                    self.view.userInteractionEnabled=NO;
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(-0.1* M_PI / 180.0f),0, 1, 0);
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(180* M_PI / 180.0f), 0, 1, 0);
                    [UIView animateWithDuration:0.6*fabs(value)/768 animations:^{
                        self.blackgroudRight.imageView.alpha=0;
                        self.blackgroudLeft.imageView.alpha=1;
                        self.frontView.imageView.alpha=1;
                        self.frontView.layer.transform=transformFront;                
                        self.blackView.layer.transform=transformBlack;
                    } completion:^(BOOL finished) {
                        [self.blackView removeFromSuperview];
                        [self.blackgroudRight removeFromSuperview];
                        [self.blackgroudLeft removeFromSuperview];
                        [self.frontView removeFromSuperview];
                        [self.groupView removeFromSuperview];
                        [frontView release];
                        frontView=nil;
                        [blackView release];
                        blackView=nil;
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.view.userInteractionEnabled=YES;
                    }  ] ;
                }
            }
            //往前翻页
            if (!isFormLeft&&touchOn) {
                if (value>5) {      
                    if (self.outCellViews.count<1) {
                        return;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(180*(value+1)/768) * M_PI / 180.0f+0.0001,0, 1, 0);
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((180*(value-1)/768)+180) * M_PI / 180.0f), 0, 1, 0);
                    self.frontView.layer.transform=transformFront;                
                    self.blackView.layer.transform=transformBlack;
                    CATransform3D transformFront1 = CATransform3DIdentity;
                    transformFront1.m34 = m34_value; // 透视效果
                    transformFront1 =CATransform3DRotate(transformFront1,(180* M_PI / 180.0f),0, 1, 0);
                    CATransform3D transformBlack1 = CATransform3DIdentity;
                    transformBlack1.m34 = m34_value; // 透视效果
                    transformBlack1 =  CATransform3DRotate(transformBlack1,(359* M_PI / 180.0f), 0, 1, 0);
                    self.view.userInteractionEnabled=NO;
                    [UIView animateWithDuration:0.6*(768-fabs(value))/768 animations:^{
                        self.blackgroudRight.imageView.alpha=0;
                        self.blackgroudLeft.imageView.alpha=1;
                        self.blackView.imageView.alpha=1;
                        
                        self.frontView.layer.transform=transformFront1;
                        
                        self.blackView.layer.transform=transformBlack1;
                    } completion:^(BOOL finished) {
                        [self.view addSubview:self.currentView];
                        [self.blackgroudRight removeFromSuperview];
                        [self.blackgroudLeft removeFromSuperview];
                        [self.outCellViews removeObject:self.currentView];
                        currentView=nil;
                        [self.frontView removeFromSuperview];
                        [self.groupView removeFromSuperview];
                        [frontView release];
                        frontView=nil;
                        [blackView release];
                        blackView=nil;
                        [self.blackView removeFromSuperview];
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.view.userInteractionEnabled=YES;
                    }  ] ;
                }
                else{
                    self.view.userInteractionEnabled=NO;
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(1.1* M_PI / 180.0f),0, 1, 0);
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(181* M_PI / 180.0f), 0, 1, 0);
                    [UIView animateWithDuration:0.6*fabs(value)/768 animations:^{
                        self.blackgroudRight.imageView.alpha=1;
                        self.blackgroudLeft.imageView.alpha=0;
                        self.frontView.imageView.alpha=1;
                        self.frontView.layer.transform=transformFront;                
                        self.blackView.layer.transform=transformBlack;
                    } completion:^(BOOL finished) {
                        [self.blackgroudRight removeFromSuperview];
                        [self.blackgroudLeft removeFromSuperview];
                        [self.blackView removeFromSuperview];
                        [self.frontView removeFromSuperview];
                        [self.groupView removeFromSuperview];
                        [frontView release];
                        frontView=nil;
                        [blackView release];
                        blackView=nil;
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.view.userInteractionEnabled=YES;
                    }  ] ;
                }
                
            }
            }            break;
        default:
            break;
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.cName" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.cName" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    
-(void)dealloc{
    [frontView removeFromSuperview];
    [frontView release];
    [blackView removeFromSuperview];
    [blackView release];
    [outCellViews removeAllObjects];
    [outCellViews release];
    [super dealloc];
}
@end

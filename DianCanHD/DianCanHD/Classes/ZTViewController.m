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
#import "Category.h"
#import "CategoryButton.h"
@implementation ZTViewController
{
    BOOL touchOn;
    BOOL isFormLeft;
    NSInteger currentPageNum;
}
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize frontView,blackView,blackgroudLeft,blackgroudRight,gestureRecognizer,currentView,groupView,outCellViews;
@synthesize listRecipe;
@synthesize player;
@synthesize flipView;
@synthesize listPageView;
@synthesize categoryPageNum;
@synthesize categoryView;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)initSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"m4a"]; 
    NSError  *error; 
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path]error:&error]; 
    //    [player prepareToPlay];
    player.numberOfLoops = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.flipView=[[UIView alloc] initWithFrame:CGRectMake(0, 50, 718, 1024-100)];
    self.view.alpha=0;
    [self.view addSubview:self.flipView];
    ZTAppDelegate *appDelegate=(ZTAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext=appDelegate.managedObjectContext;
    gestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.maximumNumberOfTouches = 1;
    gestureRecognizer.minimumNumberOfTouches = 1;
    [self.flipView addGestureRecognizer:gestureRecognizer];
    self.listRecipe=[[NSMutableArray alloc] init];
    self.listPageView=[[NSMutableArray alloc] init];
    self.categoryPageNum=[[NSMutableArray alloc] init];
    NSInteger n=0;
//    [self.categoryPageNum addObject:[NSString stringWithFormat:@"%d",1]];
    for (NSInteger i=0; i<self.fetchedResultsController.sections.count; i++) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:i];
        for (NSInteger j=0; j<[sectionInfo numberOfObjects]; j++) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:i];
            Recipe *recipe=(Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
//            CellView *imageView=[[CellView alloc] initWithFrame:CGRectMake(0, 0, self.flipView.frame.size.width, self.flipView.frame.size.height)];
//            [imageView.imageView setFrame:CGRectMake(25, 25, self.flipView.frame.size.width, self.flipView.frame.size.height)];
//            [imageView setTag:n];
//            [imageView setImage:recipe.image.image];
//            UILabel *labelName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 25)];
//            labelName.textAlignment=UITextAlignmentCenter;
//            [labelName setText:recipe.rName];
//            labelName.backgroundColor=[UIColor clearColor];
//            [imageView addSubview:labelName];
//            [labelName release];
//            [imageView release];
            [self.listRecipe addObject:recipe];
            n++;
        }
        NSInteger pageNum=n/4;
        if (n%4>0) {
            pageNum+=1;
        }
        [self.categoryPageNum addObject:[NSString stringWithFormat:@"%d",pageNum ]];
    }
    NSInteger page=1;
    while (self.listRecipe.count>7) {
        RecipePageView *recipePageView=[[RecipePageView alloc] initWithFrame:CGRectMake(0, 0, 768-50, 1024)];
        recipePageView.tag=page-1;
        [recipePageView.numLable setText:[NSString stringWithFormat:@"%d",page]];
        Recipe *firstRecipe=(Recipe *)[listRecipe objectAtIndex:0];
        Recipe *secondRecipe=(Recipe *)[listRecipe objectAtIndex:1];
        Recipe *thirdRecipe=(Recipe *)[listRecipe objectAtIndex:2];
        Recipe *fourthRecipe=(Recipe *)[listRecipe objectAtIndex:3];
        [recipePageView bindFirstRecipe:firstRecipe secondRecipe:secondRecipe thirdRecipe:thirdRecipe fourthRecipe:fourthRecipe];
        [self.listRecipe removeObject:firstRecipe];
        [self.listRecipe removeObject:secondRecipe];
        [self.listRecipe removeObject:thirdRecipe];
        [self.listRecipe removeObject:fourthRecipe];
        [self.listPageView addObject:recipePageView];
        [recipePageView release];
        page++;
    }
    if (self.listRecipe.count==7) {
        RecipePageView *recipePageView=[[RecipePageView alloc] initWithFrame:CGRectMake(0, 0, 768-50, 1024)];
        recipePageView.tag=page-1;
        [recipePageView.numLable setText:[NSString stringWithFormat:@"%d",page]];
        Recipe *recipe=(Recipe *)[listRecipe objectAtIndex:0];
        Recipe *recipe1=(Recipe *)[listRecipe objectAtIndex:1];
        Recipe *recipe2=(Recipe *)[listRecipe objectAtIndex:2];
        Recipe *recipe3=(Recipe *)[listRecipe objectAtIndex:3];
        Recipe *recipe4=(Recipe *)[listRecipe objectAtIndex:4];
        Recipe *recipe5=(Recipe *)[listRecipe objectAtIndex:5];
        Recipe *recipe6=(Recipe *)[listRecipe objectAtIndex:6];
        [recipePageView bindFirstRecipe:recipe secondRecipe:recipe1 thirdRecipe:recipe2 fourthRecipe:recipe3];
        RecipePageView *recipePageView1=[[RecipePageView alloc] initWithFrame:CGRectMake(0, 0, 768-50, 1024)];
        recipePageView1.tag=page;
        [recipePageView1 bindFirstRecipe:recipe4 secondRecipe:recipe5 thirdRecipe:recipe6];
        [recipePageView1.numLable setText:[NSString stringWithFormat:@"%d",page+1]];
        [self.listRecipe removeObject:recipe];
        [self.listRecipe removeObject:recipe1];
        [self.listRecipe removeObject:recipe2];
        [self.listRecipe removeObject:recipe3];
        [self.listRecipe removeObject:recipe4];
        [self.listRecipe removeObject:recipe5];
        [self.listRecipe removeObject:recipe6];
        [self.listPageView addObject:recipePageView];
        [self.listPageView addObject:recipePageView1];
        [recipePageView release];
        page++;
    }
    currentPageNum=1;
    self.outCellViews=[[NSMutableArray alloc]init];
    [self setFrontView:nil];
    [self setBlackgroudLeft:nil];
    [self setBlackgroudRight:nil];
    [self setBlackView:nil];
    [self initSound];
    [self initCategoryView];
//    [self loadImageWithIndex:1 count:9];
    [self markCategoryButton];

}
-(void)markCategoryButton{
    NSInteger i=0;
    for (CategoryButton *btn in self.categoryView.subviews) {
        if (currentPageNum+1>=btn.minPage&&btn.maxPage>=currentPageNum+1) {
            btn.backgroundColor=[UIColor orangeColor];
        }
        else {
            btn.backgroundColor=[UIColor whiteColor];
        }
        i++;
    }
}
-(void)initCategoryView{
    UIView *cView=[[UIView alloc] initWithFrame:CGRectMake(738, 0, 50, 1024)];
    [self.view addSubview:cView];
    [self setCategoryView:cView];
    UIImageView *bookView=[[UIImageView alloc] initWithFrame:CGRectMake(718, 50, 20, 1024)];
    [bookView setImage:[UIImage imageNamed:@"book.png"]];
    [self.view addSubview:bookView];
    [bookView release];
    NSInteger y=70;
    for (NSInteger i=0; i<self.fetchedResultsController.sections.count; i++) {
        NSInteger min=1;
        if (i>0) {
            NSString *minString=[self.categoryPageNum objectAtIndex:i-1 ];
            min=[minString integerValue];
        }
        NSString *page=[self.categoryPageNum objectAtIndex:i];
        NSInteger pageNum=[page integerValue];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:i];
        Recipe *recipe=(Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        CategoryButton *button=[[CategoryButton alloc] initWithFrame:CGRectMake(0, y, 30, 120)];
        button.layer.borderColor=[[UIColor orangeColor] CGColor];
        button.layer.borderWidth=3;
        button.layer.cornerRadius=10;
//        button.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:24];
        [button setTitle:recipe.category.cName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        button.titleLabel.numberOfLines=0;
        button.maxPage=pageNum;
        button.minPage=min;
        //    [button setBackgroundImage:[UIImage imageNamed:@"lable.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryView addSubview:button];
        [button release];
        y+=120;
    }

    [cView release];
}
-(void)categoryButtonClick:(CategoryButton *)button{
    if (currentPageNum==button.minPage) {
        return;
    }
    self.view.userInteractionEnabled=NO;
    if (currentPageNum<button.minPage) {
        currentPageNum=button.minPage;
        [self turnPageLeft];
    }
    else{
        currentPageNum=button.minPage;
        [self turnPageRight];
    }
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
        }
            
            break;
            //        case UIGestureRecognizerStateRecognized: // for discrete recognizers
            //            break;
        case UIGestureRecognizerStateFailed: // cannot recognize for multi touch sequence
        {
        }
            break;
        case UIGestureRecognizerStateBegan: {
            // allow controlled flip only when touch begins within the pan region
            touchOn=NO;
        }
            break;
        case UIGestureRecognizerStateChanged:{            
            float value = [recognizer translationInView:self.flipView].x;
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
                if (self.flipView.subviews.count<2) {
                    return;
                }
                if (self.blackgroudLeft==nil&&self.blackgroudRight==nil&&self.frontView==nil&&self.blackView==nil) {
                    self.currentView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];
                    RecipePageView *nextCellView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-2] ;
                    self.blackgroudLeft=self.currentView.leftImageView;
                    self.blackgroudRight=nextCellView.rightImageView;
                    self.frontView=self.currentView.fullImageView;
                    self.blackView=nextCellView.fullImageView;
                    self.groupView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.flipView.frame.size.width, self.flipView.frame.size.height)] autorelease];
                    [self.groupView addSubview:frontView];
                    [self.groupView addSubview:self.blackgroudRight];
                    [self.groupView addSubview:blackView];
                    [self.groupView addSubview:self.blackgroudLeft];
                    [self.flipView addSubview:groupView];
//                    self.frontView.backgroundColor=[UIColor blackColor];
//                    self.blackView.backgroundColor=[UIColor blackColor];
//                    self.blackgroudLeft.backgroundColor=[UIColor blackColor];
//                    self.blackgroudRight.backgroundColor=[UIColor blackColor];
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(1.5*180*value/768) * M_PI / 180.0f, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((1.5*180*value/768)+180) * M_PI / 180.0f+0.0001), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;
                }
                else{
                    if (value>-1) {
                        value=-1;
                    }
                    if (((1.5*180*value/768) * M_PI / 180.0f)<-3.14) {
                        value=-511;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(1.5*180*value/768) * M_PI / 180.0f, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((1.5*180*value/768)+180) * M_PI / 180.0f+0.0001), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;
                    self.blackgroudRight.imageView.alpha=1.2*fabs(1.5*value/384);
                    self.blackgroudLeft.imageView.alpha=1.2*(768+1.5*value)/384;
                    CGFloat alpha=1+0.5*value/768;
                    if (alpha<0.90) {
                        alpha=0.90;
                    }
                    self.frontView.imageView.alpha=alpha;
                    self.blackView.imageView.alpha=alpha;
             }
            }
            //往前翻页
            if (!isFormLeft&&touchOn) {
                if (self.outCellViews.count<1) {
                    return;
                }
                if (self.blackgroudLeft==nil&&self.blackgroudRight==nil&&self.frontView==nil&&self.blackView==nil) {
                    self.currentView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];
                    RecipePageView *nextCellView=[self.outCellViews objectAtIndex:self.outCellViews.count-1] ;
                    self.blackgroudLeft=nextCellView.leftImageView;
                    self.blackgroudRight=self.currentView.rightImageView;
                    self.frontView=self.currentView.fullImageView;
                    self.blackView=nextCellView.fullImageView;
                    self.groupView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.flipView.frame.size.width, self.flipView.frame.size.height)] autorelease];
                    [self.groupView addSubview:frontView];
                    [self.groupView addSubview:self.blackgroudRight];
                    [self.groupView addSubview:blackView];
                    [self.groupView addSubview:self.blackgroudLeft];
                    [self.flipView addSubview:groupView];
                    self.currentView=[self.outCellViews objectAtIndex:self.outCellViews.count-1];
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(1.5*180*value/768) * M_PI / 180.0f+0.0001, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((1.5*180*value/768) +180)* M_PI / 180.0f), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;                }
                else{
                    if (value<1) {
                        value=1;
                    }
                    if (((1.5*180*value/768) * M_PI / 180.0f)>3.13) {
                        value=510;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(1.5*180*value/768) * M_PI / 180.0f+0.0001, 0, 1, 0);
                    self.frontView.layer.transform=transformFront;
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((1.5*180*value/768) +180)* M_PI / 180.0f), 0, 1, 0);
                    self.blackView.layer.transform=transformBlack;
                    
                    //                    self.blackView.layer.transform=CATransform3DMakeRotation((((180*value/768)+180) * M_PI / 180.0f+0.0001), 0,1, 0);
                    self.blackgroudRight.imageView.alpha=(2-fabs(1.5*value/384));
                    self.blackgroudLeft.imageView.alpha=1.5*value/384;
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
            float value = [recognizer translationInView:self.flipView].x;
            //往后翻页
            if (isFormLeft&&touchOn) {
                if (value<-5) {      
                    if (self.flipView.subviews.count<2) {
                        return;
                    }
                    if (((1.5*180*value/768) * M_PI / 180.0f)<-3.14) {
                        value=-511;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(1.5*180*(value-1)/768) * M_PI / 180.0f,0, 1, 0);
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((1.5*180*(value+1)/768)+180) * M_PI / 180.0f+0.0001), 0, 1, 0);
                    self.frontView.layer.transform=transformFront;                
                    self.blackView.layer.transform=transformBlack;
                    CATransform3D transformFront1 = CATransform3DIdentity;
                    transformFront1.m34 = m34_value; // 透视效果
                    transformFront1 =CATransform3DRotate(transformFront1,(180* M_PI / 180.0f),0, 1, 0);
                    CATransform3D transformBlack1 = CATransform3DIdentity;
                    transformBlack1.m34 = m34_value; // 透视效果
                    transformBlack1 =  CATransform3DRotate(transformBlack1,(360.001* M_PI / 180.0f), 0, 1, 0);
                    self.flipView.userInteractionEnabled=NO;
                    [self playTurnBookSound];
                    [UIView animateWithDuration:0.6*(768-fabs(value))/768 animations:^{
                        self.blackgroudRight.imageView.alpha=1;
                        self.blackgroudLeft.imageView.alpha=0;
                        self.blackView.imageView.alpha=1;
                        self.frontView.layer.transform=transformFront1;
                        self.blackView.layer.transform=transformBlack1;
                    } completion:^(BOOL finished) {
                        [self.blackgroudLeft removeFromSuperview];
                        [self.outCellViews addObject:self.currentView];
                        [self.currentView removeFromSuperview];
                        currentView=nil;
                        [self.frontView removeFromSuperview];
                        [self.groupView removeFromSuperview];
                        NSLog(@"blackgroudRight=%d",self.blackgroudRight.retainCount);
                        [self.blackgroudRight removeFromSuperview];
//                        [blackgroudRight release];
                        NSLog(@"blackgroudRight=%d",self.blackgroudRight.retainCount);
                        frontView=nil;
                        blackView=nil;
                        [self.blackView removeFromSuperview];
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.flipView.userInteractionEnabled=YES;
                        currentPageNum++;
                        [self initFlip];
                        [self markCategoryButton];
                    }  ] ;
                }
                else{
                    self.flipView.userInteractionEnabled=NO;
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
                        frontView=nil;
                        blackView=nil;
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.flipView.userInteractionEnabled=YES;
                    }  ] ;
                }
            }
            //往前翻页
            if (!isFormLeft&&touchOn) {
                if (value>5) {      
                    if (self.outCellViews.count<1) {
                        return;
                    }
                    if (((1.5*180*value/768) * M_PI / 180.0f)>3.13) {
                        value=510;
                    }
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(1.5*180*(value+1)/768) * M_PI / 180.0f+0.0001,0, 1, 0);
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(((1.5*180*(value-1)/768)+180) * M_PI / 180.0f), 0, 1, 0);
                    self.frontView.layer.transform=transformFront;                
                    self.blackView.layer.transform=transformBlack;
                    CATransform3D transformFront1 = CATransform3DIdentity;
                    transformFront1.m34 = m34_value; // 透视效果
                    transformFront1 =CATransform3DRotate(transformFront1,(180* M_PI / 180.0f),0, 1, 0);
                    CATransform3D transformBlack1 = CATransform3DIdentity;
                    transformBlack1.m34 = m34_value; // 透视效果
                    transformBlack1 =  CATransform3DRotate(transformBlack1,(359* M_PI / 180.0f), 0, 1, 0);
                    self.flipView.userInteractionEnabled=NO;
                    [self playTurnBookSound];
                    [UIView animateWithDuration:0.6*(768-fabs(value))/768 animations:^{
                        self.blackgroudRight.imageView.alpha=0;
                        self.blackgroudLeft.imageView.alpha=1;
                        self.blackView.imageView.alpha=1;
                        
                        self.frontView.layer.transform=transformFront1;
                        
                        self.blackView.layer.transform=transformBlack1;
                    } completion:^(BOOL finished) {
//                        [self.flipView insertSubview:self.currentView atIndex:0];
                        [self.outCellViews removeObject:self.currentView];
                        [self.flipView addSubview:self.currentView];
                        [self.blackgroudRight removeFromSuperview];
                        [self.blackgroudLeft removeFromSuperview];
                        currentView=nil;
                        [self.frontView removeFromSuperview];
                        [self.groupView removeFromSuperview];
                        frontView=nil;
                        blackView=nil;
                        [self.blackView removeFromSuperview];
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.flipView.userInteractionEnabled=YES;
                        currentPageNum--;
                        [self initFlip];
                        [self markCategoryButton];
                    }  ] ;
                }
                else{
                    self.flipView.userInteractionEnabled=NO;
                    CATransform3D transformFront = CATransform3DIdentity;
                    transformFront.m34 = m34_value; // 透视效果
                    transformFront = CATransform3DRotate(transformFront,(0.1* M_PI / 180.0f),0, 1, 0);
                    CATransform3D transformBlack = CATransform3DIdentity;
                    transformBlack.m34 = m34_value; // 透视效果
                    transformBlack = CATransform3DRotate(transformBlack,(180.1* M_PI / 180.0f), 0, 1, 0);
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
                        frontView=nil;
                        blackView=nil;
                        [self setFrontView:nil];
                        [self setBlackgroudLeft:nil];
                        [self setBlackgroudRight:nil];
                        [self setBlackView:nil];
                        [groupView release];           
                        groupView=nil;
                        self.flipView.userInteractionEnabled=YES;
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
- (void)getNowTime
{
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSLog(@"时间  %@",[formatter stringFromDate:date]);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getNowTime];
    [self initTurnFlip];
    [self getNowTime];
    self.view.alpha=1;

//    [UIView animateWithDuration:1 delay:5 options:UIViewAnimationCurveEaseIn animations:^{
//        self.view.alpha=1;
//    } completion:^(BOOL finished) {
//    } ];
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
     if(interfaceOrientation == UIInterfaceOrientationPortrait) return YES;
    return NO;
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
-(void)initFlip{
    for (NSInteger i=self.flipView.subviews.count-1; i>=0; i--) {
        RecipePageView *pageView=[self.flipView.subviews objectAtIndex:i];
        if ([pageView isKindOfClass:[RecipePageView class]]) {
            [pageView removeFromSuperview];
        }
    }
       for (NSInteger i=0; i<self.listPageView.count; i++) {
           RecipePageView *recipeView=(RecipePageView *)[self.listPageView objectAtIndex:i];
           if (i<currentPageNum-6||i>currentPageNum+6) {
               [recipeView removeFlip];
           }
           if(i>currentPageNum-4||i<currentPageNum+5){
               [recipeView loadImage];
           }
           if (i>=currentPageNum-1) {
               [self.flipView insertSubview:recipeView atIndex:0];
           }
           if (i<currentPageNum-1) {
               [self.outCellViews addObject:recipeView];
           }
   }

    if (self.flipView.subviews.count>0) {
        RecipePageView *pageView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];
        [pageView initFlip];
    }
    if (self.flipView.subviews.count>1) {
    RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-2];

    [pageViewNext initFlip];
    }
    if(self.outCellViews.count>0){
    RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-1];
    [pageViewPre initFlip];
    }
//    if(self.outCellViews.count>1){
//        RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-2];
//        [pageViewPre initFlip];
//    }
//    if(self.outCellViews.count>2){
//        RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-3];
//        [pageViewPre initFlip];
//    }
//    if(self.outCellViews.count>3){
//        RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-4];
//        [pageViewPre initFlip];
//    }
//
//    if (self.flipView.subviews.count>2) {
//        RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-3];
//        [pageViewNext initFlip];
//    }
//    if (self.flipView.subviews.count>3) {
//        RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-4];
//        [pageViewNext initFlip];
//    }
//    if (self.flipView.subviews.count>4) {
//        RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-5];
//        [pageViewNext initFlip];
//    }

}
-(void)initTurnFlip{
    for (NSInteger i=self.flipView.subviews.count-1; i>=0; i--) {
        RecipePageView *pageView=[self.flipView.subviews objectAtIndex:i];
        if ([pageView isKindOfClass:[RecipePageView class]]) {
            [pageView removeFromSuperview];
        }
    }
    for (NSInteger i=0; i<self.listPageView.count; i++) {
        RecipePageView *recipeView=(RecipePageView *)[self.listPageView objectAtIndex:i];
        if (i<currentPageNum-6||i>currentPageNum+6) {
            [recipeView removeFlip];
        }
        if(i>currentPageNum-4||i<currentPageNum+5){
            [recipeView loadImage];
        }
        if (i>=currentPageNum-1) {
            [self.flipView insertSubview:recipeView atIndex:0];
        }
        if (i<currentPageNum-1) {
            [self.outCellViews addObject:recipeView];
        }
    }
    
    if (self.flipView.subviews.count>0) {
        RecipePageView *pageView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];
        [pageView initTurnFlip];
    }
    if (self.flipView.subviews.count>1) {
        RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-2];
        [pageViewNext initTurnFlip];
    }
    if(self.outCellViews.count>0){
        RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-1];
        [pageViewPre initTurnFlip];
    }
//    if(self.outCellViews.count>1){
//        RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-2];
//        [pageViewPre initTurnFlip];
//    }
//    if(self.outCellViews.count>2){
//        RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-3];
//        [pageViewPre initTurnFlip];
//    }
//    if(self.outCellViews.count>3){
//        RecipePageView *pageViewPre=[self.outCellViews objectAtIndex:self.outCellViews.count-4];
//        [pageViewPre initTurnFlip];
//    }
//    
//    if (self.flipView.subviews.count>2) {
//        RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-3];
//        [pageViewNext initTurnFlip];
//    }
//    if (self.flipView.subviews.count>3) {
//        RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-4];
//        [pageViewNext initTurnFlip];
//    }
//    if (self.flipView.subviews.count>4) {
//        RecipePageView *pageViewNext=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-5];
//        [pageViewNext initTurnFlip];
//    }
    
}

-(void)playTurnBookSound{
    [self.player stop];
    [self.player play];   //播放
//    NSLog(@"random=%ld",random()%4);
}
//翻书动画（往后）
-(void)turnPageLeft{
    if (self.flipView.subviews.count>0) {
        RecipePageView *pageView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];
        [pageView initTurnFlip];
    }
    RecipePageView *nextCellView=[self.listPageView objectAtIndex:currentPageNum-1] ;
    NSLog(@"currentPageNum=%d",currentPageNum);
    [nextCellView initTurnFlip];
    UIView *v1=[[UIView alloc] initWithFrame:CGRectMake(0,0, self.flipView.frame.size.width, self.flipView.frame.size.height+50)];
    UIImageView *iv1=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv1 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv1.alpha=1;
    [v1 addSubview:iv1];
    [iv1 release];
    v1.backgroundColor=[UIColor blackColor];
    UIView *v2=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv2=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv2 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv2.alpha=0.95;
    [v2 addSubview:iv2];
    [iv2 release];
    v2.backgroundColor=[UIColor blackColor];
    UIView *v3=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv3=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv3 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv3.alpha=0.9;
    [v3 addSubview:iv3];
    [iv3 release];
    v3.backgroundColor=[UIColor blackColor];
    UIView *v4=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv4=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv4 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv4.alpha=0.95;
    [v4 addSubview:iv4];
    [iv4 release];
    v4.backgroundColor=[UIColor blackColor];
    UIView *v5=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv5=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv5 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv5.alpha=1;
    [v5 addSubview:iv5];
    [iv5 release];
    v5.backgroundColor=[UIColor blackColor];
    self.currentView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];    
    NSLog(@"%d",nextCellView.tag);
//    self.blackgroudLeft=self.currentView.leftImageView;
    CellView *cr=[[CellView alloc] initWithFrame:nextCellView.rightImageView.frame];
    [cr setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
    [cr setImage:nextCellView.rightImageView.imageView.image];
    self.blackgroudRight=cr;
    CellView *cl=[[CellView alloc] initWithFrame:nextCellView.leftImageView.frame];
    [cl setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
    [cl setImage:self.currentView.leftImageView.imageView.image];
    self.blackgroudLeft=cl;
    self.frontView=self.currentView.fullImageView;
    self.blackView=nextCellView.fullImageView;
    self.groupView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.flipView.frame.size.width, self.flipView.frame.size.height)] autorelease];
    v1.layer.transform=[self getTransform:-0.9];
    v2.layer.transform=[self getTransform:-1];
    v3.layer.transform=[self getTransform:-1];
    v4.layer.transform=[self getTransform:-1];
    v5.layer.transform=[self getTransform:-1];
    CATransform3D tb1 = CATransform3DIdentity;
    tb1.m34 = m34_value; // 透视效果
    tb1 = CATransform3DRotate(tb1,179* M_PI / 180.0f, 0, 1, 0);
    CATransform3D tb2 = CATransform3DIdentity;
    tb2.m34 = m34_value; // 透视效果
    tb2 = CATransform3DRotate(tb2,1* M_PI / 180.0f, 0, 1, 0);
    self.blackView.layer.transform=[self getTransform:179];
    [self.groupView addSubview:v1];
    [self.groupView addSubview:v2];
    [self.groupView addSubview:v3];
    [self.groupView addSubview:v4];
    [self.groupView addSubview:v5];
//    self.blackgroudRight.backgroundColor=[UIColor whiteColor];
    self.blackgroudLeft.backgroundColor=[UIColor whiteColor];
    [self.groupView addSubview:self.blackgroudRight];
    [self.groupView addSubview:self.blackgroudLeft];
    [self.groupView addSubview:frontView];
    [self.groupView addSubview:blackView];
    [self.flipView addSubview:groupView];
    self.frontView.layer.transform=[self getTransform:-1];
    [UIView animateWithDuration:1 animations:^{
        self.frontView.layer.transform=[self getTransform:181];
        v1.layer.transform=[self getTransform:181];
    } completion:^(BOOL finished) {
        [v1 removeFromSuperview];
        [v1 release];
        [self.frontView removeFromSuperview];
    } ];
    [UIView animateWithDuration:1 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v2.layer.transform=[self getTransform:181];
    } completion:^(BOOL finished) {
        [v2 removeFromSuperview];
        [v2 release];
    }];
    [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v3.layer.transform=[self getTransform:181];
    } completion:^(BOOL finished) {
        [v3 removeFromSuperview];
        [v3 release];
    }];
    [UIView animateWithDuration:1 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v4.layer.transform=[self getTransform:181];
    } completion:^(BOOL finished) {    
        [v4 removeFromSuperview];
        [v4 release];
    }];
    [UIView animateWithDuration:1 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v5.layer.transform=[self getTransform:180.5];
        self.blackView.layer.transform=[self getTransform:1];
    } completion:^(BOOL finished) {      
        [v5 removeFromSuperview];
        [v5 release];
        [self.blackgroudRight removeFromSuperview];
        [self.blackgroudLeft removeFromSuperview];
        [self.blackView removeFromSuperview];
        [self.frontView removeFromSuperview];
        [self.groupView removeFromSuperview];
        blackView=nil;
        [self setFrontView:nil];
        [self setBlackgroudLeft:nil];
        [self setBlackgroudRight:nil];
        [self setBlackView:nil];
        [groupView release];           
        groupView=nil;
        self.flipView.userInteractionEnabled=YES;
        [self markCategoryButton];
//        [self initFlip];
        [self initTurnFlip];
        [cr release];
        [cl release];
        self.view.userInteractionEnabled=YES;
    }];

}
//翻书动画（往前）
-(void)turnPageRight{
    if (self.flipView.subviews.count>0) {
        RecipePageView *pageView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];
        [pageView initTurnFlip];
    }
    RecipePageView *nextCellView=[self.listPageView objectAtIndex:currentPageNum-1] ;
    NSLog(@"currentPageNum=%d",currentPageNum);
    [nextCellView initTurnFlip];
    UIView *v1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.flipView.frame.size.width, self.flipView.frame.size.height+50)];
    UIImageView *iv1=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv1 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv1.alpha=1;
    [v1 addSubview:iv1];
    [iv1 release];
    v1.backgroundColor=[UIColor blackColor];
    UIView *v2=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv2=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv2 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv2.alpha=0.95;
    [v2 addSubview:iv2];
    [iv2 release];
    v2.backgroundColor=[UIColor blackColor];
    UIView *v3=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv3=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv3 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv3.alpha=0.9;
    [v3 addSubview:iv3];
    [iv3 release];
    v3.backgroundColor=[UIColor blackColor];
    UIView *v4=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv4=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv4 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv4.alpha=0.95;
    [v4 addSubview:iv4];
    [iv4 release];
    v4.backgroundColor=[UIColor blackColor];
    UIView *v5=[[UIView alloc] initWithFrame:v1.frame];
    UIImageView *iv5=[[UIImageView alloc] initWithFrame:v1.frame];
    [iv5 setImage:[UIImage imageNamed:@"white.jpg"]];
    iv5.alpha=1;
    [v5 addSubview:iv5];
    [iv5 release];
    v5.backgroundColor=[UIColor blackColor];
    self.currentView=[self.flipView.subviews objectAtIndex:self.flipView.subviews.count-1];
    NSLog(@"%d",nextCellView.tag);
    //    self.blackgroudLeft=self.currentView.leftImageView;
    CellView *cr=[[CellView alloc] initWithFrame:nextCellView.rightImageView.frame];
    [cr setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
    [cr setImage:self.currentView.rightImageView.imageView.image];
    self.blackgroudRight=cr;
    CellView *cl=[[CellView alloc] initWithFrame:nextCellView.leftImageView.frame];
    [cl setImage:[UIImage imageNamed:@"cellBackgroud.jpg"]];
    [cl setImage:nextCellView.leftImageView.imageView.image];
    self.blackgroudLeft=cl;
    self.frontView=self.currentView.fullImageView;
    self.blackView=nextCellView.fullImageView;
    self.groupView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.flipView.frame.size.width, self.flipView.frame.size.height)] autorelease];
    v1.layer.transform=[self getTransform:1];
    v2.layer.transform=[self getTransform:1];
    v3.layer.transform=[self getTransform:1];
    v4.layer.transform=[self getTransform:1];
    v5.layer.transform=[self getTransform:1];
    self.blackView.layer.transform=[self getTransform:180.5];
    [self.groupView addSubview:v1];
    [self.groupView addSubview:v2];
    [self.groupView addSubview:v3];
    [self.groupView addSubview:v4];
    [self.groupView addSubview:v5];
    self.blackgroudLeft.backgroundColor=[UIColor whiteColor];
    [self.groupView addSubview:self.blackgroudRight];
    [self.groupView addSubview:self.blackgroudLeft];
    [self.groupView addSubview:frontView];
    [self.groupView addSubview:blackView];
    [self.flipView addSubview:groupView];
    self.frontView.layer.transform=[self getTransform:1.1];
    [UIView animateWithDuration:1 animations:^{
        self.frontView.layer.transform=[self getTransform:179];
        v1.layer.transform=[self getTransform:179];
    } completion:^(BOOL finished) {
        [v1 removeFromSuperview];
        [v1 release];
        [self.frontView removeFromSuperview];
    } ];
    [UIView animateWithDuration:1 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v2.layer.transform=[self getTransform:179];
    } completion:^(BOOL finished) {
        [v2 removeFromSuperview];
        [v2 release];
    }];
    [UIView animateWithDuration:1 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v3.layer.transform=[self getTransform:179];
    } completion:^(BOOL finished) {
        [v3 removeFromSuperview];
        [v3 release];
    }];
    [UIView animateWithDuration:1 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v4.layer.transform=[self getTransform:179];
    } completion:^(BOOL finished) {
        [v4 removeFromSuperview];
        [v4 release];
    }];
    [UIView animateWithDuration:1 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        v5.layer.transform=[self getTransform:179];
        self.blackView.layer.transform=[self getTransform:-1.5];
    } completion:^(BOOL finished) {
        [v5 removeFromSuperview];
        [v5 release];
        [self.blackgroudRight removeFromSuperview];
        [self.blackgroudLeft removeFromSuperview];
        [self.blackView removeFromSuperview];
        [self.frontView removeFromSuperview];
        [self.groupView removeFromSuperview];
        blackView=nil;
        [self setFrontView:nil];
        [self setBlackgroudLeft:nil];
        [self setBlackgroudRight:nil];
        [self setBlackView:nil];
        [groupView release];
        groupView=nil;
        self.flipView.userInteractionEnabled=YES;
        [self markCategoryButton];
        //        [self initFlip];
        [self initTurnFlip];
        [cr release];
        [cl release];
        self.view.userInteractionEnabled=YES;
    }];
    
}


-(CATransform3D)getTransform:(CGFloat)angle{
    CATransform3D transformFront = CATransform3DIdentity;
    transformFront.m34 = m34_value; 
    transformFront = CATransform3DRotate(transformFront,angle* M_PI / 180.0f, 0, 1, 0);
    return transformFront;
}
-(void)dealloc{
    [frontView removeFromSuperview];
    [blackView removeFromSuperview];
    [outCellViews removeAllObjects];
    [outCellViews release];
    [super dealloc];
}
@end

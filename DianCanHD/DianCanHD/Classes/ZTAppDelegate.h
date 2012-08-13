//
//  ZTAppDelegate.h
//  DianCanHD
//
//  Created by 李炜 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTViewController;
@class ZTMainViewController;

@interface ZTAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) ZTViewController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

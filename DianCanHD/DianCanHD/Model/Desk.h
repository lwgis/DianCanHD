//
//  Desk.h
//  DianCanHD
//
//  Created by 赵飞 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DeskType;

@interface Desk : NSManagedObject

@property (nonatomic, retain) NSNumber * dCapacity;
@property (nonatomic, retain) NSNumber * dID;
@property (nonatomic, retain) NSString * dName;
@property (nonatomic, retain) NSNumber * tID;
@property (nonatomic, retain) DeskType *deskType;

@end

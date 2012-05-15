//
//  DeskType.h
//  DianCanHD
//
//  Created by 赵飞 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Desk;

@interface DeskType : NSManagedObject

@property (nonatomic, retain) NSNumber * tID;
@property (nonatomic, retain) NSString * tName;
@property (nonatomic, retain) NSSet *deskList;
@end

@interface DeskType (CoreDataGeneratedAccessors)

- (void)addDeskListObject:(Desk *)value;
- (void)removeDeskListObject:(Desk *)value;
- (void)addDeskList:(NSSet *)values;
- (void)removeDeskList:(NSSet *)values;

@end

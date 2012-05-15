//
//  Desk+Search.h
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Desk.h"

@interface Desk (Search)

@property (nonatomic, retain) NSArray *fetchedType;

+ (Desk *)deskWithID:(NSInteger)id
inManagedObjectContext:(NSManagedObjectContext *)context;
@end

//
//  DeskType+DeskType_Search.h
//  DianCanHD
//
//  Created by 赵飞 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeskType.h"

@interface DeskType (Search)
+ (DeskType *)deskTypeWithID:(NSInteger)id
inManagedObjectContext:(NSManagedObjectContext *)context;
@end

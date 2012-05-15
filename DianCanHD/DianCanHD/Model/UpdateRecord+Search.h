//
//  UpdateRecord+Search.h
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpdateRecord.h"

@interface UpdateRecord (Search)

+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;

@end

//
//  Category+Search.h
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

@interface Category (Search)

+ (Category *)categoryWithID:(NSInteger)id inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)orderedRecipe:(NSSet *) recipes;
@end

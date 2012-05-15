//
//  Recipe+Search.h
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Recipe.h"
@interface Recipe (Search)

@property (nonatomic, retain) NSArray *fetchedCategory;

+ (Recipe *)recipeWithID:(NSInteger)id
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end

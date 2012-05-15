//
//  Recipe+Search.m
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Recipe+Search.h"
#import "Category+Search.h"
@implementation Recipe (Search)
@dynamic fetchedCategory;

+ (Recipe*) recipeWithID:(NSInteger)id inManagedObjectContext:(NSManagedObjectContext *)context
{
    Recipe *recipe = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = [NSPredicate predicateWithFormat:@"rID == %ld", id];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        
    } else {
        recipe = [matches lastObject];
    }    
    return recipe;
}

@end

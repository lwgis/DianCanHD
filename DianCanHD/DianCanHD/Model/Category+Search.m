//
//  Category+Search.m
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Category+Search.h"

@implementation Category (Search)

+ (Category*) categoryWithID:(NSInteger)cid inManagedObjectContext:(NSManagedObjectContext *)context
{
    Category *recipe = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
    request.predicate = [NSPredicate predicateWithFormat:@"cID == %ld", cid];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cID" ascending:YES];
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

+ (NSArray*) orderedRecipe:(NSSet *)recipes
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rName" ascending:YES]];
    
    NSArray *sortedRecipes = [[recipes allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    return sortedRecipes;
}
@end

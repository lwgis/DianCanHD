//
//  DeskType+DeskType_Search.m
//  DianCanHD
//
//  Created by 赵飞 on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeskType+Search.h"

@implementation DeskType (Search)
+ (DeskType*) deskTypeWithID:(NSInteger)id inManagedObjectContext:(NSManagedObjectContext *)context
{
    DeskType *recipe = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DeskType"];
    request.predicate = [NSPredicate predicateWithFormat:@"tID == %ld", id];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tID" ascending:YES];
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

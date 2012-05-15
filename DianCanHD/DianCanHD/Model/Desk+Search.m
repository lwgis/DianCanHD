//
//  Desk+Search.m
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Desk+Search.h"

@implementation Desk (Search)

@dynamic fetchedType;

+ (Desk*) deskWithID:(NSInteger)id inManagedObjectContext:(NSManagedObjectContext *)context
{
    Desk *recipe = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Desk"];
    request.predicate = [NSPredicate predicateWithFormat:@"dID == %ld", id];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dID" ascending:YES];
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

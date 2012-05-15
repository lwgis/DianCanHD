//
//  UpdateRecord+Search.m
//  Diancan
//
//  Created by 赵飞 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpdateRecord+Search.h"

@implementation UpdateRecord (Search)

+(void) deleteAllInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UpdateRecord"];
    NSError *error;
    NSArray *items = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}
@end

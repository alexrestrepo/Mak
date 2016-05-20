//
//  main.m
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Pascal.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        
        Pascal *app = [[Pascal alloc] initWithOperation:arguments[1]
                                                   path:[arguments lastObject]
                                                  flags:[arguments count] > 3 ? arguments[2] : @""];
        
        NSLog(@"Done with %@", app);
    }
    return 0;
}

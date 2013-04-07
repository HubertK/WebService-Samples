//
//  Comments.m
//  Dribble
//
//  Created by Hubert Kunnemeyer on 9/11/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import "Comments.h"
#import "Player.h"


@implementation Comments


- (id)initWithDictionary:(NSDictionary*)dribbleAttrs{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSArray *keys = [dribbleAttrs allKeys];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"body"]) {
            _body = [dribbleAttrs valueForKey:@"body"];
        }
        if ([key isEqualToString:@"likes"]) {
            _likes = [NSNumber numberWithInt:[[dribbleAttrs valueForKey:@"body"]integerValue]];
        }
        if ([key isEqualToString:@"player"]) {
            NSDictionary *playerDict = [dribbleAttrs valueForKey:@"player"];
            Player *player = [[Player alloc]initWithDictionary:playerDict];
            _player = player;
        }
    }
    
    return self;
}
@end

//
//  Comments.h
//  Dribble
//
//  Created by Hubert Kunnemeyer on 9/11/12.
//  Copyright (c) 2012 Hubert Kunnemeyer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;

@interface Comments : NSObject

@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSNumber *likes;
@property (strong, nonatomic) Player *player;

- (id)initWithDictionary:(NSDictionary*)dribbleAttrs;
@end

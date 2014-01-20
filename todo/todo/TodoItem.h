//
//  TodoItem.h
//  todo
//
//  Created by Dan Dosch on 1/17/14.
//  Copyright (c) 2014 Dan Dosch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject<NSCoding>

- (id)initWithString:(NSString *)title tag:(int)tag;
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

+ (NSMutableArray *)loadTodoItems;
+ (void) storeTodoItems:(NSMutableArray *)todoItems;

@property (strong, nonatomic) NSString *todoItemText;
@property (assign, nonatomic) int todoItemTag;

@end

//
//  TodoItem.m
//  todo
//
//  Created by Dan Dosch on 1/17/14.
//  Copyright (c) 2014 Dan Dosch. All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem

- (id)initWithString:(NSString *)title tag:(int)tag {
    self = [super init];
    if (self) {
        self.todoItemText = title;
        self.todoItemTag = tag;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.todoItemText = [decoder decodeObjectForKey:@"todoItemText"];
        self.todoItemTag = [decoder decodeIntForKey:@"todoItemTag"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.todoItemText forKey:@"todoItemText"];
    [encoder encodeInt:self.todoItemTag forKey:@"todoItemTag"];
}

+ (NSMutableArray *) loadTodoItems {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"todoItems"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"Loaded data: %@", array);
    NSMutableArray *todoItemsList = [NSMutableArray arrayWithArray:array];
    if (data == nil) {
        todoItemsList = [[NSMutableArray alloc] init];
        [todoItemsList addObject:[[TodoItem alloc] initWithString:@"Yodel" tag:0]];
    }
    return todoItemsList;
}

+ (void) storeTodoItems:(NSMutableArray *)todoItems {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:todoItems]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"todoItems"];
    NSLog(@"Saved data %@", todoItems);
}

- (NSString *) description {
    return [NSString stringWithFormat:@"TodoItem[text=%@, tag=%d]", self.todoItemText, self.todoItemTag];
}

@end

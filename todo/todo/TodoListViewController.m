//
//  TodoListViewController.m
//  todo
//
//  Created by Dan Dosch on 1/17/14.
//  Copyright (c) 2014 Dan Dosch. All rights reserved.
//

#import "TodoListViewController.h"
#import "TodoItemCell.h"
#import "TodoItem.h"
//#import “UIColor+PXExtenions.h”

@interface TodoListViewController ()

@property (strong, nonatomic) NSMutableArray *todoItemList;

- (void)addItem;
- (int)getNewTag;
- (int)indexOfItemWithTag:(int)tag;
- (TodoItem *)itemWithTag:(int)tag;

@end

@implementation TodoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.todoItemList = [TodoItem loadTodoItems];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.todoItemList = [TodoItem loadTodoItems];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.tableView.backgroundColor = [UIColor purpleColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoItemCell";
    TodoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TodoItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TodoItemCell"];
    }
    cell.todoItemTextField.delegate = self;
    
    if (indexPath.row % 2 == 0) {
        CGFloat red   = ((0x8467D7 & 0xFF0000) >> 16) / 255.0f;
        CGFloat green = ((0x8467D7 & 0x00FF00) >>  8) / 255.0f;
        CGFloat blue  =  (0x8467D7 & 0x0000FF) / 255.0f;
        cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    } else {
        CGFloat red   = ((0x9E7BFF & 0xFF0000) >> 16) / 255.0f;
        CGFloat green = ((0x9E7BFF & 0x00FF00) >>  8) / 255.0f;
        CGFloat blue  =  (0x9E7BFF & 0x0000FF) / 255.0f;
        cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    
    TodoItem *item = self.todoItemList[indexPath.row];
    cell.todoItemTextField.text = item.todoItemText;
    cell.todoItemTextField.tag = item.todoItemTag;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"edit called");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.todoItemList removeObjectAtIndex:indexPath.row];
        [TodoItem storeTodoItems:self.todoItemList];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSLog(@"This was called");
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
//    NSArray * arrayCells = [self.tableView cellForRowAtIndexPath:<#(NSIndexPath *)#>
//    self.todoItemList
    TodoItem *item = [self.todoItemList objectAtIndex:fromIndexPath.row];
    [self.todoItemList removeObjectAtIndex:fromIndexPath.row];
    [self.todoItemList insertObject:item atIndex:toIndexPath.row];
    [TodoItem storeTodoItems:self.todoItemList];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)addItem {
    [self.todoItemList addObject:[[TodoItem alloc]initWithString:@"Todo" tag:[self getNewTag]]];
    [TodoItem storeTodoItems:self.todoItemList];
    [self.tableView reloadData];
}

- (int)getNewTag {
    int newTag = 0;
    for (int i=0; i<self.todoItemList.count; i++) {
        TodoItem *item = self.todoItemList[i];
        newTag = MAX(newTag, item.todoItemTag)+1;
    }
    return newTag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn called");
    TodoItem *item = [self itemWithTag:textField.tag];
    if (item != nil) {
        NSLog(@"item is not nil");
        item.todoItemText = textField.text;
        [TodoItem storeTodoItems:self.todoItemList];
    }
    [self.view endEditing:YES];
    return YES;
}

- (int)indexOfItemWithTag:(int)tag {
    for (int i=0; i<self.todoItemList.count; i++) {
        TodoItem *item = self.todoItemList[i];
        if (tag == item.todoItemTag) {
            return i;
        }
    }
    return -1;
}

- (TodoItem *)itemWithTag:(int)tag {
    for (int i=0; i<self.todoItemList.count; i++) {
        TodoItem *item = self.todoItemList[i];
        NSLog(@"Checking %@", item);
        if (tag == item.todoItemTag) {
            return item;
        }
    }
    return nil;
}

@end

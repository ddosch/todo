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

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

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
    cell.todoCellTextView.delegate = self;
    
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
    cell.todoCellTextView.text = item.todoItemText;
    cell.todoCellTextView.tag = item.todoItemTag;
    
    [self textViewDidChange:cell.todoCellTextView];
    
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

//- (BOOL)textViewShouldReturn:(UITextView *)textView {
//    NSLog(@"textFieldShouldReturn called");
//    TodoItem *item = [self itemWithTag:textView.tag];
//    if (item != nil) {
//        NSLog(@"item is not nil");
//        item.todoItemText = textView.text;
//        [TodoItem storeTodoItems:self.todoItemList];
//    }
//    [self.view endEditing:YES];
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        
        TodoItem *item = [self itemWithTag:textView.tag];
        if (item != nil) {
            NSLog(@"item is not nil");
            item.todoItemText = textView.text;
            [TodoItem storeTodoItems:self.todoItemList];
        }
        
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TodoItem *item = self.todoItemList[indexPath.row];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0f] forKey: NSFontAttributeName];
    
    CGSize size = [item.todoItemText boundingRectWithSize:constraint options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:stringAttributes context:nil].size;
    
    
    NSLog(@"height = %f", size.height);
    CGFloat height = size.height;
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"Text view did change");
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

@end

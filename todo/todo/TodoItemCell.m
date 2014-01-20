//
//  TodoItemCell.m
//  todo
//
//  Created by Dan Dosch on 1/17/14.
//  Copyright (c) 2014 Dan Dosch. All rights reserved.
//

#import "TodoItemCell.h"

@implementation TodoItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
//{
//    float horizontalPadding = 24;
//    float verticalPadding = 16;
//    float widthOfTextView = textView.contentSize.width - horizontalPadding;
//    float height = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
//    
//    return height;
//}

@end

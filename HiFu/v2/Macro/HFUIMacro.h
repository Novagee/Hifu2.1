
#define SHADOW(view) \
CALayer *layer = view.layer;\
layer.bounds = view.bounds;\
layer.shadowColor = [UIColor blackColor].CGColor;\
layer.shadowOpacity = 0.5;\
layer.shadowRadius = 3.0;\
layer.shadowOffset = CGSizeMake(1,1);\
CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;\
view.layer.shadowPath = shadowPath;

#define SET_BORDER(view)\
view.layer.borderColor = [[UIColor whiteColor] CGColor];\
view.layer.borderWidth = 1;

#define SET_BORDER_GREY(view)\
view.layer.borderColor = [[UIColor lightGrayColor] CGColor];\
view.layer.borderWidth = 1;

#define SET_ROUNDED_CORNER(view)\
view.layer.cornerRadius = 2;

#define SET_NAVIGATION_BAR_BG_COLOR(view)\
view.backgroundColor = OS_BLUE_BUTTON;

#define SET_TEXTFIELD_TRANPARENT(view)\
[view setBackgroundColor:[UIColor clearColor]];

#define FontRegular @"Avenir"
#define FontHeavy @"Avenir-Heavy"

#define SETFont(label,fontName,fontSize)\
label.font = [UIFont fontWithName:fontName size:fontSize];

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HF_MAIN_COLOR [UIColor colorWithRed:1 green:0.39 blue:0.41 alpha:1]
#define HF_WHITE_COLOR [UIColor whiteColor]

#define USER_DEFAULTS [NSUserDefault standardUserDefaults]

#define LineSpace ([UIFont fontWithName:FontRegular size:8])

#define loginRedColor [UIColor colorWithRed:233/255.0f green:91/255.0f blue:106/255.0f alpha:1.0f]
#define loginGreyColor [UIColor colorWithRed:185/255.0f green:185/255.0f blue:185/255.0f alpha:1.0f]
#define loginLightGreyColor [UIColor colorWithRed:299/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f]

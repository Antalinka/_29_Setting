

#import <UIKit/UIKit.h>

@interface GRTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSMutableArray *collectionField;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pasSwitch;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;

- (IBAction)actionSwitch:(UISwitch *)sender;
- (IBAction)actionAgeSlider:(UISlider *)sender;
- (IBAction)actionChange:(id)sender;


@end

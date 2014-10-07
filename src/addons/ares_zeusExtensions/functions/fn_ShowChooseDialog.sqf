/*
	Displays a dialog that prompts the user to choose an option from a set of combo boxes.
	
	Params:
		0 - String - The title to display for the combo box.
		1 - Array of Arrays - The set of choices to display to the user. Each element in the array should be an array in the following format: ["Choice Description", ["Choice1", "Choice2", etc...]] optionally the last element can be a number that indicates which element to select. For example: ["Choose A Pie", ["Apple", "Pumpkin"], 1] will have "Pumpkin" selected by default.

	Returns:
		An array containing the indices of each of the values chosen, or an empty array ([]) if the user cancelled the dialog.
*/
disableSerialization;

_titleText = [_this, 0] call BIS_fnc_param;
_choicesArray = [_this, 1, [], [[]]] call BIS_fnc_param;

// Define some constants for us to use when laying things out.
#define GUI_GRID_X		(0)
#define GUI_GRID_Y		(0)
#define GUI_GRID_W		(0.025)
#define GUI_GRID_H		(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

#define BG_X					(1 * GUI_GRID_W + GUI_GRID_X)
#define BG_Y					(1 * GUI_GRID_H + GUI_GRID_Y)
#define BG_WIDTH				(38.5 * GUI_GRID_W)
#define TITLE_WIDTH				(14 * GUI_GRID_W)
#define TITLE_HEIGHT			(1.5 * GUI_GRID_H)
#define LABEL_COLUMN_X			(2 * GUI_GRID_W + GUI_GRID_X)
#define LABEL_WIDTH				(14 * GUI_GRID_W)
#define LABEL_HEIGHT			(1.5 * GUI_GRID_H)
#define COMBO_COLUMN_X			(17.5 * GUI_GRID_W + GUI_GRID_X)
#define COMBO_WIDTH				(21 * GUI_GRID_W)
#define COMBO_HEIGHT			(1.5 * GUI_GRID_H)
#define OK_BUTTON_X				(29.5 * GUI_GRID_W + GUI_GRID_X)
#define OK_BUTTON_WIDTH			(4 * GUI_GRID_W)
#define OK_BUTTON_HEIGHT		(1.5 * GUI_GRID_H)
#define CANCEL_BUTTON_X			(34 * GUI_GRID_W + GUI_GRID_X)
#define CANCEL_BUTTON_WIDTH		(4 * GUI_GRID_W)
#define CANCEL_BUTTON_HEIGHT	(1.5 * GUI_GRID_H)
#define TOTAL_ROW_HEIGHT		(2 * GUI_GRID_H)
#define BASE_IDC				(9000)

// Bring up the dialog frame we are going to add things to.
_createdDialogOk = createDialog "Ares_Dynamic_Dialog";
_dialog = findDisplay 133798;

// Create the BG and Frame
_background = _dialog ctrlCreate ["IGUIBack", BASE_IDC];
_background ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, 10 * GUI_GRID_H]; // TODO make this the right height
_background ctrlCommit 0;
/*_frame = _dialog ctrlCreate ["RscFrame", BASE_IDC + 1];
_frame ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, 100]; // TODO make this the right height
_frame ctrlCommit 0;*/

// Start placing controls 1 units down in the window.
_yCoord = BG_Y + (1 * GUI_GRID_H + GUI_GRID_Y);
_controlCount = 2;

if (_titleText != "") then
{
	// Create the label
	_labelControl = _dialog ctrlCreate ["RscText", BASE_IDC + _controlCount];
	_labelControl ctrlSetPosition [LABEL_COLUMN_X, _yCoord, TITLE_WIDTH, TITLE_HEIGHT];
	_labelControl ctrlCommit 0;
	_labelControl ctrlSetText _titleText;
	ctrlSetText [BASE_IDC + 2, "BAR"];
	_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
	_controlCount = _controlCount + 1;
};

{
	_choiceName = _x select 0;
	_choices = _x select 1;

	// Create the label for this entry
	_choiceLabel = _dialog ctrlCreate ["RscText", BASE_IDC + _controlCount];
	_choiceLabel ctrlSetPosition [LABEL_COLUMN_X, _yCoord, LABEL_WIDTH, LABEL_HEIGHT];
	_choiceLabel ctrlSetText _choiceName;
	_choiceLabel ctrlCommit 0;
	_controlCount = _controlCount + 1;
	
	// Create the combo box for this entry and populate it.
	_choiceCombo = _dialog ctrlCreate ["RscCombo", BASE_IDC + _controlCount];
	_choiceCombo ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
	_choiceCombo ctrlCommit 0;
	{
		_choiceCombo lbAdd _x;
	} forEach _choices;
	_choiceCombo lbSetCurSel 0; // TODO support setting this as part of the parameters
	_controlCount = _controlCount + 1;
	
	// Move onto the next row
	_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
} forEach _choicesArray;

// Create the Ok and Cancel buttons
_okButton = _dialog ctrlCreate ["RscButtonMenuOK", BASE_IDC + _controlCount];
_okButton ctrlSetPosition [OK_BUTTON_X, _yCoord, OK_BUTTON_WIDTH, OK_BUTTON_HEIGHT];
_okButton ctrlCommit 0;
_controlCount = _controlCount + 1;

_cancelButton = _dialog ctrlCreate ["RscButtonMenuCancel", BASE_IDC + _controlCount];
_cancelButton ctrlSetPosition [CANCEL_BUTTON_X, _yCoord, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT];
_cancelButton ctrlCommit 0;

waitUntil { !dialog };
_returnValue = [];
_returnValue;
